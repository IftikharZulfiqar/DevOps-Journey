#!/bin/bash

# AWS Profile Name
# echo "Enter your AWS profile name:"
# read profile

#profile="awsEngineer"

# Description
echo "Enter your EC2 Instance Name as input:"
read userName
#userName=Ali

# echo $userName
#If JQ is not installed Uncomment the below line.
#curl -L -o /usr/bin/jq.exe https://github.com/stedolan/jq/releases/latest/download/jq-win64.exe 

id=$(aws ec2 --profile default --region us-east-1 describe-instances --filters "Name=tag:Name,Values = $userName" --output text --query 'Reservations[*].Instances[*].InstanceId')
	# Display InstanceId 
    echo -e "\nModifying InstanceId: ${id}";
ebs=$(aws ec2 describe-volumes --region us-east-1 --filters "Name=attachment.instance-id,Values=$id" --output text --query 'Volumes[*].Attachments[*].VolumeId')
ebs2=$(aws ec2 describe-volumes --region us-east-1 --filters "Name=attachment.instance-id,Values=$id" --output json --query "Volumes[*].{ID:VolumeId,Tag:Tags,Size:Size,Type:VolumeType}")
echo $ebs2

echo "Enter the Volume Id from the above result that you want to modify"
read volId

echo "Enter the desire size"
read volSize

result=$(aws ec2 modify-volume --size $volSize --volume-id $volId --output json)
echo $result
