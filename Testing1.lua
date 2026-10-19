local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")

local gui = Instance.new("ScreenGui")
gui.Name = "EpicQuestSpy"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.1, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.15, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "Epic Quest Inspector"
title.TextColor3 = Color3.fromRGB(255, 0, 255)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 0.65, -10)
scroll.Position = UDim2.new(0, 5, 0.15, 5)
scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll

local function addLog(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 255, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.Parent = scroll
    layout:ApplyLayout()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
scanBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
scanBtn.Text = "SCAN EPIC!SANS"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.Code
scanBtn.Parent = frame

scanBtn.MouseButton1Click:Connect(function()
    scroll:ClearAllChildren()
    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    
    local questData = workspace:FindFirstChild("QuestData")
    if not questData then return addLog("QuestData not found!") end
    
    local epicQuest = questData:FindFirstChild("Epic!Sans")
    if not epicQuest then return addLog("Epic!Sans folder not found!") end
    
    addLog("--- SCANNING Epic!Sans ---")
    
    for _, obj in ipairs(epicQuest:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            addLog("[Remote] " .. obj.Name)
        elseif obj:IsA("Script") or obj:IsA("LocalScript") then
            addLog("[Script] " .. obj.Name)
        elseif obj:IsA("BoolValue") or obj:IsA("NumberValue") then
            addLog("[" .. obj.ClassName .. "] " .. obj.Name .. " = " .. tostring(obj.Value))
        end
    end
    addLog("--- END ---")
end)
