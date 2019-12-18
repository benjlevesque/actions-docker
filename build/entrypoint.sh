#!/bin/bash

set -e

: ${GCLOUD_REGISTRY:=gcr.io}
: ${IMAGE:=$GITHUB_REPOSITORY}
: ${TAG:=$GITHUB_SHA}
: ${DEFAULT_BRANCH_TAG:=true}

docker build -t $IMAGE:latest -t $IMAGE:$TAG .
docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:$TAG
docker tag $IMAGE:latest $GCLOUD_REGISTRY/$IMAGE:latest
if [ "$DEFAULT_BRANCH_TAG" = "true" ]; then
  BRANCH=$(echo $GITHUB_REF | rev | cut -f 1 -d / | rev)
  if [ "$BRANCH" = "master" ]; then # TODO
    docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:$BRANCH
  fi
fi
