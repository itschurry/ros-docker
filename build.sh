#!/bin/bash

REPO_NAME="rdv"
PROJECT_NAME="ros2"
TAG="humble"

docker build -t $REPO_NAME/$PROJECT_NAME:$TAG -f ./Dockerfile .

