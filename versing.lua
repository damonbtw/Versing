dx9.ShowConsole(false)

--// Check if NPC path is provided
if not _G.NPCPath then
    _G.NPCPath = "Workspace.WorldInfo.Live" -- Default to your game
end

--// Load the DXLib UI library
local Lib = loadstring(dx9.Get("https://raw.githubusercontent.com/damonbtw/WHATISASKID/refs/heads/main/skiddingwhattt.lua"))()

--// Create Window with dark red theme
local Window = Lib:CreateWindow({
    Title = "Damon your beloved , @crossmyheart0551",
    Size = {600, 500},
    Resizable = false,
    ToggleKey = "[F5]",
    FooterMouseCoords = true,
    MainColor = {15, 15, 18},
    BackgroundColor = {10, 10, 12},
    AccentColor = {220, 50, 60},
    OutlineColor = {40, 20, 25},
    FontColor = {240, 240, 245}
})

--// Create Tabs
local Tab = Window:AddTab("Esp")
local MiscTab = Window:AddTab("Misc")
local SettingsTab = Window:AddTab("Settings")

--// ── ESP Tab ────────────────────────────────────────────────────────────────
local MainBox = Tab:AddMiddleGroupbox("ESP Configuration")

local espEnabled = MainBox:AddToggle({ Text = "ESP Enabled", Default = true })

local nameEnabled = MainBox:AddToggle({ Text = "Name ESP", Default = true })

local boxEnabled = MainBox:AddToggle({ Text = "Box ESP", Default = true })

local box2D = MainBox:AddToggle({ Text = "2D Box (not corner)", Default = true })

local skeletonEnabled = MainBox:AddToggle({ Text = "Skeleton ESP", Default = false })

local tracerEnabled = MainBox:AddToggle({ Text = "Tracers", Default = false })

local tracerPosition = MainBox:AddDropdown({
    Text = "Tracer Position",
    Values = {"Bottom", "Top", "Middle", "Mouse", "Left", "Right"},
    Default = 1
})

local healthbarEnabled = MainBox:AddToggle({ Text = "Health Bar", Default = true })

local healthtextEnabled = MainBox:AddToggle({ Text = "Health Text", Default = true })

local dynamicHealthColor = MainBox:AddToggle({ Text = "Dynamic Health Color", Default = true })

MainBox:AddBlank(5)

-- NEW: Distance Toggle
local showDistance = MainBox:AddToggle({ Text = "Show Distance", Default = true })

-- NEW: Team Check
local teamCheck = MainBox:AddToggle({ Text = "Team Check (Hide Teammates)", Default = false })

MainBox:AddBlank(5)

local colorPicker = MainBox:AddColorPicker({ Text = "ESP Color", Default = {0, 255, 255} })

-- NEW: Teammate Color
local teamColor = MainBox:AddColorPicker({ Text = "Teammate Color", Default = {100, 255, 100} })

MainBox:AddBlank(5)

local distSlider = MainBox:AddSlider({
    Text = "Distance Limit",
    Min = 0,
    Max = 10000,
    Default = 5000,
    Rounding = 0,
    Suffix = " studs"
})

MainBox:AddBlank(5)
MainBox:AddBorder()
MainBox:AddBlank(3)
MainBox:AddLabel("NPC Path: " .. _G.NPCPath, {160, 160, 170})

--// ── Settings Tab ───────────────────────────────────────────────────────────
local UIBox = SettingsTab:AddLeftGroupbox("UI Customization")
UIBox:AddTitle("Accent Color")
UIBox:AddBlank(3)

local redSlider = UIBox:AddSlider({
    Text = "Red",
    Min = 0, Max = 255, Default = 220, Rounding = 0
}):OnChanged(function(value)
    Window.AccentColor = {value, Window.AccentColor[2], Window.AccentColor[3]}
end)

local greenSlider = UIBox:AddSlider({
    Text = "Green",
    Min = 0, Max = 255, Default = 50, Rounding = 0
}):OnChanged(function(value)
    Window.AccentColor = {Window.AccentColor[1], value, Window.AccentColor[3]}
end)

local blueSlider = UIBox:AddSlider({
    Text = "Blue",
    Min = 0, Max = 255, Default = 60, Rounding = 0
}):OnChanged(function(value)
    Window.AccentColor = {Window.AccentColor[1], Window.AccentColor[2], value}
end)

UIBox:AddBlank(5)
UIBox:AddBorder()
UIBox:AddBlank(5)

UIBox:AddButton("Reset to Red", function()
    redSlider:SetValue(220)
    greenSlider:SetValue(50)
    blueSlider:SetValue(60)
    Window.AccentColor = {220, 50, 60}
    Lib:Notify("Red theme!", 2)
end)

UIBox:AddButton("Purple Theme", function()
    redSlider:SetValue(150)
    greenSlider:SetValue(50)
    blueSlider:SetValue(200)
    Window.AccentColor = {150, 50, 200}
    Lib:Notify("Purple theme!", 2)
end)

UIBox:AddButton("Blue Theme", function()
    redSlider:SetValue(50)
    greenSlider:SetValue(120)
    blueSlider:SetValue(255)
    Window.AccentColor = {50, 120, 255}
    Lib:Notify("Blue theme!", 2)
end)

-- NPC Path Selection
local PathBox = SettingsTab:AddRightGroupbox("NPC Path Selection")
PathBox:AddTitle("Select NPC Path")
PathBox:AddBlank(3)

local pathDropdown = PathBox:AddDropdown({
    Text = "NPC Path",
    Values = {
        "Workspace.WorldInfo.Live",
        "Workspace.Characters",
        "Workspace.Character",
        "Workspace.Enemies",
        "Workspace.Enemy",
        "Workspace.Entities",
        "Workspace.NPCs",
        "Workspace.Mobs"
    },
    Default = 1
}):OnChanged(function(value)
    _G.NPCPath = value
    Lib:Notify("Path changed to: " .. value, 3, {100, 255, 100})
    
    local testFolder = GetObjectFromPath(value)
    if testFolder then
        local children = dx9.GetChildren(testFolder)
        if children then
            Lib:Notify("Found " .. #children .. " entities!", 2, {100, 255, 100})
        else
            Lib:Notify("Path exists but empty!", 2, {255, 200, 100})
        end
    else
        Lib:Notify("Path not found in this game!", 3, {255, 100, 100})
    end
end)

PathBox:AddBlank(5)
PathBox:AddLabel("Or enter custom path:", {160, 160, 170})
PathBox:AddBlank(3)
PathBox:AddButton("Set Custom Path", function()
    Lib:Notify("Edit _G.NPCPath in code for custom paths", 3, {255, 200, 100})
end)
PathBox:AddBlank(5)
PathBox:AddLabel("Active Path:", {160, 160, 170})
PathBox:AddLabel(_G.NPCPath, {100, 255, 100})

--// ── Misc Tab ───────────────────────────────────────────────────────────────
local MiscBox = MiscTab:AddMiddleGroupbox("Misc Options")

local watermarkEnabled = MiscBox:AddToggle({
    Text = "Show Watermark (Damon <3)",
    Default = true
})

--// ── Core Functions ────────────────────────────────────────────────────────
local datamodel = dx9.GetDatamodel()
local workspace = dx9.FindFirstChild(datamodel, "Workspace")
local PlayersService = dx9.FindFirstChild(datamodel, "Players")

function GetObjectFromPath(pathString)
    if not pathString or pathString == "" then return nil end
    local parts = {}
    for part in string.gmatch(pathString, "[^%.]+") do
        table.insert(parts, part)
    end
    if #parts == 0 then return nil end
    
    local current = workspace
    if parts[1]:lower() == "workspace" then
        table.remove(parts, 1)
    end
    
    for _, part in ipairs(parts) do
        if not current then return nil end
        current = dx9.FindFirstChild(current, part)
    end
    return current
end

function GetDistanceFromPlayer(v)
    local lp = dx9.get_localplayer()
    if not lp then return 99999 end
    local v1 = lp.Position
    local a = (v1.x - v.x)^2 + (v1.y - v.y)^2 + (v1.z - v.z)^2
    return math.floor(math.sqrt(a) + 0.5)
end

-- NEW: Team Check Function
function IsTeammate(targetName)
    if not teamCheck.Value or not PlayersService then return false end
    
    local lp = dx9.get_localplayer()
    if not lp or not lp.Info then return false end
    
    local localPlayerName = lp.Info.name
    if not localPlayerName then return false end
    
    -- Get local player's team
    local localTeam = nil
    local targetTeam = nil
    
    local players = dx9.GetChildren(PlayersService)
    if not players then return false end
    
    for _, playerObj in ipairs(players) do
        local playerName = dx9.GetName(playerObj)
        
        if playerName == localPlayerName then
            localTeam = dx9.GetTeam(playerObj)
        end
        
        if playerName == targetName then
            targetTeam = dx9.GetTeam(playerObj)
        end
    end
    
    -- If both have teams and they match, they're teammates
    if localTeam and targetTeam and localTeam == targetTeam then
        return true
    end
    
    return false
end

function DrawSkeleton(character, color)
    local connections = {
        {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
        {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
    }
    for _, conn in ipairs(connections) do
        local p1 = dx9.FindFirstChild(character, conn[1])
        local p2 = dx9.FindFirstChild(character, conn[2])
        if p1 and p2 then
            local pos1 = dx9.GetPosition(p1)
            local pos2 = dx9.GetPosition(p2)
            if pos1 and pos2 then
                local s1 = dx9.WorldToScreen({pos1.x, pos1.y, pos1.z})
                local s2 = dx9.WorldToScreen({pos2.x, pos2.y, pos2.z})
                if s1 and s2 and s1.x > 0 and s1.y > 0 and s2.x > 0 and s2.y > 0 then
                    dx9.DrawLine({s1.x, s1.y}, {s2.x, s2.y}, color)
                end
            end
        end
    end
end

function BoxESP(params)
    local target = params.Target
    
    if type(target) ~= "number" or dx9.GetChildren(target) == nil then return end
    
    local hrp = dx9.FindFirstChild(target, "HumanoidRootPart") or dx9.FindFirstChild(target, "Torso")
    if not hrp then return end
    
    local torso = dx9.GetPosition(hrp)
    if not torso then return end
    
    local dist = GetDistanceFromPlayer(torso)
    if dist > distSlider.Value then return end
    
    local targetName = dx9.GetName(target)
    
    -- NEW: Check if teammate and skip if team check is enabled
    local isTeammate = IsTeammate(targetName)
    if teamCheck.Value and isTeammate then
        return -- Skip teammates
    end
    
    -- NEW: Use teammate color if they're on our team
    local box_color = isTeammate and teamColor.Value or colorPicker.Value
    
    local HeadPosY = torso.y + 3
    local LegPosY = torso.y - 3.5
    
    local Top = dx9.WorldToScreen({torso.x, HeadPosY, torso.z})
    local Bottom = dx9.WorldToScreen({torso.x, LegPosY, torso.z})
    
    if not (Top and Bottom and Top.x > 0 and Top.y > 0 and Bottom.y > Top.y) then return end
    
    local height = Bottom.y - Top.y
    local width = height / 2.4
    
    if skeletonEnabled.Value then DrawSkeleton(target, box_color) end
    
    if boxEnabled.Value then
        if box2D.Value then
            dx9.DrawBox({Top.x - width, Top.y}, {Top.x + width, Bottom.y}, box_color)
        else
            local lines = {
                {{Top.x - width, Top.y}, {Top.x - width + (width/2), Top.y}},
                {{Top.x - width, Top.y}, {Top.x - width, Top.y + (height/4)}},
                {{Top.x + width, Top.y}, {Top.x + width - (width/2), Top.y}},
                {{Top.x + width, Top.y}, {Top.x + width, Top.y + (height/4)}},
                {{Top.x - width, Bottom.y}, {Top.x - width + (width/2), Bottom.y}},
                {{Top.x - width, Bottom.y}, {Top.x - width, Bottom.y - (height/4)}},
                {{Top.x + width, Bottom.y}, {Top.x + width - (width/2), Bottom.y}},
                {{Top.x + width, Bottom.y}, {Top.x + width, Bottom.y - (height/4)}}
            }
            for _, line in ipairs(lines) do
                dx9.DrawLine(line[1], line[2], box_color)
            end
        end
    end
    
    -- NEW: Only show distance if toggle is enabled
    if showDistance.Value then
        local dist_str = tostring(dist) .. " studs"
        dx9.DrawString({Bottom.x - (dx9.CalcTextWidth(dist_str)/2), Bottom.y + 4}, box_color, dist_str)
    end
    
    if nameEnabled.Value then
        local name = targetName or "NPC"
        dx9.DrawString({Top.x - (dx9.CalcTextWidth(name)/2), Top.y - 20}, box_color, name)
    end
    
    local humanoid = dx9.FindFirstChild(target, "Humanoid")
    local hp, maxhp = 100, 100
    if humanoid then
        hp = dx9.GetHealth(humanoid) or 100
        maxhp = dx9.GetMaxHealth(humanoid) or 100
    end
    
    if healthtextEnabled.Value then
        local h_str = math.floor(hp) .. "/" .. math.floor(maxhp)
        dx9.DrawString({Top.x - (dx9.CalcTextWidth(h_str)/2), Top.y - 38}, box_color, h_str)
    end
    
    if healthbarEnabled.Value and maxhp > 0 then
        local barWidth = 4
        local barPadding = 2
        local tl = {Top.x + width + barPadding, Top.y}
        local br = {Top.x + width + barPadding + barWidth, Bottom.y}
        
        local healthPercent = math.max(0, math.min(1, hp / maxhp))
        local fill_color = dynamicHealthColor.Value and 
            {math.floor(255 * (1 - healthPercent)), math.floor(255 * healthPercent), 0} or 
            box_color
        
        dx9.DrawBox({tl[1]-1, tl[2]-1}, {br[1]+1, br[2]+1}, {255,255,255})
        dx9.DrawFilledBox({tl[1], tl[2]}, {br[1], br[2]}, {0,0,0})
        
        local fillHeight = (br[2] - tl[2]) * healthPercent
        if fillHeight > 1 then
            dx9.DrawFilledBox({tl[1], br[2] - fillHeight}, {br[1], br[2]}, fill_color)
        end
    end
    
    if tracerEnabled.Value then
        local screenW, screenH = dx9.size().width, dx9.size().height
        local startPos
        local posMap = {
            Bottom = {screenW/2, screenH},
            Top = {screenW/2, 0},
            Middle = {screenW/2, screenH/2},
            Mouse = {dx9.GetMouse().x, dx9.GetMouse().y},
            Left = {0, screenH/2},
            Right = {screenW, screenH/2}
        }
        startPos = posMap[tracerPosition.Value] or posMap.Bottom
        
        dx9.DrawLine(startPos, {Top.x, Bottom.y}, box_color)
    end
end

--// Main loop
coroutine.wrap(function()
    while true do
        if espEnabled.Value then
            local folder = GetObjectFromPath(_G.NPCPath)
            if folder then
                local entities = dx9.GetChildren(folder)
                if entities then
                    for _, ent in ipairs(entities) do
                        pcall(BoxESP, {Target = ent})
                    end
                end
            end
        end
        
        if watermarkEnabled.Value then
            local screenW = dx9.size().width
            local text = "Damon <3"
            local tw = dx9.CalcTextWidth(text)
            local x, y = (screenW - tw)/2, 5
            
            for dx = -4,4,2 do
                for dy = -4,4,2 do
                    if dx ~= 0 or dy ~= 0 then
                        dx9.DrawString({x+dx, y+dy}, {0,0,0}, text)
                    end
                end
            end
            dx9.DrawString({x, y}, {255,0,0}, text)
        end
        
        dx9.Sleep(0)
    end
end)()

Lib:Notify("ESP Loaded! Path: " .. _G.NPCPath, 3)
