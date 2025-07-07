-- プロジェクト固有スニペットの例
-- .nvim.lua ファイルにプロジェクトルートに配置

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- プロジェクト情報の取得
local function get_project_name()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

local function get_author_name()
  -- Git設定から取得、なければデフォルト
  local git_user = vim.fn.system("git config user.name 2>/dev/null"):gsub("\n", "")
  return git_user ~= "" and git_user or "Developer"
end

-- React/Next.jsプロジェクト用スニペット
ls.add_snippets("typescript", {
  -- Next.js ページコンポーネント
  s("nextpage", {
    t("import { NextPage } from 'next';"),
    t({"", "import Head from 'next/head';", ""}),
    t({"", "interface "}), i(1, "Page"), t("Props {"),
    t({"", "  "}), i(2, "// props"),
    t({"", "}", ""}),
    t("const "), f(function(args) return args[1][1] end, {1}), t(": NextPage<"), 
    f(function(args) return args[1][1] end, {1}), t("Props> = ("), i(3, "props"), t(") => {"),
    t({"", "  return (", "    <>", "      <Head>", "        <title>"}), 
    i(4, "Page Title"), t("</title>"),
    t({"", "      </Head>", "      <main>"}),
    t({"", "        "}), i(5, "{/* Page content */}"),
    t({"", "      </main>", "    </>", "  );", "};", "", "export default "}), 
    f(function(args) return args[1][1] end, {1}), t(";")
  }),
  
  -- API Route
  s("apiroute", {
    t("import { NextApiRequest, NextApiResponse } from 'next';"),
    t({"", "", "export default async function handler(", "  req: NextApiRequest,", "  res: NextApiResponse"}),
    t({"", ") {", "  try {", "    switch (req.method) {", "      case 'GET':"}),
    t({"", "        "}), i(1, "// GET logic"),
    t({"", "        break;", "      case 'POST':"}),
    t({"", "        "}), i(2, "// POST logic"),
    t({"", "        break;", "      default:"}),
    t({"", "        res.setHeader('Allow', ['GET', 'POST']);", "        res.status(405).end(`Method ${req.method} Not Allowed`);"}),
    t({"", "    }", "  } catch (error) {", "    console.error('API Error:', error);"}),
    t({"", "    res.status(500).json({ error: 'Internal Server Error' });", "  }", "}"})
  }),
  
  -- React Hook
  s("customhook", {
    t("import { useState, useEffect } from 'react';"),
    t({"", "", "export const use"}), i(1, "HookName"), t(" = ("), i(2, "params"), t(") => {"),
    t({"", "  const ["}), i(3, "state"), t(", set"), 
    f(function(args) 
      local state = args[1][1]
      return state:sub(1,1):upper() .. state:sub(2)
    end, {3}), t("] = useState("), i(4, "initialValue"), t(");"),
    t({"", "", "  useEffect(() => {"}),
    t({"", "    "}), i(5, "// Effect logic"),
    t({"", "  }, ["}), i(6, "dependencies"), t("]);"),
    t({"", "", "  return {"}),
    t({"", "    "}), f(function(args) return args[1][1] end, {3}), t(","),
    t({"", "    set"}), f(function(args) 
      local state = args[1][1]
      return state:sub(1,1):upper() .. state:sub(2)
    end, {3}), t(","),
    t({"", "    "}), i(7, "// other returns"),
    t({"", "  };", "};"})
  }),
})

-- Express.js API用スニペット
ls.add_snippets("javascript", {
  -- Express ルート
  s("route", {
    t("router."), i(1, "get"), t("('"), i(2, "/path"), t("', async (req, res) => {"),
    t({"", "  try {"}),
    t({"", "    "}), i(3, "// Route logic"),
    t({"", "    res.json({ success: true, data: null });"}),
    t({"", "  } catch (error) {"}),
    t({"", "    console.error('Route Error:', error);"}),
    t({"", "    res.status(500).json({ error: error.message });"}),
    t({"", "  }"}),
    t({"", "});"})
  }),
  
  -- ミドルウェア
  s("middleware", {
    t("const "), i(1, "middlewareName"), t(" = (req, res, next) => {"),
    t({"", "  try {"}),
    t({"", "    "}), i(2, "// Middleware logic"),
    t({"", "    next();"}),
    t({"", "  } catch (error) {"}),
    t({"", "    res.status(500).json({ error: error.message });"}),
    t({"", "  }"}),
    t({"", "};", "", "module.exports = "}), f(function(args) return args[1][1] end, {1}), t(";")
  }),
})

-- Python Django/FastAPI用スニペット
ls.add_snippets("python", {
  -- Django View
  s("djangoview", {
    t("from django.shortcuts import render"),
    t({"", "from django.http import JsonResponse", "from django.views.decorators.csrf import csrf_exempt", ""}),
    t({"", "@csrf_exempt", "def "}), i(1, "view_name"), t("(request):"),
    t({"", '    """'}), i(2, "View description"), t({'"""'}),
    t({"", "    try:"}),
    t({"", "        if request.method == 'GET':"}),
    t({"", "            "}), i(3, "# GET logic"),
    t({"", "        elif request.method == 'POST':"}),
    t({"", "            "}), i(4, "# POST logic"),
    t({"", "        ", "        return JsonResponse({'success': True, 'data': None})"}),
    t({"", "    except Exception as e:"}),
    t({"", "        return JsonResponse({'error': str(e)}, status=500)"})
  }),
  
  -- FastAPI エンドポイント
  s("fastapi", {
    t("from fastapi import APIRouter, HTTPException"),
    t({"", "from typing import Dict, Any", ""}),
    t({"", "router = APIRouter()", ""}),
    t({"", "@router."}), i(1, "get"), t("('"), i(2, "/endpoint"), t("')"),
    t({"", "async def "}), i(3, "endpoint_name"), t("("), i(4, ""), t("):"),
    t({"", '    """'}), i(5, "Endpoint description"), t({'"""'}),
    t({"", "    try:"}),
    t({"", "        "}), i(6, "# Endpoint logic"),
    t({"", "        return {'success': True, 'data': None}"}),
    t({"", "    except Exception as e:"}),
    t({"", "        raise HTTPException(status_code=500, detail=str(e))"})
  }),
})

-- ドキュメンテーション用スニペット
ls.add_snippets("markdown", {
  -- プロジェクト README
  s("readme", {
    t("# "), f(get_project_name, {}), t({"", ""}),
    t({"", "> "}), i(1, "Project description"), t({"", ""}),
    t({"", "## Installation", "", "```bash"}),
    t({"", i(2, "npm install"), t({"```", ""}),
    t({"", "## Usage", "", "```bash"}),
    t({"", "}), i(3, "npm start"), t({"```", ""}),
    t({"", "## Contributing", ""}),
    t({"", "1. Fork the repository", "2. Create your feature branch", "3. Commit your changes", "4. Push to the branch", "5. Create a Pull Request"}),
    t({"", "", "## License", ""}),
    t({"", "}), i(4, "MIT"), t({"", "", "## Author", ""}),
    t({"", "}), f(get_author_name, {}), t({"", ""})
  }),
  
  -- API ドキュメント
  s("apidoc", {
    t("## API Endpoint: "), i(1, "Endpoint Name"), t({"", ""}),
    t({"", "**URL:** `"}), i(2, "METHOD"), t(" "), i(3, "/api/endpoint"), t({"`", ""}),
    t({"", "**Description:** "}), i(4, "Endpoint description"), t({"", ""}),
    t({"", "### Request", ""}),
    t({"", "```json", "{"}),
    t({"", "  "}), i(5, '"param": "value"'),
    t({"", "}", "```", ""}),
    t({"", "### Response", ""}),
    t({"", "```json", "{"}),
    t({"", '  "success": true,', '  "data": '}), i(6, "null"),
    t({"", "}", "```"})
  }),
})

-- プロジェクトタスク用スニペット
ls.add_snippets("all", {
  -- プロジェクト特有のTODO
  s("projecttodo", {
    t("// TODO ["), f(get_project_name, {}), t("]: "), i(1, "Task description"),
    t(" - "), f(function() return os.date("%Y-%m-%d") end, {}),
    t(" - "), f(get_author_name, {})
  }),
  
  -- バグレポート
  s("bug", {
    t("// BUG ["), f(get_project_name, {}), t("]: "), i(1, "Bug description"),
    t({"", "// Reproduction: "}), i(2, "Steps to reproduce"),
    t({"", "// Expected: "}), i(3, "Expected behavior"),
    t({"", "// Actual: "}), i(4, "Actual behavior"),
    t({"", "// Reporter: "}), f(get_author_name, {}), t(" - "), f(function() return os.date("%Y-%m-%d") end, {})
  }),
})

-- 設定ファイル用スニペット
ls.add_snippets("json", {
  -- package.json スクリプト
  s("script", {
    t('"'), i(1, "script-name"), t('": "'), i(2, "command"), t('"')
  }),
  
  -- 依存関係
  s("dep", {
    t('"'), i(1, "package-name"), t('": "'), i(2, "^1.0.0"), t('"')
  }),
})

-- テスト用スニペット
ls.add_snippets("javascript", {
  -- Jest テスト
  s("jest", {
    t("describe('"), i(1, "Component/Function"), t("', () => {"),
    t({"", "  beforeEach(() => {"}),
    t({"", "    "}), i(2, "// Setup"),
    t({"", "  });", ""}),
    t({"", "  it('"}), i(3, "should behave correctly"), t("', () => {"),
    t({"", "    // Arrange"}),
    t({"", "    "}), i(4, "const input = {};"),
    t({"", "    // Act"}),
    t({"", "    "}), i(5, "const result = functionToTest(input);"),
    t({"", "    // Assert"}),
    t({"", "    "}), i(6, "expect(result).toBe(expected);"),
    t({"", "  });", "});"})
  }),
})

print("Project-specific snippets loaded for: " .. get_project_name())