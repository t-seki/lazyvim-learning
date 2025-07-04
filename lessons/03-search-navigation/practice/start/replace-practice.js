// Replace Practice JavaScript File
// ===============================

// Task 1: Replace all 'var' with 'const'
var userName = "john_doe";
var userAge = 25;
var userEmail = "john@example.com";
var isActive = true;

// Task 2: Replace all 'oldFunction' with 'newFunction'
function oldFunction(param) {
    return param * 2;
}

const result1 = oldFunction(5);
const result2 = oldFunction(10);
console.log("Results:", oldFunction(15));

// Task 3: Replace 'getElementById' with 'querySelector'
document.getElementById('header');
document.getElementById('content');
document.getElementById('footer');
document.getElementById('sidebar');

// Task 4: Update API endpoints from v1 to v2
const apiUrl1 = "https://api.example.com/v1/users";
const apiUrl2 = "https://api.example.com/v1/posts";
const apiUrl3 = "https://api.example.com/v1/comments";

// Task 5: Replace console.log with console.debug
console.log("Starting application");
console.log("Loading user data");
console.log("Processing request");
console.log("Operation completed");

// Task 6: Convert function declarations to arrow functions
function add(a, b) {
    return a + b;
}

function multiply(x, y) {
    return x * y;
}

function greet(name) {
    return `Hello, ${name}!`;
}

// Task 7: Replace placeholder values
const config = {
    host: "localhost",
    port: 3000,
    database: "myapp_dev",
    timeout: 5000
};

// Task 8: Update class names
<div className="old-container">
    <span className="old-text">Sample text</span>
    <button className="old-button">Click me</button>
</div>

// Task 9: Replace callback pattern with async/await
getData(function(result) {
    processData(result, function(processed) {
        saveData(processed, function(saved) {
            console.log("All done");
        });
    });
});

// Task 10: Update imports to use destructuring
import React from 'react';
import lodash from 'lodash';
import moment from 'moment';

// Should become:
// import { useState, useEffect } from 'react';
// import { map, filter } from 'lodash';
// import { format, parse } from 'moment';

// Practice Regular Expressions
// =============================

// Find and replace patterns:
// 1. Phone numbers: (123) 456-7890 -> 123-456-7890
const phone1 = "(555) 123-4567";
const phone2 = "(888) 999-0000";

// 2. Email domains: @oldcompany.com -> @newcompany.com  
const email1 = "user1@oldcompany.com";
const email2 = "admin@oldcompany.com";
const email3 = "support@oldcompany.com";

// 3. Date format: MM/DD/YYYY -> YYYY-MM-DD
const date1 = "12/25/2023";
const date2 = "01/15/2024";
const date3 = "06/30/2023";

// 4. Remove trailing whitespace (lines end with spaces)
const text1 = "This line has trailing spaces    ";
const text2 = "This one too  ";
const text3 = "And this one   ";

// 5. Add semicolons to lines missing them
const statement1 = "let x = 1"
const statement2 = "let y = 2"
const statement3 = "let z = 3"