# Neovim 開発環境学習アプリケーション

モダンなNeovim開発環境（Lazy.nvimベース）で、vim/neovimの基本操作から実際のプロジェクト開発での実践的な使い方までを学習できるアプリケーションです。

## 🎯 対象者

- **完全初心者**: vim/neovimを触ったことがない人
- **中級者**: 基本は知ってるけどモダンな開発環境での活用法を学びたい人
- **上級者**: Lazy.nvim環境でのより効率的なワークフローを身につけたい人

## 📚 学習内容

### 基本編（vim/neovim操作）
- **01. 基本移動・編集**: モード概念、hjkl移動、基本編集
- **02. 編集の基礎**: 効率的な移動、コピー・ペースト
- **03. 検索・置換**: 検索、置換操作
- **04. ファイル・ウィンドウ操作**: バッファ、ウィンドウ、タブの概念と操作

### 実践編（開発準備中）
- **05. LSP基本操作**: コード補完、エラー確認、定義ジャンプ
- **06. Telescope活用**: ファイル検索、grep、LSP機能との連携
- **07. Git統合ワークフロー**: gitsigns、lazygitを使ったGit操作
- **08. プロジェクト開発総合**: 実際のTypeScriptプロジェクトでの開発作業

## 🚀 始め方

### 前提条件
- Neovim (>= 0.9.0) がインストール済み
- Lazy.nvimベースの設定が完了済み
- 基本的なプラグイン（LSP、Telescope、Treesitter等）がセットアップ済み

### 学習の開始
1. このリポジトリをクローン
```bash
git clone https://github.com/yourusername/neovim-dev-learning.git
cd neovim-dev-learning
```

2. 最初のレッスンから開始
```bash
cd lessons/01-basic-movement
nvim README.md
```

## 📂 プロジェクト構成

```
neovim-dev-learning/
├── lessons/                    # レッスンコンテンツ
│   ├── 01-basic-movement/      # 基本移動・編集
│   ├── 02-editing-fundamentals/# 基本編集操作
│   ├── 03-search-replace/      # 検索・置換
│   └── 04-file-navigation/     # ファイル・ウィンドウ操作
├── config/                     # 設定例
│   └── lazy-setup-example/     # 推奨Lazy.nvim設定
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

1. **実際に手を動かす**: 読むだけでなく、必ず自分で操作してみる
2. **繰り返し練習**: 筋肉記憶に定着するまで繰り返す
3. **段階的に進める**: 基本をマスターしてから次のレッスンへ
4. **カスタマイズは後回し**: まずは標準的な操作を習得

## 🤝 貢献

このプロジェクトへの貢献を歓迎します！
- バグ報告や機能提案は[Issues](https://github.com/yourusername/neovim-dev-learning/issues)へ
- プルリクエストも歓迎します

## 📄 ライセンス

MIT License

---

Happy Vimming! 🚀