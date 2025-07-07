// LSP機能練習用TypeScriptファイル
// このファイルで様々なLSP機能を試してみましょう

import { User, UserRole } from './types';
import { validateEmail, hashPassword } from './utils';
// 未使用のインポート（コードアクションで削除可能）
import { unusedFunction } from './unused';

interface UserServiceConfig {
  maxUsers: number;
  defaultRole: UserRole;
  enableNotifications: boolean;
}

// TODO: ドキュメントコメントを追加（コードアクションで生成可能）
class UserService {
  private users: Map<string, User> = new Map();
  private config: UserServiceConfig;

  constructor(config: UserServiceConfig) {
    this.config = config;
  }

  // エラー: async関数だがawaitを使用していない
  async createUser(email: string, password: string, role?: UserRole) {
    // 型エラー: validateEmailは文字列を返すが、booleanとして使用
    if (!validateEmail(email)) {
      throw new Error('Invalid email format');
    }

    if (this.users.size >= this.config.maxUsers) {
      throw new Error('User limit reached');
    }

    const hashedPassword = hashPassword(password);
    const newUser: User = {
      id: this.generateId(),
      email,
      password: hashedPassword,
      role: role || this.config.defaultRole,
      createdAt: new Date(),
      // プロパティ不足: isActiveが必要
    };

    this.users.set(newUser.id, newUser);
    return newUser;
  }

  // リファクタリング候補: メソッド名を変更してみましょう
  getUserById(id: string): User | undefined {
    return this.users.get(id);
  }

  // 未実装メソッド（コードアクションで実装を生成）
  updateUser(id: string, updates: Partial<User>): User {
    // TODO: 実装が必要
  }

  // 複雑な条件（リファクタリング候補）
  canUserPerformAction(userId: string, action: string): boolean {
    const user = this.getUserById(userId);
    if (!user) return false;
    if (user.role === 'admin') return true;
    if (user.role === 'moderator' && action !== 'delete') return true;
    if (user.role === 'user' && action === 'read') return true;
    return false;
  }

  // プライベートメソッド（未使用の警告が出る可能性）
  private generateId(): string {
    return Math.random().toString(36).substr(2, 9);
  }

  // 非推奨メソッド（デコレータやコメントで表示）
  /** @deprecated Use getUserById instead */
  getUser(id: string): User | undefined {
    return this.getUserById(id);
  }
}

// 型エラー: 必須プロパティが不足
const config: UserServiceConfig = {
  maxUsers: 1000,
  // defaultRoleが不足
  enableNotifications: true
};

// 使用例（エラーを含む）
const userService = new UserService(config);

// Promise処理のエラー
userService.createUser('test@example.com', 'password123')
  .then(user => {
    console.log('User created:', user.email);
    // 型エラー: userIdプロパティは存在しない
    console.log('User ID:', user.userId);
  });

// 未定義の変数
console.log(undefinedVariable);

// 到達不能コード
function checkCondition(value: number): string {
  if (value > 0) {
    return 'positive';
  } else {
    return 'non-positive';
  }
  // 警告: 到達不能コード
  console.log('This will never execute');
}

// エクスポート（循環参照の可能性）
export { UserService, UserServiceConfig };