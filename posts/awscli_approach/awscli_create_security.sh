#!/usr/bin/env bash
# The script generates a new security group 
# the group name is "max_restrict"
# only ports 22 and 443 are open. 
# to open other ports replicate the last paragraph and change the port number. 
# Will fail if group name "max_restrict" in already in use. 
# reads vpc_id from the environment variables set in .zshrc
#
aws ec2 create-security-group \
    --group-name max_restrict \
    --description "most restrictive l2 and 443 only" \
    --tag-specifications
    'ResourceType=security-group,Tags=[{Key=Name,Value=max_restrict-sg}]' \
    --vpc-id $vpc_id 
    
export security_grp=`aws ec2 describe-security-groups | \
jq -r '.SecurityGroups[] | select(.GroupName=="max_restrict").GroupId'`

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

