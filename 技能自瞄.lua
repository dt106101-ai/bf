local SilentAimModule = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local UserInputService = game:GetService("UserInputService")  
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local RS = game:GetService("ReplicatedStorage")
local commE = RS:WaitForChild("Remotes"):WaitForChild("CommE")
local MouseModule = RS:FindFirstChild("Mouse")

local Services = setmetatable({}, {
    __index = function(self, serviceName)
        local good, service = pcall(game.GetService, game, serviceName);
        if (good) then
            self[serviceName] = service
            return service;
        end
    end
});

local SilentAimPlayersEnabled = false
local UserWantsplayerAim = false
local PredictionEnabled = false
local HighlightEnabled = false 
local ZSkillorM1 = false
local autoKenRunning = false  -- 已禁用

local renderConnection = nil
local currentTool = nil
local playersaimbot = nil
local PlayersPosition = nil
local Selectedplayer = nil

local characterConnections = {}
local Skills = {"X"}
local Booms = {"TAP"}

local PredictionAmount = 0.1
local maxRange = 1000

local lastTool = nil
local sharkZActive, vActive, cursedZActive = false, false, false
local dmgConn = nil
local rightTouchActive = false

local function clearVSkillConnections()
	if dmgConn then
		pcall(function() dmgConn:Disconnect() end)
		dmgConn = nil
	end
end

local function DisableSilentAimbot()
    SilentAimPlayersEnabled = false
end

local function EnableSilentAimbot()
    SilentAimPlayersEnabled = UserWantsplayerAim
end

local function hookTool(tool)
    currentTool = tool
    lastTool = tool.Name
    table.insert(characterConnections, tool.AncestryChanged:Connect(function(_, parent)
        if not parent then
            currentTool = nil
            lastTool = nil
            sharkZActive, vActive, cursedZActive = false, false, false
            rightTouchActive = false
            EnableSilentAimbot()
        end
    end))
end

local function isValidStopCondition()
    return (currentTool and currentTool.Name == "Shark Anchor" and sharkZActive)
        or (lastTool == "Dough-Dough" and vActive)
        or (currentTool and currentTool.Name == "Cursed Dual Katana" and cursedZActive)
end

UserInputService.TouchStarted:Connect(function(touch)
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    if touch.Position.X > camera.ViewportSize.X / 2 then
        rightTouchActive = true

        if isValidStopCondition() then
            DisableSilentAimbot()
        end
    end
end)

UserInputService.TouchEnded:Connect(function(touch)
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    if touch.Position.X > camera.ViewportSize.X / 2 then
        rightTouchActive = false

        EnableSilentAimbot()
        sharkZActive, vActive, cursedZActive = false, false, false
    end
end)

local function watchDamageCounter()
	clearVSkillConnections()

	task.spawn(function()
		while true do
			local success, gui = pcall(function()
				return player:WaitForChild("PlayerGui", 5)
			end)
			if not success or not gui then
				task.wait(1)
				continue
			end

			local success2, mainGui = pcall(function()
				return gui:WaitForChild("Main", 5)
			end)
			if not success2 or not mainGui then
				task.wait(1)
				continue
			end

			local success3, dmgCounter = pcall(function()
				return mainGui:WaitForChild("DmgCounter", 5)
			end)
			if not success3 or not dmgCounter then
				task.wait(1)
				continue
			end

			local success4, dmgTextLabel = pcall(function()
				return dmgCounter:WaitForChild("Text", 5)
			end)
			if not success4 or not dmgTextLabel then
				task.wait(1)
				continue
			end

			dmgConn = dmgTextLabel:GetPropertyChangedSignal("Text"):Connect(function()
				local dmgText = tonumber(dmgTextLabel.Text) or 0
				if dmgText > 0 and isValidStopCondition() and rightTouchActive then
					DisableSilentAimbot()
				elseif not rightTouchActive then
					EnableSilentAimbot()
				end
			end)
			table.insert(characterConnections, dmgConn)			
			break
		end
	end)
end

if not getgenv().VSkillHooked then
    getgenv().VSkillHooked = true
    local old
	old = hookmetamethod(game, "__namecall", function(self, ...)
	    local method = getnamecallmethod()
	    local args = {...}
    
	    if (method == "InvokeServer" or method == "FireServer") then
	        local a1 = args[1]

	        if typeof(a1) == "string" and a1:upper() == "Z" then
	            if currentTool and currentTool.Name == "Shark Anchor" then
	                sharkZActive = true
	            end
	        end
        
	        if typeof(a1) == "string" and a1:upper() == "V" then
	            if lastTool == "Dough-Dough" then
	                vActive = true
	            end
	        end
        
	        if typeof(a1) == "string" and a1:upper() == "Z" then
	            if currentTool and currentTool.Name == "Cursed Dual Katana" then
	                cursedZActive = true
	            end
			end
	    end
	    return old(self, ...)
	end)
end

local function getHRP(model)
	if not model or not model:FindFirstChild("HumanoidRootPart") then return nil end
	return model.HumanoidRootPart
end

local function clearConnections()
	for _, conn in ipairs(characterConnections) do
		pcall(function() conn:Disconnect() end)
	end
	characterConnections = {}
	clearVSkillConnections()
end

local function getPredictedPosition(hrp)
	if not hrp then return nil end

	local humanoid = hrp.Parent:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return hrp.Position
	end

	if not PredictionEnabled or humanoid.WalkSpeed < 5 then
		return hrp.Position
	end

	return hrp.Position + (hrp.Velocity * PredictionAmount)
end

-- 安全版：不掃 GUI，直接用 Team 判斷（Pirates 內部全敵，Marines 內部不瞄）
local function isAllyWithMe(targetplayer)
    local myTeam = player.Team
    local targetTeam = targetplayer.Team
    if myTeam and targetTeam then
        if myTeam.Name == targetTeam.Name then
            return myTeam.Name == "Marines"  -- Marines 內部不瞄，Pirates 內部瞄
        end
    end
    return false
end

local function isEnemy(targetplayer)
	if not targetplayer or targetplayer == player then
		return false
	end

	local myTeam = player.Team
	local targetTeam = targetplayer.Team

	if myTeam and targetTeam then
		if myTeam.Name == "Pirates" and targetTeam.Name == "Marines" then
			return true
		elseif myTeam.Name == "Marines" and targetTeam.Name == "Pirates" then
			return true
		end

		if myTeam.Name == "Pirates" and targetTeam.Name == "Pirates" then
			return not isAllyWithMe(targetplayer)
		end

		if myTeam.Name == "Marines" and targetTeam.Name == "Marines" then
			return false
		end
	end

	return true
end

local function getClosestplayer(lpHRP)
	if not lpHRP then return nil end
	
	local closest = nil
	local closestDist = math.huge
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= player and isEnemy(pl) and pl.Character and pl.Character.Parent ~= nil then
			local hum = pl.Character:FindFirstChildWhichIsA("Humanoid")
			local hrp = getHRP(pl.Character)
			if hum and hum.Health > 0 and hrp then
				local dist = (hrp.Position - lpHRP.Position).Magnitude
				if dist <= maxRange and dist < closestDist then
					closestDist = dist
					closest = pl
				end
			end
		end
	end
	return closest
end

local function isSkillReadyForTool(toolName)
    if not toolName then return false end
    local success, playerGui = pcall(function()
        return player:WaitForChild("PlayerGui", 3)
    end)
    if not success or not playerGui then return false end
    local success2, mainGui = pcall(function()
        return playerGui:WaitForChild("Main", 3)
    end)
    if not success2 or not mainGui then return false end
    local success3, skillsFolder = pcall(function()
        return mainGui:WaitForChild("Skills", 3)
    end)
    if not success3 or not skillsFolder then return false end
    local success4, toolFrame = pcall(function()
        return skillsFolder:WaitForChild(toolName, 3)
    end)
    if not success4 or not toolFrame then return false end

    for _, skillKey in ipairs({"Z","X","C","V"}) do
        local success5, skill = pcall(function()
            return toolFrame:WaitForChild(skillKey, 1)
        end)
        if success5 and skill and skill:FindFirstChild("Cooldown") and skill.Cooldown:IsA("Frame") then
            local cooldownSize = skill.Cooldown.Size.X.Scale
            if cooldownSize == 1.0 then
                return true
            end
        end
    end
    return false
end

local function isNotDoughValidCondition()
    return (currentTool and currentTool.Name == "Dough-Dough")
end

local function isNotValidCondition()
    return (currentTool and currentTool.Name == "Lightning-Lightning")
    or (currentTool and currentTool.Name == "Portal-Portal")
end

local function startRenderLoop()
    if renderConnection then return end

    renderConnection = RunService.RenderStepped:Connect(function()
        local lpChar = player.Character
        if not lpChar then return end
        local lpHRP = lpChar:FindFirstChild("HumanoidRootPart")
        if not lpHRP then return end

        if not SilentAimPlayersEnabled then
            return
        end

        local lookTargetPos = nil

        if SilentAimPlayersEnabled then
            local targetplayer = Selectedplayer or getClosestplayer(lpHRP)
            if targetplayer and targetplayer ~= player and targetplayer.Character then
                playersaimbot = targetplayer.Name
                local hrp = getHRP(targetplayer.Character)
                PlayersPosition = getPredictedPosition(hrp)
                lookTargetPos = PlayersPosition
            else
                playersaimbot, PlayersPosition = nil, nil
            end
        end

        if currentTool and lookTargetPos and isSkillReadyForTool(currentTool.Name) and not isNotDoughValidCondition() then
	        local lookVector = (Vector3.new(lookTargetPos.X, lpHRP.Position.Y, lookTargetPos.Z) - lpHRP.Position).Unit
	            lpHRP.CFrame = CFrame.new(lpHRP.Position, lpHRP.Position + lookVector)
	    end
    end)
end

local function stopRenderLoop()
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
end

local function isValidCondition()
    return (currentTool and currentTool.Name == "Buddy Sword")
end

spawn(function()
    local ok, hookMeta = pcall(getrawmetatable, game)
    if ok and hookMeta then
        setreadonly(hookMeta, false)
        local OldHook
        OldHook = hookmetamethod(game, "__namecall", function(self, V1, V2, ...)
            local Method = (getnamecallmethod and getnamecallmethod():lower()) or ""

            if tostring(self) == "RemoteEvent" and Method == "fireserver" then
                if typeof(V1) == "Vector3" then
                    if SilentAimPlayersEnabled and PlayersPosition then
                        return OldHook(self, PlayersPosition, V2, ...)
                    end
				end				
				if type(V1) == "string" and table.find(Booms, V1) then
					if ZSkillorM1 then 
	                    if SilentAimPlayersEnabled and PlayersPosition then
	                        return OldHook(self, V1, PlayersPosition, nil, ...)
	                    end
					end
				end   
            elseif Method == "invokeserver" then  
	            if isValidCondition() then
	                if type(V1) == "string" and table.find(Skills, V1) then  
	                    if SilentAimPlayersEnabled and PlayersPosition then  
	                        return OldHook(self, V1, PlayersPosition, nil, ...)
	                    end  
	                end    
				end				
			end
            
            return OldHook(self, V1, V2, ...)
        end)
        setreadonly(hookMeta, true)
    end
end)

if not isNotValidCondition() then
	if MouseModule and typeof(MouseModule) == "Instance" then
        local ok2, okResult = pcall(function()
            return require(MouseModule)
        end)

        if ok2 and okResult then  
            if type(okResult) == "table" then  
                Mouse = okResult  
            else  
                Mouse = nil  
            end  
        else  
            Mouse = nil  
        end  

        RunService.Heartbeat:Connect(function()  	        
		    if not ZSkillorM1 or (not SilentAimPlayersEnabled) then
		        return
		    end
		
            if Mouse and ZSkillorM1 and SilentAimPlayersEnabled then  
                local targetCFrame = nil  

                if PlayersPosition then  
                    targetCFrame = CFrame.new(PlayersPosition)  
                end  

                if targetCFrame then  
                    pcall(function()  
                        if type(Mouse) == "table" then  
                            Mouse.Hit = targetCFrame  
                            Mouse.Target = nil  
                        end  
                    end)  

                    if MouseModule then  
                        local ok, MouseData = pcall(require, MouseModule)  
                        if ok and type(MouseData) == "table" then  
                            MouseData.Hit = targetCFrame  
                            MouseData.Target = nil  
                        end  
                    end  
                end  
            end  
        end)
    end
end

local function onCharacterAdded(char)
    clearConnections()

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            hookTool(child)
        end
    end

    table.insert(characterConnections, char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then hookTool(child) end
    end))

    table.insert(characterConnections, char.ChildRemoved:Connect(function(child)
        if child == currentTool then
            currentTool = nil
        end
    end))

    watchDamageCounter()
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

function SilentAimModule:SetZSkillorM1(state)
    ZSkillorM1 = state
end

function SilentAimModule:Pause()
	SilentAimPlayersEnabled = false
    stopRenderLoop()
end

function SilentAimModule:Restore()
	SilentAimPlayersEnabled = UserWantsplayerAim
    if UserWantsplayerAim then
        startRenderLoop()
    end
end

function SilentAimModule:IsplayerAimEnabled()
    return SilentAimPlayersEnabled
end

function SilentAimModule:SetDistanceLimit(num)
	if typeof(num) == "number" then
		maxRange = num
	end
end

function SilentAimModule:SetSelectedPlayer(playerName)
	if not playerName or playerName == "" then
		Selectedplayer = nil
		return
	end

	local found = Players:FindFirstChild(playerName)
	if found then
		Selectedplayer = found
	end
end

function SilentAimModule:GetSelectedPlayer()
	return Selectedplayer and Selectedplayer.Name or "None"
end

function SilentAimModule:SetPrediction(state)
	PredictionEnabled = state
end

function SilentAimModule:SetPredictionAmount(num)
	if typeof(num) == "number" then
		PredictionAmount = num
	end
end

function SilentAimModule:SetPlayerSilentAim(state)
    UserWantsplayerAim = state
    SilentAimPlayersEnabled = state

    if state then
        startRenderLoop()
    else
        stopRenderLoop()
    end
end

-- 使用上面的模块代码创建Aim变量
local Aim = SilentAimModule

-- 以下为UI界面代码
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleAimbotUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "Aimbot Skill"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.Text = "Aimbot: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 16
ToggleButton.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.8, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.1, 0, 0.7, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready to aim"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.Parent = Frame

local aimbotEnabled = false

ToggleButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    
    if aimbotEnabled then
        ToggleButton.Text = "Aimbot: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        StatusLabel.Text = "Aimbot開啟"
        
        if Aim and typeof(Aim.SetPlayerSilentAim) == "function" then
            pcall(function() 
                Aim:SetPlayerSilentAim(true)
            end)
        end
    else
        ToggleButton.Text = "Aimbot: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        StatusLabel.Text = "Aimbot關閉"
        
        if Aim and typeof(Aim.SetPlayerSilentAim) == "function" then
            pcall(function() 
                Aim:SetPlayerSilentAim(false)
            end)
        end
    end
end)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = Frame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    
    if Aim and typeof(Aim.SetPlayerSilentAim) == "function" then
        pcall(function() 
            Aim:SetPlayerSilentAim(false)
        end)
    end
end)

local antiAFKConnection
antiAFKConnection = game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
    end
    antiAFKConnection = game.Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

game:GetService("UserInputService").WindowFocused:Connect(function()
    if not aimbotEnabled and Aim and typeof(Aim.SetPlayerSilentAim) == "function" then
        pcall(function() 
            Aim:SetPlayerSilentAim(false)
        end)
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "Aimbot",
    Text = "載入成功！自瞄正常",
    Duration = 5,
})
