local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")

local gui = Instance.new("ScreenGui")
gui.Name = "QuestHacker"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.1, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.3, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "Quest Hacker | olliE"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0.4, 0)
btn.Position = UDim2.new(0.05, 0, 0.4, 0)
btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btn.Text = "Complete Quests"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.Code
btn.TextSize = 16
btn.Parent = frame

btn.MouseButton1Click:Connect(function()
    local questData = workspace:FindFirstChild("QuestData")
    if not questData then return end
    
    -- 1. Меняем локальные значения
    for _, questFolder in ipairs(questData:GetChildren()) do
        local started = questFolder:FindFirstChild("Started")
        local completed = questFolder:FindFirstChild("Completed")
        
        if started and started:IsA("BoolValue") then started.Value = true end
        if completed and completed:IsA("BoolValue") then completed.Value = true end
        
        -- 2. Ищем RemoteEvents внутри квеста
        for _, child in ipairs(questFolder:GetDescendants()) do
            if child:IsA("RemoteEvent") then
                pcall(function()
                    child:FireServer(true) -- Пытаемся отправить "выполнено"
                end)
            end
        end
    end
    
    print("Quest data manipulated.")
end)
