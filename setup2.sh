#!/usr/bin/sh

cd tf/rds
#Runs terraform scripts to setup rds and vpc networking
terraform init
terraform plan\
-var 'db_username='$2 \
-var 'db_password='$3 \
-var 'aws_access_key='$4 \
-var 'aws_secret_key='$5 \
-out out.terraform
terraform apply out.terraform
rm out.terraform KEY