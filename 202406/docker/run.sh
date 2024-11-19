#!/bin/bash

echo "corro la imagen creada"

docker run  -d -p 8080:80 loon04/web1-gonzalez

echo "para saber si esta corriendo"

docker ps 

curl localhost:80
