"""
LSP機能練習用Pythonファイル
このファイルで様々なLSP機能、フォーマッティング、型チェックを試してみましょう
"""

from typing import List, Dict, Optional, Union, Any
from dataclasses import dataclass
from datetime import datetime
import json
# 未使用のインポート（リンターが警告）
import os
import sys


# 型アノテーションが不完全
def process_data(data):
    """データを処理する関数（ドキュメント文字列が不完全）"""
    # 型チェックエラー: dataの型が不明
    result = []
    for item in data:
        if item > 0:
            result.append(item * 2)
    return result


@dataclass
class User:
    """ユーザーデータクラス"""
    id: int
    name: str
    email: str
    created_at: datetime
    # Optional型を使うべき
    age: int = None  # 型エラー
    is_active: bool = True


class DataProcessor:
    """データ処理クラス（メソッドの実装が不完全）"""
    
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        # 未初期化の属性（後で使用されるがここで初期化されていない）
        # self.cache = {}
    
    # 型アノテーションが不完全
    def validate_email(self, email) -> bool:
        """メールアドレスのバリデーション"""
        # シンプルすぎる実装（リファクタリング候補）
        return "@" in email and "." in email
    
    # asyncメソッドだがawaitを使用していない
    async def fetch_user_data(self, user_id: int) -> Optional[User]:
        """ユーザーデータを取得"""
        # TODO: 実際のデータ取得処理を実装
        # 型エラー: Noneを返すべきだがstrを返している
        return "not implemented"
    
    def process_users(self, users: List[User]) -> Dict[str, List[User]]:
        """ユーザーをアクティブ状態で分類"""
        result = {"active": [], "inactive": []}
        
        for user in users:
            # 複雑な条件（リファクタリング候補）
            if user.is_active and user.created_at.year == datetime.now().year:
                result["active"].append(user)
            elif not user.is_active or user.created_at.year < datetime.now().year:
                result["inactive"].append(user)
        
        # 未定義の属性にアクセス
        self.cache[user.id] = user
        
        return result
    
    # 未実装のメソッド
    def export_to_json(self, data: List[User], filename: str):
        """JSONファイルにエクスポート"""
        raise NotImplementedError("This method needs to be implemented")
    
    # 非推奨メソッド
    def old_process_method(self, data: Any) -> Any:
        """
        .. deprecated:: 1.0.0
           Use :func:`process_users` instead.
        """
        return data


# フォーマットが必要なコード（Black/Ruffで自動整形）
def poorly_formatted_function(x,y,z):
    """フォーマットが悪い関数"""
    result=x+y*z
    if result>100:
        return result
    else:
        return 0


# 型エラーを含む使用例
processor = DataProcessor({"debug": True})

# 型エラー: strをintとして渡している
user = User(id="123", name="John Doe", email="john@example.com", created_at=datetime.now())

# リストの型が間違っている
users_list: List[str] = [user]  # 型エラー

# 存在しないメソッドの呼び出し
processor.non_existent_method()

# インデントエラー
if True:
print("インデントエラー")

# 未定義の変数
print(undefined_variable)


# 循環的複雑度が高い関数（リファクタリング候補）
def complex_logic(value: int, mode: str, flags: Dict[str, bool]) -> Optional[int]:
    """複雑すぎるロジック"""
    if mode == "add":
        if flags.get("double"):
            if value > 0:
                return value * 2
            else:
                return value
        else:
            if flags.get("increment"):
                return value + 1
            else:
                return value
    elif mode == "subtract":
        if flags.get("half"):
            if value > 10:
                return value // 2
            else:
                return value - 1
        else:
            return value - 1
    else:
        if flags.get("reset"):
            return 0
        else:
            return None


# グローバル変数（避けるべきパターン）
GLOBAL_CONFIG = {"version": "1.0.0"}


def use_global():
    """グローバル変数を使用する関数"""
    # グローバル変数の変更（警告対象）
    GLOBAL_CONFIG["modified"] = True
    return GLOBAL_CONFIG