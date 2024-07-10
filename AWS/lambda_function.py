import json
import os
import boto3

def lambda_handler(event, context):
    sns_client = boto3.client('sns')
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']
    
    findings = event['detail']['findings']
    
    for finding in findings:
        message = f"New Inspector Finding: {finding['title']}\nDescription: {finding['description']}"
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=message,
            Subject='New AWS Inspector Finding'
        )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Notification sent successfully')
    }
