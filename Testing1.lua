local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")

local gui = Instance.new("ScreenGui")
gui.Name = "OldSchoolKill"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.1, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.3, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "Old School Kill | olliE"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0.4, 0)
btn.Position = UDim2.new(0.05, 0, 0.4, 0)
btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btn.Text = "TRY KILL"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.Code
btn.TextSize = 16
btn.Parent = frame

btn.MouseButton1Click:Connect(function()
    -- 1. Пытаемся расширить радиус
    pcall(function()
        sethiddenproperty(player, "SimulationRadius", 69696969)
        sethiddenproperty(player, "MaxSimulationRadius", math.huge)
    end)

    local killed = 0
    -- 2. Ищем боссов
    for i, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") then
            local parent = v.Parent
            -- Проверяем теги (Zombie, NPCTAG) или имя
            if parent:FindFirstChild("Zombie") or parent:FindFirstChild("NPCTAG") or parent.Name:lower():find("boss") then
                pcall(function()
                    -- Пытаемся убить через Health
                    v.Health = 0
                    v.MaxHealth = 0
                    -- Пытаемся убить через TakeDamage
                    v:TakeDamage(math.huge)
                    
                    -- Пытаемся удалить части (как в старом скрипте)
                    if parent:FindFirstChild("Head") then parent.Head:Destroy() end
                    if parent:FindFirstChild("Torso") then parent.Torso:Destroy() end
                    
                    killed = killed + 1
                end)
            end
        end
    end
    
    btn.Text = "Tried: " .. killed
end)
