# @Author : https://akshaykrjain.github.io
# python script that for a given aws account:
# 
# ● Counts the number of EC2 VM's per instance type (Only Running Instances)
# ● Counts the RDS instances as well (All Instances)
# ● Writes the result to a csv file in S3
#
# It is using AWS Environment variables to configure the boto3 clients.  
# Currently retrieving details for the configured default aws region
# TODO Get details for all instances in all regions

from typing import Counter
import boto3
import time
import os

###
#Counting EC2 Instances
###

ec2 = boto3.resource('ec2')
ec2_instance_types = []
ec2_instances = ec2.instances.filter(Filters=[
            {
                'Name': 'instance-state-name',
                'Values': [
                    'running',
                ]
            },
    ])

for ec2_instance in ec2_instances:
    ec2_instance_types.append(ec2_instance.instance_type)


ec2_counts_outfile = 'ec2_counts_'+time.strftime("%Y%m%d-%H%M%S")+'.csv'
with open(ec2_counts_outfile, encoding='utf-8-sig', mode='w') as fp:
    fp.write('InstanceType,NumberOfRunningInstances\n')  
    for tag, count in Counter.items(Counter(ec2_instance_types)):  
        fp.write('{},{}\n'.format(tag, count))  


###
#Counting RDS Instances
###

rds = boto3.client('rds')
rds_instance_types = []
rds_instances = rds.describe_db_instances()


for rds_instance in rds_instances['DBInstances']:
     rds_instance_types.append(rds_instance['DBInstanceClass'])

rds_counts_outfile = 'rds_counts_'+time.strftime("%Y%m%d-%H%M%S")+'.csv'
with open(rds_counts_outfile, encoding='utf-8-sig', mode='w') as fp:
    fp.write('DBInstanceType,NumberOfInstances\n')  
    for tag, count in Counter.items(Counter(rds_instance_types)):  
        fp.write('{},{}\n'.format(tag, count))  


###
#Copying the Results to S3
# Bucket Name is hardcoded here.
# TODO- get the bucket name in argument
###

s3 = boto3.client('s3')

response_ec2 = s3.upload_file(ec2_counts_outfile, 'my-bucket', ec2_counts_outfile)
response_rds = s3.upload_file(rds_counts_outfile, 'my-bucket', rds_counts_outfile)

