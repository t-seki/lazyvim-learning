-- チーム開発用Neovim設定の例
-- このファイルをプロジェクトルートに .nvim.lua として配置

-- ==============================================
-- チーム共通設定
-- ==============================================

-- プロジェクト情報
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
local is_typescript_project = vim.fn.filereadable("tsconfig.json") == 1
local is_python_project = vim.fn.filereadable("requirements.txt") == 1 or vim.fn.filereadable("pyproject.toml") == 1
local is_node_project = vim.fn.filereadable("package.json") == 1
local is_go_project = vim.fn.filereadable("go.mod") == 1

-- チーム共通のエディタ設定
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

-- 行長制限（言語別）
if is_python_project then
  vim.opt_local.colorcolumn = "88"
  vim.opt_local.textwidth = 88
else
  vim.opt_local.colorcolumn = "100"
  vim.opt_local.textwidth = 100
end

-- ==============================================
-- チーム共通キーマップ
-- ==============================================

-- プロジェクト管理
vim.keymap.set("n", "<leader>po", function()
  vim.cmd("edit README.md")
end, { desc = "Open project README" })

vim.keymap.set("n", "<leader>pc", function()
  if is_node_project then
    vim.cmd("edit package.json")
  elseif is_python_project then
    if vim.fn.filereadable("pyproject.toml") == 1 then
      vim.cmd("edit pyproject.toml")
    else
      vim.cmd("edit requirements.txt")
    end
  elseif is_go_project then
    vim.cmd("edit go.mod")
  end
end, { desc = "Open project config" })

-- ==============================================
-- 言語・フレームワーク別設定
-- ==============================================

if is_node_project then
  -- Node.js プロジェクト設定
  vim.keymap.set("n", "<leader>ns", "<cmd>!npm start<cr>", { desc = "npm start" })
  vim.keymap.set("n", "<leader>nd", "<cmd>!npm run dev<cr>", { desc = "npm run dev" })
  vim.keymap.set("n", "<leader>nb", "<cmd>!npm run build<cr>", { desc = "npm run build" })
  vim.keymap.set("n", "<leader>nt", "<cmd>!npm test<cr>", { desc = "npm test" })
  vim.keymap.set("n", "<leader>nl", "<cmd>!npm run lint<cr>", { desc = "npm run lint" })
  vim.keymap.set("n", "<leader>nf", "<cmd>!npm run format<cr>", { desc = "npm run format" })
  
  -- TypeScript固有設定
  if is_typescript_project then
    vim.keymap.set("n", "<leader>tc", "<cmd>!npm run type-check<cr>", { desc = "TypeScript check" })
    
    -- TypeScript用autocmd
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "typescript", "typescriptreact" },
      callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.keymap.set("n", "<leader>ti", "<cmd>TypescriptOrganizeImports<cr>", 
          { buffer = true, desc = "Organize imports" })
        vim.keymap.set("n", "<leader>tr", "<cmd>TypescriptRenameFile<cr>", 
          { buffer = true, desc = "Rename file" })
      end,
    })
  end
end

if is_python_project then
  -- Python プロジェクト設定
  vim.keymap.set("n", "<leader>pr", "<cmd>!python main.py<cr>", { desc = "Run Python main" })
  vim.keymap.set("n", "<leader>pt", "<cmd>!pytest<cr>", { desc = "Run pytest" })
  vim.keymap.set("n", "<leader>pf", "<cmd>!black .<cr>", { desc = "Format with black" })
  vim.keymap.set("n", "<leader>pl", "<cmd>!flake8<cr>", { desc = "Lint with flake8" })
  vim.keymap.set("n", "<leader>pi", "<cmd>!isort .<cr>", { desc = "Sort imports" })
  
  -- Python用autocmd
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
    end,
  })
end

if is_go_project then
  -- Go プロジェクト設定
  vim.keymap.set("n", "<leader>gr", "<cmd>!go run .<cr>", { desc = "go run" })
  vim.keymap.set("n", "<leader>gb", "<cmd>!go build<cr>", { desc = "go build" })
  vim.keymap.set("n", "<leader>gt", "<cmd>!go test<cr>", { desc = "go test" })
  vim.keymap.set("n", "<leader>gf", "<cmd>!go fmt ./...<cr>", { desc = "go fmt" })
  vim.keymap.set("n", "<leader>gm", "<cmd>!go mod tidy<cr>", { desc = "go mod tidy" })
  
  -- Go用autocmd
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
      vim.opt_local.expandtab = false
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
    end,
  })
end

-- ==============================================
-- Git統合設定
-- ==============================================

-- チーム共通のGitキーマップ
vim.keymap.set("n", "<leader>gs", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
vim.keymap.set("n", "<leader>gf", "<cmd>Telescope git_files<cr>", { desc = "Git files" })

-- コミットメッセージテンプレート設定
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 72
    vim.opt_local.colorcolumn = "50,72"
  end,
})

-- ==============================================
-- フォーマッティング設定
-- ==============================================

-- 保存時の自動フォーマット（チーム設定）
local function setup_auto_format()
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.css", "*.scss", "*.html" },
    callback = function()
      if vim.fn.executable("prettier") == 1 then
        vim.cmd("silent !prettier --write " .. vim.fn.expand("%"))
        vim.cmd("edit!")
      end
    end,
  })
  
  if is_python_project then
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.py",
      callback = function()
        if vim.fn.executable("black") == 1 then
          vim.cmd("silent !black " .. vim.fn.expand("%"))
          vim.cmd("edit!")
        end
      end,
    })
  end
  
  if is_go_project then
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        vim.cmd("silent !go fmt " .. vim.fn.expand("%"))
        vim.cmd("edit!")
      end,
    })
  end
end

-- チーム設定でフォーマットを有効化（オプション）
-- setup_auto_format()

-- ==============================================
-- テスト統合
-- ==============================================

-- テストファイルの自動検出と実行
local function run_current_test()
  local current_file = vim.fn.expand("%")
  
  if is_node_project then
    if current_file:match("%.test%.") or current_file:match("%.spec%.") then
      vim.cmd("!npm test " .. vim.fn.shellescape(current_file))
    else
      vim.cmd("!npm test")
    end
  elseif is_python_project then
    if current_file:match("test_") or current_file:match("_test%.py") then
      vim.cmd("!pytest " .. vim.fn.shellescape(current_file))
    else
      vim.cmd("!pytest")
    end
  elseif is_go_project then
    if current_file:match("_test%.go") then
      vim.cmd("!go test " .. vim.fn.expand("%:h"))
    else
      vim.cmd("!go test ./...")
    end
  end
end

vim.keymap.set("n", "<leader>tt", run_current_test, { desc = "Run current test" })

-- ==============================================
-- プロジェクト固有のLSP設定
-- ==============================================

-- プロジェクト固有のLSP設定
if is_typescript_project then
  -- TypeScript LSP設定の調整
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.name == "tsserver" then
        -- プロジェクト固有のLSP設定
        vim.keymap.set("n", "<leader>to", function()
          vim.lsp.buf.execute_command({
            command = "_typescript.organizeImports",
            arguments = { vim.api.nvim_buf_get_name(0) },
          })
        end, { buffer = event.buf, desc = "Organize Imports" })
      end
    end,
  })
end

-- ==============================================
-- デバッグ設定
-- ==============================================

-- プロジェクト固有のデバッグ設定
if is_node_project then
  -- Node.js/JavaScript デバッグ設定
  local dap = require("dap")
  dap.configurations.javascript = {
    {
      type = "node2",
      request = "launch",
      program = "${workspaceFolder}/index.js",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    }
  }
end

-- ==============================================
-- チーム通知
-- ==============================================

-- プロジェクト読み込み完了の通知
vim.defer_fn(function()
  local notification = string.format(
    "チーム設定を読み込みました: %s\nプロジェクトタイプ: %s",
    project_name,
    is_typescript_project and "TypeScript" or
    is_python_project and "Python" or
    is_go_project and "Go" or
    is_node_project and "Node.js" or
    "Unknown"
  )
  
  vim.notify(notification, vim.log.levels.INFO, {
    title = "プロジェクト設定",
    timeout = 3000,
  })
end, 1000)