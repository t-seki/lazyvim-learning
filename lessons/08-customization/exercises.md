# LazyVimカスタマイズ - エクササイズ

## 準備

### 設定のバックアップ
```bash
# 現在の設定をバックアップ
cp -r ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d)
```

### 練習用設定の準備
```bash
# 練習用の基本設定をコピー
cd lessons/08-customization/examples/basic-customization
```

## エクササイズ1: 基本設定のカスタマイズ

### options.lua の変更

1. **個人的な表示設定**
   - [ ] `~/.config/nvim/lua/config/options.lua`を開く
   - [ ] 行番号表示を相対行番号に変更：`opt.relativenumber = true`
   - [ ] タブ幅を2に変更：`opt.tabstop = 2`, `opt.shiftwidth = 2`
   - [ ] 設定を保存して`:source %`で反映確認

2. **スクロール設定の調整**
   - [ ] `scrolloff`を15に変更
   - [ ] `sidescrolloff`を15に変更
   - [ ] 変更後の表示を確認

3. **検索設定のカスタマイズ**
   - [ ] インクリメンタル検索を有効化：`opt.incsearch = true`
   - [ ] 検索ハイライトを無効化：`opt.hlsearch = false`

### 設定の確認方法
```vim
" 現在の設定値を確認
:set tabstop?
:set scrolloff?
:set relativenumber?
```

## エクササイズ2: キーマップの追加・変更

### 基本的なキーマップ追加

1. **カスタム保存キーマップ**
   ```lua
   -- keymaps.lua に追加
   map("n", "<leader>s", "<cmd>w<cr>", { desc = "Quick save" })
   map("n", "<leader>S", "<cmd>wa<cr>", { desc = "Save all" })
   ```

2. **ウィンドウ操作の改善**
   ```lua
   -- ウィンドウ分割
   map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Vertical split" })
   map("n", "<leader>h", "<cmd>split<cr>", { desc = "Horizontal split" })
   
   -- ウィンドウを閉じる
   map("n", "<leader>x", "<cmd>close<cr>", { desc = "Close window" })
   ```

3. **独自の編集機能**
   ```lua
   -- 行末のセミコロン追加
   map("n", "<leader>;", "A;<ESC>", { desc = "Add semicolon to end" })
   
   -- 現在行をコメントアウト
   map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
   ```

### キーマップのテスト
- [ ] 各キーマップが正常に動作することを確認
- [ ] `<leader>` + キーでwhich-keyにヒントが表示されることを確認

## エクササイズ3: プラグインの追加

### 新しいプラグインの追加

1. **ファイルエクスプローラーの追加**
   ```lua
   -- ~/.config/nvim/lua/plugins/file-manager.lua
   return {
     {
       "stevearc/oil.nvim",
       opts = {},
       dependencies = { "nvim-tree/nvim-web-devicons" },
       config = function()
         require("oil").setup()
         vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
       end,
     },
   }
   ```

2. **カラースキームの追加**
   ```lua
   -- ~/.config/nvim/lua/plugins/colorscheme.lua
   return {
     {
       "rose-pine/neovim",
       name = "rose-pine",
       opts = {
         variant = "moon",
         dark_variant = "moon",
         disable_background = false,
       },
     },
     
     -- LazyVimのカラースキーム変更
     {
       "LazyVim/LazyVim",
       opts = {
         colorscheme = "rose-pine",
       },
     },
   }
   ```

3. **Git統合の強化**
   ```lua
   -- ~/.config/nvim/lua/plugins/git.lua
   return {
     {
       "kdheepak/lazygit.nvim",
       dependencies = {
         "nvim-telescope/telescope.nvim",
         "nvim-lua/plenary.nvim",
       },
       config = function()
         vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
       end,
     },
   }
   ```

### プラグインの動作確認
- [ ] `:Lazy`でプラグインがインストールされていることを確認
- [ ] 各プラグインが正常に動作することをテスト

## エクササイズ4: 既存プラグインの設定変更

### Telescopeの設定カスタマイズ

1. **表示レイアウトの変更**
   ```lua
   -- ~/.config/nvim/lua/plugins/telescope.lua
   return {
     "nvim-telescope/telescope.nvim",
     opts = {
       defaults = {
         layout_strategy = "vertical",
         layout_config = {
           vertical = {
             preview_height = 0.6,
           },
         },
         sorting_strategy = "ascending",
         prompt_prefix = "🔍 ",
         selection_caret = "➤ ",
       },
     },
   }
   ```

2. **検索対象のカスタマイズ**
   ```lua
   -- ファイル無視パターンの追加
   defaults = {
     file_ignore_patterns = {
       "node_modules/",
       ".git/",
       "dist/",
       "build/",
       "*.log",
     },
   },
   ```

### Neo-treeの設定変更

```lua
-- ~/.config/nvim/lua/plugins/neo-tree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      position = "right",
      width = 35,
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}
```

## エクササイズ5: 言語固有の設定

### ファイルタイプ別設定

1. **Python専用設定**
   ```lua
   -- ~/.config/nvim/lua/config/autocmds.lua に追加
   vim.api.nvim_create_autocmd("FileType", {
     pattern = "python",
     callback = function()
       -- Python固有の設定
       vim.opt_local.colorcolumn = "88"
       vim.opt_local.textwidth = 88
       
       -- Python固有のキーマップ
       vim.keymap.set("n", "<leader>pr", "<cmd>!python %<cr>", 
         { buffer = true, desc = "Run Python file" })
     end,
   })
   ```

2. **Markdown専用設定**
   ```lua
   vim.api.nvim_create_autocmd("FileType", {
     pattern = "markdown",
     callback = function()
       vim.opt_local.wrap = true
       vim.opt_local.linebreak = true
       vim.opt_local.spell = true
       vim.opt_local.spelllang = "en,cjk"
     end,
   })
   ```

3. **Go専用設定**
   ```lua
   vim.api.nvim_create_autocmd("FileType", {
     pattern = "go",
     callback = function()
       vim.opt_local.expandtab = false
       vim.opt_local.tabstop = 4
       vim.opt_local.shiftwidth = 4
       
       vim.keymap.set("n", "<leader>gr", "<cmd>!go run %<cr>", 
         { buffer = true, desc = "Run Go file" })
       vim.keymap.set("n", "<leader>gt", "<cmd>!go test<cr>", 
         { buffer = true, desc = "Run Go tests" })
     end,
   })
   ```

## エクササイズ6: プロジェクト固有設定

### .nvim.lua ファイルの作成

1. **TypeScriptプロジェクト用設定**
   ```lua
   -- プロジェクトルートに .nvim.lua を作成
   
   -- このプロジェクト専用の設定
   vim.opt_local.tabstop = 2
   vim.opt_local.shiftwidth = 2
   
   -- プロジェクト固有のキーマップ
   vim.keymap.set("n", "<leader>ns", "<cmd>!npm start<cr>", { desc = "npm start" })
   vim.keymap.set("n", "<leader>nt", "<cmd>!npm test<cr>", { desc = "npm test" })
   vim.keymap.set("n", "<leader>nb", "<cmd>!npm run build<cr>", { desc = "npm build" })
   
   -- ESLintの設定
   vim.keymap.set("n", "<leader>nf", "<cmd>!npm run format<cr>", { desc = "Format code" })
   ```

2. **Pythonプロジェクト用設定**
   ```lua
   -- Pythonプロジェクト用 .nvim.lua
   
   -- 仮想環境の設定
   local venv_path = vim.fn.getcwd() .. "/venv"
   if vim.fn.isdirectory(venv_path) == 1 then
     vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
   end
   
   -- プロジェクト固有コマンド
   vim.keymap.set("n", "<leader>pp", "<cmd>!python -m pytest<cr>", { desc = "Run pytest" })
   vim.keymap.set("n", "<leader>pf", "<cmd>!black .<cr>", { desc = "Format with black" })
   ```

## エクササイズ7: 自動コマンドの活用

### 効率化のための自動コマンド

1. **ファイル保存時の自動処理**
   ```lua
   -- 末尾空白の自動削除
   vim.api.nvim_create_autocmd("BufWritePre", {
     pattern = "*",
     callback = function()
       local save_cursor = vim.fn.getpos(".")
       vim.cmd([[%s/\s\+$//e]])
       vim.fn.setpos(".", save_cursor)
     end,
   })
   ```

2. **最後のカーソル位置復元**
   ```lua
   vim.api.nvim_create_autocmd("BufReadPost", {
     callback = function()
       local mark = vim.api.nvim_buf_get_mark(0, '"')
       local lcount = vim.api.nvim_buf_line_count(0)
       if mark[1] > 0 and mark[1] <= lcount then
         pcall(vim.api.nvim_win_set_cursor, 0, mark)
       end
     end,
   })
   ```

3. **ファイル種別の自動認識**
   ```lua
   vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
     pattern = { "*.tf", "*.tfvars" },
     callback = function()
       vim.bo.filetype = "terraform"
     end,
   })
   ```

## エクササイズ8: 設定の管理とバックアップ

### Git管理の設定

1. **設定ディレクトリのGit初期化**
   ```bash
   cd ~/.config/nvim
   git init
   echo "lazy-lock.json" > .gitignore
   git add .
   git commit -m "Initial Neovim configuration"
   ```

2. **リモートリポジトリとの連携**
   ```bash
   git remote add origin <your-dotfiles-repo>
   git push -u origin main
   ```

### 設定の分岐管理

1. **実験用ブランチの作成**
   ```bash
   git checkout -b experimental-config
   # 実験的な設定を追加
   git add .
   git commit -m "Add experimental features"
   ```

2. **設定の復元**
   ```bash
   # 元の設定に戻る
   git checkout main
   ```

## エクササイズ9: パフォーマンス最適化

### 起動時間の測定と改善

1. **起動時間の測定**
   ```bash
   nvim --startuptime startup.log +q
   cat startup.log | tail -1
   ```

2. **プラグインの遅延読み込み**
   ```lua
   return {
     "expensive-plugin",
     event = "VeryLazy",  -- 起動後に読み込み
     -- または
     ft = "python",       -- 特定ファイルタイプでのみ読み込み
     -- または
     cmd = "PluginCommand", -- コマンド実行時に読み込み
   }
   ```

3. **不要プラグインの無効化**
   ```lua
   -- ~/.config/nvim/lua/plugins/disabled.lua
   return {
     { "unused-plugin", enabled = false },
   }
   ```

## チャレンジ課題

### 上級1: カスタムプラグインの作成
- [ ] 簡単な機能を持つ独自プラグインを作成
- [ ] local pluginとして~/.config/nvim/lua/に配置

### 上級2: 複数環境での設定共有
- [ ] 職場用・個人用設定の切り替え機能
- [ ] 環境変数による条件分岐設定

### 上級3: チーム設定との統合
- [ ] プロジェクトのEditorConfigとの連携
- [ ] チーム共通設定の自動同期

## 確認ポイント

練習後、以下を確認してください：

1. **設定理解**
   - [ ] LazyVimの設定構造を理解している
   - [ ] プラグインの追加・削除・設定変更ができる
   - [ ] キーマップの追加・変更ができる

2. **カスタマイズ実践**
   - [ ] 個人の使用パターンに合わせた設定ができる
   - [ ] プロジェクト固有設定が使える
   - [ ] 効率的な自動化を設定できる

3. **管理・保守**
   - [ ] 設定をGitで管理できる
   - [ ] バックアップ・復元ができる
   - [ ] パフォーマンス問題を特定・改善できる