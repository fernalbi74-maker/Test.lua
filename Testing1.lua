local Lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")
local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "OllieInstakill"
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
title.Text = "INSTAKILL | olliE"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 16
toggleBtn.Parent = frame

local isSpamming = false

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
    isSpamming = not isSpamming
    if isSpamming then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        task.spawn(function()
            while isSpamming do
                local boss = getBoss()
                if boss then
                    local hrp = boss:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local pos = hrp.Position
                        
                        -- Ищем все ремоуты в Lighting и спамим их
                        for _, obj in ipairs(Lighting:GetDescendants()) do
                            if obj:IsA("RemoteEvent") then
                                pcall(function()
                                    obj:FireServer(pos.X, pos.Y, pos.Z)
                                end)
                            end
                        end
                        
                        -- Ищем ремоуты в Workspace (на всякий случай)
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if obj:IsA("RemoteEvent") and obj.Name:find("Remote") then
                                pcall(function()
                                    obj:FireServer(pos.X, pos.Y, pos.Z)
                                end)
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)
