local RunService = game:GetService("RunService")

local MeteorFarm = {}
local isRunning = false
local farmLoop

function MeteorFarm.start(player, getCharacter, smoothFlyTo, isEnabledFunc)
    isRunning = true
    
    farmLoop = task.spawn(function()
        while isRunning and isEnabledFunc() do
            local character, humanoid, rootPart = getCharacter()
            
            if not humanoid or humanoid.Health <= 0 then 
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
                
                repeat task.wait() until not isFlying or not isRunning
                
                character, humanoid, rootPart = getCharacter()
                if isEnabledFunc() and humanoid and humanoid.Health > 0 and (nearestMeteor.part.Position - rootPart.Position).Magnitude < 20 then 
                    nearestMeteor.prompt.HoldDuration = 0
                    fireproximityprompt(nearestMeteor.prompt)
                    task.wait(1) 
                end
            end
            task.wait(0.1)
        end
    end)
end

function MeteorFarm.stop()
    isRunning = false
    if farmLoop then
        task.cancel(farmLoop)
        farmLoop = nil
    end
end

return MeteorFarm
