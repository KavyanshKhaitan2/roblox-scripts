local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ChestHop Library

if game.PlaceId == 2753915549 then -- First Sea
	FirstSea = true
    SecondSea = false
    ThirdSea = false
elseif game.PlaceId == 4442272183 then -- Second Sea
	FirstSea = false
    SecondSea = true
    ThirdSea = false
elseif game.PlaceId == 7449423635 then -- Third Sea
	FirstSea = false
    SecondSea = false
	ThirdSea = true
end

local function getCharacter()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    return LocalPlayer.Character
end

local function DistanceFromPlrSort(ObjectList: table)
    local RootPart = getCharacter().LowerTorso
    table.sort(ObjectList, function(ChestA, ChestB)
        local RootPos = RootPart.Position
        local DistanceA = (RootPos - ChestA.Position).Magnitude
        local DistanceB = (RootPos - ChestB.Position).Magnitude
        return DistanceA < DistanceB
    end)
end

local UncheckedChests = {}
local FirstRun = true

local function getChestsSorted()
    if FirstRun then
        FirstRun = false
        local Objects = game:GetDescendants()
        for i, Object in pairs(Objects) do
            if Object.Name:find("Chest") and Object.ClassName == "Part" then
                table.insert(UncheckedChests, Object)
            end
        end
    end
    local Chests = {}
    for i, Chest in pairs(UncheckedChests) do
        if Chest:FindFirstChild("TouchInterest") then
            table.insert(Chests, Chest)
        end
    end
    DistanceFromPlrSort(Chests)
    return Chests
end

local function toggleNoclip(Toggle: boolean)
    for i,v in pairs(getCharacter():GetChildren()) do
        if v.ClassName == "Part" then
            v.CanCollide = not Toggle
        end
    end
end

local function Teleport(Goal: CFrame, Speed)
    if not Speed then
        Speed = MaxSpeed
    end
    toggleNoclip(true)
    local RootPart = getCharacter().HumanoidRootPart
    local Magnitude = (RootPart.Position - Goal.Position).Magnitude

    RootPart.CFrame = RootPart.CFrame
    
    while not (Magnitude < 1) do
        local Direction = (Goal.Position - RootPart.Position).unit
        RootPart.CFrame = RootPart.CFrame + Direction * (Speed * wait())
        Magnitude = (RootPart.Position - Goal.Position).Magnitude
    end
    toggleNoclip(false)
end

local MaxSpeed = 300 -- Studs per second 380 no flag but kick

local LocalPlayer = game:GetService("Players").LocalPlayer
local Locations = workspace._WorldOrigin.Locations

local function getCharacter()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    return LocalPlayer.Character
end

local function DistanceFromPlrSort(ObjectList: table)
    local RootPart = getCharacter().LowerTorso
    table.sort(ObjectList, function(ChestA, ChestB)
        local RootPos = RootPart.Position
        local DistanceA = (RootPos - ChestA.Position).Magnitude
        local DistanceB = (RootPos - ChestB.Position).Magnitude
        return DistanceA < DistanceB
    end)
end

local UncheckedChests = {}
local FirstRun = true

local function getChestsSorted()
    if FirstRun then
        FirstRun = false
        local Objects = game:GetDescendants()
        for i, Object in pairs(Objects) do
            if Object.Name:find("Chest") and Object.ClassName == "Part" then
                table.insert(UncheckedChests, Object)
            end
        end
    end
    local Chests = {}
    for i, Chest in pairs(UncheckedChests) do
        if Chest:FindFirstChild("TouchInterest") then
            table.insert(Chests, Chest)
        end
    end
    DistanceFromPlrSort(Chests)
    return Chests
end

local function toggleNoclip(Toggle: boolean)
    for i,v in pairs(getCharacter():GetChildren()) do
        if v.ClassName == "Part" then
            v.CanCollide = not Toggle
        end
    end
end

local function Teleport(Goal: CFrame, Speed)
    if not Speed then
        Speed = MaxSpeed
    end
    toggleNoclip(true)
    local RootPart = getCharacter().HumanoidRootPart
    local Magnitude = (RootPart.Position - Goal.Position).Magnitude

    RootPart.CFrame = RootPart.CFrame
    
    while not (Magnitude < 1) do
        local Direction = (Goal.Position - RootPart.Position).unit
        RootPart.CFrame = RootPart.CFrame + Direction * (Speed * wait())
        Magnitude = (RootPart.Position - Goal.Position).Magnitude
    end
    toggleNoclip(false)
end

function ChestIterate()
  wait()
  local Chests = getChestsSorted()
  if #Chests > 0 then
      Teleport(Chests[1].CFrame)
  else
      -- You can put serverhop here
  end
end

wait = task.wait

-- Get player from Username
local function selectPlayerByUsername(playerName)
    local playerUserId = game.Players:GetUserIdFromNameAsync(playerName)
    local player = game.Players:GetPlayerByUserId(playerUserId)
    if player then return player end
end


-- Create window

local Window = Fluent:CreateWindow({
    Title = "BloxFruits NightOwl",
    SubTitle = "by '@kavyansh.' on discord",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- Default: ...LeftControl
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
HomeTab = {
    Tab = Window:AddTab({ Title = "Home", Icon = "home" }),
}
HomeTab.ChestHop = HomeTab.Tab:AddSection("Chest Hop")
HomeTab.Dev = HomeTab.Tab:AddSection("Developer Options")

PlayerTab = {
    Tab = Window:AddTab({ Title = "Player", Icon = "user-round" })
}
PlayerTab.Island = PlayerTab.Tab:AddSection("Tween to Island")
PlayerTab.Player = PlayerTab.Tab:AddSection("Tween to Player")

ShopTab = {
    Tab = Window:AddTab({ Title = "Shop", Icon = "shopping-bag" })
}
ShopTab.FightingStyles = ShopTab.Tab:AddSection("Fighting Styles")

SettingsTab = {
    Tab = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do -- Home Tab
    local ChestHopToggle = HomeTab.ChestHop:AddToggle("ChestHopToggle", {
        Title = "Enable Chest Hop", 
        Description = "Turn this on to earn some cash. Great if you want to AFK.",
        Default = false,
        Callback = function(state)
            -- -- -- --
        end 
    })
    ChestHopToggle:OnChanged(function()
        while Options.ChestHopToggle.Value do
            ChestIterate()
        end
    end)

    HomeTab.Dev:AddButton({
        Title = "Get Player Vector3 Position",
        Description = "Get player position (Copy2Clipboard)",
        Callback = function()
            pos = tostring(getCharacter().HumanoidRootPart.Position)
            Window:Dialog({
                Title = "Player Vector3 Position?",
                Content = pos,
                Buttons = {
                    { 
                        Title = "To Clipboard",
                        Callback = function()
                            toclipboard(pos)
                            Fluent:Notify({
                                Title = "Copied",
                                Content = "To Clipboard",
                                SubContent = pos, -- Optional
                                Duration = 5 -- Set to nil to make the notification not disappear
                            })
                        end 
                    }, {
                        Title = "To Console",
                        Callback = function()
                            print(pos)
                            Fluent:Notify({
                                Title = "Logged",
                                Content = "To Console [F9]",
                                SubContent = pos, -- Optional
                                Duration = 5 -- Set to nil to make the notification not disappear
                            })
                        end 
                    }
                }
            })
        end
    })
end

do -- Movement Tab
    function getSeaSpecificLocations()
        if FirstSea then return { -- First Sea Locations
            "WindMill",
            "Marine",
            "Middle Town",
            "Jungle",
            "Pirate Village",
            "Desert",
            "Snow Island",
            "MarineFord",
            "Colosseum",
            "Sky Island 1",
            "Sky Island 2",
            "Sky Island 3",
            "Prison",
            "Magma Village",
            "Under Water Island",
            "Fountain City",
            "Shank Room",
            "Mob Island"
        } end if SecondSea then return { -- Second Sea Locations
            "The Cafe",
            "Frist Spot",
            "Dark Area",
            "Flamingo Mansion",
            "Flamingo Room",
            "Green Zone",
            "Factory",
            "Colossuim",
            "Zombie Island",
            "Two Snow Mountain",
            "Punk Hazard",
            "Cursed Ship",
            "Ice Castle",
            "Forgotten Island",
            "Ussop Island",
            "Mini Sky Island"
        } end if ThirdSea then return { -- Third Sea Locations
            "Mansion",
            "Port Town",
            "Great Tree",
            "Castle On The Sea",
            "MiniSky",
            "Hydra Island",
            "Floating Turtle",
            "Haunted Castle",
            "Ice Cream Island",
            "Peanut Island",
            "Cake Island",
            "Tiki Outpost"
        } end
    end
    local TweenToIsland = PlayerTab.Island:AddDropdown("TweenToIsland", {
        Title = "Select Destination",
        Description = "Select destination, then click on the button below it to tween to destination.",
        Values = getSeaSpecificLocations(),
        Multi = false,
        Default = 1,
    })
    TweenToIsland:OnChanged(function(Value)
        TTI_Value = Value
    end)

    PlayerTab.Island:AddButton({
        Title = "Tween...",
        Description = "Tween to location mentioned in the above dropdown",
        Callback = function()
            val = TTI_Value
            if val == "WindMill" then
                Teleport(CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594))
            elseif val == "Marine" then
                Teleport(CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156))
            elseif val == "Middle Town" then
                Teleport(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))
            elseif val == "Jungle" then
                Teleport(CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754))
            elseif val == "Pirate Village" then
                Teleport(CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969))
            elseif val == "Desert" then
                Teleport(CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688))
            elseif val == "Snow Island" then
                Teleport(CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469))
            elseif val == "MarineFord" then
                Teleport(CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313))
            elseif val == "Colosseum" then
                Teleport(CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969))
            elseif val == "Sky Island 1" then
                Teleport(CFrame.new(-4869.1025390625, 733.46051025391, -2667.0180664063))
            elseif val == "Sky Island 2" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
            elseif val == "Sky Island 3" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
            elseif val == "Prison" then
                Teleport(CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656))
            elseif val == "Magma Village" then
                Teleport(CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875))
            elseif val == "Under Water Island" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            elseif val == "Fountain City" then
                Teleport(CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813))
            elseif val == "Shank Room" then
                Teleport(CFrame.new(-1442.16553, 29.8788261, -28.3547478))
            elseif val == "Mob Island" then
                Teleport(CFrame.new(-2850.20068, 7.39224768, 5354.99268))
            elseif val == "The Cafe" then
                Teleport(CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828))
            elseif val == "Frist Spot" then
                Teleport(CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375))
            elseif val == "Dark Area" then
                Teleport(CFrame.new(3780.0302734375, 22.652164459229, -3498.5859375))
            elseif val == "Flamingo Mansion" then
                Teleport(CFrame.new(-483.73370361328, 332.0383605957, 595.32708740234))
            elseif val == "Flamingo Room" then
                Teleport(CFrame.new(2284.4140625, 15.152037620544, 875.72534179688))
            elseif val == "Green Zone" then
                Teleport(CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344))
            elseif val == "Factory" then
                Teleport(CFrame.new(424.12698364258, 211.16171264648, -427.54049682617))
            elseif val == "Colossuim" then
                Teleport(CFrame.new(-1503.6224365234, 219.7956237793, 1369.3101806641))
            elseif val == "Zombie Island" then
                Teleport(CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094))
            elseif val == "Two Snow Mountain" then
                Teleport(CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938))
            elseif val == "Punk Hazard" then
                Teleport(CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125))
            elseif val == "Cursed Ship" then
                Teleport(CFrame.new(923.40197753906, 125.05712890625, 32885.875))
            elseif val == "Ice Castle" then
                Teleport(CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188))
            elseif val == "Forgotten Island" then
                Teleport(CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875))
            elseif val == "Ussop Island" then
                Teleport(CFrame.new(4816.8618164063, 8.4599885940552, 2863.8195800781))
            elseif val == "Mini Sky Island" then
                Teleport(CFrame.new(-288.74060058594, 49326.31640625, -35248.59375))
            elseif val == "Great Tree" then
                Teleport(CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625))
            elseif val == "Castle On The Sea" then
                Teleport(CFrame.new(-5074.45556640625, 314.5155334472656, -2991.054443359375))
            elseif val == "MiniSky" then
                Teleport(CFrame.new(-260.65557861328, 49325.8046875, -35253.5703125))
            elseif val == "Port Town" then
                Teleport(CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375))
            elseif val == "Hydra Island" then
                Teleport(CFrame.new(5228.8842773438, 604.23400878906, 345.0400390625))
            elseif val == "Floating Turtle" then
                Teleport(CFrame.new(-13274.528320313, 531.82073974609, -7579.22265625))
            elseif val == "Mansion" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
            elseif val == "Haunted Castle" then
                Teleport(CFrame.new(-9515.3720703125, 164.00624084473, 5786.0610351562))
            elseif val == "Ice Cream Island" then
                Teleport(CFrame.new(-902.56817626953, 79.93204498291, -10988.84765625))
            elseif val == "Peanut Island" then
                Teleport(CFrame.new(-2062.7475585938, 50.473892211914, -10232.568359375))
            elseif val == "Cake Island" then
                Teleport(CFrame.new(-1884.7747802734375, 19.327526092529297, -11666.8974609375))
            elseif val == "Tiki Outpost" then
                Teleport(CFrame.new(231.742981, 25.3354111, -12199.0537, 0.998278677, -5.16006757e-08, 0.0586484075, 4.79685092e-08, 1, 6.33390442e-08, -0.0586484075, -6.04167383e-08, 0.998278677))
            end
        end
    })

    -- PlayerTab.Island:AddButton({
    --     Title = "Instant TP",
    --     Description = "Sets your Home Point to select location to instant TP you.",
    --     Callback = function()
    --         if val == "Port Town" then 
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Great Tree" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Castle On The Sea" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5074.45556640625, 314.5155334472656, -2991.054443359375)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "MiniSky" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-260.65557861328, 49325.8046875, -35253.5703125)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Hydra Island" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5228.8842773438, 604.23400878906, 345.0400390625)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Floating Turtle" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13274.528320313, 531.82073974609, -7579.22265625)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Haunted Castle" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9515.3720703125, 164.00624084473, 5786.0610351562)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Ice Cream Island" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-902.56817626953, 79.93204498291, -10988.84765625)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Peanut Island" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2062.7475585938, 50.473892211914, -10232.568359375)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Cake Island" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1884.7747802734375, 19.327526092529297, -11666.8974609375)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         ----------------------------------------------------------------------------------------------------
    --         elseif val == "The Cafe" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Frist Spot" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Dark Area" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3780.0302734375, 22.652164459229, -3498.5859375)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Flamingo Mansion" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-483.73370361328, 332.0383605957, 595.32708740234)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Flamingo Room" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2284.4140625, 15.152037620544, 875.72534179688)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Green Zone" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Factory" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(424.12698364258, 211.16171264648, -427.54049682617)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Colossuim" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1503.6224365234, 219.7956237793, 1369.3101806641)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Zombie Island" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Two Snow Mountain" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Punk Hazard" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Cursed Ship" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(923.40197753906, 125.05712890625, 32885.875)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Ice Castle" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Forgotten Island" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Ussop Island" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4816.8618164063, 8.4599885940552, 2863.8195800781)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Mini Sky Island" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-288.74060058594, 49326.31640625, -35248.59375)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "WindMill" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT 
    --         elseif val == "Marine" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Middle Town" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Jungle" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Pirate Village" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Desert" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Snow Island" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "MarineFord" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Colosseum" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Sky Island 1" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4869.1025390625, 733.46051025391, -2667.0180664063)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Prison" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Magma Village" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Fountain City" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(127.1284179688, 59.501365661621, 4105.4458007813)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Shank Room" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1442.16553, 29.8788261, -28.3547478)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         elseif val == "Mob Island" then
    --         repeat task.wait()
    --         game.Players.LocalPlayer.Character.Head:Destroy()
    --         wait(0.5)
    --         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2850.20068, 7.39224768, 5354.99268)
    --         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
    --         until game:GetService("Players").LocalPlayer.Data.SpawnPoint.Value == SPAWNPOINT
    --         end
    --     end
    -- })


    local PlayerList = PlayerTab.Player:AddDropdown("PlayerList", {
        Title = "Select Player",
        Description = "",
        Values = {"Select player..."},
        Multi = false,
        Default = 1,
    })
    PlayerList:OnChanged(function(Value)
        TTP_Value = Value
    end)

    PlayerTab.Player:AddButton({
        Title = "Refresh Player List",
        Description = "Refreshes the player list above this button.",
        Callback = function()
            list_of_player_names = {}
            for _, v in game.Players:GetPlayers() do
                table.insert(list_of_player_names, v.Name)
            end
            -- PlayerList.Values = ({"Select player...", table.unpack(list_of_player_names)})
            PlayerList:SetValues({"Select player...", table.unpack(list_of_player_names)})
        end
    })

    PlayerTab.Player:AddButton({
        Title = "Tween...",
        Description = "Tween to player selected in the dropdown above",
        Callback = function()
            target_CFrame = selectPlayerByUsername(TTP_Value).Character.HumanoidRootPart.CFrame
            print('teleporting...')
            Teleport(target_CFrame)
        end
    })

    local SpectatePlayerToggle = PlayerTab.Player:AddToggle("SpectatePlayer", {
        Title = "Spectate Selected Player", 
        Description = "Changes your camera location to the selected players POV",
        Default = false,
        Callback = function(state)
            SpectatePlayerState = state
            game.Workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
            spawn(function()
                while wait() do
                    if not SpectatePlayerState then return end
                    game.Workspace.Camera.CameraSubject = game.Players:FindFirstChild(TTP_Value).Character.Humanoid
                end
            end)
        end 
    })
    
end

do -- Shop Tab
    DarkStepButton = ShopTab.FightingStyles:AddButton({
        Title = "[❌] Buy Dark Step",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
        end
    })
    
    ElectricButton = ShopTab.FightingStyles:AddButton({
        Title = "[❌] Buy Electric",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
        end
    })
    
    WaterKungFuButton = ShopTab.FightingStyles:AddButton({
        Title = "[❌] Buy Water Kung-Fu",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
        end
    })
    
    DragonBreathButton = ShopTab.FightingStyles:AddButton({
        Title = "[❌] Buy Dragon Breath",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1")
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
        end
    })
    
    SuperhumanButton = ShopTab.FightingStyles:AddButton({
        Title = "[❌] Buy Superhuman",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
        end
    })
    
    DeathStepButton = ShopTab.FightingStyles:AddButton({
        Title = "[❌] Buy Death Step",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
        end
    })
    
    SharkmanButton = ShopTab.FightingStyles:AddButton({
        Title = "[❌] Buy Sharkman Karate",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
        end
    })
    
    ElectricClawButton = ShopTab.FightingStyles:AddButton({
        Title = "[❌] Buy Electric Claw",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
        end
    })
    
    DragonTalonButton = ShopTab.FightingStyles:AddButton({
        Title = "[❌] Buy Dragon Talon",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
        end
    })
    
    GodhumanButton = ShopTab.FightingStyles:AddButton({
        Title = "Activate Godhuman",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
        end
    })
    function checkAll()
        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg",true) == 1 then
            DarkStepButton:SetTitle("[✅] Activate Dark Step")
        end if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro",true) == 1 then
            ElectricButton:SetTitle("[✅] Activate Electric")
        end if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate",true) == 1 then
            WaterKungFuButton:SetTitle("[✅] Activate Water Kung-Fu")
        end if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1",true) == 1 then
            DragonBreathButton:SetTitle("[✅] Activate Dragon Breath")
        end if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman",true) == 1 then
            SuperhumanButton:SetTitle("[✅] Activate Superhuman")
        end if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep",true) == 1 then
            DeathStepButton:SetTitle("[✅] Activate Death Step")
        end if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true) == 1 then
            SharkmanButton:SetTitle("[✅] Activate Sharkman Karate")
        end if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw",true) == 1 then
            ElectricClawButton:SetTitle("[✅] Activate Electric Claw")
        end if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon",true) == 1 then
            DragonTalonButton:SetTitle("[✅] Activate Dragon Talon")
        end if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman",true) == 1 then
            GodhumanButton:SetTitle("[✅] Activate Godhuman (CONTACT THE DEVS IF YOU SEE THIS!)")
        end
    end
    spawn(function()
        task.wait(10)
        checkAll()
    end)
    spawn(function()
        while task.wait(30) do
            checkAll()
        end
    end)

    function parseCommand(msg)
        if string.sub(msg,1,1) ~= '/' then return end
        cmd = string.lower(msg)
        print("Player issued command: "..cmd)
        if cmd == "/fs darkstep" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
        end if cmd == "/fs electric" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
        end if cmd == "/fs waterkungfu" or cmd == "/fs kungfu" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
        end if cmd == "/fs dragonbreath" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1")
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
        end if cmd == "/fs superhuman" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
        end if cmd == "/fs deathstep" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
        end if cmd == "/fs sharkman" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
        end if cmd == "/fs eclaw" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
        end if cmd == "/fs dragontalon" or cmd == "/fs talon" or cmd == "/fs dtalon" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
        end if cmd == "/fs godhuman" then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
        end
    end

    local player = game.Players.LocalPlayer
    player.Chatted:Connect(function(msg)
        parseCommand(msg)
    end)
end

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("NightOwlScriptHub")
SaveManager:SetFolder("NightOwlScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(SettingsTab.Tab)
SaveManager:BuildConfigSection(SettingsTab.Tab)


Window:SelectTab(1)

Fluent:Notify({
    Title = "NightOwl",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()