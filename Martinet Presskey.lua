-- 1. 配置
local CORRECT_KEY = "Martinet Press" -- 這裡設定你的金鑰

-- 2. 驗證成功後的執行動作
local function StartProject()
    print("驗證通過，正在載入主程式...")
    
    -- 執行你的遠端腳本
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ryanryan3113112-coder/MP/refs/heads/main/Martinet%20Press.lua"))()
    end)
    
    if not success then
        warn("主程式載入失敗: " .. tostring(err))
    end
end

-- 3. 建立 UI 介面 (保持不變)
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystemUI"
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- 裝飾：讓邊角變圓滑
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "CROW PROJECT | KEY SYSTEM"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.8, 0, 0, 30)
TextBox.Position = UDim2.new(0.1, 0, 0.4, 0)
TextBox.PlaceholderText = "輸入金鑰..."
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.Parent = MainFrame

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 30)
SubmitBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
SubmitBtn.Text = "提交驗證"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)
SubmitBtn.Font = Enum.Font.Gotham
SubmitBtn.Parent = MainFrame

-- 4. 驗證邏輯
SubmitBtn.MouseButton1Click:Connect(function()
    if TextBox.Text == CORRECT_KEY then
        SubmitBtn.Text = "驗證成功"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- 變綠色
        task.wait(0.5)
        
        ScreenGui:Destroy() -- 關閉 UI
        StartProject()      -- 執行遠端代碼
    else
        SubmitBtn.Text = "金鑰無效"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0) -- 變紅色
        task.wait(1)
        
        -- 恢復原狀
        SubmitBtn.Text = "提交驗證"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)
