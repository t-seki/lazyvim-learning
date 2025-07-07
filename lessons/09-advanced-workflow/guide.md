# 高度なワークフロー - 詳細ガイド

## 1. マルチカーソル・一括編集

### vim-visual-multiの基本操作

LazyVimには**vim-visual-multi**が統合されており、強力なマルチカーソル編集が可能です。

#### 基本的なマルチカーソル操作

```vim
" 基本選択
<C-n>          " 現在の単語を選択、次の同じ単語も選択
<C-Up>/<C-Down> " カーソルを上下に追加
<C-s>          " 単語をスキップ
<C-x>          " 選択を解除

" 選択後の操作
c              " 選択されたテキストを変更
d              " 選択されたテキストを削除
y              " 選択されたテキストをヤンク
```

#### 実践例1: 変数名の一括変更

```javascript
// 元のコード
const userName = "Alice";
console.log(userName);
const userAge = 30;
console.log(userName, userAge);

// 操作手順:
// 1. "userName" にカーソルを置く
// 2. <C-n> を押して最初の userName を選択
// 3. <C-n> を押して次の userName も選択
// 4. c で変更モードに入る
// 5. "userInfo" と入力
```

#### 実践例2: 複数行の同時編集

```css
/* 元のコード */
.button { background: red; }
.input { background: blue; }
.label { background: green; }

/* 操作手順: */
/* 1. 最初の行にカーソル */
/* 2. <C-Down> で下の行にもカーソル追加 */
/* 3. f{ で { の位置に移動 */
/* 4. a で挿入モード */
/* 5. 共通のスタイルを追加 */
```

### 正規表現を使った高度な選択

```vim
" 正規表現での選択
:VimVisualMultiSolver /pattern/
" 例: すべてのメールアドレスを選択
:VimVisualMultiSolver /\w\+@\w\+\.\w\+/
```

### 列編集（ブロック選択）

```vim
" ビジュアルブロックモード
<C-v>          " ブロック選択開始
<C-v>I         " ブロックの最初に挿入
<C-v>A         " ブロックの最後に挿入
<C-v>c         " ブロックを変更
```

#### 実践例: コメントの一括追加

```python
# 元のコード
print("line 1")
print("line 2")
print("line 3")

# 操作手順:
# 1. 最初の行の先頭にカーソル
# 2. <C-v> でブロック選択開始
# 3. jj で下2行も選択
# 4. I で行頭に挿入
# 5. "# " と入力してESC
```

## 2. スニペット管理

### LuaSnipによるカスタムスニペット

LazyVimは**LuaSnip**を使用してスニペット管理を行います。

#### 基本的なスニペット定義

```lua
-- ~/.config/nvim/lua/config/snippets.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- 基本的なスニペット
ls.add_snippets("lua", {
  s("fn", {
    t("function "), i(1, "name"), t("("), i(2, "args"), t(")"),
    t({"", "  "}), i(3, "-- body"),
    t({"", "end"})
  }),
})

-- JavaScript用スニペット
ls.add_snippets("javascript", {
  s("func", {
    t("function "), i(1, "name"), t("("), i(2, "params"), t(") {"),
    t({"", "  "}), i(3, "// body"),
    t({"", "}"})
  }),
  
  s("arrow", {
    t("const "), i(1, "name"), t(" = ("), i(2, "params"), t(") => {"),
    t({"", "  "}), i(3, "// body"),
    t({"", "}"})
  }),
})
```

#### 動的スニペット

```lua
-- 日付・時刻を含むスニペット
ls.add_snippets("all", {
  s("date", {
    f(function()
      return os.date("%Y-%m-%d")
    end, {})
  }),
  
  s("datetime", {
    f(function()
      return os.date("%Y-%m-%d %H:%M:%S")
    end, {})
  }),
  
  -- ファイル名を取得
  s("filename", {
    f(function()
      return vim.fn.expand("%:t:r")
    end, {})
  }),
})

-- 条件付きスニペット
ls.add_snippets("python", {
  s("class", {
    t("class "), i(1, "ClassName"), t("("), i(2, "object"), t("):"),
    t({"", "    \"\"\""}), i(3, "Class description"), t({"\"\"\"\","",""}}),
    t("    def __init__(self"), i(4, ", args"), t("):"),
    t({"", "        "}), i(5, "pass"),
  }),
})
```

#### プロジェクト固有スニペット

```lua
-- プロジェクトローカルスニペット
-- .nvim.lua に記載
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- このプロジェクト専用のスニペット
ls.add_snippets("typescript", {
  s("comp", {
    t("import React from 'react';"),
    t({"", "", "interface "}), i(1, "Component"), t("Props {"),
    t({"", "  "}), i(2, "// props"),
    t({"", "}","", "const "}), i(3, "Component"), t(": React.FC<"), f(function(args) return args[1][1] end, {1}), t("Props> = ("), i(4, "props"), t(") => {"),
    t({"", "  return (", "    <div>"}), i(5, "content"), t({"</div>", "  );", "}","", "export default "}), f(function(args) return args[1][1] end, {3}), t(";")
  }),
})
```

### スニペットの管理と共有

#### チーム共有スニペット

```lua
-- ~/.config/nvim/lua/config/team-snippets.lua
-- チーム共通のスニペット定義

local team_snippets = {
  javascript = {
    -- API呼び出しのテンプレート
    api_call = {
      "try {",
      "  const response = await fetch('${1:url}', {",
      "    method: '${2:GET}',",
      "    headers: {",
      "      'Content-Type': 'application/json',",
      "    },",
      "    ${3:body: JSON.stringify(data),}",
      "  });",
      "  const result = await response.json();",
      "  ${4:// handle result}",
      "} catch (error) {",
      "  console.error('API call failed:', error);",
      "  ${5:// handle error}",
      "}"
    },
    
    -- React Hook のテンプレート
    react_hook = {
      "import { useState, useEffect } from 'react';",
      "",
      "export const use${1:HookName} = (${2:params}) => {",
      "  const [${3:state}, set${3/(.*)/${1:/capitalize}/}] = useState(${4:initialValue});",
      "",
      "  useEffect(() => {",
      "    ${5:// effect logic}",
      "  }, [${6:dependencies}]);",
      "",
      "  return {",
      "    ${3:state},",
      "    set${3/(.*)/${1:/capitalize}/},",
      "    ${7:// other returns}",
      "  };",
      "};"
    }
  },
  
  python = {
    -- クラスのテンプレート
    dataclass = {
      "from dataclasses import dataclass",
      "from typing import ${1:Optional}",
      "",
      "@dataclass",
      "class ${2:ClassName}:",
      '    """${3:Class description}"""',
      "    ${4:field}: ${5:type}",
      "",
      "    def ${6:method_name}(self) -> ${7:return_type}:",
      '        """${8:Method description}"""',
      "        ${9:pass}"
    }
  }
}

-- スニペットの自動読み込み
for filetype, snippets in pairs(team_snippets) do
  for name, content in pairs(snippets) do
    ls.add_snippets(filetype, {
      s(name, t(content))
    })
  end
end
```

## 3. Git統合ワークフロー

### LazyGitの高度な活用

#### 基本操作

```vim
<leader>gg     " LazyGitを開く
<leader>gf     " ファイルの履歴を表示
<leader>gc     " コミット
<leader>gp     " プッシュ
<leader>gl     " プル
```

#### LazyGit内での操作

```
# ファイル操作
<space>  # ステージング/アンステージング
a        # 全ファイルをステージング
c        # コミット
P        # プッシュ
p        # プル

# ブランチ操作
n        # 新しいブランチ作成
b        # ブランチ一覧
m        # マージ
r        # リベース

# 高度な操作
s        # スタッシュ
t        # タグ
d        # 差分表示
<enter>  # ファイル内容表示・編集
```

### Gitsignsによるリアルタイム確認

```lua
-- ~/.config/nvim/lua/plugins/gitsigns.lua
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 1000,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      
      -- ナビゲーション
      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true, buffer = bufnr})
      
      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true, buffer = bufnr})
      
      -- アクション
      vim.keymap.set({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>', {buffer = bufnr})
      vim.keymap.set({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', {buffer = bufnr})
      vim.keymap.set('n', '<leader>hS', gs.stage_buffer, {buffer = bufnr})
      vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, {buffer = bufnr})
      vim.keymap.set('n', '<leader>hR', gs.reset_buffer, {buffer = bufnr})
      vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {buffer = bufnr})
      vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, {buffer = bufnr})
      vim.keymap.set('n', '<leader>hd', gs.diffthis, {buffer = bufnr})
    end
  },
}
```

### コンフリクト解決の効率化

```vim
" マージコンフリクト時のキーマップ
nnoremap <leader>gm :Git mergetool<CR>
nnoremap <leader>gd :Gdiff<CR>

" 3-way merge での操作
nnoremap <leader>gh :diffget //2<CR>  " HEAD の変更を取得
nnoremap <leader>gl :diffget //3<CR>  " ローカルの変更を取得
```

## 4. マクロ・自動化

### 複雑な編集パターンのマクロ化

#### 基本的なマクロ操作

```vim
qa           " マクロ記録開始（レジスタ a）
<操作>       " 記録したい操作を実行
q            " 記録終了
@a           " マクロ実行
@@           " 最後のマクロを再実行
10@a         " マクロを10回実行
```

#### 実践例: JSON整形マクロ

```json
// 元のデータ
{"name":"Alice","age":30,"city":"Tokyo"}
{"name":"Bob","age":25,"city":"Osaka"}

// マクロで整形
{
  "name": "Alice",
  "age": 30,
  "city": "Tokyo"
}
```

```vim
" マクロ記録手順:
qa              " マクロ記録開始
0               " 行頭に移動
f{              " { を探す
a<CR>           " { の後で改行
<Tab>"          " インデントして " を入力
f:              " : を探す
a<Space>        " : の後にスペース追加
f,              " , を探す
a<CR><Tab>      " , の後で改行してインデント
... （以下同様の操作）
q               " 記録終了
```

### Lua関数による高度な自動化

```lua
-- ~/.config/nvim/lua/utils/automation.lua
local M = {}

-- 関数のドキュメント自動生成
M.generate_doc = function()
  local line = vim.api.nvim_get_current_line()
  local func_pattern = "function%s+([%w_]+)%s*%(([^)]*)%)"
  local name, params = line:match(func_pattern)
  
  if name then
    local doc_lines = {
      "/**",
      " * " .. name .. " - Description",
    }
    
    -- パラメータの処理
    if params and params ~= "" then
      for param in params:gmatch("([^,]+)") do
        param = param:match("^%s*(.-)%s*$") -- trim
        table.insert(doc_lines, " * @param {type} " .. param .. " - Description")
      end
    end
    
    table.insert(doc_lines, " * @returns {type} Description")
    table.insert(doc_lines, " */")
    
    -- カーソル行の上に挿入
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, doc_lines)
  end
end

-- ファイルテンプレート挿入
M.insert_template = function(template_name)
  local templates = {
    react_component = {
      "import React from 'react';",
      "",
      "interface Props {",
      "  // Define props here",
      "}",
      "",
      "const Component: React.FC<Props> = (props) => {",
      "  return (",
      "    <div>",
      "      {/* Component content */}",
      "    </div>",
      "  );",
      "};",
      "",
      "export default Component;"
    },
    
    python_class = {
      "class ClassName:",
      '    """Class description."""',
      "",
      "    def __init__(self):",
      '        """Initialize the class."""',
      "        pass",
      "",
      "    def method(self):",
      '        """Method description."""',
      "        pass"
    }
  }
  
  local template = templates[template_name]
  if template then
    vim.api.nvim_put(template, "l", true, true)
  end
end

-- キーマップの設定
vim.keymap.set("n", "<leader>ad", M.generate_doc, { desc = "Generate documentation" })
vim.keymap.set("n", "<leader>atr", function() M.insert_template("react_component") end, { desc = "React template" })
vim.keymap.set("n", "<leader>atp", function() M.insert_template("python_class") end, { desc = "Python class template" })

return M
```

## 5. チーム開発統合

### EditorConfig統合

```ini
# .editorconfig
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

[*.{py,pyi}]
indent_size = 4

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
```

```lua
-- LazyVimでのEditorConfig統合
return {
  "editorconfig/editorconfig-vim",
  event = "BufReadPre",
}
```

### Prettier・ESLint統合

```lua
-- ~/.config/nvim/lua/plugins/formatting.lua
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      python = { "black", "isort" },
      go = { "gofmt", "goimports" },
      rust = { "rustfmt" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
```

### プロジェクト設定の標準化

```lua
-- ~/.config/nvim/lua/config/project-standards.lua
local M = {}

-- プロジェクトタイプの自動検出
M.detect_project_type = function()
  local project_files = {
    { "package.json", "node" },
    { "requirements.txt", "python" },
    { "Pipfile", "python" },
    { "pyproject.toml", "python" },
    { "go.mod", "go" },
    { "Cargo.toml", "rust" },
    { "pom.xml", "java" },
    { "build.gradle", "java" },
  }
  
  for _, config in ipairs(project_files) do
    local file, type = config[1], config[2]
    if vim.fn.filereadable(file) == 1 then
      return type
    end
  end
  
  return "unknown"
end

-- プロジェクトタイプ別設定
M.setup_project = function()
  local project_type = M.detect_project_type()
  
  if project_type == "node" then
    -- Node.js プロジェクト設定
    vim.keymap.set("n", "<leader>pr", "<cmd>!npm run dev<cr>", { desc = "npm run dev" })
    vim.keymap.set("n", "<leader>pt", "<cmd>!npm test<cr>", { desc = "npm test" })
    vim.keymap.set("n", "<leader>pb", "<cmd>!npm run build<cr>", { desc = "npm build" })
  elseif project_type == "python" then
    -- Python プロジェクト設定
    vim.keymap.set("n", "<leader>pr", "<cmd>!python main.py<cr>", { desc = "Run Python" })
    vim.keymap.set("n", "<leader>pt", "<cmd>!pytest<cr>", { desc = "Run tests" })
  elseif project_type == "go" then
    -- Go プロジェクト設定
    vim.keymap.set("n", "<leader>pr", "<cmd>!go run .<cr>", { desc = "go run" })
    vim.keymap.set("n", "<leader>pt", "<cmd>!go test<cr>", { desc = "go test" })
    vim.keymap.set("n", "<leader>pb", "<cmd>!go build<cr>", { desc = "go build" })
  end
end

-- プロジェクト開始時に自動実行
vim.api.nvim_create_autocmd("VimEnter", {
  callback = M.setup_project,
})

return M
```

## 6. 実践的なワークフロー例

### 機能開発のワークフロー

```lua
-- ~/.config/nvim/lua/utils/feature-workflow.lua
local M = {}

-- 新機能開発のワークフロー
M.start_feature = function(feature_name)
  if not feature_name then
    feature_name = vim.fn.input("Feature name: ")
  end
  
  if feature_name == "" then
    return
  end
  
  -- Git フローの実行
  local commands = {
    "git checkout main",
    "git pull origin main",
    "git checkout -b feature/" .. feature_name,
  }
  
  for _, cmd in ipairs(commands) do
    vim.fn.system(cmd)
  end
  
  -- テンプレートファイルの作成
  local template_path = feature_name .. ".md"
  local template_content = {
    "# Feature: " .. feature_name,
    "",
    "## 概要",
    "<!-- 機能の概要を記述 -->",
    "",
    "## TODO",
    "- [ ] 要件定義",
    "- [ ] 設計",
    "- [ ] 実装",
    "- [ ] テスト",
    "- [ ] ドキュメント",
    "",
    "## 注意事項",
    "<!-- 開発時の注意事項 -->",
  }
  
  vim.fn.writefile(template_content, template_path)
  vim.cmd("edit " .. template_path)
  
  print("Started feature: " .. feature_name)
end

-- プルリクエスト準備
M.prepare_pr = function()
  local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
  
  -- コミット整理の確認
  local choice = vim.fn.confirm("Squash commits before PR?", "&Yes\n&No", 1)
  if choice == 1 then
    vim.cmd("!git rebase -i main")
  end
  
  -- プッシュとPR作成
  vim.fn.system("git push -u origin " .. branch)
  
  -- GitHub CLI を使用してPR作成
  if vim.fn.executable("gh") == 1 then
    vim.cmd("!gh pr create --web")
  else
    print("Push completed. Create PR manually.")
  end
end

-- キーマップ設定
vim.keymap.set("n", "<leader>wf", M.start_feature, { desc = "Start feature" })
vim.keymap.set("n", "<leader>wp", M.prepare_pr, { desc = "Prepare PR" })

return M
```

### コードレビューのワークフロー

```lua
-- コードレビュー支援
M.review_mode = function()
  -- レビュー用の設定
  vim.opt.number = true
  vim.opt.relativenumber = false
  vim.opt.wrap = false
  vim.opt.colorcolumn = "80,120"
  
  -- レビュー用キーマップ
  vim.keymap.set("n", "<leader>rc", "gcc", { desc = "Comment line", remap = true })
  vim.keymap.set("v", "<leader>rc", "gc", { desc = "Comment selection", remap = true })
  vim.keymap.set("n", "<leader>rn", "]c", { desc = "Next change" })
  vim.keymap.set("n", "<leader>rp", "[c", { desc = "Previous change" })
  
  print("Review mode activated")
end

vim.keymap.set("n", "<leader>wr", M.review_mode, { desc = "Review mode" })
```

## まとめ

高度なワークフローの習得により：
- **効率性の飛躍的向上**: マルチカーソル・マクロによる作業時間短縮
- **品質の向上**: 自動化による一貫性・正確性の確保
- **チーム生産性**: 標準化された設定・ワークフローによる協力効率化
- **継続的改善**: 反復作業の特定と自動化による継続的な効率化

これらのテクニックを日常的に活用することで、プロフェッショナルレベルの開発効率を実現できます。