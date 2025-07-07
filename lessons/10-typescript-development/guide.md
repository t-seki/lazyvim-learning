# TypeScript開発 - 詳細ガイド

## 1. TypeScript LSP完全活用

### TypeScript LSP（tsserver）の設定最適化

LazyVimでは**typescript-language-server**が自動で設定されますが、TypeScript開発に特化した設定を追加します。

#### 基本的なLSP設定

```lua
-- ~/.config/nvim/lua/plugins/typescript.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      },
    },
  },
}
```

### TypeScript専用キーマップ

```lua
-- TypeScript特化キーマップ
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function()
    local map = vim.keymap.set
    local opts = { buffer = true }
    
    -- TypeScript固有操作
    map("n", "<leader>to", "<cmd>TypescriptOrganizeImports<cr>", 
      vim.tbl_extend("force", opts, { desc = "Organize Imports" }))
    map("n", "<leader>tr", "<cmd>TypescriptRenameFile<cr>", 
      vim.tbl_extend("force", opts, { desc = "Rename File" }))
    map("n", "<leader>ti", "<cmd>TypescriptAddMissingImports<cr>", 
      vim.tbl_extend("force", opts, { desc = "Add Missing Imports" }))
    map("n", "<leader>tf", "<cmd>TypescriptFixAll<cr>", 
      vim.tbl_extend("force", opts, { desc = "Fix All" }))
    
    -- 型情報・ナビゲーション
    map("n", "<leader>td", "<cmd>TypescriptGoToSourceDefinition<cr>", 
      vim.tbl_extend("force", opts, { desc = "Go to Source Definition" }))
    map("n", "<leader>tt", function()
      vim.lsp.buf.hover()
    end, vim.tbl_extend("force", opts, { desc = "Type Info" }))
    
    -- リファクタリング
    map("n", "<leader>tre", "<cmd>TypescriptRemoveUnused<cr>", 
      vim.tbl_extend("force", opts, { desc = "Remove Unused" }))
    map("v", "<leader>tre", "<cmd>TypescriptRemoveUnused<cr>", 
      vim.tbl_extend("force", opts, { desc = "Remove Unused" }))
  end,
})
```

### 高度なTypeScript機能

#### 1. 自動インポート設定

```lua
-- 自動インポートの最適化
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
    -- インポートの整理を自動実行
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" } },
      apply = true,
    })
  end,
})
```

#### 2. 型エラーの効率的な修正

```lua
-- 型エラー修正のヘルパー関数
local function fix_typescript_errors()
  vim.lsp.buf.code_action({
    context = { only = { "quickfix" } },
    apply = true,
  })
end

vim.keymap.set("n", "<leader>tq", fix_typescript_errors, { desc = "Quick Fix TS Errors" })
```

#### 3. プロジェクト全体の型チェック

```lua
-- TypeScript プロジェクト操作
vim.keymap.set("n", "<leader>tpr", function()
  vim.cmd("!npm run type-check")
end, { desc = "Run TypeScript Check" })

vim.keymap.set("n", "<leader>tpb", function()
  vim.cmd("!npm run build")
end, { desc = "Build TypeScript Project" })
```

## 2. React/Next.js開発環境

### React開発に特化したプラグイン設定

```lua
-- ~/.config/nvim/lua/plugins/react.lua
return {
  -- React用のTreesitter拡張
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "typescript", "tsx", "javascript", "jsx",
        "css", "scss", "html", "json"
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      autotag = { enable = true }, -- 自動タグ補完
    },
  },
  
  -- JSX/TSX自動タグ
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
  
  -- React用スニペット
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },
  
  -- コンポーネントファイル作成
  {
    "gennaro-tedesco/nvim-jqx",
    event = "VeryLazy",
  },
}
```

### React開発ワークフロー

#### コンポーネント作成の自動化

```lua
-- React コンポーネント作成関数
local function create_react_component()
  local component_name = vim.fn.input("Component name: ")
  if component_name == "" then return end
  
  -- ディレクトリ作成
  local component_dir = "src/components/" .. component_name
  vim.fn.mkdir(component_dir, "p")
  
  -- コンポーネントファイル作成
  local component_file = component_dir .. "/" .. component_name .. ".tsx"
  local index_file = component_dir .. "/index.ts"
  local styles_file = component_dir .. "/" .. component_name .. ".module.css"
  local test_file = component_dir .. "/" .. component_name .. ".test.tsx"
  
  -- テンプレート内容
  local component_template = string.format([[
import React from 'react';
import styles from './%s.module.css';

interface %sProps {
  // Define props here
}

const %s: React.FC<%sProps> = (props) => {
  return (
    <div className={styles.container}>
      <h1>%s Component</h1>
    </div>
  );
};

export default %s;
]], component_name, component_name, component_name, component_name, component_name, component_name)
  
  local index_template = string.format("export { default } from './%s';", component_name)
  
  local styles_template = [[
.container {
  /* Add styles here */
}
]]
  
  local test_template = string.format([[
import React from 'react';
import { render, screen } from '@testing-library/react';
import %s from './%s';

describe('%s', () => {
  test('renders correctly', () => {
    render(<%s />);
    expect(screen.getByText('%s Component')).toBeInTheDocument();
  });
});
]], component_name, component_name, component_name, component_name, component_name)
  
  -- ファイル書き込み
  vim.fn.writefile(vim.split(component_template, "\n"), component_file)
  vim.fn.writefile(vim.split(index_template, "\n"), index_file)
  vim.fn.writefile(vim.split(styles_template, "\n"), styles_file)
  vim.fn.writefile(vim.split(test_template, "\n"), test_file)
  
  -- コンポーネントファイルを開く
  vim.cmd("edit " .. component_file)
  print("Created React component: " .. component_name)
end

vim.keymap.set("n", "<leader>rc", create_react_component, { desc = "Create React Component" })
```

#### Next.js特化機能

```lua
-- Next.js ページ作成
local function create_next_page()
  local page_name = vim.fn.input("Page name: ")
  if page_name == "" then return end
  
  local page_file = "src/pages/" .. page_name .. ".tsx"
  local page_template = string.format([[
import { NextPage } from 'next';
import Head from 'next/head';

const %sPage: NextPage = () => {
  return (
    <>
      <Head>
        <title>%s | Your App</title>
        <meta name="description" content="%s page" />
      </Head>
      <main>
        <h1>%s Page</h1>
      </main>
    </>
  );
};

export default %sPage;
]], page_name, page_name, page_name, page_name, page_name)
  
  vim.fn.mkdir("src/pages", "p")
  vim.fn.writefile(vim.split(page_template, "\n"), page_file)
  vim.cmd("edit " .. page_file)
  print("Created Next.js page: " .. page_name)
end

vim.keymap.set("n", "<leader>np", create_next_page, { desc = "Create Next.js Page" })

-- API Route作成
local function create_api_route()
  local route_name = vim.fn.input("API route name: ")
  if route_name == "" then return end
  
  local api_file = "src/pages/api/" .. route_name .. ".ts"
  local api_template = string.format([[
import { NextApiRequest, NextApiResponse } from 'next';

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  try {
    switch (req.method) {
      case 'GET':
        // GET logic
        res.status(200).json({ message: 'GET %s' });
        break;
      case 'POST':
        // POST logic
        res.status(200).json({ message: 'POST %s' });
        break;
      default:
        res.setHeader('Allow', ['GET', 'POST']);
        res.status(405).end(`Method ${req.method} Not Allowed`);
    }
  } catch (error) {
    console.error('API Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}
]], route_name, route_name)
  
  vim.fn.mkdir("src/pages/api", "p")
  vim.fn.writefile(vim.split(api_template, "\n"), api_file)
  vim.cmd("edit " .. api_file)
  print("Created API route: " .. route_name)
end

vim.keymap.set("n", "<leader>na", create_api_route, { desc = "Create API Route" })
```

### JSX/TSX最適化

#### JSX要素の効率的な編集

```lua
-- JSX用の特殊キーマップ
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescriptreact", "javascriptreact" },
  callback = function()
    local map = vim.keymap.set
    local opts = { buffer = true }
    
    -- JSX要素の囲み変更
    map("n", "<leader>jw", function()
      local element = vim.fn.input("Wrap with element: ")
      if element ~= "" then
        vim.cmd("normal! vat")
        vim.cmd("normal! c<" .. element .. "></" .. element .. ">")
        vim.cmd("normal! P")
      end
    end, vim.tbl_extend("force", opts, { desc = "Wrap with JSX element" }))
    
    -- className属性の追加
    map("n", "<leader>jc", function()
      local class_name = vim.fn.input("Class name: ")
      if class_name ~= "" then
        vim.cmd("normal! f>")
        vim.cmd("normal! i className=\"" .. class_name .. "\"")
      end
    end, vim.tbl_extend("force", opts, { desc = "Add className" }))
  end,
})
```

## 3. Node.js API開発

### Express/Fastify開発環境

#### Express API開発設定

```lua
-- Express API プロジェクト設定
local function setup_express_project()
  -- 基本的なディレクトリ構造作成
  local dirs = {
    "src/controllers",
    "src/models",
    "src/routes",
    "src/middleware",
    "src/services",
    "src/utils",
    "src/types",
    "__tests__"
  }
  
  for _, dir in ipairs(dirs) do
    vim.fn.mkdir(dir, "p")
  end
  
  -- 基本ファイルの作成
  local server_template = [[
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('combined'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Error handling
app.use((err: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
]]
  
  vim.fn.writefile(vim.split(server_template, "\n"), "src/server.ts")
  vim.cmd("edit src/server.ts")
  print("Express project structure created")
end

vim.keymap.set("n", "<leader>ep", setup_express_project, { desc = "Setup Express Project" })
```

#### API Controller作成

```lua
-- Express Controller作成関数
local function create_controller()
  local controller_name = vim.fn.input("Controller name: ")
  if controller_name == "" then return end
  
  local controller_file = "src/controllers/" .. controller_name .. "Controller.ts"
  local controller_template = string.format([[
import { Request, Response, NextFunction } from 'express';

export class %sController {
  // GET /%s
  public async getAll(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      // Implementation here
      res.json({ message: 'Get all %s' });
    } catch (error) {
      next(error);
    }
  }
  
  // GET /%s/:id
  public async getById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      // Implementation here
      res.json({ message: `Get %s with id: ${id}` });
    } catch (error) {
      next(error);
    }
  }
  
  // POST /%s
  public async create(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const data = req.body;
      // Implementation here
      res.status(201).json({ message: 'Created %s', data });
    } catch (error) {
      next(error);
    }
  }
  
  // PUT /%s/:id
  public async update(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      const data = req.body;
      // Implementation here
      res.json({ message: `Updated %s with id: ${id}`, data });
    } catch (error) {
      next(error);
    }
  }
  
  // DELETE /%s/:id
  public async delete(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      // Implementation here
      res.json({ message: `Deleted %s with id: ${id}` });
    } catch (error) {
      next(error);
    }
  }
}

export const %sController = new %sController();
]], controller_name, string.lower(controller_name), string.lower(controller_name), 
    string.lower(controller_name), string.lower(controller_name), string.lower(controller_name), 
    string.lower(controller_name), string.lower(controller_name), string.lower(controller_name), 
    string.lower(controller_name), string.lower(controller_name), string.lower(controller_name), 
    string.lower(controller_name), controller_name, controller_name)
  
  vim.fn.writefile(vim.split(controller_template, "\n"), controller_file)
  vim.cmd("edit " .. controller_file)
  print("Created controller: " .. controller_name)
end

vim.keymap.set("n", "<leader>ec", create_controller, { desc = "Create Express Controller" })
```

### データベース統合（Prisma）

#### Prismaスキーマの管理

```lua
-- Prisma操作の統合
vim.api.nvim_create_autocmd("FileType", {
  pattern = "prisma",
  callback = function()
    local map = vim.keymap.set
    local opts = { buffer = true }
    
    -- Prisma コマンド
    map("n", "<leader>pg", "<cmd>!npx prisma generate<cr>", 
      vim.tbl_extend("force", opts, { desc = "Prisma Generate" }))
    map("n", "<leader>pm", "<cmd>!npx prisma migrate dev<cr>", 
      vim.tbl_extend("force", opts, { desc = "Prisma Migrate" }))
    map("n", "<leader>ps", "<cmd>!npx prisma studio<cr>", 
      vim.tbl_extend("force", opts, { desc = "Prisma Studio" }))
    map("n", "<leader>pr", "<cmd>!npx prisma db push<cr>", 
      vim.tbl_extend("force", opts, { desc = "Prisma DB Push" }))
  end,
})
```

## 4. テスト・デバッグ統合

### Jest/Vitest統合

```lua
-- テスト統合設定
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          jestCommand = "npm test --",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        },
        ["neotest-vitest"] = {},
      },
    },
  },
}
```

#### テスト実行キーマップ

```lua
-- テスト実行の効率化
vim.keymap.set("n", "<leader>tn", function()
  require("neotest").run.run()
end, { desc = "Run Nearest Test" })

vim.keymap.set("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run File Tests" })

vim.keymap.set("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Toggle Test Summary" })

vim.keymap.set("n", "<leader>to", function()
  require("neotest").output.open({ enter = true })
end, { desc = "Show Test Output" })
```

### React Testing Library統合

```lua
-- React テスト作成
local function create_react_test()
  local component_name = vim.fn.input("Component name to test: ")
  if component_name == "" then return end
  
  local test_file = "src/components/" .. component_name .. "/" .. component_name .. ".test.tsx"
  local test_template = string.format([[
import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import %s from './%s';

// Mock any dependencies if needed
jest.mock('../../hooks/useCustomHook', () => ({
  useCustomHook: () => ({ data: null, loading: false, error: null }),
}));

describe('%s', () => {
  const defaultProps = {
    // Add default props here
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('renders without crashing', () => {
    render(<%s {...defaultProps} />);
    expect(screen.getByRole('heading')).toBeInTheDocument();
  });

  test('handles user interactions', async () => {
    const user = userEvent.setup();
    render(<%s {...defaultProps} />);
    
    // Test user interactions
    // const button = screen.getByRole('button');
    // await user.click(button);
    // expect(something).toHaveBeenCalled();
  });

  test('displays correct content based on props', () => {
    const customProps = {
      ...defaultProps,
      // Override props for testing
    };
    
    render(<%s {...customProps} />);
    // Add assertions here
  });

  test('handles loading and error states', async () => {
    // Test loading state
    // Test error state
    // Test success state
  });
});
]], component_name, component_name, component_name, component_name, component_name, component_name)
  
  vim.fn.writefile(vim.split(test_template, "\n"), test_file)
  vim.cmd("edit " .. test_file)
  print("Created test for: " .. component_name)
end

vim.keymap.set("n", "<leader>rt", create_react_test, { desc = "Create React Test" })
```

### Node.js API テスト

```lua
-- API テスト作成
local function create_api_test()
  local endpoint_name = vim.fn.input("API endpoint to test: ")
  if endpoint_name == "" then return end
  
  local test_file = "__tests__/" .. endpoint_name .. ".test.ts"
  local test_template = string.format([[
import request from 'supertest';
import app from '../src/app';

describe('%s API', () => {
  beforeEach(() => {
    // Setup test database or mocks
  });

  afterEach(() => {
    // Cleanup
  });

  describe('GET /%s', () => {
    test('should return all %s', async () => {
      const response = await request(app)
        .get('/%s')
        .expect(200);
      
      expect(response.body).toHaveProperty('data');
      expect(Array.isArray(response.body.data)).toBe(true);
    });
  });

  describe('POST /%s', () => {
    test('should create new %s', async () => {
      const newData = {
        // Add test data
      };
      
      const response = await request(app)
        .post('/%s')
        .send(newData)
        .expect(201);
      
      expect(response.body).toHaveProperty('id');
    });

    test('should validate required fields', async () => {
      const invalidData = {};
      
      const response = await request(app)
        .post('/%s')
        .send(invalidData)
        .expect(400);
      
      expect(response.body).toHaveProperty('error');
    });
  });

  describe('GET /%s/:id', () => {
    test('should return specific %s', async () => {
      const id = 1; // Or use a test ID
      
      const response = await request(app)
        .get(`/%s/${id}`)
        .expect(200);
      
      expect(response.body).toHaveProperty('id', id);
    });

    test('should return 404 for non-existent %s', async () => {
      const nonExistentId = 999999;
      
      await request(app)
        .get(`/%s/${nonExistentId}`)
        .expect(404);
    });
  });
});
]], endpoint_name, endpoint_name, endpoint_name, endpoint_name, endpoint_name, 
    endpoint_name, endpoint_name, endpoint_name, endpoint_name, endpoint_name, 
    endpoint_name, endpoint_name, endpoint_name)
  
  vim.fn.writefile(vim.split(test_template, "\n"), test_file)
  vim.cmd("edit " .. test_file)
  print("Created API test for: " .. endpoint_name)
end

vim.keymap.set("n", "<leader>at", create_api_test, { desc = "Create API Test" })
```

## 5. 実践プロジェクト統合

### フルスタックプロジェクト構成

```lua
-- フルスタック開発環境のセットアップ
local function setup_fullstack_project()
  local project_name = vim.fn.input("Project name: ")
  if project_name == "" then return end
  
  -- ディレクトリ構造
  local dirs = {
    project_name .. "/frontend/src/components",
    project_name .. "/frontend/src/pages", 
    project_name .. "/frontend/src/hooks",
    project_name .. "/frontend/src/utils",
    project_name .. "/frontend/src/types",
    project_name .. "/backend/src/controllers",
    project_name .. "/backend/src/models",
    project_name .. "/backend/src/routes",
    project_name .. "/backend/src/middleware",
    project_name .. "/backend/src/services",
    project_name .. "/shared/types",
    project_name .. "/docs"
  }
  
  for _, dir in ipairs(dirs) do
    vim.fn.mkdir(dir, "p")
  end
  
  -- ルートレベルの設定ファイル
  local root_package_json = {
    name = project_name,
    version = "1.0.0",
    scripts = {
      ["dev"] = "concurrently \"npm run dev:frontend\" \"npm run dev:backend\"",
      ["dev:frontend"] = "cd frontend && npm run dev",
      ["dev:backend"] = "cd backend && npm run dev",
      ["build"] = "npm run build:frontend && npm run build:backend",
      ["build:frontend"] = "cd frontend && npm run build",
      ["build:backend"] = "cd backend && npm run build",
      ["test"] = "npm run test:frontend && npm run test:backend",
      ["test:frontend"] = "cd frontend && npm test",
      ["test:backend"] = "cd backend && npm test"
    },
    devDependencies = {
      concurrently = "^7.6.0"
    }
  }
  
  vim.fn.writefile(
    vim.split(vim.fn.json_encode(root_package_json), "\n"), 
    project_name .. "/package.json"
  )
  
  -- README作成
  local readme_content = string.format([[
# %s

Full-stack TypeScript application built with React/Next.js and Node.js.

## Project Structure

```
%s/
├── frontend/          # React/Next.js frontend
├── backend/           # Node.js API backend  
├── shared/            # Shared types and utilities
└── docs/              # Documentation
```

## Getting Started

1. Install dependencies:
```bash
npm install
cd frontend && npm install
cd ../backend && npm install
```

2. Start development servers:
```bash
npm run dev
```

## Scripts

- `npm run dev` - Start both frontend and backend in development mode
- `npm run build` - Build both applications
- `npm run test` - Run all tests
]], project_name, project_name)
  
  vim.fn.writefile(
    vim.split(readme_content, "\n"),
    project_name .. "/README.md"
  )
  
  -- プロジェクト固有の Neovim 設定
  local nvim_config = string.format([[
-- Project-specific configuration for %s

-- TypeScript プロジェクト設定
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- プロジェクト固有キーマップ
vim.keymap.set("n", "<leader>pf", "<cmd>cd frontend<cr>", { desc = "Switch to Frontend" })
vim.keymap.set("n", "<leader>pb", "<cmd>cd backend<cr>", { desc = "Switch to Backend" })
vim.keymap.set("n", "<leader>pr", "<cmd>cd %s<cr>", { desc = "Return to Root" })

-- 開発サーバー操作
vim.keymap.set("n", "<leader>ds", "<cmd>!npm run dev<cr>", { desc = "Start Dev Servers" })
vim.keymap.set("n", "<leader>df", "<cmd>!cd frontend && npm run dev<cr>", { desc = "Start Frontend" })
vim.keymap.set("n", "<leader>db", "<cmd>!cd backend && npm run dev<cr>", { desc = "Start Backend" })

-- ビルド・テスト
vim.keymap.set("n", "<leader>bt", "<cmd>!npm run build<cr>", { desc = "Build All" })
vim.keymap.set("n", "<leader>tt", "<cmd>!npm test<cr>", { desc = "Test All" })

print("Loaded configuration for %s project")
]], project_name, project_name, project_name)
  
  vim.fn.writefile(
    vim.split(nvim_config, "\n"),
    project_name .. "/.nvim.lua"
  )
  
  vim.cmd("cd " .. project_name)
  vim.cmd("edit README.md")
  print("Created fullstack project: " .. project_name)
end

vim.keymap.set("n", "<leader>fp", setup_fullstack_project, { desc = "Setup Fullstack Project" })
```

### パフォーマンス最適化・プロファイリング

```lua
-- TypeScript パフォーマンス監視
local function profile_typescript()
  vim.cmd("!npx tsc --generateTrace trace")
  print("TypeScript compilation trace generated in trace/")
end

vim.keymap.set("n", "<leader>tpt", profile_typescript, { desc = "Profile TypeScript" })

-- Bundle サイズ分析
vim.keymap.set("n", "<leader>ba", function()
  vim.cmd("!npx webpack-bundle-analyzer build/static/js/*.js")
end, { desc = "Analyze Bundle" })

-- TypeScript メモリ使用量チェック
vim.keymap.set("n", "<leader>tm", function()
  vim.cmd("!npx tsc --extendedDiagnostics")
end, { desc = "TS Memory Diagnostics" })
```

## まとめ

このTypeScript開発環境により以下が実現できます：

### 🚀 開発効率の最大化
- **LSP完全活用**: 型安全性・自動補完・リファクタリング
- **自動化ワークフロー**: コンポーネント生成・テスト作成・ビルド
- **統合デバッグ**: フロントエンド・バックエンド統合デバッグ環境

### 🏗️ スケーラブルなアーキテクチャ
- **モジュラー設計**: 再利用可能なコンポーネント・関数
- **型安全性**: TypeScriptによる堅牢なコード品質
- **テスト駆動開発**: 包括的なテストカバレッジ

### 🔧 プロフェッショナルな開発体験
- **IDE級の機能**: IntelliSenseライクな開発体験
- **チーム開発対応**: 標準化された設定・ワークフロー
- **継続的品質向上**: 自動化されたコード品質チェック

TypeScript + LazyVimの組み合わせで、モダンなWeb開発の最高の生産性を実現できます。