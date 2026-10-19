local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- Находим инструмент игрока
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()

local function getGasterBlaster()
    local tool = character:FindFirstChild("Gaster Blaster")
    if not tool then
        tool = backpack:FindFirstChild("Gaster Blaster")
    end
    return tool
end

-- Ищем босса (The Guy или любого с Humanoid)
local function getBoss()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= character then
            if obj.Name:lower():find("guy") or obj.Name:lower():find("sans") or obj.Name:lower():find("nightmare") then
                return obj
            end
        end
    end
    return nil
end

-- Спам
task.spawn(function()
    while task.wait(0.1) do -- 10 раз в секунду
        local boss = getBoss()
        local tool = getGasterBlaster()
        
        if boss and tool then
            local hrp = boss:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = hrp.Position
                
                -- Находим RemoteEvent внутри инструмента
                local remote = tool:FindFirstChild("RemoteEvent")
                if remote and remote:IsA("RemoteEvent") then
                    pcall(function()
                        remote:FireServer(pos.X, pos.Y, pos.Z)
                    end)
                end
            end
        end
    end
end)
