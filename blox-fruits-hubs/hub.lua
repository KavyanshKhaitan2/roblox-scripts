local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local MaxSpeed = 300 -- Studs per second 380 no flag but kick

local LocalPlayer = game:GetService("Players").LocalPlayer
local Locations = workspace._WorldOrigin.Locations

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

-- Create Window

local Window = Rayfield:CreateWindow({
   Name = "ChestHop for Blox Fruits by '@kavyansh.' on discord",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Chest hop for Blox Fruits",
   LoadingSubtitle = "by '@kavyansh.' on discord",
   Theme = "Default",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "BFChestHopKavyansh"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "CashGen",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Home", "home")
local ChestHopSection = MainTab:CreateSection("Chest Hop")

Rayfield:Notify({
   Title = "Chesthop script loaded",
   Content = "Created by 'kavyansh.' on discord\nUse [K] to open/close the GUI.",
   Duration = 6.5,
   Image = "rabbit",
})

local ChestHopToggle = MainTab:CreateToggle({
   Name = "Enable Chest Hop",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        print("toggle")
    end
})

ChestHopToggle:Set(false)

local StartChestHop = MainTab:CreateButton({
   Name = "Start Chest Hop",
   Callback = function()
        ChestHopToggle:Set(true)
        wait(1)
        while ChestHopToggle.CurrentValue do
            ChestIterate()
        end
    end,
})

local DevSection = MainTab:CreateSection("Developer Options")
local GetPlayerPosition = MainTab:CreateButton({
    Name = "Get Player Vector3 Position",
    Callback = function()
        print(getCharacter().HumanoidRootPart.Position)
        Rayfield:Notify({
            Title = "Player Position Logged",
            Content = "Press [F9] to view Console",
            Duration = 6.5,
            Image = "rabbit",
         })
    end,
})

local MovementTab = Window:CreateTab("Movement", "footprints")
local TweenSection = MovementTab:CreateSection("Tween")

local TweenSpeedSlider = Tab:CreateSlider({
    Name = "Slider Example",
    Range = {100, 380},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = 300,
    Flag = "TweenSpeedSlider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        MaxSpeed = Value
    end,
 })
 
 
 

local TweenDropdown = MovementTab:CreateDropdown({
    Name = "Select Location",
    Options = {"Castle on the Sea", "Turtle Mansion", "Castle TP"},
    CurrentOption = {"Castle on the Sea"},
    MultipleOptions = false,
    Flag = "TweenDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Options)
        -- pass
    end,
 })

 local TweenButton = MovementTab:CreateButton({
    Name = "Tween...",
    Callback = function()
        option = TweenDropdown.CurrentOption[1]
        if option == "Castle on the Sea" then
            Teleport(CFrame.new(-5010, 314, -2995))
        end if option == "Turtle Mansion" then
            Teleport(CFrame.new(-12550, 337, -7500))
        end
    end,
 })