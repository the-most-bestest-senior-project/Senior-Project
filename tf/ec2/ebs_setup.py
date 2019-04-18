import boto3
import subprocess
import sys  
import time

ec2 = boto3.resource('ec2')

for instance in ec2.instances.filter(
    Filters=[
        {'Name': "instance-state-name", 'Values': ["running"]},
        {'Name': "image-id", 'Values': ["ami-00a20f508263efd30"]}]
):
    instance.stop()

    while instance.state['Name'] != 'stopped':
        time.sleep(5)
        instance.load()

    for device in instance.block_device_mappings:
        instance.detach_volume(VolumeId=device.get('Ebs').get('VolumeId'))

        v = ec2.Volume(device.get('Ebs').get('VolumeId'))

        while v.state != 'available':
            time.sleep(5)
            v.load()

        v.delete()

    instance.attach_volume(VolumeId=sys.argv[1], Device='/dev/sda1')
    instance.start()
