// フロントエンドアプリケーション
// バックエンドAPIとの連携

// バックエンドと共通の型定義
interface User {
  id: number;
  username: string;
  email: string;
  role: 'admin' | 'user' | 'guest';
  created_at: string;
}

interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
}

// API設定（バックエンドのconfig.jsonと対応）
const API_BASE_URL = 'http://localhost:5000/api';

// APIクライアントクラス
class ApiClient {
  private baseUrl: string;

  constructor(baseUrl: string = API_BASE_URL) {
    this.baseUrl = baseUrl;
  }

  // ユーザー一覧を取得（バックエンドの/api/usersエンドポイント）
  async getUsers(): Promise<User[]> {
    try {
      const response = await fetch(`${this.baseUrl}/users`);
      const result: ApiResponse<{ users: User[] }> = await response.json();
      
      if (!result.success) {
        throw new Error(result.error || 'Failed to fetch users');
      }
      
      return result.data?.users || [];
    } catch (error) {
      console.error('Error fetching users:', error);
      throw error;
    }
  }

  // 特定のユーザーを取得
  async getUser(userId: number): Promise<User | null> {
    try {
      const response = await fetch(`${this.baseUrl}/users/${userId}`);
      const result: ApiResponse<User> = await response.json();
      
      if (!result.success) {
        console.error('User not found:', result.error);
        return null;
      }
      
      return result.data || null;
    } catch (error) {
      console.error('Error fetching user:', error);
      return null;
    }
  }

  // 新しいユーザーを作成
  async createUser(userData: Omit<User, 'id' | 'created_at'>): Promise<User> {
    try {
      const response = await fetch(`${this.baseUrl}/users`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(userData),
      });
      
      const result: ApiResponse<User> = await response.json();
      
      if (!result.success) {
        throw new Error(result.error || 'Failed to create user');
      }
      
      return result.data!;
    } catch (error) {
      console.error('Error creating user:', error);
      throw error;
    }
  }
}

// UIコンポーネント
class UserInterface {
  private apiClient: ApiClient;
  private containerElement: HTMLElement;

  constructor(containerId: string) {
    this.apiClient = new ApiClient();
    const container = document.getElementById(containerId);
    if (!container) {
      throw new Error(`Container element with id '${containerId}' not found`);
    }
    this.containerElement = container;
  }

  // ユーザーリストを表示
  async displayUsers(): Promise<void> {
    try {
      const users = await this.apiClient.getUsers();
      this.renderUserList(users);
    } catch (error) {
      this.renderError('Failed to load users');
    }
  }

  // ユーザーリストをレンダリング
  private renderUserList(users: User[]): void {
    const html = `
      <div class="user-list">
        <h2>Users</h2>
        <ul>
          ${users.map(user => `
            <li class="user-item" data-user-id="${user.id}">
              <span class="username">${user.username}</span>
              <span class="email">${user.email}</span>
              <span class="role role-${user.role}">${user.role}</span>
            </li>
          `).join('')}
        </ul>
      </div>
    `;
    this.containerElement.innerHTML = html;
  }

  // エラー表示
  private renderError(message: string): void {
    this.containerElement.innerHTML = `
      <div class="error-message">
        <p>Error: ${message}</p>
      </div>
    `;
  }

  // ユーザー作成フォーム
  renderCreateUserForm(): void {
    const html = `
      <form id="create-user-form" class="user-form">
        <h3>Create New User</h3>
        <input type="text" name="username" placeholder="Username" required>
        <input type="email" name="email" placeholder="Email" required>
        <select name="role" required>
          <option value="">Select Role</option>
          <option value="admin">Admin</option>
          <option value="user">User</option>
          <option value="guest">Guest</option>
        </select>
        <button type="submit">Create User</button>
      </form>
    `;
    
    const formContainer = document.createElement('div');
    formContainer.innerHTML = html;
    this.containerElement.appendChild(formContainer);
    
    // フォームイベントハンドラー
    const form = document.getElementById('create-user-form') as HTMLFormElement;
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      await this.handleCreateUser(form);
    });
  }

  // ユーザー作成処理
  private async handleCreateUser(form: HTMLFormElement): Promise<void> {
    const formData = new FormData(form);
    const userData = {
      username: formData.get('username') as string,
      email: formData.get('email') as string,
      role: formData.get('role') as User['role'],
    };
    
    try {
      await this.apiClient.createUser(userData);
      form.reset();
      await this.displayUsers(); // リストを更新
    } catch (error) {
      alert('Failed to create user');
    }
  }
}

// アプリケーションの初期化
document.addEventListener('DOMContentLoaded', () => {
  const userUI = new UserInterface('app');
  userUI.displayUsers();
  userUI.renderCreateUserForm();
});