#!/usr/bin/sh

DIR=""
if [ $# -eq 0 ]
  then
    cd tf/rds
    
    terraform init 
    terraform destroy -force 
else
    DIR=$1

    cd tf/$DIR
 
    terraform init 
    terraform destroy -force 
fi
