local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui")
gui.Name = "OllieOrbit"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 260)
frame.Position = UDim2.new(0.1, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.1, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "Orbit Dodge v2 | olliE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 16
toggleBtn.Parent = frame

-- Настройки
local settings = {
    Height = 50,
    Radius = 30,
    Speed = 1.5
}

local function createSlider(name, min, max, default, posY, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0.08, 0)
    label.Position = UDim2.new(0.05, 0, posY, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Code
    label.TextSize = 12
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.9, 0, 0.03, 0)
    bar.Position = UDim2.new(0.05, 0, posY + 0.08, 0)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bar.BorderSizePixel = 0
    bar.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = bar

    button.MouseButton1Down:Connect(function()
        local isDragging = true
        local connection
        connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if isDragging then
                    local mouseX = input.Position.X
                    local barPos = bar.AbsolutePosition.X
                    local barSize = bar.AbsoluteSize.X
                    local percent = math.clamp((mouseX - barPos) / barSize, 0, 1)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    local value = min + (max - min) * percent
                    label.Text = name .. ": " .. math.floor(value)
                    callback(value)
                end
            end
        end)

        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
                if connection then connection:Disconnect() end
            end
        end)
    end)
end

createSlider("Height", 20, 150, 50, 0.3, function(v) settings.Height = v end)
createSlider("Radius", 10, 100, 30, 0.45, function(v) settings.Radius = v end)
createSlider("Speed", 0.5, 5, 1.5, 0.6, function(v) settings.Speed = v end)

local isOrbiting = false
local orbitConnection = nil

local function startOrbit()
    if not hrp:FindFirstChild("OrbitAttachment") then
        local att = Instance.new("Attachment")
        att.Name = "OrbitAttachment"
        att.Parent = hrp
    end
    local att = hrp:FindFirstChild("OrbitAttachment")
    
    local alignPos = hrp:FindFirstChild("OrbitAlign")
    if not alignPos then
        alignPos = Instance.new("AlignPosition")
        alignPos.Name = "OrbitAlign"
        alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
        alignPos.Attachment0 = att
        alignPos.MaxForce = 100000
        alignPos.Responsiveness = 50
        alignPos.Parent = hrp
    end
    
    local center = hrp.Position + Vector3.new(0, settings.Height, 0)
    local angle = 0
    
    if orbitConnection then orbitConnection:Disconnect() end
    orbitConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
        angle = angle + dt * settings.Speed
        local x = center.X + math.cos(angle) * settings.Radius
        local z = center.Z + math.sin(angle) * settings.Radius
        local y = center.Y
        
        alignPos.Position = Vector3.new(x, y, z)
    end)
end

local function stopOrbit()
    if orbitConnection then
        orbitConnection:Disconnect()
        orbitConnection = nil
    end
    local alignPos = hrp:FindFirstChild("OrbitAlign")
    if alignPos then alignPos:Destroy() end
end

toggleBtn.MouseButton1Click:Connect(function()
    isOrbiting = not isOrbiting
    if isOrbiting then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        startOrbit()
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        stopOrbit()
    end
end)
