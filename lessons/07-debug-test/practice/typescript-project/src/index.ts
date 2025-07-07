#!/usr/bin/env ts-node

import { Calculator } from './calculator';
import { TaskManager } from './task-manager';
import { DataProcessor } from './data-processor';

/**
 * Main application for debugging practice
 * Run with: npm run dev (with debugger) or npm start
 */

function demonstrateCalculator() {
  console.log('=== Calculator Demo ===');
  const calc = new Calculator();
  
  // Basic operations
  console.log('Addition: 5 + 3 =', calc.add(5, 3));
  console.log('Subtraction: 10 - 4 =', calc.subtract(10, 4)); // Bug: wrong result
  console.log('Multiplication: 6 * 7 =', calc.multiply(6, 7));
  
  try {
    console.log('Division: 15 / 3 =', calc.divide(15, 3));
    console.log('Division by zero: 10 / 0 =', calc.divide(10, 0)); // Bug: should throw error
  } catch (error) {
    console.error('Division error:', error);
  }
  
  // Array operations
  const numbers = [1, 5, 3, 9, 2];
  console.log('Numbers:', numbers);
  console.log('Average:', calc.average(numbers));
  console.log('Maximum:', calc.findMax(numbers));
  
  // Empty array (will cause bug)
  try {
    console.log('Average of empty array:', calc.average([])); // Bug: NaN result
  } catch (error) {
    console.error('Average error:', error);
  }
  
  // History
  console.log('History:', calc.getHistory());
  calc.clearHistory();
  console.log('History after clear:', calc.getHistory()); // May still have items due to bug
}

async function demonstrateTaskManager() {
  console.log('\n=== Task Manager Demo ===');
  const taskManager = new TaskManager();
  
  // Add some tasks
  await taskManager.addTask('Learn debugging', 'high');
  await taskManager.addTask('Practice with breakpoints', 'medium');
  await taskManager.addTask('Write tests', 'low');
  
  console.log('All tasks:', await taskManager.getAllTasks());
  
  // Complete a task
  const tasks = await taskManager.getAllTasks();
  if (tasks.length > 0) {
    await taskManager.completeTask(tasks[0].id);
    console.log('After completing first task:', await taskManager.getCompletedTasks());
  }
  
  // Process high priority tasks (may have bugs)
  await taskManager.processHighPriorityTasks();
}

async function demonstrateDataProcessor() {
  console.log('\n=== Data Processor Demo ===');
  const processor = new DataProcessor();
  
  // Sample data with some problematic entries
  const sampleData = [
    { id: 1, name: 'Alice', age: 30, email: 'alice@example.com' },
    { id: 2, name: 'Bob', age: -5, email: 'invalid-email' }, // Invalid data
    { id: 3, name: '', age: 25, email: 'charlie@example.com' }, // Empty name
    { id: 4, name: 'David', age: 35, email: 'david@example.com' },
    null, // Null entry
  ];
  
  try {
    const processedData = await processor.processUserData(sampleData as any);
    console.log('Processed data:', processedData);
    
    const validUsers = processor.filterValidUsers(processedData);
    console.log('Valid users:', validUsers);
    
    const statistics = processor.calculateStatistics(validUsers);
    console.log('Statistics:', statistics);
  } catch (error) {
    console.error('Data processing error:', error);
  }
}

// Async function with potential race condition
async function demonstrateAsyncBugs() {
  console.log('\n=== Async Operations Demo ===');
  
  const promises = [];
  for (let i = 0; i < 5; i++) {
    promises.push(simulateAsyncOperation(i));
  }
  
  try {
    const results = await Promise.all(promises);
    console.log('Async results:', results);
  } catch (error) {
    console.error('Async error:', error);
  }
}

async function simulateAsyncOperation(id: number): Promise<string> {
  const delay = Math.random() * 1000;
  
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (id === 2) {
        // Intentional failure for debugging
        reject(new Error(`Operation ${id} failed`));
      } else {
        resolve(`Operation ${id} completed in ${delay.toFixed(0)}ms`);
      }
    }, delay);
  });
}

// Main execution
async function main() {
  console.log('Starting debugging practice application...\n');
  
  try {
    demonstrateCalculator();
    await demonstrateTaskManager();
    await demonstrateDataProcessor();
    await demonstrateAsyncBugs();
  } catch (error) {
    console.error('Application error:', error);
  }
  
  console.log('\nApplication completed. Check for any unexpected results!');
}

// Run the application
if (require.main === module) {
  main().catch(console.error);
}