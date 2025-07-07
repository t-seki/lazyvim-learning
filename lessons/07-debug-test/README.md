# レッスン7: デバッグ・テスト統合 - DAP・neotest活用

## 概要
このレッスンでは、LazyVimでのデバッグとテストの統合環境を構築し、プロフェッショナルな開発ワークフローを確立します。Debug Adapter Protocol (DAP)による強力なデバッグ機能と、neotestによる効率的なテスト実行環境をマスターします。

## 学習目標

### 主要目標
- [ ] nvim-dapを使ったデバッグ環境の構築と操作をマスターする
- [ ] ブレークポイント、ステップ実行、変数確認の効率的な活用
- [ ] neotestによるテスト統合と実行環境の構築
- [ ] TDD/BDDワークフローの実践

### 具体的なスキル
- [ ] 言語別デバッガーの設定と起動
- [ ] 条件付きブレークポイントと例外ブレークポイント
- [ ] デバッグセッション中の変数・スタック・スコープの確認
- [ ] テストの発見、実行、結果の確認
- [ ] カバレッジ情報の表示と分析

## 前提知識
- LazyVimの基本操作とLSP機能（レッスン1-6完了）
- 各言語のデバッグツールの基本知識
- 単体テストの概念と基本的な書き方
- プログラミング言語の実行環境の理解

## 学習内容

### 1. nvim-dap（Debug Adapter Protocol）
- DAPの概念とアーキテクチャ
- 言語別デバッガーアダプターの設定
- ブレークポイントの設定と管理
- ステップ実行（step over, step into, step out）
- 変数・ウォッチ・コールスタック表示

### 2. デバッグセッションの実践
- デバッグ設定（launch configuration）の作成
- アタッチとランチの使い分け
- 条件付きブレークポイント
- 例外ブレークポイント
- REPL（評価式）の活用

### 3. neotest統合
- テストフレームワークの自動認識
- テストの発見と実行
- テスト結果の確認と分析
- カバレッジ表示
- テスト駆動開発（TDD）ワークフロー

### 4. 言語別のデバッグ・テスト環境
- **TypeScript/JavaScript**: Node.js、Jest、Vitest
- **Python**: debugpy、pytest、unittest
- **Go**: delve、go test
- **Rust**: lldb、cargo test

## 練習環境
- `practice/typescript-project/` - TypeScript/Jest プロジェクト
- `practice/python-project/` - Python/pytest プロジェクト
- `practice/debugging-scenarios/` - 様々なデバッグシナリオ

## 推定学習時間
- 基礎理解: 45分
- 実践練習: 120分
- 応用設定: 45分
- 合計: 約3時間30分

## 次のステップ
このレッスン完了後は、以下のレッスンへ進むことを推奨します：
- レッスン8: LazyVimカスタマイズ
- レッスン9: 高度なワークフロー

## 補足リソース
- [nvim-dap Documentation](https://github.com/mfussenegger/nvim-dap)
- [neotest Documentation](https://github.com/nvim-neotest/neotest)
- [Debug Adapter Protocol](https://microsoft.github.io/debug-adapter-protocol/)