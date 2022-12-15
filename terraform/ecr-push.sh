#!/bin/bash

set -e

ACCOUNT="293748214279"
REGION="us-east-1"

LOCAL_IMAGE_TAG="latest"
AWS_IMAGE_TAG="0.0.1-alpha"

#LOCAL_REPOSITORY="github.com/felipelfraga/geoserver-cloud"
LOCAL_REPOSITORY="ealen/echo-server"
AWS_ECR_HOST=$ACCOUNT.dkr.ecr.$REGION.amazonaws.com
AWS_REPOSITORY=$AWS_ECR_HOST/geoserver-cloud-repository

docker pull $LOCAL_REPOSITORY:$LOCAL_IMAGE_TAG

LOCAL_IMAGE_ID=$(docker images --format '{{.Repository}} {{.Tag}} {{.ID}}' | grep $LOCAL_REPOSITORY | grep $LOCAL_IMAGE_TAG | cut -d" " -f3)

docker tag $LOCAL_IMAGE_ID $AWS_REPOSITORY:$AWS_IMAGE_TAG

aws --region $REGION ecr get-login-password | docker login \
    --username AWS \
    --password-stdin \
    $AWS_ECR_HOST

docker push $AWS_REPOSITORY:$AWS_IMAGE_TAG
docker rmi $AWS_REPOSITORY:$AWS_IMAGE_TAG
