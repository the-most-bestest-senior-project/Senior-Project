#!/usr/bin/sh

DIR=""
SNAP=""
if [ $1 -ne 'ec2' ]
  then
    cd tf/rds
    #Runs terraform scripts to setup rds and vpc networking
    terraform init
    terraform plan\
    -var 'db_username'=$2
    -var 'db_password'=$3
    -var 'aws_access_key'=$4
    -var 'aws_secret_key'=$5
    -out out.terraform
    terraform apply out.terraform
    rm out.terraform KEY
  fi
else
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
fi
