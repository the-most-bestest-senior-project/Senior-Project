#!/usr/bin/sh

if [ $# -eq 0 ] #change this to check if first arg = ec2
  then
    cd tf/rds
    #Runs terraform scripts to setup rds and vpc networking
    terraform init 
    terraform plan\
    -out out.terraform
    terraform apply out.terraform
    rm out.terraform KEY
else
    cd tf/$DIR
    #Runs terraform scripts to setup ec2
    terraform init 
    terraform plan\
    -var 'latest_snapshot='$2 \
    -out out.terraform
    terraform apply out.terraform
    rm out.terraform KEY
fi
