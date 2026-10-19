local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")

local gui = Instance.new("ScreenGui")
gui.Name = "TouchInstakill"
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
title.Text = "Touch Instakill | olliE"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.Code
title.TextSize = 14
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0.4, 0)
btn.Position = UDim2.new(0.05, 0, 0.4, 0)
btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btn.Text = "INSTAKILL"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.Code
btn.TextSize = 16
btn.Parent = frame

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

btn.MouseButton1Click:Connect(function()
    local boss = getBoss()
    if not boss then return end
    
    local hrp = boss:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Создаем невидимую часть с уроном
    local killPart = Instance.new("Part")
    killPart.Name = "OllieKillPart"
    killPart.Size = Vector3.new(5, 5, 5)
    killPart.Position = hrp.Position
    killPart.Anchored = true
    killPart.CanCollide = false
    killPart.Transparency = 1
    
    -- Добавляем скрипт, который наносит урон при касании
    local damageScript = Instance.new("Script")
    damageScript.Source = [[
        script.Parent.Touched:Connect(function(hit)
            local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid:TakeDamage(999999)
            end
        end)
    ]]
    damageScript.Parent = killPart
    
    killPart.Parent = workspace
    
    -- Заставляем босса коснуться этой части
    for _, part in ipairs(boss:GetDescendants()) do
        if part:IsA("BasePart") then
            firetouchinterest(part, killPart, 0)
            task.wait(0.1)
            firetouchinterest(part, killPart, 1)
        end
    end
    
    task.wait(1)
    killPart:Destroy()
end)
