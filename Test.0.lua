-- TBSOBR recon, read-only. Paged clipboard UI.
-- Arceus X mobile. run, tap Copy, paste into notes, tap Next.

local Pages = {}

Pages[#Pages+1] = [==[
local function hr(t) print("=== "..t.." ===") end
pcall(function() print("identify: "..tostring(identifyexecutor())) end)
pcall(function() print("version: "..tostring(getexecutorversion())) end)
]==]

Pages[#Pages+1] = [==[
local api = {
  "getconnections","firesignal","firetouchinterest",
  "getrawmetatable","setreadonly","hookfunction",
  "getnamecallmethod","checkcaller","getgc",
}
for _,n in ipairs(api) do
  print(n..": "..tostring(type(rawget(getfenv(), n)) ~= "nil" or type(getgenv()[n])))
end
]==]

Pages[#Pages+1] = [==[
local api2 = {
  "writefile","readfile","isfile","listfiles",
  "getcustomasset","syn","request","httpget",
  "queue_on_teleport","getgenv","getrenv","getsenv",
}
for _,n in ipairs(api2) do
  print(n..": "..tostring(type(rawget(getfenv(), n)) ~= "nil" or type(getgenv()[n])))
end
]==]

Pages[#Pages+1] = [==[
local api3 = {
  "cloneref","compareinstances","gethui","protectgui",
  "setclipboard","decompile","getscriptbytecode",
}
for _,n in ipairs(api3) do
  print(n..": "..tostring(type(rawget(getfenv(), n)) ~= "nil" or type(getgenv()[n])))
end
]==]

Pages[#Pages+1] = [==[
hr("game")
print("placeid: "..tostring(game.PlaceId))
print("jobid: "..tostring(game.JobId))
print("players: "..tostring(#game.Players:GetPlayers()))
]==]

Pages[#Pages+1] = [==[
hr("remote scan")
local rs = game:GetService("ReplicatedStorage")
local hits = 0
for _,d in ipairs(rs:GetDescendants()) do
  if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
    print(d:GetFullName())
    hits = hits + 1
    if hits > 40 then print("...capped"); break end
  end
end
]==]

Pages[#Pages+1] = [==[
hr("remote scan cont")
local rs = game:GetService("ReplicatedStorage")
local hits, shown = 0, 0
for _,d in ipairs(rs:GetDescendants()) do
  if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
    hits = hits + 1
    if hits > 40 and shown < 40 then
      print(d:GetFullName())
      shown = shown + 1
    end
  end
end
]==]

Pages[#Pages+1] = [==[
hr("workspace bosses")
local ws = game:GetService("Workspace")
for _,d in ipairs(ws:GetDescendants()) do
  if d:IsA("Model") and d:FindFirstChildOfClass("Humanoid") then
    local hum = d:FindFirstChildOfClass("Humanoid")
    print(d.Name.." hp="..tostring(hum.MaxHealth))
  end
end
]==]

Pages[#Pages+1] = [==[
hr("player shape")
local lp = game.Players.LocalPlayer
if lp then
  print("name: "..lp.Name)
  print("char: "..tostring(lp.Character ~= nil))
  print("hrp: "..tostring(lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") ~= nil))
end
hr("done")
]==]

Pages[#Pages+1] = [==[
-- end of dump. paste all pages back to Sam.
]==]

local idx = 1
local sg = Instance.new("ScreenGui")
sg.Name = "TBSOBRRecon"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
pcall(function() sg.Parent = gethui() end)
if not sg.Parent then sg.Parent = game.CoreGui end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 0, 40)
label.Position = UDim2.new(0, 10, 0, 10)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(240, 240, 240)
label.Font = Enum.Font.Code
label.TextSize = 16
label.Text = "page 1/"..#Pages
label.Parent = frame

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 120, 0, 44)
copyBtn.Position = UDim2.new(0, 15, 0, 70)
copyBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 90)
copyBtn.BorderSizePixel = 0
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 16
copyBtn.Text = "COPY"
copyBtn.Parent = frame

local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0, 120, 0, 44)
nextBtn.Position = UDim2.new(1, -135, 0, 70)
nextBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
nextBtn.BorderSizePixel = 0
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.Font = Enum.Font.GothamBold
nextBtn.TextSize = 16
nextBtn.Text = "NEXT"
nextBtn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 1, -40)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(160, 220, 180)
status.Font = Enum.Font.Code
status.TextSize = 14
status.Text = ""
status.Parent = frame

local function render()
  label.Text = "page "..idx.."/"..#Pages
  status.Text = ""
end

copyBtn.MouseButton1Click:Connect(function()
  local ok, err = pcall(function() setclipboard(Pages[idx]) end)
  if ok then
    status.Text = "copied "..idx.."/"..#Pages.." — paste it"
  else
    status.Text = "clipboard fail: "..tostring(err)
  end
end)

nextBtn.MouseButton1Click:Connect(function()
  if idx < #Pages then
    idx = idx + 1
    render()
  else
    status.Text = "last page"
  end
end)

render()
