snapshot=$(aws ec2 describe-snapshots --filters Name=owner-id,Values= --query 'Snapshots[*].SnapshotId' --output=text)
#figure out how to grab the latest snapshot

cd terraform
terraform init 
terraform plan\
  -var 'ami=ami-2757f631' \
  -var 'instance_type=g2.2xlarge' \
  -var 'region=us-east-1' \
  -var 'latest_snapshot='$snapshot \
 -out out.terraform
terraform apply out.terraform
rm out.terraform KEY

##isnt overwriting volume attached to ec2
