import subprocess
import json
import shlex
from datetime import datetime, timedelta, timezone

def run_gcloud_command(command, raw_output=False):
    """Runs a gcloud command and returns the parsed JSON output or raw output."""
    try:
        # print(f"Running command: {command}")
        process = subprocess.run(shlex.split(command), capture_output=True, text=True, check=True)
        if raw_output:
            return process.stdout.strip()
        try:
            return json.loads(process.stdout)
        except json.JSONDecodeError:
            print(f"Warning: gcloud output for '{command}' was not valid JSON.")
            return process.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running gcloud command: {command}")
        print(f"Stderr: {e.stderr}")
        return None

def get_time_filter(lookback_minutes):
    """Generates a log filter string for the given lookback minutes."""
    if lookback_minutes > 0:
        start_time = (datetime.now(timezone.utc) - timedelta(minutes=lookback_minutes)).strftime('%Y-%m-%dT%H:%M:%SZ')
        return f'timestamp >= "{start_time}"'
    return "timestamp > 0"

def save_json_to_file(data, filename):
    """Saves data to a JSON file."""
    try:
        with open(filename, 'w') as f:
            json.dump(data, f, indent=2)
        print(f"Successfully saved {len(data)} items to {filename}")
        return True
    except Exception as e:
        print(f"Error saving to file {filename}: {e}")
        return False

def _get_conv_id_from_logs(project_id, call_id, time_filter, call_id_parameter):
    """Tries to get the DF Conv ID from runtime logs."""
    print(f"--- Method 1: Trying to find DF Conv ID for Call ID {call_id} in logs using parameter '{call_id_parameter}' ---")
    call_id_query_filter = f'''
    logName="projects/{project_id}/logs/dialogflow-runtime.googleapis.com%2Frequests"
    AND jsonPayload.queryResult.parameters.{call_id_parameter}="{call_id}"
    AND {time_filter}
    '''
    call_id_query_filter = " ".join(call_id_query_filter.split())

    gcloud_command = f"gcloud logging read '{call_id_query_filter}' --project {project_id} --format=\"value(labels.session_id)\" --limit=1"
    conversation_id = run_gcloud_command(gcloud_command, raw_output=True)
    return conversation_id

def _get_conv_id_from_insights(project_id, call_id):
    """Tries to get the DF Conv ID from CCAI Insights API."""
    print(f"--- Method 2: Trying to find DF Conv ID for Call ID {call_id} via Insights API ---")
    try:
        location = "us-central1"  # Assuming us-central1
        api_endpoint = f"https://contactcenterinsights.googleapis.com/v1/projects/{project_id}/locations/{location}/conversations"
        conversation_name_suffix = f"/{call_id}"

        token_process = subprocess.run(["gcloud", "auth", "print-access-token"], capture_output=True, text=True, check=True)
        token = token_process.stdout.strip()

        curl_command = shlex.split(f"curl -X GET -H 'Authorization: Bearer {token}' -H 'Content-Type: application/json' {api_endpoint}")

        print(f"--- Querying Insights API: {api_endpoint} ---")
        process = subprocess.Popen(curl_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        stdout, stderr = process.communicate()

        if process.returncode != 0:
            print(f"Insights API call failed for {call_id}:")
            print(stderr)
            return None

        if not stdout.strip():
            print(f"Insights API returned no data for {call_id}.")
            return None

        data = json.loads(stdout)
        conversations = data.get("conversations", [])

        for conv in conversations:
            if conv.get("name", "").endswith(conversation_name_suffix):
                labels = conv.get("labels", {})
                df_conv_id = labels.get("dialogflow_conversation_id_1")
                if df_conv_id:
                    return df_conv_id
                else:
                    print(f"Found conversation for {call_id}, but 'dialogflow_conversation_id_1' label is missing.")
                    return None

        print(f"No conversation found in Insights for Call ID: {call_id}")
        return None

    except subprocess.CalledProcessError as e:
        print(f"Error getting gcloud token for Insights: {e}")
        return None
    except Exception as e:
        print(f"An error occurred during Insights API call: {e}")
        return None

def get_dialogflow_conversation_id(virtual_agent_project_id, call_id, lookback_minutes, call_id_parameter='call_id', insights_project_id=None):
    """Gets the Dialogflow Conversation ID for a given Call ID.
       Tries runtime logs first, then falls back to CCAI Insights API.
    """
    time_filter = get_time_filter(lookback_minutes)

    # Method 1: From Dialogflow runtime logs
    conversation_id = _get_conv_id_from_logs(virtual_agent_project_id, call_id, time_filter, call_id_parameter)
    if conversation_id:
        print(f"Found Conversation ID via logs: {conversation_id}")
        return conversation_id
    else:
        print(f"Could not find Conversation ID via logs for {call_id}.")

    # Method 2: From CCAI Insights API
    insights_project = insights_project_id if insights_project_id else virtual_agent_project_id
    conversation_id = _get_conv_id_from_insights(insights_project, call_id)
    if conversation_id:
        print(f"Found Conversation ID via Insights: {conversation_id}")
        return conversation_id
    else:
        print(f"Could not find Conversation ID via Insights for {call_id}.")

    return None
