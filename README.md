# SonarQube Custom Rules Plugin

This is a SonarQube plugin that provides custom Java rules. Currently, it includes a rule to detect TODO comments in Java code.

## Features

- **NoTodoComments Rule**: Detects TODO comments in Java code and flags them as code smells
- Easy to extend with additional custom rules
- Comprehensive unit tests
- Maven-based build system

## Project Structure

```
src/
├── main/java/com/example/sonarqube/
│   ├── CustomRulesPlugin.java          # Main plugin class
│   ├── CustomRulesRepository.java      # Rules repository definition
│   ├── CustomRulesProfile.java         # Quality profile definition
│   └── NoTodoCommentsRule.java         # TODO comments detection rule
├── test/java/com/example/sonarqube/
│   └── NoTodoCommentsRuleTest.java     # Unit tests
└── test/files/
    ├── NoTodoCommentsRule.java         # Test file with TODO comments
    └── NoTodoCommentsRuleValid.java    # Test file without TODO comments
```

## Building the Plugin

### Prerequisites

- Java 11 or higher
- Maven 3.6 or higher
- SonarQube 10.4 (for compatibility)
- Docker (for extracting dependencies)

### First-Time Setup

**Important**: This project uses SonarQube API dependencies that are extracted from a running SonarQube container. You need to run the setup script before building:

```bash
# Make sure you have a SonarQube container running
docker run -d --name sonarqube -p 9000:9000 sonarqube:community

# Run the dependency setup script
./setup-dependencies.sh
```

This script will:
- Find your running SonarQube container
- Extract the required API JAR files to the `lib/` directory
- Verify the files are correctly extracted

**Note**: The `lib/` directory is gitignored and should not be committed to version control.

### Build Commands

```bash
# Clean and compile
mvn clean compile

# Run tests
mvn test

# Package the plugin
mvn package
```

The plugin JAR will be created in the `target/` directory.

## Installing the Plugin

### Option 1: Using Deployment Scripts

#### For Docker Containers:
```bash
# Build the plugin
mvn clean package

# Deploy to Docker container
./deploy-docker.sh
```

#### For Local Installation:
```bash
# Build the plugin
mvn clean package

# Deploy using the general script
./deploy.sh
```

### Option 2: Manual Installation

1. **Stop SonarQube** if it's running
2. **Copy the plugin JAR** from `target/sonarqube-custom-rules-1.0.0.jar` to SonarQube's `extensions/plugins/` directory
3. **Start SonarQube**
4. **Verify installation** by checking the Rules section in SonarQube

### For Docker with Named Volumes

If your SonarQube is running with Docker volumes like:
```yaml
volumes:
  - sonarqube_data:/opt/sonarqube/data
  - sonarqube_extensions:/opt/sonarqube/extensions
  - sonarqube_logs:/opt/sonarqube/logs
  - sonarqube_temp:/opt/sonarqube/temp
```

Use the `deploy-docker.sh` script which will automatically:
- Find your SonarQube container
- Stop it
- Copy the plugin to the correct location
- Restart the container

## Activating Rules

1. **Go to Quality Profiles** in SonarQube
2. **Select your Java profile** (or create a new one)
3. **Find "Custom Java Rules"** in the rules list
4. **Activate the "NoTodoComments" rule** and set the desired severity
5. **Set as default** if you want this profile to be used by default

## Adding New Rules

To add a new rule:

1. **Create a new rule class** extending `IssuableSubscriptionVisitor`
2. **Annotate it** with `@Rule` annotation
3. **Register it** in `CustomRulesPlugin.java`
4. **Add it to the repository** in `CustomRulesRepository.java`
5. **Write unit tests** for the rule
6. **Rebuild and redeploy** the plugin

### Example Rule Structure

```java
@Rule(
    key = "YourRuleKey",
    name = "Your Rule Name",
    description = "Description of what the rule does",
    priority = Severity.MAJOR,
    tags = {"tag1", "tag2"}
)
public class YourRule extends IssuableSubscriptionVisitor {
    
    @Override
    public List<Tree.Kind> nodesToVisit() {
        return Arrays.asList(Tree.Kind.METHOD, Tree.Kind.CLASS);
    }
    
    @Override
    public void visitNode(Tree tree) {
        // Your rule logic here
        if (condition) {
            reportIssue(tree, "Issue message");
        }
    }
}
```

## Testing

The project includes comprehensive unit tests:

```bash
# Run all tests
mvn test

# Run specific test
mvn test -Dtest=NoTodoCommentsRuleTest
```

## Configuration

The plugin supports configuration through SonarQube properties:

- `custom.rules.enabled`: Enable/disable custom rules (default: true)

## Troubleshooting

### Common Issues

1. **Plugin not loading**: Check SonarQube logs for errors
2. **Rules not appearing**: Ensure the plugin is properly installed and SonarQube is restarted
3. **Build failures**: Verify Java and Maven versions are compatible

### Logs

Check SonarQube logs in:
- `logs/sonar.log` for general SonarQube logs
- `logs/web.log` for web interface logs

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your changes
4. Write tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
