import boto3
import subprocess
import pymysql
import sys
import datetime

def main():
        access_key=""
        secret_key=""

        ec2 = boto3.client('ec2', 
                aws_access_key_id=access_key,
                aws_secret_access_key=secret_key,
                region_name='us-east-1')

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
                       password="")

        snap=""
        cur = db.cursor()
        cur.execute("USE `senior_design`;")
        #sql_insert_query = "INSERT INTO `ebs_table`(`user_ID`, `snapshot`, `snapshot_time`, `AMI`) VALUES (%s,%s,%s,%s)"
        #insert_tuple = ("123", "123", datetime.datetime.now(), "idk")
        #cur.execute(sql_insert_query, insert_tuple)

        #TODO: still need to check this stuff is working
        cur.execute("SELECT * FROM `ebs_table` ORDER BY `snapshot_time` DESC LIMIT 1")

        subprocess.call('setup.sh ec2 "%s' %snap, shell=True)

main()
