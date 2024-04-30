#!/bin/bash

# script name: pull.sh
# description: Docker pull and save
# author: m.rajaonson
# date: 2024-04-30
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

# Check if no parameter is provided
if [ $# -eq 0 ]; then
    echo "No parameters provided. Exiting."
    exit 1
fi

# Iterate through all parameters
while [ $# -gt 0 ]; do
    param=$1
    name="$REGISTRY/$param"
    echo "$name"
    docker search "$name" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        printf "\nDocker image %s does not exist. Skipping." "$name"
    else
        printf "\nPulling %s ...\n" "$name"
        docker pull "$name"
        printf "\nSaving %s.tar ...\n" "$param"
        docker save "$name" > "$param.tar"
        printf "\nClean up %s ...\n" "$name"
        docker rmi -f "$name"
    fi
    shift
done

