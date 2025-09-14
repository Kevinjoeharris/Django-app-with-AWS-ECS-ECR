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

## 🖥️ Run Locally
Clone the repo:
```bash
git clone https://github.com/<your-username>/django-ecs-demo.git
cd django-ecs-demo
