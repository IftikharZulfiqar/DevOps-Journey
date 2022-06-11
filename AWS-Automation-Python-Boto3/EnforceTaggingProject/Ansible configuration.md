Ansible is configuration management tool. It's an agent less. Using the SSH connect with nodes, and push the configuration accordingly.

Ansible:
# yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# yum install git python python-level python-pip openssl ansible -y
---------------------------------------
go to host file in ansilbe server and add private IPs of the attahced nodes.
# vi /etc/ansible/hosts
Need to create the group add private Ips

[demo]
3.108.194.134
3.109.49.18
----------------------------------------
Host file will worked after updating the ansible-cfg file
#vi /etc/ansible/ansible-cfg
uncomment 
inventory
sudo-user = root
--------------------------------------------
create one user in all servers and nodes
#adduser ansible
#passwd ansible
set pasword
-------------------------------------------
#su - ansible
ssh privateIP
---------------------------------
sudo privileged
#visudo
ansible ALL=(ALL) NOPASSWD: ALL
------------------------------------------
permit root login
vi /etc/ssh/sshd_config

Uncomment following below line 

PermitRootLogin yes
passwordauthentication yes
---------------------------------------
#sudo yum install httpd -y
#ssh private IP
------------------------------------------

ssh-keygen -t -rsa
#ssh-copy-id ansible@172.31.27.4

if key is added then no changes required in sshd_config file
---------------------------------

ansible commands

go into ansible server

ansible all --list-hosts
ansible <groupname> --list-hosts
ansible <groupname>[0] --list-hosts
ansible <groupname>[1:4] --list-hosts
----------------------------------------

three way to push the code
Ad-hoc commands(simple linux)
Modules(single work like insall http)
Playbooks(more then one module)

There is no idempotency in ad-hoc commands. It will overwrite/duplicate the file everytime.
------------------------------
ad-hoc commands
idempotency is not work in ad-hoc

ansible demo -a "ls"  //a is argument
ansible demo[0] -a "touch file"
ansible demo -ba "yum install httpd -y"

------------------------------------
Ansible Modules
inverted commas we add yaml

username groupname -b -m moduleName-a "pkg=httpd state=present"
username groupname -b -m moduleName -a "pkg=httpd state=latest"
 
ansible demo -b -m copy -a "src=testFile dest=/tmp"
 ansible demo -m setup
---------------------------------
Ansible playbook yaml code:

---
- hosts: demo
  user: ansible
  become: yes
  connection: ssh
  gather_facts: yes
  tasks:
          - name: installed httpd
            action: yum name=httpd state=installed



	


















