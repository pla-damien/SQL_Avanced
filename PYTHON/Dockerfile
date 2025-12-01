FROM python:latest
WORKDIR /app
COPY Rapport.py .
RUN pip install psycopg[binary]
CMD ["python", "Rapport.py"]