package com.example.sonarqube;

/**
 * Main plugin class for SonarQube Custom Rules Plugin.
 * 
 * This class would normally extend SonarQube's Plugin interface and register
 * all the rules, repositories, and profiles. For demonstration purposes,
 * this is a simplified version.
 * 
 * In a real SonarQube plugin, this would implement org.sonar.api.Plugin
 * and register all components in the define() method.
 */
public class CustomRulesPlugin {
    
    public static final String REPOSITORY_KEY = "custom-java-rules";
    public static final String REPOSITORY_NAME = "Custom Java Rules";
    
    /**
     * Plugin entry point - this method would be called by SonarQube
     * to register all plugin components.
     */
    public void define() {
        // In a real plugin, this would register:
        // - Rules (NoTodoCommentsRule.class)
        // - Repository (CustomRulesRepository.class)
        // - Profile (CustomRulesProfile.class)
        System.out.println("Custom Rules Plugin loaded");
    }
}
