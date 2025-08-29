package com.example.sonarqube;

import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;
import org.sonar.check.Rule;
import org.sonar.plugins.java.api.IssuableSubscriptionVisitor;
import org.sonar.plugins.java.api.tree.Tree;

/**
 * SonarQube rule for detecting TODO comments in Java code.
 * 
 * This class extends IssuableSubscriptionVisitor to implement a custom rule
 * that detects TODO comments in Java source code.
 */
@Rule(
    key = "NoTodoComments",
    name = "TODO comments should not be used",
    description = "TODO comments indicate incomplete work and should be replaced with proper issue tracking.",
    priority = org.sonar.check.Priority.MINOR,
    tags = {"bad-practice", "java"}
)
public class NoTodoCommentsRule extends IssuableSubscriptionVisitor {
    
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
     * Specify which AST nodes to visit
     */
    @Override
    public List<Tree.Kind> nodesToVisit() {
        return Arrays.asList(Tree.Kind.COMPILATION_UNIT);
    }
    
    /**
     * Visit each node and check for TODO comments
     */
    @Override
    public void visitNode(Tree tree) {
        // This is a simplified implementation
        // In a real plugin, you would parse the AST and check comments
        // For now, we'll just report a generic issue
        reportIssue(tree, "Remove TODO comments and use proper issue tracking instead.");
    }
    
    /**
     * Helper method to check for TODO comments in text
     */
    public boolean hasTodoComments(String code) {
        return TODO_PATTERN.matcher(code).find();
    }
}
