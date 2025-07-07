-- 基本的なカスタマイズ例
-- ~/.config/nvim/lua/config/options.lua

local opt = vim.opt

-- === 表示設定 ===
opt.number = true              -- 行番号表示
opt.relativenumber = false     -- 相対行番号は無効（お好みで）
opt.cursorline = true          -- カーソル行をハイライト
opt.cursorcolumn = false       -- カーソル列は表示しない
opt.wrap = true                -- 長い行を折り返し
opt.linebreak = true           -- 単語境界で折り返し
opt.showbreak = "↪ "           -- 折り返し行の先頭記号

-- === 検索設定 ===
opt.ignorecase = true          -- 大文字小文字を無視
opt.smartcase = true           -- 大文字が含まれる場合は区別
opt.hlsearch = true            -- 検索結果をハイライト
opt.incsearch = true           -- インクリメンタル検索

-- === インデント・タブ設定 ===
opt.expandtab = true           -- タブをスペースに展開
opt.tabstop = 4                -- タブの表示幅
opt.shiftwidth = 4             -- 自動インデントの幅
opt.softtabstop = 4            -- Tab キー押下時の挿入スペース数
opt.autoindent = true          -- 自動インデント
opt.smartindent = true         -- スマートインデント

-- === スクロール設定 ===
opt.scrolloff = 8              -- 上下の余白
opt.sidescrolloff = 8          -- 左右の余白
opt.mouse = "a"                -- マウス操作を有効

-- === ファイル処理 ===
opt.backup = false             -- バックアップファイルを作成しない
opt.writebackup = false        -- 書き込み時のバックアップも無効
opt.swapfile = false           -- スワップファイルを作成しない
opt.undofile = true            -- アンドゥファイルを永続化

-- === ウィンドウ・分割 ===
opt.splitbelow = true          -- 水平分割は下に
opt.splitright = true          -- 垂直分割は右に
opt.winminheight = 0           -- ウィンドウの最小高さ
opt.winminwidth = 0            -- ウィンドウの最小幅

-- === 補完設定 ===
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10             -- 補完メニューの最大高さ

-- === パフォーマンス ===
opt.updatetime = 250           -- CursorHold の遅延時間
opt.timeoutlen = 300           -- キーマップのタイムアウト
opt.redrawtime = 10000         -- 再描画のタイムアウト

-- === 特殊文字の表示 ===
opt.list = true                -- 不可視文字を表示
opt.listchars = {
  tab = "→ ",                  -- タブ文字
  trail = "•",                 -- 行末スペース
  extends = "»",               -- 画面右端を超える文字
  precedes = "«",              -- 画面左端を超える文字
  nbsp = "⦸",                  -- ノーブレークスペース
}

-- === フォールドング ===
opt.foldmethod = "expr"        -- fold方法
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false         -- 起動時はfoldを無効

-- === 言語別設定 ===
-- Python
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- YAML
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml", "yml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- TypeScript/JavaScript
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Go
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false  -- Goはタブを使用
  end,
})

-- === OS固有設定 ===
if vim.fn.has("wsl") == 1 then
  -- WSL環境でのクリップボード設定
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