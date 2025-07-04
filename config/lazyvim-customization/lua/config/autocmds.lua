-- Learning Environment Auto Commands
-- ==================================

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_learning_" .. name, { clear = true })
end

-- Learning tips and hints
local learning_group = augroup("learning")

-- Show tip when entering help files
vim.api.nvim_create_autocmd("FileType", {
  group = learning_group,
  pattern = "help",
  callback = function()
    if vim.g.show_key_hints then
      vim.notify("💡 Tip: Use <C-]> to follow links and <C-T> to go back in help files!", vim.log.levels.INFO, {
        title = "Learning Tip",
        timeout = 3000,
      })
    end
  end,
})

-- Show tip when opening telescope
vim.api.nvim_create_autocmd("User", {
  group = learning_group,
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    if vim.g.show_key_hints then
      vim.notify("💡 Tip: Use <C-u>/<C-d> to scroll preview, <Tab> to toggle selection!", vim.log.levels.INFO, {
        title = "Telescope Tip",
        timeout = 3000,
      })
    end
  end,
})

-- Enhanced yank highlighting for learning
vim.api.nvim_create_autocmd("TextYankPost", {
  group = learning_group,
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 800, -- Longer highlight for learning
    })
  end,
})

-- Learning mode auto commands
local learning_mode_group = augroup("learning_mode")

-- Auto-save learning progress
vim.api.nvim_create_autocmd("BufWritePost", {
  group = learning_mode_group,
  pattern = "**/lessons/**/README.md",
  callback = function()
    -- Auto-save when completing lesson README
    local lesson_dir = vim.fn.expand("%:p:h")
    local lesson_name = vim.fn.fnamemodify(lesson_dir, ":t")
    
    if lesson_name:match("^%d%d%-") then
      vim.notify("📝 Progress saved for lesson: " .. lesson_name, vim.log.levels.INFO, {
        title = "Learning Progress",
      })
    end
  end,
})

-- Welcome message for learning sessions
vim.api.nvim_create_autocmd("VimEnter", {
  group = learning_mode_group,
  callback = function()
    if vim.g.learning_mode then
      vim.defer_fn(function()
        vim.notify("🎓 Welcome to LazyVim Learning! Press <Space> to see available commands.", vim.log.levels.INFO, {
          title = "LazyVim Learning",
          timeout = 5000,
        })
      end, 1000)
    end
  end,
})

-- File type specific learning hints
local filetype_group = augroup("filetype_learning")

-- Lua file learning hints
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = "lua",
  callback = function()
    if vim.g.show_key_hints then
      vim.defer_fn(function()
        vim.notify("💡 Lua Tip: Use 'gd' to go to definition, 'K' for documentation!", vim.log.levels.INFO, {
          title = "Lua Learning",
          timeout = 3000,
        })
      end, 2000)
    end
  end,
})

-- Markdown file learning hints
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = "markdown",
  callback = function()
    if vim.g.show_key_hints then
      vim.defer_fn(function()
        vim.notify("💡 Markdown Tip: Use ']h' and '[h' to navigate between headers!", vim.log.levels.INFO, {
          title = "Markdown Learning",
          timeout = 3000,
        })
      end, 2000)
    end
  end,
})

-- LSP learning hints
vim.api.nvim_create_autocmd("LspAttach", {
  group = learning_group,
  callback = function(event)
    if vim.g.show_key_hints then
      vim.defer_fn(function()
        vim.notify("🔍 LSP Active! Try 'gd' (definition), 'gr' (references), 'K' (hover)", vim.log.levels.INFO, {
          title = "LSP Learning",
          timeout = 4000,
        })
      end, 3000)
    end
  end,
})

-- Telescope learning hints
vim.api.nvim_create_autocmd("User", {
  group = learning_group,
  pattern = "TelescopePreviewerLoaded",
  once = true,
  callback = function()
    if vim.g.show_key_hints then
      vim.notify("🔭 Telescope shortcuts: <C-n/p> navigate, <C-u/d> scroll preview, <Tab> select multiple", vim.log.levels.INFO, {
        title = "Telescope Learning",
        timeout = 5000,
      })
    end
  end,
})