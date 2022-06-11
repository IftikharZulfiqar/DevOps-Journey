import boto3
import csv
import json


def create_queue():
    sqs_client = boto3.client("sqs", 'us-east-1')
    response = sqs_client.create_queue(
        QueueName="sqs-Tag-Harm",
        Attributes={
            "DelaySeconds": "0",
            "VisibilityTimeout": "60",
        }
    )
    print(response)


def retrieve_messages():
    msg = []
    messages_to_delete = []
    header = ["AWSAccount", "resourceARN", "SysName", "ManagedBy", "TSM", "CostCenter", "BU", "PHI"]
    sqsTagHarmClient = boto3.client('sqs', region_name="us-east-1")
    sqsUrl = sqsTagHarmClient.get_queue_url(QueueName='sqs-Tag-Harm')['QueueUrl']
    response = sqsTagHarmClient.receive_message(QueueUrl=sqsUrl, MaxNumberOfMessages=1)
    with open('Tag-Harm.csv', 'w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=header)
        writer.writeheader()
        for msg in response.get("Messages", []):
            message_body = (msg['Body'])
            print(message_body)
            msgBodyDist = json.loads(message_body)
            if (msgBodyDist):
                writer.writerow(msgBodyDist)
            # Delete received message from queue
            receipt_handle = msg['ReceiptHandle']
            print(receipt_handle)
            messages_to_delete.append(receipt_handle)
            sqsTagHarmClient.delete_message(
                QueueUrl=sqsUrl,
                ReceiptHandle=receipt_handle
            )



