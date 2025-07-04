-- Neovim Configuration for Learning Environment
-- =============================================

-- Set leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load plugins
require("lazy").setup("plugins", {
  -- Plugin installation options
  install = {
    colorscheme = { "catppuccin" }
  },
  
  -- Check for plugin updates automatically
  checker = {
    enabled = true,
    notify = false,
  },
  
  -- Plugin change detection
  change_detection = {
    enabled = true,
    notify = false,
  },
  
  -- Performance optimizations
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

-- Set colorscheme after plugins are loaded
vim.cmd.colorscheme("catppuccin")