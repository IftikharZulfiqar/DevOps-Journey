import boto3
import csv


# Function that will check the state of ec2 instance if it is stopped state it will start it and vice versa
# Append the result in CSV
def ec2StateChangeStartStop():
    result = []
    ec2_client = boto3.client("ec2", "us-east-1")
    reservations = ec2_client.describe_instances()['Reservations']
    for reservation in reservations:
        result_dic = {}
        for instance in reservation["Instances"]:
            instance_ID = instance['InstanceId']
            # result_dic['instanceID'] = instance['InstanceId']
            # result_dic['state']= instance['State']['Name']
            result_dic = {
                'instanceID': instance['InstanceId'],
                'state': instance['State']['Name'],

            }
            if result_dic['state'] == 'running':
                ec2_client.stop_instances(InstanceIds=[
                    instance_ID],
                    Force=True
                )
                result_dic['UpdatedState'] = 'stopped'
            else:
                ec2_client.start_instances(InstanceIds=[instance_ID])
                result_dic['UpdatedState'] = 'running'

        result.append(result_dic)

    header = ['instanceID', 'state', 'UpdatedState']
    with open('ec2-details.csv', 'w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=header)
        writer.writeheader()
        writer.writerows(result)
