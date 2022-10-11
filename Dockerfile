# syntax=docker/dockerfile:1

FROM python:3.10-bullseye
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONNUNFUFFERED=1
WORKDIR /code
COPY ./app /code/
RUN pip install -r requirements.txt
