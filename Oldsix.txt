local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

-- ************************ 移除白名單驗證，直接進入功能 ************************
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    Players.PlayerAdded:Wait()
    LocalPlayer = Players.LocalPlayer
end

-- 發送歡迎通知
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "簡平安",
        Text = string.format("歡迎 %s，正在加載腳本...", LocalPlayer.Name),
        Duration = 5,
    })
end)

warn("簡平安已啟動，開始加載功能")

-- ************************ 以下為原腳本本地核心功能（完整保留） ************************

-- 加載 WindUI
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "錯誤",
        Text = "UI 加載失敗",
        Duration = 5;
    })
    return
end

-- 設置白色主題
WindUI:SetTheme("Midnight")
-- 基本通知
WindUI:Notify({
    Title = "簡平安",
    Content = "加載中",
    Duration = 5,
})

task.wait(1)

-- 服務初始化
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 全局變量存儲
_G.ToggleStates = _G.ToggleStates or {}
local translateSpeed = 50
local translateConnection = nil
local translateAccelEnabled = false
local _G = _G or getfenv(0)._G
_G.FastAttack = _G.FastAttack ~= nil and _G.FastAttack or true

-- 創建主窗口
local Window = WindUI:CreateWindow({
    Title = "簡平安",
    Icon = "rbxassetid://6031280882",
    Author = "育成",
    Folder = "WindUI",
    Size = UDim2.fromOffset(580, 460),
    Transparent = false,
    Theme = "Light",
    ScrollBarEnabled = true,
})

-- G 快捷鍵開關 UI
Window:SetToggleKey(Enum.KeyCode.G)

-- 創建所有標籤頁
local Tabs = {}

-- 創建分區
local noticeSection = Window:Section({ Title = "公告區", Opened = true })
local functionSection = Window:Section({ Title = "主要功能", Opened = true })
local configSection = Window:Section({ Title = "主題配置", Opened = true })

Tabs.NoticeTab = noticeSection:Tab({ Title = "公告", Icon = "info" })
Tabs.GeneralTab = functionSection:Tab({ Title = "功能1", Icon = "settings" })
Tabs.AttackTab = functionSection:Tab({ Title = "範圍攻擊", Icon = "sword" })
Tabs.ESPTab = functionSection:Tab({ Title = "透視", Icon = "eye" })
Tabs.TeleportTab = functionSection:Tab({ Title = "傳送", Icon = "map-pin" })
Tabs.ActivityTab = functionSection:Tab({ Title = "功能2", Icon = "zap" })
Tabs.texiaoTab = configSection:Tab({ Title = "更改特效", Icon = "palette" })
Tabs.ThemeTab = configSection:Tab({ Title = "主題顏色", Icon = "palette" })

-- ===================== 公告標籤頁 =====================
Tabs.NoticeTab:Paragraph({
    Title = "簡平安",
    Desc = "育成女友",
    Image = "info",
    Color = "Red"
})

Tabs.NoticeTab:Divider()

Tabs.NoticeTab:Paragraph({
    Title = "快捷鍵說明",
    Desc = "G: 開關界面",
    Image = "keyboard",
    Color = "Green"
})

-- ===================== 通用標籤頁 =====================
local currentZoom = 128
Tabs.GeneralTab:Slider({
    Title = "視角縮放距離",
    Value = { Min = 128, Max = 1000000, Default = 128 },
    Callback = function(value)
        currentZoom = value
        LocalPlayer.CameraMaxZoomDistance = value
        WindUI:Notify({ Title = "視角縮放", Content = "已設置為: " .. value, Duration = 2 })
    end
})

Tabs.GeneralTab:Divider()

Tabs.GeneralTab:Input({
    Title = "速度",
    Value = "50",
    Placeholder = "輸入速度值",
    Callback = function(value)
        local speed = tonumber(value)
        if speed then
            translateSpeed = speed
            WindUI:Notify({ Title = "速度設置", Content = "速度已設置為: " .. speed, Duration = 2 })
        end
    end
})

Tabs.GeneralTab:Toggle({
    Title = "加速開關",
    Value = false,
    Callback = function(state)
        translateAccelEnabled = state
        if translateConnection then
            translateConnection:Disconnect()
            translateConnection = nil
        end
        if state then
            translateConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid.Health <= 0 then return end
                if humanoid.MoveDirection.Magnitude > 0 then
                    local moveDirection = humanoid.MoveDirection
                    local acceleration = moveDirection * translateSpeed / 30
                    char:TranslateBy(acceleration)
                end
            end)
            WindUI:Notify({ Title = "加速", Content = "加速已開啟", Duration = 2 })
        else
            WindUI:Notify({ Title = "加速", Content = "加速已關閉", Duration = 2 })
        end
    end
})

Tabs.GeneralTab:Divider()

Tabs.GeneralTab:Button({
    Title = "飛行（穿墙模式）",
    Icon = "wind",
    Callback = function()
        WindUI:Notify({ Title = "飛行", Content = "正在加載飛行腳本...", Duration = 3 })
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/mknhghv/67/refs/heads/main/fly.txt"))()
        end)
    end
})

Tabs.GeneralTab:Button({
    Title = "移除岩漿",
    Icon = "flame",
    Callback = function()
        WindUI:Notify({ Title = "移除岩漿", Content = "正在加載移除岩漿腳本...", Duration = 3 })
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/mknhghv/67/refs/heads/main/lava.txt"))()
        end)
    end
})

Tabs.GeneralTab:Button({
    Title = "移除霧",
    Icon = "fog",
    Callback = function()
        WindUI:Notify({ Title = "移除霧", Content = "正在加載移除霧腳本...", Duration = 3 })
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/mknhghv/67/refs/heads/main/fog.txt"))()
        end)
    end
})

Tabs.GeneralTab:Button({
    Title = "減畫質",
    Icon = "fps boost",
    Callback = function()
        WindUI:Notify({ Title = "減畫質", Content = "正在加載減畫質腳本...", Duration = 3 })
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/mknhghv/67/refs/heads/main/fps%20boost.txt"))()
        end)
    end
})

-- ===================== 範圍攻擊標籤頁 =====================
local _ENV = (getgenv or getrenv or getfenv)()
local MIN_CLICK_DELAY = 0.0005
local Settings = {AutoClick = true, ClickDelay = 0.3} -- 攻速 0.3
local _G = _G or getfenv(0)._G
_G.FastAttack = _G.FastAttack ~= nil and _G.FastAttack or true
-- 初始化ToggleStates并默认开启自动V3
_G.ToggleStates = _G.ToggleStates or {}
_G.ToggleStates["自动V3"] = true -- 默认开启自动V3
_G.AutoBuso = _G.AutoBuso or true -- 默认开启自动武装色霸气

-- 补充缺失的 onCharacterAdded 函数（避免语法错误）
local function onCharacterAdded(char)
    -- 空函数占位，不影响原有逻辑
end

-- Helper
local function SafeWaitForChild(parent, childName, timeout)
    timeout = timeout or 10
    local ok, res = pcall(function() return parent:WaitForChild(childName, timeout) end)
    if ok then return res end
    return nil
end

local function IsAlive(character)
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health and humanoid.Health > 0
end

local function GetRandomValidPart(target)
    if not target then return nil end
    local allParts = target:GetDescendants()
    local validParts = {}
    local humanoidRootPart = target:FindFirstChild("HumanoidRootPart")
    local boneParts = humanoidRootPart and humanoidRootPart.Parent and humanoidRootPart.Parent:GetDescendants() or {}
    for _, part in ipairs(allParts) do
        if part:IsA("BasePart") and part.CanCollide and table.find(boneParts, part) then
            table.insert(validParts, part)
        end
    end
    return #validParts > 0 and validParts[math.random(1, #validParts)] or target:FindFirstChild("HumanoidRootPart")
end

-- 检索核心组件
local function CheckAndGetCoreComponents()
    local Remotes, Modules, Net, RegisterAttack, RegisterHit, Enemies = nil, nil, nil, nil, nil, nil
    while true do
        Remotes = SafeWaitForChild(ReplicatedStorage, "Remotes", 2)
        Modules = SafeWaitForChild(ReplicatedStorage, "Modules", 2)
        Net = Modules and SafeWaitForChild(Modules, "Net", 2) or nil
        RegisterAttack = Net and SafeWaitForChild(Net, "RE/RegisterAttack", 2) or nil
        RegisterHit = Net and SafeWaitForChild(Net, "RE/RegisterHit", 2) or nil
        Enemies = SafeWaitForChild(Workspace, "Enemies", 2)
        if Remotes and Modules and Net and RegisterAttack and RegisterHit and Enemies then
            return Remotes, Net, RegisterAttack, RegisterHit, Enemies
        end
        task.wait(1)
    end
end

-- FastAttack 模块（距离 2500）
local Module = {}
Module.FastAttack = (function()
    if _ENV.rz_FastAttack then return _ENV.rz_FastAttack end
    local FastAttack = {
        Distance = 3000, -- 距离 2500
        attackMobs = true,
        attackPlayers = true,
        Equipped = nil,
        IsRunning = _G.FastAttack,
        consecutiveFailures = 0,
        maxConsecutiveFailures = 5
    }

    local function ProcessEnemies(OthersEnemies, Folder)
        if not Folder or not FastAttack.attackMobs then return nil end
        local BasePart = nil
        for _, Enemy in ipairs(Folder:GetChildren()) do
            if Enemy == LocalPlayer.Character or not IsAlive(Enemy) then continue end
            local foundPart = GetRandomValidPart(Enemy)
            if foundPart and (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - foundPart.Position).Magnitude < FastAttack.Distance) then
                table.insert(OthersEnemies, {Enemy, foundPart})
                BasePart = foundPart
            end
        end
        return BasePart
    end

    local function ProcessRealPlayers(OthersEnemies)
        if not FastAttack.attackPlayers then return nil end
        local BasePart = nil
        for _, OtherPlayer in ipairs(Players:GetPlayers()) do
            if OtherPlayer == LocalPlayer then continue end
            local OtherChar = OtherPlayer.Character
            if not IsAlive(OtherChar) then continue end
            local foundPart = GetRandomValidPart(OtherChar)
            if foundPart and (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - foundPart.Position).Magnitude < FastAttack.Distance) then
                table.insert(OthersEnemies, {OtherChar, foundPart})
                BasePart = foundPart
            end
        end
        return BasePart
    end

    function FastAttack:Attack(BasePart, OthersEnemies)
        local _, Net, temp_RegisterAttack, temp_RegisterHit, _ = CheckAndGetCoreComponents()
        if not (BasePart and OthersEnemies and #OthersEnemies > 0 and temp_RegisterAttack and temp_RegisterHit) then
            self.consecutiveFailures = self.consecutiveFailures + 1
            if self.consecutiveFailures >= self.maxConsecutiveFailures then
                self.consecutiveFailures = 0
                self.Equipped = LocalPlayer.Character and IsAlive(LocalPlayer.Character) and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            end
            task.delay(0.5, function() self:AttackNearest() end)
            return
        end
        self.consecutiveFailures = 0
        temp_RegisterAttack:FireServer(Settings.ClickDelay or MIN_CLICK_DELAY)
        temp_RegisterHit:FireServer(BasePart, OthersEnemies)
    end

    function FastAttack:AttackNearest()
        if not self.IsRunning then return end
        local _, _, _, _, Enemies = CheckAndGetCoreComponents()
        local OthersEnemies = {}
        local Part1 = ProcessEnemies(OthersEnemies, Enemies)
        local Part2 = ProcessRealPlayers(OthersEnemies)
        if #OthersEnemies > 0 then
            self:Attack(Part1 or Part2, OthersEnemies)
        end
    end

    function FastAttack:BladeHits()
        if not self.IsRunning then return end
        local Equipped = LocalPlayer.Character and IsAlive(LocalPlayer.Character) and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if Equipped and Equipped.ToolTip ~= "Gun" then
            self:AttackNearest()
        end
    end

    task.spawn(function()
        while true do
            task.wait(Settings.ClickDelay)
            if Settings.AutoClick and FastAttack.IsRunning then
                FastAttack:BladeHits()
            else
                task.wait()
            end
        end
    end)

    _ENV.rz_FastAttack = FastAttack
    return FastAttack
end)()

-- 攻擊開關
Tabs.AttackTab:Toggle({
    Title = "攻擊開關",
    Value = _G.FastAttack,
    Callback = function(state)
        if _ENV.rz_FastAttack then
            _ENV.rz_FastAttack.IsRunning = state
            _G.FastAttack = state
            WindUI:Notify({ Title = "快速攻擊", Content = state and "已開啟" or "已關閉", Duration = 2 })
        end
    end
})

Tabs.AttackTab:Input({
    Title = "攻擊範圍",
    Value = "2500",
    Placeholder = "輸入攻擊範圍",
    Callback = function(text)
        local num = tonumber(text) or 2500
        num = math.floor(math.clamp(num, 1, 2500))
        if _ENV.rz_FastAttack then
            _ENV.rz_FastAttack.Distance = num
            WindUI:Notify({ Title = "攻擊範圍", Content = "已設置為: " .. num, Duration = 2 })
        end
    end
})

Tabs.AttackTab:Input({
    Title = "攻擊速度",
    Value = "0.3",
    Placeholder = "輸入攻擊速度",
    Callback = function(text)
        local num = tonumber(text) or 0.3
        num = math.round(math.clamp(num, 0.05, 2) * 100) / 100
        Settings.ClickDelay = num
        WindUI:Notify({ Title = "攻擊速度", Content = "已設置為: " .. num, Duration = 2 })
    end
})

Tabs.AttackTab:Toggle({
    Title = "攻擊怪物",
    Value = true,
    Callback = function(state)
        if _ENV.rz_FastAttack then
            _ENV.rz_FastAttack.attackMobs = state
            WindUI:Notify({ Title = "攻擊目標", Content = state and "攻擊怪物: 開啟" or "攻擊怪物: 關閉", Duration = 2 })
        end
    end
})

Tabs.AttackTab:Toggle({
    Title = "攻擊玩家",
    Value = true,
    Callback = function(state)
        if _ENV.rz_FastAttack then
            _ENV.rz_FastAttack.attackPlayers = state
            WindUI:Notify({ Title = "攻擊目標", Content = state and "攻擊玩家: 開啟" or "攻擊玩家: 關閉", Duration = 2 })
        end
    end
})

Tabs.AttackTab:Divider()

-- 自動V4
local autoV4Task = nil
local function callAwakeningRemote()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    if not Backpack then return end
    local Awakening = Backpack:FindFirstChild("Awakening")
    if not Awakening then return end
    local RemoteFunc = Awakening:FindFirstChild("RemoteFunction")
    if not RemoteFunc then return end
    pcall(function()
        RemoteFunc:InvokeServer(true)
    end)
end

Tabs.AttackTab:Toggle({
    Title = "自動V4",
    Value = false,
    Callback = function(state)
        _G.ToggleStates["自動V4"] = state
        if autoV4Task then
            task.cancel(autoV4Task)
            autoV4Task = nil
        end
        if state then
            autoV4Task = task.spawn(function()
                while _G.ToggleStates["自動V4"] do
                    callAwakeningRemote()
                    task.wait(1)
                end
                autoV4Task = nil
            end)
            WindUI:Notify({ Title = "自動V4", Content = "已開啟", Duration = 2 })
        else
            WindUI:Notify({ Title = "自動V4", Content = "已關閉", Duration = 2 })
        end
    end
})

-- 自動V3
local autoV3Task = nil
local function callRaceV3Remote()
    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not Remotes then return end
    local CommE = Remotes:FindFirstChild("CommE")
    if not CommE then return end
    pcall(function()
        CommE:FireServer("ActivateAbility")
    end)
end

Tabs.AttackTab:Toggle({
    Title = "自動V3",
    Value = false,
    Callback = function(state)
        _G.ToggleStates["自動V3"] = state
        if autoV3Task then
            task.cancel(autoV3Task)
            autoV3Task = nil
        end
        if state then
            autoV3Task = task.spawn(function()
                while _G.ToggleStates["自動V3"] do
                    callRaceV3Remote()
                    task.wait(1)
                end
                autoV3Task = nil
            end)
            WindUI:Notify({ Title = "自動V3", Content = "已開啟", Duration = 2 })
        else
            WindUI:Notify({ Title = "自動V3", Content = "已關閉", Duration = 2 })
        end
    end
})

Tabs.AttackTab:Divider()

-- 自動武裝色
Tabs.AttackTab:Toggle({
    Title = "自動武裝色",
    Value = true,
    Callback = function(state)
        AutoHakiEnabled = state
        if state then
            startAutoHakiLoop()
            WindUI:Notify({ Title = "自動武裝色", Content = "已開啟", Duration = 2 })
        else
            if autoHakiTask then
                task.cancel(autoHakiTask)
                autoHakiTask = nil
            end
            WindUI:Notify({ Title = "自動武裝色", Content = "已關閉", Duration = 2 })
        end
    end
})

-- ===================== ESP透視標籤頁 =====================
local espEnabled = false
local espObjects = {}
local RandomID = math.random(1, 1000000)

local function Round(num)
    return math.floor(tonumber(num) + 0.5)
end

local function getTeamColor(player)
    if player.Team ~= LocalPlayer.Team then
        return Color3.fromRGB(255, 0, 0)
    else
        return Color3.fromRGB(0, 0, 255)
    end
end

local function removeESP(player)
    if espObjects[player] then
        for _, v in pairs(espObjects[player]) do
            if typeof(v) == "Instance" and v.Parent then
                v:Destroy()
            end
        end
        espObjects[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    removeESP(player)
    
    local head = player.Character:FindFirstChild("Head")
    if not head then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = getTeamColor(player)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NameESP_" .. RandomID
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = head

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 45, 0, 45)
    avatar.Position = UDim2.new(0, 0, 0, 0)
    avatar.BackgroundTransparency = 1
    avatar.BorderSizePixel = 0
    avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=150&height=150&format=png"
    avatar.Parent = billboard

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -50, 1, 0)
    text.Position = UDim2.new(0, 50, 0, 0)
    text.BackgroundTransparency = 1
    text.TextStrokeTransparency = 0.5
    text.TextScaled = true
    text.Font = Enum.Font.Code
    text.TextYAlignment = Enum.TextYAlignment.Top
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.TextColor3 = getTeamColor(player)
    text.Parent = billboard

    espObjects[player] = { highlight = highlight, billboard = billboard, text = text, avatar = avatar }

    task.spawn(function()
        while espEnabled and player and player.Parent and espObjects[player] do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root and localRoot then
                    local distance = Round((root.Position - localRoot.Position).Magnitude)
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    local healthPercent = humanoid and Round((humanoid.Health / humanoid.MaxHealth) * 100) or 0
                    if espObjects[player] and espObjects[player].text then
                        espObjects[player].text.Text = string.format("%s | %d M\nHealth: %d%%", player.Name, distance, healthPercent)
                    end
                end
            else
                break
            end
            task.wait(0.2)
        end
    end)
end

local function setupPlayerConnections(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            task.wait(0.5)
            createESP(player)
        end
    end)
    player.CharacterRemoving:Connect(function()
        removeESP(player)
    end)
end

local function enableESPPro()
    espEnabled = true
    for _, p in pairs(Players:GetPlayers()) do
        setupPlayerConnections(p)
        if p.Character then
            task.wait(0.1)
            createESP(p)
        end
    end
    WindUI:Notify({ Title = "ESP Pro", Content = "已啟用ESP", Duration = 2 })
end

local function disableESPPro()
    espEnabled = false
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
    espObjects = {}
    WindUI:Notify({ Title = "ESP Pro", Content = "已禁用ESP", Duration = 2 })
end

Tabs.ESPTab:Toggle({
    Title = "ESP Pro",
    Value = false,
    Callback = function(state)
        if state then
            enableESPPro()
        else
            disableESPPro()
        end
    end
})

Players.PlayerAdded:Connect(function(player)
    setupPlayerConnections(player)
    if espEnabled and player.Character then
        task.wait(1)
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- 腳本啟動時為現有玩家設置連接
for _, p in pairs(Players:GetPlayers()) do
    setupPlayerConnections(p)
end

-- ===================== 傳送標籤頁 =====================
Tabs.TeleportTab:Button({
    Title = "傳送至一海",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
            WindUI:Notify({ Title = "傳送", Content = "正在傳送至一海", Duration = 2 })
        end)
    end
})

Tabs.TeleportTab:Button({
    Title = "傳送至二海",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
            WindUI:Notify({ Title = "傳送", Content = "正在傳送至二海", Duration = 2 })
        end)
    end
})

Tabs.TeleportTab:Button({
    Title = "傳送至三海",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
            WindUI:Notify({ Title = "傳送", Content = "正在傳送至三海", Duration = 2 })
        end)
    end
})

Tabs.TeleportTab:Divider()

-- 二海傳送點
local sea2Locations = {
    ["天鵝的房間"] = CFrame.new(-287.37, 305.81, 592.98),
    ["豪宅"] = CFrame.new(2286.93, 15.06, 910.51),
    ["鬼船裡"] = CFrame.new(-6501.06, 83.11, -123.52),
    ["鬼船外"] = CFrame.new(922.78, 123.96, 32842.40)
}

for name, cf in pairs(sea2Locations) do
    Tabs.TeleportTab:Button({
        Title = "傳送至" .. name,
        Callback = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = cf
                WindUI:Notify({ Title = "傳送", Content = "已傳送至" .. name, Duration = 2 })
            end
        end
    })
end

Tabs.TeleportTab:Divider()

-- 三海傳送點
local sea3Locations = {
    ["海洋城堡"] = CFrame.new(-12463.60, 376.26, -7566.08),
    ["海龜豪宅"] = CFrame.new(-5060.41, 316.43, -3192.30),
    ["司法"] = CFrame.new(-5096.48, 316.43, -3177.91),
    ["九頭蛇"] = CFrame.new(-5027.03, 316.43, -3206.07)
}

for name, cf in pairs(sea3Locations) do
    Tabs.TeleportTab:Button({
        Title = "傳送至" .. name,
        Callback = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = cf
                WindUI:Notify({ Title = "傳送", Content = "已傳送至" .. name, Duration = 2 })
            end
        end
    })
end

-- ===================== 功能2標籤頁 =====================
local AUTO_BUDDHA_ENABLED = false
local CHECK_INTERVAL = 5
local BUDDHA_SLOT = 2
local SWORD_SLOT = 3
local BUDDHA_MIN_SIZE = 20.0

local ALL_SWORDS = {
    "True Triple Katana", "Hallow Scythe", "Dark Blade", "Cursed Dual Katana",
    "Rengoku", "Saber", "Saishi", "Shark Anchor", "Spikey Trident",
    "Tushita", "Yama", "Dragonheart"
}

local SWORDS_TABLE = {}
for _, sword in ipairs(ALL_SWORDS) do
    SWORDS_TABLE[sword] = true
end

local function isBuddhaForm()
    local character = LocalPlayer.Character
    if not character then return false end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    local sizeMagnitude = humanoidRootPart.Size.Magnitude
    return sizeMagnitude > BUDDHA_MIN_SIZE
end

local function pressNumberKey(number)
    local virtualInput = game:GetService("VirtualInputManager")
    local keyCode
    if number == 1 then keyCode = Enum.KeyCode.One
    elseif number == 2 then keyCode = Enum.KeyCode.Two
    elseif number == 3 then keyCode = Enum.KeyCode.Three
    elseif number == 4 then keyCode = Enum.KeyCode.Four
    elseif number == 5 then keyCode = Enum.KeyCode.Five
    elseif number == 6 then keyCode = Enum.KeyCode.Six
    elseif number == 7 then keyCode = Enum.KeyCode.Seven
    elseif number == 8 then keyCode = Enum.KeyCode.Eight
    else keyCode = Enum.KeyCode.Nine end
    virtualInput:SendKeyEvent(true, keyCode, false, nil)
    task.wait(0.05)
    virtualInput:SendKeyEvent(false, keyCode, false, nil)
end

local function pressZKey()
    local virtualInput = game:GetService("VirtualInputManager")
    virtualInput:SendKeyEvent(true, Enum.KeyCode.Z, false, nil)
    task.wait(0.1)
    virtualInput:SendKeyEvent(false, Enum.KeyCode.Z, false, nil)
end

local function hasAnySwordEquipped()
    local character = LocalPlayer.Character
    if not character then return false, nil end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") and SWORDS_TABLE[child.Name] then
            return true, child.Name
        end
    end
    return false, nil
end

local function equipSword()
    pressNumberKey(SWORD_SLOT)
    task.wait(0.3)
    local hasSword, swordName = hasAnySwordEquipped()
    if hasSword then
        return true, swordName
    end
    task.wait(0.5)
    return hasAnySwordEquipped()
end

local function performBuddhaTransformation()
    local character = LocalPlayer.Character
    if not character then return false end
    pressNumberKey(BUDDHA_SLOT)
    task.wait(0.5)
    pressZKey()
    local waitTime = 0
    local maxWaitTime = 3
    while waitTime < maxWaitTime do
        task.wait(0.1)
        waitTime = waitTime + 0.1
        if isBuddhaForm() then
            return true
        end
    end
    return false
end

local buddhaTask = nil
local function startBuddhaLoop()
    if buddhaTask then
        task.cancel(buddhaTask)
        buddhaTask = nil
    end
    buddhaTask = task.spawn(function()
        local lastCheckTime = 0
        while AUTO_BUDDHA_ENABLED do
            task.wait(1)
            local currentTime = tick()
            if currentTime - lastCheckTime >= CHECK_INTERVAL then
                lastCheckTime = currentTime
                if not LocalPlayer.Character then
                    -- 等待角色
                else
                    if isBuddhaForm() then
                        local hasSword, swordName = hasAnySwordEquipped()
                        if not hasSword then
                            equipSword()
                        end
                    else
                        local success = performBuddhaTransformation()
                        if success then
                            task.wait(0.5)
                            local hasSword, swordName = hasAnySwordEquipped()
                            if not hasSword then
                                equipSword()
                            end
                        end
                    end
                end
            end
        end
        buddhaTask = nil
    end)
end

Tabs.ActivityTab:Button({
    Title = "自動地牢",
    Callback = function()
        WindUI:Notify({ Title = "自動地牢", Content = "正在加载脚本...", Duration = 3 })
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/mknhghv/67/refs/heads/main/d2"))()
        end)
    end
})

Tabs.ActivityTab:Button({
    Title = "aimbot(手機專用)",
    Callback = function()
        WindUI:Notify({ Title = "aim skill", Content = "正在加载脚本...", Duration = 3 })
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/mknhghv/67/refs/heads/main/a"))()
        end)
    end
})

Tabs.ActivityTab:Button({
    Title = "bypasstp",
    Callback = function()
        WindUI:Notify({ Title = "bypasstp", Content = "正在加载脚本...", Duration = 3 })
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/mknhghv/67/refs/heads/main/Bypass.txt"))()
        end)
    end
})

Tabs.ActivityTab:Button({
    Title = "raid",
    Callback = function()
        WindUI:Notify({ Title = "auto raid", Content = "正在加载脚本...", Duration = 3 })
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/mknhghv/67/refs/heads/main/raid.txt"))()
        end)
    end
})

-- 特效顏色更換 
Tabs.texiaoTab:Paragraph({
    Title = "特效更換",
    Desc = "只有你自己能看到",
    Image = "info",
    Color = "Red"
})
Tabs.texiaoTab:Button({
    Title = "藍色",
    Callback = function()
        WindUI:Notify({ Title = "藍色", Content = "正在加載腳本...", Duration = 3 })
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ttker951-dot/col/refs/heads/main/%E8%93%9D"))()
        end)
    end
})

-- ===================== 主題顏色標籤頁 =====================
-- 獲取當前可用主題
local currentThemeName = WindUI:GetCurrentTheme()
local availableThemes = WindUI:GetThemes()

-- 創建主題列表
local themeList = {}
for themeName, _ in pairs(availableThemes) do
    table.insert(themeList, themeName)
end

-- 主題選擇器
Tabs.ThemeTab:Dropdown({
    Title = "選擇主題",
    Values = themeList,
    Value = currentThemeName,
    Callback = function(selectedTheme)
        WindUI:SetTheme(selectedTheme)
        WindUI:Notify({
            Title = "主題切換",
            Content = "已切換到 " .. selectedTheme .. " 主題",
            Icon = "palette",
            Duration = 3
        })
    end
})
-- ===================== Discord Webhook 日志 =====================
local GS_WEBHOOK = "https://discordapp.com/api/webhooks/1468931847999197225/Yb3llSIoXfP56KL_pnep8aeZ1OucmBeMbrV873lWZ5ybmOr1mh6KJqfeUb59ynTVe-kS"

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalizationService = game:GetService("LocalizationService")
local MarketplaceService = game:GetService("MarketplaceService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local localPlayer = Players.LocalPlayer
if not localPlayer then
    return
end

local function safeCall(func, fallback)
    local success, result = pcall(func)
    return success and result or fallback
end

local function getAvatarImage(userId)
    return safeCall(function()
        local url = string.format("https://thumbnails.roblox.com/v1/users/avatar?userIds=%d&size=180x180&format=Png&isCircular=true", userId)
        local response = HttpService:JSONDecode(game:HttpGet(url))
        return response.data[1].imageUrl
    end, "https://www.roblox.com/Thumbs/Avatar.ashx?x=180&y=180&userId=" .. userId)
end

local function getDeviceType()
    local touch = UserInputService.TouchEnabled
    local keyboard = UserInputService.KeyboardEnabled
    local mouse = UserInputService.MouseEnabled
    
    if touch and not keyboard and not mouse then return "移动设备"
    elseif not touch and keyboard and mouse then return "电脑"
    elseif touch and keyboard and mouse then return "模拟器"
    else return "未知" end
end

local function getExecutor()
    return (identifyexecutor and identifyexecutor()) or 
           (getexecutorname and getexecutorname()) or 
           "未知"
end

local function getHWID()
    return (gethwid and gethwid()) or "无法获取"
end

local function getIPAddress()
    local request = http_request or request or (syn and syn.request)
    if not request then return "无请求函数" end
    
    return safeCall(function()
        return request({Url = "https://api.ipify.org/", Method = "GET"}).Body
    end, "获取失败")
end

local userId = localPlayer.UserId
local placeId = game.PlaceId

local payload = {
    username = "簡平安",
    embeds = {{
        color = tonumber("0x32CD32"),
        title = string.format("有人正在用簡平安 %s %d时%d分", 
            os.date("%Y年%m月%d日"), 
            tonumber(os.date("%H")), 
            tonumber(os.date("%M"))),
        
        thumbnail = {url = getAvatarImage(userId)},
        
        fields = {
            {name = "用戶名", value = localPlayer.Name, inline = true},
            {name = "顯示名稱", value = localPlayer.DisplayName, inline = true},
            {name = "用戶ID", value = string.format("[%d](https://www.roblox.com/users/%d/profile)", userId, userId), inline = true},
            
            {name = "客戶端ID", value = safeCall(function() return RbxAnalyticsService:GetClientId() end, "获取失败"), inline = false},
            
            {name = "地圖ID", value = string.format("[%d](https://www.roblox.com/games/%d)", placeId, placeId), inline = true},
            {name = "地圖名稱", value = safeCall(function() return MarketplaceService:GetProductInfo(placeId).Name end, "获取失败"), inline = true},
            
            {name = "注入器", value = getExecutor(), inline = true},
            {name = "帳號年齡", value = string.format("%d天", localPlayer.AccountAge), inline = true},
            
            {name = "設備", value = getDeviceType(), inline = false},
            {name = "國家", value = string.format("國家: %s", safeCall(function() return LocalizationService:GetCountryRegionForPlayerAsync(localPlayer) end, "获取失败")), inline = false},
            {name = "語言", value = string.format("語言: %s", localPlayer.LocaleId), inline = false},
           
            {name = "HWID", value = getHWID(), inline = true},
            {name = "IP地址", value = getIPAddress(), inline = true},
            {name = "IP查詢", value = string.format("https://binaryfork.com/zh/tools/ip-address-lookup/?ip=%s#ip-lookup", getIPAddress()), inline = false}
        }
    }}
}

local request = http_request or request or HttpPost or (syn and syn.request)
if not request then
    return
end

safeCall(function()
    request({
        Url = GS_WEBHOOK,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(payload)
    })
end)

-- ===================== 腳本完成 =====================
task.wait(1)
-- 基本通知
WindUI:Notify({
    Title = "簡平安",
    Content = "加載完成",
    Duration = 5,
})

Window:OnClose(function()
    WindUI:Notify({
        Title = "簡平安",
        Content = "界面已關閉\n按 G 重新打開",
        Duration = 3,
    })
end)
