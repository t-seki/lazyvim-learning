# レッスン8: LazyVimカスタマイズ - 個人用開発環境の構築

## 概要
このレッスンでは、LazyVimを自分の開発スタイルに合わせてカスタマイズする方法を学習します。設定ファイルの構造理解から、プラグインの追加・削除、キーマップの変更、カラースキームの設定まで、個人用の最適化された開発環境を構築するスキルを身につけます。

## 学習目標

### 主要目標
- [ ] LazyVimの設定構造を完全に理解する
- [ ] プラグインの追加・削除・設定変更をマスターする
- [ ] キーマップを自分の使いやすいようにカスタマイズできる
- [ ] 個人の開発ワークフローに最適化された環境を構築する

### 具体的なスキル
- [ ] lua/config/配下のファイル構造と役割の理解
- [ ] Lazy.nvimプラグインマネージャーの使い方
- [ ] プラグイン設定のオーバーライドと拡張
- [ ] 条件付き設定（OS、プロジェクト別）の実装
- [ ] 設定のバックアップと復元方法

## 前提知識
- LazyVimの基本操作（レッスン1-4完了）
- LSP・デバッグ・テストの基本操作（レッスン5-7）
- Luaプログラミングの基礎
- Git操作の基本

## 学習内容

### 1. LazyVim設定アーキテクチャ
- 設定ファイルの階層構造
- 初期化プロセスの理解
- プラグイン読み込み順序
- 設定の優先順位とオーバーライド

### 2. プラグイン管理
- Lazy.nvimプラグインマネージャーの詳細
- プラグインの追加・削除・無効化
- 依存関係の管理
- プラグイン設定のカスタマイズ

### 3. キーマップカスタマイズ
- 既存キーマップの変更・削除
- 新しいキーマップの追加
- モード別キーマップ設定
- which-key統合

### 4. 外観・UI カスタマイズ
- カラースキームの変更と設定
- ステータスライン・タブラインのカスタマイズ
- フォント・アイコン設定
- ウィンドウ・バッファ管理

### 5. 言語・プロジェクト別設定
- ファイルタイプ別設定
- プロジェクト固有設定
- 環境変数による条件分岐
- チーム設定との協調

## 練習環境
- `examples/basic-customization/` - 基本的なカスタマイズ例
- `examples/advanced-setup/` - 高度な設定例
- `examples/language-specific/` - 言語別カスタマイズ

## 推定学習時間
- 基礎理解: 60分
- 実践カスタマイズ: 90分
- 応用設定: 60分
- 合計: 約3時間30分

## 次のステップ
このレッスン完了後は、以下のレッスンへ進むことを推奨します：
- レッスン9: 高度なワークフロー
- 実際のプロジェクトでの実践的活用

## 補足リソース
- [LazyVim Configuration](https://www.lazyvim.org/configuration)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html)