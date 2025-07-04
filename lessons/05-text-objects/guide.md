# Text Objectマスター - 詳細ガイド

## Text Objectとは？

Text Object（テキストオブジェクト）は、Vimの編集哲学の中核をなす概念です。「カーソル位置から特定の構造単位」を表現し、オペレータと組み合わせることで強力な編集コマンドを実現します。

### 基本構文
```
[回数][オペレータ][修飾子][オブジェクト]
```

例：
- `diw` - Delete Inner Word（単語内部を削除）
- `ca"` - Change Around quotes（引用符を含めて変更）
- `yi(` - Yank Inner parentheses（括弧内をヤンク）

## 1. 基本的なText Object

### 単語（Word）
```vim
iw  - Inner Word（単語内部）
aw  - Around Word（単語と周囲の空白）
```

**実践例**：
```lua
-- カーソルが "function" の上にある場合
local function getName()  -- diwで "function" → "getName"
```

### 文（Sentence）
```vim
is  - Inner Sentence（文内部）
as  - Around Sentence（文と空白を含む）
```

**実践例**：
```markdown
This is first. This is second. This is third.
              ^カーソル位置
-- dis → "This is first. This is third."
```

### 段落（Paragraph）
```vim
ip  - Inner Paragraph（段落内部）
ap  - Around Paragraph（段落と空行を含む）
```

### WORD（大文字W - 空白区切り）
```vim
iW  - Inner WORD（空白で区切られた文字列）
aW  - Around WORD（WORDと周囲の空白）
```

## 2. 引用符と括弧のText Object

### 引用符
```vim
i"  - Inner double quotes
a"  - Around double quotes
i'  - Inner single quotes
a'  - Around single quotes
i`  - Inner backticks
a`  - Around backticks
```

**実践例**：
```lua
local msg = "Hello, World!"
           ^カーソル位置
-- di" → local msg = ""
-- da" → local msg = 
```

### 括弧類
```vim
i(  または ib  - Inner parentheses
a(  または ab  - Around parentheses
i{  または iB  - Inner braces
a{  または aB  - Around braces
i[  - Inner brackets
a[  - Around brackets
i<  - Inner angle brackets
a<  - Around angle brackets
```

**実践例**：
```lua
function calculate(x, y, z)
                  ^カーソル位置
-- di( → function calculate()
-- vi{ でブロック全体を選択
```

## 3. HTML/XMLタグ
```vim
it  - Inner Tag（タグ内のコンテンツ）
at  - Around Tag（タグ全体を含む）
```

**実践例**：
```html
<div class="container">
  <p>Content here</p>
     ^カーソル位置
</div>
-- dit → <p></p>
-- dat → （<p>タグ全体が削除）
```

## 4. LazyVimの拡張Text Object

### Treesitter統合Text Object

LazyVimには**nvim-treesitter-textobjects**が統合されており、言語構造を理解したText Objectが使用できます。

```vim
-- 関数
if  - Inner Function
af  - Around Function

-- クラス
ic  - Inner Class
ac  - Around Class

-- パラメータ/引数
ia  - Inner Argument
aa  - Around Argument

-- コメント
ic  - Inner Comment
ac  - Around Comment

-- 条件文
ii  - Inner Conditional
ai  - Around Conditional

-- ループ
il  - Inner Loop
al  - Around Loop
```

**実践例（Lua）**：
```lua
function processData(input)
  -- 処理内容
  if input then
    return transform(input)
  end
end
-- vaf で関数全体を選択
-- dif で関数の中身だけ削除
```

### mini.aiによる拡張

LazyVimの**mini.ai**プラグインは、さらに多くのText Objectを提供します：

```vim
-- インデントベース
ii  - Inner Indent（同じインデントレベル）
ai  - Around Indent（インデントブロック全体）

-- 数値
in  - Inner Number
an  - Around Number

-- キー・値
ik  - Inner Key（オブジェクトのキー）
iv  - Inner Value（オブジェクトの値）
```

## 5. 高度なテクニック

### 連続操作
```vim
-- 複数の引用符がある場合
"first" some text "second" more text "third"
                  ^カーソル位置
-- di" → "first" some text "" more text "third"
-- 2di" → 2番目の引用符内を削除
```

### ビジュアルモードでの活用
```vim
-- 関数全体を選択してインデント
vaf>

-- 括弧内を選択して置換
vi(:s/old/new/g
```

### オペレータとの組み合わせパターン
```vim
-- よく使うパターン
ciw  - 単語を変更
dit  - タグ内容を削除
ya"  - 引用符込みでヤンク
dap  - 段落全体を削除
gUiw - 単語を大文字に変換
```

## 6. 言語別の活用例

### Python
```python
class DataProcessor:
    def process(self, data):
        if len(data) > 0:
            return [self.transform(item) for item in data]
        return []

# vac でクラス全体を選択
# dif でメソッドの中身を削除
# cii で同じインデントレベルを変更
```

### JavaScript/TypeScript
```javascript
const config = {
  server: {
    port: 3000,
    host: "localhost"
  },
  database: {
    url: "mongodb://localhost"
  }
};

// vi{ でオブジェクト内を選択
// da{ でオブジェクト全体を削除
// civ で値だけを変更
```

### HTML/React
```jsx
<Card className="user-card">
  <CardHeader>
    <h2>{user.name}</h2>
  </CardHeader>
  <CardBody>
    {user.description}
  </CardBody>
</Card>

// vat でコンポーネント全体を選択
// dit でタグ内容だけ削除
// ci{ でJSX式を変更
```

## 7. カスタマイズ例

LazyVimでカスタムText Objectを定義する例：

```lua
-- ~/.config/nvim/lua/config/keymaps.lua
-- 行全体をText Objectとして定義
vim.keymap.set({ "x", "o" }, "il", ":<C-u>normal! 0v$<CR>", { silent = true })
vim.keymap.set({ "x", "o" }, "al", ":<C-u>normal! V<CR>", { silent = true })
```

## 実践的なワークフロー

### リファクタリング作業
1. `vaf` で関数全体を選択
2. `:s/oldName/newName/g` で関数内の変数名を置換
3. `dif` で関数の中身を削除して書き直し

### 文字列操作
1. `vi"` で文字列内容を選択
2. `u` で小文字に変換
3. `ca"` で引用符ごと別の文字列に変更

### コードブロック整理
1. `vai` でインデントブロックを選択
2. `>` でインデントを深くする
3. `dap` で段落（ブロック）全体を削除

## まとめ

Text Objectをマスターすることで：
- 編集操作の精度が格段に向上
- キーストローク数が大幅に削減
- 思考と同じ速度でコードを編集可能

特にLazyVimのTreesitter統合により、言語構造を理解した賢いText Object操作が可能になり、モダンな開発環境での生産性が飛躍的に向上します。