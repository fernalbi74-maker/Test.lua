local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DeepScanner"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.9, 0, 0.9, 0)
frame.Position = UDim2.new(0.05, 0, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.06, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "TBSOBR Deep Scanner | olliE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 0.92, -20)
scroll.Position = UDim2.new(0, 10, 0.07, 10)
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
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.TextWrapped = true
    lbl.Parent = scroll
    layout:ApplyLayout()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

local function scanDeep(obj, depth)
    if depth > 4 then return end
    
    for _, v in pairs(obj:GetChildren()) do
        local indent = string.rep("  ", depth)
        local isTarget = false
        local color = Color3.fromRGB(200, 200, 200)
        
        -- Targets
        if v.Name:lower():find("attack") or v.Name:lower():find("damage") or v.Name:lower():find("death") or v.Name:lower():find("god") or v.Name:lower():find("barrage") or v.Name:lower():find("blaster") or v.Name:lower():find("firstattack") then
            isTarget = true
            color = Color3.fromRGB(255, 255, 0) -- Yellow for targets
        elseif v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            isTarget = true
            color = Color3.fromRGB(255, 165, 0) -- Orange for remotes
        elseif v:IsA("LocalScript") or v:IsA("ModuleScript") then
            isTarget = true
            color = Color3.fromRGB(0, 255, 255) -- Cyan for readable scripts
        end
        
        if isTarget then
            addLog(indent .. "[" .. v.ClassName .. "] " .. v.Name, color)
            
            -- Try to read source
            if v:IsA("LocalScript") or v:IsA("ModuleScript") then
                local success, source = pcall(function() return v.Source end)
                if success and source and #source > 0 then
                    -- Just print first few lines to avoid lag
                    local lines = string.split(source, "\n")
                    local count = 0
                    for _, line in ipairs(lines) do
                        if count >= 10 then 
                            addLog(indent .. "  ... (truncated)", Color3.fromRGB(150, 150, 150))
                            break 
                        end
                        if line:gsub("%s", "") ~= "" then
                            addLog(indent .. "  | " .. line, Color3.fromRGB(150, 255, 150))
                            count = count + 1
                        end
                    end
                else
                    addLog(indent .. "  (Source hidden/protected)", Color3.fromRGB(255, 100, 100))
                end
            end
            
            -- Check for Bools/Values inside targets
            for _, child in pairs(v:GetChildren()) do
                if child:IsA("BoolValue") or child:IsA("NumberValue") or child:IsA("StringValue") then
                    addLog(indent .. "  -> " .. child.Name .. " = " .. tostring(child.Value), Color3.fromRGB(255, 100, 255))
                end
            end
        end
        
        scanDeep(v, depth + 1)
    end
end

addLog("--- STARTING DEEP SCAN ---", Color3.fromRGB(0, 255, 0))
scanDeep(game:GetService("Lighting"), 0)
scanDeep(game:GetService("Workspace"), 0)
addLog("--- SCAN COMPLETE ---", Color3.fromRGB(0, 255, 0))
addLog("Scroll down to read.", Color3.fromRGB(255, 255, 255))
