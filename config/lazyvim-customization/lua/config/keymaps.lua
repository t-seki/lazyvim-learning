-- Additional Keymaps for Learning Environment
-- ===========================================

local keymap = vim.keymap.set

-- Learning-specific keymaps
keymap("n", "<leader>ll", function()
  local lessons = {
    "01-lazyvim-basics",
    "02-file-management", 
    "03-coding-features",
    "04-git-workflow"
  }
  
  vim.ui.select(lessons, {
    prompt = "Select lesson to open:",
    format_item = function(item)
      local status = vim.g.lesson_progress[item] and "✓ " or "○ "
      return status .. item
    end,
  }, function(choice)
    if choice then
      vim.cmd("cd lessons/" .. choice)
      vim.cmd("edit README.md")
    end
  end)
end, { desc = "Open lesson browser" })

-- Learning progress
keymap("n", "<leader>lp", function()
  local progress = vim.g.lesson_progress or {}
  local total_lessons = 4
  local completed = 0
  
  for _, v in pairs(progress) do
    if v.completed then
      completed = completed + 1
    end
  end
  
  local percentage = math.floor((completed / total_lessons) * 100)
  vim.notify(
    string.format("Learning Progress: %d/%d lessons completed (%d%%)", completed, total_lessons, percentage),
    vim.log.levels.INFO,
    { title = "Learning Progress" }
  )
end, { desc = "Show learning progress" })

-- Mark lesson as complete
keymap("n", "<leader>lc", function()
  local cwd = vim.fn.getcwd()
  local lesson_name = vim.fn.fnamemodify(cwd, ":t")
  if lesson_name:match("^%d%d%-") then
    mark_lesson_complete(lesson_name)
  else
    vim.notify("Not in a lesson directory", vim.log.levels.WARN)
  end
end, { desc = "Mark current lesson complete" })

-- Show learning tips
keymap("n", "<leader>lt", function()
  local tips = {
    "Use <Space> to see available keymaps",
    "Press 'K' over any word to see documentation",
    "Use gd to go to definition, <C-o> to go back",
    "Try <leader>ff to find files, <leader>fg to search text",
    "Use <leader>e to open Explorer Snacks (root dir)",
    "Press <leader>gg to open LazyGit",
    "Use <leader>ca for Code Action on errors",
    "Try visual mode with 'v' and then 'gc' to comment",
    "Use <leader>/ to search in current buffer",
    "Press <leader>xx to see all diagnostics"
  }
  
  local tip = tips[math.random(#tips)]
  show_learning_tip(tip)
end, { desc = "Show random learning tip" })

-- Learning mode toggles
keymap("n", "<leader>lv", function()
  vim.wo.colorcolumn = vim.wo.colorcolumn == "" and "80,120" or ""
  vim.notify("Color column: " .. (vim.wo.colorcolumn == "" and "OFF" or "ON"))
end, { desc = "Toggle color column" })

keymap("n", "<leader>ln", function()
  vim.wo.number = not vim.wo.number
  vim.notify("Line numbers: " .. (vim.wo.number and "ON" or "OFF"))
end, { desc = "Toggle line numbers" })

keymap("n", "<leader>lr", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.notify("Relative numbers: " .. (vim.wo.relativenumber and "ON" or "OFF"))
end, { desc = "Toggle relative line numbers" })

-- Quick access to help
keymap("n", "<leader>lh", function()
  local help_topics = {
    "lazyvim",
    "telescope.nvim",
    "neo-tree.nvim", 
    "lsp",
    "treesitter",
    "which-key.nvim",
    "vim-modes",
    "vim-motions",
    "folding"
  }
  
  vim.ui.select(help_topics, {
    prompt = "Select help topic:",
  }, function(choice)
    if choice then
      vim.cmd("help " .. choice)
    end
  end)
end, { desc = "Quick help browser" })

-- Keymap cheat sheet
keymap("n", "<leader>lk", function()
  local lines = {
    "=== LazyVim Learning Keymaps ===",
    "",
    "File Management:",
    "  <leader>ff - Find files",
    "  <leader>fg - Find Files (git-files)", 
    "  <leader>/  - Grep (Root Dir)",
    "  <leader>fb - Find buffers",
    "  <leader>e  - Explorer Snacks (root dir)",
    "",
    "Code Navigation:",
    "  gd - Go to definition",
    "  gr - Go to references", 
    "  K  - Show documentation",
    "  <leader>ca - Code Action",
    "",
    "Git:",
    "  <leader>gg - GitUi (Root Dir)",
    "",
    "Learning:",
    "  <leader>ll - Lesson browser",
    "  <leader>lp - Learning progress",
    "  <leader>lt - Random tip",
    "  <leader>lh - Help browser",
    "",
    "Press 'q' to close this window"
  }
  
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  
  local width = 60
  local height = #lines + 2
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    title = " Keymap Cheat Sheet ",
    title_pos = "center"
  })
  
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
end, { desc = "Show keymap cheat sheet" })

-- Emergency help for beginners
keymap("n", "<leader>l?", function()
  local help_text = [[
🆘 EMERGENCY HELP 🆘

Stuck? Here's how to get unstuck:

1. EXIT VIM:
   - Press Escape, then type :q and Enter
   - To force quit: Escape, then :q! and Enter

2. UNDO MISTAKES:
   - Press 'u' to undo
   - Press Ctrl+r to redo

3. GET TO NORMAL MODE:
   - Press Escape (maybe multiple times)

4. SAVE YOUR WORK:
   - Press Escape, then :w and Enter

5. GET HELP:
   - Press <Space> to see available commands
   - Type :help followed by topic name

6. FIND FILES:
   - Press <Space>ff

You're doing great! Keep practicing! 💪
]]
  
  vim.notify(help_text, vim.log.levels.INFO, {
    title = "🆘 Emergency Help",
    timeout = 10000,
  })
end, { desc = "Emergency help for beginners" })