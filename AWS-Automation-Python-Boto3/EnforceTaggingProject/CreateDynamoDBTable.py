import boto3


def createTable():
    client = boto3.client('dynamodb', 'us-east-1')
    response = client.create_table(
        AttributeDefinitions=[
            {
                'AttributeName': 'SysName',
                'AttributeType': 'S',
            },

            {
                'AttributeName': 'TSM',
                'AttributeType': 'S',
            },

        ],
        KeySchema=[
            {
                'AttributeName': 'SysName',
                'KeyType': 'HASH',
            },
            {
                'AttributeName': 'TSM',
                'KeyType': 'RANGE',
            },

        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5,
        },
        TableName='TagHormonization',
    )
