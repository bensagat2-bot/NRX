--[[
    ================================================================
    NZRX PRIVATE ENGINE -- LINORIA BUILD + BYPASS+ BAKED IN
    ================================================================
]]

if not game:IsLoaded() then game.Loaded:Wait() end
if getgenv().nzrx_loaded then
    pcall(function()
        if getgenv().stopFly           then getgenv().stopFly() end
        if getgenv().stopFakePosition  then getgenv().stopFakePosition() end
        if getgenv().stopDesync        then getgenv().stopDesync() end
        if getgenv().stopRapidFire     then getgenv().stopRapidFire() end
        if getgenv().stopWallbang      then getgenv().stopWallbang() end
        if getgenv().stopTp            then getgenv().stopTp() end
        if getgenv().stopAntiAfk       then getgenv().stopAntiAfk() end
        if getgenv().stopVoid          then getgenv().stopVoid() end
        if getgenv().stopVoidSpam      then getgenv().stopVoidSpam() end
        if getgenv().stopOrbit         then getgenv().stopOrbit() end
        if getgenv().stopRiotAbuser    then getgenv().stopRiotAbuser() end
        if getgenv().stopRiotBypass    then getgenv().stopRiotBypass() end
        if getgenv().stopEvasion       then getgenv().stopEvasion() end
        if getgenv().stopBlink         then getgenv().stopBlink() end
        if getgenv().stopGhost         then getgenv().stopGhost() end
        if getgenv().stopAutocollect   then getgenv().stopAutocollect() end
        if getgenv().stopSafeZone      then getgenv().stopSafeZone() end
        if getgenv().stopReturnHome    then getgenv().stopReturnHome() end
        if getgenv().stopTeleportLoop  then getgenv().stopTeleportLoop() end
        if getgenv().stopSlingRage     then getgenv().stopSlingRage() end
        if getgenv().stopAntiProj      then getgenv().stopAntiProj() end
        if getgenv().stopAntiClose     then getgenv().stopAntiClose() end
        if getgenv().stopFastReload    then getgenv().stopFastReload() end
        if getgenv().stopGlide         then getgenv().stopGlide() end
        if getgenv().stopUnderMap      then getgenv().stopUnderMap() end
        if getgenv()._nzrx_origFireServer then
            pcall(hookfunction,Instance.new("RemoteEvent").FireServer,getgenv()._nzrx_origFireServer)
            getgenv()._nzrx_origFireServer=nil
        end
        if getgenv()._bp_fireOrig then
            pcall(hookfunction,Instance.new("RemoteEvent").FireServer,getgenv()._bp_fireOrig)
            getgenv()._bp_fireOrig=nil
        end
        if getgenv()._bp_invokeOrig then
            pcall(hookfunction,Instance.new("RemoteFunction").InvokeServer,getgenv()._bp_invokeOrig)
            getgenv()._bp_invokeOrig=nil
        end
        if getgenv()._bp_bindOrig then
            pcall(hookfunction,Instance.new("BindableEvent").Fire,getgenv()._bp_bindOrig)
            getgenv()._bp_bindOrig=nil
        end
        if getgenv().AllConnections then
            for _,c in ipairs(getgenv().AllConnections) do pcall(function() c:Disconnect() end) end
        end
        if getgenv()._nzrx_loaderGui then
            pcall(function() getgenv()._nzrx_loaderGui:Destroy() end)
            getgenv()._nzrx_loaderGui=nil
        end
    end)
end
getgenv().nzrx_loaded=true

-- ================================================================
-- BYPASS L1: ANALYTICS WIPE (runs before anything else touches GC)
-- ================================================================
local ANPATS={"AnalyticsPipelineController","TelemetryService","RBXAnalytics","DiagnosticsService","MarketplaceAnalytics","EventIngestService","ClientTelemetry"}
local function wipeAnalytics()
    pcall(function()
        for _,v in pairs(getgc(true)) do
            if type(v)=="function" then
                local ok,src=pcall(debug.info,v,"s")
                if ok and src then
                    for _,p in ipairs(ANPATS) do
                        if src:find(p) then pcall(hookfunction,v,newcclosure(function()return nil end)); break end
                    end
                end
            end
        end
    end)
end
task.spawn(function() task.wait(0.5); wipeAnalytics(); task.wait(30); wipeAnalytics() end)

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local VirtualUser      = game:GetService("VirtualUser")
local HttpService      = game:GetService("HttpService")
local workspace        = game:GetService("Workspace")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local localplayer      = Players.LocalPlayer

-- ================================================================
-- BYPASS L2-4: REMOTE / INVOKE / BINDABLE FILTERS
-- Stacks above the dagger hook that runs later in this file.
-- ================================================================
local BREM={"anticheat","anti_cheat","ac_report","cheatdetect","exploit","flagplayer","reportplayer","hackdetect","velocitycheck","positioncheck","sanitycheck","teleportcheck","speedcheck","auracheck","clientcheck","integritycheck","pingabuse","exploitdetect","cheatflag","reportexploit"}
local BARG={"exploit","cheat","hack","speedhack","noclip","teleport","aimbot","wallhack","fly"}
local function rblocked(n) local l=n:lower(); for _,p in ipairs(BREM) do if l:find(p,1,true) then return true end end end
local function ablocked(args) for _,v in ipairs(args) do if type(v)=="string" then local l=v:lower(); for _,p in ipairs(BARG) do if l:find(p,1,true) then return true end end end end end

local _bpFire; _bpFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
    if not checkcaller() then
        if rblocked(tostring(rawget(self,"Name") or "")) then return end
        if ablocked({...}) then return end
    end
    return _bpFire(self,...)
end)); getgenv()._bp_fireOrig=_bpFire

pcall(function()
    local _bpInv; _bpInv=hookfunction(Instance.new("RemoteFunction").InvokeServer,newcclosure(function(self,...)
        if not checkcaller() and rblocked(tostring(rawget(self,"Name") or "")) then return false end
        return _bpInv(self,...)
    end)); getgenv()._bp_invokeOrig=_bpInv
end)

pcall(function()
    local _bpBind; _bpBind=hookfunction(Instance.new("BindableEvent").Fire,newcclosure(function(self,...)
        if not checkcaller() and rblocked(tostring(rawget(self,"Name") or "")) then return end
        return _bpBind(self,...)
    end)); getgenv()._bp_bindOrig=_bpBind
end)

-- ================================================================
-- BYPASS L5: POSITION SPOOF ANCHOR
-- ================================================================
local _spoofAnchor=Vector3.new(0,5,0); local _spoofConn=nil
local function startSpoof()
    if _spoofConn then _spoofConn:Disconnect() end
    _spoofConn=RunService.Heartbeat:Connect(function()
        local c=localplayer.Character; if not c then return end
        local h=c:FindFirstChild("HumanoidRootPart"); if not h then return end
        _spoofAnchor=_spoofAnchor:Lerp(h.Position,0.02)
    end)
end
startSpoof()

-- ================================================================
-- BYPASS L6: STATE THROTTLE
-- ================================================================
local _sTmr={}
getgenv().safeSetPhysics=function(hum)
    if not hum or not hum.Parent then return end
    local uid=tostring(hum); local now=tick()
    if _sTmr[uid] and now-_sTmr[uid]<0.35 then return end
    _sTmr[uid]=now; pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end)
end

-- ================================================================
-- BYPASS L7: GC FINGERPRINT SCRUB
-- ================================================================
local EFPS={"synapse","script.gg","fluxteam","electron","celery","wave","comet","scriptware","kiwi","evon","hydrogen","arceus","delta","oxygen"}
local function scrub()
    pcall(function()
        for _,fn in pairs(getgc(true)) do
            if type(fn)=="function" then
                local i=1; while true do
                    local ok,n,val=pcall(debug.getupvalue,fn,i); if not ok or not n then break end
                    if type(val)=="string" then local l=val:lower(); for _,fp in ipairs(EFPS) do if l==fp then pcall(debug.setupvalue,fn,i,""); break end end end
                    i=i+1
                end
            end
        end
    end)
end
scrub()
task.spawn(function() while getgenv().nzrx_loaded do task.wait(60); scrub() end end)

-- ================================================================
-- CONFIG
-- ================================================================
getgenv().config={
    nc=false,flyEnabled=false,flySpeed=50,doubleJumpEnabled=false,
    fakePositionEnabled=false,desyncEnabled=false,
    evasionEnabled=false,evasionIntensity=3.0,
    blinkEnabled=false,blinkRadius=80,blinkRate=60,
    ghostEnabled=false,ghostDistance=150,
    glideEnabled=false,glideSpeed=280,glideAccel=18,
    VoidEnabled=false,voidX=1e8,voidY=1e8,voidZ=1e8,
    voidSpamEnabled=false,voidSpamInterval=0.016,voidSpamBurst=5,
    voidSmooth=false,voidSmoothAlpha=0.5,voidPattern="random",
    voidAxisX=true,voidAxisY=true,voidAxisZ=true,
    voidXPos=2500,voidXNeg=2500,voidYPos=1500,voidYNeg=1500,voidZPos=2500,voidZNeg=2500,
    orbit=false,orbitSpeed=90,orbitDistance=8,orbitHeight=0,orbitDir=1,orbitPrediction=0.12,
    wallbangEnabled=false,rapidFire=false,teleportEnemyEnabled=false,
    chainsawBurstCount=3,chainsawVerticalOffset=0.0,
    sling=false,daggerBypass=false,AntiEnemy=false,weaponBypassAllModes=true,
    slingRage=false,antiProj=false,fastReload=false,antiClose=false,
    antiAimEnabled=false,pitchAngle=0,yawAngle=0,spinEnabled=false,
    underMapEnabled=false,underMapY=-500,
    riotAbuserEnabled=false,riotAbuserDistance=300,riotAbuserX=30,
    riotAbuserY=8,riotAbuserZ=30,riotAbuserSpin=720,
    riotBypassEnabled=false,riotBypassDistance=3,riotBypassHeight=0,riotBypassUpdate=0.02,riotBypassPosition="Front",
    antiAfkEnabled=false,autocollectEnabled=false,autocollectRadius=60,
    returnHomeEnabled=false,homeReturnDelay=3.0,
    safeZoneEnabled=false,safeZoneY=-10,
    teleportLoopEnabled=false,teleportLoopDelay=1.5,
    daggerPredictionEnabled=false,daggerPredictFrames=4,daggerPredictSmoothing=60,
    slingPredictionEnabled=false,slingPredictFrames=6,slingPredictSmoothing=50,
    predictionMode="Linear",menuToggleKey="RightControl",lockToggleKey="L",autoLoadScript=false,
}

local ROOT_FOLDER="nzrx"; local PROFILES_FOLDER=ROOT_FOLDER.."/profiles"
local GLOBAL_CFG_FILE=ROOT_FOLDER.."/global_config.json"
local ACTIVE_PROFILE_FILE=ROOT_FOLDER.."/active_profile.txt"
local AUTOLOAD_FILE=ROOT_FOLDER.."/autoload.txt"

local function ensureFolders() local function mf(p) if not isfolder(p) then pcall(makefolder,p) end end; mf(ROOT_FOLDER); mf(PROFILES_FOLDER) end
local function safeWrite(p,c) return pcall(writefile,p,c) end
local function safeRead(p) local ok,d=pcall(readfile,p); return ok and d or nil end
local function safeDelete(p) pcall(delfile,p) end
local function jsonEncode(t) local ok,s=pcall(function() return HttpService:JSONEncode(t) end); return ok and s or nil end
local function jsonDecode(s) local ok,t=pcall(function() return HttpService:JSONDecode(s) end); return ok and t or nil end
local function getActiveProfileName() return safeRead(ACTIVE_PROFILE_FILE) end
local function setActiveProfileName(name) if name then safeWrite(ACTIVE_PROFILE_FILE,name) else safeDelete(ACTIVE_PROFILE_FILE) end end
local function profilePath(name) return PROFILES_FOLDER.."/"..name:gsub("[^%w%-%_ ]",""):sub(1,48)..".json" end
local function syncUiWithConfig()
    pcall(function() for k,v in pairs(getgenv().config) do if Toggles and Toggles[k] and Toggles[k].SetValue then Toggles[k]:SetValue(v) end end end)
end
local function saveProfile(name)
    name=name:match("^%s*(.-)%s*$"); if name=="" then return false,"Enter a profile name" end
    local t={}; for k,v in pairs(getgenv().config) do t[k]=v end
    local s=jsonEncode(t); if not s then return false,"JSON encode failed" end
    local ok,err=safeWrite(profilePath(name),s); if not ok then return false,tostring(err) end
    setActiveProfileName(name); return true,"Saved: "..name
end
local function loadProfile(name)
    local raw=safeRead(profilePath(name)); if not raw then return false,"Not found" end
    local data=jsonDecode(raw); if not data then return false,"Corrupted" end
    for k,v in pairs(data) do if getgenv().config[k]~=nil then getgenv().config[k]=v end end
    setActiveProfileName(name); syncUiWithConfig(); return true,"Loaded: "..name
end
local function deleteProfile(name)
    safeDelete(profilePath(name))
    if getActiveProfileName()==name then setActiveProfileName(nil) end
    return true,"Deleted: "..name
end
local function saveGlobalConfig()
    local t={}; for k,v in pairs(getgenv().config) do t[k]=v end
    local s=jsonEncode(t); if s then safeWrite(GLOBAL_CFG_FILE,s) end
    if getgenv().config.autoLoadScript then safeWrite(AUTOLOAD_FILE,"true") else safeDelete(AUTOLOAD_FILE) end
end
local function loadGlobalConfig()
    local raw=safeRead(GLOBAL_CFG_FILE); if not raw then return end
    local data=jsonDecode(raw); if not data then return end
    for k,v in pairs(data) do if getgenv().config[k]~=nil then getgenv().config[k]=v end end
    getgenv().config.autoLoadScript=(safeRead(AUTOLOAD_FILE)=="true"); syncUiWithConfig()
end
pcall(ensureFolders); pcall(loadGlobalConfig)

local username=(localplayer and (localplayer.DisplayName or localplayer.Name)) or "User"

-- ================================================================
-- LINORIA UI LOAD
-- ================================================================
local repo="https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local libSrc=game:HttpGet(repo.."Library.lua")
libSrc=string.gsub(libSrc,"Enum%.UserInputType%.MouseButton1","Enum.UserInputType.MouseButton1 or (typeof(Input)=='Instance' and Input.UserInputType==Enum.UserInputType.Touch) or (typeof(input)=='Instance' and input.UserInputType==Enum.UserInputType.Touch) or (typeof(e)=='Instance' and e.UserInputType==Enum.UserInputType.Touch)")
local Library=loadstring(libSrc)()
local ThemeManager=loadstring(game:HttpGet(repo.."addons/ThemeManager.lua"))()
local SaveManager=loadstring(game:HttpGet(repo.."addons/SaveManager.lua"))()

local menuKey=Enum.KeyCode.RightControl
pcall(function() if getgenv().config.menuToggleKey then menuKey=Enum.KeyCode[getgenv().config.menuToggleKey] or Enum.KeyCode.RightControl end end)

local Window=Library:CreateWindow({Title="nzrx  //  private engine",Center=true,AutoShow=true,TabPadding=8,MenuFadeTime=0.2})
pcall(function() if Library and Library.ScreenGui then Library.ScreenGui.DisplayOrder=9990 end end)

local Tabs={
    Main=Window:AddTab("Main"),Combat=Window:AddTab("Combat"),
    Movement=Window:AddTab("Movement"),Utilities=Window:AddTab("Utilities"),
    Prediction=Window:AddTab("Prediction"),Settings=Window:AddTab("Settings"),
}
Library:SetWatermark("nzrx  •  "..username)
local function Notify(title,desc) Library:Notify({Title=title,Description=desc,Duration=3}) end

-- ================================================================
-- LOCK SCREEN
-- ================================================================
local LockScreen=Instance.new("ScreenGui")
LockScreen.Name="NZRX_LockUI"; LockScreen.DisplayOrder=9999; LockScreen.ResetOnSpawn=false
pcall(function() LockScreen.Parent=CoreGui end)
if not LockScreen.Parent then pcall(function() LockScreen.Parent=localplayer:WaitForChild("PlayerGui") end) end

local LockFrame=Instance.new("Frame",LockScreen)
LockFrame.Size=UDim2.new(1,0,1,0); LockFrame.BackgroundColor3=Color3.fromRGB(5,3,12)
LockFrame.BackgroundTransparency=1; LockFrame.BorderSizePixel=0; LockFrame.Visible=false; LockFrame.Active=false

local _lbg=Instance.new("Frame",LockFrame)
_lbg.Size=UDim2.new(1,0,1,0); _lbg.BackgroundColor3=Color3.fromRGB(0,0,0); _lbg.BackgroundTransparency=0.45; _lbg.BorderSizePixel=0

local LockCard=Instance.new("Frame",LockFrame)
LockCard.Size=UDim2.new(0,360,0,180); LockCard.Position=UDim2.new(0.5,-180,0.5,-90)
LockCard.BackgroundColor3=Color3.fromRGB(12,8,26); LockCard.BorderSizePixel=0
Instance.new("UICorner",LockCard).CornerRadius=UDim.new(0,14)
local lks=Instance.new("UIStroke",LockCard); lks.Color=Color3.fromRGB(138,43,226); lks.Thickness=2; lks.Transparency=0.2

local function mkLbl(parent,txt,y,sz,col,fnt)
    local l=Instance.new("TextLabel",parent); l.Size=UDim2.new(1,0,0,sz); l.Position=UDim2.new(0,0,0,y)
    l.BackgroundTransparency=1; l.Text=txt; l.Font=fnt or Enum.Font.GothamBold; l.TextSize=sz; l.TextColor3=col; return l
end
mkLbl(LockCard,"INTERFACE LOCKED",45,18,Color3.fromRGB(210,170,255))
mkLbl(LockCard,"Press lock key or tap unlock below",75,12,Color3.fromRGB(120,90,160),Enum.Font.Code)

local unlockBtn=Instance.new("TextButton",LockCard)
unlockBtn.Size=UDim2.new(0,140,0,32); unlockBtn.Position=UDim2.new(0.5,-70,0,115)
unlockBtn.BackgroundColor3=Color3.fromRGB(138,43,226); unlockBtn.Text="UNLOCK"
unlockBtn.Font=Enum.Font.GothamBold; unlockBtn.TextSize=12; unlockBtn.TextColor3=Color3.fromRGB(255,255,255)
unlockBtn.BorderSizePixel=0; Instance.new("UICorner",unlockBtn).CornerRadius=UDim.new(0,8)

local isLocked=false; LockScreen.Enabled=false
local function updateLockState(state)
    isLocked=state
    if isLocked then
        LockScreen.Enabled=true; LockFrame.Active=true; LockFrame.Visible=true; LockFrame.BackgroundTransparency=1
        TweenService:Create(LockFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{BackgroundTransparency=0.18}):Play()
        Notify("Interface Locked","Script paused.")
    else
        LockFrame.Active=false
        TweenService:Create(LockFrame,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{BackgroundTransparency=1}):Play()
        task.delay(0.22,function() LockFrame.Visible=false; LockScreen.Enabled=false end)
        Notify("Interface Unlocked","Back online.")
    end
end
getgenv().updateLockState=updateLockState
unlockBtn.Activated:Connect(function() updateLockState(false) end)
local function getLockKey() local k=Enum.KeyCode.L; pcall(function() k=Enum.KeyCode[getgenv().config.lockToggleKey] or Enum.KeyCode.L end); return k end
UserInputService.InputBegan:Connect(function(input,processed) if processed then return end; if input.KeyCode==getLockKey() then updateLockState(not isLocked) end end)

-- ================================================================
-- MOBILE FLOATING BUTTON (drag + tap + double-tap lock)
-- ================================================================
local MobileGui=Instance.new("ScreenGui")
MobileGui.Name="NZRX_MobileToggle"; MobileGui.DisplayOrder=9997; MobileGui.ResetOnSpawn=false
pcall(function() MobileGui.Parent=CoreGui end)
if not MobileGui.Parent and localplayer then pcall(function() MobileGui.Parent=localplayer:WaitForChild("PlayerGui") end) end

local mobBtn=Instance.new("TextButton",MobileGui)
mobBtn.Name="MobileToggle"; mobBtn.Size=UDim2.new(0,40,0,40); mobBtn.Position=UDim2.new(0.02,0,0.25,0)
mobBtn.BackgroundColor3=Color3.fromRGB(12,8,26); mobBtn.BorderSizePixel=0
mobBtn.Text="NZRX"; mobBtn.Font=Enum.Font.GothamBold; mobBtn.TextSize=10; mobBtn.TextColor3=Color3.fromRGB(180,80,255)
mobBtn.Active=true; mobBtn.Draggable=false
Instance.new("UICorner",mobBtn).CornerRadius=UDim.new(1,0)
local mobStk=Instance.new("UIStroke",mobBtn); mobStk.Color=Color3.fromRGB(138,43,226); mobStk.Thickness=2; mobStk.Transparency=0.2

local function toggleMenu() pcall(function() Library:Toggle() end) end

local dragging,dragInput,dragStart,startPos,isMoved=false,nil,nil,nil,false
local lastMobTap=0

mobBtn.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true; isMoved=false; dragStart=input.Position; startPos=mobBtn.Position
        -- double-tap detection
        local now=tick()
        if input.UserInputType==Enum.UserInputType.Touch and (now-lastMobTap)<0.3 then
            updateLockState(not isLocked)
        end
        lastMobTap=now
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then
                dragging=false; if not isMoved then toggleMenu() end
            end
        end)
    end
end)
mobBtn.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input==dragInput and dragging then
        local delta=input.Position-dragStart
        if delta.Magnitude>5 then isMoved=true end
        mobBtn.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)
UserInputService.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.KeyCode==menuKey then toggleMenu() end
end)

-- swipe right-edge to toggle menu
local swipeOrigin=nil
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch then swipeOrigin=input.Position end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType~=Enum.UserInputType.Touch or not swipeOrigin then return end
    local vp=workspace.CurrentCamera.ViewportSize
    local deltaX=swipeOrigin.X-input.Position.X
    if swipeOrigin.X>vp.X*0.85 and deltaX>80 then toggleMenu() end
    swipeOrigin=nil
end)

-- ================================================================
-- CORE HELPERS
-- ================================================================
getgenv().AllConnections={}; getgenv().loopWaypoints={}; getgenv().loopIndex=1
getgenv().homePosition=nil; getgenv().safeZoneSavedPos=nil
local config=getgenv().config

local function getHrp() return localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart") end
local function getClosest()
    local closest,minD=nil,math.huge; local hrp=getHrp(); if not hrp then return nil end
    for _,p in pairs(Players:GetPlayers()) do
        if p~=localplayer and p.Character then
            local ph=p.Character:FindFirstChild("HumanoidRootPart")
            if ph then
                if localplayer.Team==nil or p.Team==nil or localplayer.Team~=p.Team then
                    local hum=p.Character:FindFirstChild("Humanoid")
                    if hum and hum.Health>0 then local d=(hrp.Position-ph.Position).Magnitude; if d<minD then minD=d; closest=p end end
                end
            end
        end
    end
    return closest
end
local function safeTeleport(pos)
    local hrp=getHrp(); if not hrp then return end
    local x,y,z=pos.X,pos.Y,pos.Z; y=math.clamp(y,2,hrp.Position.Y+800)
    local rp=RaycastParams.new(); rp.FilterType=Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances={localplayer.Character}
    local hit=workspace:Raycast(Vector3.new(x,y+60,z),Vector3.new(0,-220,0),rp)
    if hit then y=math.max(hit.Position.Y+3,2) end; hrp.CFrame=CFrame.new(x,y,z)
end
local function isWeaponBypassAllowed()
    if config.weaponBypassAllModes then return true end
    local ok,ps=pcall(function() return game.PrivateServerId~=nil and game.PrivateServerId~="" end); return ok and ps
end

-- ================================================================
-- PREDICTION ENGINE
-- ================================================================
local predCache={}
table.insert(getgenv().AllConnections,RunService.Heartbeat:Connect(function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=localplayer and p.Character then
            local ph=p.Character:FindFirstChild("HumanoidRootPart")
            if ph then
                local uid=p.UserId; local prev=predCache[uid]; local cur=ph.Position
                local rawVel=prev and (cur-prev.pos) or Vector3.zero
                local smoothVel=prev and prev.smoothVel and prev.smoothVel:Lerp(rawVel,0.4) or rawVel
                local hist=prev and prev.history or {}
                table.insert(hist,cur); if #hist>8 then table.remove(hist,1) end
                predCache[uid]={pos=cur,vel=rawVel,smoothVel=smoothVel,history=hist}
            end
        end
    end
end))

local function getPredicted(player,frames,smoothing100,mode)
    local uid=player.UserId; local cache=predCache[uid]; if not cache then return nil end
    local s=smoothing100/100; local vel=cache.smoothVel or cache.vel; mode=mode or "Linear"
    if mode=="Linear" then return cache.pos+(vel*frames*s)
    elseif mode=="Quadratic" then
        local hist=cache.history
        if #hist>=3 then local a=hist[#hist];local b=hist[#hist-1];local c=hist[#hist-2]; return cache.pos+(vel*frames*s)+((a-b)-(b-c))*(frames*frames)*0.5*s end
        return cache.pos+(vel*frames*s)
    elseif mode=="Extrapolate" then
        local hist=cache.history
        if #hist>=4 then local v1=hist[#hist]-hist[#hist-1];local v2=hist[#hist-1]-hist[#hist-2];local v3=hist[#hist-2]-hist[#hist-3]; return cache.pos+((v1*0.6+v2*0.3+v3*0.1)*frames*s) end
        return cache.pos+(vel*frames*s)
    elseif mode=="Jerk" then
        local hist=cache.history
        if #hist>=5 then
            local a=hist[#hist];local b=hist[#hist-1];local c=hist[#hist-2];local d=hist[#hist-3]
            local v1=a-b; local ac=(a-b)-(b-c); local jerk=((a-b)-(b-c))-((b-c)-(c-d))
            return cache.pos+(v1*frames*s)+(ac*(frames*frames)*0.5*s)+(jerk*(frames^3)*(1/6)*s)
        end
        return cache.pos+(vel*frames*s)
    end
    return cache.pos+(vel*frames*s)
end

-- ================================================================
-- DAGGER BYPASS HOOK (stacks below the outer BP filter above)
-- ================================================================
local oldFireServer
oldFireServer=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
    local args={...}
    if not checkcaller() and config.daggerBypass and isWeaponBypassAllowed() then
        local n=self.Name:lower()
        local isWeapon=n:find("dagger") or n:find("knife") or n:find("throw") or n:find("blade") or n:find("bow") or n:find("arrow") or n:find("chainsaw") or n:find("saw") or n:find("slash")
        if isWeapon then
            local isOwnFire=false
            if localplayer.Character then
                local tool=localplayer.Character:FindFirstChildOfClass("Tool")
                if tool then local tname=tool.Name:lower(); if tname:find("dagger") or tname:find("knife") or tname:find("blade") or tname:find("bow") or tname:find("chainsaw") or tname:find("saw") then isOwnFire=true end end
            end
            if isOwnFire then
                if config.daggerPredictionEnabled then
                    local target=getClosest()
                    if target then
                        local predicted=getPredicted(target,config.daggerPredictFrames,config.daggerPredictSmoothing,config.predictionMode)
                        if predicted then for i,v in ipairs(args) do if typeof(v)=="Vector3" then args[i]=predicted; break elseif typeof(v)=="CFrame" then args[i]=CFrame.new(predicted,predicted+v.LookVector); break end end end
                    end
                end
                return oldFireServer(self,table.unpack(args))
            else return end
        end
    end
    return oldFireServer(self,...)
end))
getgenv()._nzrx_origFireServer=oldFireServer

UserInputService.JumpRequest:Connect(function()
    if config.doubleJumpEnabled then
        local hum=localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum:GetState()~=Enum.HumanoidStateType.Dead then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ================================================================
-- FEATURE LOOPS
-- ================================================================
local voidConn1,voidConn2,voidConn3,voidToggle=nil,nil,nil,false
getgenv().startVoid=function()
    if voidConn1 then voidConn1:Disconnect() end; if voidConn2 then voidConn2:Disconnect() end; if voidConn3 then voidConn3:Disconnect() end
    voidConn1=RunService.Heartbeat:Connect(function()
        if not config.VoidEnabled or not getHrp() then return end
        voidToggle=not voidToggle; local hrp=getHrp(); local vx,vy,vz=config.voidX,config.voidY,config.voidZ
        if voidToggle then hrp.CFrame=CFrame.new(math.random(-vx,vx),vy,math.random(-vz,vz)) else hrp.CFrame=CFrame.new(math.random(vx,vx*2),-vy,math.random(vz,vz*2)) end
        hrp.AssemblyLinearVelocity=Vector3.new(math.random(-1e5,1e5),math.random(-1e5,1e5),math.random(-1e5,1e5))
        hrp.AssemblyAngularVelocity=Vector3.new(math.random(-1e5,1e5),math.random(-1e5,1e5),math.random(-1e5,1e5))
    end)
    voidConn2=RunService.RenderStepped:Connect(function() if not config.VoidEnabled or not getHrp() then return end; getHrp().CFrame=getHrp().CFrame*CFrame.new(math.random(-50,50),math.random(-50,50),math.random(-50,50)) end)
    voidConn3=RunService.Stepped:Connect(function() if not config.VoidEnabled or not getHrp() then return end; if getHrp().Position.Magnitude>1e7 then getHrp().CFrame=CFrame.new(0,config.voidY,0) end end)
end
getgenv().stopVoid=function()
    if voidConn1 then voidConn1:Disconnect(); voidConn1=nil end
    if voidConn2 then voidConn2:Disconnect(); voidConn2=nil end
    if voidConn3 then voidConn3:Disconnect(); voidConn3=nil end
end

local voidSpamConn,voidSpamCharConn=nil,nil
local voidSpiralAngle=0; local voidWaveTime=0; local voidBounceDir={X=1,Y=1,Z=1}
local voidChaosSeeds={math.random(),math.random(),math.random()}; local voidHelixT=0; local voidStrobePhase=false
local function getVoidSpamDelta(dt)
    local xp,xn=config.voidXPos,config.voidXNeg; local yp,yn=config.voidYPos,config.voidYNeg; local zp,zn=config.voidZPos,config.voidZNeg
    local ax,ay,az=config.voidAxisX,config.voidAxisY,config.voidAxisZ; local p=config.voidPattern
    if p=="spiral" then voidSpiralAngle=voidSpiralAngle+0.35; return Vector3.new(ax and math.cos(voidSpiralAngle)*(xp+xn)/2 or 0,ay and math.sin(voidSpiralAngle*0.6)*(yp+yn)/2 or 0,az and math.sin(voidSpiralAngle)*(zp+zn)/2 or 0)
    elseif p=="wave" then voidWaveTime=voidWaveTime+dt*8; return Vector3.new(ax and math.sin(voidWaveTime)*(xp+xn)/2 or 0,ay and math.sin(voidWaveTime*1.7)*(yp+yn)/2 or 0,az and math.cos(voidWaveTime*0.9)*(zp+zn)/2 or 0)
    elseif p=="bounce" then
        local step=Vector3.new(ax and voidBounceDir.X*(xp+xn)/3 or 0,ay and voidBounceDir.Y*(yp+yn)/3 or 0,az and voidBounceDir.Z*(zp+zn)/3 or 0)
        if math.random()<0.25 then voidBounceDir.X=-voidBounceDir.X end; if math.random()<0.25 then voidBounceDir.Y=-voidBounceDir.Y end; if math.random()<0.25 then voidBounceDir.Z=-voidBounceDir.Z end; return step
    elseif p=="chaos" then
        voidChaosSeeds[1]=math.fmod(voidChaosSeeds[1]*1.6645+0.101390,1.0); voidChaosSeeds[2]=math.fmod(voidChaosSeeds[2]*2.2695+0.00001,1.0); voidChaosSeeds[3]=math.fmod(voidChaosSeeds[3]*2.14013+0.253101,1.0)
        return Vector3.new(ax and (voidChaosSeeds[1]*(xp+xn)-xn) or 0,ay and (voidChaosSeeds[2]*(yp+yn)-yn) or 0,az and (voidChaosSeeds[3]*(zp+zn)-zn) or 0)
    elseif p=="cross" then local tog=(math.floor(tick()*10))%2==0; return Vector3.new(ax and (tog and (math.random()*(xp+xn)-xn) or 0) or 0,ay and (not tog and (math.random()*(yp+yn)-yn) or 0) or 0,az and (tog and (math.random()*(zp+zn)-zn) or 0) or 0)
    elseif p=="helix" then voidHelixT=voidHelixT+dt*6; return Vector3.new(ax and math.cos(voidHelixT*2)*(xp+xn)/2 or 0,ay and math.sin(voidHelixT)*(yp+yn)/8 or 0,az and math.sin(voidHelixT*2)*(zp+zn)/2 or 0)
    elseif p=="strobe" then voidStrobePhase=not voidStrobePhase; local s=voidStrobePhase and 1 or -1; return Vector3.new(ax and s*xp or 0,ay and s*yp or 0,az and s*zp or 0)
    else return Vector3.new(ax and (math.random()*(xp+xn)-xn) or 0,ay and (math.random()*(yp+yn)-yn) or 0,az and (math.random()*(zp+zn)-zn) or 0) end
end
getgenv().startVoidSpam=function()
    if voidSpamConn then return end
    voidSpiralAngle=0; voidWaveTime=0; voidHelixT=0; voidStrobePhase=false; voidBounceDir={X=1,Y=1,Z=1}; voidChaosSeeds={math.random(),math.random(),math.random()}
    local root,humanoid
    local function refreshChar() local ch=localplayer.Character; if not ch then root=nil; humanoid=nil; return end; root=ch:FindFirstChild("HumanoidRootPart"); humanoid=ch:FindFirstChildOfClass("Humanoid") end
    refreshChar()
    voidSpamCharConn=localplayer.CharacterAdded:Connect(function(ch) root=ch:WaitForChild("HumanoidRootPart"); humanoid=ch:WaitForChild("Humanoid"); task.wait(0.2); if config.voidSpamEnabled and humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end end)
    local acc,dtBuf=0,0
    voidSpamConn=RunService.Heartbeat:Connect(function(dt)
        if not config.voidSpamEnabled then getgenv().stopVoidSpam(); return end
        if not root or not root.Parent then refreshChar(); return end
        if humanoid and humanoid.Health<=0 then return end
        dtBuf=dtBuf+dt; acc=acc+dt; local interval=math.max(config.voidSpamInterval,0.005)
        if acc<interval then return end; acc=acc%interval
        local burst=math.clamp(config.voidSpamBurst,1,20)
        for _=1,burst do
            if not root or not root.Parent then break end
            local pos=root.Position; local look=root.CFrame.LookVector; local delta=getVoidSpamDelta(dtBuf/burst)
            local newPos=config.voidSmooth and pos:Lerp(pos+delta,math.clamp(config.voidSmoothAlpha,0.01,1)) or (pos+delta)
            root.CFrame=CFrame.new(newPos,newPos+look)
        end; dtBuf=0
    end)
end
getgenv().stopVoidSpam=function()
    if voidSpamConn then voidSpamConn:Disconnect(); voidSpamConn=nil end
    if voidSpamCharConn then voidSpamCharConn:Disconnect(); voidSpamCharConn=nil end
    config.voidSpamEnabled=false
end

local orbConn,orbAngle=nil,0
getgenv().startOrbit=function()
    if orbConn then orbConn:Disconnect() end
    local hum=localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end; orbAngle=0
    orbConn=RunService.Heartbeat:Connect(function()
        if not config.orbit then return end; local myHrp=getHrp(); if not myHrp then return end
        local cl=getClosest()
        if cl and cl.Character then
            local hrp=cl.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                orbAngle=orbAngle+((config.orbitSpeed or 90)/500)*(config.orbitDir or 1)
                local radius=config.orbitDistance or 8; local height=config.orbitHeight or 0; local lead=Vector3.zero
                local pc=predCache[cl.UserId]
                if pc and pc.smoothVel and (config.orbitPrediction or 0)>0 then lead=pc.smoothVel*(config.orbitPrediction or 0) end
                local targetPos=hrp.Position+lead
                local offset=Vector3.new(math.cos(orbAngle)*radius,height,math.sin(orbAngle)*radius)
                myHrp.CFrame=CFrame.new(targetPos+offset,targetPos); myHrp.AssemblyLinearVelocity=Vector3.zero; myHrp.AssemblyAngularVelocity=Vector3.zero
            end
        end
    end)
end
getgenv().stopOrbit=function() if orbConn then orbConn:Disconnect(); orbConn=nil end; config.orbit=false end

local tpConn
getgenv().startTp=function()
    if tpConn then tpConn:Disconnect() end
    tpConn=RunService.Heartbeat:Connect(function()
        if not config.teleportEnemyEnabled then return end
        local t=getClosest(); local hrp=getHrp()
        if not (t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and hrp) then return end
        local targetHrp=t.Character.HumanoidRootPart; local targetPos=targetHrp.Position
        local offset=config.chainsawVerticalOffset or 0.0; local burst=math.clamp(config.chainsawBurstCount or 3,1,8)
        local pc=predCache[t.UserId]; local snapPos=(pc and pc.smoothVel) and (targetPos+pc.smoothVel*2) or targetPos
        local lv=targetHrp.CFrame.LookVector
        for i=1,burst do
            local jX=(i>1) and math.random(-2,2) or 0; local jZ=(i>1) and math.random(-2,2) or 0
            hrp.CFrame=CFrame.new(snapPos.X+jX,snapPos.Y+offset,snapPos.Z+jZ,lv.X,lv.Y,lv.Z)
            hrp.AssemblyLinearVelocity=Vector3.zero; hrp.AssemblyAngularVelocity=Vector3.zero
        end
    end)
end
getgenv().stopTp=function() if tpConn then tpConn:Disconnect(); tpConn=nil end end

local fakePosConnection,renderPosConnection,realCF=nil,nil,nil
getgenv().startFakePosition=function()
    if fakePosConnection then fakePosConnection:Disconnect() end; if renderPosConnection then renderPosConnection:Disconnect() end
    fakePosConnection=RunService.Heartbeat:Connect(function() local tHrp=getHrp(); if config.fakePositionEnabled and tHrp then realCF=tHrp.CFrame; tHrp.CFrame=realCF+Vector3.new(math.random(-150,150),math.random(10,100),math.random(-150,150)) end end)
    renderPosConnection=RunService.RenderStepped:Connect(function() local tHrp=getHrp(); if config.fakePositionEnabled and tHrp and realCF then tHrp.CFrame=realCF end end)
end
getgenv().stopFakePosition=function()
    if fakePosConnection then fakePosConnection:Disconnect(); fakePosConnection=nil end
    if renderPosConnection then renderPosConnection:Disconnect(); renderPosConnection=nil end
end

local desyncHeartbeat,desyncRender,realVel=nil,nil,nil
getgenv().startDesync=function()
    if desyncHeartbeat then desyncHeartbeat:Disconnect() end; if desyncRender then desyncRender:Disconnect() end
    desyncHeartbeat=RunService.Heartbeat:Connect(function() local tHrp=getHrp(); if config.desyncEnabled and tHrp then realVel=tHrp.AssemblyLinearVelocity; tHrp.AssemblyLinearVelocity=Vector3.new(math.random(-5000,5000),math.random(-5000,5000),math.random(-5000,5000)) end end)
    desyncRender=RunService.RenderStepped:Connect(function() local tHrp=getHrp(); if config.desyncEnabled and tHrp and realVel then tHrp.AssemblyLinearVelocity=realVel end end)
end
getgenv().stopDesync=function()
    if desyncHeartbeat then desyncHeartbeat:Disconnect(); desyncHeartbeat=nil end
    if desyncRender then desyncRender:Disconnect(); desyncRender=nil end
end

local evasionConn,blinkConn,ghostConn=nil,nil,nil
getgenv().startEvasion=function()
    if evasionConn then evasionConn:Disconnect() end
    local t0,s1,s2,s3=tick(),math.random(1e3,9e3),math.random(1e3,9e3),math.random(1e3,9e3)
    evasionConn=RunService.Heartbeat:Connect(function()
        if not config.evasionEnabled or not getHrp() then return end
        local t,i=tick()-t0,config.evasionIntensity
        local oX=math.cos(t*18.7)*500*0.18*i+math.cos(t*7.3+s1)*500*0.35*i+math.cos(t*2.1+s2)*500*0.55*i
        local oZ=math.sin(t*18.7)*500*0.18*i+math.sin(t*7.3+s1)*500*0.35*i+math.sin(t*2.1+s2)*500*0.55*i
        local oY=math.sin(t*11.3+s3)*500*0.12*i+math.sin(t*5.7)*500*0.08*i
        local jX=math.noise(t*8,s1,0)*40*i; local jY=math.noise(0,t*8,s2)*20*i; local jZ=math.noise(0,0,t*8+s3)*40*i
        safeTeleport(getHrp().Position+Vector3.new(oX+jX,oY+jY,oZ+jZ))
    end)
end
getgenv().stopEvasion=function() if evasionConn then evasionConn:Disconnect(); evasionConn=nil end end

local blinkAnchor=nil
getgenv().startBlink=function()
    if blinkConn then blinkConn:Disconnect() end; if getHrp() then blinkAnchor=getHrp().Position end
    local lastSnap,anchorT,seed=0,0,math.random(1e3,9e3)
    blinkConn=RunService.Heartbeat:Connect(function(dt)
        if not config.blinkEnabled or not getHrp() then return end; anchorT=anchorT+dt
        blinkAnchor=(blinkAnchor or getHrp().Position)+Vector3.new(math.sin(anchorT*1.3+seed)*12,math.sin(anchorT*2.1)*3,math.cos(anchorT*1.7+seed)*12)*dt
        local now=tick()
        if (now-lastSnap)>=(1/config.blinkRate) then
            lastSnap=now; local a,d=math.random()*math.pi*2,math.random()*config.blinkRadius
            safeTeleport(Vector3.new(blinkAnchor.X+math.cos(a)*d,blinkAnchor.Y+(math.random()-0.5)*config.blinkRadius*0.3,blinkAnchor.Z+math.sin(a)*d))
        end
    end)
end
getgenv().stopBlink=function() if blinkConn then blinkConn:Disconnect(); blinkConn=nil end end

getgenv().startGhost=function()
    if ghostConn then ghostConn:Disconnect() end
    local flip,t0,seed=false,tick(),math.random(1e3,9e3)
    ghostConn=RunService.Heartbeat:Connect(function()
        if not config.ghostEnabled or not getHrp() then return end; flip=not flip
        if flip then local a=(tick()-t0)*4.3+seed; safeTeleport(Vector3.new(getHrp().Position.X+math.cos(a)*config.ghostDistance,getHrp().Position.Y,getHrp().Position.Z+math.sin(a)*config.ghostDistance)) end
    end)
end
getgenv().stopGhost=function() if ghostConn then ghostConn:Disconnect(); ghostConn=nil end end

local glideConn=nil
getgenv().startGlide=function()
    if glideConn then glideConn:Disconnect() end
    local hum=localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end; local vel=Vector3.zero
    glideConn=RunService.Heartbeat:Connect(function(dt)
        if not config.glideEnabled then getgenv().stopGlide(); return end
        local hrp=getHrp(); if not hrp then return end
        local cam=workspace.CurrentCamera; local cf=cam and cam.CFrame or hrp.CFrame
        local f=Vector3.new(cf.LookVector.X,0,cf.LookVector.Z).Unit; local r=Vector3.new(cf.RightVector.X,0,cf.RightVector.Z).Unit
        local humC=localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
        local md=humC and humC.MoveDirection or Vector3.zero; local wish=Vector3.zero
        if md.Magnitude>0.001 then wish=f*md:Dot(f)+r*md:Dot(r); if wish.Magnitude>0.001 then wish=wish.Unit end end
        vel=vel:Lerp(wish*config.glideSpeed,1-math.exp(-math.clamp(config.glideAccel,1,100)*dt))
        hrp.AssemblyLinearVelocity=Vector3.new(vel.X,hrp.AssemblyLinearVelocity.Y,vel.Z)
    end)
end
getgenv().stopGlide=function() if glideConn then glideConn:Disconnect(); glideConn=nil end; config.glideEnabled=false end

local riotAbuserConn=nil
getgenv().startRiotAbuser=function()
    if riotAbuserConn then riotAbuserConn:Disconnect() end
    local t0,seed=tick(),math.random(1e3,9e3); local hrp=getHrp(); if hrp then getgenv().riotAbuserOriginal=hrp.CFrame end
    riotAbuserConn=RunService.Heartbeat:Connect(function(dt)
        if not config.riotAbuserEnabled or not getHrp() then return end
        local t=tick()-t0; local hrp2=getHrp()
        local yaw=math.rad(config.riotAbuserSpin*dt); local pitch=math.rad(config.riotAbuserSpin*0.37*dt*math.sin(t*3.1)); local roll=math.rad(config.riotAbuserSpin*0.19*dt*math.cos(t*5.7+seed))
        local spinCF=hrp2.CFrame*CFrame.Angles(pitch,yaw,roll); local spread=config.riotAbuserDistance/300
        local jX=(math.random()-0.5)*config.riotAbuserX*spread*2+math.noise(t*9,seed,0)*config.riotAbuserX*spread
        local jY=(math.random()-0.5)*config.riotAbuserY*spread+math.noise(0,t*9,seed)*config.riotAbuserY*spread*0.3
        local jZ=(math.random()-0.5)*config.riotAbuserZ*spread*2+math.noise(0,0,t*9+seed)*config.riotAbuserZ*spread
        hrp2.CFrame=spinCF+Vector3.new(jX,math.max(spinCF.Position.Y+jY,2)-spinCF.Position.Y,jZ)
    end)
end
getgenv().stopRiotAbuser=function() if riotAbuserConn then riotAbuserConn:Disconnect(); riotAbuserConn=nil end; if getHrp() and getgenv().riotAbuserOriginal then getHrp().CFrame=getgenv().riotAbuserOriginal end end

local riotBypassConn,riotBypassTarget=nil,nil; local riotBypassLastSnap=0
getgenv().startRiotBypass=function()
    if riotBypassConn then riotBypassConn:Disconnect() end
    riotBypassConn=RunService.Heartbeat:Connect(function()
        if not config.riotBypassEnabled or not getHrp() then return end
        if not riotBypassTarget or not riotBypassTarget.Character or not riotBypassTarget.Character:FindFirstChild("Humanoid") or riotBypassTarget.Character.Humanoid.Health<=0 then riotBypassTarget=getClosest(); return end
        local tr=riotBypassTarget.Character:FindFirstChild("HumanoidRootPart"); if not tr then return end
        local now=tick(); if (now-riotBypassLastSnap)<config.riotBypassUpdate then return end
        riotBypassLastSnap=now; local hrp=getHrp(); if not hrp then return end
        local targetPos=tr.Position; local targetLook=tr.CFrame.LookVector
        local dist=config.riotBypassDistance or 3; local hOff=config.riotBypassHeight or 0; local mode=config.riotBypassPosition or "Front"; local cf
        if mode=="Front" then cf=CFrame.lookAt(targetPos+(targetLook*dist)+Vector3.new(0,hOff,0),targetPos+Vector3.new(0,hOff,0))
        elseif mode=="Back" then cf=CFrame.lookAt(targetPos-(targetLook*dist)+Vector3.new(0,hOff,0),targetPos+Vector3.new(0,hOff,0))
        elseif mode=="Above" then cf=CFrame.lookAt(targetPos+Vector3.new(0,dist+hOff,0),targetPos+Vector3.new(0,hOff,0))
        elseif mode=="Below" then cf=CFrame.lookAt(targetPos+Vector3.new(0,-dist+hOff,0),targetPos+Vector3.new(0,hOff,0)) end
        hrp.CFrame=cf; hrp.AssemblyLinearVelocity=Vector3.zero; hrp.AssemblyAngularVelocity=Vector3.zero
    end)
end
getgenv().stopRiotBypass=function() if riotBypassConn then riotBypassConn:Disconnect(); riotBypassConn=nil end; riotBypassTarget=nil; riotBypassLastSnap=0 end

local slingRageConn,slingProjA,slingProjB
local slingTarget=CFrame.new(9000,9000,9000); local slingProjs={}
getgenv().startSlingRage=function()
    if slingRageConn then slingRageConn:Disconnect() end
    slingProjA=workspace.ChildAdded:Connect(function(o) if not o:IsA("BasePart") then return end; if localplayer.Character and o:IsDescendantOf(localplayer.Character) then return end; if o.Name=="CoreProjectile" then slingProjs[o]=true elseif o.Name=="Part" then task.defer(function() if o and o.Parent and o.AssemblyLinearVelocity.Magnitude>50 then slingProjs[o]=true end end) end end)
    slingProjB=workspace.ChildRemoved:Connect(function(o) slingProjs[o]=nil end)
    slingRageConn=RunService.Heartbeat:Connect(function()
        if not config.slingRage then return end
        pcall(function()
            local snapTarget=slingTarget
            if config.slingPredictionEnabled then local target=getClosest(); if target then local predicted=getPredicted(target,config.slingPredictFrames,config.slingPredictSmoothing,config.predictionMode); if predicted then snapTarget=CFrame.new(predicted) end end end
            for _,p in pairs(Players:GetPlayers()) do if p~=localplayer and p.Character then local h=p.Character:FindFirstChild("HumanoidRootPart"); if h then h.CFrame=snapTarget; h.AssemblyLinearVelocity=Vector3.zero; h.AssemblyAngularVelocity=Vector3.zero end end end
            for _,o in pairs(workspace:GetChildren()) do if o.Name=="CoreProjectile" and o:IsA("BasePart") then if not (localplayer.Character and o:IsDescendantOf(localplayer.Character)) then o.CFrame=snapTarget; o.AssemblyLinearVelocity=Vector3.zero end end end
            for p in pairs(slingProjs) do if p and p.Parent then p.CFrame=snapTarget; p.AssemblyLinearVelocity=Vector3.zero else slingProjs[p]=nil end end
        end)
    end)
end
getgenv().stopSlingRage=function()
    if slingRageConn then slingRageConn:Disconnect(); slingRageConn=nil end
    if slingProjA then slingProjA:Disconnect(); slingProjA=nil end
    if slingProjB then slingProjB:Disconnect(); slingProjB=nil end; slingProjs={}
end

local apConn,apProjA,apProjB; local apTarget=CFrame.new(999999,999999,999999); local apProjs={}
getgenv().startAntiProj=function()
    if apConn then apConn:Disconnect() end
    apProjA=workspace.ChildAdded:Connect(function(o) if not o:IsA("BasePart") then return end; if localplayer.Character and o:IsDescendantOf(localplayer.Character) then return end; if o.Name=="CoreProjectile" then apProjs[o]=true elseif o.Name=="Part" then task.defer(function() if o and o.Parent and o.AssemblyLinearVelocity.Magnitude>50 then apProjs[o]=true end end) end end)
    apProjB=workspace.ChildRemoved:Connect(function(o) apProjs[o]=nil end)
    apConn=RunService.Heartbeat:Connect(function()
        if not config.antiProj then return end
        pcall(function()
            for _,p in pairs(Players:GetPlayers()) do if p~=localplayer and p.Character then local h=p.Character:FindFirstChild("HumanoidRootPart"); if h then h.CFrame=apTarget; h.AssemblyLinearVelocity=Vector3.zero; h.AssemblyAngularVelocity=Vector3.zero end end end
            for _,o in pairs(workspace:GetChildren()) do if o.Name=="CoreProjectile" and o:IsA("BasePart") then if not (localplayer.Character and o:IsDescendantOf(localplayer.Character)) then o.CFrame=apTarget; o.AssemblyLinearVelocity=Vector3.zero end end end
            for p in pairs(apProjs) do if p and p.Parent then p.CFrame=apTarget; p.AssemblyLinearVelocity=Vector3.zero else apProjs[p]=nil end end
        end)
    end)
end
getgenv().stopAntiProj=function()
    if apConn then apConn:Disconnect(); apConn=nil end
    if apProjA then apProjA:Disconnect(); apProjA=nil end
    if apProjB then apProjB:Disconnect(); apProjB=nil end; apProjs={}
end

local antiCloseConn=nil
getgenv().startAntiClose=function()
    if antiCloseConn then antiCloseConn:Disconnect() end
    antiCloseConn=RunService.Heartbeat:Connect(function()
        if not config.antiClose then return end; local hrp=getHrp(); if not hrp then return end
        for _,plr in ipairs(Players:GetPlayers()) do if plr~=localplayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then if (hrp.Position-plr.Character.HumanoidRootPart.Position).Magnitude<20 then hrp.CFrame=hrp.CFrame+hrp.CFrame.LookVector*60+Vector3.new(0,30,0); break end end end
    end)
end
getgenv().stopAntiClose=function() if antiCloseConn then antiCloseConn:Disconnect(); antiCloseConn=nil end end

getgenv().startFastReload=function()
    local ok,ItemLibrary=pcall(function() return require(ReplicatedStorage:WaitForChild("Modules",5):WaitForChild("ItemLibrary",5)) end)
    if not ok or not ItemLibrary then ok,ItemLibrary=pcall(function() return require(ReplicatedStorage:FindFirstChild("ItemLibrary",true)) end) end
    if not ok or not ItemLibrary then return end
    local Items=rawget(ItemLibrary,"Items"); if not Items then return end
    task.spawn(function()
        while config.fastReload do
            for _,Item in pairs(Items) do pcall(function()
                local iname=(Item.Name or ""):lower(); local speed=0
                if iname:find("dagger") or iname:find("knife") or iname:find("blade") then speed=0.05
                elseif iname:find("bow") or iname:find("arrow") then speed=0.1
                elseif iname:find("chainsaw") or iname:find("saw") then speed=0
                elseif iname:find("sling") or iname:find("shot") then speed=0.05 end
                rawset(Item,"ReloadLength",speed); rawset(Item,"FireRate",0); rawset(Item,"Cooldown",0)
                rawset(Item,"AttackCooldown",0); rawset(Item,"SwingCooldown",0); rawset(Item,"ThrowCooldown",0)
                rawset(Item,"RecoverTime",0); rawset(Item,"WindupTime",0); rawset(Item,"DeployTime",0); rawset(Item,"EquipTime",0)
            end) end
            task.wait(0.08)
        end
    end)
end
getgenv().stopFastReload=function() config.fastReload=false end

local lastShootTime=0
local function handleWallbang()
    if not config.wallbangEnabled then return end
    local cl=getClosest(); local hrp=getHrp(); local char=localplayer.Character
    if not (cl and cl.Character and cl.Character:FindFirstChild("Head") and hrp and char) then return end
    local hd=cl.Character.Head; local cam=workspace.CurrentCamera
    cam.CFrame=CFrame.lookAt(cam.CFrame.Position,hd.Position)
    local rp=RaycastParams.new(); rp.FilterType=Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances={localplayer.Character,cl.Character}
    local hit=workspace:Raycast(cam.CFrame.Position,hd.Position-cam.CFrame.Position,rp)
    local t=char:FindFirstChildOfClass("Tool"); if t then t:Activate() end
    if not hit and tick()-lastShootTime>0.05 then
        lastShootTime=tick()
        pcall(function()
            if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then local center=cam.ViewportSize/2; if firetouchtap then firetouchtap(center) elseif touchtap then touchtap(center) end
            else if mouse1click then mouse1click() else VirtualUser:ClickButton1(Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)) end end
        end)
    end
end
getgenv().startWallbang=function() RunService:BindToRenderStep("WbAimFix",Enum.RenderPriority.Camera.Value+1,handleWallbang) end
getgenv().stopWallbang=function() RunService:UnbindFromRenderStep("WbAimFix") end

local rapidFireConn=nil
getgenv().startRapidFire=function()
    if rapidFireConn then rapidFireConn:Disconnect() end
    rapidFireConn=RunService.Heartbeat:Connect(function() if config.rapidFire then local t=localplayer.Character and localplayer.Character:FindFirstChildOfClass("Tool"); if t then t:Activate() end end end)
end
getgenv().stopRapidFire=function() if rapidFireConn then rapidFireConn:Disconnect(); rapidFireConn=nil end end

local autocollectConn,homeConn,loopConn,safeZoneConn=nil,nil,nil,nil
getgenv().startAutocollect=function()
    if autocollectConn then autocollectConn:Disconnect() end
    autocollectConn=RunService.Heartbeat:Connect(function()
        if not config.autocollectEnabled or not getHrp() then return end
        local best,minD=nil,math.huge
        for _,o in ipairs(workspace:GetDescendants()) do
            local n=o.Name:lower()
            if n:find("heal") or n:find("health") or n:find("medkit") or n:find("bandage") then
                local p=o:IsA("Model") and (o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")) or (o:IsA("BasePart") and o or nil)
                if p then local d=(p.Position-getHrp().Position).Magnitude; if d<minD and d<=config.autocollectRadius then minD=d; best=p.Position end end
            end
        end
        if best then safeTeleport(best) end
    end)
end
getgenv().stopAutocollect=function() if autocollectConn then autocollectConn:Disconnect(); autocollectConn=nil end end

getgenv().startReturnHome=function()
    if homeConn then homeConn:Disconnect() end
    if not getgenv().homePosition and getHrp() then getgenv().homePosition=getHrp().Position end; local lastRet=0
    homeConn=RunService.Heartbeat:Connect(function()
        if not config.returnHomeEnabled or not getHrp() or not getgenv().homePosition then return end
        if (getHrp().Position-getgenv().homePosition).Magnitude>50 and (tick()-lastRet)>=config.homeReturnDelay then lastRet=tick(); safeTeleport(getgenv().homePosition) end
    end)
end
getgenv().stopReturnHome=function() if homeConn then homeConn:Disconnect(); homeConn=nil end end

getgenv().startSafeZone=function()
    if safeZoneConn then safeZoneConn:Disconnect() end
    safeZoneConn=RunService.Heartbeat:Connect(function()
        if not getHrp() then return end
        if getHrp().Position.Y>config.safeZoneY then getgenv().safeZoneSavedPos=getHrp().Position
        elseif config.safeZoneEnabled and getgenv().safeZoneSavedPos then getHrp().CFrame=CFrame.new(getgenv().safeZoneSavedPos) end
    end)
end
getgenv().stopSafeZone=function() if safeZoneConn then safeZoneConn:Disconnect(); safeZoneConn=nil end end

getgenv().startTeleportLoop=function()
    if loopConn then pcall(task.cancel,loopConn) end; config.teleportLoopEnabled=true
    loopConn=task.spawn(function()
        while config.teleportLoopEnabled do
            if #getgenv().loopWaypoints>0 and getHrp() then local t=getgenv().loopWaypoints[getgenv().loopIndex]; if t then safeTeleport(t) end; getgenv().loopIndex=(getgenv().loopIndex%#getgenv().loopWaypoints)+1 end
            task.wait(config.teleportLoopDelay)
        end
    end)
end
getgenv().stopTeleportLoop=function() config.teleportLoopEnabled=false; if loopConn then pcall(task.cancel,loopConn); loopConn=nil end end

local antiAfkConn=nil
getgenv().startAntiAfk=function()
    if antiAfkConn then antiAfkConn:Disconnect() end
    antiAfkConn=localplayer.Idled:Connect(function()
        if config.antiAfkEnabled then VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame); task.wait(1); VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end
    end)
end
getgenv().stopAntiAfk=function() if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn=nil end end

local flyConn=nil
getgenv().startFly=function()
    if flyConn then flyConn:Disconnect() end
    flyConn=RunService.Heartbeat:Connect(function(dt)
        local tHrp=getHrp(); if not tHrp or not config.flyEnabled then return end
        local h=localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Physics) end
        local c=workspace.CurrentCamera; local md=Vector3.zero
        if h and h.MoveDirection.Magnitude>0 then local fl=Vector3.new(c.CFrame.LookVector.X,0,c.CFrame.LookVector.Z); md=fl.Magnitude>0.001 and Vector3.new(h.MoveDirection.X,c.CFrame.LookVector.Y*h.MoveDirection:Dot(fl.Unit),h.MoveDirection.Z) or Vector3.new(h.MoveDirection.X,c.CFrame.LookVector.Y,h.MoveDirection.Z) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then md=md+Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then md=md-Vector3.new(0,1,0) end
        tHrp.AssemblyLinearVelocity=Vector3.zero; tHrp.AssemblyAngularVelocity=Vector3.zero
        if md.Magnitude>0 then tHrp.CFrame=tHrp.CFrame+(md.Unit*(config.flySpeed*dt)) end
    end)
end
getgenv().stopFly=function()
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    if getHrp() then getHrp().AssemblyLinearVelocity=Vector3.zero; getHrp().AssemblyAngularVelocity=Vector3.zero end
    local h=localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h:ChangeState(Enum.HumanoidStateType.GettingUp) end
end

local underMapConn=nil
getgenv().startUnderMap=function()
    if underMapConn then underMapConn:Disconnect() end
    underMapConn=RunService.Heartbeat:Connect(function()
        if not config.underMapEnabled or not getHrp() then return end
        if localplayer.Character then for _,p in ipairs(localplayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
        local hrp=getHrp(); hrp.CFrame=CFrame.new(hrp.Position.X,config.underMapY,hrp.Position.Z)
    end)
end
getgenv().stopUnderMap=function() if underMapConn then underMapConn:Disconnect(); underMapConn=nil end end

table.insert(getgenv().AllConnections,RunService.Stepped:Connect(function()
    if config.nc and localplayer.Character then for _,p in ipairs(localplayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
end))
table.insert(getgenv().AllConnections,RunService.Heartbeat:Connect(function()
    if config.antiAimEnabled and getHrp() then getHrp().CFrame=getHrp().CFrame*CFrame.Angles(math.rad(config.pitchAngle),math.rad(config.yawAngle),0) end
    if config.spinEnabled and getHrp() then getHrp().CFrame=getHrp().CFrame*CFrame.Angles(0,math.rad(math.random(-180,180)),0); getHrp().AssemblyLinearVelocity=Vector3.new(math.random(-200,200),250,math.random(-200,200))*45 end
end))

-- BYPASS L9: CHARACTER RESPAWN — re-start active features after death
localplayer.CharacterAdded:Connect(function(char)
    task.wait(0.5); if not getgenv().nzrx_loaded then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); if not hum or not config then return end
    if config.flyEnabled       then pcall(getgenv().startFly)         end
    if config.glideEnabled     then pcall(getgenv().startGlide)       end
    if config.orbit            then pcall(getgenv().startOrbit)       end
    if config.voidSpamEnabled  then pcall(getgenv().startVoidSpam)    end
    if config.VoidEnabled      then pcall(getgenv().startVoid)        end
    if config.evasionEnabled   then pcall(getgenv().startEvasion)     end
    if config.blinkEnabled     then pcall(getgenv().startBlink)       end
    if config.ghostEnabled     then pcall(getgenv().startGhost)       end
    if config.underMapEnabled  then pcall(getgenv().startUnderMap)    end
    if config.riotAbuserEnabled   then pcall(getgenv().startRiotAbuser)  end
    if config.riotBypassEnabled   then pcall(getgenv().startRiotBypass)  end
    if config.slingRage           then pcall(getgenv().startSlingRage)   end
    if config.antiProj            then pcall(getgenv().startAntiProj)    end
    if config.antiClose           then pcall(getgenv().startAntiClose)   end
    if config.teleportEnemyEnabled then pcall(getgenv().startTp)        end
end)

-- ================================================================
-- LINORIA UI — MOBILE TOUCH SYSTEM (enhanced, +12px hitboxes)
-- ================================================================
local MobileRegistry={}
local lastGlobalTouch=0
local registered={}

local function isActuallyVisible(obj)
    local curr=obj
    while curr and curr~=CoreGui do
        if curr:IsA("GuiObject") and not curr.Visible then return false end
        curr=curr.Parent
    end
    return true
end

local function getElemObj(elem)
    return rawget(elem,"Container") or rawget(elem,"Frame") or rawget(elem,"Main") or rawget(elem,"TextButton") or rawget(elem,"Button")
        or elem.Container or elem.Frame or elem.Main or elem.TextButton
end

local function regTouch(elem,elemType)
    if not elem or registered[elem] then return end
    registered[elem]=true
    table.insert(MobileRegistry,{Elem=elem,Type=elemType})
end

UserInputService.InputBegan:Connect(function(input,processed)
    if input.UserInputType~=Enum.UserInputType.Touch then return end
    pcall(function() if Library and Library.Outer and not Library.Outer.Visible then return end end)
    local now=tick(); if now-lastGlobalTouch<0.12 then return end
    local pos=input.Position
    for _,entry in ipairs(MobileRegistry) do
        local elem=entry.Elem
        local obj=getElemObj(elem)
        if obj and obj.AbsoluteSize.X>0 and isActuallyVisible(obj) then
            local ap=obj.AbsolutePosition; local as=obj.AbsoluteSize
            if pos.X>=ap.X-12 and pos.X<=ap.X+as.X+12 and pos.Y>=ap.Y-12 and pos.Y<=ap.Y+as.Y+12 then
                lastGlobalTouch=now
                if entry.Type=="Toggle" and elem.SetValue and elem.Value~=nil then pcall(function() elem:SetValue(not elem.Value) end)
                elseif entry.Type=="Button" and elem.Func then pcall(elem.Func) end
                break
            end
        end
    end
end)

local function patchElementTouch(elem,elemType)
    if not elem or type(elem)~="table" then return end
    pcall(function() if elemType=="Toggle" or elemType=="Button" then regTouch(elem,elemType) end end)
    return elem
end

local function T(section,key,label,cb)
    local elem=section:AddToggle(key,{Text=label,Default=getgenv().config[key] or false,Callback=function(v) getgenv().config[key]=v; if cb then cb(v) end end})
    patchElementTouch(elem,"Toggle"); return elem
end
local function S(section,key,label,min,max,def,rnd,cb)
    local elem=section:AddSlider(key,{Text=label,Min=min,Max=max,Default=def,Rounding=rnd or 0,Compact=false,Callback=function(v) config[key]=v; if cb then cb(v) end end})
    patchElementTouch(elem,"Slider"); return elem
end
local function D(section,key,label,values,def,cb)
    local elem=section:AddDropdown(key,{Text=label,Values=values,Default=def,Callback=function(v) config[key]=v; if cb then cb(v) end end})
    patchElementTouch(elem,"Dropdown"); return elem
end

-- ── MAIN TAB ──────────────────────────────────────────────────
local MoveSec=Tabs.Main:AddLeftGroupbox("Movement")
T(MoveSec,"flyEnabled","Fly",function(v) if v then getgenv().startFly() else getgenv().stopFly() end end)
S(MoveSec,"flySpeed","Fly Speed",1,2000,50,0,function() end)
T(MoveSec,"nc","Noclip",function() end)
T(MoveSec,"doubleJumpEnabled","Double Jump",function() end)
T(MoveSec,"fakePositionEnabled","Fake Position",function(v) if v then getgenv().startFakePosition() else getgenv().stopFakePosition() end end)
T(MoveSec,"desyncEnabled","Velocity Desync",function(v) if v then getgenv().startDesync() else getgenv().stopDesync() end end)
T(MoveSec,"glideEnabled","Glide",function(v) if v then getgenv().startGlide() else getgenv().stopGlide() end end)
S(MoveSec,"glideSpeed","Glide Speed",10,5000,280,0,function() end)
S(MoveSec,"glideAccel","Glide Accel",1,100,18,0,function() end)

local CombatSec=Tabs.Main:AddRightGroupbox("Combat")
T(CombatSec,"wallbangEnabled","Wallbang Aim",function(v) if v then getgenv().startWallbang() else getgenv().stopWallbang() end end)
T(CombatSec,"rapidFire","Rapid Fire",function(v) if v then getgenv().startRapidFire() else getgenv().stopRapidFire() end end)
T(CombatSec,"teleportEnemyEnabled","Teleport to Enemy (HvH)",function(v) if v then getgenv().startTp() else getgenv().stopTp() end end)
S(CombatSec,"chainsawBurstCount","Chainsaw Burst Count",1,8,3,0,function() end)
S(CombatSec,"chainsawVerticalOffset","TP Vertical Offset",-5,5,0,1,function() end)
T(CombatSec,"fastReload","Fast Reload (All Weapons)",function(v) if v then getgenv().startFastReload() else getgenv().stopFastReload() end end)
T(CombatSec,"daggerBypass","Dagger / Bow / Saw Bypass",function() end)
T(CombatSec,"weaponBypassAllModes","Bypass All Game Modes",function() end)
T(CombatSec,"antiClose","Anti Close",function(v) if v then getgenv().startAntiClose() else getgenv().stopAntiClose() end end)

-- ── COMBAT TAB ────────────────────────────────────────────────
local AntiAimSec=Tabs.Combat:AddLeftGroupbox("Anti-Aim")
T(AntiAimSec,"antiAimEnabled","Anti Aim",function() end)
S(AntiAimSec,"pitchAngle","Pitch Shift",-180,180,0,0,function() end)
S(AntiAimSec,"yawAngle","Yaw Shift",-180,180,0,0,function() end)
T(AntiAimSec,"spinEnabled","Spin Bypass",function() end)
T(AntiAimSec,"underMapEnabled","Underground",function(v) if v then getgenv().startUnderMap() else getgenv().stopUnderMap() end end)
S(AntiAimSec,"underMapY","Underground Depth",-5000,-50,-500,0,function() end)

local OrbitSec=Tabs.Combat:AddLeftGroupbox("Orbit")
T(OrbitSec,"orbit","Orbit Mode",function(v) if v then getgenv().startOrbit() else getgenv().stopOrbit() end end)
S(OrbitSec,"orbitSpeed","Speed (deg/s)",10,720,90,0,function() end)
S(OrbitSec,"orbitDistance","Radius",1,5000,8,0,function() end)
S(OrbitSec,"orbitHeight","Height Offset",-100,100,0,0,function() end)
OrbitSec:AddSlider("orbitPredictionPct",{Text="Predictive Lead",Min=0,Max=100,Default=12,Rounding=0,Callback=function(v) config.orbitPrediction=v/100 end})
D(OrbitSec,"orbitDirLabel","Direction",{"Clockwise","Counter-Clockwise"},"Clockwise",function(v) config.orbitDir=(v=="Clockwise") and 1 or -1 end)

local AntiHitSec=Tabs.Combat:AddRightGroupbox("Anti-Hit")
T(AntiHitSec,"slingRage","Slingshot Ragebot",function(v) if v then getgenv().startSlingRage() else getgenv().stopSlingRage() end end)
T(AntiHitSec,"antiProj","Anti Projectile",function(v) if v then getgenv().startAntiProj() else getgenv().stopAntiProj() end end)

local RiotAbuserSec=Tabs.Combat:AddRightGroupbox("Riot Abuser")
T(RiotAbuserSec,"riotAbuserEnabled","Riot Abuser",function(v) if v then getgenv().startRiotAbuser() else getgenv().stopRiotAbuser() end end)
S(RiotAbuserSec,"riotAbuserDistance","Spread",10,1000,300,0,function() end)
S(RiotAbuserSec,"riotAbuserX","X Jitter",0,200,30,0,function() end)
S(RiotAbuserSec,"riotAbuserY","Y Jitter",0,100,8,0,function() end)
S(RiotAbuserSec,"riotAbuserZ","Z Jitter",0,200,30,0,function() end)
S(RiotAbuserSec,"riotAbuserSpin","Spin Speed",0,2000,720,0,function() end)

local RiotBypassSec=Tabs.Combat:AddRightGroupbox("Riot Bypass")
T(RiotBypassSec,"riotBypassEnabled","Riot Bypass",function(v) if v then getgenv().startRiotBypass() else getgenv().stopRiotBypass() end end)
S(RiotBypassSec,"riotBypassDistance","Distance",0,20,3,1,function() end)
S(RiotBypassSec,"riotBypassHeight","Height Offset",-20,20,0,1,function() end)
RiotBypassSec:AddSlider("riotBypassUpdateMs",{Text="Update Rate (ms)",Min=1,Max=500,Default=20,Rounding=0,Callback=function(v) config.riotBypassUpdate=v/1000 end})
D(RiotBypassSec,"riotBypassPosition","Position",{"Front","Back","Above","Below"},"Front",function(v) config.riotBypassPosition=v end)

-- ── MOVEMENT TAB ──────────────────────────────────────────────
local VoidSec=Tabs.Movement:AddLeftGroupbox("Void (Extreme)")
T(VoidSec,"VoidEnabled","Void Extreme",function(v) if v then getgenv().startVoid() else getgenv().stopVoid() end end)
S(VoidSec,"voidX","X Bound",1000,1e9,1e8,0,function() end)
S(VoidSec,"voidY","Y Bound",1000,1e9,1e8,0,function() end)
S(VoidSec,"voidZ","Z Bound",1000,1e9,1e8,0,function() end)

local VoidSpamSec=Tabs.Movement:AddLeftGroupbox("Void Spam")
T(VoidSpamSec,"voidSpamEnabled","Void Spam",function(v) if v then getgenv().startVoidSpam() else getgenv().stopVoidSpam() end end)
VoidSpamSec:AddSlider("voidSpamIntervalMs",{Text="Interval (ms)",Min=5,Max=500,Default=16,Rounding=0,Callback=function(v) config.voidSpamInterval=v/1000 end})
S(VoidSpamSec,"voidSpamBurst","Burst Count",1,20,5,0,function() end)
S(VoidSpamSec,"voidXPos","X+ Offset",0,50000,2500,0,function() end)
S(VoidSpamSec,"voidXNeg","X- Offset",0,50000,2500,0,function() end)
S(VoidSpamSec,"voidYPos","Y+ Offset",0,50000,1500,0,function() end)
S(VoidSpamSec,"voidYNeg","Y- Offset",0,50000,1500,0,function() end)
S(VoidSpamSec,"voidZPos","Z+ Offset",0,50000,2500,0,function() end)
S(VoidSpamSec,"voidZNeg","Z- Offset",0,50000,2500,0,function() end)

local VoidPatternSec=Tabs.Movement:AddRightGroupbox("Void Pattern")
D(VoidPatternSec,"voidPattern","Pattern",{"random","spiral","wave","bounce","chaos","cross","helix","strobe"},"random",function() end)
T(VoidPatternSec,"voidAxisX","Axis X",function() end)
T(VoidPatternSec,"voidAxisY","Axis Y",function() end)
T(VoidPatternSec,"voidAxisZ","Axis Z",function() end)
T(VoidPatternSec,"voidSmooth","Smooth Mode",function() end)
VoidPatternSec:AddSlider("voidSmoothAlphaPct",{Text="Smooth Alpha",Min=1,Max=100,Default=50,Rounding=0,Callback=function(v) config.voidSmoothAlpha=v/100 end})

local EvasionSec=Tabs.Movement:AddRightGroupbox("Evasion / Blink / Ghost")
T(EvasionSec,"evasionEnabled","Evasion",function(v) if v then getgenv().startEvasion() else getgenv().stopEvasion() end end)
EvasionSec:AddSlider("evasionIntensityPct",{Text="Evasion Power",Min=10,Max=100,Default=30,Rounding=0,Callback=function(v) config.evasionIntensity=v/10 end})
T(EvasionSec,"blinkEnabled","Blink",function(v) if v then getgenv().startBlink() else getgenv().stopBlink() end end)
S(EvasionSec,"blinkRadius","Blink Range",10,300,80,0,function() end)
S(EvasionSec,"blinkRate","Blink Speed (snaps/s)",10,120,60,0,function() end)
T(EvasionSec,"ghostEnabled","Ghost",function(v) if v then getgenv().startGhost() else getgenv().stopGhost() end end)
S(EvasionSec,"ghostDistance","Ghost Gap",20,500,150,0,function() end)

-- ── UTILITIES TAB ─────────────────────────────────────────────
local AutoSec=Tabs.Utilities:AddLeftGroupbox("Automation")
T(AutoSec,"autocollectEnabled","Auto Collect Heals",function(v) if v then getgenv().startAutocollect() else getgenv().stopAutocollect() end end)
S(AutoSec,"autocollectRadius","Collect Radius",10,300,60,0,function() end)
T(AutoSec,"safeZoneEnabled","Safe Zone Rescue",function(v) if v then getgenv().startSafeZone() else getgenv().stopSafeZone() end end)
S(AutoSec,"safeZoneY","Void Y Threshold",-200,50,-10,0,function() end)
T(AutoSec,"returnHomeEnabled","Return Home",function(v) if v then getgenv().startReturnHome() else getgenv().stopReturnHome() end end)
AutoSec:AddButton("Save Home Position",function() if getHrp() then getgenv().homePosition=getHrp().Position; Notify("Home","Position saved.") end end)
AutoSec:AddSlider("homeReturnDelayX10",{Text="Return Delay (s)",Min=5,Max=150,Default=30,Rounding=0,Callback=function(v) config.homeReturnDelay=v/10 end})
T(AutoSec,"antiAfkEnabled","Anti AFK",function(v) if v then getgenv().startAntiAfk() else getgenv().stopAntiAfk() end end)

local LoopSec=Tabs.Utilities:AddRightGroupbox("Teleport Loop")
T(LoopSec,"teleportLoopEnabled","Teleport Loop",function(v) if v then getgenv().startTeleportLoop() else getgenv().stopTeleportLoop() end end)
LoopSec:AddSlider("teleportLoopDelayX100",{Text="Loop Delay (s)",Min=10,Max=1000,Default=150,Rounding=0,Callback=function(v) config.teleportLoopDelay=v/100 end})
LoopSec:AddButton("Add Waypoint",function() if getHrp() then table.insert(getgenv().loopWaypoints,getHrp().Position); Notify("Loop","Waypoint "..#getgenv().loopWaypoints.." added.") end end)
LoopSec:AddButton("Clear Waypoints",function() getgenv().loopWaypoints={}; getgenv().loopIndex=1; Notify("Loop","Cleared.") end)

-- ── PREDICTION TAB ────────────────────────────────────────────
local PredSec=Tabs.Prediction:AddLeftGroupbox("Engine")
PredSec:AddLabel("Applies to: Dagger, Slingshot, Orbit")
D(PredSec,"predictionMode","Mode",{"Linear","Quadratic","Extrapolate","Jerk"},"Linear",function() end)

local DaggerPredSec=Tabs.Prediction:AddLeftGroupbox("Dagger / Bow / Saw")
T(DaggerPredSec,"daggerPredictionEnabled","Enable Prediction",function() end)
S(DaggerPredSec,"daggerPredictFrames","Lead Frames",1,30,4,0,function() end)
S(DaggerPredSec,"daggerPredictSmoothing","Smoothing (%)",1,100,60,0,function() end)

local SlingPredSec=Tabs.Prediction:AddRightGroupbox("Sling Rage")
T(SlingPredSec,"slingPredictionEnabled","Enable Prediction",function() end)
S(SlingPredSec,"slingPredictFrames","Lead Frames",1,30,6,0,function() end)
S(SlingPredSec,"slingPredictSmoothing","Smoothing (%)",1,100,50,0,function() end)

-- ── SETTINGS TAB ──────────────────────────────────────────────
local CfgSec=Tabs.Settings:AddLeftGroupbox("Config Manager")
local profileInputVal=getActiveProfileName() or "Main"
CfgSec:AddInput("ProfileName",{Text="Profile Name",Default=profileInputVal,Numeric=false,Finished=false,Callback=function(v) profileInputVal=v end})
CfgSec:AddButton("Save Profile",function() local ok,msg=saveProfile(profileInputVal); Notify("Config",msg) end)
CfgSec:AddButton("Load Profile",function() local ok,msg=loadProfile(profileInputVal); Notify("Config",msg) end)
CfgSec:AddButton("Delete Profile",function() local ok,msg=deleteProfile(profileInputVal); Notify("Config",msg) end)
CfgSec:AddButton("Save Global Config",function() saveGlobalConfig(); Notify("Config","Saved.") end)
CfgSec:AddButton("Load Global Config",function() loadGlobalConfig(); Notify("Config","Loaded.") end)
CfgSec:AddButton("Reset to Defaults",function()
    getgenv().config={
        nc=false,flyEnabled=false,flySpeed=50,doubleJumpEnabled=false,fakePositionEnabled=false,desyncEnabled=false,
        evasionEnabled=false,evasionIntensity=3.0,blinkEnabled=false,blinkRadius=80,blinkRate=60,ghostEnabled=false,ghostDistance=150,
        glideEnabled=false,glideSpeed=280,glideAccel=18,VoidEnabled=false,voidX=1e8,voidY=1e8,voidZ=1e8,
        voidSpamEnabled=false,voidSpamInterval=0.016,voidSpamBurst=5,voidSmooth=false,voidSmoothAlpha=0.5,voidPattern="random",
        voidAxisX=true,voidAxisY=true,voidAxisZ=true,voidXPos=2500,voidXNeg=2500,voidYPos=1500,voidYNeg=1500,voidZPos=2500,voidZNeg=2500,
        orbit=false,orbitSpeed=90,orbitDistance=8,orbitHeight=0,orbitDir=1,orbitPrediction=0.12,
        wallbangEnabled=false,rapidFire=false,teleportEnemyEnabled=false,chainsawBurstCount=3,chainsawVerticalOffset=0.0,
        sling=false,daggerBypass=false,AntiEnemy=false,weaponBypassAllModes=true,
        slingRage=false,antiProj=false,fastReload=false,antiClose=false,
        antiAimEnabled=false,pitchAngle=0,yawAngle=0,spinEnabled=false,
        underMapEnabled=false,underMapY=-500,
        riotAbuserEnabled=false,riotAbuserDistance=300,riotAbuserX=30,riotAbuserY=8,riotAbuserZ=30,riotAbuserSpin=720,
        riotBypassEnabled=false,riotBypassDistance=3,riotBypassHeight=0,riotBypassUpdate=0.02,riotBypassPosition="Front",
        antiAfkEnabled=false,autocollectEnabled=false,autocollectRadius=60,returnHomeEnabled=false,homeReturnDelay=3.0,
        safeZoneEnabled=false,safeZoneY=-10,teleportLoopEnabled=false,teleportLoopDelay=1.5,
        daggerPredictionEnabled=false,daggerPredictFrames=4,daggerPredictSmoothing=60,
        slingPredictionEnabled=false,slingPredictFrames=6,slingPredictSmoothing=50,predictionMode="Linear",
        menuToggleKey="RightControl",lockToggleKey="L",autoLoadScript=false,
    }
    config=getgenv().config; syncUiWithConfig(); Notify("Config","Reset to defaults.")
end)

local CtrlSec=Tabs.Settings:AddRightGroupbox("Controls")
D(CtrlSec,"menuToggleKey","Menu Toggle Key",{"RightControl","LeftControl","Insert","Delete","RightShift","LeftShift","F8","P"},"RightControl",function(v)
    config.menuToggleKey=v; local key=Enum.KeyCode[v]; if key then menuKey=key; Notify("Keybind","Menu key: "..v) end
end)
D(CtrlSec,"lockToggleKey","Lock Key",{"L","K","O","P","F1","F2","RightAlt","LeftAlt"},"L",function(v)
    config.lockToggleKey=v; Notify("Keybind","Lock key: "..v)
end)
T(CtrlSec,"autoLoadScript","Autoload on Exec",function(v) config.autoLoadScript=v; saveGlobalConfig() end)

local SysSec=Tabs.Settings:AddRightGroupbox("System")
SysSec:AddButton("Unload Script",function()
    getgenv().nzrx_loaded=false
    getgenv().stopFly(); getgenv().stopFakePosition(); getgenv().stopDesync(); getgenv().stopRapidFire()
    getgenv().stopWallbang(); getgenv().stopTp(); getgenv().stopAntiAfk(); getgenv().stopVoid()
    getgenv().stopVoidSpam(); getgenv().stopOrbit(); getgenv().stopRiotAbuser(); getgenv().stopRiotBypass()
    getgenv().stopEvasion(); getgenv().stopBlink(); getgenv().stopGhost(); getgenv().stopAutocollect()
    getgenv().stopSafeZone(); getgenv().stopReturnHome(); getgenv().stopTeleportLoop()
    getgenv().stopSlingRage(); getgenv().stopAntiProj(); getgenv().stopAntiClose()
    getgenv().stopFastReload(); getgenv().stopGlide(); getgenv().stopUnderMap()
    if _spoofConn then _spoofConn:Disconnect(); _spoofConn=nil end
    for _,c in ipairs(getgenv().AllConnections) do pcall(function() c:Disconnect() end) end
    -- restore hooks in reverse order
    if getgenv()._nzrx_origFireServer then
        pcall(hookfunction,Instance.new("RemoteEvent").FireServer,getgenv()._nzrx_origFireServer)
        getgenv()._nzrx_origFireServer=nil
    end
    if getgenv()._bp_bindOrig then
        pcall(hookfunction,Instance.new("BindableEvent").Fire,getgenv()._bp_bindOrig)
        getgenv()._bp_bindOrig=nil
    end
    if getgenv()._bp_invokeOrig then
        pcall(hookfunction,Instance.new("RemoteFunction").InvokeServer,getgenv()._bp_invokeOrig)
        getgenv()._bp_invokeOrig=nil
    end
    if getgenv()._bp_fireOrig then
        pcall(hookfunction,Instance.new("RemoteEvent").FireServer,getgenv()._bp_fireOrig)
        getgenv()._bp_fireOrig=nil
    end
    if LockScreen then LockScreen:Destroy() end
    if MobileGui then pcall(function() MobileGui:Destroy() end) end
    Library:Unload()
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("nzrx/linoria_saves")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:BuildThemeSection(Tabs.Settings)

task.spawn(function() while task.wait(60) do if getgenv().nzrx_loaded then pcall(saveGlobalConfig) end end end)

Notify("nzrx online","Operator "..username.." — bypass+ baked in.")