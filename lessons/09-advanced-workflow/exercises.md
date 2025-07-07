# 高度なワークフロー - エクササイズ

## 準備

### 練習用プロジェクトのセットアップ
```bash
cd lessons/09-advanced-workflow/examples
mkdir -p multi-editing snippet-management team-workflow
```

### バックアップの作成
```bash
# 現在の設定をバックアップ
cp -r ~/.config/nvim ~/.config/nvim.backup.advanced
```

## エクササイズ1: マルチカーソル・一括編集

### 基本的なマルチカーソル操作

1. **同一単語の一括選択・編集**
   ```javascript
   // 以下のコードで練習
   const userName = "Alice";
   console.log(userName);
   function getUserName() {
     return userName;
   }
   const userInfo = { name: userName, age: 30 };
   ```
   - [ ] `userName`にカーソルを置く
   - [ ] `<C-n>`で最初の`userName`を選択
   - [ ] 再度`<C-n>`で次の`userName`も選択
   - [ ] `c`で変更モード → `userProfile`に変更

2. **列編集の練習**
   ```css
   .button { background: red; }
   .input { background: blue; }
   .label { background: green; }
   .form { background: yellow; }
   .modal { background: purple; }
   ```
   - [ ] 最初の行にカーソル
   - [ ] `<C-v>`でブロック選択開始
   - [ ] `4j`で下4行も選択
   - [ ] `f{`で`{`の位置に移動
   - [ ] `A`で行末に移挿入 → ` border: 1px solid;`を追加

3. **正規表現による複数選択**
   ```html
   <div id="header">Header</div>
   <div id="content">Content</div>
   <div id="footer">Footer</div>
   <div id="sidebar">Sidebar</div>
   ```
   - [ ] `:VM/id="[^"]*"/`でid属性を全選択
   - [ ] `c`で変更モード → `class="section"`に変更

### 複雑なパターンの編集

4. **JSONデータの整形**
   ```json
   {"name":"Alice","age":30,"city":"Tokyo"}
   {"name":"Bob","age":25,"city":"Osaka"}
   {"name":"Charlie","age":35,"city":"Kyoto"}
   ```
   - [ ] 各行を以下の形式に整形：
   ```json
   {
     "name": "Alice",
     "age": 30,
     "city": "Tokyo"
   }
   ```

5. **コメントの一括追加**
   ```python
   print("Step 1: Initialize")
   print("Step 2: Process data")
   print("Step 3: Save results")
   print("Step 4: Cleanup")
   ```
   - [ ] すべての行の先頭に`# TODO: `を追加

## エクササイズ2: スニペット管理

### 基本スニペットの作成

1. **JavaScript用カスタムスニペット**
   ```lua
   -- ~/.config/nvim/lua/snippets/javascript.lua
   local ls = require("luasnip")
   local s = ls.snippet
   local t = ls.text_node
   local i = ls.insert_node
   
   return {
     s("func", {
       t("function "), i(1, "name"), t("("), i(2, "params"), t(") {"),
       t({"", "  "}), i(3, "// body"),
       t({"", "}"})
     }),
   }
   ```
   - [ ] 上記のスニペットを作成
   - [ ] JavaScriptファイルで`func`と入力してスニペット展開をテスト

2. **React用カスタムスニペット**
   ```lua
   s("rfc", {
     t("import React from 'react';"),
     t({"", "", "interface "}), i(1, "Component"), t("Props {"),
     t({"", "  "}), i(2, "// props"),
     t({"", "}", "", "const "}), i(3, "Component"), t(": React.FC<"), 
     f(function(args) return args[1][1] end, {1}), t("Props> = ("), i(4, "props"), t(") => {"),
     t({"", "  return (", "    <div>"}), i(5, "content"), t({"</div>", "  );", "};", "", "export default "}), 
     f(function(args) return args[1][1] end, {3}), t(";")
   }),
   ```
   - [ ] React用スニペットを作成
   - [ ] TypeScript Reactファイルで`rfc`をテスト

3. **動的スニペットの作成**
   ```lua
   s("today", {
     f(function()
       return os.date("%Y-%m-%d")
     end, {})
   }),
   
   s("comment", {
     t("/*"), t({"", " * Created: "}), 
     f(function() return os.date("%Y-%m-%d") end, {}),
     t({"", " * Author: "}), i(1, "Your Name"),
     t({"", " * Description: "}), i(2, "Description"),
     t({"", " */"})
   }),
   ```
   - [ ] 日付・コメントスニペットを作成
   - [ ] 動作確認を実施

### プロジェクト固有スニペット

4. **Node.js API用スニペット**
   ```lua
   -- プロジェクトルートの .nvim.lua に追加
   local ls = require("luasnip")
   local s = ls.snippet
   local t = ls.text_node
   local i = ls.insert_node
   
   ls.add_snippets("javascript", {
     s("api", {
       t("app."), i(1, "get"), t("('"), i(2, "/path"), t("', async (req, res) => {"),
       t({"", "  try {"}),
       t({"", "    "}), i(3, "// implementation"),
       t({"", "    res.json({ success: true, data: null });"}),
       t({"", "  } catch (error) {"}),
       t({"", "    res.status(500).json({ error: error.message });"}),
       t({"", "  }"}),
       t({"", "});"})
     }),
   })
   ```
   - [ ] API用スニペットをプロジェクト設定として作成
   - [ ] 動作確認

## エクササイズ3: Git統合ワークフロー

### LazyGitの高度な活用

1. **ブランチ操作の練習**
   - [ ] `<leader>gg`でLazyGitを開く
   - [ ] `n`で新しいブランチ`feature/test-branch`を作成
   - [ ] いくつかのファイルを編集
   - [ ] `<space>`でファイルをステージング
   - [ ] `c`でコミット（メッセージ: "Test commit for advanced workflow"）

2. **Gitsignsとの連携**
   ```lua
   -- gitsigns設定の確認・追加
   vim.keymap.set('n', ']h', function()
     require('gitsigns').next_hunk()
   end, { desc = "Next hunk" })
   
   vim.keymap.set('n', '[h', function()
     require('gitsigns').prev_hunk()
   end, { desc = "Previous hunk" })
   
   vim.keymap.set('n', '<leader>hp', function()
     require('gitsigns').preview_hunk()
   end, { desc = "Preview hunk" })
   
   vim.keymap.set('n', '<leader>hr', function()
     require('gitsigns').reset_hunk()
   end, { desc = "Reset hunk" })
   ```
   - [ ] 上記キーマップを設定
   - [ ] ファイルを編集して変更箇所をナビゲート
   - [ ] `]h`/`[h`で変更箇所間移動
   - [ ] `<leader>hp`で変更をプレビュー

3. **コンフリクト解決の練習**
   ```bash
   # 意図的にコンフリクトを作成
   git checkout main
   echo "Main branch content" > conflict-test.txt
   git add conflict-test.txt
   git commit -m "Add content from main"
   
   git checkout feature/test-branch
   echo "Feature branch content" > conflict-test.txt
   git add conflict-test.txt
   git commit -m "Add content from feature"
   
   git merge main  # コンフリクト発生
   ```
   - [ ] コンフリクトが発生することを確認
   - [ ] LazyGitでコンフリクト解決
   - [ ] マージを完了

### 高度なGitワークフロー

4. **インタラクティブリベース**
   - [ ] `git log --oneline -5`で最近のコミットを確認
   - [ ] LazyGitで`r`（リベース）を選択
   - [ ] コミット順序の変更や統合を実践

5. **スタッシュの活用**
   - [ ] 作業中のファイルを編集
   - [ ] LazyGitで`s`（スタッシュ）を実行
   - [ ] 別の作業を実施
   - [ ] スタッシュを復元

## エクササイズ4: マクロ・自動化

### 基本的なマクロ操作

1. **リスト変換マクロ**
   ```text
   Apple
   Banana
   Cherry
   Date
   Elderberry
   ```
   以下の形式に変換：
   ```javascript
   const fruits = [
     "Apple",
     "Banana", 
     "Cherry",
     "Date",
     "Elderberry"
   ];
   ```
   - [ ] マクロを記録（`qa`）
   - [ ] 1行目で`I"`（行頭に"を挿入）
   - [ ] `A",`（行末に",を追加）
   - [ ] `j`（次の行に移動）
   - [ ] `q`（記録終了）
   - [ ] `4@a`（残り4行に適用）
   - [ ] 手動で配列の開始・終了部分を追加

2. **HTML→JSON変換マクロ**
   ```html
   <div class="item" data-id="1">Item 1</div>
   <div class="item" data-id="2">Item 2</div>
   <div class="item" data-id="3">Item 3</div>
   ```
   以下に変換：
   ```json
   {"id": "1", "text": "Item 1"},
   {"id": "2", "text": "Item 2"},
   {"id": "3", "text": "Item 3"}
   ```
   - [ ] 変換マクロを作成・実行

### Lua関数による高度な自動化

3. **関数ドキュメント生成**
   ```lua
   -- ~/.config/nvim/lua/utils/doc-generator.lua
   local M = {}
   
   M.generate_jsdoc = function()
     local line = vim.api.nvim_get_current_line()
     local func_pattern = "function%s+([%w_]+)%s*%(([^)]*)%)"
     local name, params = line:match(func_pattern)
     
     if name then
       local doc_lines = {
         "/**",
         " * " .. name .. " - Description",
       }
       
       if params and params ~= "" then
         for param in params:gmatch("([^,]+)") do
           param = param:match("^%s*(.-)%s*$")
           table.insert(doc_lines, " * @param {type} " .. param .. " - Description")
         end
       end
       
       table.insert(doc_lines, " * @returns {type} Description")
       table.insert(doc_lines, " */")
       
       local row = vim.api.nvim_win_get_cursor(0)[1]
       vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, doc_lines)
     end
   end
   
   vim.keymap.set("n", "<leader>ad", M.generate_jsdoc, { desc = "Generate JSDoc" })
   
   return M
   ```
   - [ ] ドキュメント生成関数を作成
   - [ ] JavaScriptファイルで関数を定義
   - [ ] `<leader>ad`でドキュメント生成をテスト

4. **ファイルテンプレート挿入**
   ```lua
   M.insert_react_component = function()
     local filename = vim.fn.expand("%:t:r")
     local template = {
       "import React from 'react';",
       "",
       "interface " .. filename .. "Props {",
       "  // props here",
       "}",
       "",
       "const " .. filename .. ": React.FC<" .. filename .. "Props> = (props) => {",
       "  return (",
       "    <div>",
       "      {/* " .. filename .. " content */}",
       "    </div>",
       "  );",
       "};",
       "",
       "export default " .. filename .. ";"
     }
     
     vim.api.nvim_put(template, "l", true, true)
   end
   
   vim.keymap.set("n", "<leader>arc", M.insert_react_component, { desc = "Insert React component" })
   ```
   - [ ] Reactコンポーネントテンプレート機能を作成
   - [ ] 新しい`.tsx`ファイルで動作確認

## エクササイズ5: チーム開発統合

### EditorConfig統合

1. **プロジェクト設定の統一**
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
   
   [*.go]
   indent_style = tab
   
   [*.md]
   trim_trailing_whitespace = false
   max_line_length = 80
   ```
   - [ ] EditorConfigファイルを作成
   - [ ] 異なるファイルタイプで設定が適用されることを確認

2. **Prettier設定の統合**
   ```json
   // .prettierrc
   {
     "semi": true,
     "trailingComma": "es5",
     "singleQuote": true,
     "printWidth": 100,
     "tabWidth": 2,
     "useTabs": false
   }
   ```
   - [ ] Prettier設定ファイルを作成
   - [ ] JavaScriptファイルをフォーマットして動作確認

### プロジェクト設定の自動化

3. **プロジェクトタイプ検出**
   ```lua
   -- ~/.config/nvim/lua/utils/project-setup.lua
   local M = {}
   
   M.detect_and_setup = function()
     -- package.jsonの存在確認
     if vim.fn.filereadable("package.json") == 1 then
       print("Node.js project detected")
       -- Node.js用キーマップ設定
       vim.keymap.set("n", "<leader>pr", "<cmd>!npm run dev<cr>", { desc = "npm run dev" })
       vim.keymap.set("n", "<leader>pt", "<cmd>!npm test<cr>", { desc = "npm test" })
       vim.keymap.set("n", "<leader>pb", "<cmd>!npm run build<cr>", { desc = "npm build" })
       
     -- requirements.txtの存在確認
     elseif vim.fn.filereadable("requirements.txt") == 1 then
       print("Python project detected")
       vim.keymap.set("n", "<leader>pr", "<cmd>!python main.py<cr>", { desc = "Run Python" })
       vim.keymap.set("n", "<leader>pt", "<cmd>!pytest<cr>", { desc = "Run tests" })
       
     -- go.modの存在確認
     elseif vim.fn.filereadable("go.mod") == 1 then
       print("Go project detected")
       vim.keymap.set("n", "<leader>pr", "<cmd>!go run .<cr>", { desc = "go run" })
       vim.keymap.set("n", "<leader>pt", "<cmd>!go test<cr>", { desc = "go test" })
     end
   end
   
   -- プロジェクト開始時に自動実行
   vim.api.nvim_create_autocmd("VimEnter", {
     callback = M.detect_and_setup,
   })
   
   return M
   ```
   - [ ] プロジェクト検出機能を作成
   - [ ] 異なるプロジェクトタイプで動作確認

4. **チーム設定の共有**
   ```lua
   -- .nvim.lua（プロジェクトルート）
   -- チーム共通の設定
   
   -- コーディングスタイル
   vim.opt.tabstop = 2
   vim.opt.shiftwidth = 2
   vim.opt.expandtab = true
   
   -- 行長制限
   vim.opt.colorcolumn = "100"
   
   -- チーム共通キーマップ
   vim.keymap.set("n", "<leader>tf", "<cmd>!npm run format<cr>", { desc = "Format code" })
   vim.keymap.set("n", "<leader>tl", "<cmd>!npm run lint<cr>", { desc = "Lint code" })
   
   -- プロジェクト固有のLSP設定
   vim.api.nvim_create_autocmd("FileType", {
     pattern = "typescript",
     callback = function()
       vim.keymap.set("n", "<leader>ti", "<cmd>TypescriptOrganizeImports<cr>", 
         { buffer = true, desc = "Organize imports" })
     end,
   })
   ```
   - [ ] チーム共有設定ファイルを作成
   - [ ] プロジェクト固有設定が読み込まれることを確認

## エクササイズ6: 総合ワークフロー

### 実践的な開発シナリオ

1. **新機能開発のワークフロー**
   ```bash
   # 1. 新機能ブランチの作成
   git checkout -b feature/user-profile
   
   # 2. 必要なファイルを作成
   mkdir -p src/components/UserProfile
   touch src/components/UserProfile/UserProfile.tsx
   touch src/components/UserProfile/UserProfile.test.tsx
   touch src/components/UserProfile/index.ts
   ```
   
   - [ ] LazyGitでブランチを作成
   - [ ] Reactコンポーネントテンプレートを挿入
   - [ ] JSDocコメントを自動生成
   - [ ] TypeScript用のテストテンプレートを作成
   - [ ] 実装完了後、LazyGitでコミット・プッシュ

2. **バグ修正のワークフロー**
   ```javascript
   // バグのあるコード例
   function calculateTotal(items) {
     let total = 0;
     for (let i = 0; i <= items.length; i++) {  // バグ: <= instead of <
       total += items[i].price;
     }
     return total;
   }
   ```
   
   - [ ] Telescopeで関数を検索
   - [ ] LSPでエラーを確認
   - [ ] バグを修正
   - [ ] コメントでバグ修正内容を記録
   - [ ] テストを追加
   - [ ] Gitsignsで変更を確認
   - [ ] コミット

3. **リファクタリングのワークフロー**
   ```javascript
   // リファクタリング対象のコード
   function processUserData(user) {
     if (user && user.name && user.email) {
       if (user.age >= 18) {
         if (user.verified) {
           return { ...user, status: 'active' };
         }
       }
     }
     return { ...user, status: 'inactive' };
   }
   ```
   
   - [ ] マルチカーソルで変数名を一括変更
   - [ ] 複雑な条件を分割・整理
   - [ ] LSPで型安全性を確保
   - [ ] 自動フォーマットを適用
   - [ ] 変更をコミット

## チャレンジ課題

### 上級1: カスタムワークフロー構築
- [ ] 独自の開発ワークフローをLua関数として実装
- [ ] プロジェクト開始からデプロイまでの自動化

### 上級2: チーム効率化ツール
- [ ] チーム共通のスニペット・設定管理システム
- [ ] コードレビュー支援機能の実装

### 上級3: 言語固有の最適化
- [ ] 使用言語に特化したワークフロー
- [ ] 言語固有の自動化・効率化機能

## 確認ポイント

練習完了後、以下を確認してください：

### マルチカーソル・編集効率
- [ ] 複数箇所の同時編集が迅速にできる
- [ ] 正規表現による高度な選択・置換ができる
- [ ] 列編集・ブロック選択を適切に使える

### スニペット管理
- [ ] プロジェクトに適したスニペットを作成できる
- [ ] 動的スニペットを活用できる
- [ ] チーム共有スニペットを管理できる

### Git統合
- [ ] LazyGitで効率的にGit操作ができる
- [ ] Gitsignsでリアルタイム変更確認ができる
- [ ] コンフリクト解決を迅速に行える

### 自動化・マクロ
- [ ] 定型作業をマクロ化できる
- [ ] Lua関数で高度な自動化ができる
- [ ] プロジェクト固有の自動化を実装できる

### チーム開発統合
- [ ] EditorConfig・Prettierと連携できる
- [ ] プロジェクト設定を自動化できる
- [ ] チーム標準に合わせた効率化ができる

これらのスキルをマスターすることで、プロフェッショナルレベルの開発効率を実現できます。