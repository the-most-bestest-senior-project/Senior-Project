#!/usr/bin/sh

DIR=""
SNAP=""
if [ $1 -neg 'ec2' ]
  then
    cd tf/rds
else
    DIR=$1
    SNAP=$2

    cd tf/$DIR
fi

#Runs terraform scripts to setup rds and vpc networking
terraform init
terraform plan\
 -out out.terraform
terraform apply out.terraform
rm out.terraform KEY
