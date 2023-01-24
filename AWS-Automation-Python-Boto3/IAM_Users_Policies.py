import boto3
import csv

client = boto3.client("iam")
users = client.list_users()
user_list = []
keyValue=[]
for key in users['Users']:
    result = {}
    Policies = []
    ManagedPolicies = []
    Groups=[]
    # List of users
    result['userName']=key['UserName']
    # List of inline policies attahed to users
    List_of_Policies =  client.list_user_policies(UserName=key['UserName'])
    result['Policies'] = List_of_Policies['PolicyNames']
    #List of managed Ploicies
    managed_user_policies = client.list_attached_user_policies(UserName=key['UserName'])
    if (len(managed_user_policies )>0):
        for policy in managed_user_policies['AttachedPolicies']:
            ManagedPolicies.append(policy['PolicyName'])
            # print(policy['PolicyName'])
        result['ManagedPolicies']=ManagedPolicies

    List_of_Groups =  client.list_groups_for_user(UserName=key['UserName'])

    for Group in List_of_Groups['Groups']:
        Groups.append(Group['GroupName'])
    result['Groups'] = Groups

    List_of_MFA_Devices = client.list_mfa_devices(UserName=key['UserName'])

    if not len(List_of_MFA_Devices['MFADevices']):
        result['isMFADeviceConfigured']=False   
    else:
        result['isMFADeviceConfigured']=True    
    user_list.append(result)

for key in user_list:
        keyValue.append({
                'userName': key['userName'],
                'Policies': key['Policies'], 
                'ManagedPolicies': key['ManagedPolicies'],
                'Groups': key['Groups'] ,
                'isMFADeviceConfigured': key['isMFADeviceConfigured'],          
            })

header = ['userName', 'Policies','ManagedPolicies','Groups','isMFADeviceConfigured']
with open('IAM-details.csv', 'w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=header)
    writer.writeheader()
    writer.writerows(keyValue)
