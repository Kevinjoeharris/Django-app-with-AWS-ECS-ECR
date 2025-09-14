FROM python:3.11-slim

WORKDIR /Basic-Django-Website

COPY . .

RUN pip install django

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
