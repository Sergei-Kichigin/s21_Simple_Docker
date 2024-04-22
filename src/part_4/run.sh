#!/bin/bash

# Удаление существующего образа и пересборка с помощью Dockerfile
sudo docker rmi -f simple_docker/part4:1.0 && sudo docker build . -t simple_docker/part4:1.0
