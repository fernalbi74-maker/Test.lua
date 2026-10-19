local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Name = "OllieSniper"
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
title.Text = "Sniper Auto-Aim | olliE"
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

local isAiming = false
local aimConnection = nil

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
    isAiming = not isAiming
    if isAiming then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        if aimConnection then aimConnection:Disconnect() end
        aimConnection = runService.RenderStepped:Connect(function()
            local boss = getBoss()
            if boss then
                local hrp = boss:FindFirstChild("HumanoidRootPart")
                if hrp and camera then
                    -- Предсказываем позицию (упреждение)
                    local velocity = hrp.AssemblyLinearVelocity
                    local distance = (hrp.Position - camera.CFrame.Position).Magnitude
                    local travelTime = distance / 300 -- Примерная скорость снаряда
                    local predictedPos = hrp.Position + (velocity * travelTime)
                    
                    -- Наводим камеру на предсказанную точку
                    camera.CFrame = CFrame.new(camera.CFrame.Position, predictedPos)
                end
            end
        end)
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if aimConnection then
            aimConnection:Disconnect()
            aimConnection = nil
        end
    end
end)
