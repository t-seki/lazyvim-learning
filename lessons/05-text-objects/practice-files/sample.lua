-- Text Object練習用Luaファイル

-- 基本的な関数での練習
local function calculateArea(width, height)
    -- 引数の検証
    if width <= 0 or height <= 0 then
        error("Width and height must be positive numbers")
    end
    
    -- 面積を計算して返す
    return width * height
end

-- テーブル操作の練習
local userConfig = {
    name = "John Doe",
    email = "john@example.com",
    settings = {
        theme = "dark",
        fontSize = 14,
        autoSave = true,
        plugins = { "telescope", "treesitter", "lsp" }
    }
}

-- 条件分岐とループの練習
local function processItems(items)
    local results = {}
    
    for i, item in ipairs(items) do
        if type(item) == "string" then
            -- 文字列の処理
            table.insert(results, string.upper(item))
        elseif type(item) == "number" then
            -- 数値の処理
            table.insert(results, item * 2)
        else
            -- その他の型
            table.insert(results, tostring(item))
        end
    end
    
    return results
end

-- クラス風の構造（メタテーブル使用）
local Calculator = {}
Calculator.__index = Calculator

function Calculator:new()
    local self = setmetatable({}, Calculator)
    self.memory = 0
    self.history = {}
    return self
end

function Calculator:add(a, b)
    local result = a + b
    table.insert(self.history, string.format("%d + %d = %d", a, b, result))
    return result
end

function Calculator:subtract(a, b)
    local result = a - b
    table.insert(self.history, string.format("%d - %d = %d", a, b, result))
    return result
end

function Calculator:clearHistory()
    self.history = {}
    self.memory = 0
end

-- 文字列操作の練習
local function formatMessage(template, data)
    -- パターンマッチングを使った置換
    return (template:gsub("{(%w+)}", function(key)
        return tostring(data[key] or "")
    end))
end

-- ネストした構造の練習
local apiResponse = {
    status = "success",
    data = {
        users = {
            { id = 1, name = "Alice", role = "admin" },
            { id = 2, name = "Bob", role = "user" },
            { id = 3, name = "Charlie", role = "user" }
        },
        metadata = {
            total = 3,
            page = 1,
            perPage = 10
        }
    },
    timestamp = os.time()
}

-- エラーハンドリングの練習
local function safeDivide(a, b)
    if b == 0 then
        return nil, "Division by zero is not allowed"
    end
    
    local success, result = pcall(function()
        return a / b
    end)
    
    if success then
        return result, nil
    else
        return nil, "Calculation error: " .. tostring(result)
    end
end

-- モジュールのエクスポート
return {
    calculateArea = calculateArea,
    processItems = processItems,
    Calculator = Calculator,
    formatMessage = formatMessage,
    safeDivide = safeDivide
}