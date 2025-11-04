local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character, humanoid, rootPart

local function getCharacter()
    character = player.Character
    if character then
        humanoid = character:FindFirstChildOfClass("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
    end
end
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    getCharacter()
    if humanoid then
        if playerMods and playerMods.walkSpeed then humanoid.WalkSpeed = playerMods.walkSpeed end
        if playerMods and playerMods.jumpPower then humanoid.JumpPower = playerMods.jumpPower end
    end
end)
getCharacter()

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/unsolven/IVORYHUB/refs/heads/main/Scripts/ESP.luau"))()
local MeteorFarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/unsolven/IVORYHUB/refs/heads/main/Scripts/MeteorFarm.luau"))()
local GlassBeamFarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/unsolven/IVORYHUB/refs/heads/main/Scripts/GlassbeamFarm.luau"))()
local DinoInventory = loadstring(game:HttpGet("https://raw.githubusercontent.com/unsolven/IVORYHUB/refs/heads/main/Scripts/Inventory.luau"))()

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/unsolven/IVORYHUB/refs/heads/main/UI.luau"))()
local Window = DrRayLibrary:Load("ivoryHub", "Default")

local MainTab = DrRayLibrary.newTab("Main")
local FarmTab = DrRayLibrary.newTab("Farm")
local PlayerTab = DrRayLibrary.newTab("Player")
local EspTab = DrRayLibrary.newTab("ESP")
local SettingsTab = DrRayLibrary.newTab("Settings")

local isFlying = false
local autoFarm = { meteor = false, glassBeam = false }
local autoAttack = { normal = false, aoe = false }
local flySpeed = 50
playerMods = { walkSpeed = 16, jumpPower = 50 }

local function stopAllMovement() 
    isFlying = false 
end

local function smoothFlyTo(targetPos)
    if isFlying or not rootPart then return end
    isFlying = true
    task.spawn(function()
        getCharacter()
        local startPosition = rootPart.Position
        local duration = math.clamp((startPosition - targetPos).Magnitude / (flySpeed * 2.5), 1, 5)
        local elapsedTime = 0
        while elapsedTime < duration and isFlying and rootPart and humanoid and humanoid.Health > 0 do
            elapsedTime = elapsedTime + RunService.Heartbeat:Wait()
            if not rootPart or not rootPart.Parent then break end
            rootPart.CFrame = CFrame.new(startPosition:Lerp(targetPos, elapsedTime / duration))
        end
        isFlying = false
    end)
end

MainTab.newLabel("Combat")
MainTab.newToggle("Auto Normal Attack", "Continuously performs your primary attack.", false, function(v)
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

MainTab.newToggle("Auto AOE Attack", "Continuously performs your special attack.", false, function(v)
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
MainTab.newToggle("Disable Combat", "Forces you out of combat status.", false, function(v)
    if v then 
        task.spawn(function() 
            while v do 
                if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("inCombat") then 
                    player.PlayerStats.inCombat.Value = false 
                end
                task.wait(0.5) 
            end 
        end) 
    end
end)

MainTab.newLabel("Dinosaur Tokens")
local dinoNameInput
MainTab.newInput("Dinosaur Name", "Enter a dinosaur name to get its data.", function(text) 
    dinoNameInput = text 
end)
MainTab.newButton("Add Dinosaur to Inventory", "Simulates ownership for skins.", function()
    local success, message = DinoInventory.addDinosaur(player, dinoNameInput)
    print("Ivory Hub: " .. message)
end)
MainTab.newButton("Add All Dinosaurs", "Adds every dinosaur from database.", function()
    local success, message = DinoInventory.addAllDinosaurs(player)
    print("Ivory Hub: " .. message)
end)

FarmTab.newLabel("Auto Farm")
FarmTab.newToggle("Auto Collect Meteor", "Automatically finds and collects meteors.", false, function(v)
    if v then
        MeteorFarm.start(player, getCharacter, smoothFlyTo, function() return autoFarm.meteor end)
    else
        MeteorFarm.stop()
    end
    autoFarm.meteor = v
    stopAllMovement()
end)

FarmTab.newToggle("Auto Collect GlassBeam", "Flies into Glass Beams to collect them.", false, function(v) 
    if v then
        GlassBeamFarm.start(smoothFlyTo, function() return autoFarm.glassBeam end, function() return isFlying end)
    else
        GlassBeamFarm.stop()
    end
    autoFarm.glassBeam = v
    stopAllMovement() 
end)

PlayerTab.newSlider("WalkSpeed", "Changes your WalkSpeed.", 16, 200, 16, false, function(v) 
    playerMods.walkSpeed = v
    if humanoid then humanoid.WalkSpeed = v end 
end)
PlayerTab.newSlider("JumpPower", "Changes your JumpPower.", 50, 300, 50, false, function(v) 
    playerMods.jumpPower = v
    if humanoid then humanoid.JumpPower = v end 
end)

EspTab.newLabel("ESP Settings")
EspTab.newToggle("Enable ESP", "Master switch for the ESP.", true, function(v) ESP.SetEnabled(v) end)
EspTab.newToggle("Show Boxes", "Draws a box around players.", true, function(v) ESP.SetShowBoxes(v) end)
EspTab.newToggle("Show Names", "Displays player names.", true, function(v) ESP.SetShowNames(v) end)
EspTab.newToggle("Show Tracers", "Draws a line to players.", true, function(v) ESP.SetShowTracers(v) end)
EspTab.newToggle("Show Health", "Displays a health bar on the side.", true, function(v) ESP.SetShowHealth(v) end)
EspTab.newToggle("Rainbow Color", "Cycles through rainbow colors.", true, function(v) ESP.SetRainbow(v) end)

SettingsTab.newSlider("Fly Speed", "Adjusts the speed of all flight.", 20, 200, 30, false, function(v) 
    flySpeed = v 
end)
SettingsTab.newButton("Rejoin Server", "Teleports you to a new server.", function() 
    TeleportService:Teleport(game.PlaceId) 
end)
SettingsTab.newButton("Destroy GUI", "Closes the UI completely.", function() 
    Window:Close() 
end)
