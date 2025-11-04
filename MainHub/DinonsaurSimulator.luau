local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character, humanoid, rootPart

local function getCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:FindFirstChildOfClass("Humanoid")
    rootPart = character:FindFirstChild("HumanoidRootPart")
    return character, humanoid, rootPart
end

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    task.wait(1)
    getCharacter()
    if humanoid and playerMods then
        humanoid.WalkSpeed = playerMods.walkSpeed or 16
        humanoid.JumpPower = playerMods.jumpPower or 50
    end
end)
getCharacter()

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/unsolven/IVORYHUB/refs/heads/main/Scripts/ESP.luau"))()
local MeteorFarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/unsolven/IVORYHUB/refs/heads/main/Scripts/MeteorFarm.luau"))()
local GlassBeamFarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/unsolven/IVORYHUB/refs/heads/main/Scripts/GlassbeamFarm.luau"))()
local DinoInventory = loadstring(game:HttpGet("https://raw.githubusercontent.com/unsolven/IVORYHUB/refs/heads/main/Scripts/inventory.luau"))()
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/unsolven/IVORYHUB/refs/heads/main/UI.luau"))()

local Window = DrRayLibrary:Load("ivoryHub", "Default")
local MainTab = DrRayLibrary.newTab("Main")
local FarmTab = DrRayLibrary.newTab("Farm")
local EventTab = DrRayLibrary.newTab("Event")
local PlayerTab = DrRayLibrary.newTab("Player")
local EspTab = DrRayLibrary.newTab("ESP")
local SettingsTab = DrRayLibrary.newTab("Settings")

local autoFarm = { meteor = false, glassBeam = false }
local autoEvent = { skulker = false, type4 = false, type2 = false }
local autoAttack = { normal = false, aoe = false }
local flySpeed = 50
playerMods = { walkSpeed = 16, jumpPower = 50 }
local isFlying = false
_G.isFlying = false

local function stopAllMovement()
    isFlying = false
    _G.isFlying = false
end

local function smoothFlyTo(targetPos, callback)
    if isFlying or not rootPart then return end
    isFlying = true
    _G.isFlying = true
    task.spawn(function()
        local char, hum, root = getCharacter()
        if not root then isFlying = false _G.isFlying = false return end
        local startPos = root.Position
        local distance = (startPos - targetPos).Magnitude
        local duration = math.clamp(distance / (flySpeed * 2.5), 0.3, 3)
        local elapsed = 0
        while elapsed < duration and isFlying and root and hum.Health > 0 do
            elapsed += RunService.Heartbeat:Wait()
            if not root or not root.Parent then break end
            local t = elapsed / duration
            local newPos = startPos:Lerp(targetPos, t)
            root.CFrame = CFrame.new(newPos)
        end
        isFlying = false
        _G.isFlying = false
        if callback then callback() end
    end)
end

local function startSkulkerFarm()
    if skulkerFarmLoop then skulkerFarmLoop:Disconnect() end
    skulkerFarmLoop = RunService.Heartbeat:Connect(function()
        if not autoEvent.skulker then return end  -- Remove "or isFlying"
        
        local folder = workspace:FindFirstChild("CharStorage") and workspace.CharStorage:FindFirstChild("Skulker")
        if not folder then return end
        local closest, dist = nil, math.huge
        for _, s in pairs(folder:GetChildren()) do
            local hrp = s:FindFirstChild("HumanoidRootPart")
            local hum = s:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (rootPart.Position - hrp.Position).Magnitude
                if d < dist then dist = d closest = hrp end
            end
        end
        if closest and dist > 8 then  -- Only fly if not already close
            local targetPos = closest.Position - (closest.CFrame.LookVector * 5) + Vector3.new(0, 2, 0)
            smoothFlyTo(targetPos, function()
                workspace.GameEvents.Damage:FireServer()
                workspace.GameEvents.AOEDamage:FireServer()
            end)
        elseif closest and dist <= 8 then
            -- Already close, just attack
            workspace.GameEvents.Damage:FireServer()
            workspace.GameEvents.AOEDamage:FireServer()
        end
    end)
end

local function stopSkulkerFarm()
    if skulkerFarmLoop then skulkerFarmLoop:Disconnect() end
end

local function findNearest(tbl)
    local closest, dist = nil, math.huge
    for _, obj in pairs(tbl) do
        if obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            local d = (rootPart.Position - part.Position).Magnitude
            if d < dist then dist = d closest = part end
        end
    end
    return closest
end

local function goToNearestFish()
    local storage = workspace:FindFirstChild("FishStorage")
    if not storage then return end
    local nearest = findNearest(storage:GetChildren())
    if nearest then smoothFlyTo(nearest.Position + Vector3.new(0, 5, 0)) end
end

local function goToNearestLizard()
    local misc = workspace:FindFirstChild("MiscellaneousStorage")
    if not misc or not misc:FindFirstChild("LizardStorage") then return end
    local storage = misc.LizardStorage
    local nearest = findNearest(storage:GetChildren())
    if nearest then smoothFlyTo(nearest.Position + Vector3.new(0, 5, 0)) end
end

EventTab.newLabel("Event Farming")
EventTab.newToggle("Auto Farm Skulker", "Kills Skulkers automatically.", false, function(v)
    autoEvent.skulker = v
    if v then startSkulkerFarm() else stopSkulkerFarm() end
    stopAllMovement()
end)

MainTab.newLabel("Food Finder")
MainTab.newButton("Find Fish", "Goes to nearest Fish", function() goToNearestFish() end)
MainTab.newButton("Find Lizard", "Goes to nearest Lizard", function() goToNearestLizard() end)

MainTab.newLabel("Combat")
MainTab.newToggle("Auto Normal Attack", "Spams primary attack.", false, function(v)
    autoAttack.normal = v
    if v then
        task.spawn(function()
            while autoAttack.normal do
                workspace.GameEvents.Damage:FireServer()
                task.wait()
            end
        end)
    end
end)

MainTab.newToggle("Auto AOE Attack", "Spams AOE attack.", false, function(v)
    autoAttack.aoe = v
    if v then
        task.spawn(function()
            while autoAttack.aoe do
                workspace.GameEvents.AOEDamage:FireServer()
                task.wait(0.5)
            end
        end)
    end
end)

MainTab.newLabel("General Utilities")
MainTab.newToggle("Disable Combat", "Forces out of combat.", false, function(v)
    if v then
        task.spawn(function()
            while v do
                if player.PlayerStats and player.PlayerStats:FindFirstChild("inCombat") then
                    player.PlayerStats.inCombat.Value = false
                end
                task.wait(0.5)
            end
        end)
    end
end)

FarmTab.newToggle("Auto Collect Meteor", "Collects meteors.", false, function(v)
    autoFarm.meteor = v
    if v then MeteorFarm.start(player, getCharacter, smoothFlyTo, function() return autoFarm.meteor end)
    else MeteorFarm.stop() end
    stopAllMovement()
end)

FarmTab.newToggle("Auto Collect GlassBeam", "Collects beams.", false, function(v)
    autoFarm.glassBeam = v
    if v then GlassBeamFarm.start(smoothFlyTo, function() return autoFarm.glassBeam end, function() return isFlying end)
    else GlassBeamFarm.stop() end
    stopAllMovement()
end)

PlayerTab.newSlider("WalkSpeed", "16-200", 16, 200, 16, false, function(v)
    playerMods.walkSpeed = v
    if humanoid then humanoid.WalkSpeed = v end
end)
PlayerTab.newSlider("JumpPower", "50-300", 50, 300, 50, false, function(v)
    playerMods.jumpPower = v
    if humanoid then humanoid.JumpPower = v end
end)

EspTab.newToggle("Enable ESP", "Master ESP", true, function(v) ESP.SetEnabled(v) end)
EspTab.newToggle("Show Boxes", "", true, function(v) ESP.SetShowBoxes(v) end)
EspTab.newToggle("Show Names", "", true, function(v) ESP.SetShowNames(v) end)
EspTab.newToggle("Show Tracers", "", true, function(v) ESP.SetShowTracers(v) end)
EspTab.newToggle("Show Health", "", true, function(v) ESP.SetShowHealth(v) end)
EspTab.newToggle("Rainbow Color", "", true, function(v) ESP.SetRainbow(v) end)

SettingsTab.newSlider("Fly Speed", "20-200", 20, 200, 50, false, function(v) flySpeed = v end)
SettingsTab.newButton("Rejoin Server", "", function() TeleportService:Teleport(game.PlaceId) end)
SettingsTab.newButton("Destroy GUI", "", function() Window:Close() end)
