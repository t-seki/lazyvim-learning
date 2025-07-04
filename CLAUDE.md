れている
- [ ] 実際の開発シナリオに即している

### プロジェクト品質チェックリスト
- [ ] TypeScriptコンパイルエラーがない
- [ ] npm scripts（dev, test, build）が正常動作する
- [ ] LSP（TypeScript Language Server）が適切に動作する
- [ ] 各種プラグインでプロジェクトが正しく認識される
- [ ] Git履歴と.gitignoreが適切に設定されている

### プラグイン互換性チェックリスト
- [ ] Lazy.nvim で管理されたプラグインとの互換性確認
- [ ] telescope.nvim でのファイル・関数検索動作確認
- [ ] LSP機能（補完、エラー表示、定義ジャンプ）動作確認
- [ ] Git統合プラグインの動作確認

## 参考資料
- [Lazy.nvim公式ドキュメント](https://github.com/folke/lazy.nvim)
- [nvim-lspconfig設定例](https://github.com/neovim/nvim-lspconfig)
- [telescope.nvim使用例](https://github.com/nvim-telescope/telescope.nvim)
- [Modern Neovim設定例](https://github.com/LazyVim/LazyVim)

## 注意事項
- ユーザーの既存Lazy.nvim設定への影響を最小限に抑える
- 推奨プラグイン構成のドキュメント化と設定例の提供
- プラグインバージョンの互換性に注意
- 進捗管理やユーザーデータの永続化は行わない
- 自動判定機能は実装せず、ユーザーの自主学習に委ねる
- プラグイン設定の変更は学習スコープ外（既存設定を前提とする）s.js**: 標準的なルーティングとミドルウェア構成
- **エラーハンドリング**: 適切な例外処理とHTTPステータスコード
- **テスタビリティ**: Jest/Supertest対応の単体・統合テスト構成

## 学習コンテンツ設計

### 基本編（vim/neovim操作）
1. **基本移動・編集** (01-basic-movement)
   - 目標: vimモード、hjkl移動、基本編集操作の習得
   - 練習素材: シンプルなテキストファイル

2. **編集の基礎** (02-editing-fundamentals)
   - 目標: 効率的な移動・編集コマンドの習得
   - 練習素材: 構造化されたコードファイル

3. **検索・置換** (03-search-replace)
   - 目標: 検索・置換パターンと正規表現の活用
   - 練習素材: 複数パターンを含むソースコード

4. **ファイル・ウィンドウ操作** (04-file-navigation)
   - 目標: マルチファイル環境での効率的なナビゲーション
   - 練習素材: 小規模なマルチファイルプロジェクト

### 実践編（モダンNeovim環境）
5. **LSP基本操作** (05-lsp-basics)
   - 目標: **nvim-lspconfig**と**nvim-cmp**を使った開発効率化
   - 練習素材: TypeScript関数群（型エラーありのサンプル）

6. **Telescope活用** (06-telescope-mastery)
   - 目標: **telescope.nvim**でのプロジェクトナビゲーション
   - 練習素材: 中規模TypeScriptプロジェクト

7. **Git統合ワークフロー** (07-git-workflow)
   - 目標: **gitsigns.nvim**と**lazygit.nvim**でのGit操作
   - 練習素材: Git履歴のあるプロジェクト

8. **プロジェクト開発総合** (08-project-development)
   - 目標: 全プラグインを統合した実際の開発ワークフロー
   - 練習素材: TypeScript TODO APIプロジェクト

### 学習タスク例パターン
- **基本操作タスク**: 「特定の関数名を効率的に変更」
- **LSP活用タスク**: 「型エラーを修正し、自動補完を活用してコードを完成」
- **Telescope活用タスク**: 「プロジェクト内の特定の実装箇所を検索して修正」
- **Git統合タスク**: 「変更をステージングしてコミット、差分確認」
- **総合開発タスク**: 「新機能の実装（API設計→実装→テスト→Git管理）」

## 実装優先順位

### Phase 1: 基本編レッスン作成
1. レッスンテンプレートの確立と推奨Lazy.nvim設定例
2. 01-basic-movement の完全実装
3. 02-04 基本編レッスンの実装

### Phase 2: 実践編プラグインレッスン
1. TypeScript TODO APIプロジェクトの基本実装
2. 05-lsp-basics の実装
3. 06-telescope-mastery の実装

### Phase 3: 統合ワークフロー
1. 07-git-workflow の実装
2. 08-project-development の実装
3. 学習タスクの充実と上級テクニック追加

## 品質保証

### レッスン品質チェックリスト
- [ ] 学習目標とプラグイン前提が明確に定義されている
- [ ] 操作手順例が推奨プラグイン構成で動作する
- [ ] 練習用ファイルが適切に用意されている
- [ ] プラグイン間の連携方法が説明さscope.nvim (ファジーファインダー)
- nvim-treesitter (シンタックスハイライト・パーサー)

**開発効率プラグイン**:
- neo-tree.nvim または nvim-tree.lua (ファイルエクスプローラー)
- gitsigns.nvim (Git統合)
- lazygit.nvim (Git UI統合)
- which-key.nvim (キーマッピングヘルプ)

### TypeScript TODO APIプロジェクト仕様
**プロジェクト名**: TypeScript TODO API
**機能**: REST API, 認証, バリデーション, テスト

**ファイル構成**:
```
sample-projects/typescript-todo-api/
├── package.json
├── tsconfig.json
├── src/
│   ├── app.ts                      # Express アプリケーション
│   ├── routes/
│   │   ├── todos.ts                # TODO API ルート
│   │   └── users.ts                # ユーザー API ルート
│   ├── models/
│   │   ├── Todo.ts                 # TODO モデル
│   │   └── User.ts                 # ユーザー モデル
│   ├── middleware/
│   │   ├── auth.ts                 # 認証ミドルウェア
│   │   └── validation.ts           # バリデーション
│   └── utils/
│       ├── database.ts             # DB接続
│       └── logger.ts               # ロギング
├── tests/                          # テストファイル
└── docs/                           # API ドキュメント
```

## 開発ガイドライン

### レッスンコンテンツ作成原則
1. **段階的学習**: 基本操作 → プラグイン活用 → 統合ワークフロー
2. **実践重視**: 実際の開発作業でよく使用されるパターンを優先
3. **プラグイン統合**: 各プラグインの単独使用と組み合わせ使用の両方を解説
4. **即座の確認**: ユーザーが操作結果とプラグインの効果をすぐに確認できる構成

### Markdownドキュメント規約
- **見出し**: H1: レッスンタイトル、H2: セクション、H3: 具体的操作・プラグイン機能
- **コードブロック**: vim操作は\`\`\`vim、キーマップは\`\`\`lua、TypeScriptコードは\`\`\`typescript
- **キーバインド表記**: \`<leader>ff\`、\`:Telescope find_files\`のようにバッククォートで囲む
- **プラグイン言及**: 初出時に**太字**でプラグイン名を記載
- **注意事項**: > 引用ブロックで前提条件やトラブルシューティング情報

### TypeScriptコード規約
- **命名**: camelCase、明確で説明的な名前
- **型安全**: strictモード、明示的な型定義
- **Expres (補完エンジン)
- tele# CLAUDE.md - Lazy.nvimベース Neovim開発環境学習アプリ開発ガイド

## プロジェクト概要
Lazy.nvimでセットアップされたモダンなNeovim開発環境で、vim/neovimの基本操作から実際のプロジェクト開発での実践的な使い方までを学習できるローカル実行型学習アプリケーション。
ユーザーは実際のNeovimとLazy.nvim管理下のプラグインを使用して、段階的に構造化されたカリキュラムで効率的な開発ワークフローを習得する。

## 要件サマリー

### 前提条件
- **実行環境**: Lazy.nvimベースのNeovim環境（ローカル）
- **対象ユーザー**: プログラマー（初心者〜上級者）
- **プラグイン**: LSP、Telescope、Treesitter、Neo-tree等の人気プラグインセット
- **スコープ外**: Lazy.nvim環境構築、進捗管理、自動判定、ゲーミフィケーション（MVP）

### 提供内容
- vim/neovim基本操作からモダンプラグイン活用までの解説
- 実践的な開発ワークフローのステップバイステップガイド
- TypeScript TODO APIプロジェクトでの総合的な開発作業体験

## アーキテクチャ設計

### ディレクトリ構成
```
neovim-dev-learning/
├── README.md                        # プロジェクト全体ガイド
├── docs/                            # 設計ドキュメント
├── lessons/                         # 学習コンテンツ
│   ├── 01-basic-movement/           # 基本移動・編集
│   ├── 02-editing-fundamentals/     # 編集の基礎
│   ├── 03-search-replace/           # 検索・置換
│   ├── 04-file-navigation/          # ファイル・ウィンドウ操作
│   ├── 05-lsp-basics/              # LSP基本操作
│   ├── 06-telescope-mastery/        # Telescope活用
│   ├── 07-git-workflow/            # Git統合ワークフロー
│   └── 08-project-development/      # 総合的なプロジェクト開発
├── sample-projects/                 # 練習用プロジェクト
│   └── typescript-todo-api/         # TypeScript TODO API
├── config/                         # 推奨設定例
│   └── lazy-setup-example/         # Lazy.nvim設定例
├── scripts/                        # セットアップ・ユーティリティ
└── templates/                      # レッスンテンプレート
```

### レッスン構成標準
```
{lesson-number}-{lesson-name}/
├── README.md                       # レッスン概要・目標・前提知識
├── guide.md                       # 詳細な操作解説・プラグイン説明
├── practice/                      # 練習用ファイル
│   ├── start/                     # 開始時の状態
│   └── examples/                  # 操作手順例の結果
└── exercises.md                   # 練習問題と実践的ワークフロー例
```

## 技術仕様

### 必須プラグイン環境
**プラグインマネージャー**:
- Lazy.nvim

**コア機能プラグイン**:
- nvim-lspconfig (LSP設定)
- nvim-cmp
