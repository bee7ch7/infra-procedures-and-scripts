#!/bin/bash
AWS_REGION=us-east-1
INSTANCE_ID=`aws ec2 describe-instances --filters  --region $AWS_REGION 'Name=tag:Name,Values=my-instance-name' --output text --query 'Reservations[*].Instances[*].InstanceId'`
#### as output = i-dsff3223fdsfsd

#### Set SSH key from AWS SSM Parameter store
eval $(ssh-agent -s)
aws ssm get-parameter --name "/dev/instances-ssh/private_key" --with-decryption --output text --query Parameter.Value --region $AWS_REGION | ssh-add -

#### Or send output to file and specify key in ssh command
aws ssm get-parameter --name "/dev/instances-ssh/private_key" --with-decryption --output text --query Parameter.Value --region $AWS_REGION > ~/.ssh/key.pem


####
####   SSH to EC2 instance
####

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/key.pem ubuntu@$INSTANCE_ID \
    -o ProxyCommand="aws ec2-instance-connect open-tunnel --instance-id $INSTANCE_ID --region $AWS_REGION"


####
####   SCP - copy files
####

scp -i ~/.ssh/key.pem \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o ProxyCommand="aws ec2-instance-connect open-tunnel --instance-id $INSTANCE_ID --region $AWS_REGION" \
    /home/dm/test.sh \ # SOURCE FILE
    ubuntu@$INSTANCE_ID:/home/ubuntu/test.sh # DESTINATION FILE

####
####   PROXY through the EC2 instance
####

ssh -i ~/.ssh/key.pem ubuntu@$INSTANCE_ID \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o ProxyCommand="aws ec2-instance-connect open-tunnel --instance-id $INSTANCE_ID --region $AWS_REGION" \
     -L 0.0.0.0:8000:10.10.14.120:8000 \ # PROXY localhost at 0.0.0.0:8000 to 10.10.14.120:8000
     -L 0.0.0.0:6432:postgres-prod.asf2r23dsfs.us-east-1.rds.amazonaws.com:5432 # PROXY localhost at 0.0.0.0:6432 to AWS RDS instance
