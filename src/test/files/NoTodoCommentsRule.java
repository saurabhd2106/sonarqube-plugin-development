package com.example;

public class TestClass {
    
    // TODO: This should be flagged
    public void methodWithTodo() {
        // TODO: Another todo comment
        System.out.println("Hello World");
    }
    
    /* TODO: This is a block comment with TODO */
    public void anotherMethod() {
        // This is a regular comment
        System.out.println("No TODO here");
    }
}
