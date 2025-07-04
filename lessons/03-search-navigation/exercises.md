# 練習問題

## 練習1: 基本的な検索操作

**目標**: 様々な検索コマンドを使いこなす

**開始ファイル**: `practice/start/search-basics.txt`

**手順**:
1. ファイルを開く: `nvim practice/start/search-basics.txt`
2. 以下の検索を順番に試す：
   - `/function` で関数を前方検索
   - `?return` で戻り値を後方検索
   - 変数名にカーソルを置いて `*` で検索
   - `n` と `N` で検索結果を移動

**チェックポイント**:
- [ ] 前方・後方検索の違いを理解できたか
- [ ] `*` と `#` による単語検索ができたか
- [ ] `n` と `N` でスムーズに移動できたか

## 練習2: 基本的な置換操作

**目標**: 安全で効率的な置換操作を習得

**開始ファイル**: `practice/start/replace-practice.js`

**タスク**:
1. すべての `var` を `const` に置換
2. `oldFunction` を `newFunction` に置換
3. `console.log` を `console.debug` に置換
4. API URLの `v1` を `v2` に更新

**推奨コマンド**:
- `:s/old/new/` - 現在行で置換
- `:%s/old/new/g` - ファイル全体で置換
- `:%s/old/new/gc` - 確認しながら置換

## 練習3: 正規表現を使った高度な検索

**目標**: 正規表現パターンで柔軟な検索を実行

**開始ファイル**: `practice/start/codebase-sample.js`

**タスク**:
1. すべての関数定義を検索: `/^function\s\+\w\+`
2. TODO/FIXMEコメントを検索: `/\(TODO\|FIXME\)`
3. コンソール出力を検索: `/console\.\(log\|error\|debug\)`
4. 数値を検索: `/\d\+`
5. メールアドレス形式を検索: `/\w\+@\w\+\.\w\+`

**発展課題**:
- エラーハンドリング関連のコードを検索
- 非同期関数（async/await）を検索
- 設定値（config）関連を検索

## 練習4: 範囲指定での置換

**目標**: 特定の範囲でのみ置換を実行

**開始ファイル**: `practice/start/codebase-sample.js`

**タスク**:
1. 1-50行目のみで `console.log` を `console.info` に置換
2. UserManagerクラス内のみで変数名を変更
3. ビジュアルモードで関数を選択して置換を実行

**コマンド例**:
- `:1,50s/console\.log/console.info/g`
- `V}` でブロック選択後 `:s/old/new/g`
- `:'<,'>s/old/new/gc` で選択範囲内置換

## 練習5: 複雑な正規表現パターン

**目標**: 実際の開発で使える高度なパターンマッチング

**開始ファイル**: `practice/start/replace-practice.js`

**タスク**:

### 1. 関数をアロー関数に変換
```javascript
// 変換前
function add(a, b) {
    return a + b;
}

// 変換後  
const add = (a, b) => {
    return a + b;
}
```

**置換コマンド**: `:%s/function \(\w\+\)(\(.*\))/const \1 = (\2) =>/g`

### 2. 電話番号形式の統一
```javascript
// (123) 456-7890 → 123-456-7890
```

**置換コマンド**: `:%s/(\(\d\{3\}\)) \(\d\{3\}\)-\(\d\{4\}\)/\1-\2-\3/g`

### 3. 日付形式の変換
```javascript
// MM/DD/YYYY → YYYY-MM-DD
```

**置換コマンド**: `:%s/\(\d\{2\}\)\/\(\d\{2\}\)\/\(\d\{4\}\)/\3-\1-\2/g`

## 練習6: 検索と編集の組み合わせ

**目標**: 検索結果を利用した効率的な編集

**開始ファイル**: `practice/start/codebase-sample.js`

**テクニック**:

### 1. 検索→置換→繰り返しパターン
```vim
/console\.log           " console.logを検索
cgn console.debug<ESC>  " 見つかった部分を置換
n.                      " 次を検索して繰り返し
```

### 2. 複数箇所の一括編集
```vim
/TODO                   " TODOを検索
cgn DONE<ESC>          " TODOをDONEに変更
n.                      " 次のTODOも変更
```

### 3. ビジュアルモードとの組み合わせ
```vim
v/pattern<Enter>        " パターンまで選択
:s/old/new/            " 選択範囲内で置換
```

## チャレンジ問題

### チャレンジ1: リファクタリング自動化

**目標**: 1つのファイル全体を正規表現で効率的にリファクタリング

**タスク**: `practice/start/replace-practice.js` を以下のように変換：
1. すべての `var` を `const` または `let` に変換
2. 関数宣言をアロー関数に変換
3. 文字列連結をテンプレートリテラルに変換
4. コールバックをasync/awaitに変換

### チャレンジ2: ログレベルの一括変更

**目標**: 条件に応じて異なる置換を実行

**条件**:
- `console.log` → `console.info` (情報レベル)
- `console.error` → `logger.error` (エラーレベル)
- `console.debug` → `logger.debug` (デバッグレベル)

### チャレンジ3: インポート文の最適化

**タスク**: 複数のインポート文を整理
```javascript
// 変換前
import React from 'react';
import { useState } from 'react';
import { useEffect } from 'react';

// 変換後
import React, { useState, useEffect } from 'react';
```

## 自己評価チェックリスト

以下の操作が効率的にできるようになったか確認：

- [ ] `/` と `?` による前方・後方検索
- [ ] `*` と `#` による単語検索
- [ ] `n` と `N` による検索ナビゲーション
- [ ] `:s` による基本的な置換
- [ ] `:%s` によるファイル全体の置換
- [ ] `gc` フラグを使った安全な置換
- [ ] 基本的な正規表現パターンの使用
- [ ] 範囲指定での置換操作
- [ ] 検索履歴の活用
- [ ] 実際のコードでの検索・置換の実践

## 次のステップへの準備

検索・置換をマスターしたら、次は複数ファイルでの操作です：

- ファイル間の検索（grep、Telescope）
- プロジェクト全体での一括置換
- 検索結果でのナビゲーション
- より高度な正規表現テクニック

これらのスキルは次のレッスン「ファイル・ウィンドウ操作」で活用していきます！