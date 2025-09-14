pipeline {
    agent any
    stages {
        stage('Git Checkout') {
                steps {
                    git branch: 'main', url: 'https://3000-port-gfn35kiv37xriete.labs.kodekloud.com/max/python-app'
                }
            }
        stage('Build Docker Image') {
                steps {
                    sh '''
			            docker build -t django-app:$BUILD_NO .
			            docker tag django-app:$BUILD_NO 940743193916.dkr.ecr.us-east-1.amazonaws.com/django-ecs-ecr:$BUILD_NO
		            '''
                }
            }
            
        stage('Push to ECR') {
                steps {
                    withCredentials([
                        string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                         string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                        ]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 940743193916.dkr.ecr.us-east-1.amazonaws.com
                        docker push 940743193916.dkr.ecr.us-east-1.amazonaws.com/django-ecs-ecr:$BUILD_NO
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
