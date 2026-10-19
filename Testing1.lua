local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local gui = Instance.new("ScreenGui")
gui.Name = "VisualHacks"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0.1, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.15, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "Visual Hacks | olliE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

-- Кнопка яркости
local lightBtn = Instance.new("TextButton")
lightBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
lightBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
lightBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
lightBtn.Text = "Remove Darkness: OFF"
lightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lightBtn.Font = Enum.Font.Code
lightBtn.TextSize = 12
lightBtn.Parent = frame

-- Кнопка подсветки
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
espBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
espBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espBtn.Text = "Boss Highlight: OFF"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Font = Enum.Font.Code
espBtn.TextSize = 12
espBtn.Parent = frame

-- Логика темноты
local isLight = false
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient

lightBtn.MouseButton1Click:Connect(function()
    isLight = not isLight
    if isLight then
        lightBtn.Text = "Remove Darkness: ON"
        lightBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(150, 150, 150)
        Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
        -- Убираем туман
        Lighting.FogEnd = 100000
    else
        lightBtn.Text = "Remove Darkness: OFF"
        lightBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalAmbient
    end
end)

-- Логика подсветки
local isEsp = false
local highlights = {}

local function getBosses()
    local bosses = {}
    local char = player.Character
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= char then
            local name = obj.Name:lower()
            if name:find("guy") or name:find("sans") or name:find("nightmare") or name:find("boss") then
                table.insert(bosses, obj)
            end
        end
    end
    return bosses
end

local function updateESP()
    if not isEsp then return end
    local bosses = getBosses()
    for _, boss in ipairs(bosses) do
        if not boss:FindFirstChild("OllieESP") then
            local hl = Instance.new("Highlight")
            hl.Name = "OllieESP"
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 0)
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.Parent = boss
            table.insert(highlights, hl)
        end
    end
end

espBtn.MouseButton1Click:Connect(function()
    isEsp = not isEsp
    if isEsp then
        espBtn.Text = "Boss Highlight: ON"
        espBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        updateESP()
    else
        espBtn.Text = "Boss Highlight: OFF"
        espBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        for _, hl in ipairs(highlights) do
            if hl then hl:Destroy() end
        end
        highlights = {}
    end
end)

-- Обновляем ESP каждые 2 секунды
task.spawn(function()
    while task.wait(2) do
        if isEsp then updateESP() end
    end
end)
