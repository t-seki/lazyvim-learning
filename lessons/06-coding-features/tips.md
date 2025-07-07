# コーディング機能 - ヒントとトラブルシューティング

## LSPトラブルシューティング

### Q: LSPサーバーが起動しない

**A: 以下の手順で確認してください：**

1. **LSPサーバーのインストール確認**
   ```vim
   :Mason
   ```
   - 必要なLSPサーバーがインストールされているか確認
   - `i`でインストール、`u`でアップデート

2. **LSPログの確認**
   ```vim
   :LspLog
   ```
   - エラーメッセージを確認
   - パスや権限の問題がないか確認

3. **ファイルタイプの確認**
   ```vim
   :set filetype?
   ```
   - 正しいファイルタイプが設定されているか確認

### Q: 補完が効かない

**A: 補完システムの状態確認：**

```vim
:CmpStatus
```

**よくある原因：**
- LSPサーバーが起動していない
- ファイルに構文エラーがある
- 補完がバッファで無効化されている

**解決策：**
```lua
-- 手動で補完を有効化
:lua require('cmp').setup.buffer({ enabled = true })
```

### Q: フォーマッターが動作しない

**A: conform.nvimの設定確認：**

```vim
:ConformInfo
```

**チェックポイント：**
1. フォーマッターがインストールされているか
2. ファイルタイプに対応するフォーマッターが設定されているか
3. 保存時フォーマットが有効か

```vim
" フォーマットの有効/無効切り替え
:FormatEnable
:FormatDisable
```

## パフォーマンス最適化

### 大規模プロジェクトでのLSP

1. **不要なLSP機能の無効化**
   ```lua
   -- 特定の機能のみ有効化
   vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
     vim.lsp.handlers.hover, { 
       border = "rounded",
       max_width = 80,
     }
   )
   ```

2. **診断表示の最適化**
   ```lua
   vim.diagnostic.config({
     virtual_text = false,  -- 仮想テキストを無効化
     signs = true,
     underline = true,
     update_in_insert = false,  -- 挿入モードでは更新しない
   })
   ```

### 補完の高速化

1. **補完ソースの制限**
   ```lua
   -- 特定のソースのみ使用
   sources = {
     { name = 'nvim_lsp' },
     { name = 'luasnip' },
     -- { name = 'buffer' },  -- バッファ補完を無効化
   }
   ```

2. **補完のトリガー設定**
   ```lua
   -- 3文字以上で補完開始
   completion = {
     keyword_length = 3,
   }
   ```

## 効率的な使い方

### コードアクションの活用

**よく使うコードアクション：**
- **自動インポート**: 未定義の型や関数を自動でインポート
- **未使用コードの削除**: インポート、変数、関数
- **抽出リファクタリング**: 選択範囲を関数/変数に抽出
- **インライン化**: 変数や関数をインライン展開

### 診断情報の効率的な確認

```vim
" カスタムキーマップの例
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next)
```

### スニペットの効果的な使用

1. **コンテキスト依存スニペット**
   - クラス内では`init`で`__init__`メソッド
   - テストファイルでは`test`でテスト関数

2. **プレースホルダーの活用**
   - `<Tab>`で次のプレースホルダー
   - `<S-Tab>`で前のプレースホルダー
   - プレースホルダー内で入力すると全体が置換

## 言語別の設定

### TypeScript/JavaScript

**必須ツール：**
```bash
npm install -g typescript typescript-language-server
npm install -g eslint_d prettier
```

**便利な設定：**
```lua
-- package.jsonのあるディレクトリを自動認識
require("lspconfig").tsserver.setup({
  root_dir = require("lspconfig.util").root_pattern("package.json"),
})
```

### Python

**仮想環境の自動認識：**
```lua
-- pyrightの設定例
require("lspconfig").pyright.setup({
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})
```

**フォーマッター統合：**
```bash
pip install black isort ruff
```

### Go

**必須設定：**
```lua
-- goplsの最適化
require("lspconfig").gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
})
```

## 高度なカスタマイズ

### カスタムコードアクション

```lua
-- 独自のコードアクション追加
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.keymap.set("n", "<leader>ct", function()
      -- カスタムアクション（例：型ヒント追加）
      vim.lsp.buf.code_action({
        filter = function(action)
          return action.title:match("Add type hint")
        end,
        apply = true,
      })
    end, { desc = "Add type hints" })
  end,
})
```

### 補完の表示カスタマイズ

```lua
-- アイコンのカスタマイズ
local cmp = require('cmp')
cmp.setup({
  formatting = {
    format = function(entry, vim_item)
      -- カスタムアイコン設定
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      -- ソース表示
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end
  },
})
```

## ワークフロー改善のヒント

### 1. エラー駆動開発
1. コードを書く
2. リアルタイムでエラーを確認
3. `<leader>ca`で自動修正
4. 手動修正が必要な部分のみ編集

### 2. リファクタリングフロー
1. シンボルリネーム（`<leader>cr`）
2. 未使用コード削除（`<leader>ca`）
3. フォーマット（`<leader>cf`）
4. 型チェック確認

### 3. 効率的なデバッグ
1. エラー位置へジャンプ（`]e`）
2. 詳細確認（`<leader>cd`）
3. 定義ジャンプ（`gd`）で実装確認
4. 参照検索（`gr`）で使用箇所確認

## まとめ

LSPとLazyVimの統合により：
- **即座のフィードバック**: エラーをリアルタイムで確認
- **自動化**: 多くの作業をコードアクションで自動化
- **統一体験**: 言語を問わず一貫した開発体験
- **拡張性**: 必要に応じてカスタマイズ可能

これらの機能を日常的に使いこなすことで、コーディング効率が大幅に向上します。