# フルスタック開発体験 - ヒントとトラブルシューティング

## プロジェクト設計・アーキテクチャのコツ

### モノレポ管理のベストプラクティス

**Q: 複数のアプリケーション間での依存関係が複雑になる**

**A: 適切な依存関係管理：**

1. **明確な依存方向の定義**
   ```
   apps/web     → packages/shared
   apps/api     → packages/shared
   apps/web     → packages/database (型定義のみ)
   apps/api     → packages/database (完全な依存)
   
   ❌ 避けるべき: packages/shared → apps/web
   ```

2. **共通ロジックの適切な分離**
   ```typescript
   // packages/shared/src/types/index.ts
   export interface User {
     id: string;
     email: string;
     name: string;
     role: Role;
   }
   
   // packages/shared/src/utils/validation.ts
   export const validateEmail = (email: string): boolean => {
     return /\S+@\S+\.\S+/.test(email);
   };
   
   // packages/shared/src/constants/index.ts
   export const API_ENDPOINTS = {
     USERS: '/api/users',
     PROJECTS: '/api/projects',
     TASKS: '/api/tasks',
   } as const;
   ```

3. **LazyVimでの効率的なモノレポナビゲーション**
   ```lua
   -- より高度なワークスペース管理
   local function quick_switch()
     local options = {
       "web (Frontend)",
       "api (Backend)", 
       "shared (Types)",
       "database (Schema)",
       "root (Project Root)"
     }
     
     vim.ui.select(options, {
       prompt = "Switch to workspace:",
     }, function(choice)
       if choice:match("web") then
         vim.cmd("cd apps/web")
       elseif choice:match("api") then
         vim.cmd("cd apps/api")
       elseif choice:match("shared") then
         vim.cmd("cd packages/shared")
       elseif choice:match("database") then
         vim.cmd("cd packages/database")
       elseif choice:match("root") then
         vim.cmd("cd " .. vim.fn.expand("~/dev/taskflow"))
       end
       print("Switched to: " .. choice)
     end)
   end
   
   vim.keymap.set("n", "<leader>sw", quick_switch, { desc = "Quick Switch Workspace" })
   ```

### データベース設計のトラブルシューティング

**Q: Prismaマイグレーションでエラーが発生する**

**A: 段階的な問題解決：**

1. **マイグレーション状態の確認**
   ```bash
   # マイグレーション状態確認
   npx prisma migrate status
   
   # マイグレーション履歴確認
   npx prisma migrate diff --from-empty --to-schema-datamodel schema.prisma
   ```

2. **開発環境でのマイグレーションリセット**
   ```bash
   # 開発用データベースのリセット
   npx prisma migrate reset --force
   
   # 新しいマイグレーション作成
   npx prisma migrate dev --name describe_your_changes
   ```

3. **本番環境での安全なマイグレーション**
   ```bash
   # 本番適用前にマイグレーションを生成
   npx prisma migrate dev --create-only --name describe_your_changes
   
   # 生成されたマイグレーションファイルを確認・編集
   # 本番環境での適用
   npx prisma migrate deploy
   ```

## 認証・セキュリティの実装

### NextAuth.js トラブルシューティング

**Q: NextAuth.js の認証が正常に動作しない**

**A: 段階的なデバッグ手順：**

1. **環境変数の確認**
   ```bash
   # .env.local の設定確認
   NEXTAUTH_URL=http://localhost:3000
   NEXTAUTH_SECRET=your-secret-key-here
   DATABASE_URL=your-database-url
   ```

2. **NextAuth.js デバッグモードの有効化**
   ```typescript
   // pages/api/auth/[...nextauth].ts
   export default NextAuth({
     debug: process.env.NODE_ENV === 'development',
     logger: {
       error(code, metadata) {
         console.error(code, metadata);
       },
       warn(code) {
         console.warn(code);
       },
       debug(code, metadata) {
         console.log(code, metadata);
       },
     },
     // その他の設定...
   });
   ```

3. **セッション状態の確認**
   ```typescript
   // デバッグ用ページの作成
   import { useSession } from 'next-auth/react';
   
   export default function DebugPage() {
     const { data: session, status } = useSession();
     
     return (
       <div>
         <h1>Debug Session</h1>
         <p>Status: {status}</p>
         <pre>{JSON.stringify(session, null, 2)}</pre>
       </div>
     );
   }
   ```

### JWT・セッション管理のベストプラクティス

1. **安全なJWT設定**
   ```typescript
   // JWT設定の最適化
   export const authOptions: NextAuthOptions = {
     session: {
       strategy: "jwt",
       maxAge: 30 * 24 * 60 * 60, // 30日
     },
     jwt: {
       secret: process.env.NEXTAUTH_SECRET,
       maxAge: 30 * 24 * 60 * 60, // 30日
       encode: async ({ secret, token }) => {
         // カスタムエンコード（必要に応じて）
         return jwt.sign(token!, secret);
       },
       decode: async ({ secret, token }) => {
         // カスタムデコード（必要に応じて）
         return jwt.verify(token!, secret) as JWT;
       },
     },
     callbacks: {
       async jwt({ token, user, account }) {
         // トークンに追加情報を含める
         if (user) {
           token.role = user.role;
           token.userId = user.id;
         }
         return token;
       },
       async session({ session, token }) {
         // セッションにトークン情報を追加
         if (token) {
           session.user.id = token.userId as string;
           session.user.role = token.role as string;
         }
         return session;
       },
     },
   };
   ```

2. **認証状態の効率的な管理**
   ```typescript
   // カスタム認証フック
   import { useSession } from 'next-auth/react';
   import { useRouter } from 'next/router';
   import { useEffect } from 'react';
   
   export const useAuth = (redirectTo?: string) => {
     const { data: session, status } = useSession();
     const router = useRouter();
     
     useEffect(() => {
       if (status === 'loading') return; // まだ読み込み中
       
       if (!session && redirectTo) {
         router.push(redirectTo);
       }
     }, [session, status, router, redirectTo]);
     
     return {
       user: session?.user,
       isAuthenticated: !!session,
       isLoading: status === 'loading',
     };
   };
   ```

## API開発・バックエンドの最適化

### Express.js パフォーマンス最適化

1. **効率的なミドルウェア設定**
   ```typescript
   // パフォーマンス最適化されたExpress設定
   import express from 'express';
   import compression from 'compression';
   import rateLimit from 'express-rate-limit';
   
   const app = express();
   
   // gzip圧縮
   app.use(compression());
   
   // レート制限
   const limiter = rateLimit({
     windowMs: 15 * 60 * 1000, // 15分
     max: 100, // リクエスト制限
     message: 'Too many requests from this IP',
   });
   app.use('/api/', limiter);
   
   // JSONパーサーの最適化
   app.use(express.json({ limit: '10mb' }));
   app.use(express.urlencoded({ extended: true, limit: '10mb' }));
   ```

2. **データベースクエリの最適化**
   ```typescript
   // N+1問題の回避
   // 悪い例
   const tasks = await prisma.task.findMany();
   for (const task of tasks) {
     const assignee = await prisma.user.findUnique({
       where: { id: task.assigneeId },
     });
   }
   
   // 良い例
   const tasks = await prisma.task.findMany({
     include: {
       assignee: {
         select: {
           id: true,
           name: true,
           email: true,
           avatar: true,
         },
       },
       project: {
         select: {
           id: true,
           name: true,
         },
       },
     },
   });
   ```

3. **エラーハンドリングの統一**
   ```typescript
   // 統一されたエラーレスポンス
   export class APIError extends Error {
     statusCode: number;
     isOperational: boolean;
     
     constructor(statusCode: number, message: string, isOperational = true) {
       super(message);
       this.statusCode = statusCode;
       this.isOperational = isOperational;
       
       Error.captureStackTrace(this, this.constructor);
     }
   }
   
   // グローバルエラーハンドラー
   export const errorHandler = (
     err: Error,
     req: Request,
     res: Response,
     next: NextFunction
   ) => {
     let error = { ...err };
     error.message = err.message;
     
     // ログ出力
     console.error(err);
     
     // Prismaエラーの処理
     if (err.name === 'PrismaClientKnownRequestError') {
       const message = 'Database operation failed';
       error = new APIError(400, message);
     }
     
     // バリデーションエラーの処理
     if (err.name === 'ValidationError') {
       const message = 'Invalid input data';
       error = new APIError(400, message);
     }
     
     res.status(error.statusCode || 500).json({
       success: false,
       error: {
         message: error.message || 'Server Error',
         ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
       },
     });
   };
   ```

## フロントエンド開発・React最適化

### React Query 効率的な使用

**Q: API呼び出しが多すぎてパフォーマンスが悪い**

**A: 適切なキャッシュ戦略：**

1. **効率的なクエリキー設計**
   ```typescript
   // クエリキーの標準化
   export const queryKeys = {
     all: ['taskflow'] as const,
     projects: () => [...queryKeys.all, 'projects'] as const,
     project: (id: string) => [...queryKeys.projects(), id] as const,
     tasks: (projectId: string) => [...queryKeys.project(projectId), 'tasks'] as const,
     task: (id: string) => [...queryKeys.all, 'task', id] as const,
   };
   
   // 使用例
   export const useTasks = (projectId: string) => {
     return useQuery({
       queryKey: queryKeys.tasks(projectId),
       queryFn: () => api.get<Task[]>(`/projects/${projectId}/tasks`),
       staleTime: 5 * 60 * 1000, // 5分間はフレッシュデータとして扱う
       cacheTime: 10 * 60 * 1000, // 10分間キャッシュ保持
     });
   };
   ```

2. **楽観的更新の実装**
   ```typescript
   export const useUpdateTask = () => {
     const queryClient = useQueryClient();
     
     return useMutation({
       mutationFn: ({ taskId, data }: { taskId: string; data: UpdateTaskDto }) =>
         api.patch<Task>(`/tasks/${taskId}`, data),
       onMutate: async ({ taskId, data }) => {
         // 進行中のクエリをキャンセル
         await queryClient.cancelQueries({ queryKey: queryKeys.all });
         
         // 現在のデータのスナップショット
         const previousTasks = queryClient.getQueryData(queryKeys.tasks(data.projectId));
         
         // 楽観的更新
         queryClient.setQueryData(queryKeys.tasks(data.projectId), (old: Task[] = []) =>
           old.map((task) =>
             task.id === taskId ? { ...task, ...data } : task
           )
         );
         
         return { previousTasks };
       },
       onError: (err, variables, context) => {
         // エラー時にロールバック
         if (context?.previousTasks) {
           queryClient.setQueryData(
             queryKeys.tasks(variables.data.projectId),
             context.previousTasks
           );
         }
       },
       onSettled: (data, error, variables) => {
         // 更新完了後にクエリを無効化
         queryClient.invalidateQueries({
           queryKey: queryKeys.tasks(variables.data.projectId),
         });
       },
     });
   };
   ```

### React コンポーネントの最適化

1. **メモ化の適切な使用**
   ```typescript
   // 重い計算のメモ化
   const TaskList: React.FC<{ tasks: Task[] }> = ({ tasks }) => {
     const sortedTasks = useMemo(() => {
       return tasks
         .slice()
         .sort((a, b) => {
           // 優先度順、次に作成日順
           const priorityOrder = { URGENT: 4, HIGH: 3, MEDIUM: 2, LOW: 1 };
           const priorityDiff = priorityOrder[b.priority] - priorityOrder[a.priority];
           if (priorityDiff !== 0) return priorityDiff;
           
           return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
         });
     }, [tasks]);
     
     return (
       <div>
         {sortedTasks.map((task) => (
           <TaskCard key={task.id} task={task} />
         ))}
       </div>
     );
   };
   
   // コンポーネントのメモ化
   const TaskCard = React.memo<{ task: Task }>(({ task }) => {
     const handleStatusChange = useCallback((newStatus: TaskStatus) => {
       // ステータス変更ロジック
     }, []);
     
     return (
       <div className="task-card">
         <h3>{task.title}</h3>
         <StatusSelector 
           value={task.status} 
           onChange={handleStatusChange}
         />
       </div>
     );
   });
   ```

2. **仮想化による大量データの処理**
   ```typescript
   import { FixedSizeList as List } from 'react-window';
   
   const VirtualTaskList: React.FC<{ tasks: Task[] }> = ({ tasks }) => {
     const Row = ({ index, style }: { index: number; style: React.CSSProperties }) => (
       <div style={style}>
         <TaskCard task={tasks[index]} />
       </div>
     );
     
     return (
       <List
         height={600}
         itemCount={tasks.length}
         itemSize={120}
         width="100%"
       >
         {Row}
       </List>
     );
   };
   ```

## リアルタイム機能・Socket.io

### WebSocket 接続の最適化

**Q: Socket.io 接続が不安定または重い**

**A: 接続最適化戦略：**

1. **効率的な接続管理**
   ```typescript
   // クライアント側の最適化された接続管理
   import { io, Socket } from 'socket.io-client';
   
   class SocketManager {
     private socket: Socket | null = null;
     private reconnectAttempts = 0;
     private maxReconnectAttempts = 5;
     
     connect(token: string): Socket {
       if (this.socket?.connected) {
         return this.socket;
       }
       
       this.socket = io(process.env.NEXT_PUBLIC_API_URL!, {
         auth: { token },
         transports: ['websocket'], // WebSocketのみ使用
         upgrade: false,
         rememberUpgrade: false,
         timeout: 5000,
         reconnection: true,
         reconnectionDelay: 1000,
         reconnectionDelayMax: 5000,
         maxReconnectionAttempts: this.maxReconnectAttempts,
       });
       
       this.setupEventHandlers();
       return this.socket;
     }
     
     private setupEventHandlers() {
       if (!this.socket) return;
       
       this.socket.on('connect', () => {
         console.log('Socket connected');
         this.reconnectAttempts = 0;
       });
       
       this.socket.on('disconnect', (reason) => {
         console.log('Socket disconnected:', reason);
         if (reason === 'io server disconnect') {
           // サーバー側から切断された場合は再接続
           this.socket?.connect();
         }
       });
       
       this.socket.on('connect_error', (error) => {
         console.error('Socket connection error:', error);
         this.reconnectAttempts++;
         
         if (this.reconnectAttempts >= this.maxReconnectAttempts) {
           console.error('Max reconnection attempts reached');
           this.socket?.disconnect();
         }
       });
     }
     
     disconnect() {
       if (this.socket) {
         this.socket.disconnect();
         this.socket = null;
       }
     }
   }
   
   export const socketManager = new SocketManager();
   ```

2. **イベントの効率的な管理**
   ```typescript
   // React フック内でのSocket管理
   const useSocket = (projectId: string) => {
     const [socket, setSocket] = useState<Socket | null>(null);
     const [isConnected, setIsConnected] = useState(false);
     const { data: session } = useSession();
     
     useEffect(() => {
       if (!session?.accessToken) return;
       
       const socketInstance = socketManager.connect(session.accessToken);
       setSocket(socketInstance);
       
       socketInstance.on('connect', () => setIsConnected(true));
       socketInstance.on('disconnect', () => setIsConnected(false));
       
       // プロジェクトルームに参加
       socketInstance.emit('join:project', projectId);
       
       return () => {
         socketInstance.emit('leave:project', projectId);
         socketInstance.off('connect');
         socketInstance.off('disconnect');
       };
     }, [session?.accessToken, projectId]);
     
     return { socket, isConnected };
   };
   ```

## デプロイ・運用のトラブルシューティング

### Vercel デプロイ問題

**Q: Vercel でビルドエラーが発生する**

**A: 段階的な問題解決：**

1. **ビルド設定の最適化**
   ```json
   // vercel.json
   {
     "buildCommand": "npm run build",
     "outputDirectory": ".next",
     "installCommand": "npm ci",
     "framework": "nextjs",
     "functions": {
       "app/api/**": {
         "maxDuration": 30
       }
     },
     "regions": ["iad1"],
     "env": {
       "NODE_ENV": "production"
     }
   }
   ```

2. **Next.js 設定の最適化**
   ```javascript
   // next.config.js
   /** @type {import('next').NextConfig} */
   const nextConfig = {
     experimental: {
       appDir: true,
     },
     images: {
       domains: ['cloudinary.com', 'res.cloudinary.com'],
     },
     typescript: {
       // 型エラーがあってもビルドを継続（本番では推奨しない）
       ignoreBuildErrors: false,
     },
     eslint: {
       // ESLintエラーがあってもビルドを継続（本番では推奨しない）
       ignoreDuringBuilds: false,
     },
     webpack: (config, { dev, isServer }) => {
       if (!dev && !isServer) {
         // 本番ビルド時の最適化
         config.resolve.alias = {
           ...config.resolve.alias,
           '@': path.resolve(__dirname, 'src'),
         };
       }
       return config;
     },
   };
   
   module.exports = nextConfig;
   ```

### Railway API デプロイ問題

1. **環境変数の適切な設定**
   ```bash
   # Railway CLI での環境変数設定
   railway variables set DATABASE_URL=postgresql://...
   railway variables set JWT_SECRET=your-jwt-secret
   railway variables set NODE_ENV=production
   ```

2. **Dockerfile の最適化**
   ```dockerfile
   # Dockerfile (apps/api)
   FROM node:18-alpine AS base
   
   # 依存関係のインストール
   FROM base AS deps
   WORKDIR /app
   COPY package*.json ./
   COPY packages/database/package*.json ./packages/database/
   COPY packages/shared/package*.json ./packages/shared/
   RUN npm ci --only=production
   
   # アプリケーションのビルド
   FROM base AS builder
   WORKDIR /app
   COPY . .
   RUN npm ci
   RUN npm run build:api
   
   # 本番イメージ
   FROM base AS runner
   WORKDIR /app
   
   RUN addgroup --system --gid 1001 nodejs
   RUN adduser --system --uid 1001 nextjs
   
   COPY --from=deps /app/node_modules ./node_modules
   COPY --from=builder /app/apps/api/dist ./apps/api/dist
   COPY --from=builder /app/packages ./packages
   
   USER nextjs
   
   EXPOSE 3001
   
   CMD ["node", "apps/api/dist/server.js"]
   ```

## パフォーマンス最適化・モニタリング

### フロントエンド パフォーマンス

1. **Core Web Vitals の最適化**
   ```typescript
   // Web Vitals監視の実装
   import { getCLS, getFID, getFCP, getLCP, getTTFB } from 'web-vitals';
   
   const sendToAnalytics = (metric: any) => {
     // パフォーマンスデータの送信
     if (process.env.NODE_ENV === 'production') {
       fetch('/api/analytics/web-vitals', {
         method: 'POST',
         headers: { 'Content-Type': 'application/json' },
         body: JSON.stringify(metric),
       });
     }
   };
   
   // アプリケーション起動時に測定開始
   export const initPerformanceMonitoring = () => {
     getCLS(sendToAnalytics);
     getFID(sendToAnalytics);
     getFCP(sendToAnalytics);
     getLCP(sendToAnalytics);
     getTTFB(sendToAnalytics);
   };
   ```

2. **画像最適化の実装**
   ```typescript
   // Next.js Image コンポーネントの最適化
   import Image from 'next/image';
   
   const OptimizedImage: React.FC<{
     src: string;
     alt: string;
     width: number;
     height: number;
   }> = ({ src, alt, width, height }) => {
     return (
       <Image
         src={src}
         alt={alt}
         width={width}
         height={height}
         placeholder="blur"
         blurDataURL="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAAIAAoDASIAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAv/xAAhEAACAQMDBQAAAAAAAAAAAAABAgMABAUGIWEREiMxUf/EABUBAQEAAAAAAAAAAAAAAAAAAAMF/8QAGhEAAgIDAAAAAAAAAAAAAAAAAAECEgMRkf/aAAwDAQACEQMRAD8AltJagyeH0AthI5xdrLcNM91BF5pX2HaH9bcfaSXWGaRmknyejFBVWctnTEoWZsUjIsV6TsV6OKH1lsV6OJc2+7ZO2Z8lBFF1KFyUAqVvGKLrNHJTT5p/tUAUs=/1"
         priority={false}
         loading="lazy"
         sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
       />
     );
   };
   ```

### バックエンド パフォーマンス

1. **データベースクエリの監視**
   ```typescript
   // Prisma クエリの監視
   const prisma = new PrismaClient({
     log: [
       { level: 'query', emit: 'event' },
       { level: 'error', emit: 'stdout' },
       { level: 'info', emit: 'stdout' },
       { level: 'warn', emit: 'stdout' },
     ],
   });
   
   prisma.$on('query', (e) => {
     if (e.duration > 1000) {
       console.warn(`Slow query detected: ${e.duration}ms`);
       console.warn(`Query: ${e.query}`);
       console.warn(`Params: ${e.params}`);
     }
   });
   ```

2. **API レスポンス時間の監視**
   ```typescript
   // レスポンス時間監視ミドルウェア
   export const responseTimeMiddleware = (
     req: Request,
     res: Response,
     next: NextFunction
   ) => {
     const start = Date.now();
     
     res.on('finish', () => {
       const duration = Date.now() - start;
       
       // ログ出力
       console.log(`${req.method} ${req.originalUrl} - ${duration}ms`);
       
       // 遅いAPIの警告
       if (duration > 1000) {
         console.warn(`Slow API endpoint: ${req.originalUrl} took ${duration}ms`);
       }
       
       // メトリクス送信（本番環境）
       if (process.env.NODE_ENV === 'production') {
         // メトリクス送信ロジック
       }
     });
     
     next();
   };
   ```

## LazyVim 統合開発環境の最適化

### プロジェクト固有設定の高度化

```lua
-- より高度な TaskFlow プロジェクト設定
-- .nvim.lua

-- プロジェクト状態の管理
local project_state = {
  current_workspace = "root",
  dev_servers = {
    web = false,
    api = false,
  },
  last_test_result = nil,
}

-- 開発サーバーの状態管理
local function toggle_dev_server(server_type)
  if project_state.dev_servers[server_type] then
    -- サーバー停止
    vim.cmd("!pkill -f 'npm run dev:" .. server_type .. "'")
    project_state.dev_servers[server_type] = false
    print(server_type .. " server stopped")
  else
    -- サーバー開始
    vim.cmd("!" .. "cd apps/" .. server_type .. " && npm run dev &")
    project_state.dev_servers[server_type] = true
    print(server_type .. " server started")
  end
end

-- ダッシュボード表示
local function show_project_dashboard()
  local lines = {
    "TaskFlow Development Dashboard",
    "================================",
    "",
    "Current Workspace: " .. project_state.current_workspace,
    "",
    "Development Servers:",
    "  Web (Frontend): " .. (project_state.dev_servers.web and "🟢 Running" or "🔴 Stopped"),
    "  API (Backend):  " .. (project_state.dev_servers.api and "🟢 Running" or "🔴 Stopped"),
    "",
    "Quick Actions:",
    "  <leader>dw - Toggle Web Server",
    "  <leader>da - Toggle API Server", 
    "  <leader>dm - Run Database Migration",
    "  <leader>tt - Run All Tests",
    "",
    "Last Test Result: " .. (project_state.last_test_result or "None"),
  }
  
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_current_buf(buf)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"
end

-- カスタムキーマップ
vim.keymap.set("n", "<leader>pd", show_project_dashboard, { desc = "Project Dashboard" })
vim.keymap.set("n", "<leader>dw", function() toggle_dev_server("web") end, { desc = "Toggle Web Server" })
vim.keymap.set("n", "<leader>da", function() toggle_dev_server("api") end, { desc = "Toggle API Server" })

-- Git統合の強化
vim.keymap.set("n", "<leader>gf", function()
  -- 現在のブランチで作業中のファイルを自動ステージング
  vim.cmd("!git add $(git diff --name-only)")
  local commit_msg = vim.fn.input("Commit message: ")
  if commit_msg ~= "" then
    vim.cmd("!git commit -m '" .. commit_msg .. "'")
    print("Changes committed: " .. commit_msg)
  end
end, { desc = "Quick Git Commit" })

-- テスト結果の保存
vim.api.nvim_create_user_command("RunTests", function()
  project_state.last_test_result = "Running..."
  vim.cmd("!npm test")
  project_state.last_test_result = "Completed at " .. os.date("%H:%M:%S")
end, {})

print("TaskFlow advanced development environment loaded!")
```

## 最終的なプロジェクト品質確保

### コードレビュー チェックリスト

1. **セキュリティ**
   - [ ] 認証・認可が適切に実装されている
   - [ ] SQLインジェクション対策済み
   - [ ] XSS対策済み
   - [ ] CSRF対策済み
   - [ ] 機密情報の適切な管理

2. **パフォーマンス**
   - [ ] データベースクエリが最適化されている
   - [ ] N+1問題が解決されている
   - [ ] 適切なキャッシュ戦略
   - [ ] 画像・アセットの最適化

3. **テスト品質**
   - [ ] 十分なテストカバレッジ（>80%）
   - [ ] E2Eテストの実装
   - [ ] エラーケースのテスト
   - [ ] パフォーマンステスト

4. **運用準備**
   - [ ] 適切なログ出力
   - [ ] エラー監視の設定
   - [ ] ヘルスチェック機能
   - [ ] バックアップ・復旧手順

このフルスタック開発体験を通じて、実際のプロダクト開発で直面する様々な課題と解決方法を習得し、プロフェッショナルレベルの開発スキルを身につけることができます。