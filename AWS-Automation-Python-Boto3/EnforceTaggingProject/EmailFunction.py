import boto3
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


def send_email_with_attachment():
    msg = MIMEMultipart()
    msg["Subject"] = "This is an email with an attachment!"
    msg["From"] = "iftikharzulfiqar6@gmail.com"
    msg["To"] = "iftikharzulfiqar6@gmail.com"

    # Set message body
    body = MIMEText("Hello, world!", "plain")
    msg.attach(body)

    filename = "Tag-Harm.csv"  # In same directory as script

    with open(filename, "rb") as attachment:
        part = MIMEApplication(attachment.read())
        part.add_header("Content-Disposition",
                        "attachment",
                        filename=filename)
    msg.attach(part)

    # Convert message to string and send
    ses_client = boto3.client("ses", region_name="us-east-1")
    response = ses_client.send_raw_email(
        Source="iftikharzulfiqar6@gmail.com",
        Destinations=["iftikharzulfiqar6@gmail.com"],
        RawMessage={"Data": msg.as_string()}
    )
    print(response)


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
    attachfile = "/tmp/ec2-Vol_details.csv"
    print("Attachment file :" + attachfile)
    att = MIMEApplication(open(attachfile, 'rb').read())
    att.add_header('Content-Disposition', 'attachment', filename="ec2-Vol_details.csv")
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
