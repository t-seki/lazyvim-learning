-- Completion Configuration
-- ========================

return {
  -- Main completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Completion sources
      "hrsh7th/cmp-nvim-lsp",           -- LSP completions
      "hrsh7th/cmp-buffer",             -- Buffer completions
      "hrsh7th/cmp-path",               -- Path completions
      "hrsh7th/cmp-cmdline",            -- Command line completions
      "hrsh7th/cmp-nvim-lua",           -- Neovim Lua API completions
      
      -- Snippets
      "L3MON4D3/LuaSnip",              -- Snippet engine
      "saadparwaiz1/cmp_luasnip",      -- Snippet completions
      "rafamadriz/friendly-snippets",   -- Collection of snippets
      
      -- Icons
      "onsails/lspkind.nvim",          -- VS Code-like pictograms
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      
      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Custom snippet loading (optional)
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
      
      -- LuaSnip configuration
      luasnip.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
      })
      
      -- Check if we can expand or jump
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
          }),
        },
        
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              -- Show source
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lua = "[Lua]",
                cmdline = "[CMD]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          
          -- Tab completion
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "nvim_lua", priority = 500 },
          { name = "buffer", priority = 250, keyword_length = 3 },
          { name = "path", priority = 250 },
        }),
        
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        
        -- Sorting configuration
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      })
      
      -- Command line completion
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })
      
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })
      
      -- Autopairs integration
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")
      
      -- Key mappings for snippet navigation
      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { silent = true })
      
      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { silent = true })
      
      vim.keymap.set("i", "<C-k>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, { silent = true })
      
      -- Custom snippets (optional)
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local sn = ls.snippet_node
      
      -- Add custom snippets
      ls.add_snippets("lua", {
        s("hello", {
          t("print(\"Hello, "),
          i(1, "World"),
          t("!\")"),
        }),
      })
      
      ls.add_snippets("javascript", {
        s("log", {
          t("console.log("),
          i(1, "message"),
          t(");"),
        }),
        s("func", {
          t("function "),
          i(1, "name"),
          t("("),
          i(2, "params"),
          t(") {"),
          t({"", "  "}),
          i(3, "// TODO"),
          t({"", "}"}),
        }),
      })
      
      ls.add_snippets("typescript", {
        s("interface", {
          t("interface "),
          i(1, "Name"),
          t(" {"),
          t({"", "  "}),
          i(2, "property: type;"),
          t({"", "}"}),
        }),
      })
    end,
  },

  -- LSP kind icons
  {
    "onsails/lspkind.nvim",
    lazy = true,
    config = function()
      require("lspkind").init({
        mode = "symbol_text",
        preset = "codicons",
        symbol_map = {
          Text = "",
          Method = "",
          Function = "",
          Constructor = "",
          Field = "ﰠ",
          Variable = "",
          Class = "ﴯ",
          Interface = "",
          Module = "",
          Property = "ﰠ",
          Unit = "塞",
          Value = "",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "פּ",
          Event = "",
          Operator = "",
          TypeParameter = "",
        },
      })
    end,
  },
}