local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
-- Hauptfenster (etwas breiter für Sidebar)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 340, 0, 280) -- Breiter wegen Sidebar
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 0)
MainStroke.Thickness = 2
-- Title
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -4, 0, 35)
Title.Position = UDim2.new(0, 2, 0, 2)
Title.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Title.Text = "GIG HUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.BorderSizePixel = 0
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)
-- Sidebar (links für Tabs)
local SideBar = Instance.new("Frame")
SideBar.Parent = MainFrame
SideBar.Size = UDim2.new(0, 100, 1, -40)
SideBar.Position = UDim2.new(0, 2, 0, 39)
SideBar.BackgroundTransparency = 1
SideBar.BorderSizePixel = 0
local SideLayout = Instance.new("UIListLayout", SideBar)
SideLayout.Padding = UDim.new(0, 6)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
-- Content-Bereich (rechts)
local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -110, 1, -45)
ContentFrame.Position = UDim2.new(0, 108, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
-- Search-Bar (oben im Content-Bereich)
local SearchBox = Instance.new("TextBox")
SearchBox.Parent = ContentFrame
SearchBox.Size = UDim2.new(1, -10, 0, 30)
SearchBox.Position = UDim2.new(0, 5, 0, 0)
SearchBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SearchBox.TextColor3 = Color3.fromRGB(0, 255, 0)
SearchBox.PlaceholderText = "Search scripts..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(0, 180, 0)
SearchBox.Text = ""
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 18
SearchBox.ClearTextOnFocus = false
SearchBox.BorderSizePixel = 0
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)
local SearchStroke = Instance.new("UIStroke", SearchBox)
SearchStroke.Color = Color3.fromRGB(0, 255, 0)
SearchStroke.Thickness = 1
-- Funktion zum Erstellen eines Tab-ScrollFrames
local function CreateTabScrollFrame()
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 1, -40) -- Platz für Search
    Scroll.Position = UDim2.new(0, 0, 0, 35)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 6
    Scroll.Visible = false
    Scroll.Parent = ContentFrame
    local Layout = Instance.new("UIListLayout", Scroll)
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Top
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
    end)
    return Scroll, Layout
end
-- Tabs erstellen
local tabs = {}
local tabButtons = {}
local function CreateTab(name, scrollFrame)
    tabs[name] = scrollFrame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Text = name
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local strk = Instance.new("UIStroke", btn)
    strk.Color = Color3.fromRGB(0, 255, 0)
    strk.Thickness = 1.2
    btn.Parent = SideBar
    btn.MouseButton1Click:Connect(function()
        for _, s in pairs(tabs) do
            s.Visible = false
        end
        scrollFrame.Visible = true
        -- Suche neu anwenden
        applySearch()
    end)
    tabButtons[name] = btn
end
-- Button erstellen (jetzt mit parent-Scroll)
local function CreateButton(parentScroll, text, url, note)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.92, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Button.TextColor3 = Color3.fromRGB(0, 255, 0)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 22
    Button.Text = text
    Button.BorderSizePixel = 0
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
    local Stroke = Instance.new("UIStroke", Button)
    Stroke.Color = Color3.fromRGB(0, 255, 0)
    Stroke.Thickness = 1.5
    Button.Parent = parentScroll
    if note then
        Button.Text = text .. " *"
        local hint = Instance.new("TextLabel")
        hint.Size = UDim2.new(1,0,0,20)
        hint.Position = UDim2.new(0,0,1,2)
        hint.BackgroundTransparency = 1
        hint.TextColor3 = Color3.fromRGB(180,180,180)
        hint.TextSize = 14
        hint.Text = note
        hint.Font = Enum.Font.Gotham
        hint.Parent = Button
        hint.Visible = false
        Button.MouseEnter:Connect(function() hint.Visible = true end)
        Button.MouseLeave:Connect(function() hint.Visible = false end)
    end
    Button.MouseButton1Click:Connect(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(url, true))()
        end)
        if not success then
            warn("Fehler bei " .. text .. ": " .. tostring(err))
        end
    end)
    return Button
end
-- Tabs + ScrollFrames erstellen
local universalScroll, univLayout = CreateTabScrollFrame()
local gamesScroll, gamesLayout = CreateTabScrollFrame()
CreateTab("Universal", universalScroll)
CreateTab("Games", gamesScroll)
-- Erster Tab aktiv
universalScroll.Visible = true
-- Buttons hinzufügen (gruppiert)
local allButtons = {} -- für Search-Filter
local function addToUniversal(text, url, note)
    local btn = CreateButton(universalScroll, text, url, note)
    table.insert(allButtons, {btn, text:lower(), universalScroll})
end
local function addToGames(text, url, note)
    local btn = CreateButton(gamesScroll, text, url, note)
    table.insert(allButtons, {btn, text:lower(), gamesScroll})
end
-- Universal Scripts
addToUniversal("Infinity Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
addToUniversal("Fly GIG", "https://raw.githubusercontent.com/user2345600/FlyGiG/main/FlyGiG.lua")
addToUniversal("Auto TP", "https://raw.githubusercontent.com/48-create/CordGIG/refs/heads/main/maincode.lua")
addToUniversal("Universal Emote", "https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua")
addToUniversal("Player TP", "https://raw.githubusercontent.com/48-create/tp-to-playerGIG/refs/heads/main/.gitignore", "Link evtl. falsch?")
-- Game-spezifisch
addToGames("Blade Ball", "https://raw.githubusercontent.com/Urbanstormm/Project-Stark/main/Main.lua")
addToGames("Driving Empire", "https://raw.githubusercontent.com/Marco8642/science/main/drivingempire")
addToGames("Military Tycoon T2", "https://raw.githubusercontent.com/MortyMo22/roblox-scripts/refs/heads/main/MilitaryTycoon")
addToGames("talentPiano", "https://hellohellohell0.com/talentless-raw/TALENTLESS.lua", "Key nötig")
addToGames("AK Admin", "https://absent.wtf/AKADMIN.lua", "Key nötig")
-- Search-Funktion
local function applySearch()
    local query = SearchBox.Text:lower()
    local currentTab = nil
    for name, scroll in pairs(tabs) do
        if scroll.Visible then
            currentTab = scroll
            break
        end
    end
    for _, data in ipairs(allButtons) do
        local btn, txt, parent = unpack(data)
        if parent == currentTab then
            if query == "" or txt:find(query, 1, true) then
                btn.Visible = true
            else
                btn.Visible = false
            end
        end
    end
end
SearchBox:GetPropertyChangedSignal("Text"):Connect(applySearch)
-- K-Toggle
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
-- Optional: Erster Tab-Button optisch hervorheben (aktiv)
tabButtons["Universal"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
