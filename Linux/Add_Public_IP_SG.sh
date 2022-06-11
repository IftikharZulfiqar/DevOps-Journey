#!/bin/bash

<<comment

The script is working like as:

•	Filtering Instance by Name
•	Filtering Security Group by Description
•	Checking If Public IP exists or not 
•	Removing the existing Public IP
•	Adding the updated Public IP

Need to define the "AWS profile" and "user name" whose user's security group we are modifying.  
The script first filters on the basis of the description “includes (Only Username)” and will find the CIDR/Public IP. 
If Public IP against the user already exists, It will first remove it from the security group, and then add the new Public IP accordingly. 
If user are trying to add the same public IP again, it will not be allowed. I have added the filter for it as well. 

comment


# AWS Profile Name
echo "Enter your AWS profile name:"
read profile

#profile="awsEngineer"

# Port
port=22;

# Description
echo "Enter your user name for description check:"
read userName
#userName=Ali

#If JQ is not installed Uncomment the below line.
#curl -L -o /usr/bin/jq.exe https://github.com/stedolan/jq/releases/latest/download/jq-win64.exe 

id=$(aws ec2 --profile $profile --region us-east-1 describe-instances --filters 'Name=tag:Name,Values=*Server*' --output text --query 'Reservations[*].Instances[*].InstanceId')
	# Display InstanceId 
    echo -e "\nModifying InstanceId: ${id}";
	
group_id=$(aws ec2 --profile $profile --region us-east-1 describe-instances --instance-id $id --query "Reservations[].Instances[].SecurityGroups[].GroupId[]" --output text)

    # Display group name
    echo -e "\nModifying Group: ${group_id}";
	
	# Define cidrIP and describe rules that match the conditions
	cidrIP=`aws ec2 --profile $profile --region us-east-1 describe-security-groups --group-ids $group_id | jq -r '.SecurityGroups[0].IpPermissions[] | select(.ToPort=='$port') | .IpRanges[] | select(.Description == "'$userName'") | .CidrIp' | tail -1f`
	echo -e "\nCIDR IP $cidrIP"
	
		if [ -n "${cidrIP}" ]; then
			aws ec2 --profile $profile --region us-east-1 revoke-security-group-ingress --group-id $group_id --ip-permissions '[{"IpProtocol": "tcp", "FromPort": '$port', "ToPort": '$port', "IpRanges": [{"CidrIp":"'$cidrIP'"}]}]'
		fi
		
    # Get current public IP address
    myip=$(curl -s https://api.ipify.org);

    echo -e "Setting Current IP: ${myip}"
	result=$(aws ec2 --profile $profile --region us-east-1 describe-security-groups --group-ids ${group_id}\
    --filters Name=ip-permission.from-port,Values=$port Name=ip-permission.to-port,Values=$port Name=ip-permission.cidr,Values=${myip}/32 \
    --output text --query "SecurityGroups[*].[GroupId]")
	if [ "$result" = "$group_id" ]
	then
		#If they are equal then print this
		echo "$myip is already in $group_id"
	else
    # Add current IP as new rule
    #aws ec2 authorize-security-group-ingress --profile=$profile --protocol tcp --port $port --cidr ${myip}/32 --group-id $group_id
	aws ec2 --profile=$profile --region us-east-1 authorize-security-group-ingress --group-id $group_id --ip-permissions IpProtocol=tcp,FromPort=$port,ToPort=$port,IpRanges="[{CidrIp = ${myip}/32,Description='$userName'}]"					
	echo "$myip is added"
	fi
	
	
