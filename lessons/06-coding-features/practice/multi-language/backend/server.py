"""
バックエンドAPIサーバー
フロントエンドとの連携を確認
"""

from flask import Flask, jsonify, request
from typing import Dict, List, Optional
from dataclasses import dataclass, asdict
from datetime import datetime

app = Flask(__name__)

# 共通の型定義（フロントエンドのTypeScriptと対応）
@dataclass
class User:
    id: int
    username: str
    email: str
    role: str  # 'admin' | 'user' | 'guest'
    created_at: str

@dataclass
class ApiResponse:
    success: bool
    data: Optional[Dict] = None
    error: Optional[str] = None

# モックデータ
USERS_DB: Dict[int, User] = {
    1: User(1, "admin", "admin@example.com", "admin", datetime.now().isoformat()),
    2: User(2, "john_doe", "john@example.com", "user", datetime.now().isoformat()),
}

# APIエンドポイント（フロントエンドから呼び出される）
@app.route('/api/users', methods=['GET'])
def get_users():
    """全ユーザーを取得"""
    users_list = [asdict(user) for user in USERS_DB.values()]
    return jsonify(asdict(ApiResponse(True, {"users": users_list})))

@app.route('/api/users/<int:user_id>', methods=['GET'])
def get_user(user_id: int):
    """特定のユーザーを取得"""
    user = USERS_DB.get(user_id)
    if user:
        return jsonify(asdict(ApiResponse(True, asdict(user))))
    return jsonify(asdict(ApiResponse(False, error="User not found"))), 404

@app.route('/api/users', methods=['POST'])
def create_user():
    """新しいユーザーを作成"""
    data = request.json
    # バリデーション（フロントエンドの型と一致させる）
    required_fields = ['username', 'email', 'role']
    
    for field in required_fields:
        if field not in data:
            return jsonify(asdict(ApiResponse(False, error=f"Missing field: {field}"))), 400
    
    # 新しいユーザーの作成
    new_id = max(USERS_DB.keys()) + 1 if USERS_DB else 1
    new_user = User(
        id=new_id,
        username=data['username'],
        email=data['email'],
        role=data['role'],
        created_at=datetime.now().isoformat()
    )
    
    USERS_DB[new_id] = new_user
    return jsonify(asdict(ApiResponse(True, asdict(new_user)))), 201

# 設定の読み込み（config.jsonから）
def load_config():
    import json
    with open('config.json', 'r') as f:
        return json.load(f)

if __name__ == '__main__':
    config = load_config()
    app.run(
        host=config.get('host', '0.0.0.0'),
        port=config.get('port', 5000),
        debug=config.get('debug', False)
    )