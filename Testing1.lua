local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui")
gui.Name = "OllieOrbit"
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
title.Text = "Orbit Dodge | olliE"
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

local isOrbiting = false
local orbitConnection = nil

local function createAttachment()
    if not hrp:FindFirstChild("OrbitAttachment") then
        local att = Instance.new("Attachment")
        att.Name = "OrbitAttachment"
        att.Parent = hrp
    end
end

local function startOrbit()
    createAttachment()
    local att = hrp:FindFirstChild("OrbitAttachment")
    
    local alignPos = Instance.new("AlignPosition")
    alignPos.Name = "OrbitAlign"
    alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
    alignPos.Attachment0 = att
    alignPos.MaxForce = 100000
    alignPos.Responsiveness = 50
    alignPos.Parent = hrp
    
    local center = hrp.Position + Vector3.new(0, 50, 0) -- Высота 50 стадов над землей
    local radius = 30
    local angle = 0
    
    orbitConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
        angle = angle + dt * 1.5 -- Скорость вращения
        local x = center.X + math.cos(angle) * radius
        local z = center.Z + math.sin(angle) * radius
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
