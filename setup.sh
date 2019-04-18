#!/usr/bin/sh
DIR=""
SNAP=""
DIR=$1
SNAP=$2
cd tf/$DIR
#Runs terraform scripts to setup ec2
terraform init
terraform plan\
-var 'latest_snapshot='$2 \
-out out.terraform
terraform apply out.terraform
rm out.terraform KEY
