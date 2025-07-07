// 型定義ファイル

export type UserRole = 'admin' | 'moderator' | 'user' | 'guest';

export interface User {
  id: string;
  email: string;
  password: string;
  role: UserRole;
  createdAt: Date;
  updatedAt?: Date;
  isActive: boolean;
  profile?: UserProfile;
}

export interface UserProfile {
  firstName: string;
  lastName: string;
  bio?: string;
  avatar?: string;
  preferences: UserPreferences;
}

export interface UserPreferences {
  theme: 'light' | 'dark' | 'auto';
  language: string;
  notifications: {
    email: boolean;
    push: boolean;
    sms: boolean;
  };
}

// ジェネリック型の練習
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: unknown;
  };
  timestamp: number;
}

// ユーティリティ型の使用例
export type CreateUserInput = Omit<User, 'id' | 'createdAt' | 'updatedAt'>;
export type UpdateUserInput = Partial<Omit<User, 'id' | 'createdAt'>>;

// 条件型の例
export type AsyncFunction<T> = T extends (...args: any[]) => infer R
  ? (...args: Parameters<T>) => Promise<R>
  : never;

// 列挙型
export enum ErrorCode {
  VALIDATION_ERROR = 'VALIDATION_ERROR',
  NOT_FOUND = 'NOT_FOUND',
  UNAUTHORIZED = 'UNAUTHORIZED',
  INTERNAL_ERROR = 'INTERNAL_ERROR'
}

// 型ガード
export function isUser(obj: any): obj is User {
  return obj && typeof obj.id === 'string' && typeof obj.email === 'string';
}