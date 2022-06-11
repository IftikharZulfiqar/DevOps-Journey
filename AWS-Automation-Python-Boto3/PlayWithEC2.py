import boto3


def create_ec2_instance():
    try:
        resource_ec2 = boto3.client("ec2", region_name='us-east-1')
        resource_ec2.run_instances(
            ImageId="ami-0a8b4cd432b1c3063",
            MinCount=1,
            MaxCount=1,
            InstanceType="t2.micro",
            TagSpecifications=[
                {
                    'ResourceType': 'instance',
                    'Tags': [
                        {
                            'Key': 'Name',
                            'Value': 'iftikhar-ec2-instance'
                        },
                    ]
                },
            ]
        )
    except Exception as e:
        print(e)


def describe_ec2_instance():
    resource_ec2 = boto3.client("ec2", region_name='us-east-1')
    return str(resource_ec2.describe_instances()["Reservations"][2]["Instances"][0]["InstanceId"])


def stop_ec2_instance():
    try:
        print("Stop EC2 instance")
        instance_id = describe_ec2_instance()
        resource_ec2 = boto3.client("ec2", region_name='us-east-1')
        print(resource_ec2.stop_instances(InstanceIds=[
            instance_id],
            Force=True
        ))
    except Exception as e:
        print(e)


def ec2_state():
    resource_ec2 = boto3.client("ec2", region_name='us-east-1')
    INSTANCE_STATE = 'stopped'

    instances = resource_ec2.instances.filter(
        Filters=[
            {
                'Name': 'instance-state-name',
                'Values': [
                    INSTANCE_STATE
                ]
            }
        ]
    )

    print(f'Instances in state "{INSTANCE_STATE}":')

    for instance in instances:
        print(f'  - Instance ID: {instance.id, instance.instance_type}')


def start_ec2_instance():
    try:
        print("Start EC2 instance")
        instance_id = describe_ec2_instance()
        sess = boto3.Session(region_name='us-east-1')
        resource_ec2 = sess.client("ec2")
        print(resource_ec2.start_instances(InstanceIds=[instance_id]))
    except Exception as e:
        print(e)


def terminate_ec2_instance():
    try:
        print("Terminate EC2 instance")
        instance_id = describe_ec2_instance()
        resource_ec2 = boto3.client("ec2", region_name='us-east-1')
        print(resource_ec2.terminate_instances(InstanceIds=[instance_id]))
    except Exception as e:
        print(e)

# create_ec2_instance()
# describe_ec2_instance()
# stop_ec2_instance()
# ec2_state()
# start_ec2_instance()
# terminate_ec2_instance()
