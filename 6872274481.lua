local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "Novoline",
    LoadingTitle = "monkeys",
    LoadingSubtitle = "hello",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Novoline",
        FileName = "CONFIG"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Novoline",
        Subtitle = "lol",
        Note = "enter the key in discord!",
        FileName = "Novo",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = "Novoline"
    }
})

-- TABS (Combat etc etc)

local Combat = Window:CreateTab("Combat")
local Blatant = Window:CreateTab("Blatant")
local Utility = Window:CreateTab("Utility")
local Visuals = Window:CreateTab("Visuals")
local World = Window:CreateTab("World")
local Exploit = Window:CreateTab("Exploits")

Visuals:CreateSection("Main")
Combat:CreateSection("Main")
World:CreateSection("Main")
Utility:CreateSection("Main")
Exploit:CreateSection("Main")
Blatant:CreateSection("Main")

-- variables (lp etc)  
local lplr = game:GetService("Players").LocalPlayer
local cam = game:GetService("Workspace").CurrentCamera
local uis = game:GetService("UserInputService")
local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local getremote = function(tab)
    for i,v in pairs(tab) do
        if v == "Client" then
            return tab[i + 1]
        end
    end
    return ""
end
local bedwars = {
    ["SprintController"] = KnitClient.Controllers.SprintController,
    ["ClientHandlerStore"] = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
    ["KnockbackUtil"] = require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil,
    ["PingController"] = require(lplr.PlayerScripts.TS.controllers.game.ping["ping-controller"]).PingController,
    ["DamageIndicator"] = KnitClient.Controllers.DamageIndicatorController.spawnDamageIndicator,
    ["SwordController"] = KnitClient.Controllers.SwordController,
    ["ViewmodelController"] = KnitClient.Controllers.ViewmodelController,
    ["SwordRemote"] = getremote(debug.getconstants((KnitClient.Controllers.SwordController).attackEntity)),
}

function isalive(plr)
    plr = plr or lplr
    if not plr.Character then return false end
    if not plr.Character:FindFirstChild("Head") then return false end
    if not plr.Character:FindFirstChild("Humanoid") then return false end
    return true
end
function canwalk(plr)
    plr = plr or lplr
    if not plr.Character then return false end
    if not plr.Character:FindFirstChild("Humanoid") then return false end
    local state = plr.Character:FindFirstChild("Humanoid"):GetState()
    if state == Enum.HumanoidStateType.Dead then
        return false
    end
    if state == Enum.HumanoidStateType.Ragdoll then
        return false
    end
    return true
end
function getbeds()
    local beds = {}
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
        if string.lower(v.Name) == "bed" and v:FindFirstChild("Covers") ~= nil and v:FindFirstChild("Covers").Color ~= lplr.Team.TeamColor then
            table.insert(beds,v)
        end
    end
    return beds
end
function getplayers()
    local players = {}
    for i,v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Team ~= lplr.Team and isalive(v) and v.Character:FindFirstChild("Humanoid").Health > 0.11 then
            table.insert(players,v)
        end
    end
    return players
end
function getserverpos(Position)
    local x = math.round(Position.X/3)
    local y = math.round(Position.Y/3)
    local z = math.round(Position.Z/3)
    return Vector3.new(x,y,z)
end
function getnearestplayer(maxdist)
    local obj = lplr
    local dist = math.huge
    for i,v in pairs(game:GetService("Players"):GetChildren()) do
        if v.Team ~= lplr.Team and v ~= lplr and isalive(v) and isalive(lplr) then
            local mag = (v.Character:FindFirstChild("HumanoidRootPart").Position - lplr.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
            if (mag < dist) and (mag < maxdist) then
                dist = mag
                obj = v
            end
        end
    end
    return obj
end
function getmatchstate()
	return bedwars["ClientHandlerStore"]:getState().Game.matchState
end
function getqueuetype()
    local state = bedwars["ClientHandlerStore"]:getState()
    return state.Game.queueType or "bedwars_test"
end
function getitem(itm)
    if isalive(lplr) and lplr.Character:FindFirstChild("InventoryFolder").Value:FindFirstChild(itm) then
        return true
    end
    return false
end
}


do
    local fov = 0
    local fovval
    local ischanged
    local Enabled = false
	local FOVCHANGER = Visuals:CreateToggle({
		Name = "FOV",
		CurrentValue = false,
		Flag = "FOVTOGGLE",
		Callback = function(val)
			Enabled = val
            if Enabled then
             fovval = fov
             ischanged = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
                 cam.FieldOfView = fovval
            end)
            else
                ischanged:Disconnect()
                cam.FieldOfView = 80
            end
        end
    })
    local FOVDISTANCE = Visuals:CreateSlider({
		Name = "Fov",
		Range = {1, 120},
		Increment = 1,
		Suffix = "Fov",
		CurrentValue = 22,
		Flag = "sliderfov",
		Callback = function(Value)
			fov = Value
		end
	})
end

do
local Enabled = false
local Sprint = Combat:CreateToggle({
    Name = "Sprint",
    Flag = "Sprint",
    Callback = function(val)
        Enabled = val
        if Enabled then
       bedwars["SprintController"]:startSprinting()
        else
       bedwars["SprintController"]:stopSprinting()
        end
    end
})
end


do 
local Enabled = false
local Speed = Combat:CreateToggle({
    Name = "Speed",
    Flag = "Speed",
    Callback = function(val)
        Enabled = val
        if Enabled then
           repeat
            task.wait(0.25)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector * 1
        until not Enabled
        end
    end
})
end

do
    local BedwarsSwords = require(game:GetService("ReplicatedStorage").TS.games.bedwars["bedwars-swords"]).BedwarsSwords
    function hashFunc(vec) 
        return {value = vec}
    end
    local function GetInventory(plr)
        if not plr then 
            return {items = {}, armor = {}}
        end

        local suc, ret = pcall(function() 
            return require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil.getInventory(plr)
        end)

        if not suc then 
            return {items = {}, armor = {}}
        end

        if plr.Character and plr.Character:FindFirstChild("InventoryFolder") then 
            local invFolder = plr.Character:FindFirstChild("InventoryFolder").Value
            if not invFolder then return ret end
            for i,v in next, ret do 
                for i2, v2 in next, v do 
                    if typeof(v2) == 'table' and v2.itemType then
                        v2.instance = invFolder:FindFirstChild(v2.itemType)
                    end
                end
                if typeof(v) == 'table' and v.itemType then
                    v.instance = invFolder:FindFirstChild(v.itemType)
                end
            end
        end

        return ret
    end
    local function getSword()
        local highest, returning = -9e9, nil
        for i,v in next, GetInventory(lplr).items do 
            local power = table.find(BedwarsSwords, v.itemType)
            if not power then continue end
            if power > highest then 
                returning = v
                highest = power
            end
        end
        return returning
     end
local Enabled = false
local NoFall = Combat:CreateToggle({
    Name = "NoFall",
    Flag = "NoFall",
    Callback = function(val)
        Enabled = val
        if Enabled then
            repeat
            task.wait(0.1)
            game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
            until not Enabled
        end
    end
})
end

do
    Blatant:CreateSection("InfFly")
    -- Gui to Lua
    -- Version: 3.2

    -- Instances:

    local InfFly = Instance.new("ScreenGui")
    local FlyRender = Instance.new("Frame")
    local FlyStat = Instance.new("TextLabel")
    local FlyHeight = Instance.new("TextLabel")

    --Properties:

    InfFly.Name = "InfFly"
    InfFly.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    InfFly.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    InfFly.ResetOnSpawn = false

    FlyRender.Name = "FlyRender"
    FlyRender.Parent = InfFly
    FlyRender.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    FlyRender.BackgroundTransparency = 0.910
    FlyRender.Position = UDim2.new(0.399138957, 0, 0.674563587, 0)
    FlyRender.Size = UDim2.new(0, 335, 0, 90)

    FlyStat.Name = "FlyStat"
    FlyStat.Parent = FlyRender
    FlyStat.Active = true
    FlyStat.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FlyStat.BackgroundTransparency = 1.000
    FlyStat.Position = UDim2.new(0.195718661, 0, 0, 0)
    FlyStat.Size = UDim2.new(0, 200, 0, 50)
    FlyStat.Font = Enum.Font.FredokaOne
    FlyStat.Text = "Status : Safe"
    FlyStat.TextColor3 = Color3.fromRGB(33, 255, 107)
    FlyStat.TextSize = 30.000

    FlyHeight.Name = "FlyHeight"
    FlyHeight.Parent = FlyRender
    FlyHeight.Active = true
    FlyHeight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FlyHeight.BackgroundTransparency = 1.000
    FlyHeight.Position = UDim2.new(0.195718661, 0, 0.444444448, 0)
    FlyHeight.Size = UDim2.new(0, 200, 0, 50)
    FlyHeight.Font = Enum.Font.FredokaOne
    FlyHeight.Text = "Y : 100"
    FlyHeight.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlyHeight.TextSize = 30.000
    InfFly.Enabled = false
    FlyRender.Visible = false
    FlyRender.Draggable = true


    local Enabled = false
    local heightval = 1
    local heighttext = ""
    local safeornot = 1
    local char = lplr.Character
    local KeybindINFFLYCheck = false;
    local infflykeybind;
    local hrp = lplr.Character:FindFirstChild("HumanoidRootPart")
    local InfiniteFly = Blatant:CreateToggle({
        Name = "InfiniteFly",
        CurrentValue = false,
        Flag = "InfFlytoggle",
        Callback = function(val)
            Enabled = val
            if Enabled then
                array.Add("Flight", "Infinite")
                enabled("Flight.Infinite", 2)
                safeornot = math.random(1, 7)
                local origy = lplr.Character.HumanoidRootPart.Position.y
                part = Instance.new("Part", workspace)
                part.Size = Vector3.new(1,1,1)
                part.Transparency = 1
                part.Anchored = true
                part.CanCollide = false
                cam.CameraSubject = part
                RunLoops:BindToHeartbeat("FunnyFlyPart", 1, function()
                    local pos = lplr.Character.HumanoidRootPart.Position
                    part.Position = Vector3.new(pos.x, origy, pos.z)
                end)
                local cf = lplr.Character.HumanoidRootPart.CFrame
                lplr.Character.HumanoidRootPart.CFrame = CFrame.new(cf.x, 300000, cf.z)
                if lplr.Character.HumanoidRootPart.Position.X < 50000 then 
                    lplr.Character.HumanoidRootPart.CFrame *= CFrame.new(0, 100000, 0)
                end
                InfFly.Enabled = true
                FlyRender.Visible = true
                if safeornot == 2 then
                    FlyStat.Text = " " .. "UNSAFE!"
                    FlyStat.TextColor3 = Color3.fromRGB(255, 32, 80)
                else
                    if safeornot ~= 2 then
                        FlyStat.Text = " " .. " SAFE!"
                        FlyStat.TextColor3 = Color3.fromRGB(42, 255, 102)
                    end
                end
                repeat
                    heightval = heightval + 1
                    FlyHeight.Text = heightval
                    task.wait()
                    heighttext = FlyHeight.Text
                until not Enabled and InfFly.Enabled == true and FlyRender.Visible == true
            else
                array.Remove("Flight")
                disabled("Flight.Infinite", 2)
                info("InfiniteFly - Waiting to return to original pos", 2)
                repeat task.wait()
                    heighttext = tonumber(FlyHeight.Text)
                    heighttext = heighttext - 1
                    FlyHeight.Text = tostring(heighttext)
                until heighttext == 0
                heightval = 0
                task.wait(0.1)
                RunLoops:UnbindFromHeartbeat("FunnyFlyPart")
                local pos = lplr.Character.HumanoidRootPart.Position
                local rcparams = RaycastParams.new()
                rcparams.FilterType = Enum.RaycastFilterType.Whitelist
                rcparams.FilterDescendantsInstances = {workspace.Map}
                rc = workspace:Raycast(Vector3.new(pos.x, 300, pos.z), Vector3.new(0,-1000,0), rcparams)
                if rc and rc.Position then
                    lplr.Character.HumanoidRootPart.CFrame = CFrame.new(rc.Position) * CFrame.new(0,3,0)
                end
                cam.CameraSubject = lplr.Character
                part:Destroy()
                RunLoops:BindToHeartbeat("FunnyFlyVeloEnd", 1, function()
                    lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    lplr.Character.HumanoidRootPart.CFrame = CFrame.new(rc.Position) * CFrame.new(0,3,0)
                end)
                RunLoops:UnbindFromHeartbeat("FunnyFlyVeloEnd")
                InfFly.Enabled = false
                FlyRender.Visible = false
            end
        end
    })
    local ifkeybind = Blatant:CreateKeybind({
        Name = "InfFlight Keybind",
        CurrentKeybind = "B",
        HoldToInteract = false,
        Flag = "InfFlighttogglekeybind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Keybind)
            if KeybindINFFLYCheck == true then
                KeybindINFFLYCheck = false
                InfiniteFly:Set(enabled)
            else
                if KeybindINFFLYCheck == false then
                    KeybindINFFLYCheck = true
                    InfiniteFly:Set(not enabled)
                end
            end
        end,
    })
end
