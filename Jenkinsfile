pipeline {
    agent any
    environment {
        AWS_REGION = "us-east-1"
        ACCOUNT_ID = "940743193916"
        IMAGE_REPO = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/django-app"
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Kevinjoeharris/Django-app-with-AWS-ECS-ECR.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t django-app:${IMAGE_TAG} .'
            }
        }

        stage('Login to ECR') {
            steps {
                sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $IMAGE_REPO'
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                docker tag django-app:${IMAGE_TAG} $IMAGE_REPO:${IMAGE_TAG}
                docker push $IMAGE_REPO:${IMAGE_TAG}
                '''
            }
        }

        stage('Terraform Deploy') {
            steps {
                sh '''
                cd terraform
                terraform init
                terraform apply -var-file=prod.tfvars -auto-approve
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                aws ecs update-service \
                  --cluster django-app-prod-cluster \
                  --service django-app-prod-service \
                  --force-new-deployment \
                  --region $AWS_REGION
                '''
            }
        }
    }
}
