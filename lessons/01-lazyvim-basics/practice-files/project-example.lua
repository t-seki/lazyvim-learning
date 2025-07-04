-- LazyVim プロジェクト風練習ファイル
-- =====================================

local M = {}

-- 📁 このファイルで練習できること:
-- - 複数関数間のナビゲーション (gd, gr)
-- - シンボル検索 (<leader>ss)
-- - LSP機能 (K, <leader>ca)
-- - プロジェクト検索 (<leader>/)

-- 🎯 User管理モジュール
M.User = {}

function M.User.new(name, email)
  local user = {
    name = name or "Anonymous",
    email = email or "unknown@example.com",
    created_at = os.time(),
    is_active = true
  }
  
  return setmetatable(user, { __index = M.User })
end

function M.User:get_name()
  return self.name
end

function M.User:set_name(new_name)
  if type(new_name) ~= "string" or #new_name == 0 then
    error("名前は空でない文字列である必要があります")
  end
  self.name = new_name
end

function M.User:is_valid_email(email)
  -- 簡単なメール形式チェック
  return email:match("^[%w%._%+%-]+@[%w%._%+%-]+%.%w+$") ~= nil
end

function M.User:update_email(new_email)
  if not self:is_valid_email(new_email) then
    error("無効なメール形式です: " .. new_email)
  end
  self.email = new_email
end

function M.User:deactivate()
  self.is_active = false
  print("ユーザー " .. self.name .. " が非アクティブになりました")
end

-- 🎯 Project管理モジュール
M.Project = {}

function M.Project.new(title, description, owner)
  local project = {
    id = M.generate_uuid(),
    title = title or "無題プロジェクト",
    description = description or "",
    owner = owner,
    contributors = {},
    created_at = os.time(),
    status = "planning" -- planning, active, completed, cancelled
  }
  
  return setmetatable(project, { __index = M.Project })
end

function M.Project:add_contributor(user)
  if not user or not user.name then
    error("有効なユーザーオブジェクトが必要です")
  end
  
  table.insert(self.contributors, user)
  print(user.name .. " がプロジェクト '" .. self.title .. "' に追加されました")
end

function M.Project:remove_contributor(user_name)
  for i, contributor in ipairs(self.contributors) do
    if contributor.name == user_name then
      table.remove(self.contributors, i)
      print(user_name .. " がプロジェクトから削除されました")
      return true
    end
  end
  return false
end

function M.Project:change_status(new_status)
  local valid_statuses = { "planning", "active", "completed", "cancelled" }
  
  for _, status in ipairs(valid_statuses) do
    if status == new_status then
      self.status = new_status
      print("プロジェクト状態が '" .. new_status .. "' に変更されました")
      return
    end
  end
  
  error("無効なステータス: " .. new_status)
end

function M.Project:get_contributor_count()
  return #self.contributors
end

function M.Project:get_summary()
  return {
    id = self.id,
    title = self.title,
    owner = self.owner and self.owner.name or "不明",
    contributor_count = self:get_contributor_count(),
    status = self.status,
    created_at = os.date("%Y-%m-%d", self.created_at)
  }
end

-- 🎯 Utility Functions
function M.generate_uuid()
  -- 簡単なUUID生成（実際のプロジェクトではより強固な実装を使用）
  local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
  local uuid = ""
  
  for i = 1, 8 do
    local idx = math.random(1, #chars)
    uuid = uuid .. chars:sub(idx, idx)
  end
  
  return uuid
end

function M.validate_input(input, input_type)
  if input_type == "string" then
    return type(input) == "string" and #input > 0
  elseif input_type == "email" then
    return type(input) == "string" and input:match("^[%w%._%+%-]+@[%w%._%+%-]+%.%w+$") ~= nil
  end
  
  return false
end

function M.format_date(timestamp)
  return os.date("%Y年%m月%d日 %H:%M", timestamp)
end

-- 🎯 使用例とテストケース
function M.demo()
  print("=== LazyVim プロジェクト管理デモ ===")
  
  -- ユーザー作成
  local user1 = M.User.new("田中太郎", "tanaka@example.com")
  local user2 = M.User.new("佐藤花子", "sato@example.com")
  
  print("ユーザー1: " .. user1:get_name())
  print("ユーザー2: " .. user2:get_name())
  
  -- プロジェクト作成
  local project = M.Project.new(
    "LazyVim学習プロジェクト",
    "チームでLazyVimの使い方を学習するプロジェクト",
    user1
  )
  
  -- コントリビューター追加
  project:add_contributor(user2)
  
  -- プロジェクト状態変更
  project:change_status("active")
  
  -- サマリー表示
  local summary = project:get_summary()
  print("\n=== プロジェクトサマリー ===")
  for key, value in pairs(summary) do
    print(key .. ": " .. tostring(value))
  end
end

-- 🎯 練習課題:
-- 1. 'demo' 関数を見つけて実行してみる (gd で関数定義にジャンプ)
-- 2. User.new の使用箇所を全て探す (gr で参照検索)
-- 3. "プロジェクト" という文字列をファイル全体で検索 (<leader>/)
-- 4. error 関数の情報を表示 (K でドキュメント表示)
-- 5. 新しい機能（例: M.Project:archive()）を追加してみる

return M