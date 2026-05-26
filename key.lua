
local CorrectKey = "MARTINET-2026"

local key = getgenv().script_key

if not key then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Key System",
        Text = "No Key Detected",
        Duration = 5
    })

    return
end

if key ~= CorrectKey then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Key System",
        Text = "Invalid Key",
        Duration = 5
    })

    return
end

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Key System",
    Text = "Key Accepted",
    Duration = 3
})

