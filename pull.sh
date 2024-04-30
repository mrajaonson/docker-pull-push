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
