import { Calculator } from '../src/calculator';

describe('Calculator', () => {
  let calculator: Calculator;

  beforeEach(() => {
    calculator = new Calculator();
  });

  describe('Basic Operations', () => {
    test('should add two positive numbers correctly', () => {
      const result = calculator.add(5, 3);
      expect(result).toBe(8);
    });

    test('should handle string inputs in addition', () => {
      // This test will reveal the type coercion bug
      const result = calculator.add('5' as any, '3' as any);
      expect(result).toBe(8); // Will fail due to concatenation
    });

    test('should subtract correctly', () => {
      const result = calculator.subtract(10, 4);
      expect(result).toBe(6); // Will fail due to bug (returns -6)
    });

    test('should multiply positive numbers', () => {
      const result = calculator.multiply(6, 7);
      expect(result).toBe(42);
    });

    test('should handle multiplication by zero', () => {
      const result = calculator.multiply(5, 0);
      expect(result).toBe(0); // Will hang due to infinite loop
    });

    test('should divide numbers', () => {
      const result = calculator.divide(15, 3);
      expect(result).toBe(5);
    });

    test('should handle division by zero', () => {
      // This should throw an error but doesn't due to bug
      expect(() => calculator.divide(10, 0)).toThrow();
    });
  });

  describe('Advanced Operations', () => {
    test('should calculate power correctly', () => {
      const result = calculator.power(2, 3);
      expect(result).toBe(8);
    });

    test('should handle large exponents', () => {
      // This will cause stack overflow due to recursive implementation
      expect(() => calculator.power(2, 1000)).not.toThrow();
    });

    test('should calculate factorial', () => {
      expect(calculator.factorial(5)).toBe(120);
      expect(calculator.factorial(0)).toBe(1);
    });

    test('should handle negative factorial', () => {
      // This should throw an error but doesn't
      expect(() => calculator.factorial(-5)).toThrow();
    });
  });

  describe('Array Operations', () => {
    test('should calculate average of numbers', () => {
      const result = calculator.average([1, 2, 3, 4, 5]);
      expect(result).toBe(3);
    });

    test('should handle empty array for average', () => {
      // This will return NaN due to division by zero
      expect(() => calculator.average([])).toThrow();
    });

    test('should find maximum in array', () => {
      const result = calculator.findMax([1, 5, 3, 9, 2]);
      expect(result).toBe(9);
    });

    test('should handle empty array for maximum', () => {
      // This will throw due to accessing undefined array element
      expect(() => calculator.findMax([])).toThrow();
    });
  });

  describe('History Management', () => {
    test('should track calculation history', () => {
      calculator.add(5, 3);
      calculator.subtract(10, 4);
      
      const history = calculator.getHistory();
      expect(history).toHaveLength(2);
      expect(history[0].operation).toBe('5 + 3');
    });

    test('should not allow history mutation', () => {
      calculator.add(5, 3);
      const history = calculator.getHistory();
      
      // This test will fail because getHistory returns reference
      history.push({ operation: 'hacked', result: 999 });
      
      const newHistory = calculator.getHistory();
      expect(newHistory).toHaveLength(1); // Will fail if reference is returned
    });

    test('should clear history', () => {
      calculator.add(5, 3);
      calculator.clearHistory();
      
      const history = calculator.getHistory();
      expect(history).toHaveLength(0);
    });
  });

  describe('Edge Cases', () => {
    test('should handle very large numbers', () => {
      const result = calculator.add(Number.MAX_SAFE_INTEGER, 1);
      expect(result).toBe(Number.MAX_SAFE_INTEGER + 1);
    });

    test('should handle floating point numbers', () => {
      const result = calculator.add(0.1, 0.2);
      expect(result).toBeCloseTo(0.3); // Floating point precision
    });

    test('should handle negative numbers in all operations', () => {
      expect(calculator.add(-5, 3)).toBe(-2);
      expect(calculator.multiply(-3, 4)).toBe(-12);
      expect(calculator.divide(-10, 2)).toBe(-5);
    });
  });

  describe('Performance Tests', () => {
    test('should handle large arrays efficiently', () => {
      const largeArray = Array.from({ length: 10000 }, (_, i) => i);
      
      const start = Date.now();
      const average = calculator.average(largeArray);
      const end = Date.now();
      
      expect(average).toBe(4999.5);
      expect(end - start).toBeLessThan(100); // Should complete within 100ms
    });

    test('should not leak memory with many operations', () => {
      // Perform many operations to test for memory leaks
      for (let i = 0; i < 1000; i++) {
        calculator.add(i, i + 1);
      }
      
      const history = calculator.getHistory();
      expect(history).toHaveLength(1000);
    });
  });
});

// Test utilities for debugging practice
describe('Debugging Utilities', () => {
  test('breakpoint practice - step through addition', () => {
    const calc = new Calculator();
    
    // Set a breakpoint on the next line and step through
    const a = 10;
    const b = 5;
    const result = calc.add(a, b); // <-- Set breakpoint here
    
    expect(result).toBe(15);
  });

  test('watch variables during complex calculation', () => {
    const calc = new Calculator();
    
    // Watch these variables during debugging
    const numbers = [1, 2, 3, 4, 5];
    let sum = 0;
    let count = 0;
    
    for (const num of numbers) {
      sum += num; // <-- Watch 'sum' and 'count' here
      count++;
    }
    
    const average = calc.average(numbers);
    expect(average).toBe(sum / count);
  });
});