import boto3
import subprocess
import pymysql
import sys  
import datetime
import time

def get_aws_account_id(access_key, secret_key):
    sts = boto3.client(
        "sts", aws_access_key_id=access_key, aws_secret_access_key=secret_key,
    )
    user_arn = sts.get_caller_identity()["Arn"]
    return user_arn.split(":")[4]

#TODO: take in secret key, access key, ami/game, db pwd
access_key = ""
secret_key = ""

#Creates snapshot from running gaming instance
ec2 = boto3.resource('ec2')
account_id = get_aws_account_id(access_key, secret_key)

ami = "ami-00a20f508263efd30"
snapshot = ""

for instance in ec2.instances.filter(
    Filters=[
        {'Name': "instance-state-name", 'Values': ["running"]},
        {'Name': "image-id", 'Values': ["ami-00a20f508263efd30"]}]
):
    #need to stop the instance in order to take snapshot of root volume
    instance.stop()
    for device in instance.block_device_mappings:
        snapshot = ec2.create_snapshot(VolumeId=device.get('Ebs').get('VolumeId')).id

rds = boto3.client('rds', 
                aws_access_key_id=access_key,
                aws_secret_access_key=secret_key,
                region_name='us-east-1')

addr=""
usr=""
pwd=""

rds_instances = rds.describe_db_instances()
for i in rds_instances['DBInstances']:
    arn = i['DBInstanceArn']
    tags = rds.list_tags_for_resource(ResourceName=arn)['TagList']
    tag = next(iter(filter(lambda tag: tag['Key'] == 'Name' and tag['Value'] == 'gaming_db', tags)), None)
    if tag:
        addr = i.get('Endpoint').get('Address') 
        usr = i.get('MasterUsername')

db = pymysql.connect(host=addr,
                    port=3306,
                    user=usr,      
                    password="rootrootroot")

cur = db.cursor()

ts = time.time()
timestamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')

cur.execute("USE `senior_design`;")
sql_insert_query = "INSERT INTO `ebs_table`(`user_ID`, `snapshot`, `snapshot_time`, `AMI`) VALUES (%s,%s,%s,%s)"
insert_tuple = (account_id, snapshot, timestamp, ami)
cur.execute(sql_insert_query, insert_tuple)
cur.execute("SELECT * FROM `ebs_table`;")

db.commit()
db.close()

subprocess.call('teardown.sh ec2', shell=True)
            