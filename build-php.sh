cd /path/to/springboot1-application
echo '#!/bin/bash
set -e
cd /var/lib/jenkins/workspace/Springboot-python\ application/springboot1-application
./mvnw clean
./mvnw compile
./mvnw package
echo "Build completed successfully."' > build-java.sh
chmod +x build-java.sh
