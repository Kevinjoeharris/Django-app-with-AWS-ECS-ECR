pipeline {
    agent any

    environment {
        AWS_REGION = "<YOUR-REGION>"
        AWS_ACCOUNT_ID = "<YOUR-ACCID>"
        ECR_REPO = "<YOUR-ECR-REPO-NAME>"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Kevinjoeharris/Django-app-with-AWS-ECS-ECR.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $ECR_REPO:$BUILD_NUMBER .
                    docker tag $ECR_REPO:$BUILD_NUMBER $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$BUILD_NUMBER
                    docker tag $ECR_REPO:$BUILD_NUMBER $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
                '''
            }
        }

        stage('Push to ECR') {
            environment {
                AWS_ACCESS_KEY_ID     = credentials('aws-credentials-id')
                AWS_SECRET_ACCESS_KEY = credentials('aws-credentials-id')
            }
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$BUILD_NUMBER
                '''
                }
        }


        stage('Deploy to ECS') {
            steps {
                sh '''
                    aws ecs update-service \
                        --cluster <YOUR-CLUSTER-NAME> \
                        --service <YOUR_SERVICE-NAME> \
                        --force-new-deployment \
                        --region $AWS_REGION
                '''
            }
        }
    }
}
