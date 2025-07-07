/**
 * Calculator class for debugging and testing practice
 * Contains intentional bugs for debugging exercises
 */

export class Calculator {
  private history: Array<{ operation: string; result: number }> = [];

  /**
   * Add two numbers
   * Bug: Doesn't handle string inputs properly
   */
  add(a: number, b: number): number {
    // Intentional bug: Type coercion issue
    const result = a + b;
    this.history.push({ operation: `${a} + ${b}`, result });
    return result;
  }

  /**
   * Subtract two numbers
   * Bug: Wrong operator precedence
   */
  subtract(a: number, b: number): number {
    // Intentional bug: Should be a - b
    const result = b - a;
    this.history.push({ operation: `${a} - ${b}`, result });
    return result;
  }

  /**
   * Multiply two numbers
   * Bug: Infinite loop for certain inputs
   */
  multiply(a: number, b: number): number {
    let result = 0;
    let count = Math.abs(b);
    
    // Intentional bug: Infinite loop when b is 0
    while (count > 0) {
      result += a;
      count--;
    }
    
    // Handle negative numbers
    if (b < 0) {
      result = -result;
    }
    
    this.history.push({ operation: `${a} * ${b}`, result });
    return result;
  }

  /**
   * Divide two numbers
   * Bug: Doesn't handle division by zero
   */
  divide(a: number, b: number): number {
    // Intentional bug: No division by zero check
    const result = a / b;
    this.history.push({ operation: `${a} / ${b}`, result });
    return result;
  }

  /**
   * Calculate power
   * Bug: Stack overflow for large exponents
   */
  power(base: number, exponent: number): number {
    // Intentional bug: Recursive without base case optimization
    if (exponent === 0) return 1;
    if (exponent === 1) return base;
    
    // This will cause stack overflow for large exponents
    return base * this.power(base, exponent - 1);
  }

  /**
   * Calculate factorial
   * Bug: Doesn't handle negative numbers
   */
  factorial(n: number): number {
    // Intentional bug: No negative number check
    if (n <= 1) return 1;
    return n * this.factorial(n - 1);
  }

  /**
   * Get calculation history
   * Bug: Returns reference to internal array
   */
  getHistory(): Array<{ operation: string; result: number }> {
    // Intentional bug: Should return a copy, not the original array
    return this.history;
  }

  /**
   * Clear history
   * Bug: Doesn't actually clear the array
   */
  clearHistory(): void {
    // Intentional bug: Creates new array instead of clearing
    this.history = [];
  }

  /**
   * Calculate average of array
   * Bug: Doesn't handle empty arrays
   */
  average(numbers: number[]): number {
    // Intentional bug: Division by zero for empty array
    const sum = numbers.reduce((total, num) => total + num, 0);
    const result = sum / numbers.length;
    
    this.history.push({ operation: `avg([${numbers.join(', ')}])`, result });
    return result;
  }

  /**
   * Find maximum in array
   * Bug: Doesn't handle edge cases
   */
  findMax(numbers: number[]): number {
    // Intentional bug: Assumes array has at least one element
    let max = numbers[0];
    
    for (let i = 1; i < numbers.length; i++) {
      if (numbers[i] > max) {
        max = numbers[i];
      }
    }
    
    return max;
  }
}