# LazyVim カスタマイズ例

このディレクトリには、LazyVim学習アプリケーションで使用するLazyVimカスタマイズ例が含まれています。

## 📋 前提条件

- **LazyVimが既にインストール済み**であることを前提としています
- 基本的なLazyVim操作に慣れていることを推奨

## 🎯 カスタマイズの方針

LazyVimは既に完璧に設定された環境です。このカスタマイズ例では：

1. **学習に特化した設定**: 学習効率を高める設定
2. **日本語環境の最適化**: 日本語コメント、ドキュメント対応
3. **プロジェクト開発向け調整**: 実際の開発作業に即した設定
4. **段階的カスタマイズ**: 初心者から上級者まで対応

## 📁 カスタマイズファイル構成

```
config/lazyvim-customization/
└── lua/
    ├── config/
    │   ├── options.lua      # 学習特化オプション設定
    │   ├── keymaps.lua      # 学習支援キーマップ
    │   └── autocmds.lua     # 学習環境自動コマンド
    └── plugins/
        ├── learning.lua     # 学習支援プラグイン強化
        └── project.lua      # プロジェクト管理強化
```

**適用後の ~/.config/nvim/ 構成**:
```
~/.config/nvim/lua/
├── config/              # LazyVim標準 + 学習支援追加
│   ├── autocmds.lua     # 学習環境自動コマンド (追加)
│   ├── keymaps.lua      # 学習支援キーマップ (追加)  
│   ├── options.lua      # 学習特化オプション (追加)
│   └── ...              # LazyVim標準ファイル
└── plugins/             # LazyVim標準 + 学習支援追加
    ├── learning.lua     # 学習支援プラグイン (追加)
    ├── project.lua      # プロジェクト管理強化 (追加)
    └── ...              # LazyVim標準プラグイン
```

## 🚀 適用方法

### 1. バックアップ作成

既存のLazyVim設定をバックアップ：

```bash
cp -r ~/.config/nvim ~/.config/nvim.backup
```

### 2. カスタマイズファイルの適用

```bash
# このディレクトリのファイルをLazyVim設定に追加
cp -r config/lazyvim-customization/lua/* ~/.config/nvim/lua/
```

### 3. Neovimの再起動

```bash
nvim
```

初回起動時に追加プラグインが自動インストールされます。

## ⚙️ 主なカスタマイズ内容

### 学習支援機能

- **which-key強化**: より詳細なキーマップガイド
- **学習進捗管理**: レッスンの進捗追跡
- **ヒント表示**: 初心者向けのヒント機能
- **キーストローク記録**: 操作の振り返り機能

### 学習環境最適化

- **日本語表示対応**: 日本語コメント・ファイル名の完全サポート
- **視覚的学習支援**: ヤンクハイライト延長、キーストローク表示
- **学習進捗管理**: レッスン完了追跡、セッション復元
- **自動ヒント表示**: ファイルタイプ別の学習ヒント

### プロジェクト開発強化

- **プロジェクト自動検出**: Git、package.json、Cargo.toml等の認識
- **セッション管理**: 作業状態の自動保存・復元
- **ターミナル統合**: フローティング・分割ターミナル
- **タスクランナー**: プロジェクト別タスク実行環境

## 🎨 カスタマイズ例

### 1. 学習モードの有効化

```lua
-- lua/config/options.lua
vim.g.learning_mode = true
vim.g.show_hints = true
vim.g.track_keystrokes = true
```

### 2. 学習支援キーマップの活用

```lua
-- lua/config/keymaps.lua
-- 学習専用キーマップが自動で利用可能
-- <leader>ll - レッスンブラウザー
-- <leader>lp - 学習進捗表示
-- <leader>lt - ランダムヒント
-- <leader>l? - 緊急ヘルプ
```

### 3. プロジェクト管理の設定

```lua
-- lua/plugins/project.lua
return {
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        patterns = { ".git", "package.json", "Cargo.toml", "go.mod" },
      })
    end,
  }
}
```

## 🔧 トラブルシューティング

### カスタマイズが反映されない

1. LazyVimキャッシュのクリア：
```vim
:Lazy clear
:Lazy reload
```

2. 設定ファイルの構文チェック：
```vim
:luafile ~/.config/nvim/lua/config/options.lua
```

### プラグインの競合

LazyVimの既存プラグインとの競合を避けるため：

```lua
-- 既存プラグインを無効化
return {
  { "existing-plugin", enabled = false },
}
```

## 📚 学習の進め方

1. **まずは標準LazyVim**: カスタマイズ前にLazyVimの標準機能を習得
2. **段階的カスタマイズ**: 一度に多くを変更せず、必要に応じて追加
3. **設定の理解**: コピペではなく、各設定の意味を理解
4. **実践での確認**: 実際のプロジェクトで動作確認

## 📖 参考リンク

- [LazyVim公式ドキュメント](https://www.lazyvim.org/)
- [LazyVimカスタマイズガイド](https://www.lazyvim.org/configuration)
- [プラグイン一覧](https://www.lazyvim.org/plugins)

---

LazyVimの強力な基盤の上に、あなただけの理想的な開発環境を構築しましょう！