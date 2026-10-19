local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ESP_Folder = Instance.new("Folder")
ESP_Folder.Name = "OllieESP"
ESP_Folder.Parent = game.CoreGui

local function createESP(model)
    if model:FindFirstChild("OllieHighlight") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "OllieHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = model
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "OllieName"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart") or model
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = model.Name
    text.TextColor3 = Color3.fromRGB(255, 50, 50)
    text.TextStrokeTransparency = 0
    text.Font = Enum.Font.Code
    text.TextSize = 16
    text.Parent = billboard
    
    local humanoid = model:FindFirstChildOfClass("Humanoid") or model:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.HealthChanged:Connect(function(hp)
            text.Text = model.Name .. " [" .. math.floor(hp) .. "/" .. math.floor(humanoid.MaxHealth) .. "]"
        end)
        text.Text = model.Name .. " [" .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. "]"
    end
end

local function scan()
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            if not obj:FindFirstChild("OllieHighlight") then
                createESP(obj)
            end
        end
    end
end

-- Run scan every second to catch newly spawned bosses
task.spawn(function()
    while task.wait(1) do
        pcall(scan)
    end
end)

-- Initial scan
pcall(scan)
