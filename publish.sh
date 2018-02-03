#!/bin/sh

source build.sh

USER="kaikuehne"
USER_IMAGE="$USER/$IMAGE"

docker login
docker tag $IMAGE $USER_IMAGE
docker push $USER_IMAGE
