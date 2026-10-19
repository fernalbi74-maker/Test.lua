local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "TaterBox"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.8, 0, 0.8, 0)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.1, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "TBSOBR Script List"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.Code
title.TextSize = 18
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.Code
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 0.85, -20)
textBox.Position = UDim2.new(0, 10, 0.1, 10)
textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
textBox.TextColor3 = Color3.fromRGB(0, 255, 255)
textBox.PlaceholderText = "Type or paste script names here..."
textBox.Text = ""
textBox.MultiLine = true
textBox.ClearTextOnFocus = false
textBox.TextWrapped = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.Font = Enum.Font.Code
textBox.TextSize = 14
textBox.Parent = frame
