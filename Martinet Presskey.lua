

local CorrectKey = "Martinet Press"

local key = getgenv().script_key

if not key then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Martinet Press",
        Text = "No Key Detected",
        Duration = 5
    })

    return
end

if key ~= CorrectKey then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Martinet Press",
        Text = "Invalid Key",
        Duration = 5
    })

    return
end

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Martinet Press",
    Text = "Key Accepted",
    Duration = 3
})

-- Load Main Script
loadstring(game:HttpGet("https://raw.githubusercontent.com/ryanryan3113112-coder/MP/refs/heads/main/Martinet%20Press.lua"))()
