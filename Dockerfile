FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /code

RUN apt-get update && \
    apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for Docker cache optimization
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy all files including the entrypoint
COPY ./entrypoint.sh .
RUN sed -i 's/\r$//g' /code/entrypoint.sh
RUN chmod +x /code/entrypoint.sh

COPY . .

ENTRYPOINT ["/code/entrypoint.sh"]

CMD ["python", "manage.py", "runserver", "0.0.0.0:3002"]