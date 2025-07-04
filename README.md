# LazyVim 学習アプリケーション

LazyVimディストリビューションを使って、vim/neovimの基本操作から実際のプロジェクト開発での実践的な使い方までを学習できるアプリケーションです。

## 🎯 対象者

- **完全初心者**: vim/neovimを触ったことがない人
- **中級者**: 基本は知ってるけどモダンな開発環境での活用法を学びたい人
- **上級者**: LazyVim環境でのより効率的なワークフローを身につけたい人

## 📚 学習内容

### Phase 1: LazyVim基礎編
- **01. LazyVim基本**: LazyVimの概要とナビゲーション
- **02. ファイル管理**: Telescope、Neo-tree、Buffer管理
- **03. コーディング機能**: LSP、補完、フォーマッティング
- **04. Git統合**: LazyGitとGit統合機能

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

## 📂 プロジェクト構成

```
lazyvim-learning/
├── lessons/                    # レッスンコンテンツ
│   ├── 01-lazyvim-basics/      # LazyVim基本操作
│   ├── 02-file-management/     # ファイル管理（Telescope/Neo-tree）
│   ├── 03-coding-features/     # コーディング機能（LSP/補完）
│   └── 04-git-workflow/        # Git統合（LazyGit）
├── config/                     # カスタマイズ例
│   └── lazyvim-customization/  # LazyVimカスタマイズ例
└── README.md                   # このファイル
```

## 📝 各レッスンの構成

```
XX-lesson-name/
├── README.md        # レッスン概要・学習目標
├── guide.md         # 詳細な操作解説
├── practice/        # 練習用ファイル
│   ├── start/       # 開始時の状態
│   └── examples/    # 操作例の結果
├── exercises.md     # 練習問題
└── tips.md         # ヒントとよくある間違い
```

## 🎓 学習のコツ

1. **実際に手を動かす**: 読むだけでなく、必ずLazyVimで操作してみる
2. **which-keyを活用**: `<Space>`キーでヘルプを表示して覚える
3. **段階的に進める**: LazyVimの標準機能をマスターしてからカスタマイズへ
4. **プロジェクトベース学習**: 実際のコードで練習する

## 🤝 貢献

このプロジェクトへの貢献を歓迎します！
- バグ報告や機能提案は[Issues](https://github.com/yourusername/neovim-dev-learning/issues)へ
- プルリクエストも歓迎します

## 📄 ライセンス

MIT License

---

Happy Vimming! 🚀