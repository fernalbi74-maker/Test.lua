local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local userInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Name = "OllieAutoShoot"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.1, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.25, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "Auto-Shoot | olliE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 16
toggleBtn.Parent = frame

local isRunning = false
local shootTask = nil

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

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        if shootTask then task.cancel(shootTask) end
        shootTask = task.spawn(function()
            while isRunning do
                local boss = getBoss()
                if boss then
                    local hrp = boss:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        -- 1. Наводим камеру на босса
                        camera.CFrame = CFrame.new(camera.CFrame.Position, hrp.Position)
                        
                        -- 2. Находим инструмент
                        local char = player.Character
                        local tool = char and char:FindFirstChild("Gaster Blaster")
                        if not tool then
                            local backpack = player:FindFirstChild("Backpack")
                            tool = backpack and backpack:FindFirstChild("Gaster Blaster")
                            if tool then
                                tool.Parent = char -- Экипируем
                            end
                        end
                        
                        -- 3. Выстрел
                        if tool and tool.Parent == char then
                            pcall(function()
                                tool:Activate() -- Нажимаем кнопку "выстрел" программно
                            end)
                        end
                    end
                end
                task.wait(0.5) -- Интервал между выстрелами
            end
        end)
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if shootTask then
            task.cancel(shootTask)
            shootTask = nil
        end
    end
end)
