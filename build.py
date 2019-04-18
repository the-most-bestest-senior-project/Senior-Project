import boto3
import subprocess
import pymysql
import sys
import datetime
import os

def main():
        access_key=sys.argv[2]
        secret_key=sys.argv[3]

        ec2 = boto3.client('ec2',
                aws_access_key_id=access_key,
                aws_secret_access_key=secret_key,
                region_name='us-east-1')
                
        ec2_r = boto3.resource('ec2',
                aws_access_key_id=access_key,
                aws_secret_access_key=secret_key,
                region_name='us-east-1')

        filters = [{'Name':'tag:Name', 'Value':'main'}]
        
        response = ec2.describe_vpcs(
                Filters=[
                        {
                        'Name': 'tag:Name',
                        'Values': [
                                "main",
                        ]
                        }    
                ]
        )
        vpc_id = ""
        resp = response['Vpcs']
        for i in resp:
                for k, v in i.items():
                        if k == "VpcId":
                                vpc_id = v
        cnt = 0
        for vpc in ec2_r.vpcs.all():
                if vpc.id == vpc_id:
                        for subnet in vpc.subnets.all():
                                if cnt == 0:
                                        sub = subnet.id
                                        break
                                cnt+= 1
        rds = boto3.client('rds',
                aws_access_key_id=access_key,
                aws_secret_access_key=secret_key,
                region_name='us-east-1')

        addr=""
        usr=""
        pwd=sys.argv[1]

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
                       password=pwd) #figure this out

        snap=""
        cur = db.cursor()
        cur.execute("USE `senior_design`;")
        #sql_insert_query = "INSERT INTO `ebs_table`(`user_ID`, `snapshot`, `snapshot_time`, `AMI`) VALUES (%s,%s,%s,%s)"
        #insert_tuple = ("123", "123", datetime.datetime.now(), "idk")
        #cur.execute(sql_insert_query, insert_tuple)

        cur.execute("SELECT `snapshot` FROM `ebs_table` ORDER BY `snapshot_time` DESC LIMIT 1")
        snap = cur.fetchone()
        print(snap)
        for row in cur:
                print(row)

        db.commit()
        db.close()

        os.system("cd tf/rds && terraform init && terraform apply -var 'aws_access_key='%s -var 'aws_secret_key='%s -var 'latest_snapshot='%s -var 'vpc_id='%s -var 'subnet_id='%s -auto-approve" % (access_key, secret_key, snap, vpc_id, sub))
        #subprocess.call('setup.sh ec2 "%s" "%s" "%s"' %(snap, vpc_id, sub), shell=True)

main()
