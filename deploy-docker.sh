#!/bin/bash

# SonarQube Custom Rules Plugin - Docker Deployment Script
# For SonarQube running with Docker volumes

set -e

echo "SonarQube Custom Rules Plugin - Docker Deployment"
echo "================================================="

# Check if JAR exists
JAR_FILE="target/sonarqube-custom-rules-1.0.0.jar"
if [ ! -f "$JAR_FILE" ]; then
    echo "Error: Plugin JAR not found. Please run 'mvn package' first."
    exit 1
fi

echo "Plugin JAR found: $JAR_FILE"

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH"
    exit 1
fi

# Find SonarQube containers
echo "Searching for SonarQube containers..."

# Try different ways to find SonarQube containers
SONARQUBE_CONTAINERS=$(docker ps --filter "ancestor=sonarqube" --format "{{.Names}}" 2>/dev/null || true)

if [ -z "$SONARQUBE_CONTAINERS" ]; then
    # Try finding by name pattern
    SONARQUBE_CONTAINERS=$(docker ps --filter "name=sonarqube" --format "{{.Names}}" 2>/dev/null || true)
fi

if [ -z "$SONARQUBE_CONTAINERS" ]; then
    # Try finding by image name
    SONARQUBE_CONTAINERS=$(docker ps --filter "image=sonarqube" --format "{{.Names}}" 2>/dev/null || true)
fi

if [ -z "$SONARQUBE_CONTAINERS" ]; then
    echo "No SonarQube containers found."
    echo ""
    echo "Please ensure your SonarQube container is running with volumes:"
    echo "  - sonarqube_data:/opt/sonarqube/data"
    echo "  - sonarqube_extensions:/opt/sonarqube/extensions"
    echo "  - sonarqube_logs:/opt/sonarqube/logs"
    echo "  - sonarqube_temp:/opt/sonarqube/temp"
    echo ""
    echo "You can start it using: docker-compose up -d"
    exit 1
fi

echo "Found SonarQube containers:"
echo "$SONARQUBE_CONTAINERS"
echo ""

# If multiple containers, let user choose
if [ $(echo "$SONARQUBE_CONTAINERS" | wc -l) -gt 1 ]; then
    echo "Multiple SonarQube containers found. Please select one:"
    select CONTAINER in $SONARQUBE_CONTAINERS; do
        if [ -n "$CONTAINER" ]; then
            break
        fi
    done
else
    CONTAINER=$(echo "$SONARQUBE_CONTAINERS" | head -n1)
fi

echo "Selected container: $CONTAINER"

# Check if container is running
if ! docker ps --format "{{.Names}}" | grep -q "^$CONTAINER$"; then
    echo "Error: Container '$CONTAINER' is not running"
    exit 1
fi

# Get container info
echo "Container info:"
docker inspect --format='{{.Name}} - {{.Config.Image}} - {{.State.Status}}' "$CONTAINER"

echo ""
echo "Deploying plugin to container: $CONTAINER"

# Method 1: Direct copy to container (works with any volume setup)
echo "Method 1: Copying plugin directly to container..."

# Stop the container
echo "Stopping SonarQube container..."
docker stop "$CONTAINER"

# Copy plugin to container
echo "Copying plugin to container..."
docker cp "$JAR_FILE" "$CONTAINER:/opt/sonarqube/extensions/plugins/"

# Start the container
echo "Starting SonarQube container..."
docker start "$CONTAINER"

echo ""
echo "✅ Plugin deployed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Wait for SonarQube to fully start (this may take a few minutes)"
echo "2. Check container logs: docker logs -f $CONTAINER"
echo "3. Access SonarQube at the container's exposed port"
echo "4. Go to Quality Profiles in SonarQube"
echo "5. Find 'Custom Java Rules' and activate the 'NoTodoComments' rule"
echo ""
echo "🔍 Useful commands:"
echo "  Check logs:     docker logs -f $CONTAINER"
echo "  Check ports:    docker port $CONTAINER"
echo "  Container info: docker inspect $CONTAINER"
echo "  Restart:        docker restart $CONTAINER"
echo ""
echo "📁 Plugin location in container: /opt/sonarqube/extensions/plugins/$(basename $JAR_FILE)"

# Method 2: Alternative - Copy to volume (if you know the volume name)
echo ""
echo "💡 Alternative deployment methods:"
echo ""
echo "If you want to copy to the volume directly, you can also use:"
echo "  docker run --rm -v sonarqube_extensions:/extensions -v \$(pwd)/target:/source alpine cp /source/sonarqube-custom-rules-1.0.0.jar /extensions/plugins/"
echo ""
echo "Or if using docker-compose:"
echo "  docker-compose exec sonarqube mkdir -p /opt/sonarqube/extensions/plugins"
echo "  docker cp target/sonarqube-custom-rules-1.0.0.jar \$(docker-compose ps -q sonarqube):/opt/sonarqube/extensions/plugins/"
echo "  docker-compose restart sonarqube"
