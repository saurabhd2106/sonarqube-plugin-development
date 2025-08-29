# SonarQube Custom Rules Plugin - Deployment Guide

This guide provides step-by-step instructions for deploying the custom SonarQube plugin.

## Prerequisites

- Java 11 or higher
- Maven 3.6 or higher
- SonarQube 9.x or higher
- Access to SonarQube installation directory

## Quick Start

### 1. Build the Plugin

```bash
# Clone or download the project
cd workspace-sonarqube-plugins

# Build the plugin
mvn clean package
```

The plugin JAR will be created at: `target/sonarqube-custom-rules-1.0.0.jar`

### 2. Deploy to SonarQube

#### Option A: Using the Deployment Script

```bash
# Make the script executable (if not already)
chmod +x deploy.sh

# Run the deployment script
./deploy.sh
```

The script will prompt you for your SonarQube installation path and handle the deployment automatically.

#### Option B: Manual Deployment

1. **Stop SonarQube** if it's running
2. **Copy the plugin JAR** to SonarQube's plugins directory:
   ```bash
   cp target/sonarqube-custom-rules-1.0.0.jar /path/to/sonarqube/extensions/plugins/
   ```
3. **Start SonarQube**

### 3. Activate the Rules

1. **Access SonarQube** (typically at http://localhost:9000)
2. **Go to Quality Profiles** (Administration → Quality Profiles)
3. **Select your Java profile** (or create a new one)
4. **Find "Custom Java Rules"** in the rules list
5. **Activate the "NoTodoComments" rule** and set the desired severity
6. **Set as default** if you want this profile to be used by default

## Testing the Plugin

### Using Docker Compose (Recommended for Testing)

```bash
# Start SonarQube using Docker Compose
docker-compose up -d

# Wait for SonarQube to start (check logs)
docker-compose logs -f sonarqube

# Deploy the plugin to the Docker container
docker cp target/sonarqube-custom-rules-1.0.0.jar sonarqube-plugins_sonarqube_1:/opt/sonarqube/extensions/plugins/

# Restart the container
docker-compose restart sonarqube
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
│   ├── CustomRulesProfile.java         # Quality profile definition
│   ├── NoTodoCommentsRule.java         # TODO comments detection rule
│   └── ExampleRule.java                # Example of additional rule
├── test/java/com/example/sonarqube/
│   └── NoTodoCommentsRuleTest.java     # Unit tests
└── test/files/
    ├── NoTodoCommentsRule.java         # Test file with TODO comments
    └── NoTodoCommentsRuleValid.java    # Test file without TODO comments
```

## Adding New Rules

To add a new rule to the plugin:

1. **Create a new rule class** following the pattern in `ExampleRule.java`
2. **Register it** in `CustomRulesPlugin.java`
3. **Add it to the repository** in `CustomRulesRepository.java`
4. **Write unit tests**
5. **Rebuild and redeploy** the plugin

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

2. **Rules not appearing**
   - Check that the plugin is properly installed
   - Verify the quality profile is activated
   - Check SonarQube version compatibility

3. **Build failures**
   - Verify Java and Maven versions
   - Check that all dependencies are available
   - Run `mvn clean` and try again

### Logs

Check these log files for issues:
- `logs/sonar.log` - General SonarQube logs
- `logs/web.log` - Web interface logs
- `logs/ce.log` - Compute Engine logs

### Version Compatibility

This plugin is designed for:
- SonarQube 9.x and higher
- Java 11 or higher
- Maven 3.6 or higher

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review SonarQube documentation
3. Check the plugin logs for error messages

## License

This project is licensed under the MIT License.
