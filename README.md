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

### 推奨学習パス

1. **01-lazyvim-basics** (必須)
   - LazyVimの基本操作とwhich-keyの活用
   - 各種ツール（Telescope、Neo-tree）の基本的な使い方
   - 見積時間: 60-75分

2. **02-efficient-editing** (重要)
   - LSPとTreesitterを活用した効率的な編集
   - 自動補完、スニペット、コメント機能
   - 見積時間: 60-75分

3. **03-search-navigation** (重要)
   - Telescopeを中心とした検索・ナビゲーション
   - LSP統合検索と安全な置換
   - 見積時間: 60-80分

4. **04-project-management** (応用)
   - プロジェクト管理とセッション機能
   - 大規模開発での効率的ワークフロー
   - 見積時間: 70-90分

### 学習のコツ

1. **実際に手を動かす**: 読むだけでなく、必ずLazyVimで操作してみる
2. **which-keyを活用**: `<Space>`キーでヘルプを表示して覚える
3. **段階的に進める**: LazyVimの標準機能をマスターしてからカスタマイズへ
4. **プロジェクトベース学習**: 実際のコードで練習する
5. **繰り返し練習**: 重要な操作は身につくまで反復する

### 各レッスンでの学習方法

1. **README.md**: レッスンの概要と目標を理解
2. **guide.md**: 詳細な操作方法を学習
3. **practice/**: 実際のファイルで操作練習
4. **exercises.md**: 段階的な練習問題で習熟度確認
5. **tips.md**: 効率的な使い方とトラブルシューティング

## 🤝 貢献

このプロジェクトへの貢献を歓迎します！
- バグ報告や機能提案は[Issues](https://github.com/yourusername/neovim-dev-learning/issues)へ
- プルリクエストも歓迎します

## 📄 ライセンス

MIT License

---

Happy Vimming! 🚀