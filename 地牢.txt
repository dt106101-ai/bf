local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local CONFIG = {
    TargetTeleporterName = "ExitTeleporter",
    CheckInterval = 1,
    TweenTime = 0.8,
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out,
    DisableMovement = true,
    DetectionRadius = 1000,
    CooldownAfterTeleport = 3
}

local isTeleporting = false
local isDetecting = true
local lastTeleportTime = 0
local lastTeleportedLevel = 0

local function updateCharacterReferences()
    character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    isTeleporting = false
end

local function getAllExitTeleporters()
    local teleporters = {}
    
    local map = Workspace:FindFirstChild("Map")
    if not map then return teleporters end
    
    local dungeonFolder = map:FindFirstChild("Dungeon")
    if not dungeonFolder then return teleporters end
    
    for _, levelFolder in pairs(dungeonFolder:GetChildren()) do
        local levelNumber = tonumber(levelFolder.Name)
        if levelNumber then
            local teleporter = levelFolder:FindFirstChild(CONFIG.TargetTeleporterName)
            if teleporter then
                local rootPart = teleporter:FindFirstChild("Root")
                if rootPart then
                    table.insert(teleporters, {
                        level = levelNumber,
                        teleporter = teleporter,
                        rootPart = rootPart,
                        position = rootPart.Position
                    })
                end
            end
        end
    end
    
    table.sort(teleporters, function(a, b)
        return a.level < b.level
    end)
    
    return teleporters
end

local function getCurrentLevel()
    local playerPosition = humanoidRootPart.Position
    local allTeleporters = getAllExitTeleporters()
    local closestLevel = nil
    local minDistance = math.huge
    
    for _, teleporterInfo in ipairs(allTeleporters) do
        local distance = (playerPosition - teleporterInfo.position).Magnitude
        if distance < minDistance and distance < CONFIG.DetectionRadius then
            minDistance = distance
            closestLevel = teleporterInfo.level
        end
    end
    
    return closestLevel, minDistance
end

local function teleportToTarget(rootPart, level)
    if isTeleporting then return end
    
    local currentTime = tick()
    if currentTime - lastTeleportTime < CONFIG.CooldownAfterTeleport then
        return
    end
    
    isTeleporting = true
    lastTeleportTime = currentTime
    lastTeleportedLevel = level

    if CONFIG.DisableMovement then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end

    local tweenInfo = TweenInfo.new(
        CONFIG.TweenTime,
        CONFIG.EasingStyle,
        CONFIG.EasingDirection
    )
    local teleportGoal = { CFrame = rootPart.CFrame }
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, teleportGoal)
    
    tween:Play()

    tween.Completed:Connect(function()
        if CONFIG.DisableMovement then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
        
        task.wait(0.5)
        isTeleporting = false
    end)
end

local function mainDetectionLoop()
    while isDetecting do
        task.wait(CONFIG.CheckInterval)
        
        if not game:IsLoaded() or not localPlayer then
            break
        end
        
        if not character or not character:IsDescendantOf(Workspace) or humanoid.Health <= 0 then
            updateCharacterReferences()
            continue
        end
        
        if isTeleporting then
            continue
        end
        
        local currentLevel, currentDistance = getCurrentLevel()
        local allTeleporters = getAllExitTeleporters()
        
        if currentLevel then
            for _, teleporterInfo in ipairs(allTeleporters) do
                if teleporterInfo.level == currentLevel then
                    teleportToTarget(teleporterInfo.rootPart, currentLevel)
                    break
                end
            end
        else
            for _, teleporterInfo in ipairs(allTeleporters) do
                local distance = (humanoidRootPart.Position - teleporterInfo.position).Magnitude
                if distance < CONFIG.DetectionRadius then
                    teleportToTarget(teleporterInfo.rootPart, teleporterInfo.level)
                    break
                end
            end
        end
    end
end

localPlayer.CharacterAdded:Connect(updateCharacterReferences)

localPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
    if not localPlayer.Parent then
        isDetecting = false
    end
end)

localPlayer.Chatted:Connect(function(message)
    if message == "/stopdetect" then
        isDetecting = false
    elseif message == "/startdetect" then
        if not isDetecting then
            isDetecting = true
            task.spawn(mainDetectionLoop)
        end
    elseif message == "/checklevel" then
        local currentLevel, distance = getCurrentLevel()
    elseif message:match("^/goto (%d+)$") then
        local targetLevel = tonumber(message:match("^/goto (%d+)$"))
        if targetLevel then
            local allTeleporters = getAllExitTeleporters()
            local found = false
            
            for _, teleporterInfo in ipairs(allTeleporters) do
                if teleporterInfo.level == targetLevel then
                    teleportToTarget(teleporterInfo.rootPart, targetLevel)
                    found = true
                    break
                end
            end
        end
    elseif message == "/listlevels" then
        local allTeleporters = getAllExitTeleporters()
        if #allTeleporters > 0 then
            for _, teleporterInfo in ipairs(allTeleporters) do
                local distance = (humanoidRootPart.Position - teleporterInfo.position).Magnitude
            end
        end
    elseif message == "/status" then
    elseif message == "/config" then
    end
end)

updateCharacterReferences()

task.spawn(function()
    mainDetectionLoop()
end)
