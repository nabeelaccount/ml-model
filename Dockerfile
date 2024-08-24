# Use an official Python runtime as a parent image
FROM python:3.8

# Set the working directory
WORKDIR /app

# Install dependencies - most frequent updated file(s)
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . .

# # Run Pytest
# RUN PYTHONPATH=. pytest

# Set PYTHONPATH
ENV PYTHONPATH=/app

# Run Pytest
RUN pytest