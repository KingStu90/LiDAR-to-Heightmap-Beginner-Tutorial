#!/bin/bash

docker run --rm \
    --user "$(id -u):$(id -g)" \
    -v "$PWD:/project" \
    -w /project \
    lidar-pipeline \
    "./03_scripts/$1"
