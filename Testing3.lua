local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "HealthSpy"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.8, 0, 0.3, 0)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Incoming HP Spy | olliE"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 0.75, -10)
scroll.Position = UDim2.new(0, 5, 0.2, 5)
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
    lbl.TextColor3 = Color3.fromRGB(0, 255, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.Parent = scroll
    layout:ApplyLayout()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- Слушаем ВСЕ RemoteEvents в игре
for _, obj in ipairs(game:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        obj.OnClientEvent:Connect(function(...)
            local args = {...}
            local argStr = ""
            for i, v in ipairs(args) do
                if type(v) == "number" then
                    -- Если число большое (похоже на ХП), подсвечиваем
                    if v > 1000 or v < -100 then
                        argStr = argStr .. "[" .. tostring(v) .. "] "
                    else
                        argStr = argStr .. tostring(v) .. " "
                    end
                end
            end
            if #argStr > 0 then
                addLog("[" .. obj.Name .. "] Args: " .. argStr)
            end
        end)
    end
end
