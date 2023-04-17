#!/usr/bin/env bash
# given the following:
# vpc
# subnet
# aws configured
# id, secret, and output=json
# e.g. call awscli.sh power1_app
# put startup user code in aws_startup_user
#
#
#!/bin/bash
sudo snap install docker
git clone https://rgt47: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@github.com/rgt47/docker_compose_power1_app.git
wait
cp -R docker_compose_power1_app/ ~ubuntu
cd ~ubuntu
sudo chown -R ubuntu:ubuntu ~ubuntu/docker_compose_power1_app/
cd ~ubuntu/docker_compose_power1_app
sudo docker compose up
# command line arguments: 
while getopts v:s:a:g:i:p: flag
do
    case "${flag}" in
        v) vpc_id=${OPTARG};;
        s) subnet_id=${OPTARG};;
        a) ami_id=${OPTARG};;
        g) security_grp=${OPTARG};;
        i) static_ip=${OPTARG};;
        p) proj_name=${OPTARG};;
    esac
done
echo "vpc_id: $vpc_id";
echo "subnet_id: $subnet_id";
echo "ami_id: $ami_id";
echo "security_grp: $security_grp";
echo "static_ip: $static_ip";
echo "proj_name: $proj_name";

base=`basename $PWD`
if [ "$#" -ne 1 ]
then
  proj=$base
else proj=$1
fi

# aws environment ids
# -v
vpc_id="vpc-14814b73"
# -s
subnet_id="subnet-f02c90ab"
# -a
ami_id="ami-014d05e6b24240371"
# -g
security_grp="sg-04d0db0a59182add5"
# -i
static_ip="13.57.139.31"
# -d
proj_name="power1_app"


exit
aws ec2 create-security-group \
    --group-name max_restrict \
    --description "most restrictive l2 and 443 only" \
    --tag-specifications
    'ResourceType=security-group,Tags=[{Key=Name,Value=max_restrict-sg}]' \
    --vpc-id $vpc_id 
    
# need to study parsing of json to get the sd id value for the new group
sgid=`aws ec2 describe-security-groups --filters "Name=tag:GroupName,Values=max_restrict" | \
jq -r '.SecurityGroups[].IpPermissions[].UserIdGroupPairs[].GroupId'`


aws ec2 authorize-security-group-ingress \
    --group-id $security_grp \
    --protocol tcp \
    --port 22 \
    --cidr "0.0.0.0/0" 


aws ec2 authorize-security-group-ingress \
    --group-id $security_grp \
    --protocol tcp \
    --port 443 \
    --cidr "0.0.0.0/0" 


aws ec2 create-key-pair  --key-name  $proj_name \
   --query 'KeyMaterial' --output text > ~/.ssh/$proj_name.pem

aws ec2 run-instances \
    --image-id $ami_id \
    --count 1 \
    --instance-type t2.micro \
    --key-name $proj_name \
    --security-group-ids $security_grp \
    --subnet-id $subnet_id \
    --block-device-mappings "[{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"VolumeSize\":30}}]" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$proj_name}]"  \
    --user-data file://~/Dropbox/prj/qblog/posts/awscli_approach/aws_startup.sh

cd ~/.ssh 
chmod 600 ~/.ssh/$proj_name.pem

iid=`aws ec2 describe-instances --filters "Name=tag:Name,Values=$proj_name" | \
	jq -r '.Reservations[].Instances[].InstanceId'`


aws ec2 associate-address --public-ip $static_ip --instance-id $iid

ssh rgtlab.org 'sudo docker compose up'
