import boto3
from boto3.dynamodb.conditions import Key, Attr
import json


def getTableDetails(sysname):
    TABLE_NAME = "TagHormonization"
    dynamodb = boto3.resource('dynamodb', region_name="us-east-1")
    table = dynamodb.Table(TABLE_NAME)
    response = table.scan(
        FilterExpression=Attr('SysName').eq(sysname)
    )
    if 'Items' in response:
        return response['Items']

    else:
        return 'nope'


def getTags(serviceList):
    client = boto3.client('resourcegroupstaggingapi', 'us-east-1')
    nextToken = ''
    responseList = []
    while True:
        response = client.get_resources(
            TagFilters=[{
                'Key': 'ManagedBy',
                'Values': [
                    'CloudOps',
                ]}, ],
            PaginationToken=nextToken,
            ResourceTypeFilters=serviceList,
        )
        responseList += response['ResourceTagMappingList']
        if ('PaginationToken' in response) and (response['PaginationToken'] != ''):
            nextToken = response['PaginationToken']
        else:
            # print("Done")
            break
    return responseList


def updateTags(resourceARN, TagsObj):
    try:
        client = boto3.client('resourcegroupstaggingapi', "us-east-1")
        response = client.tag_resources(
            ResourceARNList=[resourceARN, ], Tags=TagsObj)
    except Exception as error:
        print("Exception: ", error)


def lambda_handler():
    sqsTagHarmClient = boto3.client('sqs', region_name="us-east-1")
    sqsUrl = sqsTagHarmClient.get_queue_url(QueueName='sqs-Tag-Harm')['QueueUrl']
    ResourceType = ['ec2:instance', 'ec2:volume', 's3']
    TagList = getTags(ResourceType)
    for resource in TagList:
        resourceARN = resource['ResourceARN']
        TagsObj = {}
        for tag in resource['Tags']:
            if tag['Key'] == 'ManagedBy' and str(tag['Value']).lower() == 'CloudOps':
                CloudOps = True
            elif tag['Key'] == 'SysName':
                SysName = tag['Value']
                DBTbldata = getTableDetails(SysName)
                for DBdata in DBTbldata:
                    lstKeys = list(DBdata.keys())
                for resourcetag in resource['Tags']:
                    if (resourcetag['Key'] in lstKeys):
                        dbTagValue = DBdata.get(resourcetag['Key'])
                        lstKeys.remove(resourcetag['Key'])
                        if (resourcetag['Value'] != dbTagValue):
                            TagsObj[resourcetag['Key']] = dbTagValue
                if len(lstKeys) > 0:
                    for i in range(len(lstKeys)):
                        TagsObj[lstKeys[i]] = DBdata.get(lstKeys[i])
                    print(TagsObj)
                    updateTags(resourceARN, TagsObj)
                if bool(TagsObj):
                    TagsObj['resourceARN'] = resourceARN
                    print("The Tag OBj", TagsObj)
                    jsonObjSQSMessage = json.dumps(TagsObj)
                    msg = sqsTagHarmClient.send_message(QueueUrl=sqsUrl, MessageBody=jsonObjSQSMessage)


lambda_handler()
