local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")

local gui = Instance.new("ScreenGui")
gui.Name = "OllieForceHit"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.1, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.4, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "Force Hit | olliE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 16
toggleBtn.Parent = frame

local isForcing = false

local function getBoss()
    local char = player.Character
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= char then
            local name = obj.Name:lower()
            if name:find("guy") or name:find("sans") or name:find("nightmare") or name:find("boss") then
                return obj
            end
        end
    end
    return nil
end

-- Хук на имя функции
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if method == "FireServer" and isForcing then
        local args = {...}
        
        -- Проверяем, что это выстрел из бластера (3 аргумента, все числа)
        if #args == 3 and type(args[1]) == "number" and type(args[2]) == "number" and type(args[3]) == "number" then
            local boss = getBoss()
            if boss then
                local hrp = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Head")
                if hrp then
                    local pos = hrp.Position
                    -- Подменяем аргументы на координаты босса
                    return oldNamecall(self, pos.X, pos.Y, pos.Z)
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

toggleBtn.MouseButton1Click:Connect(function()
    isForcing = not isForcing
    if isForcing then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)
