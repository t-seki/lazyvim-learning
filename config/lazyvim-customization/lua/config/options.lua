-- Additional Options for Learning Environment
-- ===========================================

local opt = vim.opt

-- Learning-specific options
vim.g.learning_mode = true
vim.g.show_key_hints = true

-- Enhanced visual feedback for learning
opt.cursorline = true
opt.cursorcolumn = false -- Start with column off, can be toggled
opt.colorcolumn = "80,120" -- Show multiple rulers
opt.list = true
opt.listchars = {
  tab = "→ ",
  trail = "·",
  extends = "»",
  precedes = "«",
  nbsp = "␣",
  eol = "¬", -- Show line endings for learning
}

-- Better defaults for learning
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes:2" -- Always show sign column with more space
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Enhanced search for learning
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Spell checking for documentation writing
opt.spell = true
opt.spelllang = { "en_us", "cjk" } -- Support for Japanese
opt.spelloptions = "camel" -- Camel case spell checking

-- Better command line for learning
opt.cmdheight = 1
opt.showcmd = true
opt.showmode = true -- Show mode for learning

-- Learning-friendly timeouts
opt.updatetime = 300 -- Faster feedback
opt.timeoutlen = 500 -- Longer timeout for which-key

-- File handling
opt.autoread = true
opt.autowrite = true

-- Better diff options for learning Git
opt.diffopt:append("internal,algorithm:patience")
opt.diffopt:append("linematch:60")

-- Learning session settings
opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Folding settings (helpful for large files)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false -- Start with folds open
opt.foldlevelstart = 99

-- Terminal settings
opt.termguicolors = true

-- Japanese text handling
if vim.fn.has("multi_byte") == 1 then
  opt.encoding = "utf-8"
  opt.fileencoding = "utf-8"
  opt.fileencodings = "utf-8,cp932,euc-jp,iso-2022-jp"
end

-- Learning progress tracking
vim.g.lesson_progress = {}

-- Helper function to track lesson completion
function _G.mark_lesson_complete(lesson_name)
  vim.g.lesson_progress[lesson_name] = {
    completed = true,
    completion_time = os.time(),
  }
  vim.notify("Lesson '" .. lesson_name .. "' completed! 🎉", vim.log.levels.INFO, {
    title = "Learning Progress",
  })
end

-- Helper function to show learning tips
function _G.show_learning_tip(tip)
  vim.notify(tip, vim.log.levels.INFO, {
    title = "💡 Learning Tip",
    timeout = 5000,
  })
end

-- Auto-commands for learning environment
local learning_group = vim.api.nvim_create_augroup("LearningEnvironment", { clear = true })

-- Show tip when entering help files
vim.api.nvim_create_autocmd("FileType", {
  group = learning_group,
  pattern = "help",
  callback = function()
    show_learning_tip("Use <C-]> to follow links and <C-T> to go back in help files!")
  end,
})

-- Show tip when opening telescope
vim.api.nvim_create_autocmd("User", {
  group = learning_group,
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    show_learning_tip("Use <C-u>/<C-d> to scroll preview, <Tab> to toggle selection!")
  end,
})

-- Highlight yanked text for visual feedback
vim.api.nvim_create_autocmd("TextYankPost", {
  group = learning_group,
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 500, -- Longer highlight for learning
    })
  end,
})