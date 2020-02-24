import boto3
import sys
import time

ec2_client = boto3.client('ec2')
action = sys.argv[1]
instance_list = [sys.argv[2]]

# Manage all instances
def manage_instance(list_of_instances: list, action: str):

    if action == 'start':
        response = ec2_client.start_instances(
            InstanceIds= list_of_instances
        )

        state = is_running(list_of_instances[0])

        if state:
            print(f"${list_of_instances[0]} is started and initialized!")
            return state
        else:
            print(f"${list_of_instances[0]} is NOT started! Check console.")
            return state

    elif action == 'stop':
        response = ec2_client.stop_instances(
            InstanceIds = list_of_instances
        )

        state = is_stopped(list_of_instances[0])

        if state:
            print(f"${list_of_instances[0]} is stopped!")
            return state
        else:
            print(f"${list_of_instances[0]} is NOT stopped! Check console.")
            return state

    else:
        return 'Invalid action'

    return

# Running vs stopped
def get_instance_status(instance_id):
    response = ec2_client.describe_instance_status(
        InstanceIds=[instance_id]
    )
    for instance in response['InstanceStatuses']:
        if instance['InstanceId'] == instance_id:
            return instance['InstanceState']['Name']

# Initialized or not
def get_instance_state(instance_id):
    response = ec2_client.describe_instance_status(
        InstanceIds=[instance_id]
    )
    for instance in response['InstanceStatuses']:
        if instance['InstanceId'] == instance_id:
            return instance['InstanceStatus']['Details'][0]['Status']


def is_running(instance_id):
    for x in range(5):
        status = get_instance_status(instance_id)
        if status == 'running':
            state = get_instance_state(instance_id)
            for x in range(5):
                if state == 'passed':
                    return True
                time.sleep(20)
        time.sleep(20)
    return False


def is_stopped(instance_id):
    for x in range(5):
        response = ec2_client.describe_instance_status(
            InstanceIds=[instance_id]
        )
        status = response['InstanceStatuses']
        if status == []:
            return True
        time.sleep(20)
    return False

manage_instance(instance_list, action)
