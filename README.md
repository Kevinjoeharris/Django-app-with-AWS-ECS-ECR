# Django app on AWS ECS and ECR with CICD 🚀

A basic **Django application** containerized with **Docker** and deployed on **AWS ECS (Elastic Container Service)** using **ECR (Elastic Container Registry)**.  
This project serves as a simple starter template for learning Django + Docker + AWS deployments.

---

## 📌 Features
- Basic Django app (`home` app with a simple homepage)
- Containerized using Docker
- Push Docker image to AWS ECR
- Deploy and run on AWS ECS
- Implement CICD with Jenkins

---

## ⚙️ Prerequisites
- [Python 3.10+](https://www.python.org/downloads/)
- [Django 3.x](https://docs.djangoproject.com/en/3.0/)
- [Docker](https://docs.docker.com/get-docker/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) (configured with your IAM credentials)
- [Git](https://git-scm.com/)
- Jenkins

---

## 📂 Project Structure
```bash
django-ecs-demo/
│── manage.py
│── Dockerfile
│── requirements.txt
│── basic_django_app/   # Main project settings
│── templates/          # HTML templates
│── Jenkinsfile
```

## 🖥️ Run Locally
Clone the repo:
```bash
git clone https://github.com/<your-username>/Django-app-with-AWS-ECS-ECR.git
cd django-ecs-demo
```

Create a virtual environment & install dependencies:
```bash
python -m venv venv
source venv/bin/activate   # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```
Run start server:
```bash
python manage.py migrate
python manage.py runserver
```

Visit: http://127.0.0.1:8000/

## 🐳 Docker Setup
Build Docker image:
```bash
docker build -t django-ecs-ecr .
```

Run locally with Docker:
```bash
docker run django-ecs-ecr
```

## ☁️ AWS Deployment
1. Authenticate Docker with ECR
```bash
aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <aws-account-id>.dkr.ecr.<your-region>.amazonaws.com
```

2. Create ECR Repository
```bash
aws ecr create-repository --repository-name django-ecs-ecr
```

3. Tag & Push Image
```bash
docker tag django-ecs-ecr:latest <aws-account-id>.dkr.ecr.<your-region>.amazonaws.com/django-ecs-ecr:latest
docker push <aws-account-id>.dkr.ecr.<your-region>.amazonaws.com/django-ecs-ecr:latest
```

4. Deploy on ECS
   Create an ECS cluster
   Define a Task Definition with your ECR image
   Create a Service to run your container
