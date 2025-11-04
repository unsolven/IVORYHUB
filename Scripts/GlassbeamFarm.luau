local GlassBeamFarm = {}
local connection

function GlassBeamFarm.start(smoothFlyTo, isEnabledFunc, isFlyingFunc)
    connection = workspace.MiscellaneousStorage.ChildAdded:Connect(function(child) 
        if (child.Name == "Beam" or child.Name == "Glass Beam") and isEnabledFunc() and not isFlyingFunc() then 
            local beamPart = child:WaitForChild("Beam", 5)
            if not beamPart then return end

            smoothFlyTo(beamPart.Position - Vector3.new(0, 5, 0))
            
            task.spawn(function() 
                repeat task.wait() until not isFlyingFunc()
                
                if not (isEnabledFunc() and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then 
                    return 
                end
                
                child.Destroying:Wait()
                if not (isEnabledFunc() and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then 
                    return 
                end
                
                local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
                smoothFlyTo(rootPart.Position + Vector3.new(0, 50, 0))
            end) 
        end 
    end)
end

function GlassBeamFarm.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

return GlassBeamFarm
