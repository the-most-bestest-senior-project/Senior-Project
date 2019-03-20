#!/bin/sh

DIR=""
if [ $# -eq 0 ]
  then
    DIR = "rds"
else
    DIR=$1
fi

#Runs terraform scripts to setup rds and vpc networking
cd tf/$DIR
terraform init 
terraform plan\
 -out out.terraform
terraform apply out.terraform
rm out.terraform KEY