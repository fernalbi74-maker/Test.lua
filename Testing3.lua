local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")

local gui = Instance.new("ScreenGui")
gui.Name = "BreakHeal"
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
title.Text = "Break Heal | olliE"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0.4, 0)
btn.Position = UDim2.new(0.05, 0, 0.4, 0)
btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btn.Text = "BREAK HEAL & KILL"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.Code
btn.TextSize = 16
btn.Parent = frame

btn.MouseButton1Click:Connect(function()
    pcall(function()
        sethiddenproperty(player, "SimulationRadius", 69696969)
        sethiddenproperty(player, "MaxSimulationRadius", math.huge)
    end)

    local killed = 0
    for i, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") then
            local parent = v.Parent
            if parent:FindFirstChild("Zombie") or parent:FindFirstChild("NPCTAG") or parent.Name:lower():find("boss") then
                pcall(function()
                    -- Ломаем скрипты
                    if parent:FindFirstChild("Zombie") then
                        for _, z in ipairs(parent.Zombie:GetChildren()) do
                            if z:IsA("Script") or z:IsA("LocalScript") then z:Destroy() end
                        end
                    end
                    if parent:FindFirstChild("AI") then
                        if parent.AI:IsA("Script") or parent.AI:IsA("LocalScript") then parent.AI:Destroy() end
                    end
                    if parent:FindFirstChild("Head") then
                        for _, h in ipairs(parent.Head:GetChildren()) do
                            if h:IsA("Script") then h:Destroy() end
                        end
                    end
                    
                    -- Убиваем
                    v.Health = 0
                    v.MaxHealth = 0
                    v:TakeDamage(math.huge)
                    
                    killed = killed + 1
                end)
            end
        end
    end
    
    btn.Text = "Killed: " .. killed
end)
