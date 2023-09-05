import json
import boto3
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    try:
        # Log the incoming event to check its structure
        logger.info("Received event: " + json.dumps(event))

        # Try to extract phone number
        body = json.loads(event.get('body', '{}'))
        if 'phone_number' not in body:
            return {
                'statusCode': 400,
                'body': json.dumps('Phone number not provided in the request body.')
            }
        phone_number = body['phone_number']
        
        # Store the phone number in DynamoDB
        response = dynamodb.put_item(
            TableName='PhoneNumbers',
            Item={
                'phone_number': {'S': phone_number}
            }
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps('Phone number stored successfully')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(str(e))
        }

def validate_phone_number(phone_number):
    # Return True if valid, False otherwise
    return True
