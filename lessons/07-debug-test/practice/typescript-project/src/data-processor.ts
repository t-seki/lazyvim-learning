/**
 * Data Processor for debugging practice
 * Contains validation, transformation, and error handling bugs
 */

export interface UserData {
  id: number;
  name: string;
  age: number;
  email: string;
}

export interface ProcessedUser extends UserData {
  isValid: boolean;
  validationErrors: string[];
  processedAt: Date;
}

export interface Statistics {
  totalUsers: number;
  validUsers: number;
  invalidUsers: number;
  averageAge: number;
  ageDistribution: Record<string, number>;
  commonErrors: Record<string, number>;
}

export class DataProcessor {
  private readonly EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  private readonly MIN_AGE = 0;
  private readonly MAX_AGE = 150;

  /**
   * Process user data with validation
   * Bug: Doesn't handle null/undefined inputs properly
   */
  async processUserData(rawData: unknown[]): Promise<ProcessedUser[]> {
    const results: ProcessedUser[] = [];
    
    console.log(`Processing ${rawData.length} user records...`);
    
    for (let i = 0; i < rawData.length; i++) {
      const userData = rawData[i];
      
      try {
        // Intentional bug: Doesn't check for null/undefined
        const processed = await this.processUser(userData as UserData);
        results.push(processed);
      } catch (error) {
        // Intentional bug: Silently continues on error instead of handling properly
        console.error(`Error processing user at index ${i}:`, error);
      }
    }
    
    return results;
  }

  /**
   * Process individual user
   * Bug: Validation logic has flaws
   */
  private async processUser(userData: UserData): Promise<ProcessedUser> {
    // Simulate processing delay
    await this.delay(10);
    
    const validationErrors: string[] = [];
    
    // Validate ID
    if (!userData.id || userData.id <= 0) {
      validationErrors.push('Invalid ID');
    }
    
    // Validate name
    // Intentional bug: Doesn't trim whitespace
    if (!userData.name || userData.name.length === 0) {
      validationErrors.push('Name is required');
    }
    
    // Validate age
    // Intentional bug: Wrong comparison operators
    if (userData.age < this.MIN_AGE && userData.age > this.MAX_AGE) {
      validationErrors.push(`Age must be between ${this.MIN_AGE} and ${this.MAX_AGE}`);
    }
    
    // Validate email
    if (!this.EMAIL_REGEX.test(userData.email)) {
      validationErrors.push('Invalid email format');
    }
    
    return {
      ...userData,
      isValid: validationErrors.length === 0,
      validationErrors,
      processedAt: new Date(),
    };
  }

  /**
   * Filter valid users
   * Bug: Mutates original array
   */
  filterValidUsers(users: ProcessedUser[]): ProcessedUser[] {
    // Intentional bug: Modifies original array instead of creating new one
    return users.filter(user => {
      if (user.isValid) {
        // Bug: Mutating the object
        user.name = user.name.trim().toUpperCase();
        return true;
      }
      return false;
    });
  }

  /**
   * Calculate statistics
   * Bug: Division by zero and incorrect calculations
   */
  calculateStatistics(users: ProcessedUser[]): Statistics {
    const totalUsers = users.length;
    const validUsers = users.filter(user => user.isValid).length;
    const invalidUsers = totalUsers - validUsers;
    
    // Intentional bug: Division by zero when no users
    const averageAge = users.reduce((sum, user) => sum + user.age, 0) / users.length;
    
    // Age distribution with bugs
    const ageDistribution: Record<string, number> = {};
    users.forEach(user => {
      const ageGroup = this.getAgeGroup(user.age);
      // Intentional bug: Should initialize to 0 if not exists
      ageDistribution[ageGroup] += 1; // Will be NaN if undefined + 1
    });
    
    // Count common errors
    const commonErrors: Record<string, number> = {};
    users.forEach(user => {
      user.validationErrors.forEach(error => {
        // Intentional bug: Same issue as above
        commonErrors[error] += 1;
      });
    });
    
    return {
      totalUsers,
      validUsers,
      invalidUsers,
      averageAge,
      ageDistribution,
      commonErrors,
    };
  }

  /**
   * Get age group classification
   * Bug: Incorrect age group boundaries
   */
  private getAgeGroup(age: number): string {
    // Intentional bugs in age group classification
    if (age < 0) return 'Invalid';
    if (age <= 18) return 'Child';
    if (age <= 30) return 'Young Adult';
    if (age <= 50) return 'Adult';
    if (age <= 65) return 'Middle Age';
    // Bug: Missing return for > 65
  }

  /**
   * Transform user data to different format
   * Bug: Loses data during transformation
   */
  transformToExportFormat(users: ProcessedUser[]): Array<Record<string, any>> {
    return users.map(user => {
      // Intentional bug: Loses important fields
      return {
        userId: user.id,
        displayName: user.name,
        contact: user.email,
        // Missing age, validation status, etc.
      };
    });
  }

  /**
   * Batch process with retry logic
   * Bug: Infinite retry loop potential
   */
  async batchProcessWithRetry(
    data: unknown[],
    maxRetries: number = 3
  ): Promise<ProcessedUser[]> {
    let attempt = 0;
    
    while (attempt < maxRetries) {
      try {
        return await this.processUserData(data);
      } catch (error) {
        attempt++;
        console.log(`Attempt ${attempt} failed:`, error);
        
        // Intentional bug: Potential infinite loop if maxRetries is 0
        if (attempt >= maxRetries) {
          throw new Error(`Failed after ${maxRetries} attempts`);
        }
        
        // Wait before retry
        await this.delay(1000 * attempt);
      }
    }
    
    // This should never be reached, but TypeScript requires a return
    throw new Error('Unexpected end of retry loop');
  }

  /**
   * Validate and clean email addresses
   * Bug: Doesn't handle edge cases
   */
  cleanEmail(email: string): string {
    // Intentional bug: Doesn't handle null/undefined
    email = email.toLowerCase().trim();
    
    // Remove extra spaces (but this can cause issues)
    email = email.replace(/\s+/g, '');
    
    // Intentional bug: Overly aggressive cleaning
    email = email.replace(/[^a-z0-9@._-]/g, '');
    
    return email;
  }

  /**
   * Generate user report
   * Bug: Memory leak and performance issues
   */
  generateReport(users: ProcessedUser[]): string {
    let report = 'User Data Report\n';
    report += '================\n\n';
    
    // Intentional bug: Memory inefficient string concatenation
    users.forEach(user => {
      report += `User ID: ${user.id}\n`;
      report += `Name: ${user.name}\n`;
      report += `Age: ${user.age}\n`;
      report += `Email: ${user.email}\n`;
      report += `Valid: ${user.isValid}\n`;
      
      if (user.validationErrors.length > 0) {
        report += `Errors: ${user.validationErrors.join(', ')}\n`;
      }
      
      report += '---\n';
    });
    
    // Add statistics
    const stats = this.calculateStatistics(users);
    report += `\nStatistics:\n`;
    report += `Total Users: ${stats.totalUsers}\n`;
    report += `Valid Users: ${stats.validUsers}\n`;
    report += `Invalid Users: ${stats.invalidUsers}\n`;
    report += `Average Age: ${stats.averageAge.toFixed(2)}\n`;
    
    return report;
  }

  /**
   * Async utility for delays
   */
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  /**
   * Debug method to inspect processor state
   */
  debugInfo(): void {
    console.log('DataProcessor Debug Info:');
    console.log('- Email Regex:', this.EMAIL_REGEX);
    console.log('- Age Limits:', { min: this.MIN_AGE, max: this.MAX_AGE });
  }
}