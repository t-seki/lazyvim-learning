-- Auto Commands Configuration
-- ===========================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General auto commands group
local general = augroup("General", { clear = true })

-- Highlight yanked text
autocmd("TextYankPost", {
  group = general,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
  desc = "Highlight yanked text",
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  command = [[%s/\s\+$//e]],
  desc = "Remove trailing whitespace on save",
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
  group = general,
  command = "tabdo wincmd =",
  desc = "Auto-resize splits on window resize",
})

-- Return to last cursor position
autocmd("BufReadPost", {
  group = general,
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
  desc = "Return to last cursor position",
})

-- Close certain filetypes with q
autocmd("FileType", {
  group = general,
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close with q",
})

-- File type specific settings
local filetype = augroup("FileType", { clear = true })

-- Set indentation for specific file types
autocmd("FileType", {
  group = filetype,
  pattern = { "python", "lua" },
  command = "setlocal tabstop=4 shiftwidth=4",
  desc = "Set 4-space indentation for Python and Lua",
})

autocmd("FileType", {
  group = filetype,
  pattern = { "javascript", "typescript", "json", "html", "css", "yaml" },
  command = "setlocal tabstop=2 shiftwidth=2",
  desc = "Set 2-space indentation for web technologies",
})

-- Enable spell checking for text files
autocmd("FileType", {
  group = filetype,
  pattern = { "markdown", "text", "gitcommit" },
  command = "setlocal spell",
  desc = "Enable spell checking for text files",
})

-- Set wrap for text files
autocmd("FileType", {
  group = filetype,
  pattern = { "markdown", "text" },
  command = "setlocal wrap linebreak",
  desc = "Enable text wrapping for text files",
})

-- LSP specific auto commands
local lsp = augroup("LSP", { clear = true })

-- Show line diagnostics automatically in hover window
autocmd("CursorHold", {
  group = lsp,
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
  desc = "Show line diagnostics on cursor hold",
})

-- Format on save for specific file types
autocmd("BufWritePre", {
  group = lsp,
  pattern = { "*.lua", "*.py", "*.js", "*.ts", "*.jsx", "*.tsx", "*.go", "*.rs" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
  desc = "Format on save",
})

-- Terminal specific settings
local terminal = augroup("Terminal", { clear = true })

-- Start terminal in insert mode
autocmd("TermOpen", {
  group = terminal,
  pattern = "*",
  command = "startinsert",
  desc = "Start terminal in insert mode",
})

-- Disable line numbers in terminal
autocmd("TermOpen", {
  group = terminal,
  pattern = "*",
  command = "setlocal nonumber norelativenumber",
  desc = "Disable line numbers in terminal",
})

-- Alpha dashboard (if using alpha-nvim)
local alpha = augroup("Alpha", { clear = true })

-- Disable statusline in Alpha buffer
autocmd("User", {
  group = alpha,
  pattern = "AlphaReady",
  command = "set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2",
  desc = "Disable tabline for Alpha",
})

-- Git specific auto commands
local git = augroup("Git", { clear = true })

-- Enable spell checking in git commit messages
autocmd("FileType", {
  group = git,
  pattern = "gitcommit",
  command = "setlocal spell",
  desc = "Enable spell checking for git commits",
})

-- Automatically close Neovim if Neo-tree is the last window
local neotree = augroup("NeoTree", { clear = true })

autocmd("BufEnter", {
  group = neotree,
  pattern = "*",
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.bo.filetype == "neo-tree" then
      vim.cmd("quit")
    end
  end,
  desc = "Close Neovim if Neo-tree is the last window",
})

-- Large file handling
local large_file = augroup("LargeFile", { clear = true })

autocmd("BufReadPre", {
  group = large_file,
  pattern = "*",
  callback = function()
    local file_size = vim.fn.getfsize(vim.fn.expand("%"))
    -- 1MB threshold
    if file_size > 1024 * 1024 then
      vim.cmd("syntax off")
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.undolevels = -1
      vim.opt_local.undoreload = 0
      vim.opt_local.list = false
    end
  end,
  desc = "Optimize settings for large files",
})

-- Auto-save functionality (optional)
local autosave = augroup("AutoSave", { clear = true })

-- Uncomment the following to enable auto-save
--[[
autocmd({ "InsertLeave", "TextChanged" }, {
  group = autosave,
  pattern = "*",
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.cmd("silent! write")
    end
  end,
  desc = "Auto-save on text change and insert leave",
})
--]]

-- Project specific settings
local project = augroup("Project", { clear = true })

-- Auto-change directory to project root
autocmd("BufEnter", {
  group = project,
  pattern = "*",
  callback = function()
    local root_patterns = { ".git", "package.json", "Cargo.toml", "go.mod", "pyproject.toml" }
    local path = vim.fn.expand("%:p:h")
    
    for _, pattern in ipairs(root_patterns) do
      local root = vim.fn.finddir(pattern, path .. ";")
      if root ~= "" then
        local project_root = vim.fn.fnamemodify(root, ":h")
        if project_root ~= vim.fn.getcwd() then
          vim.cmd("lcd " .. project_root)
        end
        break
      end
      
      local file_root = vim.fn.findfile(pattern, path .. ";")
      if file_root ~= "" then
        local project_root = vim.fn.fnamemodify(file_root, ":h")
        if project_root ~= vim.fn.getcwd() then
          vim.cmd("lcd " .. project_root)
        end
        break
      end
    end
  end,
  desc = "Auto-change to project root directory",
})

-- Learning helpers
local learning = augroup("Learning", { clear = true })

-- Show which-key for partial keymaps
autocmd("CmdlineEnter", {
  group = learning,
  pattern = ":",
  callback = function()
    -- You can add learning-specific commands here
  end,
  desc = "Learning mode helpers",
})

-- Clipboard synchronization (useful for SSH/remote sessions)
local clipboard = augroup("Clipboard", { clear = true })

-- Sync clipboard on focus events
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = clipboard,
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
  desc = "Check for file changes",
})

-- Performance optimization
local performance = augroup("Performance", { clear = true })

-- Disable cursorline in insert mode for better performance
autocmd("InsertEnter", {
  group = performance,
  pattern = "*",
  command = "setlocal nocursorline",
  desc = "Disable cursorline in insert mode",
})

autocmd("InsertLeave", {
  group = performance,
  pattern = "*",
  command = "setlocal cursorline",
  desc = "Enable cursorline in normal mode",
})