local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "SpyGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.8, 0, 0.4, 0)
frame.Position = UDim2.new(0.1, 0, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.15, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Remote Spy | olliE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 0.85, -10)
scroll.Position = UDim2.new(0, 5, 0.15, 5)
scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll

local function addLog(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(0, 255, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.Parent = scroll
    layout:ApplyLayout()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- Hook the FireServer method
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" then
        local args = {...}
        local argStr = ""
        for i, v in ipairs(args) do
            argStr = argStr .. tostring(v) .. ", "
        end
        addLog("Sent: " .. self:GetFullName() .. " | Args: " .. argStr)
    end
    return oldNamecall(self, ...)
end)
