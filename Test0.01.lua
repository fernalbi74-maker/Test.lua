local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "TaterScanner"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.9, 0, 0.8, 0)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.08, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "TBSOBR Structure Scanner | olliE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 16
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 0.9, -20)
scroll.Position = UDim2.new(0, 10, 0.1, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local function addLog(text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 14
    lbl.TextWrapped = true
    lbl.Parent = scroll
    layout:ApplyLayout()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

addLog("--- SCANNING LIGHTING ---", Color3.fromRGB(255, 255, 0))

-- 1. Scan Lighting.Values
local values = game:GetService("Lighting"):FindFirstChild("Values")
if values then
    addLog("[Found] Lighting.Values", Color3.fromRGB(0, 255, 0))
    for _, v in pairs(values:GetChildren()) do
        addLog("  - " .. v.Name .. " [" .. v.ClassName .. "]", Color3.fromRGB(150, 150, 255))
    end
else
    addLog("[Missing] Lighting.Values", Color3.fromRGB(255, 0, 0))
end

-- 2. Scan Lighting for RemoteEvents and specific Scripts
addLog("--- LIGHTING REMOTES/SCRIPTS ---", Color3.fromRGB(255, 255, 0))
local function scanLighting(obj, depth)
    if depth > 3 then return end
    for _, v in pairs(obj:GetChildren()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            addLog("[Remote] " .. v:GetFullName(), Color3.fromRGB(255, 165, 0))
        elseif v:IsA("BoolValue") and (v.Name:lower():find("god") or v.Name:lower():find("death") or v.Name:lower():find("admin")) then
            addLog("[Bool] " .. v:GetFullName() .. " = " .. tostring(v.Value), Color3.fromRGB(255, 100, 100))
        elseif v:IsA("Script") or v:IsA("LocalScript") then
             if v.Name:lower():find("attack") or v.Name:lower():find("correction") or v.Name:lower():find("damage") then
                addLog("[Script] " .. v:GetFullName() .. " (Disabled: " .. tostring(v.Disabled) .. ")", Color3.fromRGB(255, 100, 255))
             end
        end
        scanLighting(v, depth + 1)
    end
end
scanLighting(game:GetService("Lighting"), 0)

addLog("--- SCANNING WORKSPACE ---", Color3.fromRGB(255, 255, 0))

-- 3. Scan Workspace for specific scripts
local function scanWorkspace(obj, depth)
    if depth > 2 then return end
    for _, v in pairs(obj:GetChildren()) do
        if v.Name == "LockWorkspace" or v.Name == "NightmareROAR" or v.Name == "Script" or v.Name == "teleport" then
            addLog("[Target] " .. v:GetFullName() .. " [" .. v.ClassName .. "]", Color3.fromRGB(0, 255, 255))
            if v:IsA("BaseScript") then
                addLog("  Disabled: " .. tostring(v.Disabled), Color3.fromRGB(200, 200, 200))
            end
        end
        scanWorkspace(v, depth + 1)
    end
end
scanWorkspace(game:GetService("Workspace"), 0)

-- 4. Scan PlayerGui for health/damage scripts
addLog("--- SCANNING PLAYER GUI ---", Color3.fromRGB(255, 255, 0))
for _, v in pairs(player.PlayerGui:GetChildren()) do
    if v.Name:lower():find("health") or v.Name:lower():find("damage") or v.Name:lower():find("hp") then
        addLog("[GUI Script] " .. v:GetFullName(), Color3.fromRGB(255, 150, 0))
    end
end

addLog("--- SCAN COMPLETE ---", Color3.fromRGB(0, 255, 0))
addLog("Read through the list, Sam. Look for Remotes or Bools.", Color3.fromRGB(200, 200, 200))
