#!/bin/bash

# script name: docker.sh
# description: Docker load, tag and push tar files
# author: m.rajaonson
# date: 2024-04-23
# version: 1.0

source .env

# Docker login command
echo $TOKEN | docker login -u $USER --password-stdin $REGISTRY

# Check if Docker login was successful
if [ $? -eq 0 ]; then
    echo "Docker login successful"
else
    echo "Error: Docker login failed"
    exit 1
fi

version="latest"

# Get a list of all tar files in the current directory
files=$(find *.tar)

# Iterate through each tar file
for file in $files; do
    # Extract the image name from the tar file
    image_name=$(basename "$file" .tar)
    echo "$image_name"   

    # Load the docker image from the tar file
    image_id=$(docker load -i "$file" | awk '{print $NF}')
    echo "$image_id"

    # Docker image tag
    image_tag=$REGISTRY/$image_name:$version

    # Tag the docker image with version and image ID
    docker tag "$image_id" "$image_tag"

    # Push the tagged image to the registry
    docker push "$image_tag"

    # Clean up - remove the loaded image
    docker rmi -f "$image_id"
    docker rmi -f "$image_tag"
done
