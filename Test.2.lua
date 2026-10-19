local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local gui = Instance.new("ScreenGui")
gui.Name = "SourceReader"
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
title.Text = "HitboxUtil Source | olliE"
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

local function getModuleSource(moduleName)
    local module = ReplicatedStorage:FindFirstChild(moduleName)
    if not module then return "[ERROR] " .. moduleName .. " not found in ReplicatedStorage." end
    
    local success, source = pcall(function() return module.Source end)
    if success and source and #source > 0 then
        return source
    else
        -- Try to require and list functions if Source is hidden
        local reqSuccess, reqResult = pcall(function() return require(module) end)
        if reqSuccess and type(reqResult) == "table" then
            local funcs = {}
            for k, v in pairs(reqResult) do
                table.insert(funcs, tostring(k) .. " (" .. type(v) .. ")")
            end
            return "[Source hidden] Module functions:\n" .. table.concat(funcs, "\n")
        else
            return "[Source hidden and require failed]"
        end
    end
end

local output = ""
output = output .. "=== HitboxUtil ===\n" .. getModuleSource("HitboxUtil") .. "\n\n"
output = output .. "=== DefenseUtil ===\n" .. getModuleSource("DefenseUtil") .. "\n\n"

box.Text = output
scroll.CanvasSize = UDim2.new(0, 0, 0, box.TextBounds.Y + 20)
