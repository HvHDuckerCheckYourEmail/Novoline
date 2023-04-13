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
local HitRemote = Client:Get(bedwars["SwordRemote"])--["instance"]
local Distance = {["Value"] = 18
local Enabled = false
local Aura = Combat:CreateToggle({
    Name = "Aura",
    Flag = "Aura",
    Callback = function(val)
        Enabled = val
        if Enabled then
             spawn(function()
                    repeat
                        task.wait(0.12)
                        local nearest = getnearestplayer(Distance["Value"])
                        if nearest ~= nil and nearest.Team ~= lplr.Team and isalive(nearest) and nearest.Character:FindFirstChild("Humanoid").Health > 0.1 and isalive(lplr) and lplr.Character:FindFirstChild("Humanoid").Health > 0.1 and not nearest.Character:FindFirstChild("ForceField") then
                            local sword = getSword()
                            spawn(function()
                                local anim = Instance.new("Animation")
                                anim.AnimationId = "rbxassetid://4947108314"
                                local animator = lplr.Character:FindFirstChild("Humanoid"):FindFirstChild("Animator")
                                animator:LoadAnimation(anim):Play()
                                anim:Destroy()
                                bedwars["ViewmodelController"]:playAnimation(15)
                            end)
                            if sword ~= nil then
                                bedwars["SwordController"].lastAttack = game:GetService("Workspace"):GetServerTimeNow() - 0.11
                                HitRemote:SendToServer({
                                    ["weapon"] = sword.tool,
                                    ["entityInstance"] = nearest.Character,
                                    ["validate"] = {
                                        ["raycast"] = {
                                            ["cameraPosition"] = hashFunc(cam.CFrame.Position),
                                            ["cursorDirection"] = hashFunc(Ray.new(cam.CFrame.Position, nearest.Character:FindFirstChild("HumanoidRootPart").Position).Unit.Direction)
                                        },
                                        ["targetPosition"] = hashFunc(nearest.Character:FindFirstChild("HumanoidRootPart").Position),
                                        ["selfPosition"] = hashFunc(lplr.Character:FindFirstChild("HumanoidRootPart").Position + ((lplr.Character:FindFirstChild("HumanoidRootPart").Position - nearest.Character:FindFirstChild("HumanoidRootPart").Position).magnitude > 14 and (CFrame.lookAt(lplr.Character:FindFirstChild("HumanoidRootPart").Position, nearest.Character:FindFirstChild("HumanoidRootPart").Position).LookVector * 4) or Vector3.new(0, 0, 0)))
                                    },
                                    ["chargedAttack"] = {["chargeRatio"] = 0.8}
                                })
                            end
                        end
                    until not Enabled
                end)
            end
        end
    })
end
