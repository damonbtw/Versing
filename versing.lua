dx9.ShowConsole(false)

--// Check if NPC path is provided
if not _G.NPCPath then
    _G.NPCPath = "Workspace.Entities" -- Default fallback
end

--// Load the DXLib UI library
local Lib = loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLibUI/main/main.lua"))()

--// Create Window with dark red theme
local Window = Lib:CreateWindow({
    Title = "PRINCE UNIVERSAL ESP - @crossmyheart0551 👑",
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

--// Main ESP Settings Groupbox
local MainBox = Tab:AddMiddleGroupbox("ESP Configuration")

--// ESP Toggles
local espEnabled = MainBox:AddToggle({
    Text = "ESP Enabled",
    Default = true
})

local boxEnabled = MainBox:AddToggle({
    Text = "Box ESP",
    Default = true
})

local box2D = MainBox:AddToggle({
    Text = "2D Box (not corner)",
    Default = true
})

local skeletonEnabled = MainBox:AddToggle({
    Text = "Skeleton ESP",
    Default = false
})

local tracerEnabled = MainBox:AddToggle({
    Text = "Tracers",
    Default = false
})

local tracerPosition = MainBox:AddDropdown({
    Text = "Tracer Position",
    Values = {"Bottom", "Top", "Middle", "Mouse", "Left", "Right"},
    Default = 1
})

local healthbarEnabled = MainBox:AddToggle({
    Text = "Health Bar",
    Default = true
})

local healthtextEnabled = MainBox:AddToggle({
    Text = "Health Text",
    Default = true
})

local dynamicHealthColor = MainBox:AddToggle({
    Text = "Dynamic Health Color",
    Default = true
})

MainBox:AddBlank(5)

--// Color Picker - bright cyan
local colorPicker = MainBox:AddColorPicker({
    Text = "ESP Color",
    Default = {0, 255, 255}
})

MainBox:AddBlank(5)

--// Distance Slider
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

-- Settings Tab UI Customization (unchanged)
local UIBox = SettingsTab:AddLeftGroupbox("UI Customization")
UIBox:AddTitle("Accent Color")
UIBox:AddBlank(3)

local redSlider = UIBox:AddSlider({
    Text = "Red",
    Min = 0,
    Max = 255,
    Default = 220,
    Rounding = 0
}):OnChanged(function(value)
    Window.AccentColor = {value, Window.AccentColor[2], Window.AccentColor[3]}
end)

local greenSlider = UIBox:AddSlider({
    Text = "Green",
    Min = 0,
    Max = 255,
    Default = 50,
    Rounding = 0
}):OnChanged(function(value)
    Window.AccentColor = {Window.AccentColor[1], value, Window.AccentColor[3]}
end)

local blueSlider = UIBox:AddSlider({
    Text = "Blue",
    Min = 0,
    Max = 255,
    Default = 60,
    Rounding = 0
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

-- NPC Path Finder (unchanged)
local PathBox = SettingsTab:AddRightGroupbox("NPC Path Finder")
PathBox:AddTitle("Auto-Detect NPCs")
PathBox:AddBlank(3)

local detectedPaths = {}

local function ScanForNPCFolders()
    detectedPaths = {}
    
    if not workspace then return {} end
    
    local workspaceChildren = dx9.GetChildren(workspace)
    if not workspaceChildren then return {} end
    
    for _, child in ipairs(workspaceChildren) do
        local childName = dx9.GetName(child)
        local childChildren = dx9.GetChildren(child)
        
        if childChildren and #childChildren > 0 then
            local hasNPCs = false
            for _, subChild in ipairs(childChildren) do
                local humanoid = dx9.FindFirstChild(subChild, "Humanoid")
                if humanoid then
                    hasNPCs = true
                    break
                end
            end
            
            if hasNPCs then
                table.insert(detectedPaths, "Workspace." .. childName)
            end
        end
    end
    
    return detectedPaths
end

PathBox:AddButton("Scan Workspace", function()
    local paths = ScanForNPCFolders()
    
    if #paths > 0 then
        Lib:Notify("Found " .. #paths .. " folder(s)!", 2)
        if pathDropdown then
            pathDropdown:SetValues(paths)
        end
    else
        Lib:Notify("No NPCs found!", 2, {255, 100, 100})
    end
end)

PathBox:AddBlank(5)

local commonPaths = {
    "Workspace.Entities",
    "Workspace.NPCs", 
    "Workspace.Mobs",
    "Workspace.Enemies"
}

pathDropdown = PathBox:AddDropdown({
    Text = "NPC Path",
    Values = commonPaths,
    Default = 1
}):OnChanged(function(value)
    _G.NPCPath = value
    Lib:Notify("Path: " .. value, 2)
end)

PathBox:AddBlank(5)
PathBox:AddLabel("Active Path:", {160, 160, 170})
PathBox:AddLabel(_G.NPCPath, {100, 255, 100})

-- Misc Tab with watermark toggle
local MiscBox = MiscTab:AddMiddleGroupbox("Misc Options")

local watermarkEnabled = MiscBox:AddToggle({
    Text = "Show Watermark (Damon <3)",
    Default = true
})

--// Get workspace
local workspace = dx9.FindFirstChild(dx9.GetDatamodel(), "Workspace")

--// Parse path to get NPC folder
function GetObjectFromPath(pathString)
    if not pathString or pathString == "" then return nil end
    
    local parts = {}
    for part in string.gmatch(pathString, "[^%.]+") do
        table.insert(parts, part)
    end
    
    if #parts == 0 then return nil end
    
    local current
    if parts[1] == "Workspace" or parts[1] == "workspace" then
        current = workspace
        table.remove(parts, 1)
    else
        current = workspace
    end
    
    for _, part in ipairs(parts) do
        if not current then return nil end
        current = dx9.FindFirstChild(current, part)
    end
    
    return current
end

--// Distance func
function GetDistanceFromPlayer(v)
    local lp = dx9.get_localplayer()
    if not lp then return 99999 end
    local v1 = lp.Position
    local a = (v1.x - v.x) ^ 2 + (v1.y - v.y) ^ 2 + (v1.z - v.z) ^ 2
    return math.floor(math.sqrt(a) + 0.5)
end

--// Draw skeleton
function DrawSkeleton(character, color)
    local connections = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"}
    }
    
    for _, connection in ipairs(connections) do
        local part1 = dx9.FindFirstChild(character, connection[1])
        local part2 = dx9.FindFirstChild(character, connection[2])
        
        if part1 and part2 then
            local pos1 = dx9.GetPosition(part1)
            local pos2 = dx9.GetPosition(part2)
            
            if pos1 and pos2 then
                local screen1 = dx9.WorldToScreen({pos1.x, pos1.y, pos1.z})
                local screen2 = dx9.WorldToScreen({pos2.x, pos2.y, pos2.z})
                
                if screen1 and screen2 and screen1.x > 0 and screen1.y > 0 and screen2.x > 0 and screen2.y > 0 then
                    dx9.DrawLine({screen1.x, screen1.y}, {screen2.x, screen2.y}, color)
                end
            end
        end
    end
end

--// BoxESP
function BoxESP(params)
    local target = params.Target
    local box_color = colorPicker.Value

    if type(target) ~= "number" or dx9.GetChildren(target) == nil then return end

    local hrp = dx9.FindFirstChild(target, "HumanoidRootPart") or dx9.FindFirstChild(target, "Torso")
    if not hrp then return end

    local torso = dx9.GetPosition(hrp)
    if not torso then return end

    local dist = GetDistanceFromPlayer(torso)
    if dist > distSlider.Value then return end

    local HeadPosY = torso.y + 3
    local LegPosY = torso.y - 3.5
    local Top = dx9.WorldToScreen({torso.x, HeadPosY, torso.z})
    local Bottom = dx9.WorldToScreen({torso.x, LegPosY, torso.z})

    if not (Top and Bottom and Top.x > 0 and Top.y > 0 and Bottom.y > Top.y) then return end

    local height = Bottom.y - Top.y
    local width = height / 2.4

    if skeletonEnabled.Value then
        DrawSkeleton(target, box_color)
    end

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

    local dist_str = tostring(dist) .. " studs"
    dx9.DrawString({Bottom.x - (dx9.CalcTextWidth(dist_str) / 2), Bottom.y + 4}, box_color, dist_str)

    local name = dx9.GetName(target) or "NPC"
    dx9.DrawString({Top.x - (dx9.CalcTextWidth(name) / 2), Top.y - 20}, box_color, name)

    local humanoid = dx9.FindFirstChild(target, "Humanoid")
    local hp = 100
    local maxhp = 100
    if humanoid then
        hp = dx9.GetHealth(humanoid) or 100
        maxhp = dx9.GetMaxHealth(humanoid) or 100
    end

    if healthtextEnabled.Value then
        local h_str = math.floor(hp) .. "/" .. math.floor(maxhp)
        dx9.DrawString({Top.x - (dx9.CalcTextWidth(h_str) / 2), Top.y - 38}, box_color, h_str)
    end

    if healthbarEnabled.Value and maxhp > 0 then
        local barWidth = 4
        local barPadding = 2
        local tl = {Top.x + width + barPadding, Top.y}
        local br = {Top.x + width + barPadding + barWidth, Bottom.y}
        
        local healthPercent = math.max(0, math.min(1, hp / maxhp))
        
        local fill_color
        if dynamicHealthColor.Value then
            local red = math.floor(255 * (1 - healthPercent))
            local green = math.floor(255 * healthPercent)
            fill_color = {red, green, 0}
        else
            fill_color = box_color
        end
        
        dx9.DrawBox({tl[1] - 1, tl[2] - 1}, {br[1] + 1, br[2] + 1}, {255, 255, 255})
        dx9.DrawFilledBox({tl[1], tl[2]}, {br[1], br[2]}, {0, 0, 0})
        
        local barHeight = br[2] - tl[2]
        local fillHeight = barHeight * healthPercent
        local fillTop = br[2] - fillHeight
        
        if fillHeight > 1 then
            dx9.DrawFilledBox({tl[1], fillTop}, {br[1], br[2]}, fill_color)
        end
    end

    if tracerEnabled.Value then
        local tracerStart
        local screenW = dx9.size().width
        local screenH = dx9.size().height
        
        if tracerPosition.Value == "Bottom" then
            tracerStart = {screenW / 2, screenH}
        elseif tracerPosition.Value == "Top" then
            tracerStart = {screenW / 2, 0}
        elseif tracerPosition.Value == "Middle" then
            tracerStart = {screenW / 2, screenH / 2}
        elseif tracerPosition.Value == "Mouse" then
            local mouse = dx9.GetMouse()
            tracerStart = {mouse.x, mouse.y}
        elseif tracerPosition.Value == "Left" then
            tracerStart = {0, screenH / 2}
        elseif tracerPosition.Value == "Right" then
            tracerStart = {screenW, screenH / 2}
        else
            tracerStart = {screenW / 2, screenH}
        end
        
        dx9.DrawLine(tracerStart, {Top.x, Bottom.y}, box_color)
    end
end

--// Main ESP + Watermark loop (watermark now very high up at y=5)
coroutine.wrap(function()
    while true do
        if espEnabled.Value then
            local npcFolder = GetObjectFromPath(_G.NPCPath)
            
            if npcFolder then
                local entities = dx9.GetChildren(npcFolder)
                if entities then
                    for _, ent in ipairs(entities) do
                        pcall(BoxESP, {Target = ent})
                    end
                end
            end
        end
        
        -- Watermark: super high at top (y=5), thick outline, centered
        if watermarkEnabled.Value then
            local screenW = dx9.size().width
            local text = "Damon <3"
            local textWidth = dx9.CalcTextWidth(text)
            local x = (screenW - textWidth) / 2
            local y = 5  -- Very top (was 20, now much higher)
            
            -- Thick black outline (multiple layers for max visibility)
            for dx = -4, 4, 2 do
                for dy = -4, 4, 2 do
                    if dx ~= 0 or dy ~= 0 then
                        dx9.DrawString({x + dx, y + dy}, {0, 0, 0}, text)
                    end
                end
            end
            
            -- Bright red main text
            dx9.DrawString({x, y}, {255, 0, 0}, text)
        end
        
        dx9.Sleep(0)
    end
end)()

Lib:Notify("ESP Loaded! Path: " .. _G.NPCPath, 3)
