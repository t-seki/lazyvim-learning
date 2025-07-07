# TypeScript開発 - エクササイズ

## 準備

### 開発環境の確認
```bash
# Node.js と npm のバージョン確認
node --version  # v18.0.0+
npm --version   # v8.0.0+

# TypeScript の確認
npx tsc --version
```

### 練習プロジェクトのセットアップ
```bash
cd lessons/10-typescript-development/practice
```

## エクササイズ1: TypeScript LSP完全活用

### 基本的なLSP機能テスト

1. **型情報の確認**
   ```typescript
   // practice/frontend/src/types.ts
   interface User {
     id: number;
     name: string;
     email: string;
     role: 'admin' | 'user' | 'guest';
     profile?: {
       avatar: string;
       bio: string;
     };
   }
   
   function processUser(user: User) {
     // カーソルをuserに置いて K を押し、型情報を確認
     console.log(user.name);
   }
   ```
   - [ ] `K`で型情報（hover）を表示
   - [ ] `gd`で定義ジャンプ
   - [ ] `gr`で参照箇所表示

2. **自動補完とインポート**
   ```typescript
   // practice/frontend/src/utils.ts
   export function formatDate(date: Date): string {
     return date.toISOString().split('T')[0];
   }
   
   export function validateEmail(email: string): boolean {
     return /\S+@\S+\.\S+/.test(email);
   }
   ```
   
   ```typescript
   // practice/frontend/src/components/UserCard.tsx
   import React from 'react';
   // formatDate を入力途中で Ctrl+Space で補完
   // 自動インポートが提案されることを確認
   
   const UserCard = () => {
     const today = new Date();
     // formatDa まで入力して補完をテスト
     return <div>{/* formatDate(today) */}</div>;
   };
   ```
   - [ ] 自動補完で関数を選択
   - [ ] 自動インポートが追加されることを確認

3. **TypeScript専用操作**
   ```typescript
   // practice/frontend/src/service.ts
   import { User } from './types';
   
   // 複数のimportを追加
   import { formatDate } from './utils';
   import { validateEmail } from './utils';
   import fs from 'fs';
   import path from 'path';
   
   class UserService {
     private users: User[] = [];
     
     addUser(user: User) {
       this.users.push(user);
     }
   }
   ```
   - [ ] `<leader>to`でインポートを整理
   - [ ] `<leader>tr`でファイル名変更
   - [ ] `<leader>ti`で不足インポートを追加

### エラー修正の練習

4. **型エラーの修正**
   ```typescript
   // 意図的にエラーを含むコード
   interface Product {
     id: number;
     name: string;
     price: number;
     category: string;
   }
   
   function calculateTotal(products: Product[]): string {  // 戻り値の型が間違い
     return products.reduce((sum, product) => {
       return sum + product.price;
     }, 0);  // number を返すのに戻り値型が string
   }
   
   const invalidProduct = {
     id: "1",        // string なのに number が期待される
     name: "Test",
     price: "100",   // string なのに number が期待される
     // category が不足
   };
   ```
   - [ ] 診断パネル（`<leader>cd`）でエラー確認
   - [ ] `<leader>ca`でコードアクション実行
   - [ ] エラーを修正して型安全にする

## エクササイズ2: React/Next.js開発

### React コンポーネント開発

1. **基本コンポーネントの作成**
   - [ ] `<leader>rc`でUserProfileコンポーネントを作成
   - [ ] TypeScript Props インターフェースを定義
   - [ ] useState, useEffect の型安全な使用

2. **カスタムフックの作成**
   ```typescript
   // practice/frontend/src/hooks/useApi.ts
   import { useState, useEffect } from 'react';
   
   interface ApiState<T> {
     data: T | null;
     loading: boolean;
     error: string | null;
   }
   
   export function useApi<T>(url: string): ApiState<T> {
     const [state, setState] = useState<ApiState<T>>({
       data: null,
       loading: true,
       error: null,
     });
     
     useEffect(() => {
       // API呼び出しの実装
       // この部分を完成させる
     }, [url]);
     
     return state;
   }
   ```
   - [ ] useApi フックを完成させる
   - [ ] TypeScript ジェネリクスを正しく使用
   - [ ] エラーハンドリングを追加

3. **Next.js ページの作成**
   - [ ] `<leader>np`でユーザー一覧ページを作成
   - [ ] `<leader>na`でユーザーAPIルートを作成
   - [ ] getServerSideProps の型安全な実装

### JSX/TSX最適化

4. **JSX要素の効率的な編集**
   ```typescript
   // 以下のJSXを効率的に編集する練習
   const UserList = () => {
     return (
       <div>
         <h1>Users</h1>
         <div>
           <span>John Doe</span>
           <span>jane@example.com</span>
         </div>
         <div>
           <span>Jane Smith</span>
           <span>john@example.com</span>
         </div>
       </div>
     );
   };
   ```
   - [ ] `<leader>jw`でJSX要素を別の要素で囲む
   - [ ] `<leader>jc`でclassName属性を追加
   - [ ] マルチカーソルで複数要素を同時編集

## エクササイズ3: Node.js API開発

### Express API構築

1. **プロジェクト構造の作成**
   - [ ] `<leader>ep`でExpressプロジェクト構造を作成
   - [ ] 基本的なミドルウェア設定を確認

2. **Controller作成**
   - [ ] `<leader>ec`でUserControllerを作成
   - [ ] CRUD操作を実装
   - [ ] 型安全なRequest/Responseハンドリング

3. **API ルーティング**
   ```typescript
   // practice/backend/src/routes/userRoutes.ts
   import { Router } from 'express';
   import { userController } from '../controllers/UserController';
   
   const router = Router();
   
   // この部分を完成させる
   // router.get('/', ...);
   // router.post('/', ...);
   // router.get('/:id', ...);
   // router.put('/:id', ...);
   // router.delete('/:id', ...);
   
   export default router;
   ```
   - [ ] 適切なルーティングを設定
   - [ ] ミドルウェアの適用
   - [ ] エラーハンドリングの実装

### データベース統合

4. **Prismaスキーマ設計**
   ```prisma
   // practice/backend/prisma/schema.prisma
   generator client {
     provider = "prisma-client-js"
   }
   
   datasource db {
     provider = "sqlite"
     url      = "file:./dev.db"
   }
   
   model User {
     id        Int      @id @default(autoincrement())
     email     String   @unique
     name      String?
     createdAt DateTime @default(now())
     updatedAt DateTime @updatedAt
     
     // Postモデルとのリレーションを追加
   }
   
   model Post {
     // このモデルを完成させる
   }
   ```
   - [ ] User-Post リレーションシップを定義
   - [ ] `<leader>pg`でPrismaクライアント生成
   - [ ] `<leader>pm`でマイグレーション実行

## エクササイズ4: テスト統合

### React Testing Library

1. **コンポーネントテスト**
   - [ ] `<leader>rt`でUserCardコンポーネントのテストを作成
   - [ ] render, screen, fireEvent の使用
   - [ ] ユーザーインタラクションのテスト

2. **カスタムフックテスト**
   ```typescript
   // practice/frontend/src/hooks/__tests__/useApi.test.ts
   import { renderHook, waitFor } from '@testing-library/react';
   import { useApi } from '../useApi';
   
   // モックの設定
   global.fetch = jest.fn();
   
   describe('useApi', () => {
     beforeEach(() => {
       (fetch as jest.Mock).mockClear();
     });
     
     test('successful API call', async () => {
       // このテストを完成させる
     });
     
     test('handles API errors', async () => {
       // このテストを完成させる
     });
   });
   ```
   - [ ] useApiフックのテストを完成
   - [ ] モックの適切な使用
   - [ ] 非同期処理のテスト

### API テスト

3. **Express API テスト**
   - [ ] `<leader>at`でuser APIのテストを作成
   - [ ] SuperTestを使用したHTTPテスト
   - [ ] データベースモックの設定

4. **統合テスト**
   ```typescript
   // practice/backend/__tests__/integration/user.integration.test.ts
   import request from 'supertest';
   import app from '../../src/app';
   import { PrismaClient } from '@prisma/client';
   
   const prisma = new PrismaClient();
   
   describe('User Integration Tests', () => {
     beforeEach(async () => {
       // テストデータベースのクリーンアップ
     });
     
     test('complete user workflow', async () => {
       // ユーザー作成 → 取得 → 更新 → 削除の完全なフロー
     });
   });
   ```
   - [ ] 完全なユーザーワークフローテストを実装
   - [ ] データベースの適切なセットアップ・クリーンアップ

## エクササイズ5: フルスタック統合

### プロジェクト統合

1. **フルスタックプロジェクト作成**
   - [ ] `<leader>fp`でTodoアプリプロジェクトを作成
   - [ ] フロントエンド・バックエンドの連携確認

2. **認証システムの実装**
   ```typescript
   // Frontend: src/contexts/AuthContext.tsx
   interface AuthContextType {
     user: User | null;
     login: (email: string, password: string) => Promise<void>;
     logout: () => void;
     loading: boolean;
   }
   
   // Backend: src/middleware/auth.ts
   interface AuthRequest extends Request {
     user?: User;
   }
   ```
   - [ ] JWT認証の実装
   - [ ] Contextプロバイダーの作成
   - [ ] 認証ミドルウェアの実装

3. **リアルタイム機能**
   ```typescript
   // WebSocket統合
   // Frontend: useWebSocket hook
   // Backend: Socket.io 統合
   ```
   - [ ] WebSocket接続の確立
   - [ ] リアルタイムデータ更新
   - [ ] 型安全なWebSocketメッセージ

### デプロイメント準備

4. **Docker化**
   ```dockerfile
   # practice/fullstack/Dockerfile.frontend
   FROM node:18-alpine
   WORKDIR /app
   COPY package*.json ./
   RUN npm ci --only=production
   COPY . .
   RUN npm run build
   EXPOSE 3000
   CMD ["npm", "start"]
   ```
   - [ ] フロントエンド・バックエンドのDocker化
   - [ ] docker-compose.yml の作成
   - [ ] 環境変数の適切な管理

5. **CI/CDパイプライン**
   ```yaml
   # .github/workflows/ci.yml
   name: CI/CD Pipeline
   
   on:
     push:
       branches: [ main ]
     pull_request:
       branches: [ main ]
   
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v3
         - name: Setup Node.js
           uses: actions/setup-node@v3
           with:
             node-version: '18'
         # 他のステップを追加
   ```
   - [ ] GitHub Actions ワークフロー作成
   - [ ] 自動テスト・ビルド・デプロイ
   - [ ] 品質チェックの統合

## エクササイズ6: パフォーマンス最適化

### フロントエンド最適化

1. **Bundle最適化**
   - [ ] `<leader>ba`でバンドル分析実行
   - [ ] 不要な依存関係の特定・削除
   - [ ] Code Splittingの実装

2. **React最適化**
   ```typescript
   // 最適化前のコンポーネント
   const UserList = ({ users }: { users: User[] }) => {
     return (
       <div>
         {users.map(user => (
           <UserCard key={user.id} user={user} />
         ))}
       </div>
     );
   };
   ```
   - [ ] React.memo の適用
   - [ ] useMemo, useCallback の適切な使用
   - [ ] Virtual Scrolling の実装

### バックエンド最適化

3. **データベース最適化**
   ```typescript
   // 最適化前のクエリ
   const users = await prisma.user.findMany({
     include: {
       posts: true,
       profile: true,
     },
   });
   ```
   - [ ] N+1クエリ問題の特定・修正
   - [ ] インデックスの追加
   - [ ] クエリの最適化

4. **キャッシュ戦略**
   - [ ] Redis統合
   - [ ] API レスポンスキャッシュ
   - [ ] 条件付きリクエストの実装

## チャレンジ課題

### 上級1: マイクロサービス化
- [ ] APIをマイクロサービスに分割
- [ ] サービス間通信の実装
- [ ] 分散トレーシングの導入

### 上級2: GraphQL統合
- [ ] GraphQL スキーマ設計
- [ ] Apollo Server/Client 統合
- [ ] N+1問題の解決（DataLoader）

### 上級3: PWA対応
- [ ] Service Worker 実装
- [ ] オフライン機能
- [ ] プッシュ通知

## 確認ポイント

練習完了後、以下を確認してください：

### TypeScript LSP活用
- [ ] 型情報の確認・エラー修正が迅速にできる
- [ ] 自動インポート・リファクタリングを活用できる
- [ ] TypeScript特有の操作をマスターしている

### React/Next.js開発
- [ ] 効率的なコンポーネント作成ができる
- [ ] 型安全なHooks・Context使用ができる
- [ ] Next.js固有機能を活用できる

### Node.js API開発
- [ ] 型安全なAPI設計・実装ができる
- [ ] データベース統合とORMを使いこなせる
- [ ] 適切なエラーハンドリングができる

### テスト・デバッグ
- [ ] 包括的なテストスイートを作成できる
- [ ] 効率的なデバッグワークフローを持っている
- [ ] パフォーマンス問題を特定・解決できる

### フルスタック統合
- [ ] フロントエンド・バックエンド連携ができる
- [ ] 認証・認可システムを実装できる
- [ ] デプロイメント・CI/CDを構築できる

これらのスキルを身につけることで、プロフェッショナルなTypeScript開発者として活躍できます。