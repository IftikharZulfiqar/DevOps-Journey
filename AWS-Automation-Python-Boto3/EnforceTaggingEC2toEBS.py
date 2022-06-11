import boto3

#This code will Tags the EBS volume,  same as tags attached with EC2 instances. 
#This will work for multiple instances and with the attached volumes.
#Make sure you have configured CLI and User have approperiate IAM access 

def add_tags_ec2_to_ebs():
    ebs_tags = []
    ec2_client = boto3.client("ec2", "us-east-1")
    reservations = ec2_client.describe_instances(Filters=[
        {
            "Name": "instance-state-name",
            "Values": ["running"],
        }
    ]).get("Reservations")
    for reservation in reservations:
        for instance in reservation["Instances"]:
            ec2_tags = (instance['Tags'])
            volumes = ec2_client.describe_volumes(
                Filters=[{'Name': 'attachment.instance-id', 'Values': [instance['InstanceId']]}]
            )
            for disk in volumes['Volumes']:
                vol_id = str(disk['VolumeId'])
                if 'Tags' in disk:
                    ebs_tags = (disk['Tags'])
                for tags in ec2_tags:
                    if tags not in ebs_tags:
                        ebs_tags.append({'Key': tags['Key'].strip(), 'Value': tags['Value'].strip()})
                response = ec2_client.create_tags(
                    Resources=[vol_id],
                    Tags=ebs_tags
                )
                ebs_tags = []
            ec2_tags = []


add_tags_ec2_to_ebs()
