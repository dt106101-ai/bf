local P=game:GetService("Players")
local R=game:GetService("RunService")
local U=game:GetService("UserInputService")
local m=Instance.new("ScreenGui")
local f=Instance.new("Frame")
local u=Instance.new("TextButton")
local d=Instance.new("TextButton")
local o=Instance.new("TextButton")
local t=Instance.new("TextLabel")
local p=Instance.new("TextButton")
local s=Instance.new("TextBox")
local n=Instance.new("TextButton")
local c=Instance.new("TextButton")
local h=Instance.new("TextButton")
local h2=Instance.new("TextButton")
local nc=Instance.new("TextButton")
m.Name="main"
m.Parent=P.LocalPlayer:WaitForChild("PlayerGui")
m.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
m.ResetOnSpawn=false
f.Parent=m
f.BackgroundColor3=Color3.fromRGB(163,255,137)
f.BorderColor3=Color3.fromRGB(103,221,213)
f.Position=UDim2.new(0.100320168,0,0.379746825,0)
f.Size=UDim2.new(0,190,0,57)
f.Active=true
f.Draggable=true

local function b(x,y,z,q)
x.Name=y
x.Parent=f
x.Position=z
x.Size=q
x.Font=Enum.Font.SourceSans
x.Text=y
x.TextColor3=Color3.fromRGB(0,0,0)
x.TextSize=14
x.TextScaled=true
x.TextWrapped=true end

b(u,"↑",UDim2.new(0,0,0,0),UDim2.new(0,44,0,28))
u.BackgroundColor3=Color3.fromRGB(79,255,152)

b(d,"↓",UDim2.new(0,0,0.491228074,0),UDim2.new(0,44,0,28))
d.BackgroundColor3=Color3.fromRGB(215,255,121)

o.Name="onoff"
o.Parent=f
o.BackgroundColor3=Color3.fromRGB(255,249,74)
o.Position=UDim2.new(0.702823281,0,0.491228074,0)
o.Size=UDim2.new(0,56,0,28)
o.Font=Enum.Font.SourceSans
o.Text="开始"
o.TextColor3=Color3.fromRGB(0,0,0)
o.TextScaled=true
o.TextSize=14
o.TextWrapped=true

p.Name="plus"
p.Parent=f
p.BackgroundColor3=Color3.fromRGB(133,145,255)
p.Position=UDim2.new(0.231578946,0,0,0)
p.Size=UDim2.new(0,45,0,28)
p.Font=Enum.Font.SourceSans
p.Text="+1"
p.TextColor3=Color3.fromRGB(0,0,0)
p.TextScaled=true
p.TextSize=14
p.TextWrapped=true

n.Name="mine"
n.Parent=f
n.BackgroundColor3=Color3.fromRGB(123,255,247)
n.Position=UDim2.new(0.231578946,0,0.491228074,0)
n.Size=UDim2.new(0,45,0,29)
n.Font=Enum.Font.SourceSans
n.Text="-1"
n.TextColor3=Color3.fromRGB(0,0,0)
n.TextScaled=true
n.TextSize=14
n.TextWrapped=true

nc.Name="NoClip"
nc.Parent=f
nc.BackgroundColor3=Color3.fromRGB(255,120,60)
nc.Position=UDim2.new(0,89,-1,27)
nc.Size=UDim2.new(0,45,0,28)
nc.Font=Enum.Font.SourceSans
nc.Text="穿墙模式"
nc.TextColor3=Color3.fromRGB(0,0,0)
nc.TextScaled=true
nc.TextSize=14
nc.TextWrapped=true

t.Parent=f
t.BackgroundColor3=Color3.fromRGB(242,60,255)
t.Position=UDim2.new(0.469327301,0,0,0)
t.Size=UDim2.new(0,100,0,28)
t.Font=Enum.Font.SourceSans
t.Text="糖轩飞行"
t.TextColor3=Color3.fromRGB(0,0,0)
t.TextScaled=true
t.TextSize=14
t.TextWrapped=true

s.Parent=f
s.Name="speed"
s.BackgroundColor3=Color3.fromRGB(255,85,0)
s.Position=UDim2.new(0.468421042,0,0.491228074,0)
s.Size=UDim2.new(0,44,0,28)
s.Font=Enum.Font.SourceSans
s.Text="1"
s.TextColor3=Color3.fromRGB(0,0,0)
s.TextScaled=true
s.TextSize=14
s.TextWrapped=true
s.ClearTextOnFocus=false
s.TextEditable=true
s.PlaceholderText="1-150"

c.Name="Close"
c.Parent=f
c.BackgroundColor3=Color3.fromRGB(225,25,0)
c.Font=Enum.Font.SourceSans
c.Size=UDim2.new(0,45,0,28)
c.Text="关闭"
c.TextSize=30
c.Position=UDim2.new(0,0,-1,27)

h.Name="minimize"
h.Parent=f
h.BackgroundColor3=Color3.fromRGB(192,150,230)
h.Font=Enum.Font.SourceSans
h.Size=UDim2.new(0,45,0,28)
h.Text="隐藏"
h.TextSize=30
h.Position=UDim2.new(0,44,-1,27)

h2.Name="minimize2"
h2.Parent=f
h2.BackgroundColor3=Color3.fromRGB(192,150,230)
h2.Font=Enum.Font.SourceSans
h2.Size=UDim2.new(0,45,0,28)
h2.Text="显示"
h2.TextSize=30
h2.Position=UDim2.new(0,44,-1,57)
h2.Visible=false

local F={}
F.__index=F
function F.new()
local self=setmetatable({},F)
self.v=1
self.f=false
self.u=false
self.d=false
self.n=false
self.c={}
self.l=nil
self.w={}
self.m=nil
self.nc=nil
self.nl=nil
self.p={}
self.a=nil
self.pl=P.LocalPlayer
self.ch=nil
self.h=nil
self.r=nil
self.i=nil
self:e()
return self end
function F:e()
self:uC()
local x=self.pl.CharacterAdded:Connect(function()
task.wait(0.1)
self:uC()
self:sF()
if self.ch then
local a=self.ch:FindFirstChild("Animate")
if a then a.Disabled=false end end
if self.h then
self.h.PlatformStand=false
self.h:ResetState() end
if self.n then
task.wait(0.2)
self:aN() end end)
table.insert(self.c,x) end
function F:uC()
self.ch=self.pl.Character
if self.ch then
self.h=self.ch:FindFirstChildWhichIsA("Humanoid")
self.r=self.ch:FindFirstChild("HumanoidRootPart") end end
function F:cl()
for _,x in ipairs(self.c) do if x then x:Disconnect() end end
self.c={}
self:sA()
self:clP()
self:sI()
self:sN() end
function F:sA()
if self.l then self.l:Disconnect() self.l=nil end
if self.m then self.m:Disconnect() self.m=nil end
for _,x in ipairs(self.w) do if x then x:Disconnect() end end
self.w={} end
function F:clP()
for _,x in ipairs(self.p) do if x and (x:IsA("BodyGyro") or x:IsA("BodyVelocity")) then x:Destroy() end end
self.p={} end
function F:pI()
if not self.h then return end
self:sI()
local a=Instance.new("Animation")
a.AnimationId="rbxassetid://507766666"
self.i=self.h:LoadAnimation(a)
if self.i then
self.i:Play()
self.i.Looped=true
self.i.Priority=Enum.AnimationPriority.Idle end end
function F:sI()
if self.i then self.i:Stop() self.i=nil end end
function F:aN()
if not self.ch then return end
self:sN()
for _,x in ipairs(self.ch:GetDescendants()) do
if x:IsA("BasePart") then
x.CanCollide=false
x.CollisionGroup="NoCollision" end end
self.nc=self.ch.DescendantAdded:Connect(function(x)
if x:IsA("BasePart") then
x.CanCollide=false
x.CollisionGroup="NoCollision" end end)
self.nl=R.Heartbeat:Connect(function()
if not self.ch or not self.n then return end
for _,x in ipairs(self.ch:GetDescendants()) do
if x:IsA("BasePart") then x.CanCollide=false end end end) end
function F:rN()
if not self.ch then return end
if self.nc then self.nc:Disconnect() self.nc=nil end
if self.nl then self.nl:Disconnect() self.nl=nil end
for _,x in ipairs(self.ch:GetDescendants()) do
if x:IsA("BasePart") then
x.CanCollide=true
x.CollisionGroup="Default" end end end
function F:sN()
if self.nc then self.nc:Disconnect() self.nc=nil end
if self.nl then self.nl:Disconnect() self.nl=nil end end
function F:dH()
if not self.h then return end
local s={
Enum.HumanoidStateType.Climbing,
Enum.HumanoidStateType.FallingDown,
Enum.HumanoidStateType.Flying,
Enum.HumanoidStateType.Freefall,
Enum.HumanoidStateType.GettingUp,
Enum.HumanoidStateType.Jumping,
Enum.HumanoidStateType.Landed,
Enum.HumanoidStateType.Physics,
Enum.HumanoidStateType.PlatformStanding,
Enum.HumanoidStateType.Ragdoll,
Enum.HumanoidStateType.Running,
Enum.HumanoidStateType.RunningNoPhysics,
Enum.HumanoidStateType.Seated,
Enum.HumanoidStateType.StrafingNoPhysics,
Enum.HumanoidStateType.Swimming}
for _,x in ipairs(s) do self.h:SetStateEnabled(x,false) end
self.h:ChangeState(Enum.HumanoidStateType.Swimming) end
function F:eH()
if not self.h then return end
local s={
Enum.HumanoidStateType.Climbing,
Enum.HumanoidStateType.FallingDown,
Enum.HumanoidStateType.Flying,
Enum.HumanoidStateType.Freefall,
Enum.HumanoidStateType.GettingUp,
Enum.HumanoidStateType.Jumping,
Enum.HumanoidStateType.Landed,
Enum.HumanoidStateType.Physics,
Enum.HumanoidStateType.PlatformStanding,
Enum.HumanoidStateType.Ragdoll,
Enum.HumanoidStateType.Running,
Enum.HumanoidStateType.RunningNoPhysics,
Enum.HumanoidStateType.Seated,
Enum.HumanoidStateType.StrafingNoPhysics,
Enum.HumanoidStateType.Swimming}
for _,x in ipairs(s) do self.h:SetStateEnabled(x,true) end
self.h:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end
function F:sW()
self:sW2()
for i=1,self.v do
local x=R.Heartbeat:Connect(function()
if not self.ch or not self.h then return end
local m=self.h.MoveDirection
if m.Magnitude>0 then self.ch:TranslateBy(m) end end)
table.insert(self.w,x) end end
function F:sW2()
for _,x in ipairs(self.w) do if x then x:Disconnect() end end
self.w={} end
function F:sR6()
if not self.ch then return end
local t=self.ch:FindFirstChild("Torso")
if not t then return end
local g=t:FindFirstChildWhichIsA("BodyGyro")
local v=t:FindFirstChildWhichIsA("BodyVelocity")
if g then g:Destroy() end
if v then v:Destroy() end
local g=Instance.new("BodyGyro")
g.P=9e4
g.maxTorque=Vector3.new(9e9,9e9,9e9)
g.cframe=t.CFrame
g.Parent=t
table.insert(self.p,g)
local v=Instance.new("BodyVelocity")
v.velocity=Vector3.new(0,0.1,0)
v.maxForce=Vector3.new(9e9,9e9,9e9)
v.Parent=t
table.insert(self.p,v)
if self.f then self.h.PlatformStand=true end
local c={f=0,b=0,l=0,r=0}
local l={f=0,b=0,l=0,r=0}
local m=50
local cs=0
self.l=R.RenderStepped:Connect(function()
if not self.f or not self.h or self.h.Health<=0 then self.l:Disconnect() return end
local i=self:gI()
c=i
if c.l+c.r~=0 or c.f+c.b~=0 then
cs=cs+0.5+(cs/m)
if cs>m then cs=m end
elseif not (c.l+c.r~=0 or c.f+c.b~=0) and cs~=0 then
cs=cs-1
if cs<0 then cs=0 end end
if (c.l+c.r)~=0 or (c.f+c.b)~=0 then
v.velocity=self:cV(c,cs)
l={f=c.f,b=c.b,l=c.l,r=c.r}
elseif (c.l+c.r)==0 and (c.f+c.b)==0 and cs~=0 then
v.velocity=self:cV(l,cs)
else v.velocity=Vector3.new(0,0,0) end
g.cframe=workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad((c.f+c.b)*50*cs/m),0,0) end) end
function F:sR15()
if not self.ch then return end
local t=self.ch:FindFirstChild("UpperTorso")
if not t then return end
local g=t:FindFirstChildWhichIsA("BodyGyro")
local v=t:FindFirstChildWhichIsA("BodyVelocity")
if g then g:Destroy() end
if v then v:Destroy() end
local g=Instance.new("BodyGyro")
g.P=9e4
g.maxTorque=Vector3.new(9e9,9e9,9e9)
g.cframe=t.CFrame
g.Parent=t
table.insert(self.p,g)
local v=Instance.new("BodyVelocity")
v.velocity=Vector3.new(0,0.1,0)
v.maxForce=Vector3.new(9e9,9e9,9e9)
v.Parent=t
table.insert(self.p,v)
if self.f then self.h.PlatformStand=true end
local c={f=0,b=0,l=0,r=0}
local l={f=0,b=0,l=0,r=0}
local m=50
local cs=0
self.l=R.Heartbeat:Connect(function()
if not self.f or not self.h or self.h.Health<=0 then self.l:Disconnect() return end
local i=self:gI()
c=i
if c.l+c.r~=0 or c.f+c.b~=0 then
cs=cs+0.5+(cs/m)
if cs>m then cs=m end
elseif not (c.l+c.r~=0 or c.f+c.b~=0) and cs~=0 then
cs=cs-1
if cs<0 then cs=0 end end
if (c.l+c.r)~=0 or (c.f+c.b)~=0 then
v.velocity=self:cV(c,cs)
l={f=c.f,b=c.b,l=c.l,r=c.r}
elseif (c.l+c.r)==0 and (c.f+c.b)==0 and cs~=0 then
v.velocity=self:cV(l,cs)
else v.velocity=Vector3.new(0,0,0) end
g.cframe=workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad((c.f+c.b)*50*cs/m),0,0) end) end
function F:gI()
local i={f=0,b=0,l=0,r=0}
if U:IsKeyDown(Enum.KeyCode.W) then i.f=1 end
if U:IsKeyDown(Enum.KeyCode.S) then i.b=-1 end
if U:IsKeyDown(Enum.KeyCode.A) then i.l=-1 end
if U:IsKeyDown(Enum.KeyCode.D) then i.r=1 end
return i end
function F:cV(c,sp)
local ca=workspace.CurrentCamera
if not ca then return Vector3.new() end
return (ca.CFrame.lookVector*(c.f+c.b))+((ca.CFrame*CFrame.new(c.l+c.r,(c.f+c.b)*0.2,0).p)-ca.CFrame.p)*sp end
function F:sF()
self:uC()
if not self.ch or not self.h then return end
self.f=true
o.Text="停止"
local a=self.ch:FindFirstChild("Animate")
if a then a.Disabled=true end
if self.h then
for _,x in ipairs(self.h:GetPlayingAnimationTracks()) do x:AdjustSpeed(0) end end
self:pI()
self:dH()
self:sW()
if self.h.RigType==Enum.HumanoidRigType.R6 then self:sR6() else self:sR15() end end
function F:eF()
self.f=false
o.Text="开始"
self:sA()
self:eH()
self:sW2()
self:sI()
self:clP()
if self.ch then
local a=self.ch:FindFirstChild("Animate")
if a then a.Disabled=false end end
if self.h then self.h.PlatformStand=false end end
function F:tF()
if self.f then self:eF() else self:sF() end end
function F:tN()
self.n=not self.n
if self.n then
nc.Text="正常模式"
self:aN()
else
nc.Text="穿墙模式"
self:rN() end end
function F:sS()
local i=s.Text
if i=="" then s.Text=tostring(self.v) return end
local ns=tonumber(i)
if ns then
if ns<1 then ns=1 elseif ns>150 then ns=150 end
self.v=math.floor(ns)
s.Text=tostring(self.v)
if self.f then self:sW2() self:sW() end
else s.Text=tostring(self.v) end end
function F:iS()
if self.v<150 then
self.v=self.v+1
s.Text=tostring(self.v)
if self.f then self:sW2() self:sW() end
else s.Text="最大" task.wait(0.5) s.Text=tostring(self.v) end end
function F:dS()
if self.v>1 then
self.v=self.v-1
s.Text=tostring(self.v)
if self.f then self:sW2() self:sW() end
else s.Text="最小" task.wait(1) s.Text=tostring(self.v) end end
local fm=F.new()
o.MouseButton1Click:Connect(function() fm:tF() end)
nc.MouseButton1Click:Connect(function() fm:tN() end)
s.FocusLost:Connect(function() fm:sS() end)
local mt=nil
local function sm(x)
if mt then mt:Disconnect() end
mt=R.Heartbeat:Connect(function()
if not fm.r then return end
fm.r.CFrame=fm.r.CFrame*CFrame.new(0,x,0) end) end
local function em()
if mt then mt:Disconnect() mt=nil end end
u.MouseButton1Down:Connect(function() sm(1) end)
u.MouseButton1Up:Connect(em)
u.MouseLeave:Connect(em)
d.MouseButton1Down:Connect(function() sm(-1) end)
d.MouseButton1Up:Connect(em)
d.MouseLeave:Connect(em)
p.MouseButton1Click:Connect(function() fm:iS() end)
n.MouseButton1Click:Connect(function() fm:dS() end)
c.MouseButton1Click:Connect(function()
if fm.f then fm:eF() end
fm:cl()
m:Destroy() end)
h.MouseButton1Click:Connect(function()
u.Visible=false
d.Visible=false
o.Visible=false
p.Visible=false
s.Visible=false
n.Visible=false
nc.Visible=false
h.Visible=false
h2.Visible=true
f.BackgroundTransparency=1
c.Position=UDim2.new(0,0,-1,57) end)
h2.MouseButton1Click:Connect(function()
u.Visible=true
d.Visible=true
o.Visible=true
p.Visible=true
s.Visible=true
n.Visible=true
nc.Visible=true
h.Visible=true
h2.Visible=false
f.BackgroundTransparency=0
c.Position=UDim2.new(0,0,-1,27) end)
