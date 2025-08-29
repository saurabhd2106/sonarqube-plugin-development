package com.example.sonarqube;

/**
 * Example SonarQube quality profile class.
 * 
 * This class demonstrates the structure of a SonarQube quality profile that would
 * normally extend ProfileDefinition.
 * 
 * In a real SonarQube plugin, this would:
 * - Extend org.sonar.api.profiles.ProfileDefinition
 * - Override createProfile() method to define the profile
 * - Set default rules and their severities
 */
public class CustomRulesProfile {
    
    /**
     * Example method that would be called by SonarQube to create the quality profile.
     * In a real implementation, this would be the createProfile() method.
     */
    public void createProfile() {
        // In a real plugin, this would:
        // - Create a new RulesProfile
        // - Set profile metadata (name, language, etc.)
        // - Add rules with their severities
        // - Set as default profile if needed
        System.out.println("Creating Custom Rules Quality Profile");
    }
}
