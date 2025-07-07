// ユーティリティ関数

// メールバリデーション（型の問題あり）
export function validateEmail(email: string): string {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  // 型エラー: booleanを返すべきだがstringを返している
  return emailRegex.test(email) ? 'valid' : 'invalid';
}

// パスワードハッシュ化（簡易版）
export function hashPassword(password: string): string {
  // 実際のアプリケーションでは適切なハッシュ関数を使用
  return Buffer.from(password).toString('base64');
}

// 日付フォーマット（フォーマットオプション不足）
export function formatDate(date: Date, format?: string): string {
  // TODO: formatパラメータを活用した実装
  return date.toISOString();
}

// 配列ユーティリティ（ジェネリック型の練習）
export function groupBy<T>(array: T[], key: keyof T): Record<string, T[]> {
  return array.reduce((result, item) => {
    const groupKey = String(item[key]);
    if (!result[groupKey]) {
      result[groupKey] = [];
    }
    result[groupKey].push(item);
    return result;
  }, {} as Record<string, T[]>);
}

// デバウンス関数（型定義の改善余地あり）
export function debounce(func: Function, wait: number) {
  let timeout: NodeJS.Timeout;
  return function executedFunction(...args: any[]) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// 未使用の関数（インポートされているが使用されていない）
export function unusedFunction(): void {
  console.log('This function is not used anywhere');
}

// エラーハンドリングユーティリティ
export class AppError extends Error {
  constructor(
    public code: string,
    message: string,
    public statusCode: number = 500
  ) {
    super(message);
    this.name = 'AppError';
  }
}

// 非同期ユーティリティ（エラーハンドリング不足）
export async function retry<T>(
  fn: () => Promise<T>,
  retries: number = 3
): Promise<T> {
  try {
    return await fn();
  } catch (error) {
    if (retries > 0) {
      return retry(fn, retries - 1);
    }
    // エラーの再スローが必要
  }
}