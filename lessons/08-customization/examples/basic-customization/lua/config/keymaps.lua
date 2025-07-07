-- 基本的なキーマップカスタマイズ例
-- ~/.config/nvim/lua/config/keymaps.lua

local map = vim.keymap.set

-- === リーダーキー設定 ===
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- === 基本操作の改善 ===
-- より素早い保存・終了
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all files" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

-- Escapeの代替（指を楽に）
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "kj", "<ESC>", { desc = "Exit insert mode" })

-- === ウィンドウ・バッファ操作 ===
-- ウィンドウ間移動
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- ウィンドウサイズ調整
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- バッファ操作
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Close other buffers" })

-- === 移動・選択の改善 ===
-- より自然な j/k 移動（折り返し行も含む）
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- 行の先頭・末尾への移動
map("n", "H", "^", { desc = "Go to start of line" })
map("n", "L", "$", { desc = "Go to end of line" })
map("v", "H", "^", { desc = "Go to start of line" })
map("v", "L", "$", { desc = "Go to end of line" })

-- ページ移動時にカーソルを中央に
map("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })

-- === インデント操作 ===
-- ビジュアルモードでのインデント後も選択を維持
map("v", "<", "<gv", { desc = "Decrease indent" })
map("v", ">", ">gv", { desc = "Increase indent" })

-- === 検索・置換の改善 ===
-- 検索結果を中央に表示
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Previous search result" })

-- 検索ハイライトをクリア
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- 選択されたテキストで検索
map("v", "*", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>", { desc = "Search selected text" })

-- === コピー・ペーストの改善 ===
-- システムクリップボードとの連携
map("n", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- ペースト時にレジスタを汚さない
map("x", "<leader>p", '"_dP', { desc = "Paste without affecting register" })

-- === ターミナル操作 ===
-- ターミナルモードでのウィンドウ移動
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- ターミナルモードから抜ける
map("t", "<C-\\><C-n>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- === カスタム機能 ===
-- 新しいファイルを作成
map("n", "<leader>fn", function()
  local filename = vim.fn.input("New file name: ")
  if filename ~= "" then
    vim.cmd("edit " .. filename)
  end
end, { desc = "Create new file" })

-- 現在のファイルをリロード
map("n", "<leader>fr", "<cmd>edit!<cr>", { desc = "Reload current file" })

-- 現在のファイルのディレクトリをカレントディレクトリに
map("n", "<leader>cd", "<cmd>cd %:p:h<cr>", { desc = "Change to current file directory" })

-- === 挿入モードでの移動 ===
-- Ctrl + 矢印キーで単語単位移動
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })

-- === 便利な編集機能 ===
-- 行の複製
map("n", "<leader>d", "yyp", { desc = "Duplicate line" })
map("v", "<leader>d", "y`>p", { desc = "Duplicate selection" })

-- 選択行を上下に移動
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- === quickfix・location list ===
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- === 数値の増減 ===
map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })

-- === 折りたたみ ===
map("n", "<leader>z", "za", { desc = "Toggle fold" })
map("n", "<leader>Z", "zA", { desc = "Toggle fold recursively" })

-- === その他の便利機能 ===
-- 空行の挿入
map("n", "<leader>o", "o<ESC>", { desc = "Insert empty line below" })
map("n", "<leader>O", "O<ESC>", { desc = "Insert empty line above" })

-- 選択したテキストを置換
map("v", "<leader>r", "hy:%s/<C-r>h//g<left><left>", { desc = "Replace selected text" })

-- ファイル先頭・末尾への移動
map("n", "gg", "gg0", { desc = "Go to first line" })
map("n", "G", "G$", { desc = "Go to last line" })