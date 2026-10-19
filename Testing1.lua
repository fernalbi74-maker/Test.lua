local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "DamageBoost"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.1, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.3, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "Damage Boost | olliE"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0.4, 0)
btn.Position = UDim2.new(0.05, 0, 0.4, 0)
btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btn.Text = "BOOST DAMAGE"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.Code
btn.TextSize = 16
btn.Parent = frame

btn.MouseButton1Click:Connect(function()
    local attackTools = Lighting:FindFirstChild("AttackTools")
    if not attackTools then 
        btn.Text = "No AttackTools"
        return 
    end
    
    local count = 0
    for _, v in ipairs(attackTools:GetDescendants()) do
        if v:IsA("NumberValue") and v.Name == "Damage" then
            v.Value = 999999999
            count = count + 1
        end
    end
    
    btn.Text = "Boosted: " .. count
end)
