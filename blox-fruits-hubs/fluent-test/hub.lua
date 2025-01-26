local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ChestHop Library

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

MovementTab = {
    Tab = Window:AddTab({ Title = "Movement", Icon = "footprints" })
}
MovementTab.Island = MovementTab.Tab:AddSection("Tween to Island")
MovementTab.Player = MovementTab.Tab:AddSection("Tween to Player")

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
    local TweenToIsland = MovementTab.Island:AddDropdown("TweenToIsland", {
        Title = "Select Destination",
        Description = "Select destination, then click on the button below it to tween to destination.",
        Values = {"Castle on the Sea", "Turtle Mansion", "Hydra Island", "Haunted Castle", "Port Town", "Great Tree", "Tiki Outpost", "Floating Turtle", "Dragon Dojo", "Training Dummy"},
        Multi = false,
        Default = 1,
    })
    TweenToIsland:OnChanged(function(Value)
        TTI_Value = Value
    end)

    MovementTab.Island:AddButton({
        Title = "Tween...",
        Description = "Tween to location mentioned in the above dropdown",
        Callback = function()
            option = TTI_Value
            if option == "Castle on the Sea" then
                Teleport(CFrame.new(-5010, 314, -2995))
            end if option == "Turtle Mansion" then
                Teleport(CFrame.new(-12550, 337, -7500))
            end if option == "Hydra Island" then
                Teleport(CFrame.new(5292, 1005, 394))
            end if option == "Haunted Castle" then
                Teleport(CFrame.new(-9517, 143, 5528))
            end if option == "Port Town" then
                Teleport(CFrame.new(-339, 21, -5537))
            end if option == "Great Tree" then
                Teleport(CFrame.new(2436, 75, -6798))
            end if option == "Tiki Outpost" then
                Teleport(CFrame.new(-16953, 12, 488))
            end if option == "Floating Turtle" then
                Teleport(CFrame.new(-16953, 12, 488))
            end if option == "Dragon Dojo" then
                Teleport(CFrame.new(5691, 1208, 919))
            end if option == "Training Dummy" then
                Teleport(CFrame.new(3497, 10, 175))
            end
        end
    })


    local PlayerList = MovementTab.Player:AddDropdown("PlayerList", {
        Title = "Select Player",
        Description = "",
        Values = {"Select player..."},
        Multi = false,
        Default = 1,
    })
    PlayerList:OnChanged(function(Value)
        TTP_Value = Value
    end)

    MovementTab.Player:AddButton({
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

    MovementTab.Player:AddButton({
        Title = "Tween...",
        Description = "Tween to player selected in the dropdown above",
        Callback = function()
            target_CFrame = selectPlayerByUsername(TTP_Value).Character.HumanoidRootPart.CFrame
            print('teleporting...')
            Teleport(target_CFrame)
        end
    })
end

do -- Shop Tab
    ShopTab.FightingStyles:AddButton({
        Title = "Activate Dark Step",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
        end
    })
    
    ShopTab.FightingStyles:AddButton({
        Title = "Activate Electric",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
        end
    })
    
    ShopTab.FightingStyles:AddButton({
        Title = "Activate Water Kung-Fu",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
        end
    })
    
    ShopTab.FightingStyles:AddButton({
        Title = "Activate Dragon Breath",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1")
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
        end
    })
    
    ShopTab.FightingStyles:AddButton({
        Title = "Activate Superhuman",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
        end
    })
    
    ShopTab.FightingStyles:AddButton({
        Title = "Activate Death Step",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
        end
    })
    
    ShopTab.FightingStyles:AddButton({
        Title = "Activate Sharkman Karate",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
        end
    })
    
    ShopTab.FightingStyles:AddButton({
        Title = "Activate Electric Claw",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
        end
    })
    
    ShopTab.FightingStyles:AddButton({
        Title = "Activate Dragon Talon",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
        end
    })
    
    ShopTab.FightingStyles:AddButton({
        Title = "Activate Godhuman",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
        end
    })
    
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