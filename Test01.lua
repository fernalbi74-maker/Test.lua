-- TBSOBR recon, on-screen GUI edition. no console, no clipboard.
-- run in Arceus X after game fully loads.

local findings = {}
local function add(s) findings[#findings+1] = tostring(s) end

pcall(function() add("identify: "..tostring(identifyexecutor())) end)
pcall(function() add("version: "..tostring(getexecutorversion())) end)

local api = {
  "getconnections","firesignal","firetouchinterest",
  "getrawmetatable","setreadonly","hookfunction",
  "getnamecallmethod","checkcaller","getgc",
  "writefile","readfile","isfile","listfiles",
  "getcustomasset","syn","request","httpget",
  "queue_on_teleport","getgenv","getrenv","getsenv",
  "cloneref","compareinstances","gethui","protectgui",
  "setclipboard","decompile","getscriptbytecode",
}
for _,n in ipairs(api) do
  local ok, v = pcall(function() return rawget(getfenv(), n) end)
  local has = ok and v ~= nil
  if not has then
    local ok2, v2 = pcall(function() return getgenv()[n] end)
    has = ok2 and v2 ~= nil
  end
  add(n..": "..tostring(has))
end

pcall(function() add("placeid: "..tostring(game.PlaceId)) end)
pcall(function() add("players: "..tostring(#game.Players:GetPlayers())) end)

pcall(function()
  local rs = game:GetService("ReplicatedStorage")
  local hits = 0
  for _,d in ipairs(rs:GetDescendants()) do
    if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
      add("R: "..d:GetFullName())
      hits = hits + 1
      if hits > 50 then add("R: ...capped"); break end
    end
  end
end)

pcall(function()
  local ws = game:GetService("Workspace")
  for _,d in ipairs(ws:GetDescendants()) do
    if d:IsA("Model") and d:FindFirstChildOfClass("Humanoid") then
      local hum = d:FindFirstChildOfClass("Humanoid")
      add("B: "..d.Name.." hp="..tostring(hum.MaxHealth))
    end
  end
end)

pcall(function()
  local lp = game.Players.LocalPlayer
  add("me: "..lp.Name)
  add("char: "..tostring(lp.Character ~= nil))
  add("hrp: "..tostring(lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") ~= nil))
end)

-- GUI
local sg = Instance.new("ScreenGui")
sg.Name = "TBSOBRRecon"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
local parented = false
pcall(function()
  if gethui then sg.Parent = gethui(); parented = true end
end)
if not parented then
  local ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
  if not ok then sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end
end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 420)
frame.Position = UDim2.new(0.5, -170, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
title.BorderSizePixel = 0
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Text = "TBSOBR recon — "..#findings.." lines"
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -90)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 22 * #findings + 10)
scroll.ScrollBarThickness = 6
scroll.Parent = frame

local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(1, 0, 0, 22 * #findings + 10)
lbl.BackgroundTransparency = 1
lbl.TextColor3 = Color3.fromRGB(200, 220, 200)
lbl.Font = Enum.Font.Code
lbl.TextSize = 13
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.TextYAlignment = Enum.TextYAlignment.Top
lbl.Text = table.concat(findings, "\n")
lbl.Parent = scroll

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 100, 0, 44)
btn.Position = UDim2.new(0.5, -50, 1, -50)
btn.BackgroundColor3 = Color3.fromRGB(60, 140, 90)
btn.BorderSizePixel = 0
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
btn.Text = "CLOSE"
btn.Parent = frame
btn.MouseButton1Click:Connect(function() sg:Destroy() end)
