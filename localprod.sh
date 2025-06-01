#!/bin/bash

# Define the container name
CONTAINER_NAME="vue-app-template_prod"
IMAGE_NAME="vue-app-template-prod:latest"

# Check if the container exists
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    # If the container exists, stop and remove it
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Create and run a new container with the same name
docker build -t $IMAGE_NAME .

# Read environment variables from .env file
ENV_ARGS=""
if [ -f "./packages/server/.env" ]; then
    echo "Loading environment variables from ./packages/server/.env"
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and comments
        if [[ ! -z "$line" && ! "$line" =~ ^# ]]; then
            # Add each environment variable to the docker run command
            ENV_ARGS="$ENV_ARGS -e $line"
        fi
    done < "./packages/server/.env"
else
    echo "Warning: .env file not found in ./packages/server/"
fi

# Always include these environment variables
ENV_ARGS="$ENV_ARGS -e NODE_ENV=production -e PORT=4000"

# Run the container with all environment variables
echo "Starting container with environment variables..."
docker run -d $ENV_ARGS --name $CONTAINER_NAME -p 6060:4000 $IMAGE_NAME

# Follow the logs
docker logs -f $CONTAINER_NAME
