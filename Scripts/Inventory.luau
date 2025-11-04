local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DinoInventory = {}

function DinoInventory.addDinosaur(player, dinoName)
    if not dinoName or dinoName == "" then
        return false, "No dinosaur name provided"
    end
    
    local MemoryCard = player:FindFirstChild("MemoryCard") or Instance.new("Folder", player)
    MemoryCard.Name = "MemoryCard"
    
    local Database = ReplicatedStorage:FindFirstChild("Database")
    if not (Database and Database:FindFirstChild("Dinosaurs")) then 
        return false, "Database not found"
    end
    
    local dinoData = Database.Dinosaurs:FindFirstChild(dinoName)
    if not dinoData then 
        return false, "Dinosaur not found in database: " .. dinoName
    end
    
    local playerDinosFolder = MemoryCard:FindFirstChild("Dinosaurs") or Instance.new("Folder", MemoryCard)
    playerDinosFolder.Name = "Dinosaurs"
    
    if not playerDinosFolder:FindFirstChild(dinoName) then
        dinoData:Clone().Parent = playerDinosFolder
        return true, "Added " .. dinoName .. " to inventory"
    else
        return false, "Already have " .. dinoName
    end
end

function DinoInventory.removeDinosaur(player, dinoName)
    local MemoryCard = player:FindFirstChild("MemoryCard")
    if not MemoryCard then return false, "No MemoryCard found" end
    
    local playerDinosFolder = MemoryCard:FindFirstChild("Dinosaurs")
    if not playerDinosFolder then return false, "No Dinosaurs folder found" end
    
    local dino = playerDinosFolder:FindFirstChild(dinoName)
    if dino then
        dino:Destroy()
        return true, "Removed " .. dinoName .. " from inventory"
    else
        return false, "Dinosaur not found in inventory"
    end
end

function DinoInventory.listDinosaurs(player)
    local MemoryCard = player:FindFirstChild("MemoryCard")
    if not MemoryCard then return {} end
    
    local playerDinosFolder = MemoryCard:FindFirstChild("Dinosaurs")
    if not playerDinosFolder then return {} end
    
    local dinoList = {}
    for _, dino in pairs(playerDinosFolder:GetChildren()) do
        table.insert(dinoList, dino.Name)
    end
    return dinoList
end

function DinoInventory.addAllDinosaurs(player)
    local Database = ReplicatedStorage:FindFirstChild("Database")
    if not (Database and Database:FindFirstChild("Dinosaurs")) then 
        return false, "Database not found"
    end
    
    local count = 0
    for _, dino in pairs(Database.Dinosaurs:GetChildren()) do
        local success = DinoInventory.addDinosaur(player, dino.Name)
        if success then count = count + 1 end
    end
    
    return true, "Added " .. count .. " dinosaurs to inventory"
end

return DinoInventory
