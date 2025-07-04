# CLAUDE.md - LazyVim学習アプリケーション開発ガイド

## プロジェクト概要

LazyVimディストリビューションを基盤とした、vim/neovimの基本操作から実際のプロジェクト開発での実践的な使い方までを学習できるローカル実行型学習アプリケーション。
ユーザーは実際のLazyVim環境とその統合プラグインを使用して、段階的に構造化されたカリキュラムで効率的な開発ワークフローを習得する。

## 要件サマリー

### 前提条件
- **実行環境**: LazyVimベースのNeovim環境（ローカル）
- **対象ユーザー**: プログラマー（完全初心者〜上級者）
- **技術基盤**: LSP、Telescope、Treesitter、Neo-tree等のLazyVim統合プラグイン
- **スコープ外**: LazyVim環境構築、進捗管理、自動判定、ゲーミフィケーション（MVP）

### 提供内容
- LazyVim特化の基本操作から高度なプラグイン活用までの体系的解説
- 実践的な開発ワークフローのステップバイステップガイド
- 実際のコードベースでの練習とプロジェクト開発体験

## アーキテクチャ設計

### ディレクトリ構成
```
lazyvim-learning/
├── README.md                        # プロジェクト全体ガイド
├── CLAUDE.md                        # 開発ガイド（このファイル）
├── lessons/                         # 学習コンテンツ
│   ├── 01-lazyvim-basics/           # LazyVim基本操作・ナビゲーション
│   ├── 02-efficient-editing/        # 効率的編集操作（LSP・Treesitter）
│   ├── 03-search-navigation/        # 検索とナビゲーション（Telescope・LSP）
│   └── 04-project-management/       # プロジェクト管理（Neo-tree・Session）
├── config/                          # LazyVimカスタマイズ例
│   └── lazyvim-customization/       # 学習支援機能付きカスタマイズ
└── scripts/                         # セットアップ・ユーティリティ
```

### レッスン構成標準
```
{lesson-number}-{lesson-name}/
├── README.md                       # レッスン概要・目標・前提知識
├── guide.md                       # 詳細な操作解説・LazyVim機能説明
├── practice-files/                # 練習用ファイル
│   ├── sample.lua                 # Lua練習ファイル
│   └── sample.md                  # Markdown練習ファイル
├── exercises/                     # エクササイズ
│   └── exercise-01.md            # 段階的練習問題
└── tips.md                       # ヒントとトラブルシューティング
```

## 技術仕様

### LazyVim統合環境
**ディストリビューション**:
- LazyVim（完全セットアップ済み前提）

**コア機能プラグイン**:
- nvim-lspconfig (LSP設定)
- nvim-cmp (補完エンジン)
- telescope.nvim (ファジーファインダー)
- nvim-treesitter (シンタックスハイライト・構文解析)

**開発効率プラグイン**:
- neo-tree.nvim (ファイルエクスプローラー)
- gitsigns.nvim (Git統合)
- lazygit.nvim (Git UI統合)
- which-key.nvim (キーマッピングヘルプ)
- trouble.nvim (診断一覧)

**学習支援カスタマイズ**:
- project.nvim (プロジェクト管理)
- persistence.nvim (セッション管理)
- comment.nvim (コメント機能)
- toggleterm.nvim (ターミナル統合)

## 学習コンテンツ設計

### Phase 1: LazyVim基礎編（完成）

1. **LazyVim基本操作** (01-lazyvim-basics)
   - 目標: LazyVimの概要理解、which-key活用、基本ナビゲーション
   - 練習素材: シンプルなLua・Markdownファイル
   - 重要機能: which-key、Telescope基本、Neo-tree基本

2. **効率的編集操作** (02-efficient-editing)
   - 目標: LSP・Treesitter活用、自動補完・スニペット、コメント機能
   - 練習素材: 構造化されたコードファイル
   - 重要機能: LSPナビゲーション、Treesitterオブジェクト、nvim-cmp

3. **検索とナビゲーション** (03-search-navigation)
   - 目標: Telescope中心検索、LSP統合ナビゲーション、安全な置換
   - 練習素材: 複数パターンを含むプロジェクト
   - 重要機能: Telescope各種検索、LSP参照・定義、spectre.nvim

4. **プロジェクト管理** (04-project-management)
   - 目標: プロジェクト管理、セッション機能、大規模ワークフロー
   - 練習素材: マルチファイルプロジェクト構造
   - 重要機能: project.nvim、persistence.nvim、Neo-tree高度操作

### Phase 2: 実践編（開発準備中）
5. **コーディング機能**: LSP・補完・フォーマッティング深掘り
6. **デバッグ・テスト**: DAP、テスト統合
7. **カスタマイズ**: LazyVimのカスタマイズ方法
8. **高度なワークフロー**: 言語別最適化、チーム開発

### Phase 3: 実プロジェクト（開発準備中）
9. **TypeScript開発**: TypeScript開発の実践
10. **フルスタック開発**: フルスタック開発体験

## 開発ガイドライン

### レッスンコンテンツ作成原則
1. **LazyVim特化**: LazyVimの統合機能を最大限活用
2. **実践重視**: 実際の開発作業でよく使用されるパターンを優先
3. **段階的学習**: 基本操作 → プラグイン活用 → 統合ワークフロー
4. **即座の確認**: ユーザーが操作結果とプラグインの効果をすぐに確認できる構成

### Markdownドキュメント規約
- **見出し**: H1: レッスンタイトル、H2: セクション、H3: 具体的操作・プラグイン機能
- **コードブロック**: vim操作は```vim、キーマップは```lua、その他言語別に適切に記載
- **キーバインド表記**: `<leader>ff`、`:Telescope find_files`のようにバッククォートで囲む
- **プラグイン言及**: 初出時に**太字**でプラグイン名を記載
- **注意事項**: > 引用ブロックで前提条件やトラブルシューティング情報

### LazyVim学習支援機能
```lua
-- config/lazyvim-customization/lua/config/keymaps.lua
-- 学習専用キーマップ
vim.keymap.set("n", "<leader>ll", "lesson_browser", { desc = "Open lesson browser" })
vim.keymap.set("n", "<leader>lp", "learning_progress", { desc = "Show learning progress" })
vim.keymap.set("n", "<leader>lc", "mark_lesson_complete", { desc = "Mark lesson complete" })
vim.keymap.set("n", "<leader>lt", "random_tip", { desc = "Show random tip" })
vim.keymap.set("n", "<leader>l?", "emergency_help", { desc = "Emergency help" })
```

## 実装優先順位

### Phase 1: LazyVim基礎編（完成済み）
✅ 1. LazyVimカスタマイズ環境の構築
✅ 2. 01-lazyvim-basics の完全実装
✅ 3. 02-efficient-editing の実装（LSP・Treesitter中心）
✅ 4. 03-search-navigation の実装（Telescope・LSP統合）
✅ 5. 04-project-management の実装（Neo-tree・プロジェクト管理）

### Phase 2: 実践編レッスン（次期開発）
- [ ] TypeScript/JavaScript開発プロジェクトの準備
- [ ] 05-coding-features の実装
- [ ] 06-debug-test の実装

### Phase 3: 統合ワークフロー（将来開発）
- [ ] 07-customization の実装
- [ ] 08-advanced-workflow の実装
- [ ] 言語別最適化レッスンの追加

## 品質保証

### レッスン品質チェックリスト
- [x] 学習目標とLazyVim前提が明確に定義されている
- [x] 操作手順例がLazyVim標準構成で動作する
- [x] 練習用ファイルが適切に用意されている
- [x] プラグイン間の連携方法が説明されている
- [x] 実際の開発シナリオに即している

### プロジェクト品質チェックリスト
- [x] LazyVim標準機能との互換性確認
- [x] Telescope.nvim でのファイル・関数検索動作確認
- [x] LSP機能（補完、エラー表示、定義ジャンプ）動作確認
- [x] Git統合プラグインの動作確認
- [x] 学習支援カスタマイズの動作確認

### プラグイン互換性チェックリスト
- [x] LazyVim で管理されたプラグインとの互換性確認
- [x] telescope.nvim でのファイル・関数検索動作確認
- [x] LSP機能（補完、エラー表示、定義ジャンプ）動作確認
- [x] Neo-tree.nvim でのファイル管理動作確認
- [x] which-key.nvim での学習支援動作確認

## 参考資料
- [LazyVim公式ドキュメント](https://www.lazyvim.org/)
- [LazyVim GitHub](https://github.com/LazyVim/LazyVim)
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [Neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [nvim-lspconfig設定例](https://github.com/neovim/nvim-lspconfig)

## 注意事項
- ユーザーの既存LazyVim設定への影響を最小限に抑える
- 学習支援カスタマイズはオプション適用
- LazyVim標準機能を前提とした学習内容
- 進捗管理やユーザーデータの永続化は最小限
- 自動判定機能は実装せず、ユーザーの自主学習に委ねる
- プラグイン設定の大幅変更は学習スコープ外（LazyVim標準を前提とする）

## プロジェクト成果

### 完成した学習体系
LazyVimの強力な機能を段階的に習得できる完全な学習カリキュラムを構築：

1. **基礎固め**: which-key活用による直感的な操作習得
2. **編集効率化**: LSP・Treesitterによる現代的コード編集
3. **検索最適化**: Telescopeによる高速プロジェクトナビゲーション
4. **プロジェクト管理**: 大規模開発に対応したワークフロー習得

従来のvim学習から、LazyVimの統合開発環境を最大限活用する学習体系に進化させることで、現代的で実用的なNeovimスキルを効率的に身につけられる教材を実現。