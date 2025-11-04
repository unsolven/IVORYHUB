local RunService = game:GetService("RunService")

local SkulkerFarm = {}
local isRunning = false
local farmLoop

function SkulkerFarm.start(player, getCharacter, smoothFlyTo, isEnabledFunc)
    isRunning = true
    
    farmLoop = task.spawn(function()
        while isRunning and isEnabledFunc() do
            local character, humanoid, rootPart = getCharacter()
            
            if not humanoid or humanoid.Health <= 0 then 
                task.wait(1)
                continue 
            end
            
            local charStorage = workspace:FindFirstChild("CharStorage")
            if not charStorage then task.wait(1); continue end
            
            local nearestSkulker, nearestDistance = nil, math.huge
            for _, skulker in pairs(charStorage:GetChildren()) do
                if skulker.Name == "Skulker" then
                    local hurtbox = skulker:FindFirstChild("Hurtbox")
                    local hurtboxPart = hurtbox and hurtbox:FindFirstChild("HurtboxPart")
                    local skulkerHum = skulker:FindFirstChild("Humanoid")
                    
                    if hurtboxPart and skulkerHum and skulkerHum.Health > 0 then
                        local dist = (hurtboxPart.Position - rootPart.Position).Magnitude
                        if dist < nearestDistance then
                            nearestDistance = dist
                            nearestSkulker = {part = hurtboxPart, humanoid = skulkerHum}
                        end
                    end
                end
            end
            
            if nearestSkulker then
                local behindPos = nearestSkulker.part.Position - nearestSkulker.part.CFrame.LookVector * 8
                smoothFlyTo(behindPos)
                
                repeat task.wait() until not _G.isFlying or not isRunning
                
                character, humanoid, rootPart = getCharacter()
                while isEnabledFunc() and nearestSkulker.humanoid.Health > 0 and humanoid and humanoid.Health > 0 do
                    workspace.GameEvents.Damage:FireServer()
                    task.wait(0.1)
                    workspace.GameEvents.AOEDamage:FireServer()
                    task.wait(0.4)
                end
                
                task.wait(0.5)
            else
                task.wait(1)
            end
        end
    end)
end

function SkulkerFarm.stop()
    isRunning = false
    if farmLoop then
        task.cancel(farmLoop)
        farmLoop = nil
    end
end

return SkulkerFarm
