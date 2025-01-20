#!/bin/bash

PROJECT_NAME="rdv"

REPO_NAME=ros
TAG=noetic-desktop

docker build -t $PROJECT_NAME/$REPO_NAME:$TAG -f ./Dockerfile .

