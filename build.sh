#!/bin/bash

REPO_NAME="ghcr.io/rendezvue"
PROJECT_NAME="ros_docker"
TAG=$(git branch --show-current)

# docker build -t $REPO_NAME/$PROJECT_NAME:$TAG -f ./Dockerfile .
docker buildx build --platform linux/amd64,linux/arm64 -t $REPO_NAME/$PROJECT_NAME:$TAG -f ./Dockerfile . --push