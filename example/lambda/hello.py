import json
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    """
    Simple Lambda function that returns a greeting.
    
    Args:
        event: Lambda event data (dict)
        context: Lambda context object
        
    Returns:
        dict: Response with status code and message
    """
    try:
        # Extract name from event if provided
        name = event.get('name', 'World')
        
        # Log the invocation
        logger.info(f"Lambda invoked with name: {name}")
        
        # Create response message
        message = f"Hello, {name}! Welcome to the Terraform & Terragrunt workshop!"
        
        # Return successful response
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': message,
                'event': event,
                'timestamp': context.aws_request_id if context else None
            }),
            'headers': {
                'Content-Type': 'application/json'
            }
        }
    
    except Exception as e:
        # Log the error
        logger.error(f"Error processing request: {str(e)}")
        
        # Return error response
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': 'Internal server error',
                'message': str(e)
            }),
            'headers': {
                'Content-Type': 'application/json'
            }
        }

