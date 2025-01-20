#!/bin/bash

PROJECT_NAME="rdv"

REPO_NAME=ros2
TAG=humble-desktop

docker build -t $PROJECT_NAME/$REPO_NAME:$TAG -f ./Dockerfile .

