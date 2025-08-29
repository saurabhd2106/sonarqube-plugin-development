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

# Get SonarQube plugins directory
echo ""
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
