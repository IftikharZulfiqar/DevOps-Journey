import boto3
import csv


def ec2DataToCSV():
    result = []
    ec2_client = boto3.client("ec2", "us-east-1")
    reservations = ec2_client.describe_instances()["Reservations"]

    for reservation in reservations:
        for instance in reservation["Instances"]:
            result.append({
                'ImageId': instance['ImageId'],
                'InstanceType': instance['InstanceType'],
                'PrivateIp': instance['PrivateIpAddress'],
            })
    print(result)

    header = ['ImageId', 'InstanceType', 'PublicIp', 'PrivateIp']
    with open('ec2-details.csv', 'w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=header)
        writer.writeheader()
        writer.writerows(result)
