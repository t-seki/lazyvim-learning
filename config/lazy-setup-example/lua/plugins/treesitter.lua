-- Treesitter Configuration
-- ========================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Install parsers automatically
        ensure_installed = {
          "bash",
          "c",
          "css",
          "dockerfile",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "rust",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        
        -- Automatically install missing parsers when entering buffer
        auto_install = true,
        
        -- List of parsers to ignore installing (for "all")
        ignore_install = {},
        
        -- Highlighting configuration
        highlight = {
          enable = true,
          
          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        
        -- Indentation configuration
        indent = {
          enable = true,
          disable = { "python", "yaml" }, -- Python and YAML indentation can be problematic
        },
        
        -- Incremental selection configuration
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        
        -- Text objects configuration
        textobjects = {
          select = {
            enable = true,
            
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              ["as"] = "@statement.outer",
              ["is"] = "@statement.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["ad"] = "@conditional.outer",
              ["id"] = "@conditional.inner",
              ["at"] = "@comment.outer",
              ["it"] = "@comment.inner",
            },
            
            -- You can choose the select mode (default is charwise 'v')
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap` and `ip` mappings.
            include_surrounding_whitespace = false,
          },
          
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              ["]o"] = "@loop.*",
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
            goto_next = {
              ["]d"] = "@conditional.outer",
            },
            goto_previous = {
              ["[d"] = "@conditional.outer",
            }
          },
          
          lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>df"] = "@function.outer",
              ["<leader>dF"] = "@class.outer",
            },
          },
        },
        
        -- Context-aware commenting
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        
        -- Folding configuration
        fold = {
          enable = false, -- Disabled by default, can be slow
          disable = {},
        },
        
        -- Rainbow parentheses (optional, requires rainbow plugin)
        rainbow = {
          enable = false,
          disable = {},
          extended_mode = true,
          max_file_lines = nil,
        },
        
        -- Autopairs integration
        autopairs = {
          enable = true,
        },
        
        -- Playground (for debugging treesitter)
        playground = {
          enable = false,
          disable = {},
          updatetime = 25,
          persist_queries = false,
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
      })
      
      -- Set up context-aware commenting
      vim.g.skip_ts_context_commentstring_module = true
    end,
  },

  -- Show context of current cursor position
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
        separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
      
      -- Key mapping to toggle context
      vim.keymap.set("n", "<leader>tc", function()
        require("treesitter-context").toggle()
      end, { desc = "Toggle Treesitter Context" })
    end,
  },

  -- Context-aware commenting
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
        languages = {
          typescript = "// %s",
          css = "/* %s */",
          scss = "/* %s */",
          html = "<!-- %s -->",
          svelte = "<!-- %s -->",
          vue = "<!-- %s -->",
          json = "",
        },
      })
    end,
  },

  -- Text objects for treesitter
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  -- Additional language support
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false -- Auto close on trailing </
        },
        per_filetype = {
          ["html"] = {
            enable_close = false
          }
        }
      })
    end,
  },
}