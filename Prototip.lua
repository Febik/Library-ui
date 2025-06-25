local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Lighting = game.Lighting


-- Командные ID
-- Глобальные переменные для конфигов
fovBox = nil
smoothnessBox = nil
rangeBox = nil
speedBox = nil
jumpBox = nil


local RED_IDS = { "rbxassetid://73715024150115" }
local BLUE_IDS = { "rbxassetid://80105200189958" }

local function getTeam()
	local shirt = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Shirt")
	if not shirt then return nil end

	local id = shirt.ShirtTemplate:lower()
	if id:find("73715024150115") then return "red" end
	if id:find("80105200189958") then return "blue" end
	return nil
end

local function isEnemy(player)
	local myTeam = getTeam()
	if not myTeam or not player.Character then return false end

	local shirt = player.Character:FindFirstChildWhichIsA("Shirt")
	if not shirt then return false end

	local id = shirt.ShirtTemplate:lower()

	if myTeam == "red" then
		return id:find("80105200189958")
	elseif myTeam == "blue" then
		return id:find("73715024150115")
	end
	return false
end

local Lighting = game.Lighting
local Camera = workspace.CurrentCamera
local targetPlayer = nil
local targetPart = nil
local hitboxName = "Head" -- или HumanoidRootPart
local silent_aim_target = nil
local silent_aim_is_targetting = false
local triggerEnabled = false
local autoWallEnabled = false
local script = {
	functions = {},
	locals = {
		silent_aim_target = nil,
		silent_aim_is_targetting = false
	}
}



-- Основной GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "NeverloseGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true

-- Темы
local isDark = true
local darkTheme = {
    Background = Color3.fromRGB(20, 20, 25),
    Sidebar = Color3.fromRGB(15, 15, 20),
    Accent = Color3.fromRGB(60, 180, 255),
    Text = Color3.fromRGB(200, 200, 255)
}

local lightTheme = {
    Background = Color3.fromRGB(245, 245, 255),
    Sidebar = Color3.fromRGB(220, 220, 240),
    Accent = Color3.fromRGB(60, 120, 255),
    Text = Color3.fromRGB(30, 30, 40)
}

-- Переменная видимости GUI
local GUIOpen = true

-- Основная рамка
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 880, 0, 550)
MainFrame.Position = UDim2.new(0.5, -440, 0.5, -275)
MainFrame.BackgroundColor3 = darkTheme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true

-- Заголовок
Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Header.BorderSizePixel = 0

SaveBtn = Instance.new("TextButton", Header)
SaveBtn.Size = UDim2.new(0, 80, 0, 30)
SaveBtn.Position = UDim2.new(1, -90, 0, 5)
SaveBtn.Text = "Save"
SaveBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
SaveBtn.TextColor3 = darkTheme.Accent
SaveBtn.BorderSizePixel = 0
SaveBtn.Font = Enum.Font.SourceSansBold
SaveBtn.TextSize = 16

-- Боковая панель
Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = darkTheme.Sidebar
Sidebar.BorderSizePixel = 0

-- Контейнер вкладок
local TabNames = {
    "Ragebot", "Anti Aim", "Legitbot", "Players", "ESP",
    "Client", "World", "View", "Malicious",  "AutoBuy", "Configs"
}
local AimPart = "Head"

local Tabs = {}
local ContentFrames = {}

for i, tabName in ipairs(TabNames) do
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(1, -10, 0, 30)
    TabBtn.Position = UDim2.new(0, 5, 0, 5 + (i - 1) * 35)
    TabBtn.Text = tabName
    TabBtn.Font = Enum.Font.SourceSans
    TabBtn.TextSize = 16
    TabBtn.TextColor3 = darkTheme.Text
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabBtn.BorderSizePixel = 0

    Tabs[tabName] = TabBtn

    -- Контейнер для вкладки
    local Content = Instance.new("Frame", MainFrame)
    Content.Name = tabName .. "Content"
    Content.Position = UDim2.new(0, 170, 0, 50)
    Content.Size = UDim2.new(1, -180, 1, -60)
    Content.Visible = false
    Content.BackgroundTransparency = 1
    ContentFrames[tabName] = Content

    TabBtn.MouseButton1Click:Connect(function()
        for _, frame in pairs(ContentFrames) do frame.Visible = false end
        Content.Visible = true
    end)
end

-- 📌 RageBotFrame расширение: FOV круг + Dropdown выбора зоны стрельбы + TriggerBot с кнопкой включения

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer


--// ССЫЛКА НА ВАШУ ВКЛАДКУ
local RageBotFrame = ContentFrames["Ragebot"]

--// UI элементы
silentAimFrame = Instance.new("Frame", RageBotFrame)
silentAimFrame.Name = "SilentAimSettings"
silentAimFrame.Size = UDim2.new(0, 230, 0, 320)
silentAimFrame.Position = UDim2.new(0, 10, 0, 10)
silentAimFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
silentAimFrame.BorderSizePixel = 0

-- Часть тела (Dropdown)
dropdown = Instance.new("TextButton", silentAimFrame)
dropdown.Size = UDim2.new(0, 200, 0, 30)
dropdown.Position = UDim2.new(0, 15, 0, 10)
dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.Font = Enum.Font.Code
dropdown.TextSize = 14
dropdown.Text = "Target: HumanoidRootPart"

local parts = {"Head", "Torso", "HumanoidRootPart", "LeftFoot", "RightHand"}
local partIndex = 3

dropdown.MouseButton1Click:Connect(function()
	partIndex = partIndex % #parts + 1
	dropdown.Text = "Target: " .. parts[partIndex]
end)

-- Silent Aim Toggle
toggle = Instance.new("TextButton", silentAimFrame)
toggle.Size = UDim2.new(0, 200, 0, 30)
toggle.Position = UDim2.new(0, 15, 0, 50)
toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.Code
toggle.TextSize = 14
toggle.Text = "Silent Aim: OFF"

local enabled = false -- или true, если по умолчанию FOV включён

toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggle.Text = "Silent Aim: " .. (enabled and "ON" or "OFF")
end)

-- FOV TextBox
fovBox = Instance.new("TextBox", silentAimFrame)
fovBox.Size = UDim2.new(0, 200, 0, 30)
fovBox.Position = UDim2.new(0, 15, 0, 90)
fovBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
fovBox.TextColor3 = Color3.new(1, 1, 1)
fovBox.Font = Enum.Font.Code
fovBox.TextSize = 14
fovBox.Text = "150"
fovBox.ClearTextOnFocus = false
fovBox.PlaceholderText = "FOV"

--// Silent Aim core logic
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local targetPlayer = nil
local targetPart = nil


-- Получить ближайшего игрока
local function getClosestPlayer()
	local shortest = tonumber(fovBox.Text)
	local closest, part

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == LocalPlayer then continue end
		local char = plr.Character
		if not char then continue end

		local bodyPart = char:FindFirstChild(parts[partIndex])
		if not bodyPart then continue end

		local screenPos, onScreen = Camera:WorldToViewportPoint(bodyPart.Position)
		if not onScreen then continue end

		local mousePos = UserInputService:GetMouseLocation()
		local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

		if distance < shortest then
			shortest = distance
			closest = plr
			part = bodyPart
		end
	end

	return closest, part
end

-- Обновление цели
RunService.RenderStepped:Connect(function()
	if enabled then
		local shortest = tonumber(fovBox.Text) or 150
		local closest, part
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr == LocalPlayer then continue end
			local char = plr.Character
			if not char then continue end

			local bodyPart = char:FindFirstChild(parts[partIndex])
			if not bodyPart then continue end

			local screenPos, onScreen = Camera:WorldToViewportPoint(bodyPart.Position)
			if not onScreen then continue end

			local mousePos = UserInputService:GetMouseLocation()
			local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

			if distance < shortest then
				shortest = distance
				silent_aim_target = plr
			end
		end
	end
end)

RunService.RenderStepped:Connect(function()
	targetPlayer = silent_aim_target
	if targetPlayer and targetPlayer.Character then
		targetPart = targetPlayer.Character:FindFirstChild(parts[partIndex])
	else
		targetPart = nil
	end

	if triggerEnabled and enabled and targetPlayer and targetPart and not GUIOpen then
		local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
		if onScreen then
			local mousePos = UserInputService:GetMouseLocation()
			local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
			local fov = tonumber(fovBox.Text) or 150

			if dist < fov and isEnemy(targetPlayer) then
				local char = targetPlayer.Character
					if char and not char:FindFirstChildOfClass("ForceField") then
						if autoWallEnabled or (not autoWallEnabled and canShootThrough(targetPart)) then
							mouse1click()
						end
					end
			end
		end
	end
end)


-- Raycast перехват
local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
	local args = {...}
	local method = getnamecallmethod()

	if not checkcaller() and enabled and targetPlayer and method == "Raycast" and self == workspace then
		if typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
			local origin = args[1]
			if targetPart then
				args[2] = (targetPart.Position - origin).Unit * 1000
				return __namecall(self, unpack(args))
			end
		end
	end

	return __namecall(self, ...)
end)




local RunService = game:GetService("RunService")

-- Переключение GUI клавишей "P"
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.P then
		GUIOpen = not GUIOpen
		MainFrame.Visible = GUIOpen

		if GUIOpen then
			UIS.MouseIconEnabled = true
			UIS.MouseBehavior = Enum.MouseBehavior.Default
		else
			UIS.MouseIconEnabled = false
			UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
		end
	end
end)


-- ⛑ Автоматическая проверка (на случай принудительных изменений от игры)
RunService.RenderStepped:Connect(function()
	if GUIOpen then
		if UIS.MouseBehavior ~= Enum.MouseBehavior.Default then
			UIS.MouseBehavior = Enum.MouseBehavior.Default
		end
		if not UIS.MouseIconEnabled then
			UIS.MouseIconEnabled = true
		end
	end
end)



local PlayersFrame = ContentFrames["Players"]

-- Список игроков
local PlayerList = Instance.new("ScrollingFrame", PlayersFrame)
PlayerList.Size = UDim2.new(1, 0, 1, 0)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ScrollBarThickness = 6
PlayerList.BackgroundTransparency = 1
PlayerList.Name = "PlayerList"

-- Функция создания карточки игрока
local function createPlayerCard(plr)
	local Card = Instance.new("Frame")
	Card.Size = UDim2.new(1, -10, 0, 110)
	Card.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
	Card.BackgroundTransparency = 0.5
	Card.BorderSizePixel = 0
	Card.Position = UDim2.new(0, 5, 0, 0)
	Card.Name = plr.Name
	Card.AutomaticSize = Enum.AutomaticSize.Y
	Card.ClipsDescendants = true
	Card.Parent = PlayerList

	local UICorner = Instance.new("UICorner", Card)
	UICorner.CornerRadius = UDim.new(0, 10)

	local Thumbnail = Instance.new("ImageLabel", Card)
	Thumbnail.Size = UDim2.new(0, 60, 0, 60)
	Thumbnail.Position = UDim2.new(0, 10, 0, 10)
	Thumbnail.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..plr.UserId.."&width=420&height=420&format=png"
	Thumbnail.BackgroundTransparency = 1

	local Info = Instance.new("TextLabel", Card)
	Info.Text = string.format("ID: %s\nHP: %.0f\nWalkSpeed: %.0f\nJumpPower: %.0f",
		plr.UserId,
		plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health or 0,
		plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.WalkSpeed or 16,
		plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.JumpPower or 50
	)
	Info.Position = UDim2.new(0, 80, 0, 10)
	Info.Size = UDim2.new(1, -90, 0, 60)
	Info.TextColor3 = Color3.new(1,1,1)
	Info.TextXAlignment = Enum.TextXAlignment.Left
	Info.TextYAlignment = Enum.TextYAlignment.Top
	Info.Font = Enum.Font.SourceSans
	Info.TextSize = 14
	Info.BackgroundTransparency = 1

	-- Кнопки
	local function makeButton(text, yOffset, callback)
		local Btn = Instance.new("TextButton", Card)
		Btn.Size = UDim2.new(0, 100, 0, 20)
		Btn.Position = UDim2.new(0, 10 + (110 * yOffset), 0, 80)
		Btn.Text = text
		Btn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
		Btn.TextColor3 = Color3.new(1,1,1)
		Btn.Font = Enum.Font.SourceSansBold
		Btn.TextSize = 13
		Btn.BorderSizePixel = 0
		Btn.MouseButton1Click:Connect(callback)
	end

	makeButton("TP", 0, function()
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position)
		end
	end)

	makeButton("Big", 1, function()
		if plr.Character then
			for _, p in ipairs(plr.Character:GetDescendants()) do
				if p:IsA("BasePart") then p.Size = p.Size * 1.5 end
			end
		end
	end)

	makeButton("Small", 2, function()
		if plr.Character then
			for _, p in ipairs(plr.Character:GetDescendants()) do
				if p:IsA("BasePart") then p.Size = p.Size * 0.5 end
			end
		end
	end)

	makeButton("Color", 3, function()
		if plr.Character then
			for _, p in ipairs(plr.Character:GetDescendants()) do
				if p:IsA("BasePart") then p.Color = Color3.fromRGB(math.random(50,255),math.random(50,255),math.random(50,255)) end
			end
		end
	end)

	makeButton("🔥 Flame", 4, function()
		if plr.Character then
			local flame = Instance.new("Fire")
			flame.Size = 5
			flame.Heat = 10
			flame.Parent = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChildWhichIsA("BasePart")
		end
	end)
	return Card
end

-- Обновление списка игроков
local function updatePlayerList()
	PlayerList:ClearAllChildren()
	local y = 0
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local card = createPlayerCard(p)
			card.Position = UDim2.new(0, 5, 0, y)
			y = y + 120
		end
	end
	PlayerList.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

-- Обновляем при заходе/выходе
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

local ESPFrame = ContentFrames["ESP"]

function createCheckbox(name, y, default, callback)
	local checkbox = Instance.new("TextButton", ESPFrame)
	checkbox.Size = UDim2.new(0, 180, 0, 25)
	checkbox.Position = UDim2.new(0, 10, 0, y)
	checkbox.Text = name .. ": " .. (default and "ON" or "OFF")
	checkbox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	checkbox.TextColor3 = Color3.new(1, 1, 1)
	checkbox.Font = Enum.Font.SourceSansBold
	checkbox.TextSize = 14

	local state = default
	checkbox.MouseButton1Click:Connect(function()
		state = not state
		checkbox.Text = name .. ": " .. (state and "ON" or "OFF")
		if callback then callback(state) end
	end)

	return checkbox
end

-- ✅ Chams с врагами/союзниками + рандомные цвета и радужный режим
local chamsEnemies = false
local chamsFriends = false
local chamsRainbow = false
local enemyColor = Color3.fromRGB(255, 0, 0)
local friendColor = Color3.fromRGB(0, 150, 255)

-- Функция обновления Chams
local function applyChams()
	local folder = workspace:FindFirstChild("Players")
	if not folder then return end

	for _, model in ipairs(folder:GetChildren()) do
		if model:IsA("Model") and model.Name ~= LocalPlayer.Name then
			-- Удалить все Highlight
			for _, obj in ipairs(model:GetChildren()) do
				if obj:IsA("Highlight") then obj:Destroy() end
			end

			local shirt = model:FindFirstChildOfClass("Shirt")
			local isEnemy = shirt and shirt.ShirtTemplate and shirt.ShirtTemplate:find("73715024150115")
			local isFriend = shirt and shirt.ShirtTemplate and shirt.ShirtTemplate:find("80105200189958")

			local shouldApply = (isEnemy and chamsEnemies) or (isFriend and chamsFriends)
			if shouldApply then
				local hl = Instance.new("Highlight")
				if isEnemy then
					hl.FillColor = chamsRainbow and Color3.fromRGB(255, 255, 255) or enemyColor
				elseif isFriend then
					hl.FillColor = chamsRainbow and Color3.fromRGB(255, 255, 255) or friendColor
				end
				hl.OutlineColor = Color3.new(1, 1, 1)
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Name = "CustomChams"
				hl.Parent = model
			end
		end
	end
end


-- Кнопки в GUI
enemyChamsBtn = Instance.new("TextButton", ESPFrame)
enemyChamsBtn.Size = UDim2.new(0, 180, 0, 25)
enemyChamsBtn.Position = UDim2.new(0, 10, 0, 240)
enemyChamsBtn.Text = "Chams (Враги): OFF"
enemyChamsBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
enemyChamsBtn.TextColor3 = Color3.new(1,1,1)
enemyChamsBtn.Font = Enum.Font.SourceSansBold
enemyChamsBtn.TextSize = 14
enemyChamsBtn.MouseButton1Click:Connect(function()
	chamsEnemies = not chamsEnemies
	enemyChamsBtn.Text = "Chams (Враги): " .. (chamsEnemies and "ON" or "OFF")
	applyChams()
end)

friendChamsBtn = Instance.new("TextButton", ESPFrame)
friendChamsBtn.Size = UDim2.new(0, 180, 0, 25)
friendChamsBtn.Position = UDim2.new(0, 10, 0, 270)
friendChamsBtn.Text = "Chams (Друзья): OFF"
friendChamsBtn.BackgroundColor3 = Color3.fromRGB(50, 80, 120)
friendChamsBtn.TextColor3 = Color3.new(1,1,1)
friendChamsBtn.Font = Enum.Font.SourceSansBold
friendChamsBtn.TextSize = 14
friendChamsBtn.MouseButton1Click:Connect(function()
	chamsFriends = not chamsFriends
	friendChamsBtn.Text = "Chams (Друзья): " .. (chamsFriends and "ON" or "OFF")
	applyChams()
end)

randEnemy = Instance.new("TextButton", ESPFrame)
randEnemy.Size = UDim2.new(0, 180, 0, 25)
randEnemy.Position = UDim2.new(0, 10, 0, 300)
randEnemy.Text = "🎨 Враг цвет"
randEnemy.BackgroundColor3 = enemyColor
randEnemy.TextColor3 = Color3.new(1,1,1)
randEnemy.Font = Enum.Font.SourceSans
randEnemy.TextSize = 14
randEnemy.MouseButton1Click:Connect(function()
	enemyColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
	randEnemy.BackgroundColor3 = enemyColor
	applyChams()
end)

randFriend = Instance.new("TextButton", ESPFrame)
randFriend.Size = UDim2.new(0, 180, 0, 25)
randFriend.Position = UDim2.new(0, 10, 0, 330)
randFriend.Text = "🎨 Союзник цвет"
randFriend.BackgroundColor3 = friendColor
randFriend.TextColor3 = Color3.new(1,1,1)
randFriend.Font = Enum.Font.SourceSans
randFriend.TextSize = 14
randFriend.MouseButton1Click:Connect(function()
	friendColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
	randFriend.BackgroundColor3 = friendColor
	applyChams()
end)

rainbowBtn = Instance.new("TextButton", ESPFrame)
rainbowBtn.Size = UDim2.new(0, 180, 0, 25)
rainbowBtn.Position = UDim2.new(0, 10, 0, 360)
rainbowBtn.Text = "🌈 Радуга: OFF"
rainbowBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
rainbowBtn.TextColor3 = Color3.new(1,1,1)
rainbowBtn.Font = Enum.Font.SourceSansBold
rainbowBtn.TextSize = 14
rainbowBtn.MouseButton1Click:Connect(function()
	chamsRainbow = not chamsRainbow
	rainbowBtn.Text = "🌈 Радуга: " .. (chamsRainbow and "ON" or "OFF")
end)

-- Радужный эффект
RunService.RenderStepped:Connect(function()
	if not chamsRainbow then return end
	local t = tick() * 2
	local rainbow = Color3.fromHSV((t % 5)/5, 1, 1)

	local folder = workspace:FindFirstChild("Players")
	if folder then
		for _, model in ipairs(folder:GetChildren()) do
			if model:IsA("Model") and model.Name ~= LocalPlayer.Name then
				local hl = model:FindFirstChild("CustomChams")
				if hl and hl:IsA("Highlight") then
					hl.FillColor = rainbow
				end
			end
		end
	end
end)

-- Вызов при старте
applyChams()

local playersFolder = workspace:FindFirstChild("Players")
if playersFolder then
	playersFolder.ChildAdded:Connect(function(child)
		task.wait(0.25) -- Подождать появления Shirt и т.п.
		applyChams()
	end)
end

-- Переобновим чекбоксы чтобы они вызывали refreshESP
-- Пример:
-- createCheckbox("ESP", 50, false, wrapToggle(function(val) espEnabled = val end))
-- Аналогично для boxEnabled, hpbarEnabled, nameEnabled


local ClientFrame = ContentFrames["Client"]

-- Client Enable Toggle
local clientEnabled = true
clientToggle = Instance.new("TextButton", ClientFrame)
clientToggle.Size = UDim2.new(0, 180, 0, 30)
clientToggle.Position = UDim2.new(0, 10, 0, 10)
clientToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
clientToggle.TextColor3 = Color3.new(1, 1, 1)
clientToggle.Font = Enum.Font.SourceSansBold
clientToggle.TextSize = 16
clientToggle.Text = "Client: ON"

clientToggle.MouseButton1Click:Connect(function()
	clientEnabled = not clientEnabled
	clientToggle.Text = "Client: " .. (clientEnabled and "ON" or "OFF")
end)

-- WalkSpeed настройка
speedLabel = Instance.new("TextLabel", ClientFrame)
speedLabel.Text = "WalkSpeed:"
speedLabel.Position = UDim2.new(0, 10, 0, 50)
speedLabel.Size = UDim2.new(0, 100, 0, 20)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 14

clientSpeedBox = Instance.new("TextBox", ClientFrame)
clientSpeedBox.Text = "16"
clientSpeedBox.Position = UDim2.new(0, 120, 0, 50)
clientSpeedBox.Size = UDim2.new(0, 50, 0, 20)
clientSpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
clientSpeedBox.TextColor3 = Color3.new(1, 1, 1)
clientSpeedBox.Font = Enum.Font.SourceSans
clientSpeedBox.TextSize = 14

-- JumpPower настройка
jumpLabel = Instance.new("TextLabel", ClientFrame)
jumpLabel.Text = "JumpPower:"
jumpLabel.Position = UDim2.new(0, 10, 0, 80)
jumpLabel.Size = UDim2.new(0, 100, 0, 20)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.new(1,1,1)
jumpLabel.Font = Enum.Font.SourceSans
jumpLabel.TextSize = 14

jumpBox = Instance.new("TextBox", ClientFrame)
jumpBox.Text = "50"
jumpBox.Position = UDim2.new(0, 120, 0, 80)
jumpBox.Size = UDim2.new(0, 50, 0, 20)
jumpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
jumpBox.TextColor3 = Color3.new(1, 1, 1)
jumpBox.Font = Enum.Font.SourceSans
jumpBox.TextSize = 14

-- Инфо как было в "Main"
local infoLabel = Instance.new("TextLabel", ClientFrame)
infoLabel.Text = string.format("Nickname: %s\nUserID: %s\nPlaceID: %s\nPlayers: %d",
	LocalPlayer.Name,
	LocalPlayer.UserId,
	game.PlaceId,
	#Players:GetPlayers()
)
infoLabel.Position = UDim2.new(0, 10, 0, 120)
infoLabel.Size = UDim2.new(0, 260, 0, 70)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.new(1,1,1)
infoLabel.Font = Enum.Font.SourceSansBold
infoLabel.TextSize = 14
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top

-- Обновление значений
RunService.RenderStepped:Connect(function()
	if clientEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		local hum = LocalPlayer.Character.Humanoid
		local speed = tonumber(speedBox.Text)
		local jump = tonumber(jumpBox.Text)
		if speed then hum.WalkSpeed = speed end
		if jump then hum.JumpPower = jump end
	end
end)

local WorldFrame = ContentFrames["World"]

-- Заголовок
worldLabel = Instance.new("TextLabel", WorldFrame)
worldLabel.Text = "Настройки мира"
worldLabel.Size = UDim2.new(0, 200, 0, 30)
worldLabel.Position = UDim2.new(0, 10, 0, 10)
worldLabel.Font = Enum.Font.SourceSansBold
worldLabel.TextSize = 18
worldLabel.TextColor3 = Color3.new(1,1,1)
worldLabel.BackgroundTransparency = 1

-- Ambient Color
ambientBtn = Instance.new("TextButton", WorldFrame)
ambientBtn.Size = UDim2.new(0, 180, 0, 25)
ambientBtn.Position = UDim2.new(0, 10, 0, 50)
ambientBtn.Text = "Ambient Цвет"
ambientBtn.BackgroundColor3 = Lighting.Ambient
ambientBtn.TextColor3 = Color3.new(1,1,1)
ambientBtn.Font = Enum.Font.SourceSansBold
ambientBtn.TextSize = 14

ambientBtn.MouseButton1Click:Connect(function()
	local newColor = Color3.fromRGB(math.random(50,255), math.random(50,255), math.random(50,255))
	ambientBtn.BackgroundColor3 = newColor
	Lighting.Ambient = newColor
end)

-- Туман Вкл/Выкл
local fogEnabled = false
fogToggle = Instance.new("TextButton", WorldFrame)
fogToggle.Size = UDim2.new(0, 180, 0, 25)
fogToggle.Position = UDim2.new(0, 10, 0, 90)
fogToggle.Text = "Туман: OFF"
fogToggle.BackgroundColor3 = Color3.fromRGB(40,40,60)
fogToggle.TextColor3 = Color3.new(1,1,1)
fogToggle.Font = Enum.Font.SourceSans
fogToggle.TextSize = 14

fogToggle.MouseButton1Click:Connect(function()
	fogEnabled = not fogEnabled
	fogToggle.Text = "Туман: " .. (fogEnabled and "ON" or "OFF")
	if fogEnabled then
		fixedFogStart = Lighting.FogStart
		fixedFogEnd = Lighting.FogEnd
	else
		Lighting.FogStart = 999999
		Lighting.FogEnd = 1000000
	end
end)

-- Цвет тумана
fogColorBtn = Instance.new("TextButton", WorldFrame)
fogColorBtn.Size = UDim2.new(0, 180, 0, 25)
fogColorBtn.Position = UDim2.new(0, 10, 0, 130)
fogColorBtn.Text = "Fog Цвет"
fogColorBtn.BackgroundColor3 = Lighting.FogColor
fogColorBtn.TextColor3 = Color3.new(1,1,1)
fogColorBtn.Font = Enum.Font.SourceSansBold
fogColorBtn.TextSize = 14

fogColorBtn.MouseButton1Click:Connect(function()
	local newColor = Color3.fromRGB(math.random(50,255), math.random(50,255), math.random(50,255))
	fogColorBtn.BackgroundColor3 = newColor
	Lighting.FogColor = newColor
end)

-- Установка Skybox по ID
skyLabel = Instance.new("TextLabel", WorldFrame)
skyLabel.Text = "Skybox ID (Texture):"
skyLabel.Position = UDim2.new(0, 10, 0, 170)
skyLabel.Size = UDim2.new(0, 200, 0, 20)
skyLabel.BackgroundTransparency = 1
skyLabel.TextColor3 = Color3.new(1,1,1)
skyLabel.Font = Enum.Font.SourceSans
skyLabel.TextSize = 14

skyBox = Instance.new("TextBox", WorldFrame)
skyBox.Text = ""
skyBox.PlaceholderText = "123456789"
skyBox.Position = UDim2.new(0, 10, 0, 195)
skyBox.Size = UDim2.new(0, 180, 0, 25)
skyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
skyBox.TextColor3 = Color3.new(1, 1, 1)
skyBox.Font = Enum.Font.SourceSans
skyBox.TextSize = 14

applySky = Instance.new("TextButton", WorldFrame)
applySky.Text = "Установить Skybox"
applySky.Position = UDim2.new(0, 10, 0, 225)
applySky.Size = UDim2.new(0, 180, 0, 25)
applySky.BackgroundColor3 = Color3.fromRGB(40,40,60)
applySky.TextColor3 = Color3.new(1,1,1)
applySky.Font = Enum.Font.SourceSansBold
applySky.TextSize = 14

applySky.MouseButton1Click:Connect(function()
	local id = tonumber(skyBox.Text)
	if id then
		local sky = Instance.new("Sky")
		sky.SkyboxBk = "rbxassetid://" .. id
		sky.SkyboxDn = "rbxassetid://" .. id
		sky.SkyboxFt = "rbxassetid://" .. id
		sky.SkyboxLf = "rbxassetid://" .. id
		sky.SkyboxRt = "rbxassetid://" .. id
		sky.SkyboxUp = "rbxassetid://" .. id
		Lighting:ClearAllChildren()
		sky.Parent = Lighting
	end
end)

local ViewFrame = ContentFrames["View"]
local Camera = workspace.CurrentCamera

-- Заголовок
viewLabel = Instance.new("TextLabel", ViewFrame)
viewLabel.Text = "Настройка поля зрения (FOV)"
viewLabel.Size = UDim2.new(0, 300, 0, 30)
viewLabel.Position = UDim2.new(0, 10, 0, 10)
viewLabel.Font = Enum.Font.SourceSansBold
viewLabel.TextSize = 18
viewLabel.TextColor3 = Color3.new(1,1,1)
viewLabel.BackgroundTransparency = 1

-- Поле ввода FOV
fovLabel = Instance.new("TextLabel", ViewFrame)
fovLabel.Text = "FOV (по умолчанию 70):"
fovLabel.Position = UDim2.new(0, 10, 0, 50)
fovLabel.Size = UDim2.new(0, 200, 0, 20)
fovLabel.BackgroundTransparency = 1
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.Font = Enum.Font.SourceSans
fovLabel.TextSize = 14

fovBox = Instance.new("TextBox", ViewFrame)
fovBox.Text = tostring(Camera.FieldOfView)
fovBox.Position = UDim2.new(0, 10, 0, 75)
fovBox.Size = UDim2.new(0, 100, 0, 25)
fovBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
fovBox.TextColor3 = Color3.new(1, 1, 1)
fovBox.Font = Enum.Font.SourceSans
fovBox.TextSize = 14

-- Применение FOV
applyFov = Instance.new("TextButton", ViewFrame)
applyFov.Text = "Применить FOV"
applyFov.Position = UDim2.new(0, 120, 0, 75)
applyFov.Size = UDim2.new(0, 100, 0, 25)
applyFov.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
applyFov.TextColor3 = Color3.new(1,1,1)
applyFov.Font = Enum.Font.SourceSansBold
applyFov.TextSize = 14

applyFov.MouseButton1Click:Connect(function()
	local newFov = tonumber(fovBox.Text)
	if newFov and newFov >= 1 and newFov <= 120 then
		Camera.FieldOfView = newFov
	end
end)

local LegitFrame = ContentFrames["Legitbot"]
local legitEnabled = false
local resolverEnabled = false

-- Заголовок
legitLabel = Instance.new("TextLabel", LegitFrame)
legitLabel.Text = "Настройки LegitBot"
legitLabel.Size = UDim2.new(0, 300, 0, 30)
legitLabel.Position = UDim2.new(0, 10, 0, 10)
legitLabel.Font = Enum.Font.SourceSansBold
legitLabel.TextSize = 18
legitLabel.TextColor3 = Color3.new(1,1,1)
legitLabel.BackgroundTransparency = 1

-- LegitBot On/Off
legitToggle = Instance.new("TextButton", LegitFrame)
legitToggle.Size = UDim2.new(0, 180, 0, 30)
legitToggle.Position = UDim2.new(0, 10, 0, 50)
legitToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
legitToggle.TextColor3 = Color3.new(1, 1, 1)
legitToggle.Font = Enum.Font.SourceSansBold
legitToggle.TextSize = 16
legitToggle.Text = "LegitBot: OFF"

legitToggle.MouseButton1Click:Connect(function()
	legitEnabled = not legitEnabled
	legitToggle.Text = "LegitBot: " .. (legitEnabled and "ON" or "OFF")
end)

-- Smoothness
smoothnessLabel = Instance.new("TextLabel", LegitFrame)
smoothnessLabel.Text = "Smoothness:"
smoothnessLabel.Position = UDim2.new(0, 10, 0, 90)
smoothnessLabel.Size = UDim2.new(0, 100, 0, 20)
smoothnessLabel.BackgroundTransparency = 1
smoothnessLabel.TextColor3 = Color3.new(1,1,1)
smoothnessLabel.Font = Enum.Font.SourceSans
smoothnessLabel.TextSize = 14

smoothnessBox = Instance.new("TextBox", LegitFrame)
smoothnessBox.Text = "0.2"
smoothnessBox.Position = UDim2.new(0, 120, 0, 90)
smoothnessBox.Size = UDim2.new(0, 50, 0, 20)
smoothnessBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
smoothnessBox.TextColor3 = Color3.new(1, 1, 1)
smoothnessBox.Font = Enum.Font.SourceSans
smoothnessBox.TextSize = 14

-- Range
rangeLabel = Instance.new("TextLabel", LegitFrame)
rangeLabel.Text = "Aim Range:"
rangeLabel.Position = UDim2.new(0, 10, 0, 120)
rangeLabel.Size = UDim2.new(0, 100, 0, 20)
rangeLabel.BackgroundTransparency = 1
rangeLabel.TextColor3 = Color3.new(1,1,1)
rangeLabel.Font = Enum.Font.SourceSans
rangeLabel.TextSize = 14

rangeBox = Instance.new("TextBox", LegitFrame)
rangeBox.Text = "150"
rangeBox.Position = UDim2.new(0, 120, 0, 120)
rangeBox.Size = UDim2.new(0, 50, 0, 20)
rangeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
rangeBox.TextColor3 = Color3.new(1, 1, 1)
rangeBox.Font = Enum.Font.SourceSans
rangeBox.TextSize = 14

-- Resolver Toggle
resolverBtn = Instance.new("TextButton", LegitFrame)
resolverBtn.Size = UDim2.new(0, 180, 0, 30)
resolverBtn.Position = UDim2.new(0, 10, 0, 160)
resolverBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
resolverBtn.TextColor3 = Color3.new(1, 1, 1)
resolverBtn.Font = Enum.Font.SourceSansBold
resolverBtn.TextSize = 16
resolverBtn.Text = "Resolver: OFF"

resolverBtn.MouseButton1Click:Connect(function()
	resolverEnabled = not resolverEnabled
	resolverBtn.Text = "Resolver: " .. (resolverEnabled and "ON" or "OFF")

	for _, plr in ipairs(game.Players:GetPlayers()) do
		if plr ~= LocalPlayer and workspace:FindFirstChild(plr.Name) then
			local hb = workspace[plr.Name]:FindFirstChild("Hitbox") or workspace[plr.Name]:FindFirstChild("Hitboxes")
			if hb then
				for _, part in ipairs(hb:GetDescendants()) do
					if part:IsA("BasePart") then
						if resolverEnabled then
							part.Size = part.Size * 2.3
							part.CanCollide = false
						else
							part.Size = Vector3.new(1, 1, 1)
							part.CanCollide = true
						end
					end
				end
			end
		end
	end
end)

-- LegitBot Aiming Logic
RunService.RenderStepped:Connect(function()
	if legitEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local camera = workspace.CurrentCamera
		local closest = nil
		local shortest = tonumber(rangeBox.Text) or 150

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local pos, onScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
				local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).magnitude

				if onScreen and dist < shortest then
					shortest = dist
					closest = plr
				end
			end
		end

		if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
			local targetPos = closest.Character.HumanoidRootPart.Position
			local lookAt = (targetPos - camera.CFrame.Position).Unit
			local smooth = tonumber(smoothnessBox.Text) or 0.2

			camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, camera.CFrame.Position + lookAt), smooth)
		end
	end
end)

antiSmokeBtn = Instance.new("TextButton", WorldFrame)
antiSmokeBtn.Size = UDim2.new(0, 180, 0, 25)
antiSmokeBtn.Position = UDim2.new(0, 10, 0, 260)
antiSmokeBtn.Text = "☁ Anti-Smoke [OLD]"
antiSmokeBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 60)
antiSmokeBtn.TextColor3 = Color3.new(1, 1, 1)
antiSmokeBtn.Font = Enum.Font.SourceSansBold
antiSmokeBtn.TextSize = 14

antiSmokeBtn.MouseButton1Click:Connect(function()
	local smokeFolder = workspace:FindFirstChild("Smoke")
	if smokeFolder then
		for _, v in ipairs(smokeFolder:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
				v:Destroy()
			elseif v:IsA("BasePart") then
				v.Transparency = 1
				v.CanCollide = false
			end
		end
	end
end)


-- 🧩 Client features: Bhop, NoClip, Anti-Smoke
local noclipEnabled = false
local antiSmokeEnabled = false

-- Bhop Toggle
bhopBtn = Instance.new("TextButton", ClientFrame)
bhopBtn.Size = UDim2.new(0, 180, 0, 25)
bhopBtn.Position = UDim2.new(0, 10, 0, 200)
bhopBtn.Text = "Bhop: OFF"
bhopBtn.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
bhopBtn.TextColor3 = Color3.new(1,1,1)
bhopBtn.Font = Enum.Font.SourceSansBold
bhopBtn.TextSize = 14
bhopBtn.MouseButton1Click:Connect(function()
	bhopEnabled = not bhopEnabled
	bhopBtn.Text = "Bhop: " .. (bhopEnabled and "ON" or "OFF")
end)

local bhopMode = "Legit"
bhopModeBtn = Instance.new("TextButton", ClientFrame)
bhopModeBtn.Size = UDim2.new(0, 180, 0, 25)
bhopModeBtn.Position = UDim2.new(0, 10, 0, 370)
bhopModeBtn.Text = "Bhop Mode: Legit"
bhopModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
bhopModeBtn.TextColor3 = Color3.new(1, 1, 1)
bhopModeBtn.Font = Enum.Font.SourceSansBold
bhopModeBtn.TextSize = 14

bhopModeBtn.MouseButton1Click:Connect(function()
	bhopMode = (bhopMode == "Legit") and "Rage" or "Legit"
	bhopModeBtn.Text = "Bhop Mode: " .. bhopMode
end)


-- NoClip Toggle
noclipBtn = Instance.new("TextButton", ClientFrame)
noclipBtn.Size = UDim2.new(0, 180, 0, 25)
noclipBtn.Position = UDim2.new(0, 10, 0, 230)
noclipBtn.Text = "NoClip: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.Font = Enum.Font.SourceSansBold
noclipBtn.TextSize = 14
noclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipBtn.Text = "NoClip: " .. (noclipEnabled and "ON" or "OFF")
end)

-- Anti-Smoke Toggle
smokeBtn = Instance.new("TextButton", ClientFrame)
smokeBtn.Size = UDim2.new(0, 180, 0, 25)
smokeBtn.Position = UDim2.new(0, 10, 0, 260)
smokeBtn.Text = "Anti-Smoke: OFF"
smokeBtn.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
smokeBtn.TextColor3 = Color3.new(1,1,1)
smokeBtn.Font = Enum.Font.SourceSansBold
smokeBtn.TextSize = 14
smokeBtn.MouseButton1Click:Connect(function()
	antiSmokeEnabled = not antiSmokeEnabled
	smokeBtn.Text = "Anti-Smoke: " .. (antiSmokeEnabled and "ON" or "OFF")
end)

-- Bhop + NoClip Logic
RunService.RenderStepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Anti-Smoke Logic
task.spawn(function()
	while true do
		if antiSmokeEnabled then
			local debris = workspace:FindFirstChild("Debris")
			if debris then
				for _, obj in ipairs(debris:GetDescendants()) do
					if obj:IsA("BasePart") then
						-- Прозрачность: ждём если надо, но не зацикливаемся
						if obj.Transparency < 0.1 then
							task.spawn(function(part)
								-- Ждём максимум 3 секунды, если надо
								local timer = 0
								repeat
									task.wait(0.1)
									timer += 0.1
								until part.Transparency == 0 or timer >= 3
								if part:IsDescendantOf(workspace) then
									part.Transparency = 0.5
									part.CanCollide = false
								end
							end, obj)
						else
							obj.Transparency = 0.5
							obj.CanCollide = false
						end
					elseif obj:IsA("Smoke") or obj:IsA("ParticleEmitter") or obj:IsA("Fire") then
						obj:Destroy()
					end
				end
			end
		end
		task.wait(0.25)
	end
end)



local AntiAimFrame = ContentFrames["Anti Aim"]
local aaModes = { "Spin", "PitchDown", "PitchUp", "Jitter", "Manual" }
local aaModeIndex = 1
local angle = 0
local jitterDirection = 1
-- Переключатель
aaToggle = Instance.new("TextButton", AntiAimFrame)
aaToggle.Size = UDim2.new(0, 180, 0, 30)
aaToggle.Position = UDim2.new(0, 10, 0, 10)
aaToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
aaToggle.TextColor3 = Color3.new(1, 1, 1)
aaToggle.Font = Enum.Font.Code
aaToggle.TextSize = 14
aaToggle.Text = "Anti-Aim: OFF"

local aaEnabled = false
aaToggle.MouseButton1Click:Connect(function()
	aaEnabled = not aaEnabled
	aaToggle.Text = "Anti-Aim: " .. (aaEnabled and "ON" or "OFF")

	local char = Players.LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildWhichIsA("Humanoid")
		if hum then
			hum.AutoRotate = not aaEnabled
		end
	end
end)

-- Скорость
speedBox = Instance.new("TextBox", AntiAimFrame)
speedBox.Size = UDim2.new(0, 180, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 50)
speedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.Code
speedBox.TextSize = 14
speedBox.PlaceholderText = "Not Working..."
speedBox.Text = "5"
speedBox.ClearTextOnFocus = false

modeDropdown = Instance.new("TextButton", AntiAimFrame)
modeDropdown.Size = UDim2.new(0, 180, 0, 30)
modeDropdown.Position = UDim2.new(0, 10, 0, 90)
modeDropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
modeDropdown.TextColor3 = Color3.new(1, 1, 1)
modeDropdown.Font = Enum.Font.Code
modeDropdown.TextSize = 14
modeDropdown.Text = "Mode: None"

-- Надпись NeverLose
local titleLabel = Instance.new("TextLabel", Header)
titleLabel.Size = UDim2.new(0, 300, 0, 35)
titleLabel.Position = UDim2.new(0, 10, 0, 2)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "NeverLose"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 28
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextStrokeTransparency = 0.7
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Градиент
local gradient = Instance.new("UIGradient", titleLabel)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 90, 255))
}
gradient.Rotation = 0

-- Подпись beta
local betaLabel = Instance.new("TextLabel", Header)
betaLabel.Size = UDim2.new(0, 60, 0, 15)
betaLabel.Position = UDim2.new(0, 125, 0, 27)
betaLabel.BackgroundTransparency = 1
betaLabel.Text = "beta"
betaLabel.Font = Enum.Font.Code
betaLabel.TextSize = 12
betaLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
betaLabel.TextXAlignment = Enum.TextXAlignment.Left


modeDropdown.MouseButton1Click:Connect(function()
	aaModeIndex = (aaModeIndex % #aaModes) + 1
	modeDropdown.Text = "Mode: " .. aaModes[aaModeIndex]
end)

-- Logic
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local angle = 0

RunService.Stepped:Connect(function(_, dt)
	if not aaEnabled then return end

	local char = lp.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildWhichIsA("Humanoid")
	if not hrp or not hum then return end

	local mode = aaModes[aaModeIndex]

	--if mode == "Spin" then
	--	local speed = tonumber(speedBox.Text) or 5
		--angle = (angle + speed) % 360
	--	hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(angle), 0)

	if mode == "PitchDown" then
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(math.rad(90), 0, 0)

	elseif mode == "PitchUp" then
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(math.rad(-90), 0, 0)

	elseif mode == "Jitter" then
		local jitterAmount = 90
		jitterDirection = -jitterDirection
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(jitterDirection * jitterAmount), 0)

	elseif mode == "Manual" then
		-- Для ручной настройки можно добавить ползунок угла в GUI
		local yaw = 180 -- пример
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(yaw), 0)
	end
end)


-- Silent Aim toggle
local SilentAimEnabled = false

-- 🔫 NoRecoil toggle
local recoilDisabled = false
norecoilBtn = Instance.new("TextButton", ClientFrame)
norecoilBtn.Size = UDim2.new(0, 180, 0, 25)
norecoilBtn.Position = UDim2.new(0, 10, 0, 290)
norecoilBtn.Text = "NoRecoil: OFF"
norecoilBtn.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
norecoilBtn.TextColor3 = Color3.new(1,1,1)
norecoilBtn.Font = Enum.Font.SourceSansBold
norecoilBtn.TextSize = 14
norecoilBtn.MouseButton1Click:Connect(function()
	recoilDisabled = not recoilDisabled
	norecoilBtn.Text = "NoRecoil: " .. (recoilDisabled and "ON" or "OFF")
end)

RunService.RenderStepped:Connect(function()
	if recoilDisabled then
		local cf = Camera.CFrame
		local look = (cf.Position + cf.LookVector) - cf.Position
		Camera.CFrame = CFrame.new(cf.Position, cf.Position + Vector3.new(look.X, 0, look.Z))
	end
end)

-- 🐇 Bhop при зажатии пробела
local bhopHeld = false
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Space then
		bhopHeld = true
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Space then
		bhopHeld = false
	end
end)

local airStrafeSpeed = 50 -- сила управления в воздухе

airSpeedLabel = Instance.new("TextLabel", ClientFrame)
airSpeedLabel.Size = UDim2.new(0, 180, 0, 20)
airSpeedLabel.Position = UDim2.new(0, 10, 0, 400)
airSpeedLabel.BackgroundTransparency = 1
airSpeedLabel.TextColor3 = Color3.new(1, 1, 1)
airSpeedLabel.Font = Enum.Font.SourceSans
airSpeedLabel.TextSize = 14
airSpeedLabel.Text = "AirSpeed: " .. airStrafeSpeed

airSpeedSlider = Instance.new("TextButton", ClientFrame)
airSpeedSlider.Size = UDim2.new(0, 180, 0, 25)
airSpeedSlider.Position = UDim2.new(0, 10, 0, 420)
airSpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
airSpeedSlider.TextColor3 = Color3.new(1, 1, 1)
airSpeedSlider.Text = "← Установить AirSpeed"
airSpeedSlider.Font = Enum.Font.SourceSansBold
airSpeedSlider.TextSize = 14

airSpeedSlider.MouseButton1Click:Connect(function()
	local input = tonumber(inputBox and inputBox.Text)
	if input and input >= 0 and input <= 100 then
		airStrafeSpeed = input
		airSpeedLabel.Text = "AirSpeed: " .. airStrafeSpeed
	end
end)

-- Поле для ввода значения
inputBox = Instance.new("TextBox", ClientFrame)
inputBox.Size = UDim2.new(0, 180, 0, 25)
inputBox.Position = UDim2.new(0, 10, 0, 450)
inputBox.PlaceholderText = "Введите число (0-100)"
inputBox.Text = tostring(airStrafeSpeed)
inputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 14


RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChildOfClass("Humanoid") then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")

	if not hrp then return end

	-- Legit режим — обычный bhop (прыгает при зажатии пробела и касании земли)
	if bhopEnabled and bhopHeld and bhopMode == "Legit" then
		if hum:GetState() == Enum.HumanoidStateType.Running then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
        -- Rage режим — авто-прыжок + AirStrafe
	if bhopEnabled and bhopHeld and bhopMode == "Rage" then
		local state = hum:GetState()

	-- Авто-прыжок на земле
		if state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.Landed then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end

	-- AirStrafe в воздухе
		if state == Enum.HumanoidStateType.Freefall then
			local moveDir = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
			moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)

			if moveDir.Magnitude > 0 then
				moveDir = moveDir.Unit
				local currentY = hrp.Velocity.Y
				hrp.Velocity = Vector3.new(moveDir.X * airStrafeSpeed, currentY, moveDir.Z * airStrafeSpeed)
			end
		end
	end	
end)



-- 🛸 Jump Glitch + Setbind
local jumpGlitchKey = Enum.KeyCode.G

bindButton = Instance.new("TextButton", ClientFrame)
bindButton.Size = UDim2.new(0, 180, 0, 25)
bindButton.Position = UDim2.new(0, 10, 0, 330)
bindButton.Text = "JumpGlitch Bind: [G]"
bindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
bindButton.TextColor3 = Color3.new(1,1,1)
bindButton.Font = Enum.Font.SourceSansBold
bindButton.TextSize = 14

bindButton.MouseButton1Click:Connect(function()
	bindButton.Text = "Waiting for key..."
	local conn
	conn = UIS.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			jumpGlitchKey = input.KeyCode
			bindButton.Text = "JumpGlitch Bind: [" .. input.KeyCode.Name .. "]"
			conn:Disconnect()
		end
	end)
end)

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == jumpGlitchKey then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
			char.HumanoidRootPart.Anchored = true
			task.wait(0.3)
			char.HumanoidRootPart.Anchored = false
		end
	end
end)


-- 📷 ThirdPerson Toggle + Слайдер + Bind
local thirdPersonEnabled = false
local thirdPersonKey = Enum.KeyCode.V
local thirdPersonDistance = 100

-- Кнопка Bind
tpBindBtn = Instance.new("TextButton", ViewFrame)
tpBindBtn.Size = UDim2.new(0, 180, 0, 25)
tpBindBtn.Position = UDim2.new(0, 10, 0, 160)
tpBindBtn.Text = "ThirdPerson Bind: НЕ РАБОТАЕТ "
tpBindBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
tpBindBtn.TextColor3 = Color3.new(1,1,1)
tpBindBtn.Font = Enum.Font.SourceSansBold
tpBindBtn.TextSize = 14

tpBindBtn.MouseButton1Click:Connect(function()
	tpBindBtn.Text = "Waiting for key..."
	local conn
	conn = UIS.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			thirdPersonKey = input.KeyCode
			tpBindBtn.Text = "ThirdPerson Bind: [" .. input.KeyCode.Name .. "]"
			conn:Disconnect()
		end
	end)
end)

local MaliciousFrame = ContentFrames["Malicious"]


-- 📷 FLYCAM with bind + fix (no nil errors)

local flyCamEnabled = false
local flyCamKey = Enum.KeyCode.H
local flySpeed = 1
local rotation = Vector2.new(0, 0)
local camPos = nil

local Camera = workspace.CurrentCamera
local LocalPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- UI: Кнопка FlyCam
flyBtn = Instance.new("TextButton", MaliciousFrame)
flyBtn.Size = UDim2.new(0, 180, 0, 25)
flyBtn.Position = UDim2.new(0, 10, 0, 100)
flyBtn.Text = "FlyCam: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(70, 90, 120)
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextSize = 14

-- Кнопка Bind
flyBindBtn = Instance.new("TextButton", MaliciousFrame)
flyBindBtn.Size = UDim2.new(0, 180, 0, 25)
flyBindBtn.Position = UDim2.new(0, 10, 0, 130)
flyBindBtn.Text = "FlyCam Bind: [H]"
flyBindBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
flyBindBtn.TextColor3 = Color3.new(1, 1, 1)
flyBindBtn.Font = Enum.Font.SourceSansBold
flyBindBtn.TextSize = 14

flyBindBtn.MouseButton1Click:Connect(function()
	flyBindBtn.Text = "Waiting for key..."
	local conn
	conn = UIS.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			flyCamKey = input.KeyCode
			flyBindBtn.Text = "FlyCam Bind: [" .. input.KeyCode.Name .. "]"
			conn:Disconnect()
		end
	end)
end)

local function toggleFlyCam()
	flyCamEnabled = not flyCamEnabled
	flyBtn.Text = "FlyCam: " .. (flyCamEnabled and "ON" or "OFF")

	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = flyCamEnabled and 0 or 20 end
	end

	if flyCamEnabled then
		camPos = Camera.CFrame.Position
		rotation = Vector2.new(0, 0)
		Camera.CameraType = Enum.CameraType.Scriptable
		UIS.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
	else
		Camera.CameraType = Enum.CameraType.Custom
		UIS.MouseBehavior = Enum.MouseBehavior.Default
	end
end

-- По кнопке UI
flyBtn.MouseButton1Click:Connect(toggleFlyCam)

-- По бинду
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == flyCamKey and not UIS:GetFocusedTextBox() then
		toggleFlyCam()
	end
end)

-- Поворот мышью
UIS.InputChanged:Connect(function(input)
	if flyCamEnabled and input.UserInputType == Enum.UserInputType.MouseMovement then
		rotation = rotation + Vector2.new(-input.Delta.X, input.Delta.Y) * 0.2
	end
end)

-- Движение камеры
RunService.RenderStepped:Connect(function()
	if flyCamEnabled and camPos then
		local move = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.E) then move += Camera.CFrame.UpVector end
		if UIS:IsKeyDown(Enum.KeyCode.Q) then move -= Camera.CFrame.UpVector end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move *= 3 end

		camPos += move * flySpeed
		Camera.CFrame = CFrame.new(camPos) * CFrame.Angles(0, math.rad(rotation.X), 0) * CFrame.Angles(math.rad(-rotation.Y), 0, 0)
	end
end)




-- Слайдер расстояния (0–300)
local sliderFrame = Instance.new("Frame", ViewFrame)
sliderFrame.Size = UDim2.new(0, 250, 0, 40)
sliderFrame.Position = UDim2.new(0, 10, 0, 200)
sliderFrame.BackgroundTransparency = 1

sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.new(0, 60, 1, 0)
sliderLabel.Position = UDim2.new(0, 0, 0, 0)
sliderLabel.Text = "Distance"
sliderLabel.Font = Enum.Font.SourceSans
sliderLabel.TextSize = 14
sliderLabel.TextColor3 = Color3.new(1,1,1)
sliderLabel.BackgroundTransparency = 1

sliderValue = Instance.new("TextLabel", sliderFrame)
sliderValue.Size = UDim2.new(0, 30, 1, 0)
sliderValue.Position = UDim2.new(1, -35, 0, 0)
sliderValue.Text = tostring(thirdPersonDistance)
sliderValue.Font = Enum.Font.SourceSans
sliderValue.TextSize = 14
sliderValue.TextColor3 = Color3.new(1,1,1)
sliderValue.BackgroundTransparency = 1

local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(1, -100, 0, 4)
sliderBar.Position = UDim2.new(0, 70, 0.5, -2)
sliderBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
sliderBar.BorderSizePixel = 0

local sliderFill = Instance.new("Frame", sliderBar)
sliderFill.Size = UDim2.new(thirdPersonDistance / 300, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
sliderFill.BorderSizePixel = 0

local dragging = false

sliderBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

RunService.RenderStepped:Connect(function()
	if dragging then
		local mouseX = UIS:GetMouseLocation().X
		local relative = mouseX - sliderBar.AbsolutePosition.X
		local percent = math.clamp(relative / sliderBar.AbsoluteSize.X, 0, 1)
		thirdPersonDistance = math.floor(percent * 300)
		sliderFill.Size = UDim2.new(percent, 0, 1, 0)
		sliderValue.Text = tostring(thirdPersonDistance)
	end
end)

-- Toggle по клавише
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == thirdPersonKey then
		thirdPersonEnabled = not thirdPersonEnabled
		LocalPlayer.CameraMode = thirdPersonEnabled and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson
	end
end)



-- Обновление расстояния
RunService.RenderStepped:Connect(function()
	if thirdPersonEnabled then
		LocalPlayer.CameraMode = Enum.CameraMode.Classic
		LocalPlayer.CameraMaxZoomDistance = thirdPersonDistance
		Camera.CFrame = CFrame.new(PlayerPos - CameraDirection * Distance, PlayerPos)
	end
end)


local selectedHitboxPlayer = nil

local hitboxList = Instance.new("ScrollingFrame", MaliciousFrame)
hitboxList.Size = UDim2.new(0, 200, 0, 300)
hitboxList.Position = UDim2.new(1, -210, 0, 10)
hitboxList.CanvasSize = UDim2.new(0, 0, 0, 0)
hitboxList.ScrollBarThickness = 6
hitboxList.BackgroundColor3 = Color3.fromRGB(25, 25, 35)

local function refreshHitboxList()
	hitboxList:ClearAllChildren()
	local y = 0

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local model = workspace:FindFirstChild("Players")
			if model and model:FindFirstChild(plr.Name) then
				local btn = Instance.new("TextButton", hitboxList)
				btn.Size = UDim2.new(1, -10, 0, 25)
				btn.Position = UDim2.new(0, 5, 0, y)
				btn.Text = plr.Name
				btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
				btn.TextColor3 = Color3.new(1, 1, 1)
				btn.Font = Enum.Font.SourceSansBold
				btn.TextSize = 14

				btn.MouseButton1Click:Connect(function()
					local target = model:FindFirstChild(plr.Name)
					local hitboxes = target and target:FindFirstChild("Hitboxes")
					local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

					if hitboxes and root then
						local originalParts = {}

						for _, part in ipairs(hitboxes:GetChildren()) do
							if part:IsA("BasePart") then
								table.insert(originalParts, {
									Part = part,
									Anchored = part.Anchored,
									OriginalCFrame = part.CFrame
								})

								-- Удаляем связи
								for _, obj in ipairs(part:GetChildren()) do
									if obj:IsA("Weld") or obj:IsA("Motor6D") or obj:IsA("AlignPosition") or obj:IsA("AlignOrientation") or obj:IsA("Attachment") then
										obj:Destroy()
									end
								end

								part.Anchored = true
								part.CanCollide = false
								part.CFrame = root.CFrame * CFrame.new(0, 0, -5)

								local highlight = Instance.new("Highlight")
								highlight.FillColor = Color3.fromRGB(255, 0, 0)
								highlight.OutlineColor = Color3.new(1, 1, 1)
								highlight.Parent = part
							end
						end

						-- 🔁 Через 5 секунд — вернуть всё обратно
						task.delay(5, function()
							for _, info in ipairs(originalParts) do
								local part = info.Part
								if part and part:IsDescendantOf(workspace) then
									part.Anchored = info.Anchored
									part.CFrame = info.OriginalCFrame
									local h = part:FindFirstChildOfClass("Highlight")
									if h then h:Destroy() end
								end
							end
						end)
					end
				end)

				y += 30
			end
		end
	end

	hitboxList.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end



refreshHitboxList()
Players.PlayerAdded:Connect(refreshHitboxList)
Players.PlayerRemoving:Connect(refreshHitboxList)

-- Где-нибудь вверху:
local fixedTime = 12
local fixedFogStart = 10
local fixedFogEnd = 300


local timeStages = {6, 12, 18, 0}
local timeIndex = 1

timeBtn = Instance.new("TextButton", WorldFrame)
timeBtn.Size = UDim2.new(0, 180, 0, 25)
timeBtn.Position = UDim2.new(0, 10, 0, 260)
timeBtn.Text = "🌤️ Время: Утро"
timeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
timeBtn.TextColor3 = Color3.new(1,1,1)
timeBtn.Font = Enum.Font.SourceSansBold
timeBtn.TextSize = 14

local timeNames = {"Утро", "День", "Вечер", "Ночь"}

timeBtn.MouseButton1Click:Connect(function()
	timeIndex = timeIndex % #timeStages + 1
	Lighting.ClockTime = timeStages[timeIndex]
	timeBtn.Text = "🌤️ Время: " .. timeNames[timeIndex]
	fixedTime = Lighting.ClockTime
end)

fogBox = Instance.new("TextBox", WorldFrame)
fogBox.Size = UDim2.new(0, 180, 0, 25)
fogBox.Position = UDim2.new(0, 10, 0, 295)
fogBox.PlaceholderText = "Fog Distance (например: 500)"
fogBox.Text = ""
fogBox.Font = Enum.Font.SourceSans
fogBox.TextSize = 14
fogBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
fogBox.TextColor3 = Color3.new(1, 1, 1)

fogBox.FocusLost:Connect(function()
	local val = tonumber(fogBox.Text)
	if val then
		Lighting.FogEnd = val
		Lighting.FogStart = val * 0.25
	end
end)

-- Зафиксировать ClockTime и Fog значения
-- 🌞 Защита Lighting от сброса
task.spawn(function()
	while true do
		-- Закрепляем время суток
		if fixedTime then
			Lighting.ClockTime = fixedTime
		end

		-- Закрепляем туман
		if fogEnabled and fixedFogStart and fixedFogEnd then
			Lighting.FogStart = fixedFogStart
			Lighting.FogEnd = fixedFogEnd
		end

		-- Закрепляем ambient цвет
		if ambientBtn and ambientBtn.BackgroundColor3 then
			Lighting.Ambient = ambientBtn.BackgroundColor3
		end

		task.wait(1)
	end
end)

local themes = {
    {
        Name = "Dark Blue",
        Background = Color3.fromRGB(20, 20, 25),
        Sidebar = Color3.fromRGB(15, 15, 20),
        Accent = Color3.fromRGB(60, 180, 255),
        Text = Color3.fromRGB(200, 200, 255)
    },
    {
        Name = "Neon Green",
        Background = Color3.fromRGB(10, 10, 10),
        Sidebar = Color3.fromRGB(5, 5, 5),
        Accent = Color3.fromRGB(0, 255, 0),
        Text = Color3.fromRGB(200, 255, 200)
    },
    {
        Name = "Sunset",
        Background = Color3.fromRGB(50, 20, 30),
        Sidebar = Color3.fromRGB(70, 30, 40),
        Accent = Color3.fromRGB(255, 140, 180),
        Text = Color3.fromRGB(255, 220, 230)
    },
    {
        Name = "Classic Dark",
        Background = Color3.fromRGB(45, 45, 60),
        Sidebar = Color3.fromRGB(30, 30, 40),
        Accent = Color3.fromRGB(255, 180, 60),
        Text = Color3.fromRGB(255, 255, 255)
    },
    {
        Name = "Crimson",
        Background = Color3.fromRGB(35, 0, 0),
        Sidebar = Color3.fromRGB(50, 0, 0),
        Accent = Color3.fromRGB(255, 80, 80),
        Text = Color3.fromRGB(255, 180, 180)
    },
    {
        Name = "Aqua",
        Background = Color3.fromRGB(0, 25, 30),
        Sidebar = Color3.fromRGB(0, 40, 50),
        Accent = Color3.fromRGB(0, 200, 255),
        Text = Color3.fromRGB(180, 255, 255)
    },
    {
        Name = "Steel",
        Background = Color3.fromRGB(40, 40, 50),
        Sidebar = Color3.fromRGB(30, 30, 40),
        Accent = Color3.fromRGB(150, 150, 150),
        Text = Color3.fromRGB(200, 200, 200)
    },
    {
        Name = "Fire Orange",
        Background = Color3.fromRGB(45, 20, 0),
        Sidebar = Color3.fromRGB(60, 30, 0),
        Accent = Color3.fromRGB(255, 120, 0),
        Text = Color3.fromRGB(255, 200, 150)
    },
    {
        Name = "Violet Pulse",
        Background = Color3.fromRGB(25, 0, 40),
        Sidebar = Color3.fromRGB(40, 0, 60),
        Accent = Color3.fromRGB(180, 60, 255),
        Text = Color3.fromRGB(220, 200, 255)
    }
}

local function applyTheme(theme)
    MainFrame.BackgroundColor3 = theme.Background
    Sidebar.BackgroundColor3 = theme.Sidebar
    SaveBtn.TextColor3 = theme.Accent
    for _, btn in pairs(Tabs) do
        btn.TextColor3 = theme.Text
    end
end

TabNames[#TabNames+1] = "Themes"

local ThemeFrame = Instance.new("Frame", MainFrame)
ThemeFrame.Name = "ThemesContent"
ThemeFrame.Position = UDim2.new(0, 170, 0, 50)
ThemeFrame.Size = UDim2.new(1, -180, 1, -60)
ThemeFrame.Visible = false
ThemeFrame.BackgroundTransparency = 1
ContentFrames["Themes"] = ThemeFrame

local themeScroll = Instance.new("ScrollingFrame", ThemeFrame)
themeScroll.Size = UDim2.new(0, 200, 1, -10)
themeScroll.Position = UDim2.new(0, 10, 0, 10)
themeScroll.CanvasSize = UDim2.new(0, 0, 0, #themes * 40 + 10)
themeScroll.ScrollBarThickness = 6
themeScroll.BackgroundTransparency = 1

local y = 0
for _, theme in ipairs(themes) do
    local btn = Instance.new("TextButton", themeScroll)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.Text = theme.Name
    btn.BackgroundColor3 = theme.Accent
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(function()
        applyTheme(theme)
    end)
    y += 40
end

Tabs["Themes"] = Instance.new("TextButton", Sidebar)
Tabs["Themes"].Size = UDim2.new(1, -10, 0, 30)
Tabs["Themes"].Position = UDim2.new(0, 5, 0, 5 + (#TabNames - 1) * 35)
Tabs["Themes"].Text = "Themes"
Tabs["Themes"].Font = Enum.Font.SourceSans
Tabs["Themes"].TextSize = 16
Tabs["Themes"].TextColor3 = Color3.new(1,1,1)
Tabs["Themes"].BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Tabs["Themes"].BorderSizePixel = 0
Tabs["Themes"].MouseButton1Click:Connect(function()
    for _, frame in pairs(ContentFrames) do frame.Visible = false end
    ThemeFrame.Visible = true
end)

applyTheme(themes[1])
-- 🔁 Продолжение остального GUI ниже по коду

local plantKey = Enum.KeyCode.Z -- по умолчанию
local settingKeybind = false

plantBindBtn = Instance.new("TextButton", MaliciousFrame)
plantBindBtn.Size = UDim2.new(0, 180, 0, 25)
plantBindBtn.Position = UDim2.new(0, 10, 0, 200) -- смести вниз, если нужно
plantBindBtn.Text = "📌 Бинд: Plant (Z)"
plantBindBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
plantBindBtn.TextColor3 = Color3.new(1,1,1)
plantBindBtn.Font = Enum.Font.SourceSansBold
plantBindBtn.TextSize = 14

plantBindBtn.MouseButton1Click:Connect(function()
	settingKeybind = true
	plantBindBtn.Text = "⏳ Нажми клавишу..."
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
	if settingKeybind and input.UserInputType == Enum.UserInputType.Keyboard then
		settingKeybind = false
		plantKey = input.KeyCode
		plantBindBtn.Text = "📌 Бинд: Plant (" .. plantKey.Name .. ")"
	end
end)

UIS.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == plantKey then
		local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
		Events:WaitForChild("StartPlanting"):FireServer()
		task.wait(0.1)
		Events:WaitForChild("PlantC4"):FireServer()
	end
end)



local DebrisList = Instance.new("ScrollingFrame", ClientFrame)
DebrisList.Size = UDim2.new(0, 200, 1, -20)
DebrisList.Position = UDim2.new(1, -210, 0, 10)
DebrisList.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DebrisList.BorderSizePixel = 0
DebrisList.ScrollBarThickness = 6
DebrisList.CanvasSize = UDim2.new(0, 0, 0, 0)

local function refreshDebrisList()
	DebrisList:ClearAllChildren()
	local y = 0

	for _, obj in ipairs(workspace:FindFirstChild("Debris"):GetChildren()) do
		if obj:IsA("MeshPart") and obj:FindFirstChild("Impact2") and obj.Impact2:IsA("StringValue") then
			local btn = Instance.new("TextButton", DebrisList)
			btn.Size = UDim2.new(1, -10, 0, 25)
			btn.Position = UDim2.new(0, 5, 0, y)
			btn.Text = obj.Name
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
			btn.Font = Enum.Font.SourceSansBold
			btn.TextSize = 14

			btn.MouseButton1Click:Connect(function()
				local char = Players.LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root then
					obj.CFrame = root.CFrame * CFrame.new(0, 0, -3)
				end
			end)

			y += 30
		end
	end

	DebrisList.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

workspace:FindFirstChild("Debris").ChildAdded:Connect(function()
	task.wait(0.2)
	refreshDebrisList()
end)

autoFireBtn = Instance.new("TextButton", silentAimFrame)
autoFireBtn.Size = UDim2.new(0, 200, 0, 30)
autoFireBtn.Position = UDim2.new(0, 15, 0, 130)
autoFireBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
autoFireBtn.TextColor3 = Color3.new(1, 1, 1)
autoFireBtn.Font = Enum.Font.Code
autoFireBtn.TextSize = 14
autoFireBtn.Text = "AutoFire: OFF"

autoFireBtn.MouseButton1Click:Connect(function()
	triggerEnabled = not triggerEnabled
	autoFireBtn.Text = "AutoFire: " .. (triggerEnabled and "ON" or "OFF")
end)


autoWallBtn = Instance.new("TextButton", silentAimFrame)
autoWallBtn.Size = UDim2.new(0, 200, 0, 30)
autoWallBtn.Position = UDim2.new(0, 15, 0, 170)
autoWallBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
autoWallBtn.TextColor3 = Color3.new(1, 1, 1)
autoWallBtn.Font = Enum.Font.Code
autoWallBtn.TextSize = 14
autoWallBtn.Text = "AutoWall: OFF"

autoWallBtn.MouseButton1Click:Connect(function()
	autoWallEnabled = not autoWallEnabled
	autoWallBtn.Text = "AutoWall: " .. (autoWallEnabled and "ON" or "OFF")
end)

local AutoBuyFrame = ContentFrames["AutoBuy"]
AutoBuyFrame:ClearAllChildren()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")

-- Список категорий и оружия
local weaponCategories = {
	["Primary"] = {"AK-47", "AUG", "Barrett", "DB Shotgun", "M4A1", "P90", "Vector", "MAG-7", "UMP-45", "M77E"},
	["Pistol"] = {"Deagle", "G-17", "USP", "TEC-9"},
	["Grenade"] = {"Flashbang", "HE Grenade", "Incendiary Grenade", "Smoke Grenade", "Decoy"},
	["Equipment"] = {"Kevlar", "Kevlar+Helmet", "Knife"},
	["Other"] = {"Laser Mine", "Jump Pad", "Stim", "S-Bomb", "Teleport", "Coffee", "Defib", "Breacher Drone"}
}

-- Выбранные предметы
local selectedItems = {}
local autoBuy = false

-- Scroll
local scroll = Instance.new("ScrollingFrame", AutoBuyFrame)
scroll.Size = UDim2.new(1, -10, 1, -80)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout", scroll)
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Строим список
for category, weapons in pairs(weaponCategories) do
	local title = Instance.new("TextLabel", scroll)
	title.Size = UDim2.new(1, 0, 0, 20)
	title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	title.Text = "  " .. category
	title.TextColor3 = Color3.new(1,1,1)
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left

	local padding = Instance.new("UIPadding", title)
	padding.PaddingLeft = UDim.new(0, 5)

	for _, weapon in ipairs(weapons) do
		local btn = Instance.new("TextButton", scroll)
		btn.Size = UDim2.new(1, -10, 0, 25)
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 14
		btn.Text = "☐ " .. weapon

		local selected = false
		btn.MouseButton1Click:Connect(function()
			selected = not selected
			btn.Text = (selected and "☑ " or "☐ ") .. weapon
			if selected then
				selectedItems[weapon] = true
			else
				selectedItems[weapon] = nil
			end
		end)
	end
end

-- Обновить CanvasSize
task.defer(function()
	wait()
	scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
end)

-- Кнопка "Купить"
buyBtn = Instance.new("TextButton", AutoBuyFrame)
buyBtn.Size = UDim2.new(0, 150, 0, 30)
buyBtn.Position = UDim2.new(0, 5, 1, -70)
buyBtn.AnchorPoint = Vector2.new(0, 1)
buyBtn.Text = "Купить выбранное"
buyBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 70)
buyBtn.TextColor3 = Color3.new(1, 1, 1)
buyBtn.Font = Enum.Font.SourceSansBold
buyBtn.TextSize = 14

buyBtn.MouseButton1Click:Connect(function()
	for name, _ in pairs(selectedItems) do
		Events.BuyWeapon:FireServer(name)
	end
end)

clearBtn = Instance.new("TextButton", AutoBuyFrame)
clearBtn.Size = UDim2.new(0, 150, 0, 30)
clearBtn.Position = UDim2.new(0, 165, 1, -70)
clearBtn.AnchorPoint = Vector2.new(0, 1)
clearBtn.Text = "Очистить всё"
clearBtn.BackgroundColor3 = Color3.fromRGB(120, 70, 70)
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.TextSize = 14

clearBtn.MouseButton1Click:Connect(function()
	selectedItems = {}
	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("TextButton") and child.Text:sub(1, 1) == "☑" then
			child.Text = "☐ " .. child.Text:sub(3)
		end
	end
end)

-- Автозакупка переключатель
autoBuyToggle = Instance.new("TextButton", AutoBuyFrame)
autoBuyToggle.Size = UDim2.new(0, 150, 0, 25)
autoBuyToggle.Position = UDim2.new(0, 5, 1, -35)
autoBuyToggle.AnchorPoint = Vector2.new(0, 1)
autoBuyToggle.Text = "Автозакупка: OFF"
autoBuyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
autoBuyToggle.TextColor3 = Color3.new(1, 1, 1)
autoBuyToggle.Font = Enum.Font.SourceSans
autoBuyToggle.TextSize = 14

autoBuyToggle.MouseButton1Click:Connect(function()
	autoBuy = not autoBuy
	autoBuyToggle.Text = "Автозакупка: " .. (autoBuy and "ON" or "OFF")
end)

-- Покупка при спавне
game.Players.LocalPlayer.CharacterAdded:Connect(function()
	if autoBuy then
		task.wait(1)
		for name, _ in pairs(selectedItems) do
			Events.BuyWeapon:FireServer(name)
		end
	end
end)

-- Флаг автоспама
local autoBuySpam = false

-- Кнопка автоспама
autoBuySpamToggle = Instance.new("TextButton", AutoBuyFrame)
autoBuySpamToggle.Size = UDim2.new(0, 150, 0, 25)
autoBuySpamToggle.Position = UDim2.new(0, 165, 1, -35)
autoBuySpamToggle.AnchorPoint = Vector2.new(0, 1)
autoBuySpamToggle.Text = "Автоспам: OFF"
autoBuySpamToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
autoBuySpamToggle.TextColor3 = Color3.new(1, 1, 1)
autoBuySpamToggle.Font = Enum.Font.SourceSans
autoBuySpamToggle.TextSize = 14

autoBuySpamToggle.MouseButton1Click:Connect(function()
	autoBuySpam = not autoBuySpam
	autoBuySpamToggle.Text = "Автоспам: " .. (autoBuySpam and "ON" or "OFF")

	if autoBuySpam then
		task.spawn(function()
			while autoBuySpam do
				for name, _ in pairs(selectedItems) do
					Events.BuyWeapon:FireServer(name)
				end
				task.wait(0.5)
			end
		end)
	end
end)

-- 📁 Config System for Neverlose GUI with Delete Support
local ConfigFrame = ContentFrames["Configs"]
ConfigFrame:ClearAllChildren()

local HttpService = game:GetService("HttpService")
local ConfigsPath = "NeverLoseBruh/cfg/"

if not isfolder("NeverLoseBruh") then
	makefolder("NeverLoseBruh")
end
if not isfolder("NeverLoseBruh/cfg") then
	makefolder("NeverLoseBruh/cfg")
end


-- 🧱 UI Elements
local title = Instance.new("TextLabel", ConfigFrame)
title.Size = UDim2.new(0, 300, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.Text = "Config System"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local selectedLabel = Instance.new("TextLabel", ConfigFrame)
selectedLabel.Position = UDim2.new(0, 10, 0, 270)
selectedLabel.Size = UDim2.new(0, 300, 0, 20)
selectedLabel.TextColor3 = Color3.new(1, 1, 1)
selectedLabel.BackgroundTransparency = 1
selectedLabel.Font = Enum.Font.SourceSans
selectedLabel.TextSize = 14
selectedLabel.Text = "Выбран конфиг: -"

local newNameBox = Instance.new("TextBox", ConfigFrame)
newNameBox.Size = UDim2.new(0, 200, 0, 25)
newNameBox.Position = UDim2.new(0, 10, 0, 50)
newNameBox.PlaceholderText = "Enter config name..."
newNameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
newNameBox.TextColor3 = Color3.new(1,1,1)
newNameBox.Font = Enum.Font.SourceSans
newNameBox.TextSize = 14

local createBtn = Instance.new("TextButton", ConfigFrame)
createBtn.Size = UDim2.new(0, 100, 0, 25)
createBtn.Position = UDim2.new(0, 220, 0, 50)
createBtn.Text = "Create"
createBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
createBtn.TextColor3 = Color3.new(1, 1, 1)
createBtn.Font = Enum.Font.SourceSansBold
createBtn.TextSize = 14

local configList = Instance.new("ScrollingFrame", ConfigFrame)
configList.Size = UDim2.new(0, 310, 0, 200)
configList.Position = UDim2.new(0, 10, 0, 90)
configList.CanvasSize = UDim2.new(0, 0, 0, 0)
configList.ScrollBarThickness = 6
configList.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", configList)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 5)

local selectedConfig = nil

-- 🔁 Load config list
local function refreshConfigs()
	configList:ClearAllChildren()
	selectedConfig = nil
	
	task.spawn(function()
		local success, files = pcall(function()
			return listfiles(ConfigsPath)
		end)
		
		if success and typeof(files) == "table" then
			for _, path in ipairs(files) do
				if path:match("%.nlb$") then
					local name = path:match("([^/\\]+)%.nlb$")
					local holder = Instance.new("Frame", configList)
					holder.Size = UDim2.new(1, -10, 0, 25)
					holder.BackgroundTransparency = 1

					local btn = Instance.new("TextButton", holder)
					btn.Size = UDim2.new(0.7, 0, 1, 0)
					btn.Text = name
					btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
					btn.TextColor3 = Color3.new(1,1,1)
					btn.Font = Enum.Font.SourceSans
					btn.TextSize = 14
					btn.MouseButton1Click:Connect(function()
						selectedConfig = path
						selectedLabel.Text = "Выбран конфиг: " .. name
					end)

					local delBtn = Instance.new("TextButton", holder)
					delBtn.Size = UDim2.new(0.3, -5, 1, 0)
					delBtn.Position = UDim2.new(0.7, 5, 0, 0)
					delBtn.Text = "Delete"
					delBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
					delBtn.TextColor3 = Color3.new(1,1,1)
					delBtn.Font = Enum.Font.SourceSansBold
					delBtn.TextSize = 14
					delBtn.MouseButton1Click:Connect(function()
						if selectedConfig == path then selectedConfig = nil end
						if messagebox then
							local result = messagebox("Delete config '" .. name .. "'?", "Confirm", 4)
							if result == 6 then
								delfile(path)
								refreshConfigs()
							end
						else
							-- fallback: delete without prompt
							delfile(path)
							refreshConfigs()
						end
					end)
				end
			end
			configList.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
		end
	end)
end

-- 🔘 Buttons
local saveBtn = Instance.new("TextButton", ConfigFrame)
saveBtn.Size = UDim2.new(0, 100, 0, 25)
saveBtn.Position = UDim2.new(0, 10, 0, 300)
saveBtn.Text = "Save"
saveBtn.BackgroundColor3 = Color3.fromRGB(70, 110, 70)
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.Font = Enum.Font.SourceSansBold
saveBtn.TextSize = 14
saveBtn.MouseButton1Click:Connect(saveConfig)

local loadBtn = Instance.new("TextButton", ConfigFrame)
loadBtn.Size = UDim2.new(0, 100, 0, 25)
loadBtn.Position = UDim2.new(0, 120, 0, 300)
loadBtn.Text = "Load"
loadBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 110)
loadBtn.TextColor3 = Color3.new(1, 1, 1)
loadBtn.Font = Enum.Font.SourceSansBold
loadBtn.TextSize = 14
loadBtn.MouseButton1Click:Connect(loadConfig)

-- Создание нового
createBtn.MouseButton1Click:Connect(function()
	local name = newNameBox.Text
	if name and #name > 0 then
		name = name:gsub("[^%w_%-]", "") -- убираем все символы кроме букв, цифр, _ и -
		if name == "" then return end -- если после фильтрации имя стало пустым

		local fullPath = ConfigsPath .. name .. ".nlb"
		if not isfile(fullPath) then
			writefile(fullPath, "{}") -- сохраняем пустой конфиг
		end
		refreshConfigs()
	end
end)

refreshConfigs()

-- ✅ Улучшения RageBot и LegitBot для Neverlose Premium GUI

-- === ПЕРЕМЕННЫЕ ===
hitChance = 75
forceBodyAim = false
dynamicFOV = false
safetoopenmenu = false
backtrackEnabled = false
legitFov = 120
legitHitPart = "Head"

-- === ФУНКЦИЯ АВТОВОЛ ===
function canShootThrough(targetPart)
	if not targetPart then return false end

	local origin = Camera.CFrame.Position
	local direction = (targetPart.Position - origin).Unit * 1000

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {
		LocalPlayer.Character,
		Camera,
		targetPart.Parent -- исключаем цель, чтобы не детектить её как преграду
	}
	params.IgnoreWater = true

	local result = workspace:Raycast(origin, direction, params)

	if not result then
		return true -- ничего не попало = чистая линия
	end

	local hit = result.Instance

	-- Если ударилось в саму цель — разрешаем
	if hit:IsDescendantOf(targetPart.Parent) then
		return true
	end

	-- Пробиваемые объекты:
	if hit.Transparency > 0.7 then return true end
	if hit.CanCollide == false then return true end

	-- Доп. проверка: некоторые объекты вроде "Glass", "Neon", и т.п.
	local material = hit.Material
	if material == Enum.Material.Glass or material == Enum.Material.Neon or material == Enum.Material.ForceField then
		return true
	end

	-- Если попали в Part с именем "InvisibleWall", "NoShoot" и т.п. — можно добавить свои фильтры
	local name = hit.Name:lower()
	if name:find("invis") or name:find("noshoot") then
		return true
	end

	return false -- иначе стена или препятствие
end


-- === ОБНОВЛЕНИЕ RAGEBOT UI ===
hitChanceBox = Instance.new("TextBox", silentAimFrame)
hitChanceBox.Size = UDim2.new(0, 100, 0, 25)
hitChanceBox.Position = UDim2.new(0, 10, 0, 250)
hitChanceBox.Text = "75"
hitChanceBox.PlaceholderText = "HitChance"
hitChanceBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
hitChanceBox.TextColor3 = Color3.new(1, 1, 1)
hitChanceBox.Font = Enum.Font.SourceSans
hitChanceBox.TextSize = 14

local function updateBtn(btn, state, label)
	btn.Text = label .. ": " .. (state and "ON" or "OFF")
end

forceBodyBtn = Instance.new("TextButton", silentAimFrame)
forceBodyBtn.Size = UDim2.new(0, 160, 0, 25)
forceBodyBtn.Position = UDim2.new(0, 10, 0, 280)
forceBodyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
forceBodyBtn.TextColor3 = Color3.new(1,1,1)
forceBodyBtn.Font = Enum.Font.SourceSansBold
forceBodyBtn.TextSize = 14
forceBodyBtn.Text = "Force Body Aim: OFF"
forceBodyBtn.MouseButton1Click:Connect(function()
	forceBodyAim = not forceBodyAim
	forceBodyBtn.Text = "Force Body Aim: " .. (forceBodyAim and "ON" or "OFF")
end)

dynFovBtn = Instance.new("TextButton", silentAimFrame)
dynFovBtn.Size = UDim2.new(0, 160, 0, 25)
dynFovBtn.Position = UDim2.new(0, 10, 0, 310)
dynFovBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
dynFovBtn.TextColor3 = Color3.new(1,1,1)
dynFovBtn.Font = Enum.Font.SourceSansBold
dynFovBtn.TextSize = 14
dynFovBtn.Text = "Dynamic FOV: OFF"
dynFovBtn.MouseButton1Click:Connect(function()
	dynamicFOV = not dynamicFOV
	dynFovBtn.Text = "Dynamic FOV: " .. (dynamicFOV and "ON" or "OFF")
end)

-- === LEGITBOT UI ===
legitFovBox = Instance.new("TextBox", LegitFrame)
legitFovBox.Size = UDim2.new(0, 100, 0, 25)
legitFovBox.Position = UDim2.new(0, 10, 0, 250)
legitFovBox.Text = tostring(legitFov)
legitFovBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
legitFovBox.TextColor3 = Color3.new(1, 1, 1)
legitFovBox.Font = Enum.Font.SourceSans
legitFovBox.TextSize = 14

backtrackBtn = Instance.new("TextButton", LegitFrame)
backtrackBtn.Size = UDim2.new(0, 160, 0, 25)
backtrackBtn.Position = UDim2.new(0, 10, 0, 280)
backtrackBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
backtrackBtn.TextColor3 = Color3.new(1,1,1)
backtrackBtn.Font = Enum.Font.SourceSansBold
backtrackBtn.TextSize = 14
backtrackBtn.Text = "Backtrack: OFF"
backtrackBtn.MouseButton1Click:Connect(function()
	backtrackEnabled = not backtrackEnabled
	backtrackBtn.Text = "Backtrack: " .. (backtrackEnabled and "ON" or "OFF")
end)


-- Hit Part переключатель
local hitParts = {"Head", "UpperTorso", "Random"}
hitPartBtn = Instance.new("TextButton", LegitFrame)
hitPartBtn.Size = UDim2.new(0, 160, 0, 25)
hitPartBtn.Position = UDim2.new(0, 10, 0, 310)
hitPartBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
hitPartBtn.TextColor3 = Color3.new(1,1,1)
hitPartBtn.Font = Enum.Font.SourceSansBold
hitPartBtn.TextSize = 14
hitPartBtn.Text = "Hit Part: Head"
hitPartBtn.MouseButton1Click:Connect(function()
	local i = table.find(hitParts, legitHitPart)
	legitHitPart = hitParts[(i % #hitParts) + 1]
	hitPartBtn.Text = "Hit Part: " .. legitHitPart
end)


-- === SafeToOpenMenu реализация ===
UserInputService.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.Insert and not gpe then
		mainFrame.Visible = not mainFrame.Visible
		if safetoopenmenu then
			rageSuspended = mainFrame.Visible
		end
	end
end)


function CheckHitChance(targetPart, hitchance)
	local origin = Camera.CFrame.Position
	local total = 10
	local hits = 0

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {localPlayer.Character, Camera}

	for i = 1, total do
		local offset = Vector3.new(
			math.random(-100,100) / 500,
			math.random(-100,100) / 500,
			math.random(-100,100) / 500
		)
		local direction = (targetPart.Position + offset - origin).Unit * 1000
		local result = workspace:Raycast(origin, direction, params)
		if result and result.Instance and result.Instance:IsDescendantOf(targetPart.Parent) then
			hits += 1
		end
	end

	return (hits / total) * 100 >= hitchance
end

-- ✅ UI УПОРЯДОЧЕН ЧЕРЕЗ UIListLayout

-- === RageBot UI Layout ===

-- === LegitBot UI Layout ===
local legitLayout = Instance.new("UIListLayout", LegitFrame)
legitLayout.SortOrder = Enum.SortOrder.LayoutOrder
legitLayout.Padding = UDim.new(0, 5)

-- Перемещаем элементы внутрь и упорядочиваем автоматически
hitChanceBox.LayoutOrder = 1
forceBodyBtn.LayoutOrder = 2
dynFovBtn.LayoutOrder = 3

legitFovBox.LayoutOrder = 1
backtrackBtn.LayoutOrder = 2
hitPartBtn.LayoutOrder = 3

local repaidFireEnabled = false

local repaidFireButton = Instance.new("TextButton", ContentFrames["Ragebot"])
repaidFireButton.Size = UDim2.new(0, 180, 0, 25)
repaidFireButton.Position = UDim2.new(0, 250, 0, 130)
repaidFireButton.Text = "RepaidFire: OFF"
repaidFireButton.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
repaidFireButton.TextColor3 = Color3.new(1, 1, 1)
repaidFireButton.Font = Enum.Font.SourceSansBold
repaidFireButton.TextSize = 14

repaidFireButton.MouseButton1Click:Connect(function()
	repaidFireEnabled = not repaidFireEnabled
	repaidFireButton.Text = "RepaidFire: " .. (repaidFireEnabled and "ON" or "OFF")

	if repaidFireEnabled then
		for _, weapon in pairs(game:GetService("ReplicatedStorage").Weapons:GetChildren()) do
			if weapon:IsA("Folder") then
				weapon:SetAttribute("Penetration", "9e999")
				weapon:SetAttribute("JumpSpread", 0)
				weapon:SetAttribute("LadderSpread", 0)
				weapon:SetAttribute("LandSpread", 0)
				weapon:SetAttribute("MoveSpread", 0)
				weapon:SetAttribute("RecoilX", 0)
				weapon:SetAttribute("RecoilY", 0)
				weapon:SetAttribute("Spread", 0)
				weapon:SetAttribute("CrouchSpread", 0)
				weapon:SetAttribute("CrouchRecoveryTime", 0)
				weapon:SetAttribute("FireSpread", 0)
				weapon:SetAttribute("FireRate", 0.1)
				weapon:SetAttribute("ClipRefill", 0)
				weapon:SetAttribute("EquipTime", 0)
				weapon:SetAttribute("Auto", true)
				weapon:SetAttribute("Bullets", 5)
				weapon:SetAttribute("MaxAmmo", 9e999)
			end
		end
	end
end)

local customGunFrame = Instance.new("Frame", RageBotFrame)
customGunFrame.Size = UDim2.new(0, 200, 0, 300)
customGunFrame.Position = UDim2.new(1, -210, 0, 10) -- справа внутри RageBotFrame
customGunFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
customGunFrame.BorderSizePixel = 0



-- 🧾 Параметры
local parameters = {
	{ name = "Penetration", default = "0" },
	{ name = "RecoilX", default = "0" },
	{ name = "RecoilY", default = "0" },
	{ name = "Spread", default = "0" },
	{ name = "FireRate", default = "0.1" },
	{ name = "Bullets", default = "0" },
}

local inputBoxes = {}
local yOffset = 10

for _, param in ipairs(parameters) do
	local label = Instance.new("TextLabel", customGunFrame)
	label.Size = UDim2.new(0, 200, 0, 20)
	label.Position = UDim2.new(0, 10, 0, yOffset)
	label.BackgroundTransparency = 1
	label.Text = param.name
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.SourceSans
	label.TextSize = 14

	yOffset += 22

	local box = Instance.new("TextBox", customGunFrame)
	box.Size = UDim2.new(0, 200, 0, 25)
	box.Position = UDim2.new(0, 10, 0, yOffset)
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.TextSize = 14
	box.Font = Enum.Font.SourceSans
	box.Text = param.default
	inputBoxes[param.name] = box

	yOffset += 35
end

-- 🔘 Кнопка применения
local applyButton = Instance.new("TextButton", customGunFrame)
applyButton.Size = UDim2.new(0, 200, 0, 30)
applyButton.Position = UDim2.new(0, 10, 0, yOffset)
applyButton.BackgroundColor3 = Color3.fromRGB(80, 50, 50)
applyButton.TextColor3 = Color3.new(1, 1, 1)
applyButton.Font = Enum.Font.SourceSansBold
applyButton.TextSize = 14
applyButton.Text = "CustomGun: APPLY"

applyButton.MouseButton1Click:Connect(function()
	for _, weapon in pairs(ReplicatedStorage:WaitForChild("Weapons"):GetChildren()) do
		if weapon:IsA("Folder") then
			for name, box in pairs(inputBoxes) do
				local val = tonumber(box.Text) or box.Text
				pcall(function()
					weapon:SetAttribute(name, val)
				end)
			end
			weapon:SetAttribute("Auto", true)
		end
	end
end)


-- 📦 World вкладка: управление яркостью и материалом карты

-- Добавляем текстбокс для яркости Ambient
local ambientBox = Instance.new("TextBox", ContentFrames["World"])
ambientBox.Size = UDim2.new(0, 200, 0, 25)
ambientBox.Position = UDim2.new(0, 10, 0, 10)
ambientBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ambientBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ambientBox.PlaceholderText = "Ambient (0-10)"
ambientBox.Font = Enum.Font.SourceSans
ambientBox.TextSize = 18
ambientBox.Text = "5"

-- Автообновление Ambient от значения в боксе
ambientBox:GetPropertyChangedSignal("Text"):Connect(function()
    local val = tonumber(ambientBox.Text)
    if val then
        val = math.clamp(val, 0, 10)
        Lighting.Ambient = Color3.new(val / 10, val / 10, val / 10)
    end
end)

local materials = {
    "Plastic", "Wood", "Slate", "Concrete", "Metal",
    "Cobblestone", "Neon", "Glass", "Granite",
    "Marble", "ForceField", "Grass", "WoodPlanks"
}

local materialList = Instance.new("ScrollingFrame")
materialList.Size = UDim2.new(0, 200, 0, 300)
materialList.Position = UDim2.new(0, 220, 0, 140)
materialList.CanvasSize = UDim2.new(0, 0, 0, 0)
materialList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
materialList.BorderSizePixel = 0
materialList.ScrollBarThickness = 4
materialList.Name = "MaterialList"
materialList.AutomaticCanvasSize = Enum.AutomaticSize.Y
materialList.ClipsDescendants = true
materialList.Parent = ContentFrames["World"]

local layout = Instance.new("UIListLayout", materialList)
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder

for _, matName in ipairs(materials) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 25)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    button.Text = matName
    button.Parent = materialList

    button.MouseButton1Click:Connect(function()
        local materialEnum = Enum.Material[matName]
        local geometry = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Geometry")
        if geometry then
            for _, part in ipairs(geometry:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = materialEnum
                    if part:IsA("MeshPart") then
                        pcall(function()
                            part.UseColor = true
                        end)
                    end
                end
            end
        end
    end)
end

-- Остальной код GUI и вкладок без изменений

local colorBox = Instance.new("TextBox")
colorBox.Size = UDim2.new(0, 200, 0, 25)
colorBox.Position = UDim2.new(0, 220, 0, 100) -- рядом с ScrollingFrame
colorBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
colorBox.TextColor3 = Color3.fromRGB(255, 255, 255)
colorBox.PlaceholderText = "R,G,B"
colorBox.Font = Enum.Font.SourceSans
colorBox.TextSize = 16
colorBox.Text = "255,200,200"
colorBox.Parent = ContentFrames["World"]

button.MouseButton1Click:Connect(function()
	local materialEnum = Enum.Material[matName]
	local geometry = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Geometry")
	if geometry then
		-- получаем цвет из colorBox
		local r, g, b = string.match(colorBox.Text, "(%d+),%s*(%d+),%s*(%d+)")
		local newColor = Color3.fromRGB(255, 200, 200) -- по умолчанию
		if r and g and b then
			newColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
		end

		for _, part in ipairs(geometry:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Material = materialEnum
				part.Color = newColor
				if part:IsA("MeshPart") then
					pcall(function()
						part.UseColor = true
					end)
				end
			end
		end
	end
end)

-- ✅ Полностью переработанный GUI со всеми вкладками, упорядоченными кнопками и автолэйаутом

-- 📦 Универсальные функции
local function setupTab(frame)
	local layout = Instance.new("UIListLayout", frame)
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local padding = Instance.new("UIPadding", frame)
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
end

local function createToggle(text, state, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.Text = text .. ": " .. (state and "ON" or "OFF")
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = text .. ": " .. (state and "ON" or "OFF")
		if callback then callback(state) end
	end)
	return btn
end

local function createLabel(text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 20)
	lbl.Text = text
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.new(1, 1, 1)
	lbl.Font = Enum.Font.SourceSans
	lbl.TextSize = 14
	return lbl
end

local function createTextBox(placeholder, defaultText)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, 0, 0, 25)
	box.PlaceholderText = placeholder or ""
	box.Text = defaultText or ""
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.SourceSans
	box.TextSize = 14
	return box
end

-- 🔁 Пример генерации для каждой вкладки
for tabName, frame in pairs(ContentFrames) do
	setupTab(frame)
	if tabName == "Ragebot" then
		frame:AddChild(createToggle("Ragebot", false))
		frame:AddChild(createLabel("FOV"))
		frame:AddChild(createTextBox("FOV", "150"))
		frame:AddChild(createLabel("HitPart"))
		frame:AddChild(createTextBox("Head/Torso", "Head"))
	elseif tabName == "Anti Aim" then
		frame:AddChild(createToggle("Anti Aim", false))
		frame:AddChild(createLabel("Speed"))
		frame:AddChild(createTextBox("Speed", "5"))
		frame:AddChild(createLabel("Mode"))
		frame:AddChild(createTextBox("Spin/Pitch", "Spin"))
	elseif tabName == "Legitbot" then
		frame:AddChild(createToggle("LegitBot", false))
		frame:AddChild(createLabel("Smoothness"))
		frame:AddChild(createTextBox("0.2"))
		frame:AddChild(createLabel("Range"))
		frame:AddChild(createTextBox("150"))
	elseif tabName == "ESP" then
		frame:AddChild(createToggle("Box ESP", true))
		frame:AddChild(createToggle("Name Tags", true))
		frame:AddChild(createToggle("Chams (Enemies)", false))
		frame:AddChild(createToggle("Chams (Friends)", false))
	elseif tabName == "Client" then
		frame:AddChild(createToggle("Client Mods", true))
		frame:AddChild(createLabel("WalkSpeed"))
		frame:AddChild(createTextBox("16"))
		frame:AddChild(createLabel("JumpPower"))
		frame:AddChild(createTextBox("50"))
	elseif tabName == "World" then
		frame:AddChild(createLabel("Ambient Brightness"))
		frame:AddChild(createTextBox("5")) -- ambientBox (0-10)
		frame:AddChild(createLabel("Map Material"))
		frame:AddChild(createToggle("Fog", false))
		frame:AddChild(createLabel("Ambient Color"))
		frame:AddChild(createTextBox("R,G,B", "100,100,100"))
		frame:AddChild(createLabel("Skybox ID"))
		frame:AddChild(createTextBox("123456789"))
	elseif tabName == "View" then
		frame:AddChild(createLabel("FOV"))
		frame:AddChild(createTextBox("FOV", "70"))
		frame:AddChild(createToggle("Third Person", false))
		frame:AddChild(createLabel("TP Distance"))
		frame:AddChild(createTextBox("100"))
	elseif tabName == "Malicious" then
		frame:AddChild(createToggle("FlyCam", false))
		frame:AddChild(createLabel("Bind Key"))
		frame:AddChild(createTextBox("H"))
	elseif tabName == "Players" then
		frame:AddChild(createLabel("Здесь появляется список игроков автоматически"))
	elseif tabName == "AutoBuy" or tabName == "Configs" then
		frame:AddChild(createLabel("Эта вкладка пока пустая — в разработке."))
	end
end


