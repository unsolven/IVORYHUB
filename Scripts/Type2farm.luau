local RunService = game:GetService("RunService")

local Type2Farm = {}
local isRunning = false
local farmLoop

function Type2Farm.start(player, getCharacter, smoothFlyTo, isEnabledFunc)
    isRunning = true
    
    farmLoop = task.spawn(function()
        while isRunning and isEnabledFunc() do
            local character, humanoid, rootPart = getCharacter()
            
            if not humanoid or humanoid.Health <= 0 or not rootPart then 
                task.wait(1)
                continue 
            end
            
            if _G.isFlying then 
                task.wait(1)
                continue 
            end
            
            local nearestMeteor, nearestDistance = nil, math.huge
            for _, obj in pairs(workspace.MiscellaneousStorage:GetChildren()) do
                if obj.Name == "Meteor" then
                    local base = obj:FindFirstChild("MeteorBase")
                    local prompt = base and base:FindFirstChild("Attachment") and base.Attachment:FindFirstChild("ProximityPrompt")
                    if prompt and prompt.Enabled then 
                        local dist = (base.Position - rootPart.Position).Magnitude
                        if dist < nearestDistance then 
                            nearestDistance = dist
                            nearestMeteor = {part = base, prompt = prompt} 
                        end 
                    end
                end
            end
            
            if nearestMeteor then
                smoothFlyTo(nearestMeteor.part.Position + Vector3.new(0, 5, 0))
                
                repeat task.wait() until not _G.isFlying or not isRunning
                
                character, humanoid, rootPart = getCharacter()
                if isEnabledFunc() and humanoid and humanoid.Health > 0 and rootPart and (nearestMeteor.part.Position - rootPart.Position).Magnitude < 20 then 
                    nearestMeteor.prompt.HoldDuration = 0
                    fireproximityprompt(nearestMeteor.prompt)
                    task.wait(1) 
                end
            end
            task.wait(0.1)
        end
    end)
end

function Type2Farm.stop()
    isRunning = false
    if farmLoop then
        task.cancel(farmLoop)
        farmLoop = nil
    end
end

return Type2Farm
