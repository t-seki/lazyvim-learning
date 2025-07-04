# Text Object練習用Pythonファイル

import json
from typing import List, Dict, Optional, Union
from dataclasses import dataclass
from datetime import datetime


# 基本的なクラスでの練習
class UserManager:
    """ユーザー管理クラス"""
    
    def __init__(self, database_url: str):
        self.database_url = database_url
        self.users: Dict[int, 'User'] = {}
        self._last_id = 0
    
    def add_user(self, name: str, email: str) -> 'User':
        """新しいユーザーを追加"""
        self._last_id += 1
        user = User(
            id=self._last_id,
            name=name,
            email=email,
            created_at=datetime.now()
        )
        self.users[user.id] = user
        return user
    
    def get_user(self, user_id: int) -> Optional['User']:
        """IDでユーザーを取得"""
        return self.users.get(user_id)
    
    def update_user(self, user_id: int, **kwargs) -> bool:
        """ユーザー情報を更新"""
        if user_id not in self.users:
            return False
        
        user = self.users[user_id]
        for key, value in kwargs.items():
            if hasattr(user, key):
                setattr(user, key, value)
        
        return True
    
    def delete_user(self, user_id: int) -> bool:
        """ユーザーを削除"""
        if user_id in self.users:
            del self.users[user_id]
            return True
        return False


# データクラスでの練習
@dataclass
class User:
    id: int
    name: str
    email: str
    created_at: datetime
    is_active: bool = True
    role: str = "user"
    
    def to_dict(self) -> Dict:
        """辞書形式に変換"""
        return {
            "id": self.id,
            "name": self.name,
            "email": self.email,
            "created_at": self.created_at.isoformat(),
            "is_active": self.is_active,
            "role": self.role
        }
    
    def validate_email(self) -> bool:
        """メールアドレスの簡易検証"""
        return "@" in self.email and "." in self.email.split("@")[1]


# 関数とデコレータの練習
def retry(max_attempts: int = 3):
    """リトライデコレータ"""
    def decorator(func):
        def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1:
                        raise
                    print(f"Attempt {attempt + 1} failed: {e}")
            return None
        return wrapper
    return decorator


@retry(max_attempts=3)
def fetch_data(url: str) -> Dict:
    """データを取得する（リトライ付き）"""
    # 実際のHTTPリクエストの代わりにダミーデータを返す
    if url.startswith("http"):
        return {
            "status": "success",
            "data": {"message": "Hello, World!"}
        }
    else:
        raise ValueError("Invalid URL format")


# リスト内包表記と条件分岐の練習
def process_numbers(numbers: List[Union[int, float]]) -> Dict[str, List]:
    """数値リストを処理して分類"""
    result = {
        "even": [n for n in numbers if isinstance(n, int) and n % 2 == 0],
        "odd": [n for n in numbers if isinstance(n, int) and n % 2 == 1],
        "float": [n for n in numbers if isinstance(n, float)],
        "squared": [n ** 2 for n in numbers],
        "filtered": [n for n in numbers if 0 < n < 100]
    }
    
    # 統計情報を追加
    if numbers:
        result["stats"] = {
            "count": len(numbers),
            "sum": sum(numbers),
            "average": sum(numbers) / len(numbers),
            "min": min(numbers),
            "max": max(numbers)
        }
    
    return result


# ジェネレータとイテレータの練習
def fibonacci_generator(limit: int):
    """フィボナッチ数列のジェネレータ"""
    a, b = 0, 1
    count = 0
    
    while count < limit:
        yield a
        a, b = b, a + b
        count += 1


# 例外処理の練習
class DataProcessor:
    def __init__(self, config: Dict):
        self.config = config
        self.errors = []
    
    def process(self, data: List[Dict]) -> List[Dict]:
        """データを処理"""
        results = []
        
        for item in data:
            try:
                # データの検証
                if not self._validate_item(item):
                    raise ValueError(f"Invalid item: {item}")
                
                # データの変換
                processed = self._transform_item(item)
                
                # 結果の保存
                results.append(processed)
                
            except ValueError as e:
                self.errors.append(str(e))
                continue
            except Exception as e:
                self.errors.append(f"Unexpected error: {e}")
                break
        
        return results
    
    def _validate_item(self, item: Dict) -> bool:
        """アイテムの検証"""
        required_fields = self.config.get("required_fields", [])
        return all(field in item for field in required_fields)
    
    def _transform_item(self, item: Dict) -> Dict:
        """アイテムの変換"""
        transformations = self.config.get("transformations", {})
        result = item.copy()
        
        for field, transform in transformations.items():
            if field in result:
                if transform == "uppercase":
                    result[field] = result[field].upper()
                elif transform == "lowercase":
                    result[field] = result[field].lower()
        
        return result


# 文字列操作とフォーマッティングの練習
def generate_report(title: str, data: List[Dict], format_type: str = "text") -> str:
    """レポートを生成"""
    if format_type == "text":
        lines = [f"=== {title} ===", ""]
        
        for idx, item in enumerate(data, 1):
            lines.append(f"{idx}. {item.get('name', 'Unknown')}")
            lines.append(f"   Status: {item.get('status', 'N/A')}")
            lines.append(f"   Date: {item.get('date', 'N/A')}")
            lines.append("")
        
        return "\n".join(lines)
    
    elif format_type == "json":
        return json.dumps({
            "title": title,
            "items": data,
            "generated_at": datetime.now().isoformat()
        }, indent=2)
    
    else:
        raise ValueError(f"Unsupported format: {format_type}")


# 複雑なネスト構造の練習
configuration = {
    "application": {
        "name": "MyApp",
        "version": "1.0.0",
        "settings": {
            "debug": True,
            "log_level": "INFO",
            "features": {
                "authentication": {
                    "enabled": True,
                    "providers": ["local", "oauth"],
                    "session_timeout": 3600
                },
                "database": {
                    "type": "postgresql",
                    "host": "localhost",
                    "port": 5432,
                    "pool_size": 10
                }
            }
        }
    },
    "endpoints": [
        {"path": "/api/users", "method": "GET", "auth": True},
        {"path": "/api/login", "method": "POST", "auth": False},
        {"path": "/api/data", "method": "GET", "auth": True}
    ]
}


if __name__ == "__main__":
    # テストコード
    manager = UserManager("sqlite:///users.db")
    user = manager.add_user("Alice", "alice@example.com")
    print(f"Created user: {user.name}")
    
    numbers = [1, 2.5, 3, 4.7, 5, 6, 7.2, 8, 9, 10]
    processed = process_numbers(numbers)
    print(f"Even numbers: {processed['even']}")
    
    fib_nums = list(fibonacci_generator(10))
    print(f"Fibonacci sequence: {fib_nums}")