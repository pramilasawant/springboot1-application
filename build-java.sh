#!/bin/bash

echo "Building Java application..."

# Clean and package the Spring Boot application using Maven
./mvnw clean package

if [ $? -ne 0 ]; then
  echo "Build failed"
  exit 1
fi

echo "Build successful"
