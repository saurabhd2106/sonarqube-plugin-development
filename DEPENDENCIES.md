# SonarQube Dependencies Management

## Overview

This project uses SonarQube API dependencies that are not publicly available through Maven Central. Instead, we extract these dependencies directly from a running SonarQube container.

## Why This Approach?

1. **SonarQube API is not publicly available**: SonarSource doesn't publish their API to public Maven repositories
2. **Version compatibility**: Using the exact same version as your SonarQube instance ensures compatibility
3. **Legal compliance**: Extracting from your own SonarQube installation avoids redistribution issues

## Dependencies Used

- **sonar-application-25.8.0.112029.jar**: Contains the core SonarQube API classes
- **sonar-java-plugin-8.18.0.40025.jar**: Contains the Java plugin API classes

## Setup Process

### Automatic Setup (Recommended)

```bash
# 1. Start a SonarQube container
docker run -d --name sonarqube -p 9000:9000 sonarqube:community

# 2. Run the setup script
./setup-dependencies.sh

# 3. Build the project
mvn clean package
```

### Manual Setup

If you prefer to extract dependencies manually:

```bash
# 1. Create lib directory
mkdir -p lib

# 2. Extract from your SonarQube container
docker cp sonarqube:/opt/sonarqube/lib/sonar-application-25.8.0.112029.jar lib/
docker cp sonarqube:/opt/sonarqube/lib/extensions/sonar-java-plugin-8.18.0.40025.jar lib/
```

## Maven Configuration

The dependencies are configured in `pom.xml` using the `system` scope:

```xml
<dependency>
    <groupId>org.sonarsource.sonarqube</groupId>
    <artifactId>sonar-plugin-api</artifactId>
    <version>25.8.0</version>
    <scope>system</scope>
    <systemPath>${project.basedir}/lib/sonar-application-25.8.0.112029.jar</systemPath>
</dependency>
```

## Version Compatibility

| SonarQube Version | Plugin API Version | Java Plugin Version |
|-------------------|-------------------|-------------------|
| 25.8.0           | 25.8.0           | 8.18.0           |
| 10.4             | 10.4             | 7.16              |

**Note**: Always use the same version as your SonarQube instance.

## Troubleshooting

### "Dependencies not found" error

1. Make sure SonarQube container is running
2. Run `./setup-dependencies.sh` again
3. Check that files exist in `lib/` directory

### "Class not found" errors

1. Verify the JAR files are correctly extracted
2. Check that the versions match your SonarQube instance
3. Re-run the setup script

### Build warnings about system dependencies

These warnings are expected and can be ignored. The system dependencies are necessary for this project structure.

## Git Ignore

The `lib/` directory is gitignored because:

1. **Large file size**: JAR files are too large for Git
2. **Version-specific**: Different users may have different SonarQube versions
3. **Easy to recreate**: The setup script makes it simple to extract dependencies

## Alternative Approaches

### Using Maven Repository (Not Recommended)

While some SonarQube artifacts are available in SonarSource's repository, they often have access restrictions and may not include all required classes.

### Bundling Dependencies (Not Recommended)

Bundling SonarQube dependencies in the plugin JAR can cause class loading conflicts and is not recommended.

## Best Practices

1. **Always use the setup script**: It handles version detection and error checking
2. **Keep versions in sync**: Use the same SonarQube version for development and deployment
3. **Don't commit lib/**: The directory should remain in `.gitignore`
4. **Document your version**: Update this file if you change SonarQube versions
