#Using Python base image
FROM python:3.11-slim

RUN mkdir /app

WORKDIR /app

COPY requirements.txt .

#Installing Django
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

#Running the application at port 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
