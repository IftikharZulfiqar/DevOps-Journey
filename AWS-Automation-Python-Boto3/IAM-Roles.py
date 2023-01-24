import boto3
import csv

result = []
client = boto3.client("iam")
roles = []
response = client.list_roles()
roles.extend(response['Roles'])
while 'Marker' in response.keys():
    response = client.list_roles(Marker = response['Marker'])
    roles.extend(response['Roles'])

print('roles found: ' + str(len(roles)))  
for role in roles:
    result.append({
                'RoleName': role['RoleName'],
                'Arn': role['Arn'],                
            })
print(result)

header = ['RoleName', 'Arn']
with open('IAM-details.csv', 'w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=header)
    writer.writeheader()
    writer.writerows(result)
