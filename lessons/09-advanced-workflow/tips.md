# 高度なワークフロー - ヒントとトラブルシューティング

## マルチカーソル・一括編集のコツ

### Q: vim-visual-multiで選択がうまくいかない

**A: 段階的なアプローチを取る：**

1. **基本選択の確認**
   ```vim
   " 現在の単語選択
   <C-n>          " 最初の選択
   <C-n>          " 同じ単語の次の出現箇所を追加
   <C-x>          " 現在の選択を解除
   <C-p>          " 前の出現箇所に戻る
   ```

2. **選択範囲の調整**
   ```vim
   " 選択範囲の拡張・縮小
   <Tab>          " 選択範囲を拡張
   <S-Tab>        " 選択範囲を縮小
   ```

3. **モード切り替え**
   ```vim
   " Extended modeとCursor modeの切り替え
   <C-v>          " Extended modeに切り替え
   <Tab>          " モード切り替え（E/C表示を確認）
   ```

### Q: 正規表現での選択が期待通りにならない

**A: パターンの段階的構築：**

```vim
" 段階的にパターンを複雑にする
:VM/word/                    " 単純な単語
:VM/\bword\b/               " 単語境界付き
:VM/\b\w+@\w+\.\w+\b/       " メールアドレス
:VM/"[^"]*"/                " ダブルクォート内のテキスト
```

### パフォーマンス最適化

1. **大きなファイルでの注意点**
   ```lua
   -- vim-visual-multiの設定最適化
   vim.g.VM_default_mappings = 0  -- デフォルトマッピングを無効化
   vim.g.VM_mouse_mappings = 1    -- マウスマッピングを有効化
   vim.g.VM_silent_exit = 1       -- 静かに終了
   ```

2. **メモリ使用量の管理**
   ```vim
   " 大量選択時の制限
   let g:VM_max_matches = 1000
   ```

## スニペット管理のベストプラクティス

### スニペットが展開されない問題

**A: トラブルシューティング手順：**

1. **LuaSnipの状態確認**
   ```vim
   :lua print(require("luasnip").available())
   :lua print(vim.tbl_keys(require("luasnip").get_snippets()))
   ```

2. **ファイルタイプの確認**
   ```vim
   :set filetype?
   :lua print(vim.bo.filetype)
   ```

3. **スニペット読み込みの確認**
   ```lua
   -- デバッグ用の読み込み確認
   require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/snippets"})
   
   -- 読み込まれたスニペットの確認
   local ls = require("luasnip")
   print(vim.inspect(ls.get_snippets("javascript")))
   ```

### 複雑なスニペットのデバッグ

1. **段階的な構築**
   ```lua
   -- まず単純なスニペットでテスト
   s("test", t("Hello World"))
   
   -- 徐々に複雑化
   s("test2", {
     t("Hello "), i(1, "name"), t("!")
   })
   
   -- 関数を追加
   s("test3", {
     t("Hello "), i(1, "name"), t(" - "), 
     f(function() return os.date("%Y-%m-%d") end, {})
   })
   ```

2. **エラーハンドリング**
   ```lua
   -- 安全な関数スニペット
   s("safe", {
     f(function(args)
       local name = args[1][1]
       if name and name ~= "" then
         return "Hello " .. name
       else
         return "Hello World"
       end
     end, {1})
   })
   ```

### スニペットのパフォーマンス

```lua
-- 効率的なスニペット設計
local helpers = require("luasnip-helpers")

-- ヘルパー関数の活用
local function current_date()
  return os.date("%Y-%m-%d")
end

-- キャッシュを活用した動的スニペット
local function get_project_name()
  if not _G.project_name_cache then
    _G.project_name_cache = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end
  return _G.project_name_cache
end
```

## Git統合のトラブルシューティング

### LazyGitが起動しない

**A: 環境確認とセットアップ：**

1. **LazyGitのインストール確認**
   ```bash
   which lazygit
   lazygit --version
   ```

2. **パス設定の確認**
   ```lua
   -- LazyGitのパス指定
   vim.g.lazygit_floating_window_winblend = 0
   vim.g.lazygit_floating_window_scaling_factor = 0.9
   vim.g.lazygit_use_neovim_remote = 1
   ```

3. **Neovim内での起動テスト**
   ```vim
   :terminal lazygit
   ```

### Gitsignsの表示がおかしい

**A: 設定の確認・修正：**

1. **基本設定の確認**
   ```lua
   require('gitsigns').setup({
     signs = {
       add = { text = '+' },
       change = { text = '~' },
       delete = { text = '_' },
       topdelete = { text = '‾' },
       changedelete = { text = '~' },
     },
     on_attach = function(bufnr)
       print("Gitsigns attached to buffer " .. bufnr)
     end,
   })
   ```

2. **Git設定の確認**
   ```bash
   git config --list | grep user
   git status  # Git repoか確認
   ```

3. **手動更新**
   ```vim
   :Gitsigns refresh
   :Gitsigns toggle_signs
   ```

### コンフリクト解決のコツ

1. **3-way mergeの理解**
   ```
   <<<<<<< HEAD
   現在のブランチの内容
   =======
   マージしようとするブランチの内容
   >>>>>>> feature-branch
   ```

2. **効率的な解決キーマップ**
   ```lua
   -- コンフリクト解決用キーマップ
   vim.keymap.set("n", "<leader>co", "<cmd>Gitsigns diffthis HEAD<cr>", { desc = "Conflict: diff with HEAD" })
   vim.keymap.set("n", "<leader>ch", "<cmd>diffget //2<cr>", { desc = "Conflict: take HEAD" })
   vim.keymap.set("n", "<leader>ct", "<cmd>diffget //3<cr>", { desc = "Conflict: take theirs" })
   ```

## マクロ・自動化のトラブルシューティング

### マクロが期待通りに動かない

**A: デバッグ手順：**

1. **マクロ内容の確認**
   ```vim
   " レジスタの内容を確認
   :reg a
   " マクロを編集
   :let @a = 'new macro content'
   ```

2. **ステップバイステップの確認**
   ```vim
   " マクロを1ステップずつ実行
   qa          " 記録開始
   " 1つの操作を実行
   q           " 記録終了
   @a          " 実行
   " 期待通りかチェック、問題があれば修正
   ```

3. **環境に依存しないマクロ作成**
   ```vim
   " 相対移動ではなく絶対位置を使用
   qa
   0           " 行頭に移動（jやkではなく）
   f:          " 特定文字を検索
   " 操作
   q
   ```

### Lua自動化関数のデバッグ

1. **ログ出力の追加**
   ```lua
   local function debug_log(message)
     local log_file = vim.fn.stdpath("data") .. "/debug.log"
     local file = io.open(log_file, "a")
     if file then
       file:write(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message .. "\n")
       file:close()
     end
   end
   
   -- 関数内でデバッグ
   M.my_function = function()
     debug_log("Function started")
     -- 処理
     debug_log("Function completed")
   end
   ```

2. **エラーハンドリング**
   ```lua
   M.safe_function = function()
     local ok, result = pcall(function()
       -- リスクのある処理
       return some_risky_operation()
     end)
     
     if not ok then
       vim.notify("Error: " .. result, vim.log.levels.ERROR)
       return nil
     end
     
     return result
   end
   ```

## パフォーマンス最適化

### 大きなファイルでの問題

1. **ファイルサイズ制限の設定**
   ```lua
   -- 大きなファイル用の設定
   vim.api.nvim_create_autocmd("BufReadPre", {
     callback = function()
       local max_filesize = 1024 * 1024  -- 1MB
       local filename = vim.api.nvim_buf_get_name(0)
       local ok, stats = pcall(vim.loop.fs_stat, filename)
       
       if ok and stats and stats.size > max_filesize then
         -- 重い機能を無効化
         vim.b.large_buf = true
         vim.opt_local.syntax = "off"
         vim.opt_local.wrap = false
         vim.opt_local.foldmethod = "manual"
         
         -- プラグインを無効化
         vim.b.cmp_enabled = false
         vim.b.treesitter_highlight = false
       end
     end,
   })
   ```

2. **プラグインの条件付き読み込み**
   ```lua
   -- 条件付きプラグイン設定
   return {
     "expensive-plugin",
     cond = function()
       return not vim.b.large_buf
     end,
   }
   ```

### メモリ使用量の監視

```lua
-- メモリ使用量チェック関数
local function check_memory_usage()
  local memory_kb = vim.fn.system("ps -o rss= -p " .. vim.fn.getpid())
  memory_kb = tonumber(memory_kb:gsub("%s+", ""))
  local memory_mb = memory_kb / 1024
  
  if memory_mb > 500 then  -- 500MB以上の場合
    vim.notify("High memory usage: " .. string.format("%.1f MB", memory_mb), 
               vim.log.levels.WARN)
  end
end

-- 定期的なメモリチェック
vim.fn.timer_start(60000, check_memory_usage, { ["repeat"] = -1 })
```

## チーム開発での注意点

### 設定の競合回避

1. **チーム設定とローカル設定の分離**
   ```lua
   -- ~/.config/nvim/lua/config/team.lua
   -- チーム共通設定
   
   -- ~/.config/nvim/lua/config/local.lua  
   -- 個人設定（gitignoreに追加）
   
   -- init.luaで条件付き読み込み
   require("config.team")
   
   local ok, _ = pcall(require, "config.local")
   if not ok then
     -- ローカル設定がない場合のデフォルト
   end
   ```

2. **プラットフォーム固有設定**
   ```lua
   -- OS判定
   local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
   local is_mac = vim.loop.os_uname().sysname == "Darwin"
   local is_wsl = vim.fn.has("wsl") == 1
   
   -- プラットフォーム別設定
   if is_windows then
     vim.opt.shell = "powershell"
   elseif is_wsl then
     -- WSL固有の設定
   end
   ```

### バージョン管理のベストプラクティス

1. **設定のバージョン管理**
   ```gitignore
   # .gitignore
   lazy-lock.json
   .luarc.json
   local.lua
   debug.log
   ```

2. **設定の同期**
   ```bash
   # 設定同期スクリプト
   #!/bin/bash
   CONFIG_REPO="https://github.com/yourname/nvim-config.git"
   BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d)"
   
   # バックアップ
   cp -r ~/.config/nvim $BACKUP_DIR
   
   # 最新設定を取得
   cd ~/.config/nvim
   git pull origin main
   
   # プラグイン同期
   nvim --headless "+Lazy! sync" +qa
   ```

## デバッグ・ログ活用

### 総合的なデバッグ環境

```lua
-- ~/.config/nvim/lua/utils/debug.lua
local M = {}

M.setup_debug_env = function()
  -- デバッグ用キーマップ
  vim.keymap.set("n", "<leader>di", function()
    print("Debug info:")
    print("  Neovim version:", vim.version())
    print("  Current filetype:", vim.bo.filetype)
    print("  LSP clients:", vim.tbl_keys(vim.lsp.get_active_clients()))
    print("  Large buffer:", vim.b.large_buf or false)
  end, { desc = "Debug info" })
  
  -- ログ表示
  vim.keymap.set("n", "<leader>dl", function()
    vim.cmd("edit " .. vim.fn.stdpath("data") .. "/debug.log")
  end, { desc = "Show debug log" })
  
  -- 設定リロード
  vim.keymap.set("n", "<leader>dr", function()
    for name, _ in pairs(package.loaded) do
      if name:match("^config") or name:match("^plugins") then
        package.loaded[name] = nil
      end
    end
    dofile(vim.env.MYVIMRC)
    vim.notify("Configuration reloaded", vim.log.levels.INFO)
  end, { desc = "Reload config" })
end

return M
```

## まとめ

高度なワークフローを成功させるために：

1. **段階的な導入**: 一度にすべてを導入せず、段階的に機能を追加
2. **エラーハンドリング**: 自動化機能には必ずエラーハンドリングを組み込む
3. **パフォーマンス監視**: 大きなファイルや複雑な操作でのパフォーマンスを定期確認
4. **チーム調整**: 個人設定とチーム設定を明確に分離
5. **継続的改善**: 日常使用での問題点を定期的に見直し・改善

これらの注意点を守ることで、安定した高効率の開発環境を維持できます。