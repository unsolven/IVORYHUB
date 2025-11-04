local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESP = { 
    Enabled = true, 
    ShowBoxes = true, 
    ShowNames = true, 
    ShowTracers = true, 
    ShowHealth = true, 
    Color = nil 
}
local ESPObjects = {}

local function newDrawing(type, props) 
    local obj = Drawing.new(type)
    for k, v in pairs(props) do obj[k] = v end
    return obj 
end

local function createESPElements() 
    return { 
        Box = newDrawing("Square", {Visible = false, Thickness = 2, Filled = false}), 
        Name = newDrawing("Text", {Visible = false, Center = true, Outline = true, Size = 16, Font = 2}), 
        Tracer = newDrawing("Line", {Visible = false, Thickness = 1}), 
        HealthBar = newDrawing("Line", {Visible = false, Thickness = 4}) 
    } 
end

local function getRainbowColor(t) 
    return Color3.fromHSV((t * 0.5) % 1, 1, 1) 
end

local function getHealthColor(health) 
    if health > 0.7 then return Color3.fromRGB(85, 255, 85) 
    elseif health > 0.3 then return Color3.fromRGB(255, 255, 85) 
    else return Color3.fromRGB(255, 85, 85) end 
end

local function getBoxScreenPoints(cframe, size) 
    local half = size / 2
    local points = {}
    local visible = true
    for x = -1,1,2 do 
        for y = -1,1,2 do 
            for z = -1,1,2 do 
                local corner = cframe * CFrame.new(half.X*x, half.Y*y, half.Z*z)
                local screenPos, onScreen = Camera:WorldToViewportPoint(corner.Position)
                if not onScreen then visible = false end
                table.insert(points, Vector2.new(screenPos.X, screenPos.Y)) 
            end 
        end 
    end
    return points, visible 
end

local function hideAll(data) 
    data.Box.Visible, data.Name.Visible, data.Tracer.Visible, data.HealthBar.Visible = false, false, false, false 
end

RunService.RenderStepped:Connect(function() 
    if not ESP.Enabled then 
        for _, data in pairs(ESPObjects) do hideAll(data) end
        return 
    end
    
    local now = tick()
    local baseColor = ESP.Color or getRainbowColor(now)
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)

    for _, p in ipairs(Players:GetPlayers()) do 
        if p ~= player then 
            local char = p.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health > 0 then 
                local s, cframe, size = pcall(function() return char:GetBoundingBox() end)
                if s and cframe and size then 
                    local points, visible = getBoxScreenPoints(cframe, size)
                    if not visible then 
                        if ESPObjects[p] then hideAll(ESPObjects[p]) end 
                    else 
                        local data = ESPObjects[p] or createESPElements()
                        ESPObjects[p] = data
                        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
                        for _, pt in ipairs(points) do 
                            minX, minY, maxX, maxY = math.min(minX, pt.X), math.min(minY, pt.Y), math.max(maxX, pt.X), math.max(maxY, pt.Y) 
                        end
                        local boxW, boxH = maxX - minX, maxY - minY
                        local healthRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)

                        if ESP.ShowBoxes then 
                            data.Box.Visible = true
                            data.Box.Position = Vector2.new(minX, minY)
                            data.Box.Size = Vector2.new(boxW, boxH)
                            data.Box.Color = baseColor
                        else 
                            data.Box.Visible = false 
                        end
                        
                        if ESP.ShowNames then 
                            data.Name.Visible = true
                            data.Name.Text = p.Name
                            data.Name.Position = Vector2.new(minX + boxW/2, minY - 20)
                            data.Name.Color = baseColor
                        else 
                            data.Name.Visible = false 
                        end
                        
                        if ESP.ShowTracers then 
                            data.Tracer.Visible = true
                            data.Tracer.From = screenCenter
                            data.Tracer.To = Vector2.new(minX + boxW/2, maxY)
                            data.Tracer.Color = baseColor
                        else 
                            data.Tracer.Visible = false 
                        end
                        
                        if ESP.ShowHealth then 
                            data.HealthBar.Visible = true
                            data.HealthBar.Color = getHealthColor(healthRatio)
                            data.HealthBar.From = Vector2.new(minX - 6, maxY)
                            data.HealthBar.To = Vector2.new(minX - 6, maxY - (boxH * healthRatio))
                        else 
                            data.HealthBar.Visible = false 
                        end
                    end 
                end 
            else 
                if ESPObjects[p] then hideAll(ESPObjects[p]) end 
            end 
        else 
            if ESPObjects[p] then hideAll(ESPObjects[p]) end 
        end 
    end 
end)

Players.PlayerRemoving:Connect(function(p) 
    if ESPObjects[p] then 
        for _, obj in pairs(ESPObjects[p]) do obj:Remove() end
        ESPObjects[p] = nil 
    end 
end)

return {
    SetEnabled = function(v) ESP.Enabled = v end,
    SetShowBoxes = function(v) ESP.ShowBoxes = v end,
    SetShowNames = function(v) ESP.ShowNames = v end,
    SetShowTracers = function(v) ESP.ShowTracers = v end,
    SetShowHealth = function(v) ESP.ShowHealth = v end,
    SetRainbow = function(v) 
        if v then ESP.Color = nil else ESP.Color = Color3.new(1,1,1) end 
    end
}
