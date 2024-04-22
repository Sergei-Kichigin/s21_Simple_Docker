#!/bin/bash
echo "Start building containers..."
sudo docker-compose down && sudo docker-compose build && sudo docker-compose up -d
echo "Check server response..."
sleep 1 && curl localhost:80 && curl localhost:80/status