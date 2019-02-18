# AWS Automated AMI and Snapshot Deletion
# @stolen from: 
# @adapted by: ron@basenube.com
#

import boto3
import collections
import datetime
import time
import sys

ec = boto3.client('ec2', 'us-east-1')
ec2 = boto3.resource('ec2', 'us-east-1')
images = ec2.images.filter(Owners=["self"])

def lambda_handler(event, context):

    reservations = ec.describe_instances(
        Filters=[
            {'Name': 'tag-key', 'Values': ['backup', 'Backup']},
        ]
    ).get(
        'Reservations', []
    )

    instances = sum(
        [
            [i for i in r['Instances']]
            for r in reservations
        ], [])

    print "Found %d instances that need evaluated" % len(instances)

    to_tag = collections.defaultdict(list)

    date = datetime.datetime.now()
    date_fmt = date.strftime('%Y-%m-%d')

    imagesList = []

    backupSuccess = False

    for instance in instances:
        imagecount = 0

        for image in images:

            if image.name.startswith('AMI Backup - ' + instance['InstanceId']):

                imagecount = imagecount + 1

                try:
                    if image.tags is not None:
                        deletion_date = [
                            t.get('Value') for t in image.tags
                            if t['Key'] == 'DeleteOn'][0]
                        delete_date = time.strptime(deletion_date, "%m-%d-%Y")
                except IndexError:
                    deletion_date = False
                    delete_date = False

                today_time = datetime.datetime.now().strftime('%m-%d-%Y')

                today_date = time.strptime(today_time, '%m-%d-%Y')

                if delete_date <= today_date:
                    imagesList.append(image.id)


                if image.name.endswith(date_fmt):

                    backupSuccess = True
                    print "Latest backup from " + date_fmt + " was a success"

        print "instance " + instance['InstanceId'] + " has " + str(imagecount) + " AMIs"

    print "============="

    print "About to process the following AMIs:"
    print imagesList

    if backupSuccess == True:

        myAccount = boto3.client('sts').get_caller_identity()['Account']
        snapshots = ec.describe_snapshots(MaxResults=1000, OwnerIds=[myAccount])['Snapshots']


        for image in imagesList:
            print "deregistering image %s" % image
            amiResponse = ec.deregister_image(
                DryRun=False,
                ImageId=image,
            )

            for snapshot in snapshots:
                if snapshot['Description'].find(image) > 0:
                    snap = ec.delete_snapshot(SnapshotId=snapshot['SnapshotId'])
                    print "Deleting snapshot " + snapshot['SnapshotId']
                    print "-------------"

    else:
        print "No current backup found. Termination suspended."
