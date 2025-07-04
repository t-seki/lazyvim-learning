# Text Object練習用Markdownファイル

## 概要

このドキュメントは、Text Objectの練習用に様々な構造を含んでいます。段落、リスト、引用、コードブロックなど、Markdownの各要素でText Objectを練習できます。

## 基本的な段落操作

これは最初の段落です。段落は空行で区切られています。`ip`で段落内部を、`ap`で段落全体（前後の空行を含む）を選択できます。

これは2番目の段落です。複数の文が含まれています。最初の文です。2番目の文です。3番目の文です。`is`や`as`で文単位の操作ができます。

短い段落。

## リスト構造での練習

### 番号なしリスト

- 最初のアイテム（この行で`dd`を試してみましょう）
- 2番目のアイテム
  - ネストしたアイテム1
  - ネストしたアイテム2
    - さらに深いネスト
- 3番目のアイテム

### 番号付きリスト

1. ステップ1: 準備をする
2. ステップ2: 実行する
3. ステップ3: 確認する
   1. サブステップ3.1
   2. サブステップ3.2
4. ステップ4: 完了

### タスクリスト

- [ ] 未完了のタスク（`ci[`で括弧内を変更）
- [x] 完了済みのタスク
- [ ] 別の未完了タスク
  - [ ] サブタスク1
  - [x] サブタスク2

## 引用とコードブロック

### 引用ブロック

> これは引用ブロックです。複数行にわたることができます。
> 引用記号は各行の先頭にあります。
> 
> 引用ブロック内でも段落を分けることができます。

### インラインコード

この文章には`インラインコード`が含まれています。バッククォートで囲まれた部分は`i``や`a``で選択できます。

### コードブロック

```python
def hello_world():
    """シンプルな関数の例"""
    message = "Hello, World!"
    print(message)
    return message
```

```javascript
// JavaScriptの例
const config = {
    name: "MyApp",
    version: "1.0.0",
    features: ["feature1", "feature2", "feature3"]
};

function processConfig(cfg) {
    console.log(`Processing ${cfg.name} v${cfg.version}`);
    cfg.features.forEach(feature => {
        console.log(`- ${feature}`);
    });
}
```

## テーブル構造

| カラム1 | カラム2 | カラム3 |
|---------|---------|---------|
| データ1 | データ2 | データ3 |
| 値A     | 値B     | 値C     |
| 項目X   | 項目Y   | 項目Z   |

## リンクと画像

### リンク

- [LazyVim公式サイト](https://www.lazyvim.org/)（`ci[`でリンクテキストを変更）
- [Neovim GitHub](https://github.com/neovim/neovim)（`ci(`でURLを変更）
- [相対リンク](./guide.md)

### 画像

![代替テキスト](image.png)（`ci[`で代替テキストを変更、`ci(`でパスを変更）

## 複雑な構造の練習

### ネストした引用

> 外側の引用
> > ネストした引用
> > > さらに深いネスト
> > 
> > 戻ってきた
> 
> 最初のレベルに戻る

### 混在したコンテンツ

この段落には**太字のテキスト**と*イタリックのテキスト*が含まれています。また、***太字かつイタリック***のテキストもあります。

1. リスト内の**強調**
2. `コード`を含むリスト項目
3. [リンク](https://example.com)を含む項目

## HTML要素（Markdownに埋め込み）

<div class="container">
    <p>HTMLタグ内のコンテンツ（`it`や`at`で操作）</p>
    <span>インライン要素</span>
</div>

## 文字列操作の練習

"ダブルクォートで囲まれた文字列"（`ci"`で内容を変更）

'シングルクォートで囲まれた文字列'（`ci'`で内容を変更）

`バッククォートで囲まれた文字列`（`ci``で内容を変更）

(括弧で囲まれた内容)（`ci(`で内容を変更）

[角括弧で囲まれた内容]（`ci[`で内容を変更）

{中括弧で囲まれた内容}（`ci{`で内容を変更）

## 長い段落での練習

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## まとめ

このファイルを使って、様々なText Object操作を練習してください：

- `dip` - 段落を削除
- `ci"` - 引用符内を変更
- `da[` - 角括弧を含めて削除
- `vit` - HTMLタグ内を選択
- `yap` - 段落全体をヤンク

練習を重ねることで、効率的な編集が可能になります。