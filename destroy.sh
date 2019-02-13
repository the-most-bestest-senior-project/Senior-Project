#!/usr/bin/env bash

echo "*** Termination started" 

##will have to change this a bit if user has more than one running instance
instance=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=running --query 'Reservations[0].Instances[0].InstanceId' --output=text)

volume=$(aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$instance --query 'Volumes[0].VolumeId' --output=text)

$(aws ec2 create-snapshot --volume-id $volume --description "teardown snapshot")

echo "***  starting terraform" 
cd terraform
terraform destroy -force
echo "*** Termination complete"