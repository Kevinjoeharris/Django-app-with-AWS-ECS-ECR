pipeline {
    agent any
    environment {
        AWS_REGION = "us-east-1"
        ACCOUNT_ID = "917877044379"
        IMAGE_REPO = "917877044379.dkr.ecr.us-east-1.amazonaws.com/django-ecs-ecr"
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')     // Jenkins credential ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        /*stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Kevinjoeharris/Django-app-with-AWS-ECS-ECR.git'
            }
        }*/

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t django-ecs-ecr:${IMAGE_TAG} .'
            }
        }
        

        stage('Push to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $IMAGE_REPO
                docker tag django-ecs-ecr:${IMAGE_TAG} $IMAGE_REPO:${IMAGE_TAG}
                docker push $IMAGE_REPO:${IMAGE_TAG}
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                aws ecs update-service \
                  --cluster django-ecs-ecr-cluster \
                  --service django-ecs-ecr-service \
                  --force-new-deployment \
                  --region $AWS_REGION
                '''
            }
        }
    }
}