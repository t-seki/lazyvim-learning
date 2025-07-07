# LazyVimカスタマイズ - 詳細ガイド

## 1. LazyVim設定アーキテクチャの理解

### 設定ファイルの階層構造

LazyVimの設定は以下の構造で管理されています：

```
~/.config/nvim/
├── init.lua                 # エントリーポイント
├── lazy-lock.json           # プラグインバージョン固定
├── lua/
│   ├── config/              # 基本設定
│   │   ├── autocmds.lua     # 自動コマンド
│   │   ├── keymaps.lua      # キーマップ
│   │   ├── lazy.lua         # Lazy.nvim設定
│   │   └── options.lua      # Vim設定
│   └── plugins/             # プラグイン設定
│       ├── ui.lua           # UI関連プラグイン
│       ├── editor.lua       # エディタ機能
│       ├── coding.lua       # コーディング支援
│       └── example.lua      # カスタムプラグイン例
```

### 初期化プロセス

1. **init.lua**: LazyVimのブートストラップ
2. **config/lazy.lua**: Lazy.nvimの初期化
3. **config/options.lua**: Vim基本設定
4. **config/keymaps.lua**: キーマップ設定
5. **config/autocmds.lua**: 自動コマンド
6. **plugins/\*.lua**: プラグイン設定読み込み

## 2. 基本設定のカスタマイズ

### options.lua - Vim設定

```lua
-- ~/.config/nvim/lua/config/options.lua

local opt = vim.opt

-- 個人的な設定例
opt.relativenumber = false  -- 相対行番号を無効化
opt.wrap = true            -- 行の折り返しを有効化
opt.scrolloff = 8          -- スクロール時の余白を8行に
opt.sidescrolloff = 8      -- 横スクロール時の余白

-- 検索設定
opt.ignorecase = true      -- 大文字小文字を無視
opt.smartcase = true       -- 大文字が含まれる場合は区別

-- タブ・インデント設定（デフォルトをオーバーライド）
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- バックアップ・スワップファイル
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- 言語固有設定
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml", "yml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
```

### keymaps.lua - キーマップカスタマイズ

```lua
-- ~/.config/nvim/lua/config/keymaps.lua

local map = vim.keymap.set

-- 既存キーマップの削除
vim.keymap.del("n", "<leader>l") -- デフォルトのlazy.nvimキーマップ

-- 個人的なキーマップ追加
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- ウィンドウ移動をより直感的に
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- ターミナルモードのキーマップ
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- カスタム機能のキーマップ
map("n", "<leader>fn", function()
  local filename = vim.fn.input("New file name: ")
  if filename ~= "" then
    vim.cmd("edit " .. filename)
  end
end, { desc = "Create new file" })

-- 挿入モードでの便利キーマップ
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
```

### autocmds.lua - 自動コマンド

```lua
-- ~/.config/nvim/lua/config/autocmds.lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- 個人的な自動コマンド
local personal_group = augroup("PersonalAutocmds", { clear = true })

-- ファイル保存時に末尾の空白を削除
autocmd("BufWritePre", {
  group = personal_group,
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- 大きなファイルでは一部機能を無効化
autocmd("BufReadPre", {
  group = personal_group,
  pattern = "*",
  callback = function()
    local max_filesize = 1024 * 1024 -- 1MB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      vim.b.large_buf = true
      vim.opt_local.syntax = "off"
      vim.opt_local.swapfile = false
      vim.opt_local.bufhidden = "unload"
    end
  end,
})

-- 最後のカーソル位置を復元
autocmd("BufReadPost", {
  group = personal_group,
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
```

## 3. プラグイン管理とカスタマイズ

### Lazy.nvimの基本操作

```vim
:Lazy          " プラグイン管理UI表示
:Lazy install  " 新しいプラグインをインストール
:Lazy update   " プラグインを更新
:Lazy clean    " 不要なプラグインを削除
:Lazy sync     " install + update + clean
:Lazy profile  " 起動時間のプロファイル
```

### 新しいプラグインの追加

```lua
-- ~/.config/nvim/lua/plugins/custom.lua

return {
  -- GitHub Copilotの追加
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
    end,
  },

  -- カラースキームの変更
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
  },

  -- 追加のステータスライン
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      theme = "catppuccin",
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Git統合の強化
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
      },
    },
  },
}
```

### 既存プラグインの設定変更

```lua
-- ~/.config/nvim/lua/plugins/overrides.lua

return {
  -- Telescopeの設定カスタマイズ
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        sorting_strategy = "ascending",
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
    },
  },

  -- Neo-treeの設定変更
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "right", -- 右側に表示
        width = 40,
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
    },
  },

  -- treesitterの言語追加
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash", "html", "javascript", "json", "lua", "markdown",
        "markdown_inline", "python", "query", "regex", "tsx",
        "typescript", "vim", "yaml", "rust", "go", "java",
      },
    },
  },
}
```

### プラグインの無効化

```lua
-- ~/.config/nvim/lua/plugins/disabled.lua

return {
  -- 不要なプラグインを無効化
  { "folke/flash.nvim", enabled = false },
  { "echasnovski/mini.pairs", enabled = false },
  { "RRethy/vim-illuminate", enabled = false },
}
```

## 4. 条件付き設定とプロファイル

### OS別設定

```lua
-- ~/.config/nvim/lua/config/options.lua

local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
local is_wsl = vim.fn.has("wsl") == 1

if is_windows then
  -- Windows固有設定
  vim.opt.shell = "powershell"
  vim.opt.shellcmdflag = "-command"
elseif is_wsl then
  -- WSL固有設定
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
end
```

### プロジェクト別設定

```lua
-- ~/.config/nvim/lua/config/autocmds.lua

-- プロジェクト固有設定の読み込み
autocmd("VimEnter", {
  callback = function()
    local project_config = vim.fn.getcwd() .. "/.nvim.lua"
    if vim.fn.filereadable(project_config) == 1 then
      dofile(project_config)
    end
  end,
})
```

```lua
-- プロジェクトルートの .nvim.lua 例
-- この設定は該当プロジェクトでのみ有効

-- TypeScriptプロジェクト用設定
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

-- プロジェクト固有のキーマップ
vim.keymap.set("n", "<leader>pr", "<cmd>!npm run dev<cr>", { desc = "Run dev server" })
vim.keymap.set("n", "<leader>pt", "<cmd>!npm test<cr>", { desc = "Run tests" })
vim.keymap.set("n", "<leader>pb", "<cmd>!npm run build<cr>", { desc = "Build project" })
```

## 5. 外観・UIカスタマイズ

### カラースキーム設定

```lua
-- ~/.config/nvim/lua/plugins/colorscheme.lua

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = false,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = false,
      },
    },
  },
}
```

### ステータスライン・タブライン

```lua
-- ~/.config/nvim/lua/plugins/ui.lua

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        },
        lualine_x = {
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = LazyVim.ui.fg("Statement"),
          },
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = LazyVim.ui.fg("Constant"),
          },
          { "encoding" },
          { "fileformat" },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
    },
  },
}
```

## 6. パフォーマンス最適化

### 起動時間の最適化

```lua
-- ~/.config/nvim/lua/config/lazy.lua

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
```

### 大きなファイル対応

```lua
-- ~/.config/nvim/lua/config/autocmds.lua

autocmd("BufReadPre", {
  callback = function()
    local max_filesize = 100 * 1024 -- 100KB
    local filename = vim.api.nvim_buf_get_name(0)
    local ok, stats = pcall(vim.loop.fs_stat, filename)
    
    if ok and stats and stats.size > max_filesize then
      -- 大きなファイルでは機能を制限
      vim.opt_local.syntax = "off"
      vim.opt_local.wrap = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.undolevels = -1
      
      -- プラグインを無効化
      vim.b.large_buf = true
      vim.cmd("syntax clear")
    end
  end,
})
```

## 7. 設定の管理とバックアップ

### Git管理

```bash
# Neovim設定をGitで管理
cd ~/.config/nvim
git init
git add .
git commit -m "Initial Neovim configuration"
git remote add origin <your-dotfiles-repo>
git push -u origin main
```

### 設定の分離

```lua
-- ~/.config/nvim/lua/config/personal.lua
-- 個人設定を分離（Git管理外）

local M = {}

-- 個人的なAPI keyや秘密情報
M.api_keys = {
  openai = os.getenv("OPENAI_API_KEY"),
  github = os.getenv("GITHUB_TOKEN"),
}

-- 個人的な設定
M.personal_settings = {
  email = "your.email@example.com",
  name = "Your Name",
  work_directory = "~/work",
}

return M
```

### 設定のバックアップ・復元

```bash
#!/bin/bash
# backup-nvim-config.sh

BACKUP_DIR="$HOME/nvim-backup-$(date +%Y%m%d)"
CONFIG_DIR="$HOME/.config/nvim"

echo "Backing up Neovim configuration to $BACKUP_DIR"
cp -r "$CONFIG_DIR" "$BACKUP_DIR"
echo "Backup completed!"

# 復元用スクリプト
# restore-nvim-config.sh
BACKUP_DIR="$1"
CONFIG_DIR="$HOME/.config/nvim"

if [ -z "$BACKUP_DIR" ]; then
  echo "Usage: $0 <backup-directory>"
  exit 1
fi

echo "Restoring Neovim configuration from $BACKUP_DIR"
rm -rf "$CONFIG_DIR"
cp -r "$BACKUP_DIR" "$CONFIG_DIR"
echo "Restore completed!"
```

## まとめ

LazyVimのカスタマイズにより：
- **個人最適化**: 自分の作業スタイルに合わせた環境構築
- **生産性向上**: よく使う機能への素早いアクセス
- **メンテナンス性**: 設定の構造化と管理
- **拡張性**: 新しい要件に対する柔軟な対応

継続的に設定を改善し、自分だけの最適な開発環境を構築することで、長期的な生産性向上を実現できます。