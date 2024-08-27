import json
import boto3
import joblib
import tarfile
import os

# initialise S3
s3 = boto3.client('s3')

# Load model from S3
def load_model():
    # specify bucket name and model file
    bucket_name = 'nabeel-cicd-mi-model2'
    model_key = 'model/model.joblib.tar.gz'

    # Download the model file from S3 and save it in /tmp
    s3.download_file(bucket_name, model_key, '/tmp/model.joblib.tar.gz')

    
    # Extract the model file from the tar.gz archive
    # https://www.geeksforgeeks.org/how-to-uncompress-a-tar-gz-file-using-python/
    with tarfile.open('/tmp/model.joblib.tar.gz') as file:
        file.extract('model.joblib', path='/tmp')

    # Load the saved model
    model = joblib.load('/tmp/model.joblib')
    return model

# https://medium.com/analytics-vidhya/deploy-machine-learning-models-on-aws-lambda-5969b11616bf

# Object must be extracted and processed

# def predict(event):
#     sample = event['body']
#     model = load_model()
#     result = model.predict(sample)
#     return result

# # Lambda handler function
# def lambda_handler(event, context):
#     result = predict(event)
#     return {'StatusCode':200,
#     'body':result[0]}

