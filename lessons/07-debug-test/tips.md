# デバッグ・テスト統合 - ヒントとトラブルシューティング

## DAPトラブルシューティング

### Q: デバッガーが起動しない

**A: 以下の順序で確認してください：**

1. **DAPアダプターのインストール確認**
   ```vim
   :Mason
   ```
   必要なアダプターがインストールされているか確認：
   - TypeScript/JavaScript: `node-debug2`, `js-debug-adapter`
   - Python: `debugpy`
   - Go: `delve`

2. **LazyVimのDAP設定確認**
   ```vim
   :checkhealth dap
   ```

3. **設定ファイルの確認**
   ```vim
   :lua print(vim.inspect(require('dap').configurations))
   ```

### Q: ブレークポイントで停止しない

**A: よくある原因と解決策：**

1. **ソースマップの問題**
   ```json
   // tsconfig.json で sourceMap を有効化
   {
     "compilerOptions": {
       "sourceMap": true
     }
   }
   ```

2. **ファイルパスの不一致**
   ```vim
   " 現在のファイルパスを確認
   :echo expand('%:p')
   
   " DAP設定でパスマッピングを確認
   :lua print(vim.inspect(require('dap').configurations.typescript))
   ```

3. **条件付きブレークポイントの構文エラー**
   ```vim
   " 条件の構文を確認
   " 正しい: i === 5
   " 間違い: i = 5
   ```

### Q: 変数が表示されない

**A: 変数スコープとタイミングの確認：**

1. **スコープ内かどうか確認**
   - 変数が宣言されている関数内で停止しているか
   - ローカル変数 vs グローバル変数

2. **最適化による変数削除**
   ```json
   // tsconfig.json で最適化を無効化
   {
     "compilerOptions": {
       "target": "ES2015", // より低いターゲット
       "optimization": false
     }
   }
   ```

3. **仮想テキストの設定確認**
   ```vim
   " DAP virtual text が有効か確認
   :lua print(require('nvim-dap-virtual-text').setup())
   ```

## 効率的なデバッグワークフロー

### デバッグセッションの準備

1. **デバッグ前チェックリスト**
   - [ ] 最新のコードがビルドされている
   - [ ] テストが通る状態である
   - [ ] 再現手順が明確である
   - [ ] 期待値と実際の値が明確である

2. **効率的なブレークポイント配置**
   ```vim
   " 問題の境界を特定するための配置
   " 1. 関数の入口
   " 2. 条件分岐の前後
   " 3. ループの内部
   " 4. 関数の出口
   ```

### 変数確認のテクニック

1. **Watch式の活用**
   ```vim
   " よく確認する式をWatch に追加
   :lua require('dap').set_breakpoint(nil, nil, 'user.name + " - " + user.email')
   ```

2. **REPLでの対話的確認**
   ```vim
   <leader>dr  " REPL 表示
   
   " REPL内で実行可能
   > typeof variable
   > Object.keys(obj)
   > JSON.stringify(data, null, 2)
   ```

### ステップ実行の効率化

```vim
" カスタムキーマップ例
vim.keymap.set('n', '<F5>', require('dap').continue)
vim.keymap.set('n', '<F10>', require('dap').step_over)
vim.keymap.set('n', '<F11>', require('dap').step_into)
vim.keymap.set('n', '<F12>', require('dap').step_out)
```

## テストのトラブルシューティング

### Q: テストが見つからない

**A: ネオテストの設定確認：**

1. **アダプターの設定**
   ```lua
   require('neotest').setup({
     adapters = {
       require('neotest-jest')({
         jestCommand = 'npm test --',
         env = { CI = true },
       }),
     },
   })
   ```

2. **テストファイルパターンの確認**
   ```vim
   " テストファイルが認識されているか確認
   :lua print(vim.inspect(require('neotest').run.get_tree()))
   ```

### Q: テストデバッグができない

**A: Jest デバッグ設定：**

1. **package.json にデバッグスクリプト追加**
   ```json
   {
     "scripts": {
       "test:debug": "node --inspect-brk node_modules/.bin/jest --runInBand"
     }
   }
   ```

2. **DAP設定でJestデバッグ追加**
   ```lua
   require('dap').configurations.typescript = {
     {
       type = 'node2',
       request = 'attach',
       name = 'Attach to Jest',
       port = 9229,
       skipFiles = {'<node_internals>/**'},
     }
   }
   ```

### テスト実行の最適化

1. **選択的テスト実行**
   ```vim
   " 現在のテストのみ実行
   <leader>tr
   
   " ファイル内のテストのみ実行
   <leader>tR
   
   " 失敗したテストのみ再実行
   <leader>tf
   ```

2. **並列実行の調整**
   ```json
   // jest.config.js
   module.exports = {
     maxWorkers: 1, // デバッグ時は並列実行を無効化
   };
   ```

## パフォーマンスデバッグ

### メモリリークの調査

1. **Node.js プロファイラーの活用**
   ```bash
   # ヒーププロファイル生成
   node --inspect --heap-prof src/index.js
   
   # Chrome DevTools で確認
   chrome://inspect
   ```

2. **メモリ使用量の監視**
   ```typescript
   function monitorMemory() {
     const usage = process.memoryUsage();
     console.log({
       rss: Math.round(usage.rss / 1024 / 1024) + 'MB',
       heapTotal: Math.round(usage.heapTotal / 1024 / 1024) + 'MB',
       heapUsed: Math.round(usage.heapUsed / 1024 / 1024) + 'MB',
     });
   }
   
   // 定期的に実行
   setInterval(monitorMemory, 5000);
   ```

### CPU プロファイリング

1. **実行時間の測定**
   ```typescript
   function profileFunction<T>(fn: () => T, name: string): T {
     const start = process.hrtime.bigint();
     const result = fn();
     const end = process.hrtime.bigint();
     const duration = Number(end - start) / 1000000; // ms
     console.log(`${name}: ${duration.toFixed(2)}ms`);
     return result;
   }
   ```

2. **ボトルネックの特定**
   ```bash
   # CPUプロファイル生成
   node --prof src/index.js
   
   # プロファイル解析
   node --prof-process isolate-*.log > profile.txt
   ```

## 非同期デバッグのコツ

### Promise チェーンのデバッグ

1. **async/await vs Promise.then**
   ```typescript
   // デバッグしやすい async/await
   async function processData() {
     const data = await fetchData(); // ブレークポイント設定可能
     const processed = await transformData(data); // ここも
     return processed;
   }
   
   // デバッグしにくい Promise チェーン
   function processData() {
     return fetchData()
       .then(transformData); // 中間状態の確認が困難
   }
   ```

2. **エラーハンドリングの追加**
   ```typescript
   async function safeAsyncOperation() {
     try {
       const result = await riskyOperation();
       return result;
     } catch (error) {
       // ここにブレークポイントを設定してエラー調査
       console.error('Operation failed:', error);
       throw error;
     }
   }
   ```

### 競合状態（Race Condition）の調査

1. **タイミング依存の問題**
   ```typescript
   // 問題のあるコード
   let counter = 0;
   async function incrementAsync() {
     const current = counter; // 読み込み
     await delay(10); // 他の処理が割り込む可能性
     counter = current + 1; // 書き込み
   }
   
   // 修正版
   const mutex = new Mutex();
   async function incrementAsyncSafe() {
     await mutex.acquire();
     try {
       counter++;
     } finally {
       mutex.release();
     }
   }
   ```

2. **ログによる実行順序の追跡**
   ```typescript
   function logWithTimestamp(message: string) {
     const timestamp = new Date().toISOString();
     console.log(`[${timestamp}] ${message}`);
   }
   ```

## CI/CD でのテスト・デバッグ

### GitHub Actions 設定例

```yaml
# .github/workflows/test.yml
name: Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - run: npm ci
      - run: npm test
      - run: npm run test:coverage
      
      # カバレッジレポートをアップロード
      - uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
```

### デバッグ情報の収集

```typescript
// テスト失敗時の詳細情報収集
afterEach(() => {
  if (this.currentTest?.state === 'failed') {
    console.log('=== Debug Information ===');
    console.log('Test:', this.currentTest.title);
    console.log('Error:', this.currentTest.err?.message);
    console.log('Stack:', this.currentTest.err?.stack);
    
    // アプリケーション状態の出力
    if (global.app) {
      console.log('App State:', global.app.getState());
    }
  }
});
```

## 高度なデバッグテクニック

### カスタムデバッグ設定

```lua
-- ~/.config/nvim/lua/config/dap.lua
local dap = require('dap')

-- カスタム設定の追加
dap.configurations.typescript = vim.list_extend(
  dap.configurations.typescript or {},
  {
    {
      type = 'node2',
      request = 'launch',
      name = 'Launch with custom env',
      program = '${file}',
      env = {
        NODE_ENV = 'development',
        DEBUG = 'app:*',
      },
    }
  }
)
```

### 条件付きロギング

```typescript
// デバッグビルドでのみ実行されるログ
function debugLog(message: string, data?: any) {
  if (process.env.NODE_ENV === 'development') {
    console.log(`[DEBUG] ${message}`, data || '');
  }
}

// 特定条件でのみログ出力
function conditionalLog(condition: boolean, message: string) {
  if (condition && process.env.DEBUG_VERBOSE) {
    console.log(message);
  }
}
```

## まとめ

効率的なデバッグとテストのために：

1. **環境準備**: 適切なツールチェーンの構築
2. **体系的アプローチ**: 症状 → 仮説 → 検証のサイクル
3. **ツール活用**: DAP、neotest、プロファイラーの使い分け
4. **継続的改善**: CI/CDでの自動化とフィードバック

これらの技術を身につけることで、バグの早期発見と迅速な修正が可能になり、ソフトウェアの品質と開発効率が大幅に向上します。