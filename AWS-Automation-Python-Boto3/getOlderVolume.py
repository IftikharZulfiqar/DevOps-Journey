import datetime
import pytz
import csv
import boto3
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication

#Make sure you have configured CLI and User have approperiate IAM access 
def sendEmail():
    SUBJECT = 'Daily Volume Inventory Report'
    SENDER = "iftikharzulfiqar6@gmail.com"
    recipientEmailList = ['iftikharzulfiqar6@gmail.com']
    # configure the client for SES Service
    ses_client = boto3.client('ses', region_name='us-east-1')
    msg = MIMEMultipart('mixed')
    # Add subject, from and to lines.
    msg['Subject'] = SUBJECT
    msg['From'] = SENDER
    msg['To'] = "iftikharzulfiqar6@gmail.com"
    msg['CC'] = ", ".join(recipientEmailList)
    # Create a multipart/alternative child container.
    msg_body = MIMEMultipart('alternative')
    recipientEmailList.append('iftikharzulfiqar6@gmail.com')
    BODY_HTML = """
        <p style="font-size:18px;">Hello Team,</p>
        <p style="font-size:18px;">Please find the attached Volume report.</p>
        <p style="font-size:18px;">Sincerely,<br>Cloud Governance - Automation</p>
        """
    part1 = MIMEText(BODY_HTML, 'html')
    msg_body.attach(part1)
    attachfile = "/tmp/ec2-AMI_details.csv"
    print("Attachment file :" + attachfile)
    att = MIMEApplication(open(attachfile, 'rb').read())
    att.add_header('Content-Disposition', 'attachment', filename="ec2-AMI_details.csv")
    msg.attach(msg_body)
    msg.attach(att)
    response = ses_client.send_raw_email(
        Source=SENDER,
        Destinations=recipientEmailList,
        RawMessage={
            'Data': msg.as_string(),
        }
        )
    print("Email sent! Message ID:"),
    print(response['MessageId'])

def lambda_handler(event, context):
    result = []
    ec2_client = boto3.client('ec2', region_name='us-east-1')
    # print(available_vol_response)
    available_vol_response = ec2_client.describe_volumes(Filters=[
        {
            'Name': 'status',
            'Values': [
                'available',
            ]
        },
    ], )
    # print(older_threshold_time)
    older_threshold_time = datetime.datetime.now() - datetime.timedelta(days=30)
    older_threshold_time = pytz.utc.localize(older_threshold_time)    
    # get the required data field
    for volume_info in available_vol_response['Volumes']:
        if volume_info['CreateTime'] < older_threshold_time:
           print(volume_info['VolumeId'])
        result.append([
            volume_info['AvailabilityZone'],
            volume_info['VolumeId'],
            volume_info['VolumeType'],
            volume_info['Size'],
            volume_info['CreateTime'],
            volume_info['State'],

        ])
    # Make a CSV File    
    header = ['Availability Zone', 'Volume ID', 'VolumeType', 'Volume Size', 'Create Time', 'Volume state', 'Delete Y|N', 'Justification']
    with open('/tmp/ec2-Vol_details.csv', 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        for row in result:
            writer.writerow(row)
            
    file.close()
    Email.sendEmail()
    