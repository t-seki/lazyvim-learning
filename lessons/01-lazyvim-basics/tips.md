# 💡 LazyVim 基本操作のコツ

**このファイルについて**: [quick-start.md](quick-start.md) や [guided-practice.md](guided-practice.md) で基本操作を学んだ後に、さらなる効率化のコツを学べます。

## 🚀 効率アップのコツ

### 1. which-keyを活用する

**基本原則**: 迷ったら`<Space>`を押す

```
覚えられないコマンド → <Space>を押してメニューから選択
慣れてきたコマンド → 直接キー入力で高速実行
```

**おすすめ練習法**:
- 毎日3つ新しいコマンドをwhich-keyから発見
- よく使うコマンドはキーシーケンスを覚える
- カテゴリ別に段階的に習得（f→g→w→x）

### 2. ファイル操作の使い分け

| 状況 | 推奨方法 | キー |
|------|----------|------|
| ファイル構造を見たい | Neo-tree | `<leader>e` |
| ファイル名がわかっている | Telescope | `<leader>ff` |
| 最近編集したファイル | Recent files | `<leader>fr` |
| 開いているファイル一覧 | Buffer list | `<leader>fb` |

### 3. 検索の使い分け

| 目的 | ツール | キー | 備考 |
|------|--------|------|------|
| ファイル名検索 | Telescope | `<leader>ff` | 部分一致OK |
| Gitファイル検索 | Find Files (git-files) | `<leader>fg` | Git管理下ファイル |
| プロジェクト内容検索 | Grep (Root Dir) | `<leader>/` | 正規表現対応 |
| シンボル検索 | Goto Symbol (Aerial) | `<leader>ss` | 関数・変数名 |

### 4. モード切り替えのコツ

**基本原則**: 迷ったら`<Esc>`でNormalモードに戻る

```
Normal → Insert: i, a, o, O
Insert → Normal: <Esc>
Normal → Visual: v, V, <C-v>
Visual → Normal: <Esc>
```

**練習法**:
- 編集中は頻繁にNormalモードに戻る習慣をつける
- `<Esc>`を押すのを恐れない
- モードがわからなくなったら`<Esc><Esc>`

## 🎯 よく使うキーシーケンス

### ファイル操作フロー

```
1. プロジェクト全体確認: <leader>e
2. ファイル検索: <leader>ff
3. Gitファイル検索: <leader>fg
4. ファイル開く: Enter
5. 編集: i (Insert mode)
6. 保存: <Esc> :w <Enter>
```

### Git操作フロー

```
1. Git状態確認: <leader>gg
2. ファイル変更確認: j/k で移動
3. ステージング: s
4. コミット: c
5. プッシュ: P
```

### コード編集フロー

```
1. 定義ジャンプ: gd
2. ドキュメント確認: K
3. 編集: i/a/o
4. 元の場所に戻る: <C-o>
5. 参照確認: gr
```

## 🛠️ カスタマイズのヒント

### 1. よく使うキーマップを追加

`~/.config/nvim/lua/config/keymaps.lua`に追加：

```lua
-- 個人的によく使うコマンド
vim.keymap.set("n", "<leader>t", ":terminal<CR>", { desc = "Terminal" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" })
```

### 2. which-keyグループを追加

```lua
local wk = require("which-key")
wk.register({
  ["<leader>m"] = {
    name = "My Commands",
    t = { ":terminal<CR>", "Terminal" },
    n = { ":enew<CR>", "New File" },
  }
})
```

## 🔍 デバッグ・トラブルシューティング

### 1. 動作しないときの確認項目

**キーマップが効かない**:
```vim
:verbose map <leader>ff  " キーマップの確認
:checkhealth telescope   " Telescopeの状態確認
```

**プラグインが動作しない**:
```vim
:Lazy                   " プラグイン管理画面
:Lazy sync              " プラグイン同期
:checkhealth            " 全体的なヘルスチェック
```

### 2. ログ確認

```vim
:messages              " メッセージ履歴
:lua vim.notify("test") " 通知テスト
```

## 📚 学習進捗の記録

### 1. 日次チェックリスト

毎日以下を確認：
- [ ] which-keyで新しいコマンドを1つ発見
- [ ] Telescopeで検索を3回実行
- [ ] Neo-treeでファイル操作を実行
- [ ] Gitコマンドを1つ実行

### 2. 週次レビュー

毎週以下を確認：
- [ ] 覚えたキーマップをリストアップ
- [ ] よく使うワークフローを最適化
- [ ] 新しいプラグインや機能を調査
- [ ] 設定ファイルをバックアップ

## 🚨 よくある間違い

### 1. モード混乱

**問題**: どのモードにいるかわからない
**解決**: ステータスラインでモード確認、迷ったら`<Esc>`

### 2. キー入力ミス

**問題**: `<leader>`キーを間違える
**解決**: LazyVimでは`<Space>`が`<leader>`

### 3. 検索結果が出ない

**問題**: Telescopeで何も見つからない
**解決**: 正しいディレクトリにいるか確認、大文字小文字を確認

### 4. ファイルが保存されない

**問題**: 編集内容が保存されない
**解決**: `:w`で明示的に保存、自動保存設定を確認

## 💪 上達のための練習法

### 1. デイリールーチン

毎日10分間：
1. 新しいファイルを作成
2. 既存ファイルを検索して編集
3. Git操作を実行
4. ヘルプで何かを調べる

### 2. 実際のプロジェクトで練習

- 小さなプロジェクトを作成
- READMEファイルの編集
- シンプルなスクリプトの作成
- Gitでバージョン管理

### 3. チャレンジ課題

- 5分でファイル作成→編集→コミット
- キーマップだけでマウス使わずに操作
- ヘルプだけで新機能を学習

## 🎉 次のレベルへ

基本操作に慣れたら：

1. **[02-efficient-editing](../02-efficient-editing/)**: LSPやTreesitterを活用した編集機能
2. **[03-search-navigation](../03-search-navigation/)**: TelescopeとLSP統合検索
3. **[04-project-management](../04-project-management/)**: プロジェクト管理とセッション機能

**重要**: 基礎をしっかり固めてから次に進むことが上達の秘訣です！

---

💡 **覚えておきたい**: 完璧を求めず、毎日少しずつ練習することが一番の上達法です。