# デバッグ・テスト統合 - 詳細ガイド

## 1. nvim-dap（Debug Adapter Protocol）入門

### DAPとは？
Debug Adapter Protocol（DAP）は、エディタとデバッガー間の標準化された通信プロトコルです。LazyVimでは**nvim-dap**によってDAPが統合されており、様々な言語のデバッガーを統一的に操作できます。

### LazyVimでのDAP統合

LazyVimには以下のDAPプラグインが事前設定されています：
- **nvim-dap**: DAPクライアント
- **nvim-dap-ui**: デバッグUI
- **nvim-dap-virtual-text**: 仮想テキスト表示
- **mason-nvim-dap.nvim**: アダプターの自動インストール

### 基本的なデバッグ操作

#### デバッグセッションの開始
```vim
<leader>dB  " ブレークポイントの設定/削除
<leader>dc  " デバッグセッション開始（continue）
<leader>dr  " REPL表示
<leader>dl  " 最後のデバッグセッションを再実行
```

#### ステップ実行
```vim
<leader>ds  " Step Into（関数の中に入る）
<leader>dS  " Step Over（関数を飛び越える）
<leader>do  " Step Out（関数から出る）
<leader>dC  " Continue（次のブレークポイントまで実行）
```

#### 変数確認
```vim
<leader>dh  " カーソル下の変数をホバー表示
<leader>dp  " 変数プレビュー
<leader>de  " 式の評価
```

### デバッグUIの活用

#### UI表示の切り替え
```vim
<leader>du  " DAP UIの表示/非表示切り替え
```

#### UIウィンドウの説明
- **Variables**: 現在のスコープの変数一覧
- **Watches**: ウォッチ式（監視したい変数や式）
- **Call Stack**: 関数呼び出しスタック
- **Breakpoints**: ブレークポイント一覧
- **Console**: デバッガーからの出力
- **REPL**: 式の対話的評価

## 2. 言語別デバッグ設定

### TypeScript/JavaScript

#### 必要なアダプター
```bash
# node-debug2-adapter のインストール
npm install -g node-debug2
```

#### 基本設定例
```lua
-- JavaScript/TypeScript用の設定
require('dap').configurations.javascript = {
  {
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    type = 'node2',
    request = 'attach',
    port = 9229,
    skipFiles = {'<node_internals>/**'},
  },
}
```

#### デバッグの実行
1. TypeScriptファイルでブレークポイント設定（`<leader>dB`）
2. デバッグ開始（`<leader>dc`）
3. アプリケーションが停止したらステップ実行

### Python

#### 必要なアダプター
```bash
pip install debugpy
```

#### 基本設定例
```lua
-- Python用の設定
require('dap').configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",
    program = '${file}',
    pythonPath = function()
      return '/usr/bin/python3'
    end,
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Django',
    program = vim.fn.getcwd() .. '/manage.py',
    args = {'runserver'},
  },
}
```

#### pytest統合
```lua
-- pytest用設定
{
  type = 'python',
  request = 'launch',
  name = 'pytest',
  module = 'pytest',
  args = {'${file}'},
}
```

### Go

#### 必要なアダプター
```bash
go install github.com/go-delve/delve/cmd/dlv@latest
```

#### 基本設定
```lua
-- Go用の設定
require('dap').configurations.go = {
  {
    type = 'go',
    name = 'Debug',
    request = 'launch',
    program = '${file}',
  },
  {
    type = 'go',
    name = 'Debug Package',
    request = 'launch',
    program = '${fileDirname}',
  },
}
```

## 3. 高度なデバッグテクニック

### 条件付きブレークポイント

```vim
" 条件付きブレークポイントの設定
:lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
```

**使用例：**
- `i == 5`: 変数iが5の時にのみ停止
- `len(items) > 10`: リストの長さが10を超えた時に停止
- `user.name == "admin"`: 特定の条件を満たすオブジェクトの時に停止

### ログポイント

```vim
" ログポイントの設定（ブレークせずにログ出力）
:lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
```

### 例外ブレークポイント

```lua
-- 未処理例外で自動的に停止
require('dap').set_exception_breakpoints({'uncaught'})

-- 全ての例外で停止
require('dap').set_exception_breakpoints({'all'})
```

### REPL（式の評価）

デバッグセッション中にREPLで任意の式を評価：
```vim
<leader>dr  " REPL表示

" REPL内で実行可能
> variables()        # 現在の変数一覧
> user.email         # 変数の値確認
> calculate(x, y)    # 関数の実行
> import os; os.getcwd()  # その場でコード実行
```

## 4. neotest統合

### neotestとは？
**neotest**は、Neovim用の包括的なテストフレームワーク統合プラグインです。様々なテストフレームワークを統一的なインターフェースで操作できます。

### 基本操作

```vim
<leader>tr  " 最寄りのテストを実行
<leader>tR  " ファイル内の全テストを実行
<leader>ta  " 全テストを実行
<leader>ts  " テスト実行を停止
<leader>to  " テスト出力を表示
<leader>tS  " テストサマリー表示
```

### テストの発見と実行

#### 自動テスト発見
neotestは以下のパターンでテストを自動発見：
- **Python**: `test_*.py`, `*_test.py`
- **JavaScript**: `*.test.js`, `*.spec.js`
- **Go**: `*_test.go`

#### テスト結果の表示
- ✅ **合格**: 緑色のチェックマーク
- ❌ **失敗**: 赤色のX
- ⏸️ **スキップ**: 黄色の一時停止
- 🔄 **実行中**: 青色の回転アイコン

### テストカバレッジ

#### カバレッジ表示の有効化
```lua
require('neotest').setup({
  adapters = {
    require('neotest-python')({
      args = {'--cov', '--cov-report=term-missing'},
    }),
  },
})
```

#### カバレッジ情報の確認
```vim
<leader>tc  " カバレッジ表示切り替え
```

## 5. TDD/BDDワークフロー

### Test-Driven Development (TDD)

#### 基本サイクル
1. **Red**: 失敗するテストを書く
2. **Green**: テストを通す最小限のコードを書く
3. **Refactor**: コードをリファクタリング

#### LazyVimでのTDDワークフロー
```vim
" 1. テストファイルを作成
:e test_calculator.py

" 2. 失敗するテストを書く
" 3. テストを実行
<leader>tr

" 4. 実装ファイルに切り替え
:e calculator.py

" 5. 最小限の実装
" 6. テスト再実行
<leader>tr

" 7. リファクタリング
" 8. 継続的にテスト実行
<leader>ta
```

### Behavior-Driven Development (BDD)

#### Pythonでのpytest-bdd
```python
# features/calculator.feature
Feature: Calculator
  Scenario: Add two numbers
    Given I have a calculator
    When I add 2 and 3
    Then the result should be 5

# test_calculator_bdd.py
from pytest_bdd import scenarios, given, when, then

scenarios('calculator.feature')

@given('I have a calculator')
def calculator():
    return Calculator()

@when('I add 2 and 3')
def add_numbers(calculator):
    calculator.result = calculator.add(2, 3)

@then('the result should be 5')
def check_result(calculator):
    assert calculator.result == 5
```

## 6. デバッグとテストの統合

### テストのデバッグ

1. **テストファイルでブレークポイント設定**
   ```vim
   <leader>dB  " テスト関数内にブレークポイント
   ```

2. **テストデバッグの開始**
   ```vim
   <leader>td  " 現在のテストをデバッグモードで実行
   ```

3. **失敗したテストの詳細調査**
   ```vim
   <leader>to  " テスト出力確認
   <leader>dp  " 変数の詳細確認
   ```

### パフォーマンステスト

#### プロファイリング統合
```python
import cProfile
import pstats

def test_performance():
    profiler = cProfile.Profile()
    profiler.enable()
    
    # テスト対象の実行
    result = expensive_function()
    
    profiler.disable()
    stats = pstats.Stats(profiler)
    stats.sort_stats('tottime')
    stats.print_stats(10)  # 上位10件を表示
```

## 7. 実践的なデバッグシナリオ

### バグ調査のワークフロー

1. **症状の再現**
   - エラーメッセージの確認
   - 最小限の再現手順の特定

2. **仮説立案**
   - 考えられる原因の列挙
   - 優先順位の設定

3. **デバッグ実行**
   ```vim
   <leader>dB  " 問題が発生しそうな箇所にブレークポイント
   <leader>dc  " デバッグ開始
   ```

4. **状態確認**
   ```vim
   <leader>dh  " 変数の値確認
   <leader>de  " 式の評価
   ```

5. **仮説検証**
   - ステップ実行で流れを追跡
   - 期待値と実際の値の比較

6. **修正と検証**
   - コード修正
   - テスト実行で修正確認

### デバッグの効率化

#### ログベースデバッグ
```python
import logging

# デバッグレベルでのログ出力
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def process_data(data):
    logger.debug(f"Processing {len(data)} items")
    for i, item in enumerate(data):
        logger.debug(f"Item {i}: {item}")
        # 処理
```

#### アサーションの活用
```python
def divide(a, b):
    assert b != 0, f"Division by zero: {a} / {b}"
    assert isinstance(a, (int, float)), f"Invalid type for a: {type(a)}"
    assert isinstance(b, (int, float)), f"Invalid type for b: {type(b)}"
    return a / b
```

## まとめ

LazyVimのデバッグ・テスト統合環境により：
- **効率的なバグ修正**: ブレークポイントとステップ実行による確実な調査
- **品質保証**: 継続的なテスト実行による回帰防止
- **開発速度向上**: TDD/BDDによる設計品質の向上
- **統合ワークフロー**: デバッグとテストのシームレスな連携

これらの機能を日常的に活用することで、品質の高いソフトウェアを効率的に開発できます。