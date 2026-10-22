--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--kaizeo
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Ore Teleporter",
    LoadingTitle = "Loading Script...",
    LoadingSubtitle = "by THE KAIZO KNIGHT OMG REAL",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})
--LA BOBUX SPEWNER
local MainTab = Window:CreateTab("Main", 4483362458)

local AutoTeleport = false
local TeleportDistance = 5
local OresHidden = false
local ExcludeTesseract = false
local originalTesseractPivot = nil

local function handleTesseractExclusion(exclude)
    local oresFolder = Workspace:FindFirstChild("Ores")
    if not oresFolder then return end

    local tesseract = oresFolder:FindFirstChild("Tesseract")
    if tesseract and tesseract:IsA("Model") then
        if not originalTesseractPivot then
            originalTesseractPivot = tesseract:GetPivot()
        end

        if exclude and originalTesseractPivot then
            tesseract:PivotTo(originalTesseractPivot)
        end
    end
end

local function teleportOres()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart
    local targetCFrame = hrp.CFrame + (hrp.CFrame.LookVector * TeleportDistance)

    local oresFolder = Workspace:FindFirstChild("Ores")
    if not oresFolder then
        Rayfield:Notify({
            Title = "Error",
            Content = "Folder 'Ores' not found in Workspace!",
            Duration = 3,
            Image = 4483362458,
        })
        return
    end

    for _, item in ipairs(oresFolder:GetChildren()) do
        if item:IsA("Model") then
            if item.Name == "Tesseract" and ExcludeTesseract then
                continue
            end

            if item.Name == "Tesseract" and not originalTesseractPivot then
                originalTesseractPivot = item:GetPivot()
            end

            item:PivotTo(targetCFrame)
        end
    end
end

local function setOresVisibility(hidden)
    local oresFolder = Workspace:FindFirstChild("Ores")
    if not oresFolder then return end

    for _, item in ipairs(oresFolder:GetDescendants()) do
        if item:IsA("BasePart") then
            if item:GetAttribute("OriginalTransparency") == nil then
                item:SetAttribute("OriginalTransparency", item.Transparency)
            end

            if hidden then
                item.Transparency = 1
            else
                item.Transparency = item:GetAttribute("OriginalTransparency") or 0
            end
        end
    end
end

MainTab:CreateSlider({
    Name = "Teleport Distance",
    Range = {2, 20},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 5,
    Flag = "DistanceSlider",
    Callback = function(Value)
        TeleportDistance = Value
    end,
})

MainTab:CreateButton({
    Name = "Teleport Ores (Once)",
    Callback = function()
        teleportOres()
    end,
})

MainTab:CreateToggle({
    Name = "Auto-Bring Ores (Loop)",
    CurrentValue = false,
    Flag = "AutoTeleportToggle",
    Callback = function(Value)
        AutoTeleport = Value
    end,
})

MainTab:CreateToggle({
    Name = "Hide Ores (Lag Reduction)",
    CurrentValue = false,
    Flag = "HideOresToggle",
    Callback = function(Value)
        OresHidden = Value
        setOresVisibility(OresHidden)
    end,
})

MainTab:CreateToggle({
    Name = "Exclude Tesseract",
    CurrentValue = false,
    Flag = "ExcludeTesseractToggle",
    Callback = function(Value)
        ExcludeTesseract = Value
        handleTesseractExclusion(Value)
    end,
})

RunService.Heartbeat:Connect(function()
    if AutoTeleport then
        teleportOres()
    end
    
    if OresHidden then
        setOresVisibility(true)
    end
end)
