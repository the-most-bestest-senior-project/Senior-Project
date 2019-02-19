import boto3

client = boto3.client('ec2', 
        aws_access_key_id=key,
        aws_secret_access_key=secret,
        region_name='us-east-1')

#prints out our snapshots
print(client.describe_snapshots(OwnerIds=['self']))

#change this shit later when we get the database up
#will be super ez to grab the latest snapshot 

