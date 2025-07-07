-- カスタムスニペット管理の例
-- ~/.config/nvim/lua/snippets/custom.lua

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

-- JavaScript/TypeScript用スニペット
ls.add_snippets("javascript", {
  -- 基本的なスニペット
  s("log", {
    t("console.log("), i(1), t(");")
  }),
  
  -- 関数スニペット
  s("func", {
    t("function "), i(1, "name"), t("("), i(2, "params"), t(") {"),
    t({"", "  "}), i(3, "// TODO: Implement"),
    t({"", "}"})
  }),
  
  -- アロー関数スニペット
  s("arrow", {
    t("const "), i(1, "name"), t(" = ("), i(2, "params"), t(") => {"),
    t({"", "  "}), i(3, "// TODO: Implement"),
    t({"", "}"})
  }),
  
  -- API呼び出しスニペット
  s("api", {
    t("try {"),
    t({"", "  const response = await fetch('"}), i(1, "url"), t("', {"),
    t({"", "    method: '"}), c(2, {t("GET"), t("POST"), t("PUT"), t("DELETE")}), t("',"),
    t({"", "    headers: {", "      'Content-Type': 'application/json',", "    },"}),
    i(3, ""),
    t({"", "  });", "  const data = await response.json();", "  "}), i(4, "// Handle success"),
    t({"", "} catch (error) {", "  console.error('API Error:', error);", "  "}), i(5, "// Handle error"),
    t({"", "}"})
  }),
  
  -- React Hookスニペット
  s("usestate", {
    t("const ["), i(1, "state"), t(", set"), 
    f(function(args) 
      local state = args[1][1]
      if state and #state > 0 then
        return state:sub(1,1):upper() .. state:sub(2)
      else
        return "State"
      end
    end, {1}), 
    t("] = useState("), i(2, "initialValue"), t(");")
  }),
  
  -- useEffectスニペット
  s("useeffect", {
    t("useEffect(() => {"),
    t({"", "  "}), i(1, "// Effect logic"),
    t({"", "}, ["}), i(2, "dependencies"), t("]);")
  }),
})

-- TypeScript用追加スニペット
ls.add_snippets("typescript", {
  -- インターフェース
  s("interface", {
    t("interface "), i(1, "InterfaceName"), t(" {"),
    t({"", "  "}), i(2, "property: type;"),
    t({"", "}"})
  }),
  
  -- 型定義
  s("type", {
    t("type "), i(1, "TypeName"), t(" = "), i(2, "TypeDefinition"), t(";")
  }),
  
  -- Reactコンポーネント
  s("rfc", {
    t("import React from 'react';"),
    t({"", "", "interface "}), i(1, "Component"), t("Props {"),
    t({"", "  "}), i(2, "// Define props here"),
    t({"", "}", "", "const "}), 
    f(function(args) return args[1][1] end, {1}), 
    t(": React.FC<"), 
    f(function(args) return args[1][1] end, {1}), 
    t("Props> = ("), i(3, "props"), t(") => {"),
    t({"", "  return (", "    <div>"}),
    t({"", "      "}), i(4, "{/* Component content */}"),
    t({"", "    </div>", "  );", "};", "", "export default "}), 
    f(function(args) return args[1][1] end, {1}), t(";")
  }),
})

-- Python用スニペット
ls.add_snippets("python", {
  -- 基本的なクラス
  s("class", {
    t("class "), i(1, "ClassName"), t(":"),
    t({"", '    """'}), i(2, "Class description"), t({'"""', ""}),
    t({"", "    def __init__(self"}), i(3, ""), t("):"),
    t({"", '        """Initialize the class."""'}),
    t({"", "        "}), i(4, "pass"),
  }),
  
  -- 関数定義
  s("def", {
    t("def "), i(1, "function_name"), t("("), i(2, "args"), t("):"),
    t({"", '    """'}), i(3, "Function description"), t({'"""'}),
    t({"", "    "}), i(4, "pass"),
  }),
  
  -- メイン関数
  s("main", {
    t("def main():"),
    t({"", '    """Main function."""'}),
    t({"", "    "}), i(1, "pass"),
    t({"", "", "", "if __name__ == '__main__':", "    main()"})
  }),
  
  -- try-except
  s("try", {
    t("try:"),
    t({"", "    "}), i(1, "# Try block"),
    t({"", "except "}), i(2, "Exception"), t(" as e:"),
    t({"", "    "}), i(3, "# Exception handling"),
  }),
})

-- Lua用スニペット
ls.add_snippets("lua", {
  -- 基本的な関数
  s("func", {
    t("local function "), i(1, "name"), t("("), i(2, "args"), t(")"),
    t({"", "  "}), i(3, "-- Function body"),
    t({"", "end"})
  }),
  
  -- モジュール作成
  s("module", {
    t("local M = {}"),
    t({"", "", "function M."}), i(1, "method_name"), t("("), i(2, "args"), t(")"),
    t({"", "  "}), i(3, "-- Method implementation"),
    t({"", "end", "", "return M"})
  }),
  
  -- Neovim設定用
  s("keymap", {
    t("vim.keymap.set('"), c(1, {t("n"), t("i"), t("v"), t("x")}), t("', '"), i(2, "<key>"), t("', "),
    c(3, {
      {t("'"), i(1, "command"), t("'")},
      {t("function() "), i(1, "-- code"), t(" end")}
    }),
    t(", { desc = '"), i(4, "description"), t("' })")
  }),
})

-- 動的スニペット例
ls.add_snippets("all", {
  -- 現在の日付
  s("date", {
    f(function() return os.date("%Y-%m-%d") end, {})
  }),
  
  -- 現在の日時
  s("datetime", {
    f(function() return os.date("%Y-%m-%d %H:%M:%S") end, {})
  }),
  
  -- ファイル名（拡張子なし）
  s("filename", {
    f(function() return vim.fn.expand("%:t:r") end, {})
  }),
  
  -- TODOコメント
  s("todo", {
    t("// TODO: "), i(1, "Description"), t(" - "), 
    f(function() return os.date("%Y-%m-%d") end, {}), t(" - "), 
    i(2, "Your Name")
  }),
  
  -- FIXME コメント
  s("fixme", {
    t("// FIXME: "), i(1, "Description"), t(" - "), 
    f(function() return os.date("%Y-%m-%d") end, {}), t(" - "), 
    i(2, "Your Name")
  }),
})

-- プロジェクト固有スニペット（条件付き）
local function is_node_project()
  return vim.fn.filereadable("package.json") == 1
end

local function is_python_project()
  return vim.fn.filereadable("requirements.txt") == 1 or 
         vim.fn.filereadable("pyproject.toml") == 1
end

if is_node_project() then
  ls.add_snippets("javascript", {
    s("npm", {
      t("npm run "), i(1, "script")
    }),
    
    s("test", {
      t("describe('"), i(1, "Test Suite"), t("', () => {"),
      t({"", "  it('"}), i(2, "should do something"), t("', () => {"),
      t({"", "    "}), i(3, "// Test implementation"),
      t({"", "  });", "});"})
    }),
  })
end

if is_python_project() then
  ls.add_snippets("python", {
    s("test", {
      t("def test_"), i(1, "function_name"), t("():"),
      t({"", '    """Test '}), 
      f(function(args) return args[1][1]:gsub("_", " ") end, {1}), 
      t({'."""'}),
      t({"", "    "}), i(2, "assert True"),
    }),
  })
end