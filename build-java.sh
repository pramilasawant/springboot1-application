#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Print commands and their arguments as they are executed.
set -x

echo "Starting Java build process..."

# Ensure that Java and Maven are installed
if ! [ -x "$(command -v java)" ]; then
  echo "Java is not installed. Installing..."
  sudo apt-get update
  sudo apt-get install -y default-jdk
fi

if ! [ -x "$(command -v mvn)" ]; then
  echo "Maven is not installed. Installing..."
  sudo apt-get update
  sudo apt-get install -y maven
fi

# Verify the presence of pom.xml
if [ ! -f "pom.xml" ]; then
  echo "Error: pom.xml file is missing in the directory $(pwd)"
  exit 1
fi

# Clean and build the project
mvn clean install

echo "Java build process completed successfully."
