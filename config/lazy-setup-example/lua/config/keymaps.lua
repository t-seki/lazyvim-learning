-- Key Mappings Configuration
-- ==========================

local keymap = vim.keymap.set

-- Helper function for options
local opts = function(desc)
  return { desc = desc, silent = true, noremap = true }
end

-- Better escape
keymap("i", "jk", "<ESC>", opts("Exit insert mode"))
keymap("i", "kj", "<ESC>", opts("Exit insert mode"))

-- Clear search highlighting
keymap("n", "<Esc>", ":nohlsearch<CR>", opts("Clear search highlighting"))

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts("Move to left window"))
keymap("n", "<C-j>", "<C-w>j", opts("Move to bottom window"))
keymap("n", "<C-k>", "<C-w>k", opts("Move to top window"))
keymap("n", "<C-l>", "<C-w>l", opts("Move to right window"))

-- Window resizing
keymap("n", "<C-Up>", ":resize -2<CR>", opts("Resize window up"))
keymap("n", "<C-Down>", ":resize +2<CR>", opts("Resize window down"))
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts("Resize window left"))
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts("Resize window right"))

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", opts("Next buffer"))
keymap("n", "<S-h>", ":bprevious<CR>", opts("Previous buffer"))
keymap("n", "<leader>bd", ":bdelete<CR>", opts("Delete buffer"))
keymap("n", "<leader>ba", ":bufdo bd<CR>", opts("Delete all buffers"))

-- Tab navigation
keymap("n", "<leader>tn", ":tabnew<CR>", opts("New tab"))
keymap("n", "<leader>tc", ":tabclose<CR>", opts("Close tab"))
keymap("n", "<leader>to", ":tabonly<CR>", opts("Only this tab"))
keymap("n", "<A-l>", ":tabnext<CR>", opts("Next tab"))
keymap("n", "<A-h>", ":tabprevious<CR>", opts("Previous tab"))

-- Better indenting
keymap("v", "<", "<gv", opts("Indent left"))
keymap("v", ">", ">gv", opts("Indent right"))

-- Move text up and down
keymap("n", "<A-j>", ":move .+1<CR>==", opts("Move line down"))
keymap("n", "<A-k>", ":move .-2<CR>==", opts("Move line up"))
keymap("v", "<A-j>", ":move '>+1<CR>gv=gv", opts("Move selection down"))
keymap("v", "<A-k>", ":move '<-2<CR>gv=gv", opts("Move selection up"))

-- Better paste
keymap("v", "p", '"_dP', opts("Paste without overwriting register"))

-- File operations
keymap("n", "<leader>w", ":w<CR>", opts("Save file"))
keymap("n", "<leader>wa", ":wa<CR>", opts("Save all files"))
keymap("n", "<leader>q", ":q<CR>", opts("Quit"))
keymap("n", "<leader>qa", ":qa<CR>", opts("Quit all"))
keymap("n", "<leader>wq", ":wq<CR>", opts("Save and quit"))

-- Split windows
keymap("n", "<leader>sv", ":vsplit<CR>", opts("Split window vertically"))
keymap("n", "<leader>sh", ":split<CR>", opts("Split window horizontally"))
keymap("n", "<leader>se", "<C-w>=", opts("Make splits equal size"))
keymap("n", "<leader>sx", ":close<CR>", opts("Close current split"))

-- Line manipulation
keymap("n", "<leader>o", "o<ESC>", opts("Insert line below"))
keymap("n", "<leader>O", "O<ESC>", opts("Insert line above"))
keymap("n", "Y", "y$", opts("Yank to end of line"))

-- Search and replace
keymap("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", 
       opts("Replace word under cursor"))
keymap("v", "<leader>s", "\"hy:%s/<C-r>h//g<left><left>", opts("Replace selected text"))

-- Quick fix list
keymap("n", "<leader>co", ":copen<CR>", opts("Open quickfix"))
keymap("n", "<leader>cc", ":cclose<CR>", opts("Close quickfix"))
keymap("n", "<leader>cn", ":cnext<CR>", opts("Next quickfix item"))
keymap("n", "<leader>cp", ":cprevious<CR>", opts("Previous quickfix item"))

-- Location list
keymap("n", "<leader>lo", ":lopen<CR>", opts("Open location list"))
keymap("n", "<leader>lc", ":lclose<CR>", opts("Close location list"))
keymap("n", "<leader>ln", ":lnext<CR>", opts("Next location item"))
keymap("n", "<leader>lp", ":lprevious<CR>", opts("Previous location item"))

-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", opts("Move to left window"))
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", opts("Move to bottom window"))
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", opts("Move to top window"))
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", opts("Move to right window"))
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", opts("Exit terminal mode"))

-- Toggle options
keymap("n", "<leader>th", ":set hlsearch!<CR>", opts("Toggle search highlight"))
keymap("n", "<leader>tw", ":set wrap!<CR>", opts("Toggle line wrap"))
keymap("n", "<leader>ts", ":set spell!<CR>", opts("Toggle spell check"))
keymap("n", "<leader>tr", ":set relativenumber!<CR>", opts("Toggle relative numbers"))

-- Plugin-specific keymaps (will be overridden by plugin configs if loaded)

-- File explorer (Neo-tree)
keymap("n", "<leader>e", ":Neotree toggle<CR>", opts("Toggle file explorer"))

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts("Find files"))
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts("Live grep"))
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts("Find buffers"))
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts("Help tags"))
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", opts("Recent files"))
keymap("n", "<leader>fc", ":Telescope colorscheme<CR>", opts("Colorschemes"))

-- LSP (will be overridden by LSP config)
keymap("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
keymap("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
keymap("n", "gr", vim.lsp.buf.references, opts("Go to references"))
keymap("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
keymap("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code actions"))
keymap("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))
keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts("Signature help"))

-- Diagnostic navigation
keymap("n", "[d", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
keymap("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))
keymap("n", "<leader>d", vim.diagnostic.open_float, opts("Open diagnostic float"))
keymap("n", "<leader>dl", vim.diagnostic.setloclist, opts("Diagnostic location list"))

-- Git (will be overridden by git plugins)
keymap("n", "<leader>gs", ":Git<CR>", opts("Git status"))
keymap("n", "<leader>gb", ":Git blame<CR>", opts("Git blame"))
keymap("n", "<leader>gd", ":Gdiffsplit<CR>", opts("Git diff"))

-- Commenting (will be overridden by comment plugin)
keymap("n", "<leader>/", "gcc", opts("Toggle comment"))
keymap("v", "<leader>/", "gc", opts("Toggle comment"))

-- Utility functions
keymap("n", "<leader>z", ":lua vim.wo.foldlevel = vim.wo.foldlevel > 0 and 0 or 99<CR>", 
       opts("Toggle all folds"))

-- Diagnostic keymaps for learning
keymap("n", "<leader>xx", ":Trouble<CR>", opts("Toggle trouble"))
keymap("n", "<leader>xw", ":Trouble workspace_diagnostics<CR>", opts("Workspace diagnostics"))
keymap("n", "<leader>xd", ":Trouble document_diagnostics<CR>", opts("Document diagnostics"))
keymap("n", "<leader>xl", ":Trouble loclist<CR>", opts("Location list"))
keymap("n", "<leader>xq", ":Trouble quickfix<CR>", opts("Quickfix"))

-- Learning helpers
keymap("n", "<leader>h", ":checkhealth<CR>", opts("Check health"))
keymap("n", "<leader>L", ":Lazy<CR>", opts("Open Lazy.nvim"))
keymap("n", "<leader>M", ":Mason<CR>", opts("Open Mason"))

-- Emergency exit (useful when learning)
keymap("n", "<leader>Q", ":qa!<CR>", opts("Force quit all"))