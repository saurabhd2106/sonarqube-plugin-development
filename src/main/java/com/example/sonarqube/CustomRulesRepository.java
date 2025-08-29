package com.example.sonarqube;

/**
 * Example SonarQube rules repository class.
 * 
 * This class demonstrates the structure of a SonarQube rules repository that would
 * normally implement RulesDefinition interface.
 * 
 * In a real SonarQube plugin, this would:
 * - Implement org.sonar.api.server.rule.RulesDefinition
 * - Override define() method to create the repository
 * - Register all rules using RulesDefinitionAnnotationLoader
 */
public class CustomRulesRepository {
    
    public static final String REPOSITORY_KEY = CustomRulesPlugin.REPOSITORY_KEY;
    public static final String REPOSITORY_NAME = CustomRulesPlugin.REPOSITORY_NAME;
    
    /**
     * Example method that would be called by SonarQube to define the rules repository.
     * In a real implementation, this would be the define() method.
     */
    public void define() {
        // In a real plugin, this would:
        // - Create a new repository with context.createRepository()
        // - Load rules using RulesDefinitionAnnotationLoader
        // - Set repository metadata (name, description, etc.)
        System.out.println("Defining Custom Rules Repository: " + REPOSITORY_NAME);
    }
}
