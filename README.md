# LazyVim 学習アプリケーション

LazyVimディストリビューションを使って、vim/neovimの基本操作から実際のプロジェクト開発での実践的な使い方までを学習できるアプリケーションです。

## ✨ 特徴

- 🚀 **LazyVim特化**: LazyVimの強力な機能を最大限活用した学習カリキュラム
- 🎯 **実践重視**: 実際の開発作業を想定した練習とワークフロー
- 📈 **段階的学習**: 基本操作から高度な機能まで体系的にステップアップ
- 🔧 **学習支援**: カスタムキーマップとヒント機能でスムーズな学習体験
- 🏗️ **プロジェクトベース**: 実際のコード編集を通じた実用的なスキル習得

## 🎯 対象者

- **完全初心者**: vim/neovimを触ったことがない人
- **中級者**: 基本は知ってるけどモダンな開発環境での活用法を学びたい人
- **上級者**: LazyVim環境でのより効率的なワークフローを身につけたい人

## 📚 学習内容

### Phase 1: LazyVim基礎編（完成）
- **01. LazyVim基本操作**: LazyVimの概要、which-key、基本ナビゲーション
- **02. 効率的編集操作**: LSP・Treesitter活用、自動補完・スニペット
- **03. 検索とナビゲーション**: Telescope・LSP統合検索、安全な置換
- **04. プロジェクト管理**: Neo-tree・プロジェクト管理・セッション機能

### Phase 2: 実践編（開発準備中）
- **05. プロジェクト設定**: プロジェクト固有設定
- **06. デバッグ・テスト**: DAP、テスト統合
- **07. カスタマイズ**: LazyVimのカスタマイズ方法
- **08. 高度なワークフロー**: 高度な開発ワークフロー

### Phase 3: 実プロジェクト（開発準備中）
- **09. TypeScript開発**: TypeScript開発の実践
- **10. フルスタック開発**: フルスタック開発体験

## 🚀 始め方

### 前提条件
- Neovim (>= 0.9.0) がインストール済み
- **LazyVimが完全にセットアップ済み**
- Git、ripgrep、Node.js等の基本ツールがインストール済み

### LazyVimのセットアップ
LazyVimがまだセットアップされていない場合：

1. 既存のNeovim設定をバックアップ
```bash
mv ~/.config/nvim{,.bak}
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

2. LazyVimをインストール
```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

3. Neovimを起動してプラグインをインストール
```bash
nvim
```

### 学習の開始
1. このリポジトリをクローン
```bash
git clone https://github.com/yourusername/lazyvim-learning.git
cd lazyvim-learning
```

2. 最初のレッスンから開始
```bash
cd lessons/01-lazyvim-basics
nvim README.md
```

3. 学習支援機能を有効化（オプション）
```bash
# LazyVim学習支援カスタマイズを適用
cp -r config/lazyvim-customization/lua/* ~/.config/nvim/lua/
# Neovimを再起動してプラグインをインストール
nvim
```

**学習支援機能**:
- `<leader>ll` - レッスンブラウザー
- `<leader>lp` - 学習進捗表示
- `<leader>lt` - ランダムヒント
- `<leader>l?` - 緊急ヘルプ

## 📂 プロジェクト構成

```
lazyvim-learning/
├── lessons/                      # レッスンコンテンツ
│   ├── 01-lazyvim-basics/        # LazyVim基本操作・ナビゲーション
│   ├── 02-efficient-editing/     # 効率的編集操作（LSP・Treesitter）
│   ├── 03-search-navigation/     # 検索とナビゲーション（Telescope・LSP）
│   └── 04-project-management/    # プロジェクト管理（Neo-tree・Session）
├── config/                       # カスタマイズ例
│   └── lazyvim-customization/    # LazyVimカスタマイズ例
└── README.md                     # このファイル
```

## 📝 各レッスンの構成

```
XX-lesson-name/
├── README.md            # レッスン概要・学習目標
├── guide.md             # 詳細な操作解説
├── practice-files/      # 練習用ファイル
│   ├── sample.lua       # Lua練習ファイル
│   └── sample.md        # Markdown練習ファイル
├── exercises/           # エクササイズ
│   └── exercise-01.md   # 段階的練習問題
└── tips.md             # ヒントとトラブルシューティング
```

## 🔧 学習支援機能（オプション）

```
config/lazyvim-customization/
└── lua/
    ├── config/
    │   ├── options.lua      # 学習特化設定
    │   ├── keymaps.lua      # 学習支援キーマップ  
    │   └── autocmds.lua     # 学習環境自動化
    └── plugins/
        ├── learning.lua     # 学習支援プラグイン
        └── project.lua      # プロジェクト管理強化
```

## 🎓 学習の進め方

### 📋 Phase 1完了までの学習パス

```
┌──────────────────────────────────────┐
│         LazyVim学習の全体像          │
├──────────────────────────────────────┤
│  [Phase 1] LazyVim基礎習得           │
│  ├─ 01-lazyvim-basics     ⏱️ 1.5-2h  │ ← START HERE
│  ├─ 02-efficient-editing  ⏱️ 1.5-2h  │
│  ├─ 03-search-navigation  ⏱️ 1.5-2h  │
│  └─ 04-project-management ⏱️ 2-2.5h │ ← Phase 1 GOAL
│                                      │
│  総学習時間: 6.5-8.5時間            │
│  (実践含む/個人差あり)               │
│                                      │
│  [Phase 2] 実践編 (開発準備中)       │
│  [Phase 3] 実プロジェクト (開発準備中)│
└──────────────────────────────────────┘
```

### 📚 各レッスンの詳細ガイド

#### 1️⃣ 01-lazyvim-basics（必須・最初のステップ）
**目標**: LazyVimの基本操作をマスターし、which-keyとTelescope検索に慣れる

**学習内容**:
- LazyVimの概要理解とwhich-keyナビゲーション
- ファイル検索（`<leader>ff`）とテキスト検索（`<leader>/`）
- 基本的なLSP機能（定義ジャンプ、ドキュメント表示）

**学習時間**:
- ⚡ 速習コース: 30分（基本機能のみ）
- 📚 標準コース: 2時間（推奨）
- 🏆 完全マスター: 4時間（全機能習得）

**前提知識**: vimの基本（モード、移動、保存・終了）

---

#### 2️⃣ 02-efficient-editing（重要・編集スキル向上）
**目標**: LSPとTreesitterを活用した効率的なコード編集をマスターする

**学習内容**:
- LSP統合編集（エラー検出、自動修正、リファクタリング）
- Treesitterテキストオブジェクト（関数・クラス単位選択）
- 高機能自動補完とスニペット活用

**学習時間**:
- ⚡ 速習コース: 30分（基本LSP機能）
- 📚 標準コース: 75分（推奨）
- 🏆 完全マスター: 2時間（全編集機能）

**前提知識**: 01-lazyvim-basicsの完了

---

#### 3️⃣ 03-search-navigation（重要・検索マスター）
**目標**: Telescope・LSP・vim検索を統合した高速ナビゲーションを習得する

**学習内容**:
- Telescope検索システム（ファイル・テキスト・シンボル）
- LSP統合検索（定義・参照・実装ジャンプ）
- 安全で効率的な置換・リファクタリング

**学習時間**:
- ⚡ 速習コース: 30分（基本検索）
- 📚 標準コース: 80分（推奨）
- 🏆 完全マスター: 2時間（高度な検索・置換）

**前提知識**: 01-02レッスンの完了

---

#### 4️⃣ 04-project-management（応用・ワークフロー完成）
**目標**: 大規模プロジェクトでの効率的開発ワークフローを完成させる

**学習内容**:
- Neo-treeとTelescope連携によるプロジェクト管理
- セッション機能を活用した作業状態保存・復元
- ウィンドウ・タブ管理とターミナル統合

**学習時間**:
- ⚡ 速習コース: 40分（基本プロジェクト操作）
- 📚 標準コース: 90分（推奨）
- 🏆 完全マスター: 2.5時間（マルチプロジェクト管理）

**前提知識**: Phase 1の01-03レッスン完了

---

### 🎯 Phase 1完了の判定基準

以下をすべて達成できればPhase 1完了です：

**✅ 必須スキル**:
- [ ] which-keyで迷わずコマンド発見できる
- [ ] ファイル検索（`<leader>ff`）とテキスト検索（`<leader>/`）を日常的に使える
- [ ] LSP機能（`gd`, `gr`, `K`, `<leader>ca`）を活用できる
- [ ] Neo-treeでファイル管理ができる
- [ ] セッション機能（`<leader>qs`）を活用できる

**🌟 推奨スキル**:
- [ ] プロジェクト間の切り替えがスムーズにできる
- [ ] Treesitterオブジェクト（`af`, `if`）を使いこなせる
- [ ] 複雑な検索・置換パターンを実行できる

### 📖 各レッスン内での学習方法

```
📁 XX-lesson-name/
├── 📖 README.md           ← まずはここ: 概要・学習目標・時間見積
├── 🚀 quick-start.md      ← 5分体験: 重要機能の即座体験
├── 🎯 guided-practice.md  ← ステップ練習: 段階的な実践学習
├── 🏋️ exercises/          ← スキル検定: 体系的な習熟度確認
├── 📂 practice/           ← 自由練習: 実際のファイルで練習
└── 💡 tips.md             ← 効率化: 上級テクニックとトラブル解決
```

**推奨学習順序**:
1. **README.md** → 2. **quick-start.md** → 3. **guided-practice.md** → 4. **exercises/** → 5. **tips.md**

### 🚀 学習を成功させるコツ

1. **実際に手を動かす**: 読むだけでなく、必ずLazyVimで操作してみる
2. **which-keyを活用**: `<Space>`キーでヘルプを表示して覚える
3. **段階的に進める**: LazyVimの標準機能をマスターしてからカスタマイズへ
4. **プロジェクトベース学習**: 実際のコードで練習する
5. **繰り返し練習**: 重要な操作は身につくまで反復する
6. **時間を区切る**: 集中できる時間（30-60分）で区切って学習する

## 🤝 貢献

このプロジェクトへの貢献を歓迎します！
- バグ報告や機能提案は[Issues](https://github.com/yourusername/neovim-dev-learning/issues)へ
- プルリクエストも歓迎します

## 📄 ライセンス

MIT License

---

Happy Vimming! 🚀