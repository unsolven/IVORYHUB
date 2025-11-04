local RunService = game:GetService("RunService")

local Type4Farm = {}
local isRunning = false
local farmLoop

function Type4Farm.start(player, getCharacter, smoothFlyTo, isEnabledFunc)
    isRunning = true
    
    farmLoop = task.spawn(function()
        while isRunning and isEnabledFunc() do
            local character, humanoid, rootPart = getCharacter()
            
            if not humanoid or humanoid.Health <= 0 then 
                task.wait(1)
                continue 
            end
            
            if _G.isFlying then 
                task.wait(0.5)
                continue 
            end
            
            local interactables = workspace:FindFirstChild("Interactables")
            if not interactables then 
                task.wait(2)
                continue 
            end
            
            local type4Location = interactables:FindFirstChild("Type4Location")
            if not type4Location then 
                task.wait(2)
                continue 
            end
            
            local base = type4Location:FindFirstChild("Base")
            if not base then 
                task.wait(2)
                continue 
            end
            
            local attachment = base:FindFirstChild("Attachment")
            if not attachment then 
                task.wait(2)
                continue 
            end
            
            local prompt = attachment:FindFirstChild("ProximityPrompt")
            if not prompt or not prompt.Enabled then 
                task.wait(2)
                continue 
            end
            
            smoothFlyTo(base.Position + Vector3.new(0, 3, 0))
            
            repeat task.wait() until not _G.isFlying or not isRunning
            
            character, humanoid, rootPart = getCharacter()
            if isEnabledFunc() and humanoid and humanoid.Health > 0 then
                local retries = 0
                while retries < 3 and prompt.Parent and prompt.Enabled do
                    prompt.HoldDuration = 0
                    local success = pcall(function()
                        fireproximityprompt(prompt)
                    end)
                    if success then
                        task.wait(1)
                        if not prompt.Enabled then break end
                    end
                    retries = retries + 1
                    task.wait(0.5)
                end
            end
            
            task.wait(3)
        end
    end)
end

function Type4Farm.stop()
    isRunning = false
    if farmLoop then
        task.cancel(farmLoop)
        farmLoop = nil
    end
end

return Type4Farm
