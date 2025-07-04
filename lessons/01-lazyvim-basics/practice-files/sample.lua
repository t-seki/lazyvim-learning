-- LazyVim 基本操作練習用ファイル
-- ===========================

-- 🎯 このファイルでカーソル移動と基本操作を練習しましょう

local M = {}

-- 練習1: カーソル移動
-- 以下の関数にカーソルを移動してみましょう
-- - 'gd' で定義ジャンプ
-- - 'K' でドキュメント表示
-- - '<leader>ca' でコードアクション

function M.hello_world()
  print("Hello, LazyVim!")
end

function M.calculate_sum(a, b)
  -- この関数は2つの数値を足します
  return a + b
end

function M.greet_user(name)
  if name == nil then
    name = "Anonymous"
  end
  
  local greeting = "こんにちは、" .. name .. "さん！"
  print(greeting)
  
  return greeting
end

-- 練習2: ファイル検索
-- '<leader>fg' でGitファイル検索を試してみましょう
-- '<leader>/' でプロジェクト全体から以下のキーワードを検索：
-- - "function"
-- - "print"
-- - "LazyVim"

-- 練習3: 編集操作
-- このコメントを編集してみましょう：
-- TODO: ここに自分の名前を書く → 

-- 練習4: シンボル検索
-- '<leader>ss' でシンボル（関数名など）を検索

-- 📝 練習課題
-- 1. 新しい関数 'M.farewell()' を作成する
-- 2. その関数で "さようなら！" を出力する
-- 3. コメントを日本語で追加する

-- あなたの関数をここに書いてください：


-- 練習5: フォールディング（折りたたみ）
-- 'za' で以下のセクションを折りたたんでみましょう
do
  -- このブロックは折りたたみ可能です
  local internal_data = {
    version = "1.0.0",
    author = "LazyVim学習者",
    description = "練習用データ"
  }
  
  function M.get_info()
    return internal_data
  end
end

-- 練習6: ビジュアルモード
-- 'v' でビジュアルモードにして以下のテキストを選択：
local sample_text = "この行をビジュアルモードで選択してください"

-- 選択後に 'gc' でコメントアウト/解除を試してください

return M