--start code
local startTick = tick()
repeat task.wait(0.25) until game:IsLoaded();
local run = function(func) func() end
local cloneref = cloneref or function(obj) return obj end
local function safeRequire(path)
    local success, result = pcall(require, path)
    if not success then
        warn("[Require Error]:", path:GetFullName(), result)
        return nil
    end
    return result
end
if getgenv().SCRUNNED == true then return end;
getgenv().SCRUNNED = true
if identifyexecutor then
	if table.find({'Argon', 'Wave', 'Hyerin'}, ({identifyexecutor()})[1]) then
		getgenv().setthreadidentity = nil
	end
end
local queue_on_teleport = queue_on_teleport or function() end
local cliendID = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
local TextChatService = cloneref(game:GetService("TextChatService"))
local StatsService = cloneref(game:GetService("Stats"))
local RunService = cloneref(game:GetService('RunService'))
local UserInputService = cloneref(game:GetService('UserInputService'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local TweenService = cloneref(game:GetService('TweenService'))
local Players = cloneref(game:GetService("Players"))
local camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local PlayerScripts = player.PlayerScripts
if not player.Character or not player.Character.Parent then
    player.CharacterAdded:Wait()
end
local oldKick

local function safeExecute(func)
    local success, err = pcall(func)
    if not success then
        warn("Error occurred in safeExecute:", err)
    end
end

safeExecute(function()
    oldKick = hookfunction(player.Kick, newcclosure(function(self, ...)
        return
    end))
end)

local lastSendChatMessage = ""
local rbx_channel
safeExecute(function()
    rbx_channel = TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral")
end)
local function sendChatMessage(messageText)
	if not rbx_channel then return end
	local formatted = string.format('<b><font color="#A0A0A0">[</font><font color="#7160e8">Matrix Hub</font><font color="#A0A0A0">]</font>:</b> %s',messageText)
	rbx_channel:DisplaySystemMessage(formatted)
end

local loadstring = function(...)
	local res, err = loadstring(...)
	if err then
		sendChatMessage("Failed to load : "..err)
	end
	return res
end

getgenv()._aimState = {
    lastJitter = tick(),
    jitterX = 0,
    jitterY = 0,
    weight = 0,
    cooldown = 0,

    aimPart = "Head",
    nextSwitch = tick()
}

local Fluent = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
local SETTINGS_FILE = "MatrixhubSettings.json"
local defaultSettings = {
    AutoSave = false,
    Toggles = {
        ToggleAimbot = true,
        ToggleSilentAim = false,
        ToggleAutoFire = false,
        ToggleWallCheck = true,
        ToggleAntiKatana = false,
        ToggleNoCoolDown = false,
        ToggleNoRecoil = false,
        ToggleNoSpread = false,
        CustomBullet = true,
        humanAim = false,
        healthCheck = false,
        CheckTeams = false,
        WallCheck = false,
        DrawFov = false,
        FovSilent = false,
        ToggleBoxEsp = false,
        ToggleBoxFilled = false,
        ToggleChams = false,
        ToggleTracerEsp = false,
        ToggleToolName = false,
        ToggleNameEsp = false,
        DisplayNameChk = false,
        EspTeamCheck = false,
        EspTeamColor = true,
        FlyEnabled = false,
        CFrameWalk = false,
        ToggleAntiFling = false,
        ToggleInfJump = false,
        ToggleNoclip = false,
        CtrlTP = false,
        checkjarkup = false,
        AutoReExecute = true,
    },
    Values = {
        AimbotKeybind = "E",
        AimbotSmoothness = 1,
        AimPositionX = 2.5,
        AimPositionY = 2.5,
        DetectedCool = 0,
        SilentFovRadius = 100,
        FovRadius = 150,
        HitChance = 100,
        TracerRadius = 100,
        FlyKeybind = "Q",
        CFrameWalkKeybind = "H",
        FlySpeed = 50,
        WalkSpeed = 0,
    }
}

local Settings = {
    Current = table.clone(defaultSettings),
    Save = function(self)
        if not self.Current.AutoSave then return end
        local saveData = {
            AutoSave = self.Current.AutoSave,
            Toggles = self.Current.Toggles,
            Values = self.Current.Values
        }
        writefile(SETTINGS_FILE, game:GetService("HttpService"):JSONEncode(saveData))
    end,
    Load = function(self)
        if not isfile(SETTINGS_FILE) then return end
        local data = game:GetService("HttpService"):JSONDecode(readfile(SETTINGS_FILE))
        self.Current.AutoSave = data.AutoSave
        self.Current.Toggles = data.Toggles or defaultSettings.Toggles
        self.Current.Values = data.Values or defaultSettings.Values
    end
}

local function bindSave(element, category, key)
    element:OnChanged(function(value)
        if category == "Toggles" then
            Settings.Current.Toggles[key] = value
        elseif category == "Values" then
            Settings.Current.Values[key] = value
        end
        Settings:Save()
    end)
end

local endTick = tick()
----------------------------------------------

getgenv().Image = "rbxassetid://122042534314509" -- put a asset id in here to make it work
getgenv().ToggleUI = "RightControl"
getgenv().OpenUI = ""

task.spawn(function()
    if not getgenv().LoadedMobileUI == true then getgenv().LoadedMobileUI = true
        getgenv().OpenUI = Instance.new("ScreenGui");
        local ImageButton = Instance.new("ImageButton");
        local UICorner = Instance.new("UICorner");
        getgenv().OpenUI.Name = "OpenUI";
        getgenv().OpenUI.Parent = game:GetService("CoreGui");
        getgenv().OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        getgenv().OpenUI.Enabled = false;
        ImageButton.Parent = getgenv().OpenUI;
        ImageButton.BackgroundColor3 = Color3.fromRGB(105,105,105);
        ImageButton.BackgroundTransparency = 0.8
        ImageButton.Position = UDim2.new(0.1,0,0.3,0);
        ImageButton.Size = UDim2.new(0,50,0,50);
        ImageButton.Image = getgenv().Image;
        ImageButton.Draggable = true;
        ImageButton.Transparency = 1;
        UICorner.CornerRadius = UDim.new(0,200);
        UICorner.Parent = ImageButton;
        ImageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true,getgenv().ToggleUI,false,game);
        end)
    end
end)

local gui = Instance.new("ScreenGui");
gui.Name = "tracerUI";
gui.ResetOnSpawn = true;
gui.Parent = game:GetService("CoreGui");
gui.DisplayOrder = math.huge
local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local lastIsVisibleTick = tick()
local lastIsVisible = false
local KatanaDetected = false
local Rivals
run(function()
    if PlaceID ~= 17625359962 then return end 
    local ControllersFolder = PlayerScripts:WaitForChild("Controllers")

    Rivals = setmetatable({
        CONSTANTS = safeRequire(ReplicatedStorage.Modules.CONSTANTS),
        CosmeticLibrary = safeRequire(ReplicatedStorage.Modules.CosmeticLibrary),
        ReplicatedClass = safeRequire(ReplicatedStorage.Modules.ReplicatedClass),
        SoundLibrary = safeRequire(ReplicatedStorage.Modules.SoundLibrary),
        ItemLibrary = safeRequire(ReplicatedStorage.Modules.ItemLibrary),
        Utility = safeRequire(ReplicatedStorage.Modules.Utility),
        ClientViewModel = safeRequire(PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel),
        ItemUtility = safeRequire(ReplicatedStorage.Modules.ItemUtility),
        EnumLibrary = safeRequire(ReplicatedStorage.Modules.EnumLibrary),
        EnumBuilder = safeRequire(ReplicatedStorage.Modules.EnumBuilder),
        CoreGuiController = safeRequire(ControllersFolder:FindFirstChild("CoreGuiController")),
        ClientItem = safeRequire(PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem),
        Scene = safeRequire(PlayerScripts.Modules.UserInterface.Equipment.Scene),
    }, {
        __index = function(self, ind)
            local Controller = ControllersFolder:FindFirstChild(ind)
            if Controller and Controller:IsA('ModuleScript') then
                local module = safeRequire(Controller)
                rawset(self, ind, module)
                return module
            else
                Fluent:Notify{
                    Title = "Matrixhub.lua",
                    Content = "Unsupported Executor!!!",
                    SubContent = "You are not allowed to use the SILENT AIM feature!",
                    Duration = 10
                }
                warn(ind..' Controller not found')
            end
        end
    })
end)

local function sendNotification(messageText)
	if not Fluent then return end
	Fluent:Notify{
        Title = "Matrixhub.lua",
        Content = messageText,
        SubContent = "", 
        Duration = 3
    }
end

local inputHandlers = {}

local function cleanupInput(featureName)
    local handler = inputHandlers[featureName]
    if handler then
        if handler.beganConnection then
            handler.beganConnection:Disconnect()
            handler.beganConnection = nil
        end
        if handler.endedConnection then
            handler.endedConnection:Disconnect()
            handler.endedConnection = nil
        end
        if handler.stateLoop then
            handler.stateLoop:Disconnect()
            handler.stateLoop = nil
        end
        inputHandlers[featureName] = nil
    end
end

local function convertBind(bindString)
    if typeof(bindString) == "string" then
        if bindString:sub(1, 5) == "Left" then
            return Enum.UserInputType.MouseButton1
        elseif bindString:sub(1, 5) == "Right" then
            return Enum.UserInputType.MouseButton2
        else
            return Enum.KeyCode[bindString] 
        end
    end
    return bindString 
end

local function setupInput(featureName, bindOption, stateVariableName, toggleMode)
    cleanupInput(featureName)
    
    inputHandlers[featureName] = {}
    local handler = inputHandlers[featureName]
    local currentBind = convertBind(bindOption.Value)
    
    if toggleMode then
        getgenv()[stateVariableName] = false
        handler.lastState = false
    end

    if currentBind.EnumType == Enum.KeyCode then
        if toggleMode then
            handler.stateLoop = RunService.RenderStepped:Connect(function()
                local isDown = UserInputService:IsKeyDown(currentBind)
                if isDown and not handler.lastState then
                    getgenv()[stateVariableName] = not getgenv()[stateVariableName]
                    sendNotification(featureName .. " has been " .. (getgenv()[stateVariableName] and "Enabled" or "Disabled"))
                end
                handler.lastState = isDown
            end)
        else
            handler.stateLoop = RunService.RenderStepped:Connect(function()
                getgenv()[stateVariableName] = UserInputService:IsKeyDown(currentBind)
            end)
        end
        
    elseif currentBind.EnumType == Enum.UserInputType then
        if toggleMode then
            handler.beganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == currentBind and not handler.lastState then
                    getgenv()[stateVariableName] = not getgenv()[stateVariableName]
                    sendNotification(featureName .. " has been " .. (getgenv()[stateVariableName] and "Enabled" or "Disabled"))
                    handler.lastState = true
                end
            end)
            
            handler.endedConnection = UserInputService.InputEnded:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == currentBind then
                    handler.lastState = false
                end
            end)
        else
            getgenv()[stateVariableName] = false
            handler.beganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == currentBind then
                    getgenv()[stateVariableName] = true
                end
            end)
            
            handler.endedConnection = UserInputService.InputEnded:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == currentBind then
                    getgenv()[stateVariableName] = false
                end
            end)
        end
    end
    return true
end

local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)

if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end

local function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

local function isVisible(enemyCharacter)
    if tick() - lastIsVisibleTick < 0.1 then
        return lastIsVisible
    end
    local origin = camera.CFrame.Position
    
    local checkParts = {
        "Head",
    }

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character, camera}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    for _, name in ipairs(checkParts) do
        local part = enemyCharacter:FindFirstChild(name)
        if part then
            local direction = part.Position - origin
            local rayResult = workspace:Raycast(
                origin, 
                direction.Unit * direction.Magnitude,
                raycastParams
            )

            while rayResult do
                local hitInstance = rayResult.Instance
                
                if hitInstance:IsDescendantOf(enemyCharacter) then
                    lastIsVisible = true
                    lastIsVisibleTick = tick()
                    return true
                end
                
                if hitInstance.Name == "Bullet" then
                    origin = rayResult.Position + (direction.Unit * 0.1)
                    rayResult = workspace:Raycast(
                        origin,
                        direction.Unit * (direction.Magnitude - (origin - part.Position).Magnitude),
                        raycastParams
                    )
                else
                    break
                end
            end
        end
    end
    
    lastIsVisible = false
    lastIsVisibleTick = tick()
    return false
end

local function getAllPlayerNames()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    return playerNames
end

Settings:Load()

print([[
    MADE BY: Semi                         
    ______  ___________________________________  __
    ___   |/  /__    |__  __/__  __ \___  _/_  |/ /
    __  /|_/ /__  /| |_  /  __  /_/ /__  / __    / 
    _  /  / / _  ___ |  /   _  _, _/__/ /  _    |  
    /_/  /_/  /_/  |_/_/    /_/ |_| /___/  /_/|_|                                     
]])

getgenv().MatrixhubNameSaved = "MatrixHub.lua"
getgenv().MatrixhubVerSaved = "V4.0.3"
getgenv().isAimKeyPress = false
getgenv().ServerHob = function ()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

local Window = Fluent:CreateWindow({
    Title = "MatrixHub.lua",
    SubTitle = "By searchblox",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 360),
    MinSize = Vector2.new(470, 380),
    Acrylic = false,
    Theme = "Monokai Vibrant",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Home = Window:CreateTab({
        Title = "Home",
        Icon = "compass"
    }),
    Combat = Window:CreateTab({
        Title = "Aim Assist",
        Icon = "flame"
    }),
    SilentAim = Window:CreateTab({
        Title = "Silent Aim",
        Icon = "bolt",
    }),
    Visuals = Window:CreateTab({
        Title = "Visuals",
        Icon = "eye"
    }),
    Players = Window:CreateTab({
        Title = "Player",
        Icon = "phosphor-users-bold"
    }),
    Client = Window:CreateTab({
        Title = "Client",
        Icon = "hexagon"
    }),
    Settings = Window:CreateTab({
        Title = "Settings",
        Icon = "settings"
    })
}

local Options = Fluent.Options

run(function()
    local oldRaycast;
    local last_first_pos;
    local last_last_pos;
    local fireoffset, rand, delayCheck = CFrame.identity, Random.new(), tick()
    local getPlr = function()
        local entities = {};

        for _, child in workspace.GetChildren(workspace) do
            if child.FindFirstChildOfClass(child, "Humanoid") then
                table.insert(entities, child);
            elseif child.Name == "HurtEffect" then
                for _, hurt_player in child.GetChildren(child) do
                    if (hurt_player.ClassName ~= "Highlight") then
                        table.insert(entities, hurt_player);
                    end
                end
            end
        end
        return entities
    end
    local function IsWithinRadius(position)
        local ScreenPos = camera:WorldToViewportPoint(position)
        
        if ScreenPos.Z <= 0 or not Options.SilentFovRadius.Value then
            return false
        end
    
        local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        local screenPoint = Vector2.new(ScreenPos.X, ScreenPos.Y)
        return (screenPoint - screenCenter).Magnitude <= (tonumber(Options.SilentFovRadius.Value) or tonumber(Settings.Current.Values.SilentFovRadius) or 100)
    end
    local closestPlayer = function()
        if rand.NextNumber(rand, 0, 100) > (Options.HitChance.Value) then return end
        local closest, closest_distance = nil, math.huge
        local character = player.Character
        if not character then return end
    
        for _, enemy in ipairs(getPlr()) do
            if enemy ~= player and enemy:FindFirstChild("HumanoidRootPart") then
                local enemyRoot = enemy.HumanoidRootPart
                local screenPos, onScreen = camera:WorldToViewportPoint(enemyRoot.Position)
    
                if onScreen then
                    if IsWithinRadius(enemyRoot.Position) and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("Humanoid").Health > 0 then
                        local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
    
                        if distance < closest_distance then
                            closest = enemy
                            closest_distance = distance
                        end
                    end
                end
            end
        end
        return closest
    end
    local function fadeBullet(from, to)
        if (Options.CustomBullet and not Options.CustomBullet.Value) then return end
        if (not Rivals.CoreGuiController.LocalFighter.EquippedItem.Info.Type == "Gun") then return end
        local distance = (to - from).Magnitude
        local part = Instance.new("Part")
        part.Name = "Bullet"
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.Neon
        part.Color = Options.BulletColor and Options.BulletColor.Value or Color3.fromRGB(113, 96, 232)
        part.Size = Vector3.new(0.05, 0.05, distance)
        part.CFrame = CFrame.new(from, to) * CFrame.new(0, 0, -distance / 2)
    
        part.Parent = workspace
    
        task.spawn(function()
            for i = 1, 10 do
                part.Transparency = i / 10
                task.wait(0.05)
            end
            part:Destroy()
        end)
    end
    
    local function StartShooting(...)
        local args = {...}
        local closest = closestPlayer()
        last_first_pos = args[2]
        last_last_pos = args[3]
        if not closest then return oldRaycast(...) end
        if (closest) then
            local targetPart = (rand.NextNumber(rand, 0, 100) < (Options.ToggleAutoFire.Enabled and 100 or Options.HitChance.Value)) and 'Head' or 'HumanoidRootPart'
            args[3] = closest[targetPart].Position
            task.spawn(fadeBullet, last_first_pos + Vector3.new(0, -1.5, 0), args[3])
        end
        
        return oldRaycast(unpack(args,1,select("#",...)))
    end
    local Hook = function(...)
        local args = {...}
        if debug.info(5, "n") == "Input" and debug.info(4, "n") == "StartShooting" then
            if typeof(args[2]) == "Vector3" then
                return StartShooting(...)
            end
        end

        return oldRaycast(...)
    end
    local chkItem = function(closest)
        local plr = Players:GetPlayerFromCharacter(closest)
        
        local EquippedItem = Rivals.FighterController:GetFighter(plr).EquippedItem
        if EquippedItem then
            return 'None'
        end
        if EquippedItem and EquippedItem.Name then
            return EquippedItem.Name
        end
        return 'None'
    end
    local chkKatana = function(closest)
        if (Options.ToggleAntiKatana and not Options.ToggleAntiKatana.Value) then return true end
        local plr = Players:GetPlayerFromCharacter(closest)
        local DeflectCooldown = 0
        
        local EquippedItem = Rivals.FighterController:GetFighter(plr).EquippedItem
        if EquippedItem then
            DeflectCooldown = EquippedItem.Info.DeflectCooldown or 0
        end
        if EquippedItem and EquippedItem.Name and EquippedItem.Name == 'Katana' and EquippedItem._deflect_cooldown and tick() +
            DeflectCooldown < EquippedItem._deflect_cooldown then
            KatanaDetected = true
            return false
        end
        if EquippedItem and EquippedItem.Name and EquippedItem.Name == 'Riot Shield' then
            KatanaDetected = true
            return false
        end
        KatanaDetected = false
        return true
    end
    local chkTeam = function(closest)
        local plr = Players:GetPlayerFromCharacter(closest)
        
        local Data = Rivals.FighterController:GetFighter(plr).Data
        local lpData = Rivals.CoreGuiController.LocalFighter.Data
        if not Data then
            return true
        end
        
        if Data and Data.TeamID and lpData and lpData.TeamID and Data.TeamID == lpData.TeamID then
            return false
        end
        return true
    end

    local rankmeowmeow = "User"
    local savePing = 0
    local PingStats = "Good"
    if Players:GetUserIdFromNameAsync(player.Name) == 2759165852 then
        rankmeowmeow = "Owner"
    end

    sendChatMessage("MatrixHub.lua is Loaded!")
    
    Tabs.Home:CreateParagraph("welcome",{
        Title = "Welcome To " .. getgenv().MatrixhubNameSaved .. " " .. getgenv().MatrixhubVerSaved .. "!, " ..player.Name,
        Content = "We aim to meet your needs. For concerns, \nsuggestions, or bug reports, feel free to join our Discord.",
    })
    
    Tabs.Home:CreateParagraph("level",{
        Title = "Subscription Level",
        Content = rankmeowmeow
    })

    local PingCheck = Tabs.Home:CreateParagraph("ping",{
        Title = "Your ping " .. PingStats,
        Content = savePing.. " ms"
    })

    task.spawn(function()
        while true do
            wait(1.5)

            local networkStats = StatsService.Network.ServerStatsItem["Data Ping"]
            savePing = math.floor(networkStats:GetValue())
            if savePing <= 150 then
                PingStats = "Good"
            elseif savePing <= 250 and savePing > 150 then
                PingStats = "SoSo"
            elseif savePing <= 400 and savePing > 250 then
                PingStats = "Not Good"
            elseif savePing > 400 then
                PingStats = "Worst"
            end
            
            PingCheck:Destroy()
            PingCheck = Tabs.Home:CreateParagraph("ping",{
                Title = "Your ping " .. PingStats,
                Content = savePing.. " ms"
            })
            
            if Fluent.Unloaded then
                break
            end
        end
    end)

    local ToggleAimbot = Tabs.Combat:CreateToggle("ToggleAimbot", {
        Title = "Aimbot",
        --Description = "Automatically follow the selected body part of players when aiming",
        Default = getgenv().ToggleAimbot or true
    })
    ToggleAimbot:OnChanged(function()
        getgenv().ToggleAimbot = Options.ToggleAimbot.Value
    end)
    local AimPartDropdown = Tabs.Combat:CreateDropdown("AimPart", {
        Title = "Aimbot Part",
        --Description = "Choose which part of the body the aimbot locks onto: head, torso, or random",
        Values = {"Head", "Torso"},
        Multi = false, 
        Default = getgenv().AimPart or 1
    })
    AimPartDropdown:OnChanged(function()
        getgenv().AimPart = Options.AimPart.Value;
    end)
    local AimMovementDropdown = Tabs.Combat:CreateDropdown("Movement", {
        Title = "Movement",
        --Description = "Choose whether you want to move with the mouse or the camera",
        Values = {"Mouse", "Camera"},
        Multi = false,
        Default = getgenv().Movement or 1
    })
    AimMovementDropdown:OnChanged(function()
        getgenv().Movement = Options.Movement.Value
    end)
    local AimbotSettingSection = Tabs.Combat:CreateSection("Aimbot Setting")
    local aimInputConnectionBegan, aimInputConnectionEnded, keybindStateLoop
    
    local AimbotKeybind = AimbotSettingSection:CreateKeybind("AimbotKeybind", {
        Title = "Keybind",
        Description = "Hold down the key you set to activate the Aimbot",
        Mode = "Hold",
        Default = Settings.Current.Values.AimbotKeybind or getgenv().AimKeybind or "E",
    })

    AimbotKeybind:OnChanged(function()
        getgenv().AimKeybind = Options.AimbotKeybind.Value
        Settings.Current.Values["AimbotKeybind"] = Options.AimbotKeybind.Value
        Settings:Save()
        setupInput("Aimbot", Options.AimbotKeybind, "isAimKeyPress", false)
    end)

    local humanAim, healthCheck, CheckTeams, WallCheck, AimbotSmoothness

    humanAim = AimbotSettingSection:CreateToggle("humanAim", {
        Title = "Human Aim [SAFE]",
        --Description = "Our recommendation for use of this feature is a smoothness setting of 10\n이 기능을 사용할 시 Smoothness를 10으로 설정하는것을 권장합니다",
        Default = getgenv().HumanAim
    })
    humanAim:OnChanged(function()
        getgenv().HumanAim = Options.humanAim.Value
    end)
    healthCheck = AimbotSettingSection:CreateToggle("healthCheck", {
        Title = "Health Check",
        --Description = "Only target players who have health remaining",
        Default = getgenv().healthCheck
    })
    healthCheck:OnChanged(function()
        getgenv().healthCheck = Options.healthCheck.Value
    end)
    CheckTeams = AimbotSettingSection:CreateToggle("CheckTeams", {
        Title = "Team Check",
        --Description = "Only target players who are on the enemy team",
        Default = getgenv().CheckTeams
    })
    CheckTeams:OnChanged(function()
        getgenv().CheckTeams = Options.CheckTeams.Value
    end)
    WallCheck = AimbotSettingSection:CreateToggle("WallCheck", {
        Title = "Wall Check",
        --Description = "Prevents aiming at players hiding behind walls.",
        Default = getgenv().WallCheck
    })
    WallCheck:OnChanged(function()
        getgenv().WallCheck = Options.WallCheck.Value
    end)
    AimbotSmoothness = AimbotSettingSection:CreateSlider("AimbotSmoothness", {
        Title = "Smoothness",
        --Description = "Control how smoothly the aimbot locks onto targets",
        Default = Settings.Current.Values.AimbotSmoothness or getgenv().AimbotSmoothness or 1,
        Min = 1,
        Max = 10,
        Rounding = 1
    })
    AimbotSmoothness:OnChanged(function()
        getgenv().AimbotSmoothness = Options.AimbotSmoothness.Value
    end)
    bindSave(AimbotSmoothness, "Values", "AimbotSmoothness")

    local AimPositionX = AimbotSettingSection:CreateSlider("AimPositionX", {
        Title = "Aim PositionX",
        --Description = "Sets which x-coordinate to aim at\nDefault: 2.5",
        Default = Settings.Current.Values.AimPositionX or getgenv().AimPositionX or 2.5,
        Min = 0,
        Max = 5,
        Rounding = 1
    })
    AimPositionX:OnChanged(function()
        getgenv().AimPositionX = Options.AimPositionX.Value
    end)
    bindSave(AimPositionX, "Values", "AimPositionX")

    local AimPositionY = AimbotSettingSection:CreateSlider("AimPositionY", {
        Title = "Aim PositionY",
        --Description = "Sets which y-coordinate to aim at\nDefault: 2.5",
        Default = Settings.Current.Values.AimPositionY or getgenv().AimPositionY or 2.5,
        Min = 0,
        Max = 5,
        Rounding = 1
    })
    AimPositionY:OnChanged(function()
        getgenv().AimPositionY = Options.AimPositionY.Value
    end)
    bindSave(AimPositionY, "Values", "AimPositionY")

    local FovSettingSection = Tabs.Combat:CreateSection("Fov Setting")
    local DrawFov = FovSettingSection:CreateToggle("DrawFov", {
        Title = "Draw Fov",
        --Description = "Display the Field of View (Fov) circle, showing the area where the aimbot can lock onto targets",
        Default = getgenv().DrawFov
    })
    DrawFov:OnChanged(function()
        getgenv().DrawFov = Options.DrawFov.Value
    end)

    local FovRadius = FovSettingSection:CreateSlider("FovRadius", {
        Title = "Fov Radius",
        --Description = "Adjust the radius of the Field of View (Fov) to control how wide the aimbot's targeting area is",
        Default = Settings.Current.Values.FovRadius or getgenv().FovRadius or 150,
        Min = 1,
        Max = 1000,
        Rounding = 1
    })
    FovRadius:OnChanged(function()
        getgenv().FovRadius = Options.FovRadius.Value
    end)

    bindSave(FovRadius, "Values", "FovRadius")

    local FovColorPicker = FovSettingSection:CreateColorpicker("FovColor", {
        Title = "Fov Color",
        --Description = "Change the color of the Field of View (Fov) circle",
        Default = getgenv().FovColor or Color3.fromRGB(113,96,232)
    })

    FovColorPicker:OnChanged(function()
        getgenv().FovColor = Options.FovColor.Value
    end)

    local ToggleSilentAim = Tabs.SilentAim:CreateToggle("ToggleSilentAim", {
        Title = "Silent Aim",
        Description = "Rivals Only Support",
        Default = Settings.Current.Toggles.ToggleSilentAim or false
    })
    local ToggleAutoFire = Tabs.SilentAim:CreateToggle("ToggleAutoFire", {
        Title = "Auto Fire",
        Description = "",
        Default = Settings.Current.Toggles.ToggleAutoFire or false
    })
    local ToggleWallCheck = Tabs.SilentAim:CreateToggle("ToggleWallCheck", {
        Title = "Wall Check",
        Description = "",
        Default = Settings.Current.Toggles.ToggleWallCheck or true
    })
    local ToggleAntiKatana = Tabs.SilentAim:CreateToggle("ToggleAntiKatana", {
        Title = "Anti Katana",
        Description = "",
        Default = Settings.Current.Toggles.ToggleAntiKatana or false
    })
    local ToggleNoCoolDown = Tabs.SilentAim:CreateToggle("ToggleNoCoolDown", {
        Title = "No Cooldown",
        Description = "For safety, this feature overrides autosave",
        Default = Settings.Current.Toggles.ToggleNoCoolDown or false
    })
    local ToggleNoRecoil = Tabs.SilentAim:CreateToggle("ToggleNoRecoil", {
        Title = "No Recoil",
        Description = "For safety, this feature overrides autosave",
        Default = Settings.Current.Toggles.ToggleNoRecoil or false
    })
    local ToggleNoSpread = Tabs.SilentAim:CreateToggle("ToggleNoSpread", {
        Title = "No Spread",
        Description = "For safety, this feature overrides autosave",
        Default = Settings.Current.Toggles.ToggleNoSpread or false
    })

    local CustomBulletSection = Tabs.SilentAim:CreateSection("Custom Bullet")

    local CustomBullet = CustomBulletSection:CreateToggle("CustomBullet", {
        Title = "Custom Bullet",
        Description = "",
        Default = Settings.Current.Toggles.CustomBullet or false
    })

    local BulletColor = CustomBulletSection:CreateColorpicker("BulletColor", {
        Title = "Bullet Color",
        --Description = "Change the color of the Field of View (Fov) circle",
        Default = getgenv().BulletColor or Color3.fromRGB(113,96,232)
    })

    BulletColor:OnChanged(function()
        getgenv().BulletColor = Options.BulletColor.Value
    end)

    local SilentSettingSection = Tabs.SilentAim:CreateSection("Silent Settings")

    local DetectedCool = SilentSettingSection:CreateSlider("DetectedCool", {
        Title = "Detection time (ms)",
        Description = "This feature only takes effect when Auto Fire is true",
        Default = Settings.Current.Values.DetectedCool or 0,
        Min = 0,
        Max = 500,
        Rounding = 1
    })
    
    bindSave(DetectedCool, "Values", "DetectedCool")
    
    local FovSilent = SilentSettingSection:CreateToggle("FovSilent", {
        Title = "Silent Fov",
        --Description = "Display the Field of View (Fov) circle, showing the area where the aimbot can lock onto targets",
        Default = getgenv().FovSilent
    })
    
    local SilentFovRadius = SilentSettingSection:CreateSlider("SilentFovRadius", {
        Title = "Fov Radius",
        --Description = "Adjust the radius of the Field of View (Fov) to control how wide the aimbot's targeting area is",
        Default = Settings.Current.Values.SilentFovRadius or getgenv().SilentFovRadius or 100,
        Min = 1,
        Max = 1000,
        Rounding = 1
    })
    SilentFovRadius:OnChanged(function()
        getgenv().SilentFovRadius = Options.SilentFovRadius.Value
    end)
    
    bindSave(SilentFovRadius, "Values", "SilentFovRadius")
    
    local HitChance = SilentSettingSection:CreateSlider("HitChance", {
        Title = "Hit Chance",
        Default = Settings.Current.Values.HitChance or getgenv().HitChance or 100,
        Min = 1,
        Max = 100,
        Rounding = 1
    })
    HitChance:OnChanged(function()
        getgenv().HitChance = Options.HitChance.Value
    end)

    bindSave(HitChance, "Values", "HitChance")

    -------code---------

    ToggleSilentAim:OnChanged(function()
        if game.PlaceId ~= 17625359962 then return end
        if identifyexecutor() == "Solara" or identifyexecutor() == "Xeno"then
            return
        end
        if Options.ToggleSilentAim.Value then
            oldRaycast = Rivals.Utility.Raycast
            Rivals.Utility.Raycast = function(...)
                return Hook(...)
            end
    
            local inCooldown   = false
            local isShooting   = false
            local detectStart  = nil
            local lastSeen     = nil
            local GRACE_TIME   = 0.1

            repeat
                safeExecute(function()
                    if not (Options.ToggleAutoFire and Options.ToggleAutoFire.Value) then
                        inCooldown, isShooting, detectStart, lastSeen = false, false, nil, nil
                        return
                    end

                    local closest = closestPlayer()
                    local item    = Rivals.CoreGuiController.LocalFighter.EquippedItem

                    local detected = false
                    if closest and item and item.Info.Type == "Gun"
                    and chkTeam(closest) and IsWithinRadius(closest.HumanoidRootPart.Position)
                    and closest.Humanoid and closest.Humanoid.Health > 0 then

                        if Options.ToggleWallCheck.Value then
                            if isVisible(closest) and chkKatana(closest) then
                                detected = true
                            end
                        else
                            if chkKatana(closest) then
                                detected = true
                            end
                        end
                    end

                    local now = os.clock()

                    if detected then
                        lastSeen = now
                        if not detectStart then
                            detectStart = now
                        end

                        if not inCooldown and (now - detectStart) >= (Options.DetectedCool.Value / 1000) then
                            inCooldown = true
                            isShooting = true
                        end

                        if isShooting then
                            setthreadidentity(2)
                            Rivals.ClientItem.Input(item, 'StartShooting')
                            setthreadidentity(8)
                        end

                    else
                        if lastSeen and (now - lastSeen) >= GRACE_TIME then
                            if inCooldown or isShooting or detectStart then
                            end
                            inCooldown, isShooting, detectStart, lastSeen = false, false, nil, nil
                        end
                    end
                end)

                task.wait()
            until not Options.ToggleSilentAim.Value
        else
            if oldRaycast then
                Rivals.Utility.Raycast = oldRaycast
            end
            oldRaycast = nil
        end
    end)

    --------end---------

    local ToggleBoxEsp = Tabs.Visuals:CreateToggle("ToggleBoxEsp", {
        Title = "Box",
        --Description = "Enable or disable Box ESP, which draws a box around players to show their positions",
        Default = getgenv().ToggleBoxEsp
    })    
    ToggleBoxEsp:OnChanged(function()
        getgenv().ToggleBoxEsp = Options.ToggleBoxEsp.Value
    end)
    local ToggleChams = Tabs.Visuals:CreateToggle("ToggleChams", {
        Title = "Chams",
        Default = getgenv().ToggleChams
    })    
    ToggleChams:OnChanged(function()
        getgenv().ToggleChams = Options.ToggleChams.Value
    end)
    local ToggleTracerEsp = Tabs.Visuals:CreateToggle("ToggleTracerEsp", {
        Title = "Tracer",
        --Description = "Draws triangle from a customizable point on your screen to show the location of other players",
        Default = getgenv().ToggleTracerEsp
    })
    ToggleTracerEsp:OnChanged(function()
        getgenv().ToggleTracerEsp = Options.ToggleTracerEsp.Value
    end)
    local ToggleToolName = Tabs.Visuals:CreateToggle("ToggleToolName", {
        Title = "Tool name",
        Description = "Rivals Only Support",
        Default = getgenv().ToggleToolName
    })
    local ToggleNameEsp = Tabs.Visuals:CreateToggle("ToggleNameEsp", {
        Title = "Name",
        --Description = "Shows the names and health of players above their heads",
        Default = false
    })
    local DisplayNameChk = Tabs.Visuals:CreateToggle("DisplayNameChk", {
        Title = "DisplayName",
        --Description = "Shows the names and health of players above their heads",
        Default = false
    })
    DisplayNameChk:OnChanged(function()
        if Options.DisplayNameChk.Value then
            ToggleNameEsp:SetValue(false)
            task.wait()
            ToggleNameEsp:SetValue(true)
        end
    end)
    local ESPSettingSection = Tabs.Visuals:CreateSection("ESP Settings")
    local ToggleBoxFilled = ESPSettingSection:CreateToggle("ToggleBoxFilled", {
        Title = "Fill Box",
        --Description = "Fill the box with translucency",
        Default = Settings.Current.Toggles.ToggleBoxFilled
    })

    local TracerRadius = ESPSettingSection:CreateSlider("TracerRadius", {
        Title = "Tracer Radius",
        --Description = "Adjust the radius of the Field of View (Fov) to control how wide the tracer's showing area is",
        Default = Settings.Current.Values.TracerRadius or getgenv().TracerRadius or 100,
        Min = 0,
        Max = 1000,
        Rounding = 1
    })
    TracerRadius:OnChanged(function()
        getgenv().TracerRadius = Options.TracerRadius.Value
    end)

    bindSave(TracerRadius, "Values", "TracerRadius")

    local EspColorPicker = ESPSettingSection:CreateColorpicker("EspColor", {
        Title = "ESP Color",
        --Description = "Adjust the color used for ESP highlights, player names, and tracer lines",
        Default = getgenv().EspColor or Color3.fromRGB(113,96,232)
    })
    EspColorPicker:OnChanged(function()
        getgenv().EspColor = Options.EspColor.Value
    end)

    local EspTeamCheck = ESPSettingSection:CreateToggle("EspTeamCheck", {
        Title = "Team Check",
        --Description = "Secure the position of a team other than your current team",
        Default = getgenv().EspTeamCheck or false
    })
    EspTeamCheck:OnChanged(function()
        getgenv().EspTeamCheck = Options.EspTeamCheck.Value
    end)

    local EspTeamColor = ESPSettingSection:CreateToggle("EspTeamColor", {
        Title = "Team Color",
        --Description = "Depending on the team, the ESP color of the player belonging to that team is assigned the team color",
        Default = getgenv().EspTeamColor or true
    })
    EspTeamColor:OnChanged(function()
        getgenv().EspTeamColor = Options.EspTeamColor.Value
    end)

    local FlyEnabled = Tabs.Players:CreateToggle("FlyEnabled", {
        Title = "Fly",
        --Description = "This allows you to go faster at your own pace",
        Default = false
    })
    
    local CFrameWalk = Tabs.Players:CreateToggle("CFrameWalk", {
        Title = "CFrame Walk",
        --Description = "This allows you to go faster at your own pace",
        Default = false
    })
    
    local FlyKeybind = Tabs.Players:CreateKeybind("FlyKeybind", {
        Title = "Keybind",
        Description = "Fly",
        Mode = "Toggle",
        Default = Settings.Current.Values.FlyKeybind or getgenv().FlyKeybind or "Q",
    })
    
    local CFrameWalkKeybind = Tabs.Players:CreateKeybind("CFrameWalkKeybind", {
        Title = "Keybind",
        Description = "CFrame Walk",
        Mode = "Toggle",
        Default = Settings.Current.Values.CFrameWalkKeybind or getgenv().CFrameWalkKeybind or "H",
    })
    
    FlyKeybind:OnChanged(function()
        getgenv().FlyKeybind = Options.FlyKeybind.Value
        Settings.Current.Values["FlyKeybind"] = Options.FlyKeybind.Value
        Settings:Save()
        setupInput("FlyKeybind", Options.FlyKeybind, "isFLYKeyPress", true)
    end)

    CFrameWalkKeybind:OnChanged(function()
        getgenv().CFrameWalkKeybind = Options.CFrameWalkKeybind.Value
        Settings.Current.Values["CFrameWalkKeybind"] = Options.CFrameWalkKeybind.Value
        Settings:Save()
        setupInput("CFrameWalk", Options.CFrameWalkKeybind, "isCFameWalkKeyPress", true)
    end)

    local FlySpeed = Tabs.Players:CreateSlider("FlySpeed", {
        Title = "Fly Speed",
        --Description = "Choose how much to adjust the current speed",
        Default = Settings.Current.Values.FlySpeed or getgenv().FlySpeed or 50,
        Min = 0,
        Max = 150,
        Rounding = 1
    })

    bindSave(FlySpeed, "Values", "FlySpeed")

    local WalkSpeed = Tabs.Players:CreateSlider("WalkSpeed", {
        Title = "CFrame Speed",
        --Description = "Choose how much to adjust the current speed",
        Default = Settings.Current.Values.WalkSpeed or getgenv().WalkSpeed or 0,
        Min = 0,
        Max = 100,
        Rounding = 1
    })

    bindSave(WalkSpeed, "Values", "WalkSpeed")
    
    local PlayerSettingTab = Tabs.Players:CreateSection("Util")

    local ToggleAntiFling = PlayerSettingTab:CreateToggle("AntiFling", {
        Title = "Anti Fling",
        --Description = "If a fling is detected, it immediately returns to its previous safe position",
        Default = getgenv().AntiFling
    })
    ToggleAntiFling:OnChanged(function()
        getgenv().AntiFling = Options.AntiFling.Value
    end)

    local ToggleInfJump = PlayerSettingTab:CreateToggle("ToggleInfJump", {
        Title = "Inf Jump",
        --Description = "Allows continuous jumping mid-air",
        Default = getgenv().ToggleInfJump
    })
    ToggleInfJump:OnChanged(function()
        getgenv().ToggleInfJump = Options.ToggleInfJump.Value
    end)

    local ToggleNoclip = PlayerSettingTab:CreateToggle("ToggleNoclip", {
        Title = "Noclip",
        --Description = "When you move, you can pass through a wall in front of you",
        Default = getgenv().ToggleNoclip
    })
    ToggleNoclip:OnChanged(function()
        getgenv().ToggleNoclip = Options.ToggleNoclip.Value
    end)
    ----------------------------------------------

    Tabs.Client:CreateParagraph("executorinfo",{
        Title = "Executor: " .. identifyexecutor() or "Unknown" .. "",
    })

    Tabs.Client:CreateParagraph("hwidinfo",{
        Title = "HWID: " .. tostring(game:GetService("RbxAnalyticsService"):GetClientId()) or "Unknown" .. "",
    })  

    Tabs.Client:CreateParagraph("appver",{
        Title = "Application Version: " .. Version() or "Unknown" .. "",
    })

    local TeleportSection = Tabs.Client:CreateSection("Teleport")

    local PlayerDropdown, RefreshPlayerButton, TeleportPlayerButton, ToggleCtrlTP
    
    ToggleCtrlTP = TeleportSection:CreateToggle("CtrlTP", {
        Title = "CtrlTP",
        --Description = "",
        Default = getgenv().CtrlTP
    })

    PlayerDropdown = TeleportSection:CreateDropdown("PlayerDropdown", {
        Title = "Player Select",
        --Description = "You have the ability to teleport to any player of your choice",
        Values = getAllPlayerNames(),
        Multi = false,
        Default = getgenv().PlayerDropdown or 1
    })

    PlayerDropdown:OnChanged(function()
        getgenv().PlayerDropdown = Options.PlayerDropdown.Value
    end)

    ToggleCtrlTP:OnChanged(function()
        getgenv().CtrlTP = Options.CtrlTP.Value
    end)

    getgenv().RefreshTeleportTabs = function()
        PlayerDropdown:Destroy()
        PlayerDropdown = TeleportSection:CreateDropdown("PlayerDropdown", {
            Title = "Player Select",
            --Description = "You have the ability to teleport to any player of your choice",
            Values = getAllPlayerNames(),
            Multi = false,
            Default = getgenv().PlayerDropdown or 1
        })
        RefreshPlayerButton:Destroy()
        RefreshPlayerButton = TeleportSection:CreateButton({
            Title = "Refresh Player",
            --Description = "This button resets the player list",
            Callback = function()
                getgenv().RefreshTeleportTabs()
            end
        })

        TeleportPlayerButton:Destroy()
        TeleportPlayerButton = TeleportSection:CreateButton({
            Title = "Teleport to Players",
            --Description = "Instantly Teleport to Players",
            Callback = function()
                local localPlayer = Players.LocalPlayer
                local targetPlayer = Players:FindFirstChild(getgenv().PlayerDropdown)
    
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                        print("Teleported to " .. getgenv().PlayerDropdown)
                    end
                else
                    print("Target player or their HumanoidRootPart not found.")
                end
            end
        })

        PlayerDropdown:OnChanged(function()
            getgenv().PlayerDropdown = Options.PlayerDropdown.Value
        end)
    end

    RefreshPlayerButton = TeleportSection:CreateButton({
        Title = "Refresh Player",
        --Description = "This button resets the player list",
        Callback = function()
            getgenv().RefreshTeleportTabs()
        end
    })

    TeleportPlayerButton = TeleportSection:CreateButton({
        Title = "Teleport to Players",
        --Description = "Instantly Teleport to Players",
        Callback = function()
            local localPlayer = Players.LocalPlayer
            local targetPlayer = Players:FindFirstChild(getgenv().PlayerDropdown)

            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                    print("Teleported to " .. getgenv().PlayerDropdown)
                end
            else
                print("Target player or their HumanoidRootPart not found.")
            end
        end
    })

    local ServerSection = Tabs.Client:CreateSection("Server")

    ServerSection:CreateButton({
        Title = "Server Hop",
        --Description = "",
        Callback = function()
            Fluent:Notify({
                Title = getgenv().MatrixhubNameSaved,
                Content = "Reconnecting to another server shortly.",
                Duration = 5
            })
            getgenv().ServerHob()
        end
    })

    ServerSection:CreateButton({
        Title = "Rejoin Server",
        --Description = "",
        Callback = function()
            Fluent:Notify({
                Title = getgenv().MatrixhubNameSaved,
                Content = "Reconnecting to the current server shortly.",
                Duration = 5
            })
            game:GetService("TeleportService"):Teleport(game.PlaceId, player)
        end
    })

    local AnySettingSection = Tabs.Settings:CreateSection("System Setting")
    local checkjarkup = AnySettingSection:CreateToggle("checkjarkup", {
        Title = "Keep Working",
        --Description = "The current system can be kept running just the way it is",
        Default = getgenv().checkjarkup or false
    })
    local AutoSaveToggle = AnySettingSection:CreateToggle("AutoSave", {
        Title = "Auto Save Settings",
        --Description = "Beta system",
        Default = Settings.Current.AutoSave
    })
    AutoSaveToggle:OnChanged(function(value)
        Settings.Current.AutoSave = value
        Settings:Save()
    end)
    local AutoReExecuteToggle = AnySettingSection:CreateToggle("AutoReExecute", {
        Title = "Auto ReExecute",
        --Description = "",
        Default = Settings.Current.Toggles.AutoReExecute
    })
    AutoReExecuteToggle:OnChanged(function()
        if Options.AutoReExecute.Value then 
            queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/junkm012/roblox/main/Rivals.lua", true))()]]) 
        else 
            queue_on_teleport([[]])
        end
    end)
    local menuKeyBind = AnySettingSection:CreateKeybind("MenuKeybind", { Title = "Minimize Bind", Default = "RightControl" })
    Fluent.MinimizeKeybind = Options.MenuKeybind
    getgenv().ToggleUI = Options.MenuKeybind.Value
    task.spawn(function()
        while true do
            wait(0.1)
            getgenv().ToggleUI = Options.MenuKeybind.Value
            if Fluent.Unloaded then
                break
            end
        end
    end)
    local ThemeSettings = AnySettingSection:CreateDropdown("InterfaceTheme", {
        Title = "Theme",
        --Description = "Changes the interface theme.",
        Values = Fluent.Themes,
        Default = Fluent.Theme,
        Multi = false,
        Callback = function(Value)
            Fluent:SetTheme(Value)
        end
    })
    checkjarkup:OnChanged(function()
        getgenv().checkjarkup = Options.checkjarkup.Value
    end)

    ToggleAimbot:SetValue(Settings.Current.Toggles.ToggleAimbot)
    bindSave(ToggleAimbot, "Toggles", "ToggleAimbot")

    bindSave(ToggleSilentAim, "Toggles", "ToggleSilentAim")

    bindSave(ToggleAutoFire, "Toggles", "ToggleAutoFire")

    bindSave(ToggleAntiKatana, "Toggles", "ToggleAntiKatana")

    bindSave(CustomBullet, "Toggles", "CustomBullet")

    humanAim:SetValue(Settings.Current.Toggles.humanAim)
    bindSave(humanAim, "Toggles", "humanAim")

    healthCheck:SetValue(Settings.Current.Toggles.healthCheck)
    bindSave(healthCheck, "Toggles", "healthCheck")

    CheckTeams:SetValue(Settings.Current.Toggles.CheckTeams)
    bindSave(CheckTeams, "Toggles", "CheckTeams")

    WallCheck:SetValue(Settings.Current.Toggles.WallCheck)
    bindSave(WallCheck, "Toggles", "WallCheck")

    DrawFov:SetValue(Settings.Current.Toggles.DrawFov)
    bindSave(DrawFov, "Toggles", "DrawFov")

    FovSilent:SetValue(Settings.Current.Toggles.FovSilent)
    bindSave(FovSilent, "Toggles", "FovSilent")

    ToggleBoxEsp:SetValue(Settings.Current.Toggles.ToggleBoxEsp)
    bindSave(ToggleBoxEsp, "Toggles", "ToggleBoxEsp")

    ToggleBoxFilled:SetValue(Settings.Current.Toggles.ToggleBoxFilled)
    bindSave(ToggleBoxFilled, "Toggles", "ToggleBoxFilled")

    ToggleChams:SetValue(Settings.Current.Toggles.ToggleChams)
    bindSave(ToggleChams, "Toggles", "ToggleChams")

    ToggleTracerEsp:SetValue(Settings.Current.Toggles.ToggleTracerEsp)
    bindSave(ToggleTracerEsp, "Toggles", "ToggleTracerEsp")

    ToggleToolName:SetValue(Settings.Current.Toggles.ToggleToolName)
    bindSave(ToggleToolName, "Toggles", "ToggleToolName")

    ToggleNameEsp:SetValue(Settings.Current.Toggles.ToggleNameEsp)
    bindSave(ToggleNameEsp, "Toggles", "ToggleNameEsp")

    DisplayNameChk:SetValue(Settings.Current.Toggles.DisplayNameChk)
    bindSave(DisplayNameChk, "Toggles", "DisplayNameChk")

    EspTeamCheck:SetValue(Settings.Current.Toggles.EspTeamCheck)
    bindSave(EspTeamCheck, "Toggles", "EspTeamCheck")

    EspTeamColor:SetValue(Settings.Current.Toggles.EspTeamColor)
    bindSave(EspTeamColor, "Toggles", "EspTeamColor")

    FlyEnabled:SetValue(Settings.Current.Toggles.FlyEnabled)
    bindSave(FlyEnabled, "Toggles", "FlyEnabled")

    CFrameWalk:SetValue(Settings.Current.Toggles.CFrameWalk)
    bindSave(CFrameWalk, "Toggles", "CFrameWalk")

    ToggleAntiFling:SetValue(Settings.Current.Toggles.ToggleAntiFling)
    bindSave(ToggleAntiFling, "Toggles", "ToggleAntiFling")

    ToggleInfJump:SetValue(Settings.Current.Toggles.ToggleInfJump)
    bindSave(ToggleInfJump, "Toggles", "ToggleInfJump")

    ToggleNoclip:SetValue(Settings.Current.Toggles.ToggleNoclip)
    bindSave(ToggleNoclip, "Toggles", "ToggleNoclip")

    ToggleCtrlTP:SetValue(Settings.Current.Toggles.CtrlTP)
    bindSave(ToggleCtrlTP, "Toggles", "CtrlTP")

    checkjarkup:SetValue(Settings.Current.Toggles.checkjarkup)
    bindSave(checkjarkup, "Toggles", "checkjarkup")

    bindSave(AutoReExecuteToggle, "Toggles", "AutoReExecute")
end)

--SaveManager:SetLibrary(Fluent)
--SaveManager:SetIgnoreIndexes({})
--SaveManager:SetFolder("MatrixHub/bin")
--SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

--SaveManager:LoadAutoloadConfig()

if not getgenv().NyaNya then

    local UIS = game:GetService("UserInputService")
    local playerScripts = player:FindFirstChild("PlayerScripts")
    local mouse = player:GetMouse()
    local CtrlTPConnection, InfJumpConnection, flyConnections
    local aiming = false
    local currentTarget = nil
    local active = true
    local oldSpread;
    local oldRecoil;
    local oldCooldown;
    local lockedTarget = nil
    local triangles = {}
    local espBoxes = {}
    local highlights = {}
    local espConnections = {}
    local lastTicks = {}
    local running = true
    local systmp = true
    local XrayActivated = false
    local maxRaycastDistance = 300
    local nameHealthIndicators = {}
    local ToolNameIndicators = {}
    local lastclr = nil
    local silentFov = Drawing.new("Circle")
    local circleFov = Drawing.new("Circle")
    local antifling_VELOCITY_THRESHOLD = 85
    local antifling_ANGULAR_THRESHOLD = 25
    local antifling_lastSafeCFrame = nil
    local triangleImageId = "rbxassetid://9559112621"
    local FLYING = false
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, U = 0, D = 0}
    local SPEED = 0
    local flyKeyDown, flyKeyUp, flyConnection
    
    circleFov.Visible = Options.DrawFov.Value
    circleFov.Thickness = 1
    circleFov.Transparency = 1
    circleFov.Color = Options.FovColor.Value or Color3.fromRGB(255, 255, 255)
    circleFov.Filled = false
    silentFov.Visible = Options.FovSilent.Value
    silentFov.Thickness = 1
    silentFov.Transparency = 1
    silentFov.Color = Options.FovColor.Value or Color3.fromRGB(255, 255, 255)
    silentFov.Filled = false
    
    getgenv().StopScript = false

    CtrlTPConnection = UIS.InputBegan:Connect(function(input)
        if not systmp then CtrlTPConnection:Disconnect() end;
        if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) and Options.CtrlTP.Value then
            local Char = player.Character
            if Char then
                Char:MoveTo(mouse.Hit.p)
            end
        end
    end)

    local function getRoot(character)
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    end

    local chkItem = function(closest)
        local plr = Players:GetPlayerFromCharacter(closest)
        
        local EquippedItem = Rivals.FighterController:GetFighter(plr).EquippedItem
        if not EquippedItem then
            return "None"
        end
        if EquippedItem and EquippedItem.Name then
            return EquippedItem.Name
        end
        return "None"
    end

    local function createBoxEsp(character, teamColor)
        if espBoxes[character] then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local outline = Drawing.new("Square")
        outline.Thickness = 2
        outline.Color = Color3.new(0, 0, 0)
        outline.Filled = false
        outline.Visible = false
    
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Color = teamColor
        box.Filled = Options.ToggleBoxFilled.Value
        box.Transparency = Options.ToggleBoxFilled.Value and 0.5 or 1
        box.Visible = false
    
        local healthBackground = Drawing.new("Square")
        healthBackground.Filled = true
        healthBackground.Thickness = 2
        healthBackground.Color = Color3.fromRGB(0, 0, 0)
        healthBackground.Visible = false
    
        local healthBar = Drawing.new("Square")
        healthBar.Filled = true
        healthBar.Thickness = 1
        healthBar.Color = Color3.fromRGB(0, 255, 0)
        healthBar.Visible = false

        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not systmp then 
                box:Remove()
                outline:Remove()
                healthBar:Remove()
                healthBackground:Remove()
                if connection then connection:Disconnect() end
                espBoxes[character] = nil
                return
            end
            hrp = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChild("Humanoid")
            if not character or not hrp or not workspace:FindFirstChild(character.Name) then
                box:Remove()
                outline:Remove()
                healthBar:Remove()
                healthBackground:Remove()
                if connection then connection:Disconnect() end
                espBoxes[character] = nil
                return
            end
    
            if not head or not humanoid or humanoid.Health <= 0 then
                box:Remove()
                outline:Remove()
                healthBar:Remove()
                healthBackground:Remove()
                if connection then connection:Disconnect() end
                espBoxes[character] = nil
                return
            end
    
            local cam = workspace.CurrentCamera
            local torsoPos, torsoVisible = cam:WorldToViewportPoint(hrp.Position)
            local headPos, headVisible = cam:WorldToViewportPoint(head.Position)
            local feetWorld = hrp.Position - Vector3.new(0, humanoid.HipHeight + 2.5, 0)
            local feetPos, feetVisible = cam:WorldToViewportPoint(feetWorld)
    
            if torsoVisible and headVisible and feetVisible then
                local headY = math.min(headPos.Y, feetPos.Y)
                local footY = math.max(headPos.Y, feetPos.Y)
    
                local height = footY - headPos.Y
                local width = height / 1.5
                local boxPos = Vector2.new(torsoPos.X - width / 2, (headPos.Y - 1))
    
                outline.Size = Vector2.new(width, height)
                
                box.Size = Vector2.new(width, height)
                box.Filled = Options.ToggleBoxFilled.Value
                box.Transparency = Options.ToggleBoxFilled.Value and 0.5 or 1
    
                local hp = humanoid.Health / humanoid.MaxHealth
                local barHeight = height * hp
    
                healthBackground.Size = Vector2.new(2, height)

                healthBar.Size = Vector2.new(2, barHeight)
                local hue = 120 * hp
                healthBar.Color = Color3.fromHSV(hue / 360, 1, 1)

                outline.Position = boxPos
                box.Position = boxPos
                box.Visible = true
                healthBackground.Position = Vector2.new(boxPos.X - 8, boxPos.Y)
                healthBar.Position = Vector2.new(boxPos.X - 8, boxPos.Y + (height - barHeight))
                healthBar.Visible = true
                healthBackground.Visible = true
                outline.Visible = true
            else
                outline.Visible = false
                box.Visible = false
                healthBar.Visible = false
                healthBackground.Visible = false
            end
        end)
    
        espBoxes[character] = {
            box = box,
            outline = outline,
            healthBar = healthBar,
            healthBackground = healthBackground,
            connection = connection,
        }
    end    

    local function removeBoxEsp(character)
        wait(0.2)
        local esp = espBoxes[character]
        if esp then
            if esp.box then esp.box:Remove() end
            if esp.outline then esp.outline:Remove() end
            if esp.healthBar then esp.healthBar:Remove() end
            if esp.healthBackground then esp.healthBackground:Remove() end
            if esp.connection then esp.connection:Disconnect() end
            espBoxes[character] = nil
        end
    end
    
    local function removeAllBoxes()
        wait(0.2)
        for character, esp in pairs(espBoxes) do
            if esp.box then esp.box:Remove() end
            if esp.outline then esp.outline:Remove() end
            if esp.healthBar then esp.healthBar:Remove() end
            if esp.healthBackground then esp.healthBackground:Remove() end
            if esp.connection then esp.connection:Disconnect() end
        end
        table.clear(espBoxes)
    end
    
    local function removeAllNameHealthIndicators()
        wait(0.2)
        for _, uiSet in pairs(nameHealthIndicators) do
            for _, ui in pairs(uiSet) do
                if typeof(ui) == "Instance" and ui:IsDescendantOf(game) then
                    ui:Destroy()
                elseif typeof(ui) == "RBXScriptConnection" then
                    ui:Disconnect()
                end
            end
        end
        table.clear(nameHealthIndicators)
    
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                for _, obj in pairs(p.Character:GetChildren()) do
                    if obj.Name == "MATRIX_NAMESP" or obj.Name == "[0x36E9AD8C]" then
                        obj:Destroy()
                    end
                end
            end
        end
    end

    local function removeAllTriangles()
        wait(0.2)
        for _, t in pairs(triangles) do
            if t and t.Destroy then
                t:Destroy()
            end
        end
        triangles = {}
    end

    local function removeToolNames(character)
        local h = character:FindFirstChild("MATRIX_TOOLESP")
        if h then h:Destroy() end
    end

    local function removeHighlights(character)
        local h = character:FindFirstChild("chams_mtx")
        if h then h:Destroy() end
    end

    local function removeAllToolNames()
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                for _, obj in pairs(p.Character:GetChildren()) do
                    if obj.Name == "MATRIX_TOOLESP" then
                        obj:Destroy()
                    end
                end
            end
        end
    end

    local function removeAllHighlights()
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                for _, obj in pairs(p.Character:GetChildren()) do
                    if obj.Name == "chams_mtx" then
                        obj:Destroy()
                    end
                end
            end
        end
    end
    
    local function getDirectionAngle(from, to, forward)
        local direction = (to - from).Unit
        local angle = math.atan2(forward.X * direction.Z - forward.Z * direction.X, forward.X * direction.X + forward.Z * direction.Z)
        return angle
    end
    
    
    local function updateTriangles()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
        if Options.ToggleTracerEsp.Value then
            task.spawn(function()
                if not systmp then removeAllTriangles() end
                local cameraCF = camera.CFrame
                local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end
                local myPos = myHRP.Position
    
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local otherHRP = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local teamCheck = Options.EspTeamCheck.Value
                        local isSameTeam = (player.Team and otherPlayer.Team and player.Team == otherPlayer.Team)
    
                        local tri = triangles[otherPlayer.Character]
                        if teamCheck and isSameTeam then
                            if tri then
                                tri.Visible = false
                            end
                        else
                            local screenPoint, onScreen = camera:WorldToViewportPoint(otherHRP.Position)
    
                            local angle = math.atan2(screenPoint.Y - camera.ViewportSize.Y/2, screenPoint.X - camera.ViewportSize.X/2)
                            local radius = tonumber(Options.TracerRadius.Value) + 10
                            local cx = camera.ViewportSize.X/2 + math.cos(angle)*radius
                            local cy = camera.ViewportSize.Y/2 + (-57) + math.sin(angle)*radius -- -57 은 매우 중요함

                            local size = 14
                            local rotation = (math.deg(angle) + 90) % 360

                            if not tri then
                                tri = Instance.new("ImageLabel")
                                tri.Name = "Triangle"
                                tri.BackgroundTransparency = 1
                                tri.Image = triangleImageId
                                tri.Size = UDim2.new(0, size, 0, size)
                                tri.AnchorPoint = Vector2.new(0.5, 0.5)
                                tri.Parent = gui
                                triangles[otherPlayer.Character] = tri
                            end

                            local color = (Options.EspTeamColor.Value and otherPlayer.Team) and otherPlayer.Team.TeamColor.Color or Options.EspColor.Value
                            tri.Position = UDim2.new(0, cx, 0, cy)
                            tri.Rotation = rotation
                            tri.Visible = true
                            tri.ImageColor3 = color
                        end
                    else
                        if triangles[otherPlayer.Character] then
                            triangles[otherPlayer.Character]:Destroy()
                            triangles[otherPlayer.Character] = nil
                        end
                    end
                end
            end)
        else
            removeAllTriangles()
        end
    end
    
    local function setupCharacterCleanup(char)
        char.AncestryChanged:Connect(function(_, parent)
            if not parent then
                if nameHealthIndicators[char] then
                    for _, ui in pairs(nameHealthIndicators[char]) do
                        if typeof(ui) == "Instance" then
                            ui:Destroy()
                        end
                    end
                    nameHealthIndicators[char] = nil
                end
            end
        end)
    end

    local function addTextAboveHead(character)
        if character then
            local head = character:FindFirstChild("Head")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            if head and humanoid then
                local otherPlayer = Players:GetPlayerFromCharacter(character)
                local isSameTeam = otherPlayer and player.Team and (otherPlayer.Team == player.Team) or false
    
                if Options.EspTeamCheck.Value and isSameTeam then
                    
                    if espBoxes[character] then
                        local esp = espBoxes[character]
                        if esp.box then esp.box:Remove() end
                        if esp.outline then esp.outline:Remove() end
                        if esp.healthBar then esp.healthBar:Remove() end
                        if esp.healthBackground then esp.healthBackground:Remove() end
                        if esp.connection then esp.connection:Disconnect() end
                        espBoxes[character] = nil
                    end
                    
                    removeToolNames(character)
                    removeHighlights(character)
                                
                    if nameHealthIndicators[character] then
                        local uiSet = nameHealthIndicators[character]
                        for _, ui in pairs(uiSet) do
                            if typeof(ui) == "Instance" and ui:IsDescendantOf(game) then
                                ui:Destroy()
                            elseif typeof(ui) == "RBXScriptConnection" then
                                ui:Disconnect()
                            end
                        end
                        nameHealthIndicators[character] = nil
                    
                        local billboardInstance = character:FindFirstChild("MATRIX_NAMESP")
                        if billboardInstance then
                            billboardInstance:Destroy()
                        end
                    end                    
    
                    return
                end
    
                local teamColorAnABCDEFG
                if Options.EspTeamColor.Value and otherPlayer.Team then
                    teamColorAnABCDEFG = otherPlayer.Team.TeamColor.Color or Options.EspColor.Value
                    if not lastclr then lastclr = teamColorAnABCDEFG end
                else
                    teamColorAnABCDEFG = Options.EspColor.Value
                    if not lastclr then lastclr = teamColorAnABCDEFG end
                end
                if lastclr ~= teamColorAnABCDEFG then
                    removeAllBoxes()
                    removeAllNameHealthIndicators()
                    removeAllHighlights()
                    removeAllToolNames()
                    lastclr = teamColorAnABCDEFG
                end

                
                if Options.ToggleBoxEsp.Value then
                    createBoxEsp(character, teamColorAnABCDEFG)
                else
                    removeBoxEsp(character)
                end
                
                if Options.ToggleNameEsp.Value or Options.DisplayNameChk.Value then
                    if not nameHealthIndicators[character] then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Adornee = head
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 1, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = character
                        billboard.Name = "MATRIX_NAMESP"
                    
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Parent = billboard
                        nameLabel.Size = UDim2.new(0, 0, 0.5, 0)
                        nameLabel.Position = UDim2.new(0.5, 0, 0, 0)
                        nameLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                        nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        nameLabel.TextSize = 12.5
                        nameLabel.RichText = true
                        nameLabel.Font = Enum.Font.Code
                        nameLabel.Text = character.Name
                        nameLabel.AutomaticSize = Enum.AutomaticSize.XY
                        nameLabel.TextXAlignment = Enum.TextXAlignment.Center
                    
                        local UICorner = Instance.new("UICorner", nameLabel)
                    
                        local padding = Instance.new("UIPadding")
                        padding.Parent = nameLabel
                        padding.PaddingLeft = UDim.new(0, 10)
                        padding.PaddingRight = UDim.new(0, 10)
                    
                        local function updateHealth(newHealth)
                            local maxHealth = humanoid.MaxHealth
                            local healthPercent = newHealth / maxHealth
                            local hue = 120 * healthPercent
                            local healthColor = Color3.fromHSV(hue/360, 1, 1)
                    
                            nameLabel.Text = string.format(
                                "<b><font color='#FFFFFF'>[<font color='%s'>%d<font color='#FFFFFF'>]</font></font></font> <font color='%s'>%s</font></b>", 
                                "#" .. healthColor:ToHex(),
                                math.floor(newHealth),
                                "#" .. teamColorAnABCDEFG:ToHex(),
                                character.Name..(Options.DisplayNameChk.Value and " ("..otherPlayer.DisplayName..")" or "")
                            )
                        end

                        local connection = humanoid.HealthChanged:Connect(updateHealth)
                    
                        updateHealth(humanoid.Health)
                    
                        local healthLabel = Instance.new("TextLabel")
                        healthLabel.Parent = billboard
                        healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        healthLabel.Position = UDim2.new(0, 0, 0, 0)
                        healthLabel.BackgroundTransparency = 1
                        healthLabel.TextTransparency = 1
                        healthLabel.TextSize = 9
                        healthLabel.Visible = false
                    
                        nameHealthIndicators[character] = {billboard, nameLabel, healthLabel, connection}
                    end
                else
                    if nameHealthIndicators[otherPlayer.Character] then
                        local uiSet = nameHealthIndicators[otherPlayer.Character]
                        for _, ui in pairs(uiSet) do
                            if typeof(ui) == "Instance" and ui:IsDescendantOf(game) then
                                ui:Destroy()
                            elseif typeof(ui) == "RBXScriptConnection" then
                                ui:Disconnect()
                            end
                        end
                        nameHealthIndicators[otherPlayer.Character] = nil
                    
                        local billboardInstance = otherPlayer.Character:FindFirstChild("MATRIX_NAMESP") or otherPlayer.Character:FindFirstChild("[0x36E9AD8C]")
                        if billboardInstance then
                            billboardInstance:Destroy()
                        end
                    end
                end

                if Options.ToggleToolName.Value then
                    if game.PlaceId ~= 17625359962 then return end
                    local ToolName = character:FindFirstChild("MATRIX_TOOLESP")
                    if not ToolName then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Adornee = head
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, -5, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = character
                        billboard.Name = "MATRIX_TOOLESP"
                    
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Name = "TOOL"
                        nameLabel.Parent = billboard
                        nameLabel.Size = UDim2.new(0, 0, 0.5, 0)
                        nameLabel.Position = UDim2.new(0.5, 0, 0, 0)
                        nameLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                        nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        nameLabel.TextSize = 16
                        nameLabel.RichText = true
                        nameLabel.Font = Enum.Font.SourceSansBold
                        nameLabel.Text = "Unknown"
                        nameLabel.AutomaticSize = Enum.AutomaticSize.XY
                        nameLabel.TextXAlignment = Enum.TextXAlignment.Center
                    
                        local UICorner = Instance.new("UICorner", nameLabel)
                    
                        local padding = Instance.new("UIPadding")
                        padding.Parent = nameLabel
                        padding.PaddingLeft = UDim.new(0, 10)
                        padding.PaddingRight = UDim.new(0, 10)
                    end

                    safeExecute(function()
                        local txt = ToolName:WaitForChild("TOOL")
                        local item = chkItem(character)
                        if txt then
                            if item == "Katana" then
                                if KatanaDetected then
                                    txt.TextColor3 = Color3.fromRGB(255, 99, 99)
                                    txt.Text = "Katana Detected!"
                                else
                                    txt.TextColor3 = Color3.fromRGB(99, 255, 99)
                                    txt.Text = item
                                end
                            elseif item == "Riot Shield" then
                                txt.TextColor3 = Color3.fromRGB(99, 255, 99)
                                txt.Text = item
                            else
                                txt.TextColor3 = teamColorAnABCDEFG
                                txt.Text = item
                            end
                        end
                    end)
                else
                    removeToolNames(character)
                end

                if Options.ToggleChams.Value then
                    local highlight = character:FindFirstChild("chams_mtx")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "chams_mtx"
                        highlight.Adornee = character
                        highlight.FillTransparency = 0
                        highlight.FillColor = Color3.new(0, 0, 0)
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = character
                    end
                
                    highlight.OutlineColor = teamColorAnABCDEFG
                
                    if lastTicks[character.Name] and tick() - lastTicks[character.Name] < 0.2 then return end
                    lastTicks[character.Name] = tick()
                    local visible = false
                    local char = player.Character or player.CharacterAdded:Wait()
                    local playerTorso = char:WaitForChild("HumanoidRootPart")
                    if not playerTorso then 
                        return
                    end
                
                    local origin = playerTorso.Position + Vector3.new(0, 1.5, 0)
                
                    local checkParts = {
                        "HumanoidRootPart",
                        "Head",
                        "Torso",        
                        "UpperTorso",   
                        "LowerTorso"    
                    }
                
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    raycastParams.FilterDescendantsInstances = {char}
                    raycastParams.IgnoreWater = true

                    for _, name in ipairs(checkParts) do
                        local part = character:FindFirstChild(name)
                        if part then
                            local direction = (part.Position - origin)
                            local ray = workspace:Raycast(origin, direction.Unit * direction.Magnitude, raycastParams)
                    
                            if not ray or (ray.Instance and ray.Instance:IsDescendantOf(character)) then
                                visible = true
                                getgenv().wellchk = true
                                break
                            else
                                getgenv().wellchk = false
                                break
                            end
                        end
                    end
                    
                    highlight.FillColor = visible and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
                else
                    removeHighlights(character)
                end                
            end
        end
    end
    
    local function updateCircle()
        circleFov.Visible = Options.DrawFov.Value
        circleFov.Color = Options.FovColor.Value or Color3.fromRGB(255, 255, 255)
        circleFov.Position = game:GetService("UserInputService"):GetMouseLocation()
        circleFov.Radius = tonumber(Options.FovRadius.Value)
        silentFov.Visible = Options.FovSilent.Value
        silentFov.Color = Options.FovColor.Value or Color3.fromRGB(255, 255, 255)
        silentFov.Position = game:GetService("UserInputService"):GetMouseLocation()
        silentFov.Radius = tonumber(Options.SilentFovRadius.Value)
    end
    
    local function IsWithinRadius(position)
        local ScreenPos = camera:WorldToViewportPoint(position)
        if ScreenPos.Z <= 0 and not lockedTarget then return false end
    
        local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        local distanceFromCenter = (Vector2.new(ScreenPos.X, ScreenPos.Y) - screenCenter).Magnitude
        return distanceFromCenter <= tonumber(Options.FovRadius.Value)
    end
    
    local function aimAtClosestPlayer()
        if not (Options.ToggleAimbot.Value and getgenv().isAimKeyPress) then
            lockedTarget = nil
            return
        end
        
        if not lockedTarget then
            local closestScore = math.huge
            local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
            for _, otherPlayer in ipairs(game:GetService("Players"):GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local character = otherPlayer.Character
                    local humanoid = character:FindFirstChild("Humanoid")
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
                    if humanoid and humanoid.Health > 0 and rootPart then
                        if Options.healthCheck.Value and humanoid.Health <= 0 then
                            
                        else
                            if Options.CheckTeams.Value and player.Team == otherPlayer.Team then
        
                            elseif Options.WallCheck.Value and not IsWithinRadius(rootPart.Position) then
        
                            else
                                local viewportPos = camera:WorldToViewportPoint(rootPart.Position)
                                if viewportPos.Z < 0 then
        
                                else
                                    local screenPos = Vector2.new(viewportPos.X, viewportPos.Y)
                                    local screenDistance = (screenPos - screenCenter).Magnitude
        
                                    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                    local worldDistance = myRoot and (myRoot.Position - rootPart.Position).Magnitude or 0
        
                                    local isSameTeam = otherPlayer and player.Team and (otherPlayer.Team == player.Team) or false
                                    if Options.CheckTeams.Value and isSameTeam then
        
                                    elseif not IsWithinRadius(rootPart.Position) then

                                    elseif Options.WallCheck.Value and not isVisible(character) then
        
                                    else
                                        local totalScore = screenDistance + worldDistance
                                        if totalScore < closestScore then
                                            closestScore = totalScore
                                            lockedTarget = otherPlayer
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    
        if lockedTarget and lockedTarget.Character then
            local character = lockedTarget.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local targetPart = character:FindFirstChild(Options.AimPart.Value == "Torso" and "HumanoidRootPart" or Options.AimPart.Value)
            if not targetPart then return end
            if Options.healthCheck.Value and humanoid.Health <= 0 then
                lockedTarget = nil
                return
            elseif Options.WallCheck.Value and not isVisible(character) then
                lockedTarget = nil
                return
            elseif not IsWithinRadius(targetPart.Position) then
                lockedTarget = nil
                return
            end
    
            local targetOffset = Vector3.new(0, 0, 0)
            if Options.AimPart.Value == "Head" then
                targetOffset = Vector3.new(0, -0.15, 0)
            end
    
            local predictedPosition = (targetPart.Position + targetOffset) + 
                (getgenv().Prediction and targetPart.Velocity * (0.15 + (targetPart.Position - camera.CFrame.Position).Magnitude / 1000) or Vector3.zero)
    
            local screenPoint, onScreen = camera:WorldToViewportPoint(predictedPosition)
            if not onScreen then
                lockedTarget = nil
                return
            end
    
            local scaleFactorX = 10
            local scaleFactorY = 10
            local aimOffset = Vector2.new(
                (Options.AimPositionX.Value - 2.5) * scaleFactorX,
                (Options.AimPositionY.Value - 2.5) * scaleFactorY
            )
            local targetPos = Vector2.new(screenPoint.X, screenPoint.Y) + aimOffset
    
            if Options.Movement.Value == "Mouse" then
                local currentPos = game:GetService("UserInputService"):GetMouseLocation()
                local delta = (targetPos - currentPos)
                local distance = delta.Magnitude
                local moving = distance > 1

                local baseSmooth = tonumber(Options.AimbotSmoothness.Value)
                local smoothingFactor = math.clamp(baseSmooth * (distance / 100), 1, 15)
                local smoothedDelta = delta / smoothingFactor

                local moveX = math.clamp(smoothedDelta.X, -25, 25)
                local moveY = math.clamp(smoothedDelta.Y, -25, 25)

                if Options.humanAim.Value and moving then
                    local t = os.clock()
                    local state = getgenv()._aimState or {
                        lastJitter = 0,
                        jitterX = 0,
                        jitterY = 0,
                        weight = 0,
                        cooldown = 0
                    }

                    getgenv()._aimState = state

                    local dt = t - state.lastJitter

                    if dt >= 0.01 then
                        state.lastJitter = t

                        if state.cooldown <= 0 then
                            state.weight = math.clamp(state.weight + math.random(-1, 2) * 0.02, 0, 1)
                            state.cooldown = math.random(8, 20) / 100
                        else
                            state.cooldown = state.cooldown - dt
                        end

                        local n1 = math.sin(t * 2.0 + math.random()) * 0.5
                        local n2 = math.cos(t * 2.8 + math.random()) * 0.5
                        state.jitterX = n1 * state.weight
                        state.jitterY = n2 * state.weight
                    end

                    local toleranceRadius = getgenv().insideRadius or 8
                    local insideTolerance = distance <= toleranceRadius

                    if not insideTolerance then
                        local moveDirection = delta.Magnitude > 0 and delta.Unit or Vector2.new(0, 0)
                        local adjustedDistance = distance - toleranceRadius
                        local limitedDelta = moveDirection * adjustedDistance
                        local smoothedLimitedDelta = limitedDelta / smoothingFactor

                        local finalMoveX = math.clamp(smoothedLimitedDelta.X + state.jitterX, -25, 25)
                        local finalMoveY = math.clamp(smoothedLimitedDelta.Y + state.jitterY, -25, 25)

                        if math.abs(finalMoveX) >= 1 or math.abs(finalMoveY) >= 1 then
                            mousemoverel(finalMoveX, finalMoveY)
                        end
                    end
                elseif moving then
                    if baseSmooth <= 1 then
                        if math.abs(delta.X) >= 1 or math.abs(delta.Y) >= 1 then
                            mousemoverel(delta.X, delta.Y)
                        end                        
                    else
                        if math.abs(moveX) >= 1 or math.abs(moveY) >= 1 then
                            mousemoverel(moveX, moveY)
                        end
                    end
                end


            else
                local adjustedWorldPos = camera:ViewportPointToRay(screenPoint.X + aimOffset.X, screenPoint.Y + aimOffset.Y).Origin
                local targetCFrame = CFrame.lookAt(camera.CFrame.Position, adjustedWorldPos)
    
                camera.CFrame = camera.CFrame:Lerp(
                    targetCFrame,
                    math.clamp(1 / Options.AimbotSmoothness.Value, 0.01, 1)
                )
            end
    
        else
            lockedTarget = nil
        end
    end

    local function protectCharacter()
        if not player.Character then return end
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        
        if root and humanoid then
            if Options.AntiFling.Value and root.Velocity.Magnitude <= antifling_VELOCITY_THRESHOLD then
                antifling_lastSafeCFrame = root.CFrame
            end
    
            if Options.AntiFling.Value and root.Velocity.Magnitude > antifling_VELOCITY_THRESHOLD then
                if antifling_lastSafeCFrame then
                    root.Velocity = Vector3.new(0,0,0)
                    root.AssemblyLinearVelocity = Vector3.new(0,0,0)
                    root.AssemblyAngularVelocity = Vector3.new(0,0,0)
                    root.CFrame = antifling_lastSafeCFrame
                end
            end
    
            if root.AssemblyAngularVelocity.Magnitude > antifling_ANGULAR_THRESHOLD and Options.AntiFling.Value then
                root.AssemblyAngularVelocity = Vector3.new(0,0,0)
            end
            
            if humanoid:GetState() == Enum.HumanoidStateType.FallingDown and Options.AntiFling.Value then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end

    local function lineTask()
        abc = RunService.Heartbeat:Connect(function()
            if systmp then
                updateTriangles()
            else
                removeAllTriangles()
                abc:Disconnect()
            end
        end)

        while systmp do
            task.wait(1)
            removeAllTriangles()
        end
    end

    local function fovTask()
        abc = RunService.Heartbeat:Connect(function()
            if systmp then
                updateCircle()
            else
                circleFov.Visible = false
                silentFov.Visible = false
                abc:Disconnect()
            end
        end)
    end

    local function noclipTask()
        while systmp do
            if Options.ToggleNoclip.Value then
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name == player.Name then
                        for _, part in pairs(obj:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end

    local function aimbotTask()
        abcde = RunService.RenderStepped:Connect(function()
            if not systmp then abcde:Disconnect() end
            if Options.ToggleAimbot.Value and getgenv().isAimKeyPress then
                aimAtClosestPlayer()
            else
                lockedTarget = nil
            end
        end)
    end

    local function antiflingTask()
        RunService.Heartbeat:Connect(protectCharacter)
    end

    InfJumpConnection = UIS.JumpRequest:connect(function()
        if not systmp then InfJumpConnection:Disconnect() end;
        if Options.ToggleInfJump.Value then
            player.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end
    end)

    local function espTask()
        abcde = RunService.Heartbeat:Connect(function()
            if systmp then
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= player then
                        local character = otherPlayer.Character
                        addTextAboveHead(character)
                    end
                end
            else
                removeAllNameHealthIndicators()
                removeAllTriangles()
                removeAllBoxes()
                removeAllToolNames()
                removeAllHighlights()
                abcde:Disconnect()
                return               
            end
        end)
    end

    local function cleanupTask()
        abc = RunService.Heartbeat:Connect(function()
            if getgenv().StopScript then
                getgenv().SCRUNNED = false
                systmp = false
                removeAllNameHealthIndicators()
                removeAllTriangles()
                removeAllHighlights()
                removeAllToolNames()
                removeAllBoxes()  
                circleFov.Visible = false
                silentFov.Visible = false
                safeExecute(function() gui:Destroy() end)
                abc:Disconnect()
                safeExecute(function() script:Destroy() end)
            end
            if Fluent.Unloaded then
                if not Options.checkjarkup.Value then
                    systmp = false
                    getgenv().SCRUNNED = false
                    removeAllNameHealthIndicators()
                    removeAllTriangles()
                    removeAllHighlights()
                    removeAllToolNames()
                    removeAllBoxes()  
                    circleFov.Visible = false
                    silentFov.Visible = false
                    getgenv().NyaNya = false
                    getgenv().StopScript = true
                    safeExecute(function() gui:Destroy() end)
                    abc:Disconnect()
                    return
                else
                    getgenv().NyaNya = true
                end
            end
        end)
    end

    local function stopFly()
        if not FLYING then return end
        FLYING = false
    
        if flyKeyDown then flyKeyDown:Disconnect() end
        if flyKeyUp then flyKeyUp:Disconnect() end
        if flyConnection then flyConnection:Disconnect() end
        CONTROL = {F = 0, B = 0, L = 0, R = 0, U = 0, D = 0}
    
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local root = getRoot(character)
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    
        if humanoid then
            humanoid.PlatformStand = false
        end
    end

    local function startFly()
        if FLYING then return end
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local root = getRoot(character)
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    
        if not root or not humanoid then return end
    
        if flyKeyDown or flyKeyUp then
            flyKeyDown:Disconnect()
            flyKeyUp:Disconnect()
        end
    
        FLYING = true
        SPEED = tonumber(Options.FlySpeed.Value)
        humanoid.PlatformStand = true
    
        flyKeyDown = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 1
            elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = -1
            elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = -1
            elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 1
            elseif input.KeyCode == Enum.KeyCode.Space then CONTROL.U = 1
            elseif input.KeyCode == Enum.KeyCode.LeftShift then CONTROL.D = -1
            end
        end)
    
        flyKeyUp = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0
            elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0
            elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0
            elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0
            elseif input.KeyCode == Enum.KeyCode.Space then CONTROL.U = 0
            elseif input.KeyCode == Enum.KeyCode.LeftShift then CONTROL.D = 0
            end
        end)
    
        flyConnection = RunService.RenderStepped:Connect(function(dt)
            if FLYING and root then
                local forward = root.CFrame.LookVector
                local right = root.CFrame.RightVector
                local up = Vector3.new(0, 1, 0)
        
                local move = Vector3.zero
                move = move + forward * (CONTROL.F + CONTROL.B)
                move = move + right * (CONTROL.R + CONTROL.L)
                move = move + up * (CONTROL.U + CONTROL.D)
        
                local newPosition
                if move.Magnitude > 0 then
                    newPosition = root.Position + move.Unit * SPEED * dt
                else
                    newPosition = root.Position
                end
        
                root.AssemblyLinearVelocity = Vector3.zero
                root.CFrame = CFrame.new(newPosition, newPosition + root.CFrame.LookVector)
            else
                stopFly()
            end
        end)        
    end
    
    flyConnections = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not systmp then flyConnections:Disconnect() end;
        if gameProcessed then return end
        if Options.FlyEnabled.Value and input.KeyCode == convertBind(Options.FlyKeybind.Value) then
            if FLYING then
                stopFly()
            else
                startFly()
            end
        end
    end)

    task.spawn(espTask)
    task.spawn(lineTask)
    task.spawn(fovTask)
    task.spawn(antiflingTask)
    task.spawn(noclipTask)
    task.spawn(cleanupTask)
    task.spawn(aimbotTask)
    task.spawn(function()
        while systmp do
            local char = player.Character or player.CharacterAdded:Wait()
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")

            if humanoid then
                if Options.CFrameWalk.Value and getgenv().isCFameWalkKeyPress and char and humanoid and humanoid.Parent then
                    local delta = RunService.Heartbeat:Wait()

                    if humanoid.MoveDirection.Magnitude > 0 then
                        char:TranslateBy(humanoid.MoveDirection * tonumber(Options.WalkSpeed.Value) * delta * 10)
                    end
                end
            end
            task.wait()
        end
    end)
    task.spawn(function()
        while systmp do
            task.wait()
            if game.PlaceId ~= 17625359962 then return end
            if identifyexecutor() == "Solara" or identifyexecutor() == "Xeno"then
                return
            end
            if (Rivals.CoreGuiController.LocalFighter.EquippedItem) then
                if (Rivals.CoreGuiController.LocalFighter.EquippedItem.Info) then
                    if (Options.ToggleNoCoolDown.Value) then
                        if not oldCooldown then oldCooldown = Rivals.CoreGuiController.LocalFighter.EquippedItem.Info.ShootCooldown end
                        Rivals.CoreGuiController.LocalFighter.EquippedItem.Info.ShootCooldown = 0.01
                    else
                        if oldCooldown then 
                            Rivals.CoreGuiController.LocalFighter.EquippedItem.Info.ShootCooldown = oldCooldown
                            oldCooldown = nil
                        end
                    end
                    if (Options.ToggleNoRecoil.Value) then
                        if not oldRecoil then oldRecoil = Rivals.CoreGuiController.LocalFighter.EquippedItem.Info.ShootRecoil end
                        Rivals.CoreGuiController.LocalFighter.EquippedItem.Info.ShootRecoil = 0
                    else
                        if oldRecoil then 
                            Rivals.CoreGuiController.LocalFighter.EquippedItem.Info.ShootRecoil = oldRecoil
                            oldRecoil = nil
                        end
                    end
                    if (Options.ToggleNoSpread.Value) then
                        if not oldSpread then oldSpread = Rivals.CoreGuiController.LocalFighter.EquippedItem.Info.ShootSpread end
                        Rivals.CoreGuiController.LocalFighter.EquippedItem.Info.ShootSpread = 0
                    else
                        if oldSpread then 
                            Rivals.CoreGuiController.LocalFighter.EquippedItem.Info.ShootSpread = oldSpread
                            oldSpread = nil
                        end
                    end
                end
            end
        end
    end)
end
