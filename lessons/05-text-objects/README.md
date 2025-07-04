# レッスン5: Text Objectマスター

## 概要
このレッスンでは、Vimの最も強力な機能の1つである**Text Object（テキストオブジェクト）**を学習します。Text Objectを理解することで、コードやテキストの構造単位で効率的に編集操作を行えるようになります。LazyVimの拡張Text Objectプラグインも活用して、より高度な編集テクニックを習得します。

## 学習目標

### 主要目標
- [ ] Vimの組み込みText Objectを完全に理解し活用できる
- [ ] Text Objectとオペレータ（d, c, y, v）の組み合わせをマスターする
- [ ] LazyVimの拡張Text Object（Treesitter統合）を使いこなす
- [ ] カスタムText Objectの概念を理解する

### 具体的なスキル
- [ ] 単語、文、段落、引用符、括弧などの基本Text Objectの操作
- [ ] インデントベース、関数、クラスなどの高度なText Object
- [ ] Treesitterによる言語固有のText Object操作
- [ ] Text Objectの範囲選択と編集の効率化

## 前提知識
- LazyVimの基本操作（レッスン1完了）
- 基本的なVimモーション（h, j, k, l, w, b, e）
- ビジュアルモードの基本操作
- 基本的なオペレータ（d, c, y）の理解

## 学習内容

### 1. Text Objectの基礎
- Text Objectとは何か？その威力の理解
- 基本的なText Object（iw, aw, is, as, ip, ap）
- 引用符と括弧のText Object（i", a", i(, a(, i{, a{）
- 内側（inner）と周囲を含む（around）の違い

### 2. オペレータとの組み合わせ
- 削除（d）+ Text Object
- 変更（c）+ Text Object
- ヤンク（y）+ Text Object
- ビジュアル選択（v）+ Text Object

### 3. 高度なText Object
- タグのText Object（it, at）- HTML/XML編集
- インデントのText Object（ii, ai）- Pythonなどに便利
- 関数・メソッドのText Object（if, af）
- クラスのText Object（ic, ac）

### 4. LazyVim拡張Text Object
- **nvim-treesitter-textobjects**による言語認識Text Object
- **mini.ai**による拡張Text Object
- カスタムText Objectの活用方法
- 言語固有のText Object活用

## 練習環境
- `practice-files/sample.lua` - Lua関数でのText Object練習
- `practice-files/sample.py` - Pythonクラス・関数でのText Object練習
- `practice-files/sample.md` - Markdownでの段落・リスト操作練習

## 推定学習時間
- 基礎理解: 30分
- 実践練習: 45分
- 応用テクニック: 30分
- 合計: 約1時間45分

## 次のステップ
このレッスン完了後は、以下のレッスンへ進むことを推奨します：
- レッスン6: コーディング機能（LSP・補完の深掘り）
- レッスン7: デバッグとテスト統合

## 補足リソース
- `:help text-objects` - Vimの公式ヘルプ
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [mini.ai](https://github.com/echasnovski/mini.ai)