local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "OllieAutoAim"
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
title.Text = "Auto-Aim"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
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

local isAiming = false
local aimTask = nil

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
        
        if aimTask then task.cancel(aimTask) end
        aimTask = task.spawn(function()
            while isAiming do
                local boss = getBoss()
                if boss then
                    local hrp = boss:FindFirstChild("HumanoidRootPart")
                    if hrp and camera then
                        -- Наводим камеру на босса
                        camera.CFrame = CFrame.new(camera.CFrame.Position, hrp.Position)
                    end
                end
                task.wait(0.05)
            end
        end)
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if aimTask then
            task.cancel(aimTask)
            aimTask = nil
        end
    end
end)
