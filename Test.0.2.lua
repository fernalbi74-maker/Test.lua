local services = {
    game:GetService("Lighting"),
    game:GetService("ReplicatedStorage"),
    game:GetService("Workspace"),
    game.Players.LocalPlayer:WaitForChild("PlayerGui")
}

local output = {}
local count = 0
local MAX_COUNT = 300 -- Ограничитель, чтобы не завис телефон

local function scan(obj)
    if count >= MAX_COUNT then return end
    
    local success, descendants = pcall(function() return obj:GetDescendants() end)
    if not success then return end

    for _, v in ipairs(descendants) do
        if count >= MAX_COUNT then break end
        
        local s, isTarget = pcall(function()
            return v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") or v:IsA("RemoteEvent") or v:IsA("RemoteFunction")
        end)
        
        if s and isTarget then
            local path = v:GetFullName()
            -- Исключаем спам звуками, чтобы не забивать список
            if not path:find("CharacterSoundEvent") and not path:find("Music") and not path:find("Sound") then
                table.insert(output, "[" .. v.ClassName .. "] " .. path)
                count = count + 1
            end
        end
    end
end

for _, srv in ipairs(services) do
    scan(srv)
end

local finalString = table.concat(output, "\n")

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ManualDumpGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.95, 0, 0.95, 0)
frame.Position = UDim2.new(0.025, 0, 0.025, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.05, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Copy The List Manually | olliE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 0.95, -10)
scroll.Position = UDim2.new(0, 5, 0.05, 5)
scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.Parent = frame

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, 0, 0, 2000) -- Высота будет расти
box.BackgroundTransparency = 1
box.TextColor3 = Color3.fromRGB(200, 255, 200)
box.Text = finalString
box.MultiLine = true
box.TextWrapped = true
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.ClearTextOnFocus = false -- Чтобы не стиралось при клике
box.Font = Enum.Font.Code
box.TextSize = 12
box.Parent = scroll

-- Автоматически подгоняем размер холста под текст
box:GetPropertyChangedSignal("TextBounds"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, box.TextBounds.Y + 20)
end)

scroll.CanvasSize = UDim2.new(0, 0, 0, box.TextBounds.Y + 20)
