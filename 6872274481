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
local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default
local CurrentCamera = workspace.CurrentCamera
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
lighting = game:GetService("Lighting")


local getremote = function(script)
    for r,s in pairs(script) do
        if s == "Client" then
            return script[r + 1]
        end
    end
    return ""
end
----------------------------------------------------------------------------------------
local bedwars = {
    ["SprintController"] = KnitClient.Controllers.SprintController,
    ["ClientHandlerStore"] = require(lplr.PlayerScripts.TS.ui.store).ClientStore,
    ["KnockbackUtil"] = require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil,
    ["SwordRemote"] = getremote(debug.getconstants((KnitClient.Controllers.SwordController).attackEntity)),
    ["damageTable"] = KnitClient.Controllers.DamageController,
    ["FovController"] = KnitClient.Controllers.FovController,
    ["BalloonController"] = KnitClient.Controllers.BalloonController,
    ["ViewmodelController"] = KnitClient.Controllers.ViewmodelController,
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
