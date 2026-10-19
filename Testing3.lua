local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ValueScanner"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.9, 0, 0.8, 0)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.08, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "HP Value Scanner | olliE"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 0.9, -10)
scroll.Position = UDim2.new(0, 5, 0.08, 5)
scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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

local function scan(obj, path)
    for _, v in ipairs(obj:GetDescendants()) do
        if v:IsA("NumberValue") or v:IsA("IntValue") then
            local name = v.Name:lower()
            if name:find("hp") or name:find("health") or name:find("damage") or name:find("boss") or name:find("max") then
                addLog("[" .. v.ClassName .. "] " .. v:GetFullName() .. " = " .. tostring(v.Value))
            end
        end
    end
end

addLog("--- SCANNING WORKSPACE ---")
scan(game:GetService("Workspace"), "Workspace")
addLog("--- SCANNING REPLICATEDSTORAGE ---")
scan(game:GetService("ReplicatedStorage"), "ReplicatedStorage")
addLog("--- SCANNING LIGHTING ---")
scan(game:GetService("Lighting"), "Lighting")
addLog("--- DONE ---")
