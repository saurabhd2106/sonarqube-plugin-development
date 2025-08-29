package com.example.sonarqube;

import java.util.regex.Pattern;

/**
 * Example of how to add a new SonarQube rule.
 * 
 * This class demonstrates the structure for creating additional rules.
 * To use this in a real SonarQube plugin:
 * 
 * 1. Extend IssuableSubscriptionVisitor
 * 2. Add @Rule annotation with proper metadata
 * 3. Override nodesToVisit() to specify which AST nodes to analyze
 * 4. Override visitNode() to implement the rule logic
 * 5. Register the rule in CustomRulesPlugin.java
 * 6. Add it to CustomRulesRepository.java
 * 7. Write unit tests
 * 
 * Example: This rule would detect hardcoded passwords in Java code
 */
public class ExampleRule {
    
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
        "password\\s*=\\s*[\"'][^\"']*[\"']", 
        Pattern.CASE_INSENSITIVE
    );
    
    /**
     * Rule key - used to identify this rule in SonarQube
     */
    public static final String RULE_KEY = "NoHardcodedPasswords";
    
    /**
     * Rule name - displayed in SonarQube UI
     */
    public static final String RULE_NAME = "Hardcoded passwords should not be used";
    
    /**
     * Rule description - explains what the rule does
     */
    public static final String RULE_DESCRIPTION = 
        "Hardcoded passwords in source code are a security risk. " +
        "Use environment variables or secure configuration management instead.";
    
    /**
     * Example method that would be called by SonarQube to check for hardcoded passwords.
     * In a real implementation, this would be the visitNode() method.
     * 
     * @param code The Java code to analyze
     * @return true if hardcoded passwords are found, false otherwise
     */
    public boolean hasHardcodedPassword(String code) {
        return PASSWORD_PATTERN.matcher(code).find();
    }
    
    /**
     * Example method that would report an issue in SonarQube.
     * In a real implementation, this would call reportIssue().
     * 
     * @param message The issue message to report
     */
    public void reportIssue(String message) {
        System.out.println("SECURITY ISSUE: " + message);
    }
}
