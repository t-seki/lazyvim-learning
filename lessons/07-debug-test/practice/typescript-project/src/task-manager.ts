/**
 * Task Manager for debugging practice
 * Contains async operations and state management bugs
 */

export interface Task {
  id: string;
  title: string;
  priority: 'low' | 'medium' | 'high';
  completed: boolean;
  createdAt: Date;
  completedAt?: Date;
}

export class TaskManager {
  private tasks: Map<string, Task> = new Map();
  private currentId = 0;

  /**
   * Add a new task
   * Bug: Race condition with ID generation
   */
  async addTask(title: string, priority: Task['priority']): Promise<Task> {
    // Intentional bug: Race condition in async environment
    const id = (++this.currentId).toString();
    
    // Simulate async operation
    await this.delay(Math.random() * 100);
    
    const task: Task = {
      id,
      title,
      priority,
      completed: false,
      createdAt: new Date(),
    };
    
    this.tasks.set(id, task);
    return task;
  }

  /**
   * Get all tasks
   * Bug: Returns direct reference to internal data
   */
  async getAllTasks(): Promise<Task[]> {
    // Simulate network delay
    await this.delay(50);
    
    // Intentional bug: Should return a copy, not the original
    return Array.from(this.tasks.values());
  }

  /**
   * Complete a task
   * Bug: Doesn't validate task existence
   */
  async completeTask(id: string): Promise<boolean> {
    await this.delay(30);
    
    // Intentional bug: No validation if task exists
    const task = this.tasks.get(id);
    task!.completed = true; // Will throw if task doesn't exist
    task!.completedAt = new Date();
    
    return true;
  }

  /**
   * Get completed tasks
   * Bug: Memory leak - doesn't clean up old completed tasks
   */
  async getCompletedTasks(): Promise<Task[]> {
    await this.delay(40);
    
    const completed = Array.from(this.tasks.values())
      .filter(task => task.completed);
    
    // Intentional bug: Memory leak - completed tasks accumulate
    return completed;
  }

  /**
   * Delete a task
   * Bug: Doesn't handle non-existent tasks properly
   */
  async deleteTask(id: string): Promise<boolean> {
    await this.delay(25);
    
    // Intentional bug: Returns true even if task doesn't exist
    this.tasks.delete(id);
    return true;
  }

  /**
   * Get tasks by priority
   * Bug: Wrong filtering logic
   */
  async getTasksByPriority(priority: Task['priority']): Promise<Task[]> {
    await this.delay(35);
    
    // Intentional bug: Using wrong comparison
    return Array.from(this.tasks.values())
      .filter(task => task.priority !== priority); // Should be ===
  }

  /**
   * Process high priority tasks
   * Bug: Concurrent modification during iteration
   */
  async processHighPriorityTasks(): Promise<void> {
    console.log('Processing high priority tasks...');
    
    const highPriorityTasks = await this.getTasksByPriority('high');
    
    // Intentional bug: Modifying collection during iteration
    for (const task of highPriorityTasks) {
      console.log(`Processing task: ${task.title}`);
      
      // Simulate processing
      await this.delay(100);
      
      // This might cause issues if the task list is modified elsewhere
      await this.completeTask(task.id);
      
      // Intentional bug: Deleting during iteration
      await this.deleteTask(task.id);
    }
  }

  /**
   * Bulk operations
   * Bug: Doesn't handle partial failures
   */
  async bulkAddTasks(taskData: Array<{ title: string; priority: Task['priority'] }>): Promise<Task[]> {
    const results: Task[] = [];
    
    // Intentional bug: If one fails, all previous succeed but function throws
    for (const data of taskData) {
      if (!data.title.trim()) {
        throw new Error('Invalid task title');
      }
      
      const task = await this.addTask(data.title, data.priority);
      results.push(task);
    }
    
    return results;
  }

  /**
   * Get task statistics
   * Bug: Division by zero and incorrect calculations
   */
  getStatistics(): {
    total: number;
    completed: number;
    pending: number;
    completionRate: number;
    averageCompletionTime: number;
  } {
    const allTasks = Array.from(this.tasks.values());
    const completedTasks = allTasks.filter(task => task.completed);
    
    // Intentional bug: Division by zero when no tasks
    const completionRate = completedTasks.length / allTasks.length * 100;
    
    // Intentional bug: Incorrect calculation for completion time
    const totalCompletionTime = completedTasks.reduce((total, task) => {
      if (task.completedAt) {
        // Bug: Should be completedAt - createdAt
        return total + (task.createdAt.getTime() - task.completedAt.getTime());
      }
      return total;
    }, 0);
    
    const averageCompletionTime = totalCompletionTime / completedTasks.length;
    
    return {
      total: allTasks.length,
      completed: completedTasks.length,
      pending: allTasks.length - completedTasks.length,
      completionRate,
      averageCompletionTime,
    };
  }

  /**
   * Search tasks
   * Bug: Case sensitivity and partial matching issues
   */
  async searchTasks(query: string): Promise<Task[]> {
    await this.delay(60);
    
    // Intentional bug: Case sensitive search
    return Array.from(this.tasks.values())
      .filter(task => task.title.includes(query)); // Should be case-insensitive
  }

  /**
   * Clear all completed tasks
   * Bug: Race condition with concurrent operations
   */
  async clearCompletedTasks(): Promise<number> {
    const completedTasks = await this.getCompletedTasks();
    
    // Intentional bug: Race condition - tasks might be modified during deletion
    let deletedCount = 0;
    for (const task of completedTasks) {
      if (this.tasks.has(task.id)) {
        this.tasks.delete(task.id);
        deletedCount++;
      }
    }
    
    return deletedCount;
  }

  /**
   * Utility method to simulate async delays
   */
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  /**
   * Debug method to inspect internal state
   */
  debugState(): void {
    console.log('TaskManager Debug State:');
    console.log('- Total tasks:', this.tasks.size);
    console.log('- Current ID:', this.currentId);
    console.log('- Tasks:', Array.from(this.tasks.entries()));
  }
}