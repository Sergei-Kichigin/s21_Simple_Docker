#!/bin/bash
export DOCKER_CONTENT_TRUST=1

echo "Start building containers..."
sudo docker rmi simple_docker/part5:1.0 -f && sudo docker build . -t simple_docker/part5:1.0
sleep 1
echo "Dockle check..."
dockle simple_docker/part5:1.0
