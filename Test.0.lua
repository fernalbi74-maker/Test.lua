-- TBSOBR recon, console-print edition. no clipboard, no GUI.
-- run once, everything prints to executor console.

local function hr(t) print("\n=== "..t.." ===") end

hr("executor")
pcall(function() print("identify: "..tostring(identifyexecutor())) end)
pcall(function() print("version: "..tostring(getexecutorversion())) end)
pcall(function() print("clip: "..type(setclipboard)) end)

hr("api probe")
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
  print(n..": "..tostring(type(rawget(getfenv(), n)) ~= "nil" or type(getgenv()[n])))
end

hr("game")
print("placeid: "..tostring(game.PlaceId))
print("jobid: "..tostring(game.JobId))
print("players: "..tostring(#game.Players:GetPlayers()))

hr("remote scan")
local rs = game:GetService("ReplicatedStorage")
local hits = 0
for _,d in ipairs(rs:GetDescendants()) do
  if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
    print(d:GetFullName())
    hits = hits + 1
    if hits > 80 then print("...capped"); break end
  end
end

hr("workspace bosses")
local ws = game:GetService("Workspace")
for _,d in ipairs(ws:GetDescendants()) do
  if d:IsA("Model") and d:FindFirstChildOfClass("Humanoid") then
    print(d.Name.." hp="..tostring(d:FindFirstChildOfClass("Humanoid").MaxHealth))
  end
end

hr("player shape")
local lp = game.Players.LocalPlayer
if lp then
  print("name: "..lp.Name)
  print("char: "..tostring(lp.Character ~= nil))
  print("hrp: "..tostring(lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") ~= nil))
end

hr("done")
