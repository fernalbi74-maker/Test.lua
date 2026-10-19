local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local userInputService = game:GetService("UserInputService")

-- UI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "OllieAutoAim"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 120)
mainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.25, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "olliE AutoAim"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -20, 0.5, -20)
toggleBtn.Position = UDim2.new(0, 10, 0.3, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 20
toggleBtn.Parent = mainFrame

local isRunning = false
local spamTask = nil

-- Logic
local function getGasterBlaster()
    local char = player.Character
    if char and char:FindFirstChild("Gaster Blaster") then
        return char["Gaster Blaster"]
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack and backpack:FindFirstChild("Gaster Blaster") then
        return backpack["Gaster Blaster"]
    end
    return nil
end

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

local function startSpam()
    if spamTask then task.cancel(spamTask) end
    spamTask = task.spawn(function()
        while isRunning do
            local boss = getBoss()
            local tool = getGasterBlaster()
            
            if boss and tool then
                local hrp = boss:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = hrp.Position
                    local remote = tool:FindFirstChild("RemoteEvent")
                    if remote and remote:IsA("RemoteEvent") then
                        pcall(function()
                            remote:FireServer(pos.X, pos.Y, pos.Z)
                        end)
                    end
                end
            end
            task.wait(0.1) -- Adjust speed here (0.1 = 10 times per sec)
        end
    end)
end

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        startSpam()
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if spamTask then
            task.cancel(spamTask)
            spamTask = nil
        end
    end
end)
