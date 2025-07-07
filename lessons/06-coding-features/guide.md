# コーディング機能深掘り - 詳細ガイド

## 1. LSPの高度な活用

### LSPとは？
Language Server Protocol（LSP）は、エディタと言語サーバー間の通信プロトコルです。LazyVimでは**nvim-lspconfig**により、各言語のLSPサーバーが事前設定されています。

### LSPサーバーの管理

#### インストール済みLSPの確認
```vim
:LspInfo
```
現在のバッファで有効なLSPサーバーの状態を表示

#### Masonによる管理
```vim
:Mason
```
LazyVimは**Mason**を使用してLSPサーバーを管理：
- `i`: インストール
- `u`: アップデート
- `X`: アンインストール

### コードアクション（Code Actions）

#### 基本的な使い方
```vim
<leader>ca  " カーソル位置のコードアクション表示
```

#### よく使うコードアクション

**TypeScript/JavaScript**:
```typescript
// カーソルを未使用インポートに置いて
import { unused } from "./module";  // <leader>ca → "Remove unused imports"

// アロー関数を通常関数に変換
const fn = () => {};  // <leader>ca → "Convert arrow function to function expression"

// async/await変換
promise.then(result => {});  // <leader>ca → "Convert to async function"
```

**Python**:
```python
# 未使用インポートの削除
import os  # <leader>ca → "Remove unused import"

# 型アノテーション追加
def process(data):  # <leader>ca → "Add type annotations"
    pass
```

### リファクタリング機能

#### リネーム（Rename）
```vim
<leader>cr  " または gr
```
プロジェクト全体での変数名・関数名の変更

#### 実装例
```typescript
// 変数名の変更
const oldName = "value";  // カーソルを置いて<leader>cr
// → newNameを入力すると、全参照箇所が変更される
```

### ワークスペースシンボル検索

```vim
<leader>ss  " ワークスペース内のシンボル検索
<leader>sS  " 現在のドキュメント内のシンボル検索
```

#### 検索例
- クラス名: `@User`
- 関数名: `#processData`
- 変数名: `config`

### 高度なナビゲーション

#### 型階層（Type Hierarchy）
```vim
<leader>cht  " 型階層を表示（サポートされている言語で）
```

#### 呼び出し階層（Call Hierarchy）
```vim
<leader>chi  " incoming calls（この関数を呼んでいる場所）
<leader>cho  " outgoing calls（この関数が呼んでいる関数）
```

## 2. 補完システムの完全理解

### nvim-cmpの仕組み

LazyVimの補完は**nvim-cmp**によって提供されます。複数の補完ソースから候補を収集し、統合して表示します。

### 補完の操作

```vim
<C-Space>    " 補完を手動でトリガー
<Tab>        " 次の候補選択
<S-Tab>      " 前の候補選択
<C-e>        " 補完をキャンセル
<CR>         " 選択した候補を確定
<C-y>        " 現在の候補を確定（選択なしでも）
```

### 補完ソースの理解

#### 主要な補完ソース
1. **LSP** (`nvim_lsp`): 言語サーバーからの補完
2. **Buffer** (`buffer`): 開いているバッファ内の単語
3. **Path** (`path`): ファイルパス補完
4. **Luasnip** (`luasnip`): スニペット補完

#### 補完アイコンの意味
```
 Text          (テキスト)
 Method        (メソッド)
 Function      (関数)
 Constructor   (コンストラクタ)
 Field         (フィールド)
 Variable      (変数)
 Class         (クラス)
 Interface     (インターフェース)
 Module        (モジュール)
 Property      (プロパティ)
 Unit          (単位)
 Value         (値)
 Enum          (列挙型)
 Keyword       (キーワード)
 Snippet       (スニペット)
 Color         (色)
 File          (ファイル)
 Reference     (参照)
 Folder        (フォルダ)
 EnumMember    (列挙型メンバー)
 Constant      (定数)
 Struct        (構造体)
 Event         (イベント)
 Operator      (演算子)
 TypeParameter (型パラメータ)
```

### スニペットの活用

#### 基本的なスニペット
```lua
-- LuaSnipスニペットの例
fun<Tab>  → function name(params)
            body
          end

if<Tab>   → if condition then
            body
          end
```

#### スニペット内のナビゲーション
```vim
<Tab>    " 次のプレースホルダーへジャンプ
<S-Tab>  " 前のプレースホルダーへジャンプ
```

### カスタム補完設定

#### 特定ファイルタイプでの補完無効化
```lua
-- ~/.config/nvim/lua/config/autocmds.lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    require("cmp").setup.buffer({ enabled = false })
  end,
})
```

## 3. フォーマッティング・リンティング

### conform.nvimによる自動フォーマッティング

LazyVimは**conform.nvim**を使用してフォーマッティングを管理します。

#### フォーマット実行
```vim
<leader>cf  " 現在のバッファをフォーマット
```

#### 保存時自動フォーマット
LazyVimではデフォルトで有効。無効化する場合：
```vim
:FormatDisable  " 現在のバッファで無効化
:FormatEnable   " 再度有効化
```

### 言語別フォーマッター設定

#### TypeScript/JavaScript
- **prettier**: 一般的なコードスタイル
- **eslint_d**: ESLint経由のフォーマット

#### Python
- **black**: PEP 8準拠の自動フォーマット
- **isort**: インポート文の整理
- **ruff**: 高速な総合ツール

#### Go
- **gofmt**: Go標準フォーマッター
- **goimports**: インポート自動追加

### 診断情報の操作

#### 診断表示
```vim
<leader>cd  " 行の診断情報を表示
]d          " 次の診断へジャンプ
[d          " 前の診断へジャンプ
<leader>xd  " Troubleで診断一覧表示
```

#### 診断レベル
- 🔴 **Error**: 修正が必要なエラー
- 🟡 **Warning**: 潜在的な問題
- 🔵 **Info**: 情報提供
- ⚪ **Hint**: 提案

### エラー修正ワークフロー

1. **診断確認**
   ```vim
   <leader>xd  " 全診断を一覧表示
   ```

2. **エラーへジャンプ**
   ```vim
   ]e  " 次のエラーへ
   [e  " 前のエラーへ
   ```

3. **クイックフィックス**
   ```vim
   <leader>ca  " コードアクションで自動修正
   ```

## 4. 言語別最適化

### TypeScript/JavaScript設定

#### 必須LSPサーバー
- `typescript-language-server`
- `eslint-language-server`

#### 便利な設定
```lua
-- TypeScript固有のキーマップ
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact" },
  callback = function()
    vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", { desc = "Organize Imports" })
    vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File" })
  end,
})
```

### Python設定

#### 推奨LSPサーバー
- `pyright` または `pylsp`
- `ruff-lsp`

#### 仮想環境の自動認識
LazyVimは自動的にvenv/virtualenvを検出します。

### Go設定

#### 必須ツール
- `gopls`: Go言語サーバー
- `gofumpt`: より厳密なフォーマッター

#### 便利な機能
```vim
<leader>cgf  " go.modの依存関係更新
<leader>cgt  " テスト生成
```

### Rust設定

#### 必須ツール
- `rust-analyzer`: Rust言語サーバー

#### Cargo統合
```vim
<leader>crc  " cargo check
<leader>crr  " cargo run
```

## 実践的なワークフロー

### 効率的なコーディングフロー

1. **ファイルを開く**
   ```vim
   <leader>ff  " ファイル検索
   ```

2. **LSP起動確認**
   ```vim
   :LspInfo  " サーバー状態確認
   ```

3. **コーディング開始**
   - 補完を活用: `<C-Space>`
   - 定義参照: `gd`, `gr`
   - ドキュメント表示: `K`

4. **エラー修正**
   - 診断確認: `<leader>cd`
   - 自動修正: `<leader>ca`

5. **フォーマット**
   - 手動: `<leader>cf`
   - 保存時自動

6. **リファクタリング**
   - リネーム: `<leader>cr`
   - 抽出: コードアクション

### トラブルシューティング

#### LSPが起動しない
1. `:LspInfo`で状態確認
2. `:LspLog`でログ確認
3. `:Mason`で再インストール

#### 補完が効かない
1. `:CmpStatus`で状態確認
2. LSPサーバーの起動確認
3. ファイルタイプの確認

#### フォーマットされない
1. `:ConformInfo`で設定確認
2. フォーマッターのインストール確認
3. `:FormatEnable`で有効化

## まとめ

LazyVimのコーディング機能をマスターすることで：
- IDEレベルの開発体験をVim内で実現
- 言語別に最適化された開発環境
- 効率的なエラー修正とリファクタリング
- 一貫性のあるコードスタイル維持

これらの機能を日常的に使いこなすことで、開発生産性が飛躍的に向上します。