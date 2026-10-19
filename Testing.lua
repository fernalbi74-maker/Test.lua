local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local userInputService = game:GetService("UserInputService")

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "OllieHubV1"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 320)
mainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 255, 255)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "olliE Hub"
titleText.TextColor3 = Color3.fromRGB(0, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 2.5)
minBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minBtn

-- Minimized Square
local minSquare = Instance.new("TextButton")
minSquare.Name = "MinSquare"
minSquare.Size = UDim2.new(0, 50, 0, 50)
minSquare.Position = UDim2.new(0.1, 0, 0.2, 0)
minSquare.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
minSquare.Text = "oE"
minSquare.TextColor3 = Color3.fromRGB(0, 255, 255)
minSquare.Font = Enum.Font.GothamBold
minSquare.TextSize = 20
minSquare.Visible = false
minSquare.Active = true
minSquare.Draggable = true
minSquare.Parent = gui

local squareCorner = Instance.new("UICorner")
squareCorner.CornerRadius = UDim.new(0, 8)
squareCorner.Parent = minSquare

local squareStroke = Instance.new("UIStroke")
squareStroke.Color = Color3.fromRGB(0, 255, 255)
squareStroke.Thickness = 2
squareStroke.Parent = minSquare

-- Minimize Logic
minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minSquare.Visible = true
    minSquare.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset)
end)

minSquare.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    minSquare.Visible = false
    mainFrame.Position = UDim2.new(minSquare.Position.X.Scale, minSquare.Position.X.Offset, minSquare.Position.Y.Scale, minSquare.Position.Y.Offset)
end)

-- Scrolling Frame for Content
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.new(0, 10, 0, 45)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

-- Helper function for buttons
local function createButton(text, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.LayoutOrder = layoutOrder
    btn.Parent = scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

-- == CHEATS == --

-- 1. NoClip
local noClipBtn = createButton("NoClip", 1)
local isNoClip = false
local noclipConn = nil

noClipBtn.MouseButton1Click:Connect(function()
    isNoClip = not isNoClip
    if isNoClip then
        noClipBtn.Text = "NoClip: ON"
        noClipBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        noclipConn = runService.Stepped:Connect(function()
            if player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        noClipBtn.Text = "NoClip: OFF"
        noClipBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if noclipConn then noclipConn:Disconnect() end
    end
end)

-- 2. Orbit Dodge
local orbitBtn = createButton("Orbit Dodge", 2)
local isOrbiting = false
local orbitConn = nil

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

orbitBtn.MouseButton1Click:Connect(function()
    isOrbiting = not isOrbiting
    if isOrbiting then
        orbitBtn.Text = "Orbit Dodge: ON"
        orbitBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        
        if not hrp:FindFirstChild("OrbitAttachment") then
            local att = Instance.new("Attachment")
            att.Name = "OrbitAttachment"
            att.Parent = hrp
        end
        
        local alignPos = hrp:FindFirstChild("OrbitAlign")
        if not alignPos then
            alignPos = Instance.new("AlignPosition")
            alignPos.Name = "OrbitAlign"
            alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
            alignPos.Attachment0 = hrp:FindFirstChild("OrbitAttachment")
            alignPos.MaxForce = 100000
            alignPos.Responsiveness = 50
            alignPos.Parent = hrp
        end
        
        local center = hrp.Position + Vector3.new(0, 50, 0)
        local radius = 30
        local angle = 0
        
        if orbitConn then orbitConn:Disconnect() end
        orbitConn = runService.Heartbeat:Connect(function(dt)
            angle = angle + dt * 2
            local x = center.X + math.cos(angle) * radius
            local z = center.Z + math.sin(angle) * radius
            alignPos.Position = Vector3.new(x, center.Y, z)
        end)
    else
        orbitBtn.Text = "Orbit Dodge: OFF"
        orbitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if orbitConn then orbitConn:Disconnect() end
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local alignPos = char.HumanoidRootPart:FindFirstChild("OrbitAlign")
            if alignPos then alignPos:Destroy() end
        end
    end
end)

-- 3. Auto Shoot
local shootBtn = createButton("Auto Shoot", 3)
local isShooting = false
local shootTask = nil

shootBtn.MouseButton1Click:Connect(function()
    isShooting = not isShooting
    if isShooting then
        shootBtn.Text = "Auto Shoot: ON"
        shootBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        if shootTask then task.cancel(shootTask) end
        shootTask = task.spawn(function()
            while isShooting do
                local boss = getBoss()
                if boss then
                    local hrp = boss:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        camera.CFrame = CFrame.new(camera.CFrame.Position, hrp.Position)
                        local char = player.Character
                        local tool = char and char:FindFirstChild("Gaster Blaster")
                        if not tool then
                            local backpack = player:FindFirstChild("Backpack")
                            tool = backpack and backpack:FindFirstChild("Gaster Blaster")
                            if tool then tool.Parent = char end
                        end
                        if tool and tool.Parent == char then
                            pcall(function() tool:Activate() end)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        shootBtn.Text = "Auto Shoot: OFF"
        shootBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if shootTask then task.cancel(shootTask) end
    end
end)

-- 4. Visuals (Light + ESP)
local visualBtn = createButton("Visuals", 4)
local isVisuals = false
local espHighlights = {}
local originalBrightness = lighting.Brightness
local originalAmbient = lighting.Ambient

visualBtn.MouseButton1Click:Connect(function()
    isVisuals = not isVisuals
    if isVisuals then
        visualBtn.Text = "Visuals: ON"
        visualBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        -- Light
        lighting.Brightness = 3
        lighting.Ambient = Color3.fromRGB(150, 150, 150)
        lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
        lighting.FogEnd = 100000
        
        -- ESP
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= player.Character then
                local name = obj.Name:lower()
                if name:find("guy") or name:find("sans") or name:find("nightmare") or name:find("boss") then
                    if not obj:FindFirstChild("OllieESP") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "OllieESP"
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                        hl.FillTransparency = 0.5
                        hl.Parent = obj
                        table.insert(espHighlights, hl)
                    end
                end
            end
        end
    else
        visualBtn.Text = "Visuals: OFF"
        visualBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        -- Reset Light
        lighting.Brightness = originalBrightness
        lighting.Ambient = originalAmbient
        lighting.OutdoorAmbient = originalAmbient
        
        -- Clear ESP
        for _, hl in ipairs(espHighlights) do
            if hl then hl:Destroy() end
        end
        espHighlights = {}
    end
end)

-- Fix scroll size
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)
