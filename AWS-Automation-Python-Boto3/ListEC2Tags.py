import boto3

AWS_REGION = "us-east-1"
EC2_RESOURCE = boto3.resource('ec2', region_name=AWS_REGION)
ec2_resource = boto3.client('ec2', 'us-east-1')
INSTANCE_ID = str(ec2_resource.describe_instances()["Reservations"][0]["Instances"][0]["InstanceId"])

instances = EC2_RESOURCE.instances.filter(
    InstanceIds=[
        INSTANCE_ID
    ]
)

for instance in instances:
    print(f'EC2 instance {instance.id} tags:')

    if len(instance.tags) > 0:
        for tag in instance.tags:
            print(f'{tag["Key"]}={tag["Value"]}')
    else:
        print(f'  - No Tags')
