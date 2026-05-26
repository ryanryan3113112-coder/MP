local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Loader"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 200)
frame.Position = UDim2.new(0.5, -200, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 140, 0)
stroke.Thickness = 3
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.55, 0)
title.BackgroundTransparency = 1
title.Text = "載入中"
title.TextColor3 = Color3.fromRGB(255, 200, 100)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0.45, 0)
subtitle.Position = UDim2.new(0, 0, 0.55, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "請稍候..."
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = frame

local RunService = game:GetService("RunService")
local connection = RunService.Heartbeat:Connect(function()
    local t = tick() * 1.2
    local offsetX = math.sin(t * 1.8) * 0.28 + math.cos(t * 1.1) * 0.15
    local offsetY = math.sin(t * 1.4) * 0.22 + math.cos(t * 2.3) * 0.12
    frame.Position = UDim2.new(0.5 + offsetX, -200, 0.5 + offsetY, -100)
    
    local dots = math.floor((tick() * 2) % 4)
    title.Text = "載入中" .. string.rep(".", dots)
end)


task.wait(2.3)

local success, err = pcall(function()

    local p1 = "https://raw.githubusercontent.com/"
    local p2 = "ryanryan3113112-coder/MP/refs/heads/main/"
    

    local real = "freephone.lua" 
    
    local a = p1 .. p2
    local b = real:sub(1,3) .. real:sub(4)
    local finalUrl = a .. b
    
    local code = game:HttpGet(finalUrl)
    
    connection:Disconnect()
    screenGui:Destroy()
    
    loadstring(code)()
    print("✅ 載入成功")
end)

if not success then
    connection:Disconnect()
    screenGui:Destroy()
    warn("載入失敗: " .. tostring(err))
end
