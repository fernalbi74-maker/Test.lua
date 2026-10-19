--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Window = Rayfield:CreateWindow({
    name = "IMMIE HUB",
    subtitle = "TBSOBR",
    sidebarLayout = true,
})

local Skips = Window:CreateTab({
    name = "Skips",
    icon = 6031091002,
})

local Halloween = Window:CreateTab({
    name = "HALLOWEEN",
    icon = 6031280882,
})

local skipDialogue = false
local endlessMode = false
local foolsMode = false
local godMode = false
local boneFlame = false

local function getDetector(name)
    local object = workspace:FindFirstChild(name)

    if not object then
        return nil
    end

    local detector = object:FindFirstChild("ClickDetector")

    if detector and detector:IsA("ClickDetector") then
        return detector
    end

    return nil
end

Skips:CreateToggle({
    name = "Skip Dialogue",
    flag = "SkipDialogue",
    callback = function(value)
        skipDialogue = value
    end,
})

Skips:CreateToggle({
    name = "Endless Mode Vote",
    flag = "EndlessModeVote",
    callback = function(value)
        endlessMode = value
    end,
})

Skips:CreateToggle({
    name = "Fools Mode",
    flag = "FoolsMode",
    callback = function(value)
        foolsMode = value
    end,
})

Skips:CreateToggle({
    name = "God Mode Vote",
    flag = "GodModeVote",
    callback = function(value)
        godMode = value
    end,
})

Skips:CreateToggle({
    name = "Bone Flame",
    flag = "BoneFlame",
    callback = function(value)
        boneFlame = value
    end,
})

task.spawn(function()
    while task.wait(0.1) do
        if skipDialogue then
            local detector = getDetector("SkipDialogue")
            if detector then
                fireclickdetector(detector)
            end
        end

        if endlessMode then
            local detector = getDetector("EndlessModeVote")
            if detector then
                fireclickdetector(detector)
            end
        end

        if foolsMode then
            local detector = getDetector("FoolsMode")
            if detector then
                fireclickdetector(detector)
            end
        end

        if godMode then
            local detector = getDetector("GodModeVote")
            if detector then
                fireclickdetector(detector)
            end
        end

        if boneFlame then
            local detector = getDetector("BoneFlame")
            if detector then
                fireclickdetector(detector)
            end
        end
    end
end)

Halloween:CreateButton({
    name = "Teleport to Blue Axe",
    callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local axe = workspace:FindFirstChild("HalloweenBlueAxe")

        if not root or not axe then
            return
        end

        local part = axe:IsA("BasePart") and axe or axe:FindFirstChildWhichIsA("BasePart", true)

        if part then
            root.CFrame = part.CFrame * CFrame.new(0, 0, 10)
        end
    end,
})

Halloween:CreateButton({
    name = "Teleport to Purple Axe",
    callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local axe = workspace:FindFirstChild("HalloweenPurpleAxe")

        if not root or not axe then
            return
        end

        local part = axe:IsA("BasePart") and axe or axe:FindFirstChildWhichIsA("BasePart", true)

        if part then
            root.CFrame = part.CFrame + Vector3.new(0, 3, 0)
        end
    end,
})

Halloween:CreateButton({
    name = "TP to Portal",
    callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local portal = workspace:FindFirstChild("HalloweenEventPortal")

        if not root or not portal then
            return
        end

        local part = portal:IsA("BasePart") and portal or portal:FindFirstChildWhichIsA("BasePart", true)

        if not part then
            return
        end

        firetouchinterest(root, part, 0)
        task.wait(0.1)
        firetouchinterest(root, part, 1)
    end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local bossFloat = false
local floatForce = nil

local function startBossFloat(character)
    if floatForce then
        floatForce:Destroy()
        floatForce = nil
    end

    local root = character:WaitForChild("HumanoidRootPart", 5)

    if not root or not bossFloat then
        return
    end

    floatForce = Instance.new("BodyPosition")
    floatForce.Name = "BossFloat"
    floatForce.Position = Vector3.new(0, 13.3, 0)
    floatForce.MaxForce = Vector3.new(0, math.huge, 0)
    floatForce.P = 10000
    floatForce.D = 1000
    floatForce.Parent = root
end

Halloween:CreateToggle({
    name = "BOSS FLOAT",
    flag = "BossFloat",
    callback = function(value)
        bossFloat = value

        if floatForce then
            floatForce:Destroy()
            floatForce = nil
        end

        if bossFloat and LocalPlayer.Character then
            startBossFloat(LocalPlayer.Character)
        end
    end,
})

LocalPlayer.CharacterAdded:Connect(function(character)
    if bossFloat then
        task.wait(0.5)
        startBossFloat(character)
    end
end)

local AutoSpawn = Window:CreateTab({
    name = "Auto Spawn",
    icon = 6031091002,
})

local selectedMorph = "V404"
local autoSpawnEnabled = false

local morphs = {
    "V404",
    "True Pablo",
    "King Multiverse",
    "ERRORSIPHONER",
    "Sansta",
    "KJ",
    "HyperDust",
    "Spamton"
}

local morphPaths = {
    ["V404"] = function()
        local model = workspace:FindFirstChild("Virus404Sans")
        return model and model:FindFirstChild("Morph")
    end,

    ["True Pablo"] = function()
        local model = workspace:FindFirstChild("TRUEPABLO")
        local erororo = model and model:FindFirstChild("erororo")
        return erororo and erororo:FindFirstChild("Head")
    end,

    ["King Multiverse"] = function()
        local model = workspace:FindFirstChild("PabloCreation")
        return model and model:FindFirstChild("Morph")
    end,

    ["ERRORSIPHONER"] = function()
        local model = workspace:FindFirstChild("404")
        return model and model:FindFirstChild("Head")
    end,

    ["Sansta"] = function()
        local model = workspace:FindFirstChild("Sansta")
        return model and model:FindFirstChild("Head")
    end,

    ["KJ"] = function()
        return workspace:FindFirstChild("morph thing")
    end,

    ["HyperDust"] = function()
        local model = workspace:FindFirstChild("LV21HYPERCHAR")
        return model and model:FindFirstChild("Head")
    end,

    ["Spamton"] = function()
        local model = workspace:FindFirstChild("SPAMTON")
        return model and model:FindFirstChild("Head")
    end,
}

AutoSpawn:CreateDropdown({
    name = "Choose Morph",
    options = morphs,
    currentOption = "V404",
    flag = "AutoSpawnMorph",
    callback = function(value)
        if type(value) == "table" then
            selectedMorph = value[1]
        else
            selectedMorph = value
        end
    end,
})

AutoSpawn:CreateToggle({
    name = "Auto Spawn",
    flag = "AutoSpawnEnabled",
    callback = function(value)
        autoSpawnEnabled = value
    end,
})

local function fireMorphTouch()
    if not autoSpawnEnabled then
        return
    end

    local character = game.Players.LocalPlayer.Character

    if not character then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    local getPart = morphPaths[selectedMorph]

    if not getPart then
        return
    end

    local part = getPart()

    if not part or not part:IsA("BasePart") then
        return
    end

    local touchInterest = part:FindFirstChild("TouchInterest")

    if not touchInterest then
        return
    end

    firetouchinterest(root, part, 0)
    task.wait(0.1)
    firetouchinterest(root, part, 1)
end

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if autoSpawnEnabled then
        task.wait(1)
        fireMorphTouch()
    end
end)
