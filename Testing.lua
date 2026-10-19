local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- Создаем UI
local gui = Instance.new("ScreenGui")
gui.Name = "OllieBlasterControl"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
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
title.Text = "Blaster Control | olliE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

-- Кнопка поиска босса
local findBtn = Instance.new("TextButton")
findBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
findBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
findBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
findBtn.Text = "1. Find Boss"
findBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
findBtn.Font = Enum.Font.Code
findBtn.TextSize = 14
findBtn.Parent = frame

-- Кнопка выстрела
local shootBtn = Instance.new("TextButton")
shootBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
shootBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
shootBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
shootBtn.Text = "2. Fire at Boss"
shootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
shootBtn.Font = Enum.Font.Code
shootBtn.TextSize = 14
shootBtn.Parent = frame

-- Лог
local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(0.9, 0, 0.2, 0)
logLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
logLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
logLabel.Text = "Ready."
logLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
logLabel.Font = Enum.Font.Code
logLabel.TextSize = 12
logLabel.TextWrapped = true
logLabel.Parent = frame

-- Логика
local targetBoss = nil
local targetPos = nil

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

findBtn.MouseButton1Click:Connect(function()
    targetBoss = getBoss()
    if targetBoss then
        local hrp = targetBoss:FindFirstChild("HumanoidRootPart")
        if hrp then
            targetPos = hrp.Position
            logLabel.Text = "Found: " .. targetBoss.Name .. " at " .. tostring(math.floor(targetPos.X)) .. ", " .. tostring(math.floor(targetPos.Y)) .. ", " .. tostring(math.floor(targetPos.Z))
        else
            logLabel.Text = "Boss found, but no HRP."
        end
    else
        logLabel.Text = "Boss not found."
    end
end)

shootBtn.MouseButton1Click:Connect(function()
    if not targetBoss or not targetPos then
        logLabel.Text = "Find boss first!"
        return
    end
    
    local char = player.Character
    local tool = char and char:FindFirstChild("Gaster Blaster")
    if not tool then
        local backpack = player:FindFirstChild("Backpack")
        tool = backpack and backpack:FindFirstChild("Gaster Blaster")
    end
    
    if tool then
        if tool.Parent ~= char then
            tool.Parent = char
            task.wait(0.2)
        end
        
        local remote = tool:FindFirstChild("RemoteEvent")
        if remote then
            pcall(function()
                remote:FireServer(targetPos.X, targetPos.Y, targetPos.Z)
                logLabel.Text = "Fired!"
            end)
        else
            logLabel.Text = "RemoteEvent not found in tool."
        end
    else
        logLabel.Text = "Gaster Blaster not found in inventory."
    end
end)
