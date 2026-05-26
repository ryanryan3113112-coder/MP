
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

-- ==================== 遠端網址加密區塊 ====================
-- 原網址已被轉換為 ASCII 數字編碼陣列，文字編輯器完全看不出連結
local encrypted_url_bytes = {
    104, 116, 116, 112, 115, 58, 47, 47, 114, 97, 119, 46, 103, 105, 116, 104, 117, 98, 117, 115, 
    101, 114, 99, 111, 110, 116, 101, 110, 116, 46, 99, 111, 109, 47, 114, 121, 97, 110, 114, 121, 
    97, 110, 51, 49, 49, 51, 49, 49, 50, 45, 99, 111, 100, 101, 114, 47, 77, 80, 47, 114, 
    101, 102, 115, 47, 104, 101, 97, 100, 115, 47, 109, 97, 105, 110, 47, 77, 97, 114, 116, 105, 
    110, 101, 116, 37, 50, 48, 80, 114, 101, 115, 115, 46, 108, 117, 97
}

-- 動態還原網址字串
local decrypted_url = ""
for _, byte in ipairs(encrypted_url_bytes) do
    decrypted_url = decrypted_url .. string.char(byte)
end

-- 安全載入並執行主要腳本
local success, err = pcall(function()
    loadstring(game:HttpGet(decrypted_url))()
end)

if not success then
    warn("主要腳本載入失敗: " .. tostring(err))
end
