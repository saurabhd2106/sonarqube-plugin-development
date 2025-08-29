# SonarQube Custom Rules Plugin - Deployment Guide

This guide provides step-by-step instructions for deploying the custom SonarQube plugin.

## Prerequisites

- Java 11 or higher
- Maven 3.6 or higher
- SonarQube 10.4 or higher (tested with 25.8.0)
- Docker (for dependency extraction and containerized deployment)
- Access to SonarQube installation directory

## Quick Start

### 1. Setup Dependencies (First Time Only)

**Important**: This project uses SonarQube API dependencies that need to be extracted from a running SonarQube container.

```bash
# Clone the repository
git clone <your-repo-url>
cd sonarqube-custom-rules

# Start a SonarQube container (if not already running)
docker run -d --name sonarqube -p 9000:9000 sonarqube:community

# Extract dependencies from the container
./setup-dependencies.sh
```

This script will:
- Find your running SonarQube container
- Extract required API JAR files to the `lib/` directory
- Verify the files are correctly extracted

### 2. Build the Plugin

```bash
# Build the plugin
mvn clean package
```

The plugin JAR will be created at: `target/sonarqube-custom-rules-1.0.0.jar`

### 3. Deploy to SonarQube

#### Option A: Using Docker Deployment Script (Recommended)

```bash
# Deploy to Docker container
./deploy-docker.sh
```

This script will:
- Automatically find your SonarQube container
- Stop the container
- Copy the plugin to the correct location
- Restart the container
- Provide helpful next steps

#### Option B: Using General Deployment Script

```bash
# Make the script executable (if not already)
chmod +x deploy.sh

# Run the deployment script
./deploy.sh
```

The script will auto-detect Docker containers or prompt you for your SonarQube installation path.

#### Option C: Manual Deployment

1. **Stop SonarQube** if it's running
2. **Copy the plugin JAR** to SonarQube's plugins directory:
   ```bash
   cp target/sonarqube-custom-rules-1.0.0.jar /path/to/sonarqube/extensions/plugins/
   ```
3. **Start SonarQube**

### 4. Activate the Rules

1. **Access SonarQube** (typically at http://localhost:9000)
2. **Wait for SonarQube to fully start** (check container logs if using Docker)
3. **Go to Quality Profiles** (Administration → Quality Profiles)
4. **Select your Java profile** (or create a new one)
5. **Find "Custom Java Rules"** in the rules list
6. **Activate the "NoTodoComments" rule** and set the desired severity
7. **Set as default** if you want this profile to be used by default

### 5. Verify Installation

Check SonarQube logs to confirm successful plugin deployment:
```bash
# For Docker containers
docker logs sonarqube | grep "Custom Java Rules"

# For local installations
tail -f logs/sonar.log | grep "Custom Java Rules"
```

You should see: `Deploy Custom Java Rules / 1.0.0 / null`

## Testing the Plugin

### Using Docker Compose (Recommended for Testing)

```bash
# Start SonarQube using Docker Compose
docker-compose up -d

# Wait for SonarQube to start (check logs)
docker-compose logs -f sonarqube

# Setup dependencies (first time only)
./setup-dependencies.sh

# Build the plugin
mvn clean package

# Deploy using the Docker script
./deploy-docker.sh
```

### Using Docker with Named Volumes

If your SonarQube is running with named volumes like:
```yaml
volumes:
  - sonarqube_data:/opt/sonarqube/data
  - sonarqube_extensions:/opt/sonarqube/extensions
  - sonarqube_logs:/opt/sonarqube/logs
  - sonarqube_temp:/opt/sonarqube/temp
```

The `deploy-docker.sh` script will automatically handle this:

```bash
# Build the plugin
mvn clean package

# Deploy using the Docker script
./deploy-docker.sh
```

The script will:
- Find your SonarQube container
- Stop it safely
- Copy the plugin to the correct location
- Restart the container
- Provide helpful next steps

**Alternative manual method:**
```bash
# Find your SonarQube container
docker ps --filter "ancestor=sonarqube"

# Stop the container
docker stop <container_name>

# Copy plugin to container
docker cp target/sonarqube-custom-rules-1.0.0.jar <container_name>:/opt/sonarqube/extensions/plugins/

# Start the container
docker start <container_name>
```

### Manual Testing

1. **Create a test Java file** with TODO comments:
   ```java
   public class TestClass {
       // TODO: This should be flagged
       public void method() {
           System.out.println("Hello");
       }
   }
   ```

2. **Run SonarQube analysis** on the test file
3. **Check the results** - you should see the TODO comment flagged

## Plugin Structure

```
src/
├── main/java/com/example/sonarqube/
│   ├── CustomRulesPlugin.java          # Main plugin class
│   ├── CustomRulesRepository.java      # Rules repository definition
│   └── NoTodoCommentsRule.java         # TODO comments detection rule
├── test/java/com/example/sonarqube/
│   └── NoTodoCommentsRuleTest.java     # Unit tests
└── test/files/
    ├── NoTodoCommentsRule.java         # Test file with TODO comments
    └── NoTodoCommentsRuleValid.java    # Test file without TODO comments
```

**Note**: The `CustomRulesProfile.java` was removed as it's not compatible with newer SonarQube versions.

## Adding New Rules

To add a new rule to the plugin:

1. **Create a new rule class** extending `IssuableSubscriptionVisitor`
2. **Annotate it** with `@Rule` annotation
3. **Register it** in `CustomRulesPlugin.java`
4. **Add it to the repository** in `CustomRulesRepository.java`
5. **Write unit tests**
6. **Rebuild and redeploy** the plugin

### Example: Adding a Security Rule

```java
@Rule(
    key = "NoHardcodedPasswords",
    name = "Hardcoded passwords should not be used",
    description = "Hardcoded passwords in source code are a security risk.",
    priority = Severity.BLOCKER,
    tags = {"security", "java"}
)
public class NoHardcodedPasswordsRule extends IssuableSubscriptionVisitor {
    
    @Override
    public List<Tree.Kind> nodesToVisit() {
        return Arrays.asList(Tree.Kind.STRING_LITERAL);
    }
    
    @Override
    public void visitNode(Tree tree) {
        // Check for hardcoded passwords
        if (hasHardcodedPassword(tree)) {
            reportIssue(tree, "Remove hardcoded password and use environment variables instead.");
        }
    }
}
```

## Troubleshooting

### Common Issues

1. **Plugin not loading**
   - Check SonarQube logs: `logs/sonar.log`
   - Verify JAR file is in the correct location
   - Ensure SonarQube was restarted after deployment
   - Check for `ClassCastException` errors (indicates missing dependencies)

2. **Rules not appearing**
   - Check that the plugin is properly installed
   - Verify the quality profile is activated
   - Check SonarQube version compatibility
   - Ensure dependencies are properly extracted

3. **Build failures**
   - Verify Java and Maven versions
   - Check that all dependencies are available in `lib/` directory
   - Run `./setup-dependencies.sh` to extract missing dependencies
   - Run `mvn clean` and try again

4. **Dependency issues**
   - Ensure SonarQube container is running before running `setup-dependencies.sh`
   - Check that the correct JAR files are extracted to `lib/` directory
   - Verify SonarQube version compatibility

### Logs

Check these log files for issues:
- `logs/sonar.log` - General SonarQube logs
- `logs/web.log` - Web interface logs
- `logs/ce.log` - Compute Engine logs

### Version Compatibility

This plugin is designed for:
- SonarQube 10.4 and higher (tested with 25.8.0)
- Java 11 or higher
- Maven 3.6 or higher

**Note**: The plugin uses system dependencies extracted from your SonarQube installation, so version compatibility is automatically ensured.

## Dependency Management

### Understanding Dependencies

This project uses SonarQube API dependencies that are not publicly available. Instead, we extract them from your running SonarQube container:

- **sonar-application-25.8.0.112029.jar**: Core SonarQube API classes
- **sonar-java-plugin-8.18.0.40025.jar**: Java plugin API classes

### Setup Script

The `setup-dependencies.sh` script automates the extraction process:

```bash
./setup-dependencies.sh
```

This script will:
- Find your running SonarQube container
- Extract the required JAR files
- Verify the extraction was successful
- Provide next steps

### Manual Extraction

If you prefer manual extraction:

```bash
# Create lib directory
mkdir -p lib

# Extract from your SonarQube container
docker cp sonarqube:/opt/sonarqube/lib/sonar-application-25.8.0.112029.jar lib/
docker cp sonarqube:/opt/sonarqube/lib/extensions/sonar-java-plugin-8.18.0.40025.jar lib/
```

### Git Ignore

The `lib/` directory is gitignored because:
- JAR files are too large for Git
- Different users may have different SonarQube versions
- The setup script makes it easy to recreate

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review the `DEPENDENCIES.md` file for detailed dependency information
3. Review SonarQube documentation
4. Check the plugin logs for error messages

## License

This project is licensed under the MIT License.
