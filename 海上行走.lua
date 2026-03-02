local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local waterWalkEnabled = false
local platform
local renderConn

local function getHRP()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function getWaterY()
    local water = Workspace:FindFirstChild("Water")
    return water and water.Position.Y or 0
end

local function createPlatform()
    if platform then platform:Destroy() end

    local hrp = getHRP()
    if not hrp then return end

    platform = Instance.new("Part")
    platform.Name = "WaterWalkPlatform"
    platform.Size = Vector3.new(50, 1, 50)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 1
    platform.Parent = Workspace

    platform.Position = Vector3.new(
        hrp.Position.X,
        getWaterY() - 3,
        hrp.Position.Z
    )
end

local function updatePlatform()
    if not platform then return end
    local hrp = getHRP()
    if not hrp then return end

    local waterY = getWaterY()

    if hrp.Position.Y < waterY then
        platform.CanCollide = false
    else
        platform.CanCollide = true
        platform.Position = Vector3.new(
            hrp.Position.X,
            waterY - 3,
            hrp.Position.Z
        )
    end
end

function setWaterWalkState(state)
    waterWalkEnabled = state

    if state then
        createPlatform()
        renderConn = RunService.RenderStepped:Connect(updatePlatform)
    else
        if renderConn then
            renderConn:Disconnect()
            renderConn = nil
        end
        if platform then
            platform:Destroy()
            platform = nil
        end
    end
end
