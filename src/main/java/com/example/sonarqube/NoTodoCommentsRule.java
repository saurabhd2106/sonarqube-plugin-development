package com.example.sonarqube;

import java.util.regex.Pattern;

/**
 * Example SonarQube rule for detecting TODO comments in Java code.
 * 
 * This class demonstrates the structure of a SonarQube rule that would
 * normally extend IssuableSubscriptionVisitor and be annotated with @Rule.
 * 
 * In a real SonarQube plugin, this would:
 * - Extend org.sonar.plugins.java.api.IssuableSubscriptionVisitor
 * - Be annotated with @Rule(key="NoTodoComments", name="...", etc.)
 * - Override nodesToVisit() to specify which AST nodes to analyze
 * - Override visitNode() to implement the rule logic
 */
public class NoTodoCommentsRule {
    
    private static final Pattern TODO_PATTERN = Pattern.compile("\\bTODO\\b", Pattern.CASE_INSENSITIVE);
    
    /**
     * Rule key - used to identify this rule in SonarQube
     */
    public static final String RULE_KEY = "NoTodoComments";
    
    /**
     * Rule name - displayed in SonarQube UI
     */
    public static final String RULE_NAME = "TODO comments should not be used";
    
    /**
     * Rule description - explains what the rule does
     */
    public static final String RULE_DESCRIPTION = 
        "TODO comments indicate incomplete work and should be replaced with proper issue tracking.";
    
    /**
     * Example method that would be called by SonarQube to check for TODO comments.
     * In a real implementation, this would be the visitNode() method.
     * 
     * @param code The Java code to analyze
     * @return true if TODO comments are found, false otherwise
     */
    public boolean hasTodoComments(String code) {
        return TODO_PATTERN.matcher(code).find();
    }
    
    /**
     * Example method that would report an issue in SonarQube.
     * In a real implementation, this would call reportIssue().
     * 
     * @param message The issue message to report
     */
    public void reportIssue(String message) {
        System.out.println("ISSUE: " + message);
    }
    

}
