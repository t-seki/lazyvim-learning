import { TaskManager, Task } from '../src/task-manager';

describe('TaskManager', () => {
  let taskManager: TaskManager;

  beforeEach(() => {
    taskManager = new TaskManager();
  });

  describe('Task Creation', () => {
    test('should create a task with correct properties', async () => {
      const task = await taskManager.addTask('Test Task', 'high');
      
      expect(task.title).toBe('Test Task');
      expect(task.priority).toBe('high');
      expect(task.completed).toBe(false);
      expect(task.id).toBeDefined();
      expect(task.createdAt).toBeInstanceOf(Date);
    });

    test('should generate unique IDs for concurrent tasks', async () => {
      // This test may fail due to race condition in ID generation
      const taskPromises = [
        taskManager.addTask('Task 1', 'low'),
        taskManager.addTask('Task 2', 'medium'),
        taskManager.addTask('Task 3', 'high'),
      ];
      
      const tasks = await Promise.all(taskPromises);
      const ids = tasks.map(task => task.id);
      const uniqueIds = new Set(ids);
      
      expect(uniqueIds.size).toBe(3); // May fail due to race condition
    });

    test('should handle bulk task creation', async () => {
      const taskData = [
        { title: 'Task 1', priority: 'low' as const },
        { title: 'Task 2', priority: 'medium' as const },
        { title: '', priority: 'high' as const }, // Invalid task
      ];
      
      // This should throw due to empty title, but all previous tasks are created
      await expect(taskManager.bulkAddTasks(taskData)).rejects.toThrow();
      
      // Check if partial tasks were created (bug)
      const allTasks = await taskManager.getAllTasks();
      expect(allTasks.length).toBe(2); // Bug: partial success not handled
    });
  });

  describe('Task Retrieval', () => {
    beforeEach(async () => {
      await taskManager.addTask('Low Priority Task', 'low');
      await taskManager.addTask('Medium Priority Task', 'medium');
      await taskManager.addTask('High Priority Task', 'high');
    });

    test('should retrieve all tasks', async () => {
      const tasks = await taskManager.getAllTasks();
      expect(tasks).toHaveLength(3);
    });

    test('should not allow external modification of task list', async () => {
      const tasks = await taskManager.getAllTasks();
      
      // This test will fail because getAllTasks returns reference
      tasks.push({
        id: 'hacked',
        title: 'Hacked Task',
        priority: 'high',
        completed: false,
        createdAt: new Date(),
      });
      
      const newTasks = await taskManager.getAllTasks();
      expect(newTasks).toHaveLength(3); // Will fail if reference is returned
    });

    test('should filter tasks by priority correctly', async () => {
      const highPriorityTasks = await taskManager.getTasksByPriority('high');
      
      // This will fail due to wrong filtering logic (using !== instead of ===)
      expect(highPriorityTasks).toHaveLength(1);
      expect(highPriorityTasks[0].priority).toBe('high');
    });
  });

  describe('Task Completion', () => {
    let taskId: string;

    beforeEach(async () => {
      const task = await taskManager.addTask('Test Task', 'medium');
      taskId = task.id;
    });

    test('should complete a task successfully', async () => {
      const success = await taskManager.completeTask(taskId);
      expect(success).toBe(true);
      
      const completedTasks = await taskManager.getCompletedTasks();
      expect(completedTasks).toHaveLength(1);
      expect(completedTasks[0].completed).toBe(true);
      expect(completedTasks[0].completedAt).toBeInstanceOf(Date);
    });

    test('should handle non-existent task completion', async () => {
      // This will throw due to no validation
      await expect(taskManager.completeTask('non-existent-id'))
        .rejects.toThrow();
    });

    test('should clear completed tasks', async () => {
      await taskManager.completeTask(taskId);
      
      const deletedCount = await taskManager.clearCompletedTasks();
      expect(deletedCount).toBe(1);
      
      const remainingTasks = await taskManager.getAllTasks();
      expect(remainingTasks).toHaveLength(0);
    });
  });

  describe('Task Search', () => {
    beforeEach(async () => {
      await taskManager.addTask('Learn TypeScript', 'high');
      await taskManager.addTask('Practice Debugging', 'medium');
      await taskManager.addTask('Write Tests', 'low');
    });

    test('should search tasks case-insensitively', async () => {
      // This will fail due to case-sensitive search
      const results = await taskManager.searchTasks('typescript');
      expect(results).toHaveLength(1);
      expect(results[0].title).toContain('TypeScript');
    });

    test('should find partial matches', async () => {
      const results = await taskManager.searchTasks('Learn');
      expect(results).toHaveLength(1);
    });

    test('should return empty array for no matches', async () => {
      const results = await taskManager.searchTasks('Nonexistent');
      expect(results).toHaveLength(0);
    });
  });

  describe('Statistics', () => {
    beforeEach(async () => {
      const task1 = await taskManager.addTask('Task 1', 'high');
      const task2 = await taskManager.addTask('Task 2', 'medium');
      await taskManager.addTask('Task 3', 'low');
      
      // Complete some tasks
      await taskManager.completeTask(task1.id);
      await taskManager.completeTask(task2.id);
    });

    test('should calculate statistics correctly', () => {
      const stats = taskManager.getStatistics();
      
      expect(stats.total).toBe(3);
      expect(stats.completed).toBe(2);
      expect(stats.pending).toBe(1);
      expect(stats.completionRate).toBe(66.67); // May be wrong due to calculation bugs
    });

    test('should handle empty task list', () => {
      const emptyManager = new TaskManager();
      const stats = emptyManager.getStatistics();
      
      // This will return NaN due to division by zero
      expect(stats.completionRate).toBe(0);
      expect(stats.averageCompletionTime).toBe(0);
    });

    test('should calculate average completion time', () => {
      const stats = taskManager.getStatistics();
      
      // This may be negative due to wrong calculation in the implementation
      expect(stats.averageCompletionTime).toBeGreaterThan(0);
    });
  });

  describe('Concurrent Operations', () => {
    test('should handle concurrent task additions', async () => {
      const promises = [];
      for (let i = 0; i < 10; i++) {
        promises.push(taskManager.addTask(`Task ${i}`, 'medium'));
      }
      
      const tasks = await Promise.all(promises);
      expect(tasks).toHaveLength(10);
      
      // Check for unique IDs (may fail due to race condition)
      const ids = tasks.map(task => task.id);
      const uniqueIds = new Set(ids);
      expect(uniqueIds.size).toBe(10);
    });

    test('should handle processing high priority tasks safely', async () => {
      // Add multiple high priority tasks
      await taskManager.addTask('High Task 1', 'high');
      await taskManager.addTask('High Task 2', 'high');
      await taskManager.addTask('High Task 3', 'high');
      
      // This may fail due to concurrent modification during iteration
      await expect(taskManager.processHighPriorityTasks()).resolves.not.toThrow();
      
      // Check that tasks were processed
      const remainingTasks = await taskManager.getAllTasks();
      const highPriorityTasks = remainingTasks.filter(task => task.priority === 'high');
      expect(highPriorityTasks).toHaveLength(0);
    });
  });

  describe('Memory Management', () => {
    test('should not accumulate completed tasks indefinitely', async () => {
      // Create and complete many tasks
      for (let i = 0; i < 100; i++) {
        const task = await taskManager.addTask(`Task ${i}`, 'low');
        await taskManager.completeTask(task.id);
      }
      
      const completedTasks = await taskManager.getCompletedTasks();
      
      // This test checks for potential memory leak
      expect(completedTasks).toHaveLength(100);
      
      // Clear completed tasks
      await taskManager.clearCompletedTasks();
      
      const remainingCompleted = await taskManager.getCompletedTasks();
      expect(remainingCompleted).toHaveLength(0);
    });
  });

  describe('Debugging Helpers', () => {
    test('debug state inspection', async () => {
      await taskManager.addTask('Debug Task', 'high');
      
      // Use this test to practice debugging
      taskManager.debugState(); // <-- Set breakpoint here
      
      const allTasks = await taskManager.getAllTasks();
      expect(allTasks).toHaveLength(1);
    });

    test('async operation timing', async () => {
      const start = Date.now();
      
      // Set breakpoints and watch the timing
      await taskManager.addTask('Timed Task', 'medium');
      const tasks = await taskManager.getAllTasks();
      const stats = taskManager.getStatistics();
      
      const end = Date.now();
      const duration = end - start;
      
      console.log(`Operations took ${duration}ms`);
      expect(duration).toBeGreaterThan(0);
    });
  });
});