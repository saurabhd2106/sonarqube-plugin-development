package com.example.sonarqube;

import org.sonar.api.server.rule.RulesDefinition;
import org.sonar.api.server.rule.RulesDefinitionAnnotationLoader;
import org.sonar.plugins.java.Java;

/**
 * SonarQube rules repository class.
 * 
 * This class implements the RulesDefinition interface to define
 * the custom rules repository.
 */
public class CustomRulesRepository implements RulesDefinition {
    
    public static final String REPOSITORY_KEY = CustomRulesPlugin.REPOSITORY_KEY;
    public static final String REPOSITORY_NAME = CustomRulesPlugin.REPOSITORY_NAME;
    
    /**
     * Method called by SonarQube to define the rules repository.
     */
    @Override
    public void define(Context context) {
        // Create a new repository for Java language
        NewRepository repository = context
            .createRepository(REPOSITORY_KEY, Java.KEY)
            .setName(REPOSITORY_NAME);
        
        // Load rules using annotation loader
        RulesDefinitionAnnotationLoader annotationLoader = new RulesDefinitionAnnotationLoader();
        annotationLoader.load(repository, NoTodoCommentsRule.class);
        
        repository.done();
    }
}
