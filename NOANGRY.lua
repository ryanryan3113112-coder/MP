
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

-- ==================== 主介面 ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestPanel_" .. math.random(10000, 99999)
screenGui.ResetOnSpawn = false
screenGui.Enabled = true          -- 預設開啟
screenGui.DisplayOrder = 100000
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 460, 0, 650)
frame.Position = UDim2.new(0.5, -230, 0.5, -325)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BorderSizePixel = 0
frame.Visible = true              -- 預設顯示
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 0)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 55)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 0)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Martinet Press P 開關"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 21
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(1, 0, 0, 2)
titleLine.Position = UDim2.new(0, 0, 1, 0)
titleLine.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
titleLine.BorderSizePixel = 0
titleLine.Parent = titleBar

-- ==================== 縮小/展開按鈕 ====================
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -45, 0, 7)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

-- 關閉按鈕
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -90, 0, 7)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

-- ==================== 按鈕 ====================
local buttons = {}

for i = 1, 10 do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, 75 + (i-1)*55)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    btn.TextColor3 = Color3.fromRGB(200, 220, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "測試 " .. i
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 0)
    
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(25, 25, 45) end)
    
    buttons[i] = btn
end

-- ==================== 縮小化功能 ====================
local isMinimized = false
local originalSize = frame.Size

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        frame.Size = UDim2.new(0, 460, 0, 55)   -- 只剩標題
        for _, btn in ipairs(buttons) do
            btn.Visible = false
        end
        minimizeBtn.Text = "+"
    else
        frame.Size = originalSize
        for _, btn in ipairs(buttons) do
            btn.Visible = true
        end
        minimizeBtn.Text = "—"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    frame.Visible = false
end)

-- ==================== 可拖動 ====================
local dragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local function safeExecute(func)
    pcall(func)
end

-- ==================== 測試1：透視 ====================
local espEnabled = false
local espObjects = {}

local function updateESP()
    if not espEnabled then return end
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            if Players:GetPlayerFromCharacter(model) == player then continue end
            if not model:FindFirstChild("TestESP") then
                local hl = Instance.new("Highlight")
                hl.Name = "TestESP"
                hl.FillColor = Players:GetPlayerFromCharacter(model) and Color3.fromRGB(255, 80, 180) or Color3.fromRGB(0, 255, 200)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.55
                hl.Adornee = model
                hl.Parent = model
                table.insert(espObjects, hl)
            end
        end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        print("✅ 透視已開啟")
        task.spawn(function()
            while espEnabled do updateESP() task.wait(0.4) end
        end)
    else
        for _, v in ipairs(espObjects) do v:Destroy() end
        espObjects = {}
        print("❌ 透視已關閉")
    end
end

buttons[1].MouseButton1Click:Connect(function() safeExecute(toggleESP) end)

-- ==================== 測試2~6 (保持不變) ====================
-- 測試2：純移速
local speedEnabled = false
local function toggleSpeed()
    speedEnabled = not speedEnabled
    if speedEnabled then
        print("✅ 移速加快 已開啟 (速度 65)")
        task.spawn(function()
            while speedEnabled do
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 65 end
                task.wait(0.25)
            end
        end)
    else
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
        print("❌ 移速加快 已關閉")
    end
end
buttons[2].MouseButton1Click:Connect(function() safeExecute(toggleSpeed) end)

-- 測試3：穿牆 (保持不變)
local noclipEnabled = false
local noclipConnection = nil
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    print("穿牆模式：" .. (noclipEnabled and "✅ 開啟" or "❌ 關閉"))
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end
buttons[3].MouseButton1Click:Connect(function() safeExecute(toggleNoclip) end)

-- 測試4：白圓FOV自瞄 (保持不變)
local aimEnabled = false
local fovRadius = 180
local whiteCircle = Drawing.new("Circle")
whiteCircle.Thickness = 2
whiteCircle.NumSides = 100
whiteCircle.Radius = fovRadius
whiteCircle.Color = Color3.fromRGB(255,255,255)
whiteCircle.Filled = false
whiteCircle.Transparency = 0.7
whiteCircle.Visible = false

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.IgnoreWater = true

local function canSeeTarget(targetHead, targetModel)
    if not targetHead then return false end
    local startPos = Camera.CFrame.Position
    local direction = (targetHead.Position - startPos)
    raycastParams.FilterDescendantsInstances = {player.Character or {}, targetModel}
    return Workspace:Raycast(startPos, direction.Unit * direction.Magnitude, raycastParams) == nil
end

local function getClosestInFOV(radius)
    local closest, minDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
            if Players:GetPlayerFromCharacter(obj) == player then continue end
            local hum = obj:FindFirstChild("Humanoid")
            local head = obj:FindFirstChild("Head")
            if hum and hum.Health > 0 and head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist <= radius and dist < minDist and canSeeTarget(head, obj) then
                        minDist = dist
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end

local aimConn = nil
local function toggleAimbot()
    aimEnabled = not aimEnabled
    whiteCircle.Visible = aimEnabled
    print("白圓FOV自瞄：" .. (aimEnabled and "✅ 開啟" or "❌ 關閉"))
    if aimEnabled then
        aimConn = RunService.RenderStepped:Connect(function()
            whiteCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            local target = getClosestInFOV(fovRadius)
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end)
    else
        if aimConn then aimConn:Disconnect() aimConn = nil end
    end
end
buttons[4].MouseButton1Click:Connect(function() safeExecute(toggleAimbot) end)

-- ==================== 測試5：AUTO KILL (頭頂 + O鍵關閉) ====================
-- main.lua
-- 付費專用 黑色方形 UI（可關閉）

function love.load()
    love.window.setTitle("付費專用")
    
    -- 視窗大小
    local width = 420
    local height = 280
    
    -- 設定視窗置中
    love.window.setMode(width, height, {
        centered = true,
        resizable = false,
        borderless = false,   -- 保留標題列讓叉叉出現
    })
    
    -- 字型
    font_big = love.graphics.newFont(48)
    font_small = love.graphics.newFont(24)
end

function love.draw()
    -- 黑色背景
    love.graphics.clear(0, 0, 0, 1)
    
    -- 畫邊框
    love.graphics.setColor(1, 1, 1, 0.15)
    love.graphics.setLineWidth(8)
    love.graphics.rectangle("line", 20, 20, 380, 240)
    
    -- 主標題
    love.graphics.setFont(font_big)
    love.graphics.setColor(1, 0.2, 0.2, 1)   -- 紅色
    love.graphics.printf("付費專用", 0, 70, 420, "center")
    
    -- 副標題
    love.graphics.setFont(font_small)
    love.graphics.setColor(0.9, 0.9, 0.9, 1)
    love.graphics.printf("VIP Exclusive", 0, 140, 420, "center")
    
    love.graphics.setColor(0.6, 0.6, 0.6, 1)
    love.graphics.printf("已授權版本", 0, 180, 420, "center")
end

-- 按 ESC 也可以關閉
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

-- ==================== O 鍵快速關閉測試5 ====================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.O then
        if autoKillEnabled then
            autoKillEnabled = false
            if autoKillConnection then 
                autoKillConnection:Disconnect() 
                autoKillConnection = nil 
            end
            print("❌ AUTO KILL 已透過 O 鍵關閉")
        end
    end
end)

-- ==================== 測試6：簡化飛行 (保持不變) ====================
local flyEnabled = false
local flyConnection = nil

local function toggleFly()
    flyEnabled = not flyEnabled
    print("簡化飛行模式：" .. (flyEnabled and "✅ 開啟 (WASD + Space上升)" or "❌ 關閉"))
    if flyEnabled then
        flyConnection = RunService.Heartbeat:Connect(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
            
            if moveDir.Magnitude > 0 then
                root.Velocity = moveDir.Unit * 85
            else
                root.Velocity = Vector3.new(root.Velocity.X * 0.96, root.Velocity.Y * 0.98, root.Velocity.Z * 0.96)
            end
        end)
    else
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    end
end
buttons[6].MouseButton1Click:Connect(function() safeExecute(toggleFly) end)

-- ==================== 測試7：變天空晚上 ====================
local nightSkyEnabled = false

local function toggleNightSky()
    nightSkyEnabled = not nightSkyEnabled
    print("夜晚天空模式：" .. (nightSkyEnabled and "✅ 開啟" or "❌ 關閉"))
    
    if nightSkyEnabled then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.3
        Lighting.Ambient = Color3.fromRGB(10, 10, 30)
        Lighting.FogEnd = 800
        Lighting.FogColor = Color3.fromRGB(5, 5, 15)
        print("🌙 已切換為夜晚模式")
    else
        Lighting.ClockTime = 14
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.FogEnd = 100000
        print("☀️ 已恢復白天")
    end
end

buttons[7].MouseButton1Click:Connect(function() safeExecute(toggleNightSky) end)

-- ==================== 測試8 & 9 (保持不變) ====================
-- 測試8：高級Chams
local function copyDiscordLink()
    local link = "https://discord.gg/B82Q8cPFKB"
    if setclipboard then
        setclipboard(link)
        print("✅ Discord 連結已複製到剪貼簿！")
    else
        print("❌ 此遊戲不支援 setclipboard")
    end
end

buttons[8].MouseButton1Click:Connect(function()
    safeExecute(copyDiscordLink)
end)
-- 測試9：彩虹名字標籤 (保持不變)
local nameTagsEnabled = false
local nameTags = {}
local function toggleRainbowNameTags()
    nameTagsEnabled = not nameTagsEnabled
    print("動態彩虹名字標籤：" .. (nameTagsEnabled and "✅ 開啟" or "❌ 關閉"))
    if nameTagsEnabled then
        task.spawn(function()
            while nameTagsEnabled do
                for _, model in ipairs(Workspace:GetDescendants()) do
                    if model:IsA("Model") and model:FindFirstChild("Head") and model:FindFirstChild("Humanoid") then
                        if Players:GetPlayerFromCharacter(model) == player then continue end
                        if not model:FindFirstChild("RainbowTag") then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Name = "RainbowTag"
                            billboard.Adornee = model.Head
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.StudsOffset = Vector3.new(0, 3, 0)
                            billboard.AlwaysOnTop = true
                            local text = Instance.new("TextLabel", billboard)
                            text.Size = UDim2.new(1, 0, 1, 0)
                            text.BackgroundTransparency = 1
                            text.Text = model.Name or "NPC"
                            text.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                            text.TextScaled = true
                            text.Font = Enum.Font.GothamBold
                            billboard.Parent = model
                            table.insert(nameTags, billboard)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    else
        for _, v in ipairs(nameTags) do v:Destroy() end
        nameTags = {}
    end
end
buttons[9].MouseButton1Click:Connect(function() safeExecute(toggleRainbowNameTags) end)
local purpleEffectEnabled = false
local colorCorrection = nil

local function togglePurpleEffect()
    purpleEffectEnabled = not purpleEffectEnabled
    print("畫面負片紫色效果：" .. (purpleEffectEnabled and "✅ 開啟" or "❌ 關閉"))
    
    if purpleEffectEnabled then
        if not colorCorrection then
            colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Parent = Lighting
        end
        colorCorrection.Saturation = -0.8
        colorCorrection.Contrast = 0.3
        colorCorrection.Brightness = 0.1
        colorCorrection.TintColor = Color3.fromRGB(180, 100, 255)  -- 偏紫色調
    else
        if colorCorrection then
            colorCorrection.Saturation = 0
            colorCorrection.Contrast = 0
            colorCorrection.Brightness = 0
            colorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
        end
    end
end

buttons[10].MouseButton1Click:Connect(function() safeExecute(togglePurpleEffect) end)

-- ==================== 按鈕文字 ====================
buttons[1].Text = "1 - 透視 ESP"
buttons[2].Text = "2 - 移速加快"
buttons[3].Text = "3 - 穿牆"
buttons[4].Text = "4 - 白圓FOV自瞄"
buttons[5].Text = "5 - 憤怒功能"
buttons[6].Text = "6 - 簡化飛行"
buttons[7].Text = "7 - 變天"
buttons[8].Text = "8 - 加入DC"
buttons[9].Text = "9 - 彩虹名字標籤"
buttons[10].Text = "10 - 紫色負片"

-- ==================== P 鍵 ====================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.P then
        screenGui.Enabled = not screenGui.Enabled
        frame.Visible = screenGui.Enabled
    end
end)

print("Martinet Press 載入成功！")
