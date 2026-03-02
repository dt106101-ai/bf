local function removeFog()
    local lightingService = game:GetService("Lighting")
    if lightingService:FindFirstChild("LightingLayers") then
        lightingService.LightingLayers:Destroy()
    end
    if lightingService:FindFirstChild("Sky") then
        lightingService.Sky:Destroy()
    end
    lightingService.FogEnd = 9000000000
end

removeFog()
