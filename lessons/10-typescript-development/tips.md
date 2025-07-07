# TypeScript開発 - ヒントとトラブルシューティング

## TypeScript LSP関連のトラブルシューティング

### Q: TypeScript LSPが遅い・重い

**A: パフォーマンス最適化手順：**

1. **tsconfig.json の最適化**
   ```json
   {
     "compilerOptions": {
       "incremental": true,
       "tsBuildInfoFile": ".tsbuildinfo",
       "skipLibCheck": true,
       "skipDefaultLibCheck": true
     },
     "include": ["src/**/*"],
     "exclude": ["node_modules", "dist", "build", "**/*.test.ts"]
   }
   ```

2. **LSP設定の調整**
   ```lua
   -- TypeScript LSP最適化
   return {
     "neovim/nvim-lspconfig",
     opts = {
       servers = {
         tsserver = {
           settings = {
             typescript = {
               maxTsServerMemory = 4096,
               preferences = {
                 includeCompletionsForModuleExports = false,
                 includeCompletionsWithInsertText = false,
               },
             },
           },
         },
       },
     },
   }
   ```

3. **大きなプロジェクトでの対策**
   ```lua
   -- プロジェクトサイズ制限
   vim.api.nvim_create_autocmd("BufReadPre", {
     pattern = "*.{ts,tsx,js,jsx}",
     callback = function()
       local file_size = vim.fn.getfsize(vim.fn.expand("%"))
       if file_size > 1024 * 1024 then -- 1MB以上
         vim.b.large_buf = true
         vim.cmd("syntax off")
         print("Large file detected, syntax disabled")
       end
     end,
   })
   ```

### Q: 自動インポートが機能しない

**A: 段階的な確認手順：**

1. **TypeScript設定確認**
   ```json
   // tsconfig.json
   {
     "compilerOptions": {
       "baseUrl": ".",
       "paths": {
         "@/*": ["src/*"],
         "@/components/*": ["src/components/*"]
       },
       "moduleResolution": "node"
     }
   }
   ```

2. **LSP設定確認**
   ```lua
   -- 自動インポート設定
   vim.api.nvim_create_autocmd("LspAttach", {
     callback = function(event)
       local client = vim.lsp.get_client_by_id(event.data.client_id)
       if client and client.name == "tsserver" then
         -- 自動インポート有効化
         vim.keymap.set("n", "<leader>ai", function()
           vim.lsp.buf.code_action({
             context = { only = { "source.addMissingImports" } },
             apply = true,
           })
         end, { buffer = event.buf, desc = "Add Missing Imports" })
       end
     end,
   })
   ```

3. **手動でのトリガー**
   ```vim
   " インポート追加の手動実行
   :lua vim.lsp.buf.code_action({context = {only = {"source.addMissingImports"}}, apply = true})
   ```

## React/Next.js開発のベストプラクティス

### パフォーマンス最適化

1. **効率的なRe-render対策**
   ```typescript
   // 悪い例：毎回新しいオブジェクトを作成
   const BadComponent = ({ items }: { items: Item[] }) => {
     return (
       <List 
         items={items}
         config={{ sortBy: 'name', order: 'asc' }} // 毎回新しいオブジェクト
       />
     );
   };
   
   // 良い例：オブジェクトを外部で定義またはuseMemo使用
   const SORT_CONFIG = { sortBy: 'name', order: 'asc' };
   
   const GoodComponent = ({ items }: { items: Item[] }) => {
     const sortConfig = useMemo(() => ({ 
       sortBy: 'name', 
       order: 'asc' 
     }), []);
     
     return <List items={items} config={SORT_CONFIG} />;
   };
   ```

2. **型安全なProps設計**
   ```typescript
   // 汎用的で再利用可能なコンポーネント設計
   interface BaseButtonProps {
     children: React.ReactNode;
     disabled?: boolean;
     loading?: boolean;
   }
   
   interface PrimaryButtonProps extends BaseButtonProps {
     variant: 'primary';
     onClick: () => void;
   }
   
   interface LinkButtonProps extends BaseButtonProps {
     variant: 'link';
     href: string;
   }
   
   type ButtonProps = PrimaryButtonProps | LinkButtonProps;
   
   const Button: React.FC<ButtonProps> = (props) => {
     if (props.variant === 'link') {
       return <a href={props.href}>{props.children}</a>;
     }
     return <button onClick={props.onClick}>{props.children}</button>;
   };
   ```

### Next.js特有の問題

1. **Static Generation vs Server-Side Rendering**
   ```typescript
   // ISR (Incremental Static Regeneration) の活用
   export const getStaticProps: GetStaticProps = async () => {
     const data = await fetchData();
     
     return {
       props: { data },
       revalidate: 3600, // 1時間ごとに再生成
     };
   };
   
   // 動的ルートでのISR
   export const getStaticPaths: GetStaticPaths = async () => {
     const paths = await getPopularPaths();
     
     return {
       paths,
       fallback: 'blocking', // 新しいパスは動的に生成
     };
   };
   ```

2. **API Routes最適化**
   ```typescript
   // エラーハンドリングとバリデーション
   import { z } from 'zod';
   
   const CreateUserSchema = z.object({
     name: z.string().min(1),
     email: z.string().email(),
   });
   
   export default async function handler(
     req: NextApiRequest,
     res: NextApiResponse
   ) {
     if (req.method !== 'POST') {
       return res.status(405).json({ error: 'Method not allowed' });
     }
     
     try {
       const body = CreateUserSchema.parse(req.body);
       const user = await createUser(body);
       res.status(201).json(user);
     } catch (error) {
       if (error instanceof z.ZodError) {
         return res.status(400).json({ error: error.issues });
       }
       res.status(500).json({ error: 'Internal server error' });
     }
   }
   ```

## Node.js API開発のベストプラクティス

### エラーハンドリング戦略

1. **統一されたエラーレスポンス**
   ```typescript
   // カスタムエラークラス
   export class AppError extends Error {
     constructor(
       public statusCode: number,
       public message: string,
       public isOperational = true
     ) {
       super(message);
       Object.setPrototypeOf(this, AppError.prototype);
     }
   }
   
   // グローバルエラーハンドラー
   export const globalErrorHandler = (
     err: Error,
     req: Request,
     res: Response,
     next: NextFunction
   ) => {
     if (err instanceof AppError) {
       return res.status(err.statusCode).json({
         error: {
           message: err.message,
           statusCode: err.statusCode,
           timestamp: new Date().toISOString(),
           path: req.path,
         },
       });
     }
     
     // 未知のエラー
     console.error(err);
     res.status(500).json({
       error: {
         message: 'Internal server error',
         statusCode: 500,
         timestamp: new Date().toISOString(),
         path: req.path,
       },
     });
   };
   ```

2. **バリデーション統合**
   ```typescript
   import { z } from 'zod';
   
   // バリデーションミドルウェア
   export const validate = (schema: z.ZodSchema) => {
     return (req: Request, res: Response, next: NextFunction) => {
       try {
         schema.parse(req.body);
         next();
       } catch (error) {
         if (error instanceof z.ZodError) {
           return res.status(400).json({
             error: {
               message: 'Validation failed',
               details: error.issues,
             },
           });
         }
         next(error);
       }
     };
   };
   
   // 使用例
   const CreateUserSchema = z.object({
     name: z.string().min(1, 'Name is required'),
     email: z.string().email('Invalid email format'),
     age: z.number().min(0).max(120),
   });
   
   router.post('/users', validate(CreateUserSchema), userController.create);
   ```

### データベース最適化

1. **Prisma最適化パターン**
   ```typescript
   // N+1問題の回避
   // 悪い例
   const posts = await prisma.post.findMany();
   for (const post of posts) {
     const author = await prisma.user.findUnique({
       where: { id: post.authorId },
     });
   }
   
   // 良い例
   const posts = await prisma.post.findMany({
     include: {
       author: true,
     },
   });
   
   // さらに最適化：特定フィールドのみ取得
   const posts = await prisma.post.findMany({
     select: {
       id: true,
       title: true,
       content: true,
       author: {
         select: {
           id: true,
           name: true,
         },
       },
     },
   });
   ```

2. **トランザクション処理**
   ```typescript
   // 安全なトランザクション
   export const transferFunds = async (
     fromUserId: number,
     toUserId: number,
     amount: number
   ) => {
     return await prisma.$transaction(async (tx) => {
       // 送金者の残高確認
       const fromUser = await tx.user.findUnique({
         where: { id: fromUserId },
         select: { balance: true },
       });
       
       if (!fromUser || fromUser.balance < amount) {
         throw new AppError(400, 'Insufficient funds');
       }
       
       // 残高更新（原子的操作）
       await tx.user.update({
         where: { id: fromUserId },
         data: { balance: { decrement: amount } },
       });
       
       await tx.user.update({
         where: { id: toUserId },
         data: { balance: { increment: amount } },
       });
       
       // 取引履歴の記録
       await tx.transaction.create({
         data: {
           fromUserId,
           toUserId,
           amount,
           type: 'TRANSFER',
         },
       });
     });
   };
   ```

## テスト・デバッグのコツ

### React Testing Library活用

1. **効果的なテスト戦略**
   ```typescript
   // カスタムレンダー関数
   const customRender = (
     ui: ReactElement,
     options?: {
       initialState?: Partial<AppState>;
       ...RenderOptions;
     }
   ) => {
     const { initialState, ...renderOptions } = options || {};
     
     const store = createStore(initialState);
     
     const Wrapper: React.FC<{ children: ReactNode }> = ({ children }) => (
       <Provider store={store}>
         <Router>
           {children}
         </Router>
       </Provider>
     );
     
     return render(ui, { wrapper: Wrapper, ...renderOptions });
   };
   
   // 使用例
   test('user can add item to cart', async () => {
     const user = userEvent.setup();
     customRender(<ProductPage />, {
       initialState: { cart: { items: [] } },
     });
     
     const addButton = screen.getByRole('button', { name: /add to cart/i });
     await user.click(addButton);
     
     expect(screen.getByText(/item added to cart/i)).toBeInTheDocument();
   });
   ```

2. **MSW (Mock Service Worker) 活用**
   ```typescript
   // src/mocks/handlers.ts
   import { rest } from 'msw';
   
   export const handlers = [
     rest.get('/api/users', (req, res, ctx) => {
       return res(
         ctx.json([
           { id: 1, name: 'John Doe', email: 'john@example.com' },
           { id: 2, name: 'Jane Smith', email: 'jane@example.com' },
         ])
       );
     }),
     
     rest.post('/api/users', async (req, res, ctx) => {
       const newUser = await req.json();
       return res(
         ctx.status(201),
         ctx.json({ id: 3, ...newUser })
       );
     }),
   ];
   
   // テストでの使用
   test('fetches and displays users', async () => {
     render(<UserList />);
     
     expect(screen.getByText('Loading...')).toBeInTheDocument();
     
     await waitFor(() => {
       expect(screen.getByText('John Doe')).toBeInTheDocument();
       expect(screen.getByText('Jane Smith')).toBeInTheDocument();
     });
   });
   ```

### デバッグ効率化

1. **TypeScript デバッグ設定**
   ```json
   // .vscode/launch.json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "Debug Next.js",
         "type": "node",
         "request": "launch",
         "program": "${workspaceFolder}/node_modules/next/dist/bin/next",
         "args": ["dev"],
         "console": "integratedTerminal",
         "serverReadyAction": {
           "pattern": "ready - started server on .+, url: (https?://.+)",
           "uriFormat": "%s",
           "action": "debugWithChrome"
         }
       },
       {
         "name": "Debug Node.js API",
         "type": "node",
         "request": "launch",
         "program": "${workspaceFolder}/src/server.ts",
         "outFiles": ["${workspaceFolder}/dist/**/*.js"],
         "env": {
           "NODE_ENV": "development"
         }
       }
     ]
   }
   ```

2. **Neovim DAP設定**
   ```lua
   -- TypeScript/Node.js デバッグ設定
   local dap = require("dap")
   
   dap.adapters.node2 = {
     type = "executable",
     command = "node",
     args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
   }
   
   dap.configurations.typescript = {
     {
       name = "Launch",
       type = "node2",
       request = "launch",
       program = "${file}",
       cwd = vim.fn.getcwd(),
       sourceMaps = true,
       protocol = "inspector",
       console = "integratedTerminal",
     },
     {
       name = "Attach",
       type = "node2",
       request = "attach",
       processId = require("dap.utils").pick_process,
     },
   }
   
   -- デバッグ用キーマップ
   vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
   vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
   vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step Over" })
   ```

## パフォーマンス監視・プロファイリング

### フロントエンド監視

1. **React DevTools Profiler活用**
   ```typescript
   // React.Profilerを使用したパフォーマンス測定
   import { Profiler } from 'react';
   
   const onRenderCallback = (
     id: string,
     phase: 'mount' | 'update',
     actualDuration: number,
     baseDuration: number,
     startTime: number,
     commitTime: number
   ) => {
     console.log(`${id} ${phase} phase:`, {
       actualDuration,
       baseDuration,
       startTime,
       commitTime,
     });
   };
   
   const App = () => (
     <Profiler id="App" onRender={onRenderCallback}>
       <Router>
         <Routes>
           {/* routes */}
         </Routes>
       </Router>
     </Profiler>
   );
   ```

2. **Web Vitals測定**
   ```typescript
   // pages/_app.tsx
   import { getCLS, getFID, getFCP, getLCP, getTTFB } from 'web-vitals';
   
   function sendToAnalytics(metric: any) {
     // アナリティクスサービスに送信
     console.log(metric);
   }
   
   getCLS(sendToAnalytics);
   getFID(sendToAnalytics);
   getFCP(sendToAnalytics);
   getLCP(sendToAnalytics);
   getTTFB(sendToAnalytics);
   ```

### バックエンド監視

1. **API レスポンス時間監視**
   ```typescript
   // パフォーマンス監視ミドルウェア
   export const performanceMonitor = (
     req: Request,
     res: Response,
     next: NextFunction
   ) => {
     const start = Date.now();
     
     res.on('finish', () => {
       const duration = Date.now() - start;
       console.log(`${req.method} ${req.path} - ${duration}ms`);
       
       // 遅いAPIの警告
       if (duration > 1000) {
         console.warn(`Slow API detected: ${req.path} took ${duration}ms`);
       }
     });
     
     next();
   };
   ```

2. **メモリ使用量監視**
   ```typescript
   // メモリ監視
   setInterval(() => {
     const memUsage = process.memoryUsage();
     const usage = {
       rss: Math.round(memUsage.rss / 1024 / 1024) + ' MB',
       heapTotal: Math.round(memUsage.heapTotal / 1024 / 1024) + ' MB',
       heapUsed: Math.round(memUsage.heapUsed / 1024 / 1024) + ' MB',
       external: Math.round(memUsage.external / 1024 / 1024) + ' MB',
     };
     
     console.log('Memory usage:', usage);
   }, 30000); // 30秒ごと
   ```

## プロダクション環境での考慮事項

### セキュリティ

1. **入力サニタイゼーション**
   ```typescript
   import DOMPurify from 'dompurify';
   import { JSDOM } from 'jsdom';
   
   const window = new JSDOM('').window;
   const purify = DOMPurify(window);
   
   export const sanitizeHtml = (dirty: string): string => {
     return purify.sanitize(dirty);
   };
   
   // XSS対策
   const UserComment = ({ comment }: { comment: string }) => {
     const cleanComment = sanitizeHtml(comment);
     return <div dangerouslySetInnerHTML={{ __html: cleanComment }} />;
   };
   ```

2. **CSRF対策**
   ```typescript
   import csrf from 'csurf';
   
   const csrfProtection = csrf({ cookie: true });
   
   app.use(csrfProtection);
   
   app.get('/form', (req, res) => {
     res.render('form', { csrfToken: req.csrfToken() });
   });
   ```

### エラー監視

1. **Sentry統合**
   ```typescript
   import * as Sentry from '@sentry/nextjs';
   
   Sentry.init({
     dsn: process.env.SENTRY_DSN,
     environment: process.env.NODE_ENV,
     tracesSampleRate: 1.0,
   });
   
   // エラーの手動レポート
   try {
     riskyOperation();
   } catch (error) {
     Sentry.captureException(error);
     throw error;
   }
   ```

## まとめ

TypeScript開発での成功のポイント：

1. **段階的な学習**: 基本から応用まで段階的にスキルアップ
2. **型安全性の活用**: TypeScriptの恩恵を最大限活用
3. **開発効率の追求**: ツール・ワークフローの最適化
4. **品質の確保**: テスト・監視・デバッグの徹底
5. **継続的改善**: パフォーマンス・セキュリティの継続的向上

これらの実践により、プロフェッショナルなTypeScript開発者として活躍できます。