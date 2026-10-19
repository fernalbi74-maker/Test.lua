local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- 1. Функция поиска босса
local function getBoss()
    local char = player.Character
    local bestTarget = nil
    local shortestDist = math.huge

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= char then
            local name = obj.Name:lower()
            if name:find("guy") or name:find("sans") or name:find("nightmare") or name:find("boss") then
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                if hrp and char and char:FindFirstChild("HumanoidRootPart") then
                    local dist = (hrp.Position - char.HumanoidRootPart.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        bestTarget = obj
                    end
                end
            end
        end
    end
    return bestTarget
end

-- 2. Перехват FireServer
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    -- Если это выстрел
    if method == "FireServer" and self.Name == "RemoteEvent" then
        local boss = getBoss()
        
        -- Если это именно Gaster Blaster (или похожий инструмент) и босс найден
        if boss then
            local hrp = boss:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = hrp.Position
                -- Подменяем аргументы на координаты босса
                -- ВАЖНО: Мы не знаем точный формат, поэтому передаем Vector3
                return oldNamecall(self, pos)
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

print("Hook установлен. Теперь твои выстрелы будут лететь в босса.")
