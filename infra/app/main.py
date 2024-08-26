import json
import boto3
import joblib
import tarfile
import os

# S3 client
s3 = boto3.client('s3')

# Load model from S3 and return it
def load_model():
    # Specify your S3 bucket and model file
    bucket_name = 'nabeel-cicd-mi-model2'
    model_key = 'model/model.joblib.tar.gz'

    # Download the model file from S3
    s3.download_file(bucket_name, model_key, '/tmp/model.joblib.tar.gz')

    
    # Extract the model file from the tar.gz archive
    # https://www.geeksforgeeks.org/how-to-uncompress-a-tar-gz-file-using-python/
    with tarfile.open('/tmp/model.joblib.tar.gz') as file:
        file.extract('model.joblib', path='/tmp')

    # Load the model
    model = joblib.load('/tmp/model.joblib')
    return model


# Lambda handler function
def lambda_handler(event, context):
    # Load the model
    model = load_model()

    # Extract features from the request body
    body = json.loads(event['body'])
    features = body['features']

    # Make a prediction
    prediction = model.predict([features])

    # Return the prediction as JSON
    return {'statusCode': 200, 'body': json.dumps({'prediction': prediction.tolist()})
    }
