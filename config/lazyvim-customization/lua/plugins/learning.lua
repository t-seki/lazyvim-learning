-- Learning Support Plugins for LazyVim
-- ====================================

return {
  -- Enhanced which-key for learning
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      -- Extend existing which-key configuration for learning
      local wk = require("which-key")
      
      -- Learning-specific key groups
      wk.register({
        ["<leader>l"] = {
          name = "Learning",
          l = "Lesson browser",
          p = "Learning progress", 
          c = "Mark lesson complete",
          t = "Random tip",
          h = "Help browser",
          k = "Keymap cheat sheet",
          v = "Toggle color column",
          n = "Toggle line numbers",
          r = "Toggle relative numbers",
          ["?"] = "Emergency help",
        },
      })
      
      return opts
    end,
  },

  -- Show keystrokes for learning
  {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    opts = {
      timeout = 1,
      maxkeys = 5,
      show_count = true,
      excluded_modes = { "i" }, -- Don't show in insert mode
      position = "top-right",
    },
    keys = {
      { "<leader>lk", "<cmd>ShowkeysToggle<cr>", desc = "Toggle keystroke display" },
    },
  },

  -- Learning tips and notifications
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      -- Enhanced notifications for learning
      opts.timeout = 5000
      opts.stages = "fade_in_slide_out"
      opts.render = "compact"
      opts.top_down = false
      return opts
    end,
  },

  -- Buffer management for learning
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      -- Show buffer numbers for learning
      opts.options.numbers = "ordinal"
      opts.options.show_buffer_close_icons = true
      opts.options.show_close_icon = true
      return opts
    end,
  },

  -- Learning progress persistence
  {
    "folke/persistence.nvim",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- Help and documentation enhancement
  {
    "folke/trouble.nvim",
    opts = function(_, opts)
      -- Learning-friendly trouble configuration
      opts.auto_open = false
      opts.auto_close = true
      opts.use_diagnostic_signs = true
      return opts
    end,
  },
}