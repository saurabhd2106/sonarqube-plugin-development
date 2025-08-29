package com.example.sonarqube;

import org.sonar.api.Plugin;

/**
 * Main plugin class for SonarQube Custom Rules Plugin.
 * 
 * This class implements the SonarQube Plugin interface to register
 * all the rules, repositories, and profiles.
 */
public class CustomRulesPlugin implements Plugin {
    
    public static final String REPOSITORY_KEY = "custom-java-rules";
    public static final String REPOSITORY_NAME = "Custom Java Rules";
    
    /**
     * Plugin entry point - this method is called by SonarQube
     * to register all plugin components.
     */
    @Override
    public void define(Context context) {
        // Register the plugin components
        context.addExtensions(
            // Rules
            NoTodoCommentsRule.class,
            
            // Repository
            CustomRulesRepository.class
        );
    }
}
