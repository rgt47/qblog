#!/usr/bin/env bash
while getopts s:t:p: flag
do
    case "${flag}" in
        s) size=${OPTARG};;
        t) type=${OPTARG};;
        p) proj_name=${OPTARG};;
    esac
done
echo "proj_name: $proj_name";
base=`basename $PWD`
echo "basename is $base"
echo "proj_name is $proj_name"
if [ -z "$proj_name" ]
then
  proj_name=$base
else
      echo "proj_name is $proj_name"
fi



if [ -z "$type" ]
then
 type="t2.micro" 
fi

if [ -z "$size" ]
then
  size=30
fi


echo "proj_name is $proj_name"
echo "vpc_id: $vpc_id";
echo "subnet_id: $subnet_id";
echo "ami_id: $ami_id";
echo "security_grp: $security_grp";
echo "static_ip: $static_ip";
echo "type: $type";
echo "size: $size";
echo "proj_name: $proj_name";


read -p "Continue (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  echo "Here we go!";
else
  echo "booo"; exit; 
fi

aws ec2 create-key-pair  --key-name  $proj_name \
   --query 'KeyMaterial' --output text > ~/.ssh/$proj_name.pem

wait
cd ~/.ssh 
chmod 600 ~/.ssh/$proj_name.pem
exit



aws ec2 run-instances \
    --image-id $ami_id \
    --count 1 \
    --instance-type $type \
    --key-name $proj_name \
    --security-group-ids $security_grp \
    --subnet-id $subnet_id \
    --block-device-mappings "[{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"VolumeSize\":$size}}]" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$proj_name}]"  \
    --user-data file://~/Dropbox/prj/qblog/posts/awscli_approach/aws_startup.sh

iid=`aws ec2 describe-instances --filters "Name=tag:Name,Values=$proj_name" | \
	jq -r '.Reservations[].Instances[].InstanceId'`

aws ec2 associate-address --public-ip $static_ip --instance-id $iid

ssh rgtlab.org 'sudo docker compose up'

