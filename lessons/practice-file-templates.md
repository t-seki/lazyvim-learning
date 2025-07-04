# 練習用ファイルテンプレート

各レッスンで使用する練習用ファイルのテンプレート集です。
実際のコーディングシーンを想定した内容にすることで、実践的な学習を促進します。

## プログラミング言語別テンプレート

### JavaScript/TypeScript
```javascript
// ユーザー管理関数
function getUserById(id) {
    // データベースからユーザーを取得
    const user = database.find(u => u.id === id);
    
    if (!user) {
        throw new Error('User not found');
    }
    
    return {
        id: user.id,
        name: user.name,
        email: user.email,
        createdAt: user.createdAt
    };
}

// TODOリスト管理クラス
class TodoList {
    constructor() {
        this.todos = [];
    }
    
    addTodo(text) {
        const todo = {
            id: Date.now(),
            text: text,
            completed: false,
            createdAt: new Date()
        };
        this.todos.push(todo);
        return todo;
    }
    
    toggleTodo(id) {
        const todo = this.todos.find(t => t.id === id);
        if (todo) {
            todo.completed = !todo.completed;
        }
    }
}
```

### Python
```python
# データ処理関数
def process_data(data_list):
    """データリストを処理して統計情報を返す"""
    if not data_list:
        return None
    
    total = sum(data_list)
    average = total / len(data_list)
    
    return {
        'total': total,
        'average': average,
        'count': len(data_list),
        'min': min(data_list),
        'max': max(data_list)
    }

# ファイル操作クラス
class FileManager:
    def __init__(self, base_path):
        self.base_path = base_path
    
    def read_file(self, filename):
        """ファイルを読み込んで内容を返す"""
        file_path = os.path.join(self.base_path, filename)
        
        try:
            with open(file_path, 'r') as f:
                return f.read()
        except FileNotFoundError:
            print(f"Error: File {filename} not found")
            return None
```

### Markdown
```markdown
# プロジェクトドキュメント

## 概要

このプロジェクトは、ユーザー管理システムの実装例です。
以下の機能を提供します：

- ユーザー登録
- ログイン/ログアウト
- プロフィール管理
- 権限管理

## インストール

1. リポジトリをクローン
   ```bash
   git clone https://github.com/example/project.git
   ```

2. 依存関係をインストール
   ```bash
   npm install
   ```

3. 環境変数を設定
   ```bash
   cp .env.example .env
   ```

## 使用方法

### 開発サーバーの起動

```bash
npm run dev
```

### テストの実行

```bash
npm test
```
```

### 設定ファイル (JSON/YAML)
```json
{
  "name": "my-app",
  "version": "1.0.0",
  "description": "サンプルアプリケーション",
  "scripts": {
    "dev": "nodemon src/index.js",
    "build": "webpack --mode production",
    "test": "jest",
    "lint": "eslint src/**/*.js"
  },
  "dependencies": {
    "express": "^4.18.0",
    "dotenv": "^16.0.0",
    "mongoose": "^6.0.0"
  },
  "devDependencies": {
    "nodemon": "^2.0.0",
    "jest": "^29.0.0",
    "eslint": "^8.0.0"
  }
}
```

## エラーを含むコード例

練習用に意図的にエラーを含むコード：

### 構文エラー
```javascript
function calculateTotal(items) {
    let total = 0;
    for (let item of items {  // カッコが閉じていない
        total += item.price;
    }
    return total;
}
```

### ロジックエラー
```python
def find_max(numbers):
    max_num = 0  # 負の数に対応していない
    for num in numbers:
        if num > max_num:
            max_num = num
    return max_num
```

### タイポ
```javascript
const userNmae = "John Doe";  // 変数名のタイポ
console.log(userName);  // 参照時に異なる名前
```

## 練習シナリオ別テンプレート

### リファクタリング練習用
```javascript
// リファクタリング前
function calc(x, y, op) {
    if (op == 'add') {
        return x + y;
    } else if (op == 'sub') {
        return x - y;
    } else if (op == 'mul') {
        return x * y;
    } else if (op == 'div') {
        return x / y;
    }
}
```

### デバッグ練習用
```python
# バグを含むコード
def merge_lists(list1, list2):
    result = []
    i = j = 0
    
    while i < len(list1) and j < len(list2):
        if list1[i] < list2[j]:
            result.append(list1[i])
            i += 1
        else:
            result.append(list2[j])
            # j += 1  # インクリメントを忘れている
    
    return result
```