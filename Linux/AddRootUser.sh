#/bin/bash

#Script that will add the user in sudores/root 

echo "Enter user name:"
read username

user_add () {
grep {{ username }} /etc/sssd/sssd.conf
if [ $? -ne 0 ];then
realm permit {{ username }}
else
echo \{{ username }} already exist\
fi
grep {{ username }} /etc/sudoers
if [ $? -ne 0 ];then
echo \{{ username }}  ALL=(ALL)   ALL !/bin/su - root !/bin/su - !/bin/su - ec2-user !/bin/su - regnadmin\ >> /etc/sudoers
else
echo \{{ username }} already part of sudoers\
fi
}