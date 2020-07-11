#!/bin/bash

set -e

: ${INPUT_REGISTRY:=gcr.io}
: ${INPUT_IMAGE:=$GITHUB_REPOSITORY}
: ${INPUT_ARGS:=} # Default: empty build args
: ${INPUT_TAG:=$GITHUB_SHA}
: ${INPUT_LATEST:=true}
: ${INPUT_PATH:=.}
: ${INPUT_DOCKERFILE:=Dockerfile}


docker build $INPUT_ARGS -f $INPUT_DOCKERFILE -t $INPUT_IMAGE:$INPUT_TAG $INPUT_PATH
docker tag $INPUT_IMAGE:$INPUT_TAG $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_TAG

if [ $INPUT_LATEST = true ]; then
  docker tag $INPUT_IMAGE:$INPUT_TAG $INPUT_REGISTRY/$INPUT_IMAGE:latest
fi
