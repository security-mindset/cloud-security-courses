import boto3

def lambda_handler(event, context):
    inspector = boto3.client('inspector')
    ec2 = boto3.client('ec2')

    # Recover instances marked as infected by Inspector
    findings = inspector.describe_findings(
        filter={
            'severities': ['Critical','High', 'Medium'],
            'rulesPackageArns': ['arn:aws:inspector:us-west-2:758058086616:rulespackage/0-9hgA516p']
        }
    )

    for finding in findings['findings']:
        instance_id = finding['assetAttributes']['agentId']

        # Isolate the instance by removing the ASG
        response = ec2.terminate_instances(
            InstanceIds=[instance_id],
            DryRun=False
        )

        # tag resource
        ec2.create_tags(
            Resources=[instance_id],
            Tags=[
                {'Key': 'Isolated', 'Value': 'True'},
                {'Key': 'Reason', 'Value': 'Security finding'}
            ]
        )

        # Send notification
        sns = boto3.client('sns')
        sns.publish(
            TopicArn='arn:aws:sns:us-west-2:123456789012:example-topic',
            Message='Instance {} has been isolated due to security finding.'.format(instance_id),
            Subject='Instance Isolation Alert'
        )

        print('Instance {} isolated successfully.'.format(instance_id))
