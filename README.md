# Machine learning training model to recongnise Iris flower


##  Building through GitHub action
The project is broken down into two segements.

1. Building the Iris flower training application

The code loads a dataset of iris flowers, trains a Random Forest model, already created, and then uses that data to classify the species of the flowers based on their measurements. The trained model is then saved to a file 'model.joblib' for future use.

What has been achieved

Build pipeline
```markdown

Run test -------> Train model -------> Create docker image -------> store image in ECR -------> Package model (model.joblib) -------> Create model artifact
```

 deploy_to_s3
```markdown

Download model artifact -------> Upload compressed artifact to S3
```

deploy_to_sagemaker
```markdown

Download model artifact -------> Upload compressed artifact to S3
```

An alternative of this is using SageMaker comprehensively
```markdown

Sage Maker -------> END Point (API CALLS) -------> result [y/n]
    |
    |   -------> S3 bucket (stored module)
    |
    v
ECR Image (Train, test, and revise module to S3)
```


Further reading and reference:
- https://scikit-learn.org/stable/auto_examples/datasets/plot_iris_dataset.html
- https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html

2. Building the supporting infrastructure for inferencing

Machine learning inferencing is the ability to make use of the trained model. In our example, using Lambda, we aim to extract the trained model to predict whether a plant is an Iris Flower based in the flowers dimensions - petals.

The current method
```markdown

API Call -------> API Gateway -------> API Lambda (load model) -------> S3 bucket (stored module)
                                        |
                                        |
                                        v
                                 result [y/n]
```

Alternative method
```markdown

Sage Maker -------> END Point (API CALLS) -------> result [y/n]
    |
    |   -------> S3 bucket (stored module)
    |
    v
ECR Image (Train, test, and revise module to S3)
```


references:
- Sagemaker inferencing: https://www.datacamp.com/tutorial/aws-sagemaker-tutorial
- Machine learning inference: https://www.datacamp.com/blog/what-is-machine-learning-inference
- Flask fir Sagemaker inference: https://towardsdatascience.com/deploy-a-machine-learning-model-using-flask-da580f84e60c

## Explaining an alternative CICD pipeline, with diagram, using AWS services, instead of GitHub. 

Alternative using native AWS CICD pipeline
```markdown

Developer Push code -------> CodeCommit -------> CodePipeline -------> CodeBuild -------> Store Image (ECR) -------> Sage Maker
                                                                          |
                                                                          |
                                                                          |
                                                                          v
                                                                    Store model (S3)
```


A more complete scanerio can be found in the following example:
![ML Pipeline](images/prod-ml-pipeline.png)

- Developer push code: Develoer pushes code to CodeCommit
- CodeCommit: CodeCommit repository, alternative to GitHub repository
- CodePipeline: Detects changes in the repository and triggers the pipeline
- CodeBuild: Installs dependencies, runs the tests, and trains the model
- -  S3 Bucket: Store the trained model in AWS S3
- - Stores application image in ECR
- Builds SageMaker model, and endpoint


For more information: https://aws.amazon.com/blogs/machine-learning/build-a-ci-cd-pipeline-for-deploying-custom-machine-learning-models-using-aws-services/