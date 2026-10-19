local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local gui = Instance.new("ScreenGui")
gui.Name = "HealthInspector"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.9, 0, 0.9, 0)
frame.Position = UDim2.new(0.05, 0, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.05, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "HP Handler Source | olliE"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.Font = Enum.Font.Code
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 0.95, -10)
scroll.Position = UDim2.new(0, 5, 0.05, 5)
scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = frame

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, 0, 0, 2000)
box.BackgroundTransparency = 1
box.TextColor3 = Color3.fromRGB(200, 255, 200)
box.MultiLine = true
box.TextWrapped = true
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.ClearTextOnFocus = false
box.Font = Enum.Font.Code
box.TextSize = 12
box.Parent = scroll

box:GetPropertyChangedSignal("TextBounds"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, box.TextBounds.Y + 20)
end)

local output = ""

local function readScript(obj, name)
    output = output .. "=== " .. name .. " ===\n"
    if not obj then
        output = output .. "Not found.\n\n"
        return
    end
    
    local success, source = pcall(function() return obj.Source end)
    if success and source and #source > 0 then
        output = output .. source .. "\n\n"
    else
        output = output .. "[Source hidden or protected]\n\n"
    end
end

-- Ищем HPHandler
local hpHandler = char:FindFirstChild("HPHandler") or char:FindFirstChild("Health2")
if hpHandler then
    if hpHandler:IsA("LocalScript") or hpHandler:IsA("Script") then
        readScript(hpHandler, "HPHandler")
    else
        for _, child in ipairs(hpHandler:GetDescendants()) do
            if child:IsA("Script") or child:IsA("LocalScript") then
                readScript(child, child:GetFullName())
            end
        end
    end
else
    output = output .. "HPHandler not found in Character.\n"
end

box.Text = output
