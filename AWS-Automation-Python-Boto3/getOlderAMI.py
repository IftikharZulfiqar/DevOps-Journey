import datetime
from datetime import date
from datetime import datetime
import csv
import boto3


#Make sure you have configured CLI and User have approperiate IAM access 
ec2 = boto3.client('ec2')
instances = ec2.describe_instances()

def lambda_handler(event, context):
    images = ec2.describe_images(
        Filters=[
            {
                'Name': 'state',
                'Values': ['available']
            },
        ],
        Owners=['self'],
    )
    today = str(date.today())
    
    result = []
    for image in images['Images']:
        date1 = image['CreationDate']
        d1 = datetime.strptime(date1, "%Y-%m-%dT%H:%M:%S.%fZ")
        d2 = datetime.strptime(today, "%Y-%m-%d")
        difference = abs((d2 - d1).days)
        
        if(difference >= 90):
            print()
            # print(difference)
            # print(image['ImageId'])
        
            result.append([
                difference,
                image['ImageId'],
            ])
        # print(result)
    header = ['Aging Days','ImageId', 'Delete Y|N', 'Justification']
    with open('/tmp/ec2-AMI_details.csv', 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        for row in result:
            writer.writerow(row)
            
    file.close()