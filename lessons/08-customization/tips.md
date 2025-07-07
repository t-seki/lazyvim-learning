# LazyVimカスタマイズ - ヒントとトラブルシューティング

## 設定管理のベストプラクティス

### Q: 設定ファイルが多すぎて管理が大変

**A: 構造化された管理方法：**

1. **機能別ファイル分割**
   ```
   ~/.config/nvim/lua/
   ├── config/
   │   ├── options.lua      # Vim基本設定
   │   ├── keymaps.lua      # キーマップ設定
   │   └── autocmds.lua     # 自動コマンド
   ├── plugins/
   │   ├── ui.lua           # UI関連プラグイン
   │   ├── editor.lua       # エディタ機能
   │   ├── coding.lua       # コーディング支援
   │   ├── git.lua          # Git関連
   │   └── lang/            # 言語別設定
   │       ├── python.lua
   │       ├── typescript.lua
   │       └── go.lua
   └── utils/
       ├── helpers.lua      # ヘルパー関数
       └── constants.lua    # 定数定義
   ```

2. **共通設定の分離**
   ```lua
   -- ~/.config/nvim/lua/utils/helpers.lua
   local M = {}
   
   -- よく使う設定をヘルパー関数化
   M.setup_language = function(ft, config)
     vim.api.nvim_create_autocmd("FileType", {
       pattern = ft,
       callback = function()
         for key, value in pairs(config) do
           vim.opt_local[key] = value
         end
       end,
     })
   end
   
   return M
   ```

### Q: 設定の変更が反映されない

**A: 設定反映の確認手順：**

1. **ファイル再読み込み**
   ```vim
   :source ~/.config/nvim/init.lua
   " または現在のファイル
   :source %
   ```

2. **プラグイン設定の反映**
   ```vim
   :Lazy reload <plugin-name>
   " または全体
   :Lazy sync
   ```

3. **キャッシュクリア**
   ```bash
   rm -rf ~/.local/share/nvim
   rm -rf ~/.cache/nvim
   ```

## プラグイン管理のトラブルシューティング

### Q: プラグインがインストールできない

**A: 段階的な確認：**

1. **ネットワーク接続確認**
   ```bash
   curl -I https://github.com
   ```

2. **Git設定確認**
   ```bash
   git config --global user.name
   git config --global user.email
   ```

3. **プラグイン設定確認**
   ```lua
   -- 正しい設定例
   return {
     "author/plugin-name",
     dependencies = { "required-plugin" },
     config = function()
       require("plugin-name").setup()
     end,
   }
   ```

### Q: プラグインの競合が発生する

**A: 競合解決の方法：**

1. **段階的な有効化**
   ```lua
   -- 問題のあるプラグインを一時的に無効化
   return {
     "problematic-plugin",
     enabled = false,
   }
   ```

2. **ログ確認**
   ```vim
   :messages
   :Lazy log
   ```

3. **設定の優先順位確認**
   ```lua
   -- 優先順位を明示的に設定
   return {
     "high-priority-plugin",
     priority = 1000,
   }
   ```

## パフォーマンス最適化

### 起動時間の改善

1. **プロファイリング実行**
   ```bash
   nvim --startuptime startup.log +q && cat startup.log
   ```

2. **遅延読み込みの活用**
   ```lua
   return {
     -- イベント駆動の読み込み
     { "plugin1", event = "InsertEnter" },
     { "plugin2", event = "BufReadPost" },
     { "plugin3", event = "VeryLazy" },
     
     -- ファイルタイプ別読み込み
     { "python-plugin", ft = "python" },
     { "web-plugin", ft = { "html", "css", "javascript" } },
     
     -- コマンド実行時読み込み
     { "git-plugin", cmd = { "Git", "Gstatus" } },
   }
   ```

3. **不要プラグインの削除**
   ```lua
   -- ~/.config/nvim/lua/plugins/disabled.lua
   return {
     { "flash.nvim", enabled = false },
     { "mini.pairs", enabled = false },
   }
   ```

### メモリ使用量の最適化

```lua
-- 大きなファイル用の設定
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function()
    local max_filesize = 1024 * 1024 -- 1MB
    local filename = vim.api.nvim_buf_get_name(0)
    local ok, stats = pcall(vim.loop.fs_stat, filename)
    
    if ok and stats and stats.size > max_filesize then
      -- 重い機能を無効化
      vim.opt_local.syntax = "off"
      vim.opt_local.wrap = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.cursorline = false
      vim.opt_local.cursorcolumn = false
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.undolevels = -1
      
      vim.b.large_buf = true
    end
  end,
})
```

## キーマップ設定のコツ

### 効率的なキーマップ設計

1. **論理的なグループ分け**
   ```lua
   -- ファイル操作
   map("n", "<leader>f", group = "File")
   map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
   map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
   map("n", "<leader>fn", function() -- 新しいファイル作成関数 end, { desc = "New file" })
   
   -- Git操作
   map("n", "<leader>g", group = "Git")
   map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
   map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
   ```

2. **記憶しやすいニーモニック**
   ```lua
   -- 直感的なキーマップ
   map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write/Save" })
   map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
   map("n", "<leader>e", "<cmd>NeoTreeToggle<cr>", { desc = "Explorer" })
   map("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Terminal" })
   ```

### キーマップの競合回避

```lua
-- 既存キーマップの確認
vim.api.nvim_get_keymap('n')

-- 安全なキーマップ削除
pcall(vim.keymap.del, "n", "<leader>l")

-- 条件付きキーマップ
if not vim.g.vscode then
  map("n", "<leader>e", "<cmd>NeoTreeToggle<cr>", { desc = "Explorer" })
end
```

## 言語別設定の管理

### モジュラー設定

```lua
-- ~/.config/nvim/lua/config/languages.lua
local M = {}

M.setup_python = function()
  -- Python固有設定
  vim.opt_local.tabstop = 4
  vim.opt_local.shiftwidth = 4
  vim.opt_local.expandtab = true
  vim.opt_local.colorcolumn = "88"
  
  -- Python固有キーマップ
  local map = vim.keymap.set
  map("n", "<leader>pr", "<cmd>!python %<cr>", { buffer = true, desc = "Run Python" })
  map("n", "<leader>pt", "<cmd>!python -m pytest<cr>", { buffer = true, desc = "Run tests" })
end

M.setup_javascript = function()
  vim.opt_local.tabstop = 2
  vim.opt_local.shiftwidth = 2
  vim.opt_local.expandtab = true
  
  local map = vim.keymap.set
  map("n", "<leader>nr", "<cmd>!node %<cr>", { buffer = true, desc = "Run Node" })
  map("n", "<leader>nt", "<cmd>!npm test<cr>", { buffer = true, desc = "npm test" })
end

-- 言語設定の自動適用
local function setup_language_autocmds()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = M.setup_python,
  })
  
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    callback = M.setup_javascript,
  })
end

setup_language_autocmds()

return M
```

## 環境別設定の管理

### OS固有設定

```lua
-- ~/.config/nvim/lua/config/platform.lua
local M = {}

local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
local is_wsl = vim.fn.has("wsl") == 1
local is_mac = vim.loop.os_uname().sysname == "Darwin"

M.setup_clipboard = function()
  if is_wsl then
    vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      },
    }
  elseif is_mac then
    vim.opt.clipboard = "unnamedplus"
  end
end

M.setup_terminal = function()
  if is_windows then
    vim.opt.shell = "powershell"
    vim.opt.shellcmdflag = "-command"
  end
end

return M
```

### プロジェクト固有設定

```lua
-- 自動プロジェクト設定読み込み
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local project_configs = {
      ".nvim.lua",
      ".nvimrc.lua",
      "nvim.lua",
    }
    
    for _, config_file in ipairs(project_configs) do
      local config_path = vim.fn.getcwd() .. "/" .. config_file
      if vim.fn.filereadable(config_path) == 1 then
        dofile(config_path)
        print("Loaded project config: " .. config_file)
        break
      end
    end
  end,
})
```

## デバッグとログ

### 設定のデバッグ

```lua
-- デバッグ用ヘルパー関数
local M = {}

M.debug_keymaps = function()
  local buf = vim.api.nvim_create_buf(false, true)
  local keymaps = vim.api.nvim_get_keymap('n')
  local lines = {}
  
  for _, map in ipairs(keymaps) do
    table.insert(lines, string.format("%s -> %s", map.lhs, map.rhs or "[function]"))
  end
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_current_buf(buf)
end

M.debug_options = function()
  local options = {
    "tabstop", "shiftwidth", "expandtab", "number", "relativenumber",
    "wrap", "scrolloff", "ignorecase", "smartcase"
  }
  
  for _, opt in ipairs(options) do
    print(string.format("%s = %s", opt, vim.opt[opt]:get()))
  end
end

return M
```

### ログ記録

```lua
-- ~/.config/nvim/lua/utils/logger.lua
local M = {}

local log_file = vim.fn.stdpath("data") .. "/nvim.log"

M.log = function(level, message)
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local log_line = string.format("[%s] %s: %s\n", timestamp, level, message)
  
  local file = io.open(log_file, "a")
  if file then
    file:write(log_line)
    file:close()
  end
end

M.info = function(message) M.log("INFO", message) end
M.warn = function(message) M.log("WARN", message) end
M.error = function(message) M.log("ERROR", message) end

return M
```

## 設定のテストとバリデーション

### 設定の自動テスト

```lua
-- ~/.config/nvim/lua/tests/config_test.lua
local M = {}

M.test_keymaps = function()
  local required_maps = {
    { "n", "<leader>w", "Save file" },
    { "n", "<leader>q", "Quit" },
    { "n", "<leader>e", "Explorer" },
  }
  
  for _, map_def in ipairs(required_maps) do
    local mode, lhs, desc = unpack(map_def)
    local maps = vim.api.nvim_get_keymap(mode)
    local found = false
    
    for _, map in ipairs(maps) do
      if map.lhs == lhs then
        found = true
        break
      end
    end
    
    if not found then
      print("FAIL: Missing keymap " .. lhs .. " (" .. desc .. ")")
    else
      print("PASS: Found keymap " .. lhs)
    end
  end
end

M.test_plugins = function()
  local required_plugins = {
    "telescope.nvim",
    "neo-tree.nvim",
    "nvim-lspconfig",
  }
  
  for _, plugin in ipairs(required_plugins) do
    local ok = pcall(require, plugin)
    if ok then
      print("PASS: Plugin " .. plugin .. " loaded")
    else
      print("FAIL: Plugin " .. plugin .. " not found")
    end
  end
end

return M
```

## まとめ

効果的なLazyVimカスタマイズのために：

1. **段階的なカスタマイズ**: 一度に多くを変更せず、段階的に調整
2. **設定の文書化**: 変更理由をコメントで記録
3. **バックアップの習慣**: 重要な変更前は必ずバックアップ
4. **コミュニティの活用**: LazyVimコミュニティから学ぶ
5. **継続的な改善**: 使用パターンの変化に合わせて設定を見直し

個人の開発スタイルに合わせた最適な環境を構築することで、長期的な生産性向上を実現できます。