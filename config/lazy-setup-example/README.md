# Lazy.nvim 推奨設定例

このディレクトリには、Neovim学習アプリケーションで使用する推奨のLazy.nvim設定が含まれています。

## 📋 含まれるプラグイン

### 必須プラグイン
- **lazy.nvim**: プラグインマネージャー本体
- **nvim-lspconfig**: LSP設定
- **nvim-cmp**: 補完エンジン
- **nvim-treesitter**: シンタックスハイライト・パーサー

### 推奨プラグイン
- **telescope.nvim**: ファジーファインダー
- **neo-tree.nvim**: ファイルエクスプローラー
- **which-key.nvim**: キーマッピングヘルプ
- **gitsigns.nvim**: Git統合

### 追加プラグイン
- **catppuccin**: カラーテーマ
- **lualine.nvim**: ステータスライン
- **nvim-autopairs**: 括弧の自動補完
- **comment.nvim**: コメント操作

## 🚀 セットアップ方法

### 1. バックアップ作成（重要）

既存の設定をバックアップ：

```bash
# 既存設定のバックアップ
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup
```

### 2. 設定ファイルのコピー

```bash
# 新しい設定ディレクトリを作成
mkdir -p ~/.config/nvim

# このディレクトリの設定ファイルをコピー
cp -r config/lazy-setup-example/* ~/.config/nvim/
```

### 3. Neovimを起動

初回起動時に自動的にプラグインがインストールされます：

```bash
nvim
```

## 📁 ファイル構成

```
~/.config/nvim/
├── init.lua                 # メイン設定ファイル
├── lua/
│   ├── config/
│   │   ├── options.lua      # Neovim基本設定
│   │   ├── keymaps.lua      # キーマッピング
│   │   └── autocmds.lua     # 自動コマンド
│   ├── plugins/
│   │   ├── init.lua         # プラグイン設定の読み込み
│   │   ├── lsp.lua          # LSP設定
│   │   ├── completion.lua   # 補完設定
│   │   ├── treesitter.lua   # Treesitter設定
│   │   ├── telescope.lua    # Telescope設定
│   │   ├── neotree.lua      # Neo-tree設定
│   │   ├── ui.lua           # UI関連プラグイン
│   │   └── git.lua          # Git関連プラグイン
│   └── utils/
│       └── helpers.lua      # ヘルパー関数
└── README.md               # このファイル
```

## ⚙️ 主な設定内容

### 基本設定（options.lua）
- 行番号表示
- インデント設定
- 検索設定
- バックアップ・スワップファイル設定

### キーマッピング（keymaps.lua）
- Leader キーは `<Space>`
- よく使う操作の効率的なマッピング
- プラグイン固有のキーマッピング

### LSP設定（plugins/lsp.lua）
- TypeScript/JavaScript
- Python
- Go
- Rust
- その他の一般的な言語

## 🎨 カスタマイズ

### テーマの変更

`lua/plugins/ui.lua`で他のテーマに変更可能：

```lua
-- Catppuccin (デフォルト)
{ \"catppuccin/nvim\", name = \"catppuccin\" }

-- 他のテーマ例
-- { \"folke/tokyonight.nvim\" }
-- { \"ellisonleao/gruvbox.nvim\" }
-- { \"rebelot/kanagawa.nvim\" }
```

### プラグインの追加

`lua/plugins/`ディレクトリに新しいファイルを作成：

```lua
-- lua/plugins/my-plugin.lua
return {
  \"author/plugin-name\",
  config = function()
    -- プラグインの設定
  end
}
```

### キーマッピングの変更

`lua/config/keymaps.lua`を編集：

```lua
-- カスタムキーマッピングの例
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
```

## 🔧 トラブルシューティング

### プラグインが正しくインストールされない

```vim
:Lazy update
:Lazy sync
```

### LSPが動作しない

言語サーバーのインストール確認：

```vim
:LspInfo
:Mason  # 言語サーバーの管理
```

### Telescopeが動作しない

依存関係の確認：

```bash
# ripgrep のインストール（必須）
# macOS
brew install ripgrep

# Ubuntu/Debian
sudo apt install ripgrep

# Windows (chocolatey)
choco install ripgrep
```

### 設定の読み込みエラー

設定ファイルの構文チェック：

```vim
:luafile %  # 現在のLuaファイルを実行
:checkhealth  # システム全体の健康状態チェック
```

## 📚 学習の進め方

1. **まずは基本操作**: レッスン01-04で基本的なVim操作を習得
2. **プラグインの活用**: Telescope、Neo-treeなどの使い方を覚える
3. **LSPの活用**: コード補完、エラー検出、定義ジャンプを使いこなす
4. **カスタマイズ**: 自分の作業スタイルに合わせて設定を調整

## 📖 参考リンク

- [Lazy.nvim公式ドキュメント](https://github.com/folke/lazy.nvim)
- [Neovim公式ドキュメント](https://neovim.io/doc/)
- [Lua学習リソース](https://www.lua.org/manual/5.1/)

---

この設定は学習を目的として最適化されており、実際のプロジェクト開発でもそのまま使用できます。