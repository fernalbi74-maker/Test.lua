local Lighting = game:GetService("Lighting")

local bannedNames = {
    "FirstAttack", "Bonezone", "Blaster", "Slash", "Bone throw", "AI", "Jump", "Phase", 
    "SummonAU", "FallenStar", "InkBall", "SpinBone", "Animate", "Grab", "OnSpawn", 
    "Zombie", "HumanoidRootPart"
}

local count = 0

for _, obj in ipairs(Lighting:GetDescendants()) do
    if obj:IsA("Script") or obj:IsA("LocalScript") then
        for _, name in ipairs(bannedNames) do
            if obj.Name == name then
                obj.Disabled = true
                count = count + 1
                print("Disabled: " .. obj:GetFullName())
                break
            end
        end
    end
end

print("Total disabled: " .. count)
