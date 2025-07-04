-- Neovim Basic Options
-- ====================

local opt = vim.opt

-- UI & Display
opt.number = true          -- Show line numbers
opt.relativenumber = true  -- Show relative line numbers
opt.signcolumn = "yes"     -- Always show sign column
opt.cursorline = true      -- Highlight current line
opt.wrap = false           -- Disable line wrapping
opt.scrolloff = 8          -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8      -- Keep 8 columns left/right of cursor
opt.colorcolumn = "80"     -- Show ruler at column 80

-- Search
opt.ignorecase = true      -- Ignore case in search
opt.smartcase = true       -- Override ignorecase if search contains uppercase
opt.hlsearch = true        -- Highlight search results
opt.incsearch = true       -- Show search results while typing

-- Indentation
opt.tabstop = 2           -- Number of spaces for tab
opt.shiftwidth = 2        -- Number of spaces for autoindent
opt.expandtab = true      -- Convert tabs to spaces
opt.autoindent = true     -- Copy indent from current line
opt.smartindent = true    -- Smart autoindenting

-- Splits
opt.splitbelow = true     -- Horizontal splits go below
opt.splitright = true     -- Vertical splits go right

-- Files & Buffers
opt.hidden = true         -- Allow hidden buffers
opt.autowrite = true      -- Auto save before switching buffers
opt.autoread = true       -- Auto reload changed files
opt.swapfile = false      -- Disable swap files
opt.backup = false        -- Disable backup files
opt.writebackup = false   -- Disable backup before writing

-- Undo & History
opt.undofile = true       -- Enable persistent undo
opt.undolevels = 10000    -- Maximum number of undo levels
opt.history = 10000       -- Command history length

-- Completion
opt.completeopt = "menu,menuone,noselect"  -- Completion options
opt.pumheight = 15        -- Maximum items in popup menu

-- Performance
opt.updatetime = 250      -- Faster completion (default 4000ms)
opt.timeoutlen = 300      -- Faster key sequence timeout
opt.lazyredraw = true     -- Don't redraw during macros

-- Mouse & Clipboard
opt.mouse = "a"           -- Enable mouse in all modes
opt.clipboard = "unnamedplus"  -- Use system clipboard

-- Formatting
opt.formatoptions:remove({ "c", "r", "o" })  -- Don't insert comment leader automatically

-- Folding (disabled by default)
opt.foldenable = false    -- Disable folding by default
opt.foldmethod = "indent" -- Fold based on indentation
opt.foldlevel = 99        -- Open all folds by default

-- Visual indicators
opt.list = true           -- Show invisible characters
opt.listchars = {
  tab = "→ ",
  trail = "·",
  extends = "»",
  precedes = "«",
  nbsp = "␣",
}

-- Command line
opt.cmdheight = 1         -- Height of command line
opt.showcmd = true        -- Show command in bottom right
opt.showmode = false      -- Don't show mode (statusline will show it)

-- Status line
opt.laststatus = 3        -- Global statusline

-- Terminal
opt.termguicolors = true  -- Enable 24-bit RGB colors

-- Spelling (disabled by default)
opt.spell = false         -- Disable spell checking
opt.spelllang = { "en_us" }  -- Spell check language

-- Session options
opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- Diff options
opt.diffopt:append("internal,algorithm:patience")

-- Grep program
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --follow"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Wildmenu
opt.wildmenu = true       -- Enable command-line completion
opt.wildmode = "longest:full,full"  -- Command-line completion mode
opt.wildignore:append({
  "*.o", "*.obj", "*.pyc", "*.pyo", "*.pyd", "*.class", "*.lock",
  "*.DS_Store", "*.swp", "*.swo", "*~", "._*",
  "node_modules/*", ".git/*", ".hg/*", ".svn/*",
  "*.jpg", "*.jpeg", "*.png", "*.gif", "*.bmp", "*.ico",
  "*.pdf", "*.doc", "*.docx", "*.ppt", "*.pptx",
})

-- Neovim specific options
if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"  -- Keep screen layout when splitting
end

-- Platform specific options
if vim.fn.has("win32") == 1 then
  opt.shell = "powershell"
  opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  opt.shellquote = ""
  opt.shellxquote = ""
end