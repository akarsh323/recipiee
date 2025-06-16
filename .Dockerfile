FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Install build dependencies
RUN apk add --no-cache gcc musl-dev libffi-dev

# Create app directory
WORKDIR /app

# Copy requirements first for better cache
COPY requirements.txt /app/requirements.txt
COPY requirements.dev.txt /app/requirements.dev.txt

# Install flake8 directly to diagnose issues
RUN pip install flake8>=3.9.2,<3.10

# Create virtual environment and install dependencies
ARG DEV=false
RUN python -m venv /pyenv && \
    /pyenv/bin/pip install --upgrade pip && \
    /pyenv/bin/pip install -r /app/requirements.txt

# Set venv path for all users
ENV PATH="/pyenv/bin:$PATH"

# Copy application code
COPY ./app /app

# Create a non-root user
RUN adduser -D django-user

# Use non-root user
USER django-user