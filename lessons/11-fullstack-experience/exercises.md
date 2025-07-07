# フルスタック開発体験 - エクササイズ

## 準備: TaskFlowプロジェクトの初期化

### 環境確認
```bash
# 必要なツールの確認
node --version    # v18.0.0+
npm --version     # v8.0.0+
git --version     # v2.30.0+
docker --version  # v20.0.0+

# アカウント準備の確認
echo "Vercel account ready: https://vercel.com"
echo "Railway account ready: https://railway.app"
echo "GitHub account ready: https://github.com"
```

### プロジェクト作成
```bash
# TaskFlowプロジェクトの作成
cd ~/dev
mkdir taskflow && cd taskflow
```

## フェーズ1: プロジェクト設計・セットアップ (2-3時間)

### エクササイズ1.1: プロジェクト構造の作成

1. **モノレポ構成の初期化**
   - [ ] LazyVimで`<leader>ct`を実行してTaskFlowプロジェクトを作成
   - [ ] 生成されたディレクトリ構造を確認
   - [ ] ルートpackage.jsonの内容を確認

2. **ワークスペース設定**
   ```bash
   # 各アプリケーションの初期化
   cd apps/web
   npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
   
   cd ../api
   npm init -y
   npm install express cors helmet morgan bcryptjs jsonwebtoken
   npm install -D @types/express @types/cors @types/bcryptjs @types/jsonwebtoken typescript ts-node nodemon
   ```
   - [ ] Next.jsアプリケーションの初期化完了
   - [ ] Express APIの初期化完了
   - [ ] TypeScript設定の確認

3. **共通パッケージの設定**
   ```bash
   cd ../../packages/database
   npm init -y
   npm install prisma @prisma/client
   npm install -D typescript
   
   cd ../shared
   npm init -y
   npm install -D typescript
   ```
   - [ ] Prismaパッケージのセットアップ
   - [ ] 共有型定義パッケージの作成

### エクササイズ1.2: データベース設計

1. **Prismaスキーマの作成**
   ```bash
   cd packages/database
   npx prisma init
   ```
   - [ ] `schema.prisma`ファイルをguide.mdの内容で更新
   - [ ] モデル関係の確認（User, Project, Task, Comment等）

2. **データベース初期化**
   ```bash
   # 開発用SQLiteデータベースの設定
   DATABASE_URL="file:./dev.db"
   npx prisma migrate dev --name init
   npx prisma generate
   ```
   - [ ] マイグレーションファイルの生成確認
   - [ ] Prisma Clientの生成確認

3. **LazyVimでのPrisma開発**
   - [ ] `<leader>dm`でマイグレーション実行のテスト
   - [ ] `<leader>dg`でPrismaクライアント生成のテスト
   - [ ] `<leader>ds`でPrisma Studioの起動確認

### エクササイズ1.3: 開発環境統合

1. **LazyVim設定の最適化**
   - [ ] プロジェクトルートの`.nvim.lua`設定を確認
   - [ ] `<leader>pw`（Web切り替え）の動作確認
   - [ ] `<leader>pa`（API切り替え）の動作確認

2. **開発ツールの統合**
   ```bash
   # ルートレベルでの設定
   npm install -D eslint prettier husky lint-staged
   npx husky install
   ```
   - [ ] ESLint設定の統合
   - [ ] Prettier設定の統合
   - [ ] Git hooksの設定

## フェーズ2: コア機能開発 (8-10時間)

### エクササイズ2.1: 認証システム構築

1. **NextAuth.js セットアップ**
   ```bash
   cd apps/web
   npm install next-auth @next-auth/prisma-adapter
   npm install bcryptjs
   npm install -D @types/bcryptjs
   ```
   - [ ] NextAuth.js設定ファイルの作成
   - [ ] 認証プロバイダー（Credentials）の設定
   - [ ] セッション管理の実装

2. **認証フロー UI の実装**
   ```typescript
   // apps/web/src/components/auth/SignInForm.tsx を作成
   // apps/web/src/components/auth/SignUpForm.tsx を作成
   // apps/web/src/pages/auth/signin.tsx を作成
   // apps/web/src/pages/auth/signup.tsx を作成
   ```
   - [ ] サインインフォームの実装
   - [ ] サインアップフォームの実装
   - [ ] フォームバリデーションの追加
   - [ ] エラーハンドリングの実装

3. **認証ミドルウェアの作成**
   ```typescript
   // apps/api/src/middleware/auth.ts を作成
   // JWT認証ミドルウェアの実装
   ```
   - [ ] JWT生成・検証機能の実装
   - [ ] 認証ミドルウェアの作成
   - [ ] 保護されたルートの設定

### エクササイズ2.2: API開発

1. **Express サーバーのセットアップ**
   ```typescript
   // apps/api/src/server.ts を作成
   // 基本的なExpress設定
   // ミドルウェア（CORS, Helmet, Morgan）の設定
   // エラーハンドリングミドルウェア
   ```
   - [ ] Express サーバーの基本構成
   - [ ] セキュリティミドルウェアの設定
   - [ ] グローバルエラーハンドラー

2. **コントローラーの実装**
   ```bash
   # UserController, ProjectController, TaskController の作成
   ```
   - [ ] `<leader>ec`でUserControllerを作成
   - [ ] `<leader>ec`でProjectControllerを作成  
   - [ ] `<leader>ec`でTaskControllerを作成
   - [ ] CRUD操作の実装

3. **ルーティングの設定**
   ```typescript
   // apps/api/src/routes/ 以下にルートファイルを作成
   // userRoutes.ts, projectRoutes.ts, taskRoutes.ts
   ```
   - [ ] RESTful APIルートの設計
   - [ ] 認証が必要なルートの保護
   - [ ] バリデーションミドルウェアの統合

### エクササイズ2.3: フロントエンド開発

1. **状態管理の実装**
   ```bash
   cd apps/web
   npm install @tanstack/react-query zustand
   ```
   - [ ] React Queryのセットアップ
   - [ ] API クライアントの作成
   - [ ] カスタムフックの実装（useTasks, useProjects等）

2. **UI コンポーネントの実装**
   ```bash
   # Shadcn/uiの設定
   npx shadcn-ui@latest init
   npx shadcn-ui@latest add button input label card
   ```
   - [ ] `<leader>rc`でTaskCardコンポーネントを作成
   - [ ] `<leader>rc`でProjectCardコンポーネントを作成
   - [ ] TaskBoard コンポーネントの実装

3. **ページレイアウトの作成**
   - [ ] `<leader>np`でダッシュボードページを作成
   - [ ] `<leader>np`でプロジェクト詳細ページを作成
   - [ ] ナビゲーション・レイアウトコンポーネント

### エクササイズ2.4: 統合テスト

1. **API テストの実装**
   ```bash
   cd apps/api
   npm install -D jest supertest @types/jest @types/supertest
   ```
   - [ ] `<leader>at`でuser APIテストを作成
   - [ ] `<leader>at`でtask APIテストを作成
   - [ ] 認証テストの実装

2. **フロントエンドテストの実装**
   ```bash
   cd apps/web
   npm install -D @testing-library/react @testing-library/jest-dom @testing-library/user-event
   ```
   - [ ] `<leader>rt`でTaskCardコンポーネントテストを作成
   - [ ] `<leader>rt`でSignInFormコンポーネントテストを作成
   - [ ] カスタムフックのテスト

## フェーズ3: 高度機能・統合 (6-8時間)

### エクササイズ3.1: リアルタイム機能

1. **Socket.io サーバー統合**
   ```bash
   cd apps/api
   npm install socket.io
   npm install -D @types/socket.io
   ```
   - [ ] Socket.io サーバーの設定
   - [ ] 認証ミドルウェアの統合
   - [ ] プロジェクトルーム管理の実装

2. **クライアント側WebSocket**
   ```bash
   cd apps/web
   npm install socket.io-client
   ```
   - [ ] Socket.io クライアントの設定
   - [ ] リアルタイム更新の実装
   - [ ] 接続状態の管理

3. **リアルタイム機能の実装**
   - [ ] タスク状態のリアルタイム同期
   - [ ] 入力状態の表示（誰かがタイピング中）
   - [ ] オンラインユーザーの表示

### エクササイズ3.2: ドラッグ&ドロップ

1. **react-beautiful-dnd の統合**
   ```bash
   cd apps/web
   npm install react-beautiful-dnd
   npm install -D @types/react-beautiful-dnd
   ```
   - [ ] TaskBoardでのドラッグ&ドロップ実装
   - [ ] タスク状態の自動更新
   - [ ] アニメーション・UXの最適化

2. **状態管理の最適化**
   - [ ] 楽観的更新の実装
   - [ ] エラーハンドリング・ロールバック
   - [ ] パフォーマンス最適化

### エクササイズ3.3: ファイルアップロード

1. **画像アップロード機能**
   ```bash
   # Cloudinary または AWS S3 の設定
   cd apps/api
   npm install multer cloudinary
   npm install -D @types/multer
   ```
   - [ ] ファイルアップロード APIの実装
   - [ ] プロフィール画像アップロード
   - [ ] タスク添付ファイル機能

2. **フロントエンド ファイル処理**
   - [ ] ドラッグ&ドロップファイルアップロード
   - [ ] プレビュー機能
   - [ ] プログレス表示

## フェーズ4: デプロイ・運用 (3-4時間)

### エクササイズ4.1: CI/CD パイプライン

1. **GitHub Actions 設定**
   ```yaml
   # .github/workflows/ci-cd.yml の作成
   ```
   - [ ] Lint・TypeScriptチェックの自動化
   - [ ] 自動テスト実行
   - [ ] ビルド・デプロイの自動化

2. **環境変数管理**
   - [ ] 開発・本番環境の分離
   - [ ] シークレットの適切な管理
   - [ ] 環境固有設定の実装

### エクササイズ4.2: 本番デプロイ

1. **Railway API デプロイ**
   ```bash
   # Railway CLI の設定
   npm install -g @railway/cli
   railway login
   railway init
   ```
   - [ ] PostgreSQL データベースの作成
   - [ ] 環境変数の設定
   - [ ] API サーバーのデプロイ

2. **Vercel フロントエンドデプロイ**
   ```bash
   # Vercel CLI の設定
   npm install -g vercel
   vercel login
   vercel
   ```
   - [ ] ビルド設定の最適化
   - [ ] 環境変数の設定
   - [ ] Next.js アプリのデプロイ

3. **ドメイン・SSL設定**
   - [ ] カスタムドメインの設定
   - [ ] SSL証明書の自動取得
   - [ ] CDN設定の最適化

### エクササイズ4.3: 監視・運用

1. **エラー監視の設定**
   ```bash
   # Sentry の統合
   cd apps/web
   npm install @sentry/nextjs
   
   cd ../api
   npm install @sentry/node
   ```
   - [ ] Sentry プロジェクトの作成
   - [ ] エラー監視の設定
   - [ ] アラート設定

2. **パフォーマンス監視**
   - [ ] Web Vitals の測定
   - [ ] API レスポンス時間の監視
   - [ ] データベースクエリの最適化

3. **ログ・メトリクス**
   - [ ] 構造化ログの実装
   - [ ] メトリクス収集の設定
   - [ ] ダッシュボードの作成

## エクササイズ4.4: スケーリング・最適化

1. **パフォーマンス最適化**
   - [ ] React コンポーネントの最適化（memo, useMemo）
   - [ ] 画像最適化・遅延読み込み
   - [ ] バンドルサイズの最適化

2. **データベース最適化**
   - [ ] クエリの最適化・インデックス追加
   - [ ] N+1問題の解決
   - [ ] コネクションプールの設定

3. **キャッシュ戦略**
   - [ ] Redis キャッシュの実装
   - [ ] CDN キャッシュの最適化
   - [ ] ブラウザキャッシュの設定

## チャレンジ課題

### 上級1: マルチテナント対応
- [ ] 組織・チーム機能の実装
- [ ] データ分離・セキュリティ強化
- [ ] 権限管理の高度化

### 上級2: モバイルアプリ開発
- [ ] React Native アプリの作成
- [ ] プッシュ通知の実装
- [ ] オフライン機能の対応

### 上級3: 高度な分析機能
- [ ] タスク分析・レポート機能
- [ ] 時間トラッキング
- [ ] 生産性メトリクスの可視化

### 上級4: 国際化対応
- [ ] 多言語対応（i18n）
- [ ] タイムゾーン対応
- [ ] 地域別設定

## 最終確認ポイント

### 機能面の確認
- [ ] ユーザー認証・認可が正常に動作する
- [ ] タスク・プロジェクト管理の完全なCRUD操作
- [ ] リアルタイム更新が全ての機能で動作
- [ ] ファイルアップロード・添付機能
- [ ] 通知システムの動作

### 技術面の確認
- [ ] TypeScript の型安全性が保たれている
- [ ] 全てのテストが通過する
- [ ] LazyVim ワークフローが効率的に活用できている
- [ ] パフォーマンスが最適化されている
- [ ] セキュリティベストプラクティスが実装されている

### 運用面の確認
- [ ] CI/CD パイプラインが自動化されている
- [ ] 本番環境で安定稼働している
- [ ] 監視・アラートが設定されている
- [ ] バックアップ・復旧手順が確立されている
- [ ] スケーリング戦略が準備されている

### LazyVim活用度の確認
- [ ] プロジェクト間の効率的な移動
- [ ] LSP・自動補完を最大限活用
- [ ] カスタムキーマップで開発効率化
- [ ] 統合デバッグ環境の活用
- [ ] Git統合ワークフローの実践

このフルスタック開発体験を通じて、プロフェッショナルレベルの開発スキルとLazyVimの完全マスターを達成できます。完成したTaskFlowアプリケーションは、ポートフォリオとして活用し、キャリアアップに繋げることができます。