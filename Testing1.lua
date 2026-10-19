local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")

local gui = Instance.new("ScreenGui")
gui.Name = "OneShot"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.1, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.3, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "One Shot Zone | olliE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local shootBtn = Instance.new("TextButton")
shootBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
shootBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
shootBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
shootBtn.Text = "FIRE ZONE"
shootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
shootBtn.Font = Enum.Font.Code
shootBtn.TextSize = 16
shootBtn.Parent = frame

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

shootBtn.MouseButton1Click:Connect(function()
    local boss = getBoss()
    if not boss then return end
    
    local hrp = boss:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    -- Ищем Bone Zone везде
    local tool = char:FindFirstChild("Bone Zone") or backpack:FindFirstChild("Bone Zone")
    
    if tool then
        -- Экипируем
        tool.Parent = char
        task.wait(1) -- Ждем, чтобы сервер зарегистрировал
        
        -- Отправляем команду напрямую
        local remote = tool:FindFirstChild("RemoteEvent")
        if remote then
            pcall(function()
                remote:FireServer(hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
            end)
        end
    end
end)
