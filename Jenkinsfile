pipeline {
    agent any
    stages {
        stage('Git Checkout') {
                steps {
                    git branch: 'main', url: 'https://github.com/Kevinjoeharris/Django-app-with-AWS-ECS-ECR.git'
                }
            }
        stage('Build Docker Image') {
                steps {
                    sh '''
                        docker build -t django-app:${BUILD_NUMBER} .
                        docker tag django-app:${BUILD_NUMBER} 940743193916.dkr.ecr.us-east-1.amazonaws.com/django-ecs-ecr:${BUILD_NUMBER}
		            '''
                }
            }
            
        stage('Push to ECR') {
                steps {
                    withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                        sh '''
                            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 940743193916.dkr.ecr.us-east-1.amazonaws.com
                            docker push 940743193916.dkr.ecr.us-east-1.amazonaws.com/django-ecs-ecr:${BUILD_NUMBER}
                         '''
                    }
                }
        }          

        stage('Deploy to ECS') {
                steps{
		  sh 'aws ecs update-service --cluster MyCluster --service my-http-service --force-new-deployment'
                }
            }

        }
    }
