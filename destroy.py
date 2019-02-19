import boto3

volumes = []

#Creates snapshot from running gaming instance
ec2 = boto3.resource('ec2')
for instance in ec2.instances.filter(
    Filters=[
        {'Name': "instance-state-name", 'Values': ["running"]},
        {'Name': "image-id", 'Values': ["ami-017dbf6a"]}]
):
    for device in instance.block_device_mappings:
        volumes.append(device)

#Check if xvdf volume exists and take snapshot of it, otherwise this is the first boot
#so we take a snapshot of the root device
if not any(device['DeviceName'] == '/dev/xvdf' for device in volumes):
    ec2.create_snapshot(VolumeId=device.get('Ebs').get('VolumeId'))
else:
    if device['DeviceName'] == '/dev/xvdf':
        print(device['Ebs']['VolumeId'])
        ec2.create_snapshot(VolumeId=device.get('Ebs').get('VolumeId'))
            
        