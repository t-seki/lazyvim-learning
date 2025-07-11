# 01 - LazyVim 基本操作

## 🎯 このレッスンについて

LazyVimディストリビューションの基本操作を学習し、効率的な開発ワークフローを習得します。

### 学習の流れ（推奨順序）
1. **🚀 [quick-start.md](quick-start.md)** - 5分でLazyVimの核心機能を体験
2. **🎯 [guided-practice.md](guided-practice.md)** - ステップバイステップの実践練習
3. **🏋️ [exercises/exercise-01.md](exercises/exercise-01.md)** - 体系的なスキル検定
4. **💡 [tips.md](tips.md)** - 効率化のコツとトラブルシューティング

## 🎪 LazyVim とは？

**LazyVim = 即座に使える完全なNeovim開発環境**

### 従来のvim vs LazyVim

| 従来のvim | LazyVim |
|-----------|---------|
| 設定ファイルを自分で書く | **即座に使える設定済み** |
| プラグインを手動で管理 | **最適化されたプラグイン構成** |
| キーマップを覚える必要 | **which-keyで発見型操作** |
| IDE機能は別途設定 | **LSP・補完が標準装備** |

### LazyVim の主要機能

1. **which-key統合**: `<Space>`キーからすべての操作を発見可能
2. **高速検索**: Telescopeとripgrepによるファイル・テキスト検索
3. **LSP統合**: コード補完・エラー検出・リファクタリング支援

## 🗝️ 覚えるべき基本キーマップ

### 基本キーマップ

| キー | 機能 | 重要度 |
|------|------|-------|
| `<Space>` | which-keyメニュー | 高 |
| `<leader>ff` | ファイル検索 | 高 |
| `<leader>/` | プロジェクト検索 | 高 |

### よく使う操作（覚えると便利）

#### ファイル操作
| キー | 機能 | 説明 |
|------|------|------|
| `<leader>e` | Explorer Snacks | ファイルツリー表示 |
| `<leader>fg` | Find Files (git-files) | Git管理ファイル検索 |
| `<leader>fr` | Recent | 最近のファイル |
| `<leader>fb` | Buffers | 開いているファイル一覧 |

#### ナビゲーション・編集
| キー | 機能 | 説明 |
|------|------|------|
| `<leader>ss` | Goto Symbol (Aerial) | 関数・変数検索 |
| `gd` | Goto Definition | 定義ジャンプ |
| `gr` | References | 参照箇所表示 |
| `K` | Hover | ドキュメント表示 |
| `<leader>ca` | Code Action | 自動修正・リファクタリング |

#### ウィンドウ操作
| キー | 機能 | 説明 |
|------|------|------|
| `<C-h/j/k/l>` | ウィンドウ移動 | 左/下/上/右のウィンドウへ |
| `<leader>w` | Window commands | ウィンドウ関連操作 |
| `<leader><tab>` | Tab commands | タブ関連操作 |

#### Git操作
| キー | 機能 | 説明 |
|------|------|------|
| `<leader>gg` | GitUi (Root Dir) | LazyGit起動 |

## 🎨 LazyVim の UI コンポーネント

### 画面構成の理解

```
┌─────────────────────────────────────┐
│             タブライン               │ ← 開いているファイル一覧
├─────────────┬───────────────────────┤
│             │                       │
│  Neo-tree   │     メインエディタ     │ ← ファイル内容
│ (ファイル    │                       │
│  ツリー)    │                       │
│             │                       │
├─────────────┴───────────────────────┤
│            ステータスライン           │ ← モード・ファイル情報・Git状態
└─────────────────────────────────────┘
```

### 重要なUI要素

- **which-key**: `<Space>`で表示されるコマンドヘルプ
- **Telescope**: ファイル・テキスト検索のフローティングウィンドウ
- **Neo-tree**: 左サイドのファイルエクスプローラー
- **Trouble**: エラー・警告の一覧表示

## 🚀 学習アプローチ

### ⚡ 速習コース（30分）
1. **[quick-start.md](quick-start.md)** (5分) - 即座体験
2. **[guided-practice.md](guided-practice.md)** の第1-3部 (25分) - 基本操作

### 📚 標準コース（2時間）
1. **[quick-start.md](quick-start.md)** (5分)
2. **[guided-practice.md](guided-practice.md)** 全体 (50分)
3. **[exercises/exercise-01.md](exercises/exercise-01.md)** (45分)
4. **[tips.md](tips.md)** 流し読み (20分)

### 🏆 完全マスターコース（4時間）
- 上記標準コース + practice-filesでの自由練習 + カスタマイズ挑戦

## ⚡ LazyVim 設定ファイル構造

### 基本構造（参考情報）

```
~/.config/nvim/
├── init.lua              # エントリーポイント
├── lua/config/
│   ├── autocmds.lua      # 自動コマンド
│   ├── keymaps.lua       # カスタムキーマップ
│   ├── lazy.lua          # プラグインマネージャー設定
│   └── options.lua       # Neovim基本設定
├── lua/plugins/          # プラグイン個別設定
└── lazyvim.json          # LazyVim設定
```

**重要**: LazyVimは最初から完璧に設定されているので、カスタマイズは学習が進んでからで十分です。

## 🎯 実践的な使用例

### 開発作業での典型的なフロー

1. **プロジェクトを開く**: `nvim .`
2. **ファイル探索**: `<leader>e` でツリー表示
3. **ファイル検索**: `<leader>ff` で目的ファイル検索
4. **コード検索**: `<leader>/` で特定の関数・変数を検索
5. **編集**: LSP支援下での効率的コード編集
6. **Git操作**: `<leader>gg` でバージョン管理

### LazyVimが得意な場面

- **大規模プロジェクトでのファイル検索**
- **コードベース全体の理解（シンボル検索・参照検索）**
- **リファクタリング作業（LSP連携）**
- **Git管理下での効率的な開発**

## 📋 学習目標・前提知識

### 達成目標
- [ ] which-keyを使ったコマンド発見ができる
- [ ] ファイル検索・テキスト検索を使いこなせる
- [ ] 基本的な編集操作（移動・編集・保存）ができる
- [ ] LazyVimの設定構造を理解している
- [ ] LSP基本機能（定義ジャンプ・ドキュメント表示）を活用できる

### 前提知識
- vimの基本モード（Normal、Insert、Visual）
- 基本カーソル移動（h, j, k, l）
- ESCキーでNormalモードに戻る方法
- `:w`でファイル保存、`:q`で終了

**初心者の方**: 上記がわからなくても、guided-practiceで一緒に学習できます！

## 🏃‍♂️ 次のステップ

### このレッスン完了後の選択肢

1. **次のレッスンへ**: [02-efficient-editing](../02-efficient-editing/) で編集機能を深掘り
2. **実プロジェクト適用**: 自分のプロジェクトでLazyVimを使ってみる
3. **カスタマイズ挑戦**: [tips.md](tips.md)のカスタマイズ例を試す

### 学習継続のコツ

- **毎日10分**: 新しい操作を1つずつ覚える
- **実践重視**: 実際の作業でLazyVimを使う
- **コミュニティ活用**: LazyVim公式ドキュメント・コミュニティで情報収集

## ✅ 完了チェック

このレッスンを完了するには：

**必須項目**:
- [ ] quick-start.mdの3つの魔法を体験した
- [ ] guided-practice.mdで基本操作を練習した
- [ ] which-keyで5つ以上のコマンドを実行した
- [ ] ファイル検索とテキスト検索を使えるようになった

**推奨項目**:
- [ ] exercise-01.mdで体系的なスキル確認を完了した
- [ ] practice-filesで自由に練習した
- [ ] tips.mdで効率化のコツを確認した

**完了したら**: `<leader>lc` でレッスン完了をマーク！

## 📚 参考リンク

- [LazyVim公式ドキュメント](https://www.lazyvim.org/)
- [LazyVimキーマップ一覧](https://www.lazyvim.org/keymaps)
- [which-key.nvim使い方](https://github.com/folke/which-key.nvim)

---

**重要**: 操作に迷った場合は`<Space>`キーでwhich-keyメニューを表示し、必要なコマンドを探してください。