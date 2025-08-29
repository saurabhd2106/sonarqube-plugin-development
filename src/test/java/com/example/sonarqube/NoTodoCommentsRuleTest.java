package com.example.sonarqube;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class NoTodoCommentsRuleTest {

    @Test
    void testHasTodoCommentsWithTodo() {
        NoTodoCommentsRule rule = new NoTodoCommentsRule();
        
        String codeWithTodo = "// TODO: This should be flagged";
        assertTrue(rule.hasTodoComments(codeWithTodo));
        
        String codeWithBlockTodo = "/* TODO: This is a block comment with TODO */";
        assertTrue(rule.hasTodoComments(codeWithBlockTodo));
        
        String codeWithMixedCase = "// todo: This should also be flagged";
        assertTrue(rule.hasTodoComments(codeWithMixedCase));
    }

    @Test
    void testHasTodoCommentsWithoutTodo() {
        NoTodoCommentsRule rule = new NoTodoCommentsRule();
        
        String codeWithoutTodo = "// This is a regular comment";
        assertFalse(rule.hasTodoComments(codeWithoutTodo));
        
        String codeWithOtherText = "// This contains the word COMPLETE";
        assertFalse(rule.hasTodoComments(codeWithOtherText));
    }

    @Test
    void testRuleConstants() {
        assertEquals("NoTodoComments", NoTodoCommentsRule.RULE_KEY);
        assertEquals("TODO comments should not be used", NoTodoCommentsRule.RULE_NAME);
        assertTrue(NoTodoCommentsRule.RULE_DESCRIPTION.contains("incomplete work"));
    }
}
