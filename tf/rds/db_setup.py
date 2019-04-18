#!/usr/bin/python
import pymysql
import sys  

db = pymysql.connect(host=sys.argv[1],
                    port=3306,
                    user=sys.argv[2],      
                    password=sys.argv[3])
                    
#create cursor object to execute sql commands
cur = db.cursor()
try:    
    cur.execute("CREATE SCHEMA IF NOT EXISTS `senior_design`;")
except:
    pass #just so we don't show errors when db already exists

cur.execute("USE `senior_design`;")
cur.execute("""CREATE TABLE IF NOT EXISTS `senior_design`.`ebs_table` ( 
  `user_ID` VARCHAR(45) NOT NULL, 
  `snapshot` VARCHAR(45) NOT NULL, 
  `snapshot_time` TIMESTAMP NOT NULL, 
  `AMI` VARCHAR(45) NULL DEFAULT NULL, 
  PRIMARY KEY (`snapshot`));""")
cur.execute("""CREATE TABLE IF NOT EXISTS `senior_design`.`game_table` (
  `AMI` VARCHAR(45) NOT NULL,
  `game_title` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`AMI`));""")

#insert into game table initial game ami

db.commit()
db.close()