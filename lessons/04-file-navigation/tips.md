# ヒントとテクニック

## よくある間違い

### 間違い1: バッファとウィンドウの混同

**症状**: ファイルを閉じたつもりがウィンドウだけ閉じて、バッファが残っている

**原因**: `:q`（ウィンドウを閉じる）と`:bd`（バッファを削除）の違いを理解していない

**解決方法**:
```vim
" ウィンドウを閉じる（バッファは残る）
:q

" バッファを削除する（ファイルを完全に閉じる）
:bd

" 確認方法
:ls  " バッファリストを確認
```

**覚え方**: 
- Window（ウィンドウ）= 窓（見えるかどうか）
- Buffer（バッファ）= 本（メモリに残っているかどうか）

### 間違い2: 画面分割での迷子

**症状**: 分割しすぎて、どのウィンドウにいるかわからなくなる

**原因**: ウィンドウ間の移動方法とレイアウトを把握していない

**解決方法**:
```vim
" 現在のウィンドウを強調表示（設定）
:set cursorline
:set cursorcolumn

" ウィンドウレイアウトをリセット
Ctrl-w o    " 現在のウィンドウのみ残す
Ctrl-w =    " 全ウィンドウを等サイズに

" ウィンドウ番号を表示（設定）
:set number
```

### 間違い3: タブの過剰使用

**症状**: タブを大量に開いて管理できなくなる

**原因**: タブとウィンドウの使い分けができていない

**解決方法**:
```vim
" タブの適切な使い分け
" ✓ 良い例：機能別にタブを分ける
" タブ1: メイン開発
" タブ2: テスト
" タブ3: 設定・ドキュメント

" ✗ 悪い例：ファイルごとにタブを作る
" 大量のタブで管理困難

" タブリストで現状確認
:tabs
```

### 間違い4: ファイルパスの理解不足

**症状**: ファイルが見つからない、間違ったファイルを開く

**原因**: 相対パスと絶対パス、カレントディレクトリを理解していない

**解決方法**:
```vim
" 現在位置を確認
:pwd

" カレントディレクトリを変更
:cd /path/to/project

" ファイルパスを確認
:echo expand('%:p')    " 現在ファイルの絶対パス
:echo expand('%:h')    " 現在ファイルのディレクトリ
```

## 効率的なテクニック

### テクニック1: キーマッピングの活用

よく使う操作にショートカットを設定：

```vim
" .vimrc または init.vim に追加
" バッファ切り替え
nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprev<CR>

" ウィンドウ移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" タブ切り替え
nnoremap <silent> <A-l> :tabnext<CR>
nnoremap <silent> <A-h> :tabprev<CR>
```

### テクニック2: ウィンドウレイアウトのパターン化

作業内容に応じたレイアウトパターンを決める：

#### パターン1: コード+テスト
```vim
" 左右分割：コードとテスト
:vsplit tests/unit/component.test.js
```

#### パターン2: メイン+サブ+設定
```vim
" 上下左右分割
" ┌─────────┬─────────┐
" │ Main    │ Sub     │
" ├─────────┴─────────┤
" │ Config            │
" └───────────────────┘

:split config/app.json
Ctrl-w k
:vsplit src/utils/helper.js
```

#### パターン3: ログ監視
```vim
" 下部にログファイル
:split logs/debug.log
Ctrl-w J    " 下部に移動
:resize 10  " 高さを10行に
```

### テクニック3: ファイル検索の効率化

```vim
" ワイルドカードを活用
:e **/user*         " userを含むファイルを再帰検索
:e *.{js,ts}        " JavaScriptまたはTypeScriptファイル
:e src/**/*.test.*  " テストファイルを再帰検索

" 補完設定
set wildmenu            " コマンドライン補完を強化
set wildmode=full       " 補完モード
set wildignore+=*.o,*.obj,*.pyc  " 除外ファイル
```

### テクニック4: セッション活用

```vim
" プロジェクト用セッション設定
" プロジェクトルートで実行
:mksession! .session.vim

" 自動復元設定（.vimrc）
autocmd VimEnter * nested
  \ if argc() == 0 && filereadable('.session.vim') |
  \   source .session.vim |
  \ endif
```

### テクニック5: バッファ管理の自動化

```vim
" 未保存バッファの警告
set confirm

" バッファ切り替え時の自動保存
set autowrite

" 非表示バッファを削除（メモリ節約）
:command! BufClean call s:CleanBuffers()
function! s:CleanBuffers()
  let open_buffers = []
  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor
  for num in range(1, bufnr('$') + 1)
    if buflisted(num) && index(open_buffers, num) == -1
      exec 'bdelete ' . num
    endif
  endfor
endfunction
```

## 実践的なワークフローパターン

### パターン1: フロントエンド開発

```vim
" タブ1: コンポーネント開発
:tabnew
:e src/components/UserProfile.jsx
:vsplit src/hooks/useUser.js
:split src/styles/userProfile.css

" タブ2: テスト
:tabnew  
:e tests/UserProfile.test.jsx
:split tests/__mocks__/api.js

" タブ3: 設定・ビルド
:tabnew
:e package.json
:vsplit webpack.config.js
```

### パターン2: バックエンド開発

```vim
" タブ1: API開発
:e src/routes/users.js
:vsplit src/models/User.js
:split src/middleware/auth.js

" タブ2: テスト・デバッグ  
:tabnew
:e tests/routes/users.test.js
:split logs/app.log

" タブ3: データベース・設定
:tabnew
:e migrations/001_create_users.sql
:vsplit config/database.json
```

### パターン3: デバッグセッション

```vim
" メインコード + エラーログ
:e src/problematic-function.js
:split logs/error.log
:resize 8

" 別タブで関連ファイル
:tabnew
:e tests/problematic-function.test.js
:vsplit docs/api.md
```

## パフォーマンス最適化

### 1. バッファ数の管理

```vim
" バッファ数を制限（設定例）
set hidden              " バッファを隠す（削除しない）
set bufhidden=delete    " 非表示時にバッファ削除

" 定期的なクリーンアップ
autocmd BufEnter * call s:CleanOldBuffers()
```

### 2. ウィンドウ操作の高速化

```vim
" ウィンドウ移動を高速化
nnoremap <C-w><C-w> <C-w>w
nnoremap <C-w><C-h> <C-w>h
nnoremap <C-w><C-j> <C-w>j
nnoremap <C-w><C-k> <C-w>k
nnoremap <C-w><C-l> <C-w>l

" 素早いリサイズ
nnoremap <silent> <C-w>+ :resize +5<CR>
nnoremap <silent> <C-w>- :resize -5<CR>
nnoremap <silent> <C-w>> :vertical resize +5<CR>
nnoremap <silent> <C-w>< :vertical resize -5<CR>
```

### 3. メモリ使用量の最適化

```vim
" 大きなファイルでの最適化
autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | syntax off | endif

" スワップファイルの管理
set directory=~/.vim/swap//
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//
```

## トラブルシューティング

### Q: ウィンドウが小さすぎて作業できない

```vim
" 解決方法
Ctrl-w =        " 等サイズに調整
:resize 20      " 高さを20行に
:vertical resize 80  " 幅を80文字に
```

### Q: タブが多すぎて把握できない

```vim
" 現状確認
:tabs

" 不要なタブを閉じる
:tabclose       " 現在のタブ
:tabonly        " 現在のタブ以外を閉じる

" タブ移動の改善
:set showtabline=2  " 常にタブラインを表示
```

### Q: バッファリストが煩雑

```vim
" リスト確認
:ls!            " 削除済みバッファも表示

" クリーンアップ
:bufdo bdelete  " 全バッファ削除（保存してから）
:%bdelete       " 全バッファ削除
```

### Q: ファイルが見つからない

```vim
" 現在位置確認
:pwd
:echo @%        " 現在のファイル名
:echo expand('%:p')  " 絶対パス

" ディレクトリ変更
:cd %:h         " 現在ファイルのディレクトリに移動
:lcd %:h        " ローカルディレクトリ変更
```

## 上級者向けテクニック

### 1. 動的ウィンドウ管理

```vim
" ウィンドウサイズの自動調整
autocmd VimResized * wincmd =

" フォーカスウィンドウを自動的に大きく
autocmd WinEnter * if &buftype != 'quickfix' | wincmd = | endif
```

### 2. コンテキスト別セッション

```vim
" プロジェクト別セッション管理
function! LoadProjectSession()
  let session_file = findfile('.session.vim', '.;')
  if filereadable(session_file)
    execute 'source ' . session_file
  endif
endfunction

autocmd VimEnter * call LoadProjectSession()
```

### 3. インテリジェントファイル検索

```vim
" プロジェクトルートの自動検出
function! FindProjectRoot()
  let markers = ['.git', 'package.json', 'Cargo.toml', 'go.mod']
  let current_dir = expand('%:p:h')
  
  for marker in markers
    let found = findfile(marker, current_dir . ';')
    if !empty(found)
      return fnamemodify(found, ':p:h')
    endif
  endfor
  
  return current_dir
endfunction
```

これらのテクニックを組み合わせることで、Neovimでの複数ファイル作業が格段に効率的になります！