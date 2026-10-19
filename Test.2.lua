local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HitboxUtil = require(ReplicatedStorage:WaitForChild("HitboxUtil"))
local DefenseUtil = require(ReplicatedStorage:WaitForChild("DefenseUtil"))

print("--- OLLIE MODE ---")

-- 1. Try to disable hitboxes
if HitboxUtil then
    pcall(function()
        HitboxUtil.Disabled = true
        HitboxUtil.HitboxesDisabled = true
        print("Set HitboxesDisabled to true")
    end)
end

-- 2. Try to change defense
if DefenseUtil then
    pcall(function()
        if DefenseUtil.SetBaseDefense then
            DefenseUtil.SetBaseDefense(999999)
            print("Set BaseDefense to 999999")
        end
        if DefenseUtil.UpdateDefense then
            DefenseUtil.UpdateDefense()
            print("Updated Defense")
        end
    end)
end

print("Done. Check if you take damage.")
