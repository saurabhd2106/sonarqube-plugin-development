#!/bin/bash

# SonarQube Custom Rules Plugin Deployment Script

set -e

echo "SonarQube Custom Rules Plugin Deployment"
echo "========================================"

# Check if JAR exists
JAR_FILE="target/sonarqube-custom-rules-1.0.0.jar"
if [ ! -f "$JAR_FILE" ]; then
    echo "Error: Plugin JAR not found. Please run 'mvn package' first."
    exit 1
fi

echo "Plugin JAR found: $JAR_FILE"

# Check if Docker is available
if command -v docker &> /dev/null; then
    echo "Docker detected. Checking for running SonarQube containers..."
    
    # Find running SonarQube containers
    SONARQUBE_CONTAINERS=$(docker ps --filter "ancestor=sonarqube" --format "{{.Names}}" 2>/dev/null || true)
    
    if [ -n "$SONARQUBE_CONTAINERS" ]; then
        echo "Found running SonarQube containers:"
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
        
        # Deploy to Docker container
        echo "Deploying plugin to Docker container..."
        
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
        echo "Plugin deployed successfully to Docker container!"
        echo ""
        echo "Next steps:"
        echo "1. Wait for SonarQube to fully start (check logs with: docker logs -f $CONTAINER)"
        echo "2. Access SonarQube at the container's exposed port"
        echo "3. Go to Quality Profiles in SonarQube"
        echo "4. Find 'Custom Java Rules' and activate the 'NoTodoComments' rule"
        echo ""
        echo "To check container logs: docker logs -f $CONTAINER"
        echo "To access SonarQube: docker port $CONTAINER"
        
    else
        echo "No running SonarQube containers found."
        echo "Please start your SonarQube container first, then run this script again."
        exit 1
    fi
    
else
    echo "Docker not found. Using manual deployment method..."
    echo ""
    
    # Manual deployment for non-Docker installations
    echo "Please provide the path to your SonarQube installation:"
    echo "Example: /opt/sonarqube"
    read -p "SonarQube path: " SONARQUBE_PATH

    if [ ! -d "$SONARQUBE_PATH" ]; then
        echo "Error: SonarQube directory not found: $SONARQUBE_PATH"
        exit 1
    fi

    PLUGINS_DIR="$SONARQUBE_PATH/extensions/plugins"

    if [ ! -d "$PLUGINS_DIR" ]; then
        echo "Creating plugins directory: $PLUGINS_DIR"
        mkdir -p "$PLUGINS_DIR"
    fi

    # Copy plugin
    echo "Copying plugin to: $PLUGINS_DIR"
    cp "$JAR_FILE" "$PLUGINS_DIR/"

    echo ""
    echo "Plugin deployed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Stop SonarQube if it's running"
    echo "2. Start SonarQube"
    echo "3. Go to Quality Profiles in SonarQube"
    echo "4. Find 'Custom Java Rules' and activate the 'NoTodoComments' rule"
    echo ""
    echo "Plugin will be available at: $PLUGINS_DIR/$(basename $JAR_FILE)"
fi
