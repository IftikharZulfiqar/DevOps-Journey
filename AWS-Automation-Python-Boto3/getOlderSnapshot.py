import boto3
from datetime import datetime, timezone
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
import csv

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
        <p style="font-size:18px;">Please find the attached Snapshots report.</p>
        <p style="font-size:18px;">Sincerely,<br>Cloud Governance - Automation</p>
        """
    part1 = MIMEText(BODY_HTML, 'html')
    msg_body.attach(part1)
    attachfile = "/tmp/ec2-snapshot_details.csv"
    print("Attachment file :" + attachfile)
    att = MIMEApplication(open(attachfile, 'rb').read())
    att.add_header('Content-Disposition', 'attachment', filename="ec2-snapshot_details.csv")
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
    result=[]
    ec2_client = boto3.client('ec2')
    snapshot_response = ec2_client.describe_snapshots(OwnerIds=['self'])
    for snapshot in snapshot_response['Snapshots']:
        days_old = (datetime.now(timezone.utc) - snapshot['StartTime']).days
        if (days_old >= 30):
            try:
                # TODO: write code...
                volume_response = ec2_client.describe_volumes(VolumeIds=[snapshot['VolumeId']])
                volume = volume_response['Volumes'][0]
                for attachment in volume['Attachments']:
                    result.append([
                        days_old,
                        snapshot['SnapshotId'],
                        snapshot['VolumeId'],
                        snapshot['VolumeSize'],
                        volume['VolumeType'],
                        attachment['InstanceId'],
                    ])
            except Exception as e:
                print(e)
                result.append([
                        days_old,
                        snapshot['SnapshotId'],
                        snapshot['VolumeId'],
                        snapshot['VolumeSize'],
                ])
            
            # print(result)        
    
    header = ['Aging Days','Snapshot Id', 'Volume Id','Volume Size','VolumeType','InstanceId','Delete Y|N', 'Justification']
    with open('/tmp/ec2-snapshot_details.csv', 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        for row in result:
            writer.writerow(row)
            
    file.close()
    sendEmail()