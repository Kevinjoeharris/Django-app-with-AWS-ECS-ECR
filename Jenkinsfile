pipeline {
    agent any
    environment {
        AWS_REGION = "us-east-1"
        ACCOUNT_ID = "679510350363"
        IMAGE_REPO = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/django-app-prod"
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/Kevinjoeharris/Django-app-with-AWS-ECS-ECR.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t django-app:${IMAGE_TAG} .'
            }
        }

        stage('Login to ECR') {
            steps {
                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 679510350363.dkr.ecr.us-east-1.amazonaws.com'
                 }
             }
        }


        stage('Push to ECR') {
            steps {
                sh '''
                docker tag django-app-prod:${IMAGE_TAG} $IMAGE_REPO:${IMAGE_TAG}
                docker push $IMAGE_REPO:${IMAGE_TAG}
                '''
            }
        }

        stage('Deploy to Dev') {
            when {
                branch "dev"
            }
            steps {
                sh '''
                cd terraform
                terraform init
                terraform apply -var-file=dev.tfvars -auto-approve
                aws ecs update-service \
                  --cluster django-app-dev-cluster \
                  --service django-app-dev-service \
                  --force-new-deployment \
                  --region $AWS_REGION
                '''
            }
        }

        stage('Approval for Prod') {
            when {
                branch "main"
            }
            steps {
                script {
                    def userInput = input(
                        id: 'ProdApproval', message: 'Deploy to Production?', parameters: [
                            choice(name: 'Confirm', choices: ['No', 'Yes'], description: 'Deploy to prod?')
                        ]
                    )
                    if (userInput == 'No') {
                        error "Prod deployment aborted by user."
                    }
                }
            }
        }

        stage('Deploy to Prod') {
            when {
                branch "main"
            }
            steps {
                sh '''
                cd terraform
                terraform init
                terraform apply -var-file=prod.tfvars -auto-approve
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
