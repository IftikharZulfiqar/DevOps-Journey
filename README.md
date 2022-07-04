# DevOps-Journey
The journey toward the DevOps…

Lets start with the DevOps/SysOps Journey.  

GitHub Repo Link: https://github.com/IftikharZulfiqar/DevOps-Journey

# Linux Essentials: 
First of all, knowledge of Linux and Windows administrations is of vital importance. Particularly, Linux is highly crucial and it is used in every step of the DevOps path. 

I started with Linux and covered the topics of Linux Fundamental, Linux Architecture, Linux Administrations, Linux Networking, and Linux Shell Script.

You should also be well-versed in the following areas:
Disk Management, File Permission, Access Control Lists (ACL), Searching, File Commands, User Management, Networking, SSH Login, and File transfer.

Knowledge without practice is useless. Practice makes a person perfect, or at least takes a person close to a significantly reliable output. As practice, I have worked on the following scripts:
1.	Add Public IP to Security Group
This script checks the Public IP rule in Security Groups (SGs) of EC2 instances by a specified filter and if the IP does not exist in SG, it will add the public IP.
2.	Admin Access to User
This script provides admin access to the user. Add the user in sudoers files. So that the user can perform the tasks such as root user can do. 
3.	Get Local Users
This script finds the local users and lists all normal user and system accounts in the system.
4.	LAMP
Installation of Apache, MySQL, and PHP in the Linux machine.  
5.	Prometheus agent installation
Installation according to the working environment  
6.	Update the Security group of EC2 instance
If the IP already exists, it will delete it first and then add the rule in SG. 
7.	Disk Management
Mounting the Disk, Resizing the Disk, and NFS Mounting.

This is not the end of Linux, and we can add more knowledge to it once we are in a professional environment.
Following are a few helpful links:
- Linux Fundamentals:  https://www.edx.org/course/introduction-to-linux
- Bash Script Tutorial: https://www.youtube.com/watch?v=e7BufAVwDiM&ab

A separate folder in the git hub repository has been added along with all the relevant data. You can also find the E-Books and practical examples.  

# Networking Essentials:
The next topic is Networking. It is one of the most important pillars to continuing this Journey. Knowing VPC and its components is very helpful in designing cloud architecture and solutions. Knowledge of the following topics is essential.

VPC Components:
-	Subnets 
-	Elastic Network Interfaces 
-	Route Tables 
-	Internet Gateways 
-	Elastic Ip Addresses 
-	Vpc Endpoints 
-	Nat 
-	VPC Peering 
-	VPC Security (Security Groups)
-	Disaster Recovery 
-	VPC Flow Logs
-	VPC Access Control List

I have used all these components within the AWS Cloud Platform. Designed and Implemented solutions that are High available and secure.

I have added the Network folder in the repository and shared the AWS Security and Linux Networking E-Book as a guide. 
- Helpful Link:
https://www.youtube.com/watch?v=rv3QK2UquxM&ab

# Knowledge of YAML/JSON
The next stop is YAML. We can take help from the open-source community to learn YAML. I also take help from YouTube and some Udemy-based tutorials. 

One link is mentioned below for a quick start.
- https://www.youtube.com/watch?v=1uFVr15xDGg&ab

As I am working in AWS Cloud and my resource is CloudFormation. CloudFormation is a JSON-and-YAML-based Infrastructure as a code service.  I had provisioned EC2, ELB, S3, Lambda, SQS, SNS, IAM roles, ALB, Lambda, and many AWS services using YAML.

I have added the YAML folder in my Repo and shared some templates like:
1.	AWS Application Load Balancer Provisioning 
2.	AWS IAM Role Creation 
3.	AWS EC2 Provisioning with Elastic IP
4.	AWS Elastic File System Provisioning 
5.	Access of S3 to EC2 Instance
6.	AWS SNS Provisioning

# Git Essentials
Now let us move on toward the GIT. Git is very essential and it is used in every professional project and every software developer must have a fundamental knowledge of it. My expertise is in GitHub/Bitbucket/GitLab. 

The following topics are essential in the domain of Git:
-	Git Branching Strategy
-	Git Basic Commands
-	GitHub Access with PAT (Personal Access Token)/SSH Configuration 
-	Create your own repo and pull-push files on it. For both public and private, create branches.
-	Add Webhooks in GitHub and Bitbucket.
-	GitHub Action with Cloud 
I have added some basic commands and one GIT E-book to the repository.

Helpful Link: 
Complete Git and GitHub Tutorial (Kunal Kushwaha) - https://youtu.be/apGV9Kg7ics 

# AWS Cloud
What is AWS? 
- AWS (Amazon Web Services) is a Cloud Provider 
- AWS provides you with servers and services that you can use on-demand and scale easily 
- AWS has revolutionized IT over time
- AWS powers some of the biggest websites in the world Like Amazon, Netflix, etc.

It is a very huge domain. Learning and practicing AWS takes time. I am working in AWS for the last 2.5 years trying to learn the services as much as I can.

For Learning AWS, I have followed the Stephane Udemy courses. And the services I have learned are listed below:
-	IAM
-	EC2
-	EBS
-	S3
-	Route53
-	High Availability
-	Load Balancer
-	CloudFront
-	RDS
-	DynamoDB
-	Lambda
-	SES
-	SQS
-	SNS
-	CloudWatch
-	CloudFormation
-	CloudTrail
-	ECS
-	API Gateway
-	System Manger
-	Cognito
-	VPC
-	Code Commit
-	Code Build
-	Code Deploy
-	Code Pipeline
-	Step Function
-	Config
-	(SAA-C02) AWS Certified Solutions Architect Associate
-	(DVA-C01) Amazon Web Services Certified Developer
-	(CLF-C01) AWS Cloud Practitioner

I have added some material to my Amazon folder for reference. Go through the provided material and grab the knowledge.

# Best Free Courses:
  
- AWS Cloud Practitioner (freecodecamp) - https://youtu.be/SOTamWNgDKc
- AWS Full Course (Edureka) - https://www.youtube.com/watch?v=k1RI5locZE4&ab

# AWS Automation using Python-Boto3 APIs
The best part of this journey starts from here. Automation using Python as a programming language and Boto3 APIs, and building AWS solutions. Most of my professional experience revolves around this domain. In AWS, to find the best solutions we must have an idea of pricing, compliance, proximity to the customer, and service availability. 

Automation is a one-time effort it will reduce the manual effort. According to the requirement, we can automate the process. I wrote some basic functions and that helped a lot. 

Prerequisite knowledge for AWS Automation:

-	Having a working knowledge of Python
-	Knowledge about using APIs
-	Basic knowledge of AWS CLI, which is programmatical access to AWS

I am explaining below a project step-by-step that I completed using Python and Boto3 API:
Make sure AWS CLI is configured and the User has appropriate access to the service.

1.	Get the EC2 Metadata in CSV format
2.	EC2 state change – This function changes the state of EC2 from stop to start and vice versa.
3.	Enforce Tagging EC2 to EBS – This function adds the same tags as EC2 have.
4.	Get Older AMI – This function will get the older AMI. Helps in cost-saving. 
5.	Get Older Snapshot - This function will get the older snapshot against a specific time duration.
6.	Get Older Volumes - It gets the volumes that are in available state 
7.	List EC2 Tags – Lists all the Tags that are attached with any EC2 instance 
8.	Play with EC2 – This is the provisioning of EC2 and other uses of boto3 APIs
9.	Upload File to S3 – This function uploads the file over the S3 bucket 

# Tag Harmonization Project:
I am sharing below a basic-level project as well. The scope of the project is to validate the tags attached to EC2, EBS, S3, VPC, IAM, Load Balancer, RDS, Subnet, and AMI.

1.	Working with AWS CLI, Lambda, SQS, DynamoDB, SES, CloudFormation, and Boto3 APIs
2.	Attaching necessary tags to AWS services
3.	Generating automated reports
4.	Sending emails to registered users using SES

All the mentioned program is in the folder of Automation with Python and Boto3. This part helped me a lot in learning the DevOps. Without the open-source, the DevOps will never be complete. So, I have self-learned the DevOps tools to excel my skill set in the domain.

# Docker:
Docker is a containerization tool. It has changed the monolithic way to microservices. In DevOps, it has created a big value. In order to clear my concepts with docker and also for practice purposes, I wrote the docker file and worked with docker-compose. Exploring docker-swarm made me confident in docker. It is a small effort but it is a jump start. We can further explore this domain in our professional careers. I have shared my findings in the form of a PDF in the Docker folder as well as some interview-related questions.

The best tutorial that I have followed for docker and it has helped me a lot to learn docker:
- Docker (KodeKloud)-https://www.youtube.com/watch?v=zJ6WbK9zFpI&ab
- Docker (TechWorldwithNana)-https://www.youtube.com/watch?v=3c-iBn73dDE&ab

# Ansible
Ansible is a configuration management tool. It is agent-less, using the SSH to connect with nodes, and pushing the configuration accordingly. It works using the Push mechanism. I practiced using the three EC2 Linux instances. I installed the ansible to all my three instances and made one instance as master and declared the other two as Nodes. Creating a group of those two servers after applying the configurations to the master and nodes, I explored the following three ways to push the code:
-	Ad-hoc commands (simple Linux)
-	Modules (single work like install HTTP)
-	Playbooks (more than one module)
There is no idempotency in ad-hoc commands. It will overwrite/duplicate the file every time.
With the help of the code pushing method, I have added the HTTP service to my node servers. It familiarized me with the Ansible architecture, despite it being a very basic task. I am adding my efforts to the Ansible folder.
Here are some helpful links where we can quickly learn to start with Ansible:

- Ansible (Kodekloude)-https://www.youtube.com/watch?v=LfuP38ZWlbU&list=PL2We04F3Y_42_PN52bT_U5o_lt6uPQqqq&ab

- Ansible (Nana) - https://www.youtube.com/watch?v=1id6ERvfozo&ab


# Kubernetes
Kubernetes is a game-changer in the cloud world and it is a full domain itself. I recently jump-started with Kubernetes and explored the following very basic concepts:

Main K8s Components (Node & Pod, Service & Ingress, ConfigMap & Secret, Volumes, Deployment & Stateful Set) 

Kubernetes Architecture (Worker Nodes, Master Nodes, API Server, Scheduler, Controller Manager, etcd - the cluster brain)

For practice purposes, I have deployed one EC2 instance and installed Minikube and kubectl - Local Setup

I have taken help from this course to clear basic concepts:
- Kubernetes course (TechWithNana)- https://youtu.be/X48VuDVv0do

# Jenkins:
Knowledge of Jenkins is critically important. It will help a lot in CICD Pipeline. CICD is a main domain in DevOps. CICD is Continues Development and Continues Deployment/Delivery. Jenkins is an open-source integration tool that will help to create the CICD Pipeline. I got the chance to work with Jenkins for practice purposes. I have written the Jenkins file for the automation process.

CICD:
- Jenkins complete course - https://youtu.be/FX322RVNGj4
- Github actions (techworldwithnana) - https://youtu.be/R8_veQiYBjI

# Infrastructure As Code:
Terraform is an IAC tool but I have used CloudFormation because both are used for the same purpose: Infrastructure As Code Services. But Terraform supports multiple vendors and CloudFormation is an AWS tool. I have explored the concepts of Terraform with the help of the following YouTube course:

- Terraform: https://www.youtube.com/watch?v=YcJ9IeukJL8&ab_



# Others Tools:
I have gotten a chance to experience some other cloud-native tools like the Monitoring tool New Relic, and CloudWatch. 

For Backup purposes, I have developed expertise with Cloud Ranger.

For Security purposes, I have a knowledge of Trend Micro.

For FinOps (cost optimization), I learnt Cloud Health.

For BI tools, I have experience in SNOW, JIRA, and Confluence.

Basic Knowledge of Cloud Migration 6 Rs.
https://txture.io/en/blog/6-Rs-cloud-migration-strategies

Although it is a big domain and new tech updates are coming daily, we have to work regularly and try to read the articles so that we can stay up to date in this tech world. 


 
 

  
  

