#!/bin/bash

REPO_NAME="rdv"
PROJECT_NAME="ros"
TAG="noetic-desktop"

docker build -t $REPO_NAME/$PROJECT_NAME:$TAG -f ./Dockerfile .

