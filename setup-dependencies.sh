#!/bin/bash

# SonarQube Custom Rules Plugin - Dependency Setup Script
# ======================================================

echo "SonarQube Custom Rules Plugin - Dependency Setup"
echo "================================================"

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed or not in PATH"
    echo "Please install Docker and try again."
    exit 1
fi

# Check if SonarQube container is running
echo "🔍 Checking for running SonarQube containers..."

# Try different container name patterns
CONTAINER_NAME=""
for pattern in "sonarqube" "sonarqube:community" "sonarqube:latest"; do
    if docker ps --filter "ancestor=$pattern" --format "table {{.Names}}" | grep -q .; then
        CONTAINER_NAME=$(docker ps --filter "ancestor=$pattern" --format "{{.Names}}" | head -1)
        break
    fi
done

if [ -z "$CONTAINER_NAME" ]; then
    echo "❌ No running SonarQube container found"
    echo ""
    echo "Please start your SonarQube container first, then run this script again."
    echo ""
    echo "Example:"
    echo "  docker run -d --name sonarqube -p 9000:9000 sonarqube:community"
    echo ""
    exit 1
fi

echo "✅ Found SonarQube container: $CONTAINER_NAME"

# Create lib directory
echo "📁 Creating lib directory..."
mkdir -p lib

# Extract SonarQube application JAR
echo "📦 Extracting SonarQube application JAR..."
if docker exec "$CONTAINER_NAME" test -f /opt/sonarqube/lib/sonar-application-*.jar; then
    docker cp "$CONTAINER_NAME:/opt/sonarqube/lib/sonar-application-25.8.0.112029.jar" lib/ 2>/dev/null || \
    docker cp "$(docker exec $CONTAINER_NAME find /opt/sonarqube/lib -name 'sonar-application-*.jar' | head -1)" lib/
    echo "✅ SonarQube application JAR extracted"
else
    echo "❌ SonarQube application JAR not found in container"
    exit 1
fi

# Extract Java plugin JAR
echo "📦 Extracting Java plugin JAR..."
if docker exec "$CONTAINER_NAME" test -f /opt/sonarqube/lib/extensions/sonar-java-plugin-*.jar; then
    docker cp "$CONTAINER_NAME:/opt/sonarqube/lib/extensions/sonar-java-plugin-8.18.0.40025.jar" lib/ 2>/dev/null || \
    docker cp "$(docker exec $CONTAINER_NAME find /opt/sonarqube/lib/extensions -name 'sonar-java-plugin-*.jar' | head -1)" lib/
    echo "✅ Java plugin JAR extracted"
else
    echo "❌ Java plugin JAR not found in container"
    exit 1
fi

# Verify files exist
echo "🔍 Verifying extracted files..."
if [ -f "lib/sonar-application-25.8.0.112029.jar" ] || [ -f "lib/sonar-application-"*.jar ]; then
    echo "✅ SonarQube application JAR verified"
else
    echo "❌ SonarQube application JAR not found"
    exit 1
fi

if [ -f "lib/sonar-java-plugin-8.18.0.40025.jar" ] || [ -f "lib/sonar-java-plugin-"*.jar ]; then
    echo "✅ Java plugin JAR verified"
else
    echo "❌ Java plugin JAR not found"
    exit 1
fi

echo ""
echo "🎉 Dependencies setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Build the project: mvn clean compile"
echo "2. Package the plugin: mvn package"
echo "3. Deploy to SonarQube: ./deploy-docker.sh"
echo ""
echo "📁 Files extracted:"
ls -la lib/
echo ""
echo "💡 Note: The lib/ directory is gitignored and should not be committed to version control."
