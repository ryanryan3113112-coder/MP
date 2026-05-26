local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 建立最外層 UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "System_AntiLeak_Protection"
screenGui.IgnoreGuiInset = true -- 讓 UI 可以跳到最螢幕邊緣
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 隨機亂數產生器
local random = Random.new()

-- 【核心功能：建立一個瘋狂亂跳、閃爍、抖動的警告視窗】
local function createWarningWindow()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 180)
    -- 初始隨機位置
    frame.Position = UDim2.new(random:NextNumber(0.1, 0.7), 0, random:NextNumber(0.1, 0.7), 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- 黑色背景
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.fromRGB(255, 0, 0) -- 紅色邊框
    frame.ZIndex = 100
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = frame

    -- 警告主要文字
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "⚠️ 偵測到洩漏 ⚠️\n\nDETECTED DATA LEAK\nACCESS DENIED"
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.TextSize = 22
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.ZIndex = 101
    textLabel.Parent = frame

    -- 1. 【抖動特效 (Shake)】
    local basePosition = frame.Position
    local shakeConnection
    shakeConnection = runService.RenderStepped:Connect(function()
        if not frame or not frame.Parent then 
            shakeConnection:Disconnect() 
            return 
        end
        -- 在目前位置加上微小的隨機偏移量
        local offsetX = random:NextNumber(-8, 8)
        local offsetY = random:NextNumber(-8, 8)
        frame.Position = UDim2.new(basePosition.X.Scale, basePosition.X.Offset + offsetX, basePosition.Y.Scale, basePosition.Y.Offset + offsetY)
    end)

    -- 2. 【紅黑閃爍特效 (Flash)】
    task.spawn(function()
        while frame and frame.Parent do
            frame.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- 變暗紅
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- 文字變白
            task.wait(0.1)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- 變回黑
            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- 文字變紅
            task.wait(0.1)
        end
    end)

    -- 3. 【畫面上亂跳特效 (Random Teleport)】
    task.spawn(function()
        while frame and frame.Parent do
            task.wait(random:NextNumber(0.3, 0.7)) -- 每隔 0.3 到 0.7 秒隨機跳躍一次
            -- 重新設定基準位置，讓抖動效果在新的位置繼續運作
            basePosition = UDim2.new(random:NextNumber(0.05, 0.75), 0, random:NextNumber(0.05, 0.75), 0)
        end
    end)
end

-- ==================== 執行邏輯 ====================

-- 執行後立刻彈出第一個黑方 UI
createWarningWindow()

-- 隔三秒後，跑出第二個，並且開始無限瘋狂複製，直到畫面滿掉
task.delay(3, function()
    while task.wait(0.5) do -- 每 0.5 秒多噴出一個視窗
        createWarningWindow()
    end
end)
