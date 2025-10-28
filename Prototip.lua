-- RAGE VISUALS UI (cleaned, bind + config core)
-- LocalScript (StarterGui)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ====== STATE ======
local Binds = {}
local BindStates = {}

-- Forward declarations for UI objects we create later
local Gui, MainFrame, contentScroll, keybindScroll, KeybindListFrame, keybindToggle, keybindLayout
local keybindListVisible = false

-- ====== HELPERS ======
local function safeDestroy(obj)
	if obj and obj.Parent then obj:Destroy() end
end

local function makeUICorner(parent, radius)
	local c = Instance.new("UICorner", parent)
	c.CornerRadius = UDim.new(0, radius or 6)
	return c
end

local function makeUIStroke(parent, color, thickness)
	local s = Instance.new("UIStroke", parent)
	s.Color = color or Color3.fromRGB(80, 80, 100)
	s.Thickness = thickness or 1
	return s
end

-- ====== UPDATE KEYBIND LIST (side panel) ======
local function updateKeybindList()
	if not keybindScroll or not keybindScroll:IsDescendantOf(game) then return end

	-- Clear existing children (frames only)
	for i = #keybindScroll:GetChildren(), 1, -1 do
		local ch = keybindScroll:GetChildren()[i]
		if ch:IsA("Frame") then ch:Destroy() end
	end

	-- Add binds
	for name, bind in pairs(Binds) do
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 22)
		frame.BackgroundTransparency = 1
		frame.Parent = keybindScroll

		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(1, -60, 1, 0)
		label.Position = UDim2.new(0, 6, 0, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.Gotham
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextColor3 = BindStates[name] and Color3.fromRGB(220,50,50) or Color3.fromRGB(200,200,200)
		label.Text = name .. " - [" .. tostring(bind.key) .. "]"

		local status = Instance.new("TextLabel", frame)
		status.Size = UDim2.new(0, 45, 1, 0)
		status.Position = UDim2.new(1, -50, 0, 0)
		status.BackgroundTransparency = 1
		status.Font = Enum.Font.GothamBold
		status.TextSize = 11
		status.TextXAlignment = Enum.TextXAlignment.Right
		status.TextColor3 = BindStates[name] and Color3.fromRGB(0,255,0) or Color3.fromRGB(150,150,150)
		status.Text = BindStates[name] and "ON" or "OFF"
	end
end

-- ====== CREATE BIND MENU (change key/mode) ======
local function createBindMenu(bindName, bind)
	-- ensure Gui exists
	if not Gui or not Gui:IsDescendantOf(game) then return end
	-- create overlay (to detect outside click)
	local overlay = Instance.new("TextButton", Gui)
	overlay.Size = UDim2.new(1,0,1,0)
	overlay.BackgroundTransparency = 1
	overlay.Text = ""
	overlay.ZIndex = 99
	overlay.AutoButtonColor = false

	local menu = Instance.new("Frame", Gui)
	-- place near bind.frame if available, otherwise center
	local x, y =  (bind.frame and bind.frame.AbsolutePosition.X) or (Gui.AbsoluteSize.X/2 - 60), (bind.frame and bind.frame.AbsolutePosition.Y) or (Gui.AbsoluteSize.Y/2 - 50)
	menu.Size = UDim2.new(0, 140, 0, 120)
	menu.Position = UDim2.new(0, x + (bind.frame and bind.frame.AbsoluteSize.X + 10 or 0), 0, y)
	menu.BackgroundColor3 = Color3.fromRGB(25,25,35)
	menu.ZIndex = 100
	makeUICorner(menu, 6)
	makeUIStroke(menu, Color3.fromRGB(80,80,100))

	-- Modes
	local modes = {"Toggle", "Hold", "Off"}
	for i, mode in ipairs(modes) do
		local btn = Instance.new("TextButton", menu)
		btn.Size = UDim2.new(1, -10, 0, 26)
		btn.Position = UDim2.new(0, 5, 0, 6 + (i-1)*30)
		btn.BackgroundColor3 = bind.mode == mode and Color3.fromRGB(220,50,50) or Color3.fromRGB(40,40,50)
		btn.Text = mode
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 12
		btn.TextColor3 = Color3.new(1,1,1)
		makeUICorner(btn, 4)

		btn.MouseButton1Click:Connect(function()
			bind.mode = mode
			if mode == "Off" then
				BindStates[bindName] = false
			end
			-- update UI entries
			if bind.ui and bind.ui.modeLabel then
				bind.ui.modeLabel.Text = bind.mode
			end
			updateKeybindList()
			safeDestroy(menu)
			safeDestroy(overlay)
		end)
	end

	-- Change key button
	local changeBtn = Instance.new("TextButton", menu)
	changeBtn.Size = UDim2.new(1, -10, 0, 20)
	changeBtn.Position = UDim2.new(0, 5, 1, -28)
	changeBtn.BackgroundTransparency = 1
	changeBtn.Text = "Change Key"
	changeBtn.Font = Enum.Font.Gotham
	changeBtn.TextSize = 12
	changeBtn.TextColor3 = Color3.fromRGB(100,150,255)

	local waiting = false
	changeBtn.MouseButton1Click:Connect(function()
		if waiting then return end
		waiting = true
		changeBtn.Text = "Press any key..."
		local conn
		conn = UIS.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
				bind.key = input.KeyCode.Name
				-- update UI entries
				if bind.ui and bind.ui.keyLabel then
					bind.ui.keyLabel.Text = "["..bind.key.."]"
				end
				updateKeybindList()
				waiting = false
				safeDestroy(menu)
				safeDestroy(overlay)
				conn:Disconnect()
			end
		end)
	end)

	overlay.MouseButton1Click:Connect(function()
		safeDestroy(menu)
		safeDestroy(overlay)
	end)
end

-- ====== SIMPLE BIND CREATION (logic only) ======
local function createSimpleBind(name, defaultKey, defaultMode)
	local bind = {
		key = defaultKey,
		mode = defaultMode or "Toggle",
		frame = nil,
		ui = nil,
		connections = {}
	}
	Binds[name] = bind
	BindStates[name] = false

	-- Input began
	local c1 = UIS.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and tostring(input.KeyCode.Name) == tostring(bind.key) then
			if bind.mode == "Hold" then
				BindStates[name] = true
			elseif bind.mode == "Toggle" then
				BindStates[name] = not BindStates[name]
			end
			-- update UI
			updateKeybindList()
		end
	end)
	table.insert(bind.connections, c1)

	-- Input ended (for Hold)
	local c2 = UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard and tostring(input.KeyCode.Name) == tostring(bind.key) and bind.mode == "Hold" then
			BindStates[name] = false
			updateKeybindList()
		end
	end)
	table.insert(bind.connections, c2)

	-- return getter
	return function() return BindStates[name] end
end

-- ====== KEYBINDS TAB UI OPTION (shows in Keybinds tab) ======
-- ====== KEYBIND OPTION (ПКМ - смена режима, колёсико - смена клавиши) ======
local function createBindOption(parent, name, defaultKey, defaultMode)
	local bind = Binds[name]
	if not bind then 
		-- Если бинд не существует, создаем его
		bind = {
			key = defaultKey or "Unknown",
			mode = defaultMode or "Toggle",
			frame = nil
		}
		Binds[name] = bind
		BindStates[name] = false
	end

	local container = Instance.new("Frame", parent)
	container.Size = UDim2.new(1, 0, 0, 36)
	container.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(0.44, 0, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local keyLabel = Instance.new("TextLabel", container)
	keyLabel.Size = UDim2.new(0.22, 0, 1, 0)
	keyLabel.Position = UDim2.new(0.46, 0, 0, 0)
	keyLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	keyLabel.Text = "[" .. tostring(bind.key) .. "]"
	keyLabel.Font = Enum.Font.Gotham
	keyLabel.TextSize = 12
	keyLabel.TextColor3 = Color3.fromRGB(220, 50, 50)
	
	-- Используем существующие функции для создания углов и обводки
	local keyCorner = Instance.new("UICorner", keyLabel)
	keyCorner.CornerRadius = UDim.new(0, 4)
	local keyStroke = Instance.new("UIStroke", keyLabel)
	keyStroke.Color = Color3.fromRGB(80, 80, 100)

	local modeLabel = Instance.new("TextLabel", container)
	modeLabel.Size = UDim2.new(0.22, 0, 1, 0)
	modeLabel.Position = UDim2.new(0.68, 0, 0, 0)
	modeLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	modeLabel.Text = bind.mode or "Toggle"
	modeLabel.Font = Enum.Font.Gotham
	modeLabel.TextSize = 12
	modeLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
	
	local modeCorner = Instance.new("UICorner", modeLabel)
	modeCorner.CornerRadius = UDim.new(0, 4)
	local modeStroke = Instance.new("UIStroke", modeLabel)
	modeStroke.Color = Color3.fromRGB(80, 80, 100)

	-- Прозрачная кнопка для кликов
	local clickArea = Instance.new("TextButton", container)
	clickArea.Size = UDim2.new(1, 0, 1, 0)
	clickArea.BackgroundTransparency = 1
	clickArea.Text = ""
	clickArea.AutoButtonColor = false

	-- === ПКМ: меню выбора режима ===
	clickArea.MouseButton2Click:Connect(function()
		-- Создаем затемняющий оверлей
		local overlay = Instance.new("TextButton", Gui)
		overlay.Size = UDim2.new(1, 0, 1, 0)
		overlay.BackgroundTransparency = 1
		overlay.Text = ""
		overlay.ZIndex = 99
		overlay.AutoButtonColor = false

		-- Создаем меню
		local menu = Instance.new("Frame", Gui)
		menu.Size = UDim2.new(0, 130, 0, 100)
		menu.Position = UDim2.new(0, container.AbsolutePosition.X + container.AbsoluteSize.X + 10, 0, container.AbsolutePosition.Y)
		menu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
		menu.ZIndex = 100
		
		local menuCorner = Instance.new("UICorner", menu)
		menuCorner.CornerRadius = UDim.new(0, 6)
		local menuStroke = Instance.new("UIStroke", menu)
		menuStroke.Color = Color3.fromRGB(80, 80, 100)

		local modes = {"Toggle", "Hold", "On", "Off"}
		for i, mode in ipairs(modes) do
			local btn = Instance.new("TextButton", menu)
			btn.Size = UDim2.new(1, -10, 0, 22)
			btn.Position = UDim2.new(0, 5, 0, 6 + (i - 1) * 23)
			btn.BackgroundColor3 = bind.mode == mode and Color3.fromRGB(220, 50, 50) or Color3.fromRGB(40, 40, 50)
			btn.Text = mode
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 12
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.ZIndex = 101
			
			local btnCorner = Instance.new("UICorner", btn)
			btnCorner.CornerRadius = UDim.new(0, 4)

			btn.MouseButton1Click:Connect(function()
				bind.mode = mode
				modeLabel.Text = mode
				updateKeybindList()
				
				-- Уничтожаем меню и оверлей
				if menu and menu.Parent then
					menu:Destroy()
				end
				if overlay and overlay.Parent then
					overlay:Destroy()
				end
			end)
		end

		-- Закрытие при клике вне меню
		overlay.MouseButton1Click:Connect(function()
			if menu and menu.Parent then
				menu:Destroy()
			end
			if overlay and overlay.Parent then
				overlay:Destroy()
			end
		end)
	end)

	-- === ЛКМ: выбор своей клавиши ===
	clickArea.MouseButton1Click:Connect(function()
		keyLabel.Text = "Press any key..."
		local conn
		conn = UIS.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				bind.key = input.KeyCode.Name
				keyLabel.Text = "[" .. bind.key .. "]"
				updateKeybindList()
				conn:Disconnect()
			end
		end)
	end)

	-- сохраняем ссылки
	bind.frame = container
	bind.ui = { keyLabel = keyLabel, modeLabel = modeLabel }
	
	return container
end

-- ====== ADD BIND (convenience) ======
local function addBind(name, defaultKey, defaultMode, createInKeybindTab)
	-- create logic
	local getter = createSimpleBind(name, defaultKey, defaultMode)
	-- create option in Keybinds tab if present
	if createInKeybindTab and type(createInKeybindTab) == "table" then
		createBindOption(createInKeybindTab, name)
	end
	-- refresh side list
	updateKeybindList()
	return getter
end

-- ====== CONFIG SYSTEM ======
local ConfigSystem = {
	Configs = {},
	CurrentConfig = nil
}

function ConfigSystem:SaveConfig(name)
	if self.Configs[name] then
		return "exists"
	end
	local data = {
		timestamp = os.time(),
		created = os.date("%Y-%m-%d %H:%M:%S"),
		updated = os.date("%Y-%m-%d %H:%M:%S"),
		data = {
			version = "1.0",
			binds = Binds,
			bindStates = BindStates
		}
	}
	self.Configs[name] = data
	self.CurrentConfig = name
	return "success"
end

function ConfigSystem:OverwriteConfig(name)
	if not self.Configs[name] then return false end
	self.Configs[name].updated = os.date("%Y-%m-%d %H:%M:%S")
	self.Configs[name].timestamp = os.time()
	self.Configs[name].data.binds = Binds
	self.Configs[name].data.bindStates = BindStates
	self.CurrentConfig = name
	return true
end

function ConfigSystem:LoadConfig(name)
	if not self.Configs[name] then return false end
	self.CurrentConfig = name
	local cfg = self.Configs[name].data
	if cfg.binds then
		for bname, bdata in pairs(cfg.binds) do
			if Binds[bname] then
				Binds[bname].key = bdata.key
				Binds[bname].mode = bdata.mode
				-- update UI if present
				if Binds[bname].ui and Binds[bname].ui.keyLabel then
					Binds[bname].ui.keyLabel.Text = "["..tostring(Binds[bname].key).."]"
				end
				if Binds[bname].ui and Binds[bname].ui.modeLabel then
					Binds[bname].ui.modeLabel.Text = tostring(Binds[bname].mode)
				end
			end
		end
	end
	if cfg.bindStates then
		for bname, state in pairs(cfg.bindStates) do
			BindStates[bname] = state
		end
	end
	updateKeybindList()
	return true
end

function ConfigSystem:DeleteConfig(name)
	if not self.Configs[name] then return false end
	self.Configs[name] = nil
	if self.CurrentConfig == name then self.CurrentConfig = nil end
	return true
end

function ConfigSystem:ResetConfig()
	self.CurrentConfig = nil
	for k,_ in pairs(BindStates) do BindStates[k] = false end
	updateKeybindList()
	return true
end

function ConfigSystem:GetConfigList()
	local out = {}
	for name, info in pairs(self.Configs) do
		table.insert(out, {name = name, created = info.created, updated = info.updated})
	end
	table.sort(out, function(a,b) return a.name < b.name end)
	return out
end

-- ====== BUILD GUI ======
Gui = Instance.new("ScreenGui")
Gui.Name = "RageVisualsUI"
Gui.ResetOnSpawn = false
Gui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
MainFrame = Instance.new("Frame", Gui)
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 520, 0, 600)
MainFrame.Position = UDim2.new(0.25, 0, 0.12, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
makeUICorner(MainFrame, 8)
makeUIStroke(MainFrame, Color3.fromRGB(60,60,80))

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Position = UDim2.new(0,0,0,0)
Header.BackgroundColor3 = Color3.fromRGB(25,25,35)
makeUICorner(Header, 8)

local Title = Instance.new("TextLabel", Header)
Title.Text = "LOLSENSE"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(220,50,50)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left

--local CloseButton = Instance.new("TextButton", Header)
--CloseButton.Text = "×"
--CloseButton.Font = Enum.Font.GothamBold
--CloseButton.TextSize = 20
--CloseButton.TextColor3 = Color3.fromRGB(200,200,200)
--CloseButton.BackgroundTransparency = 1
--CloseButton.Size = UDim2.new(0, 30, 0, 30)
--CloseButton.Position = UDim2.new(1, -60, 0.5, -15)
--CloseButton.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- Keybind show checkbox will be placed to the right in Header
local keybindCheckContainer = Instance.new("Frame", Header)
keybindCheckContainer.Size = UDim2.new(0, 110, 0, 30)
keybindCheckContainer.Position = UDim2.new(1, -110, 0.5, -15)
keybindCheckContainer.BackgroundTransparency = 1

local function createCheckboxSimple(parent, text, callback)
	local container = Instance.new("Frame", parent)
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundTransparency = 1

	local checkbox = Instance.new("TextButton", container)
	checkbox.Size = UDim2.new(0, 18, 0, 18)
	checkbox.Position = UDim2.new(0, 2, 0.5, -9)
	checkbox.BackgroundColor3 = Color3.fromRGB(40,40,50)
	checkbox.BorderSizePixel = 0
	checkbox.AutoButtonColor = false
	makeUICorner(checkbox, 4)
	makeUIStroke(checkbox, Color3.fromRGB(80,80,100))

	local label = Instance.new("TextLabel", container)
	label.Size = UDim2.new(1, -24, 1, 0)
	label.Position = UDim2.new(0, 24, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextColor3 = Color3.fromRGB(200,200,200)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local enabled = false
	local function setState(state)
		enabled = not not state
		checkbox.BackgroundColor3 = enabled and Color3.fromRGB(220,50,50) or Color3.fromRGB(40,40,50)
		if callback then callback(enabled) end
	end
	local function getState() return enabled end

	checkbox.MouseButton1Click:Connect(function()
		setState(not enabled)
	end)

	return getState, setState
end

-- Tabs container (left)
local TabsContainer = Instance.new("Frame", MainFrame)
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(0, 120, 1, -120)
TabsContainer.Position = UDim2.new(0, 0, 0, 40)
TabsContainer.BackgroundColor3 = Color3.fromRGB(25,25,35)
makeUICorner(TabsContainer, 6)

local tabsLayout = Instance.new("UIListLayout", TabsContainer)
tabsLayout.Padding = UDim.new(0, 6)
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Content area (right)
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -120, 1, -120)
ContentContainer.Position = UDim2.new(0, 120, 0, 40)
ContentContainer.BackgroundColor3 = Color3.fromRGB(20,20,25)
ContentContainer.BorderSizePixel = 0

contentScroll = Instance.new("ScrollingFrame", ContentContainer)
contentScroll.Size = UDim2.new(1, 0, 1, 0)
contentScroll.BackgroundTransparency = 1
contentScroll.ScrollBarThickness = 6
contentScroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,100)
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroll.Parent = ContentContainer
local contentLayout = Instance.new("UIListLayout", contentScroll)
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Bottom (reserved)
local BottomSection = Instance.new("Frame", MainFrame)
BottomSection.Name = "BottomSection"
BottomSection.Size = UDim2.new(1, 0, 0, 80)
BottomSection.Position = UDim2.new(0, 0, 1, -80)
BottomSection.BackgroundColor3 = Color3.fromRGB(25,25,35)
makeUICorner(BottomSection, 8)

-- ====== KEYBIND SIDE LIST ======
KeybindListFrame = Instance.new("Frame", Gui)
KeybindListFrame.Name = "KeybindList"
KeybindListFrame.Size = UDim2.new(0, 220, 0, 60)
KeybindListFrame.Position = UDim2.new(0, MainFrame.Position.X.Offset + MainFrame.Size.X.Offset + 20, 0, MainFrame.Position.Y.Offset)
KeybindListFrame.BackgroundColor3 = Color3.fromRGB(20,20,25)
KeybindListFrame.BorderSizePixel = 0
KeybindListFrame.Active = true
KeybindListFrame.Draggable = true
KeybindListFrame.Visible = false
KeybindListFrame.ClipsDescendants = true
makeUICorner(KeybindListFrame, 8)
makeUIStroke(KeybindListFrame, Color3.fromRGB(60,60,80))

local keybindHeader = Instance.new("Frame", KeybindListFrame)
keybindHeader.Size = UDim2.new(1, 0, 0, 30)
keybindHeader.Position = UDim2.new(0,0,0,0)
keybindHeader.BackgroundColor3 = Color3.fromRGB(25,25,35)

local keybindTitle = Instance.new("TextLabel", keybindHeader)
keybindTitle.Text = "Keybind List"
keybindTitle.Font = Enum.Font.GothamBold
keybindTitle.TextSize = 14
keybindTitle.TextColor3 = Color3.fromRGB(220,50,50)
keybindTitle.BackgroundTransparency = 1
keybindTitle.Size = UDim2.new(1, -30, 1, 0)
keybindTitle.Position = UDim2.new(0, 10, 0, 0)
keybindTitle.TextXAlignment = Enum.TextXAlignment.Left

keybindToggle = Instance.new("TextButton", keybindHeader)
keybindToggle.Text = "+"
keybindToggle.Font = Enum.Font.GothamBold
keybindToggle.TextSize = 16
keybindToggle.TextColor3 = Color3.fromRGB(200,200,200)
keybindToggle.BackgroundTransparency = 1
keybindToggle.Size = UDim2.new(0, 20, 0, 20)
keybindToggle.Position = UDim2.new(1, -25, 0.5, -10)

keybindScroll = Instance.new("ScrollingFrame", KeybindListFrame)
keybindScroll.Size = UDim2.new(1, -10, 0, 0)
keybindScroll.Position = UDim2.new(0, 5, 0, 35)
keybindScroll.BackgroundTransparency = 1
keybindScroll.ScrollBarThickness = 4
keybindScroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,100)
keybindScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
keybindScroll.ClipsDescendants = true

keybindLayout = Instance.new("UIListLayout", keybindScroll)
keybindLayout.Padding = UDim.new(0, 5)
keybindLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ====== CONFIRMATION DIALOG ======
local function showConfirmation(title, message, confirmCallback, cancelCallback)
    local backgroundOverlay = Instance.new("TextButton", Gui)
    backgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
    backgroundOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    backgroundOverlay.BackgroundTransparency = 0.5
    backgroundOverlay.Text = ""
    backgroundOverlay.BorderSizePixel = 0
    backgroundOverlay.ZIndex = 99

    local dialog = Instance.new("Frame", Gui)
    dialog.Size = UDim2.new(0, 300, 0, 150)
    dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
    dialog.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    dialog.BorderSizePixel = 0
    dialog.ZIndex = 100
    makeUICorner(dialog, 8)
    makeUIStroke(dialog, Color3.fromRGB(80, 80, 100), 2)

    local titleLabel = Instance.new("TextLabel", dialog)
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(220, 50, 50)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 101

    local messageLabel = Instance.new("TextLabel", dialog)
    messageLabel.Size = UDim2.new(1, -20, 0, 50)
    messageLabel.Position = UDim2.new(0, 10, 0, 45)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 13
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.TextWrapped = true
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.ZIndex = 101

    local buttonContainer = Instance.new("Frame", dialog)
    buttonContainer.Size = UDim2.new(1, -20, 0, 35)
    buttonContainer.Position = UDim2.new(0, 10, 1, -50)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.ZIndex = 101

    local buttonLayout = Instance.new("UIGridLayout", buttonContainer)
    buttonLayout.CellSize = UDim2.new(0.45, 0, 1, 0)
    buttonLayout.CellPadding = UDim2.new(0.1, 0, 0, 0)
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local function closeDialog()
        safeDestroy(dialog)
        safeDestroy(backgroundOverlay)
    end

    local confirmBtn = Instance.new("TextButton", buttonContainer)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    confirmBtn.Text = "Yes"
    confirmBtn.Font = Enum.Font.Gotham
    confirmBtn.TextSize = 14
    confirmBtn.TextColor3 = Color3.new(1, 1, 1)
    confirmBtn.AutoButtonColor = false
    confirmBtn.BorderSizePixel = 0
    confirmBtn.ZIndex = 102
    makeUICorner(confirmBtn, 6)

    local cancelBtn = Instance.new("TextButton", buttonContainer)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    cancelBtn.Text = "No"
    cancelBtn.Font = Enum.Font.Gotham
    cancelBtn.TextSize = 14
    cancelBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    cancelBtn.AutoButtonColor = false
    cancelBtn.BorderSizePixel = 0
    cancelBtn.ZIndex = 102
    makeUICorner(cancelBtn, 6)

    confirmBtn.MouseButton1Click:Connect(function()
        if confirmCallback then confirmCallback() end
        closeDialog()
    end)
    
    cancelBtn.MouseButton1Click:Connect(function()
        if cancelCallback then cancelCallback() end
        closeDialog()
    end)
    
    backgroundOverlay.MouseButton1Click:Connect(closeDialog)
end

-- Toggle function (keeps frame visible, just collapses/expands)
local function toggleKeybindList(state)
	if state ~= nil then keybindListVisible = state else keybindListVisible = not keybindListVisible end
	keybindToggle.Text = keybindListVisible and "−" or "+"
	-- keep KeybindListFrame visible so it doesn't disappear; just animate size
	KeybindListFrame.Visible = true
	TweenService:Create(KeybindListFrame, TweenInfo.new(0.25), {
		Size = keybindListVisible and UDim2.new(0, 220, 0, 250) or UDim2.new(0, 220, 0, 60)
	}):Play()
	TweenService:Create(keybindScroll, TweenInfo.new(0.25), {
		Size = keybindListVisible and UDim2.new(1, -10, 0, 210) or UDim2.new(1, -10, 0, 0)
	}):Play()

	-- When collapsed, keep content but small; when expanded, reset canvas pos
	if keybindListVisible then
		task.delay(0.28, function()
			if keybindScroll and keybindScroll:IsDescendantOf(game) then
				keybindScroll.CanvasPosition = Vector2.new(0,0)
			end
		end)
	end
end

keybindToggle.MouseButton1Click:Connect(function() toggleKeybindList() end)

-- ====== TABS (minimal) ======
local tabs = {}
local currentTab = nil
local function createTab(name)
	local tabButton = Instance.new("TextButton", TabsContainer)
	tabButton.Size = UDim2.new(0.9, 0, 0, 36)
	tabButton.BackgroundColor3 = Color3.fromRGB(35,35,45)
	tabButton.Text = name
	tabButton.Font = Enum.Font.Gotham
	tabButton.TextSize = 14
	tabButton.TextColor3 = Color3.fromRGB(150,150,150)
	tabButton.AutoButtonColor = false
	tabButton.BorderSizePixel = 0
	makeUICorner(tabButton, 6)

	local tabContent = Instance.new("Frame", contentScroll)
	tabContent.Size = UDim2.new(1, 0, 0, 0)
	tabContent.BackgroundTransparency = 1
	tabContent.Visible = false
	local contentList = Instance.new("UIListLayout", tabContent)
	contentList.Padding = UDim.new(0, 8)
	contentList.SortOrder = Enum.SortOrder.LayoutOrder

	tabButton.MouseButton1Click:Connect(function()
		for _, t in pairs(tabs) do
			if t.button and t.button:IsDescendantOf(game) then
				t.button.BackgroundColor3 = Color3.fromRGB(35,35,45)
				t.button.TextColor3 = Color3.fromRGB(150,150,150)
			end
			if t.content and t.content:IsDescendantOf(game) then
				t.content.Visible = false
			end
		end
		tabButton.BackgroundColor3 = Color3.fromRGB(220,50,50)
		tabButton.TextColor3 = Color3.new(1,1,1)
		tabContent.Visible = true
		currentTab = name
	end)

	tabs[name] = {button = tabButton, content = tabContent}
	if not currentTab then
		currentTab = name
		tabButton.BackgroundColor3 = Color3.fromRGB(220,50,50)
		tabButton.TextColor3 = Color3.new(1,1,1)
		tabContent.Visible = true
	end
	return tabContent
end

local KeybindsTab = createTab("Keybinds")
local SecretTab = createTab("Configs")

-- ====== UI CREATION HELPERS (small set kept) ======
local function createSection(parent, title)
	local section = Instance.new("Frame", parent)
	section.Size = UDim2.new(1,0,0,0)
	section.BackgroundTransparency = 1
	local layout = Instance.new("UIListLayout", section)
	layout.Padding = UDim.new(0,6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	if title then
		local tl = Instance.new("TextLabel", section)
		tl.Size = UDim2.new(1,0,0,20)
		tl.BackgroundTransparency = 1
		tl.Text = title
		tl.Font = Enum.Font.GothamBold
		tl.TextSize = 14
		tl.TextColor3 = Color3.fromRGB(220,50,50)
		tl.TextXAlignment = Enum.TextXAlignment.Left
	end
	return section
end

local function createButton(parent, text, callback)
	local button = Instance.new("TextButton", parent)
	button.Size = UDim2.new(1,0,0,34)
	button.BackgroundColor3 = Color3.fromRGB(40,40,50)
	button.Text = text
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.TextColor3 = Color3.fromRGB(200,200,200)
	button.AutoButtonColor = false
	makeUICorner(button, 6)
	makeUIStroke(button, Color3.fromRGB(80,80,100))
	button.MouseButton1Click:Connect(function()
		if callback then callback() end
		TweenService:Create(button, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(220,50,50)}):Play()
		task.delay(0.08, function() TweenService:Create(button, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(40,40,50)}):Play() end)
	end)
	return button
end

-- ====== SECRET TAB: Config UI (simplified) ======
local secretSection = createSection(SecretTab, "Config")
local configListLabel = Instance.new("TextLabel", secretSection)
configListLabel.Size = UDim2.new(1,0,0,18)
configListLabel.BackgroundTransparency = 1
configListLabel.Text = "Configurations:"
configListLabel.Font = Enum.Font.GothamBold
configListLabel.TextSize = 14
configListLabel.TextColor3 = Color3.fromRGB(220,50,50)
configListLabel.TextXAlignment = Enum.TextXAlignment.Left

local configScroll = Instance.new("ScrollingFrame", secretSection)
configScroll.Size = UDim2.new(1,0,0,120)
configScroll.BackgroundColor3 = Color3.fromRGB(30,30,40)
configScroll.BorderSizePixel = 0
configScroll.ScrollBarThickness = 4
configScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
makeUICorner(configScroll, 6)

local configLayout = Instance.new("UIListLayout", configScroll)
configLayout.Padding = UDim.new(0,4)
configLayout.SortOrder = Enum.SortOrder.LayoutOrder

local configInputContainer = Instance.new("Frame", secretSection)
configInputContainer.Size = UDim2.new(1,0,0,34)
configInputContainer.BackgroundTransparency = 1

local configTextBox = Instance.new("TextBox", configInputContainer)
configTextBox.Size = UDim2.new(1,0,1,0)
configTextBox.BackgroundColor3 = Color3.fromRGB(40,40,50)
configTextBox.Text = ""
configTextBox.Font = Enum.Font.Gotham
configTextBox.TextSize = 13
configTextBox.TextColor3 = Color3.fromRGB(200,200,200)
configTextBox.PlaceholderText = "Enter config name..."
configTextBox.ClearTextOnFocus = false
makeUICorner(configTextBox, 6)
makeUIStroke(configTextBox, Color3.fromRGB(80,80,100))

local buttonsContainer = Instance.new("Frame", secretSection)
buttonsContainer.Size = UDim2.new(1,0,0,36)
buttonsContainer.BackgroundTransparency = 1
local buttonsLayout = Instance.new("UIGridLayout", buttonsContainer)
buttonsLayout.CellSize = UDim2.new(0.32,0,1,0)
buttonsLayout.CellPadding = UDim2.new(0.04,0,0,0)

local function updateConfigList()
	-- clear
	for i = #configScroll:GetChildren(), 1, -1 do
		local ch = configScroll:GetChildren()[i]
		if ch:IsA("TextButton") then ch:Destroy() end
	end
	local list = ConfigSystem:GetConfigList()
	for _, v in ipairs(list) do
		local btn = Instance.new("TextButton", configScroll)
		btn.Size = UDim2.new(1, -10, 0, 36)
		btn.Position = UDim2.new(0, 5, 0, 0)
		btn.BackgroundColor3 = Color3.fromRGB(40,40,50)
		btn.Text = v.name
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 12
		btn.TextColor3 = Color3.fromRGB(200,200,200)
		btn.AutoButtonColor = false
		makeUICorner(btn, 6)
		local info = Instance.new("TextLabel", btn)
		info.Size = UDim2.new(1, -10, 0, 14)
		info.Position = UDim2.new(0, 6, 1, -18)
		info.BackgroundTransparency = 1
		info.Font = Enum.Font.Gotham
		info.TextSize = 10
		info.TextColor3 = Color3.fromRGB(150,150,150)
		info.Text = "Updated: " .. (v.updated or "")
		info.TextXAlignment = Enum.TextXAlignment.Left
		btn.MouseButton1Click:Connect(function()
			configTextBox.Text = v.name
			ConfigSystem:LoadConfig(v.name)
		end)
	end
end

-- config buttons
local saveBtn = createButton(buttonsContainer, "Save", function()
	local configName = configTextBox.Text
	if configName and configName ~= "" then
		local result = ConfigSystem:SaveConfig(configName)
		if result == "exists" then
			showConfirmation(
				"Config Exists",
				"Config '" .. configName .. "' already exists. Overwrite?",
				function()
					ConfigSystem:OverwriteConfig(configName)
					updateConfigList()
					print("Config overwritten:", configName)
				end,
				function()
					print("Save cancelled")
				end
			)
		else
			updateConfigList()
			print("Config saved:", configName)
		end
	else
		showConfirmation(
			"Missing Name",
			"Please enter a config name before saving.",
			nil,
			nil
		)
	end
end)

local loadBtn = createButton(buttonsContainer, "Load", function()
	local configName = configTextBox.Text
	if configName and configName ~= "" then
		if ConfigSystem:LoadConfig(configName) then
			print("Config loaded:", configName)
		else
			showConfirmation(
				"Config Not Found",
				"Config '" .. configName .. "' does not exist.",
				nil,
				nil
			)
		end
	else
		showConfirmation(
			"Missing Name",
			"Please enter a config name before loading.",
			nil,
			nil
		)
	end
end)
local delBtn = createButton(buttonsContainer, "Delete", function()
	local configName = configTextBox.Text
	if configName and configName ~= "" then
		if ConfigSystem.Configs[configName] then
			showConfirmation(
				"Delete Config",
				"Are you sure you want to delete config '" .. configName .. "'? This action cannot be undone.",
				function()
					if ConfigSystem:DeleteConfig(configName) then
						updateConfigList()
						configTextBox.Text = ""
						print("Config deleted:", configName)
					else
						showConfirmation(
							"Delete Failed",
							"Failed to delete config '" .. configName .. "'.",
							nil,
							nil
						)
					end
				end,
				function()
					print("Delete cancelled")
				end
			)
		else
			showConfirmation(
				"Config Not Found",
				"Config '" .. configName .. "' does not exist.",
				nil,
				nil
			)
		end
	else
		showConfirmation(
			"Missing Name",
			"Please enter a config name before deleting.",
			nil,
			nil
		)
	end
end)

-- parent children hookup
saveBtn.Parent = buttonsContainer
loadBtn.Parent = buttonsContainer
delBtn.Parent = buttonsContainer

-- ====== KEYBINDS TAB (content) ======
local keybindsSection = createSection(KeybindsTab, "Keybinds")

local function addBindOptionUIAll()
	-- clear existing options in KeybindsTab
	for i = #keybindsSection:GetChildren(), 1, -1 do
		local ch = keybindsSection:GetChildren()[i]
		if ch:IsA("Frame") then ch:Destroy() end
	end
	-- re-create
	for name,_ in pairs(Binds) do
		createBindOption(keybindsSection, name)
	end
end

-- ====== Hook up Keybind show checkbox in header ======
local getKeybindCheckState, setKeybindCheckState = createCheckboxSimple(keybindCheckContainer, "Show Keybind List", function(state)
	toggleKeybindList(state)
end)

-- ====== Auto-resize handlers ======
contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	if contentScroll and contentScroll:IsDescendantOf(game) then
		contentScroll.CanvasSize = UDim2.new(0,0,0, contentLayout.AbsoluteContentSize.Y)
	end
end)
keybindLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	if keybindScroll and keybindScroll:IsDescendantOf(game) then
		keybindScroll.CanvasSize = UDim2.new(0,0,0, keybindLayout.AbsoluteContentSize.Y)
	end
end)


-- Toggle GUI (Insert)
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		MainFrame.Visible = not MainFrame.Visible
	end
end)


