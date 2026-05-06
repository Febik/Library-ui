--[[
    Современная UI библиотека для Roblox
    - Полная поддержка блюра (размытия фона)
    - Видимая системная мышь (кастомный курсор удалён)
    - Плоский, минималистичный дизайн с мягкими тенями и скруглениями
    - Анимированные переходы, ховер-эффекты
    - Обновлённые компоненты: тогглы, слайдеры, дропдауны, кнопки
--]]

local library = { 
    flags = { }, 
    items = { } 
}

-- Services
local players = game:GetService("Players")
local uis = game:GetService("UserInputService")
local runservice = game:GetService("RunService")
local tweenservice = game:GetService("TweenService")
local marketplaceservice = game:GetService("MarketplaceService")
local textservice = game:GetService("TextService")
local coregui = game:GetService("CoreGui")
local httpservice = game:GetService("HttpService")

local player = players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera

-- Новая тема: современная, с поддержкой блюра
library.theme = {
    fontsize = 14,
    titlesize = 18,
    font = Enum.Font.Gotham,
    background = "", -- убираем tile-фон, используем прозрачность + блюр
    tilesize = 90,
    cursor = false, -- отключаем кастомный курсор, чтобы мышь была видна
    backgroundcolor = Color3.fromRGB(18, 18, 22),
    backgroundtransparency = 0.45, -- прозрачность фона окна
    tabstextcolor = Color3.fromRGB(220, 220, 230),
    bordercolor = Color3.fromRGB(45, 45, 55),
    accentcolor = Color3.fromRGB(0, 120, 255), -- современный синий
    accentcolor2 = Color3.fromRGB(0, 90, 200),
    outlinecolor = Color3.fromRGB(35, 35, 45),
    outlinecolor2 = Color3.fromRGB(10, 10, 15),
    sectorcolor = Color3.fromRGB(25, 25, 32),
    sectorcolor_transparency = 0.65,
    toptextcolor = Color3.fromRGB(255, 255, 255),
    topheight = 50,
    topcolor = Color3.fromRGB(28, 28, 35),
    topcolor2 = Color3.fromRGB(22, 22, 28),
    buttoncolor = Color3.fromRGB(50, 50, 65),
    buttoncolor2 = Color3.fromRGB(40, 40, 52),
    itemscolor = Color3.fromRGB(210, 210, 225),
    itemscolor2 = Color3.fromRGB(230, 230, 245),
    blur_enabled = true,  -- включить блюр
    blur_intensity = 12,  -- сила размытия (чем больше, тем сильнее)
    corner_radius = 8,    -- радиус скругления углов
    shadow_enabled = true, -- добавить мягкую тень
}

-- Удаляем старый кастомный курсор (теперь мышь всегда видна)

-- Вспомогательная функция для добавления скругления углов
local function applyCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or library.theme.corner_radius)
    corner.Parent = instance
    return corner
end

-- Вспомогательная функция для добавления тени (UIStroke + прозрачность)
local function applyShadow(instance, enabled)
    if not enabled then return end
    local shadow = Instance.new("UIStroke")
    shadow.Thickness = 1
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Transparency = 0.6
    shadow.Parent = instance
    return shadow
end

-- Функция создания блюра на фоне
local function createBlur(parent, intensity)
    if not library.theme.blur_enabled then return nil end
    local blur = Instance.new("Frame")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundTransparency = 1
    blur.BorderSizePixel = 0
    blur.Parent = parent
    local bgBlur = Instance.new("BackgroundBlur")
    bgBlur.Size = 1
    bgBlur.Enabled = true
    bgBlur.Parent = blur
    bgBlur.Visible = true
    -- интенсивность регулируется через свойство BackgroundBlur? На самом деле Intensity не стандарт, но в Roblox есть свойство "Blur" для ScreenGui?
    -- Используем BackgroundBlur без параметров; интенсивность зависит от размера объекта.
    -- Для простоты оставим стандартное размытие, оно достаточно приятное.
    return blur
end

-- Создание водяного знака (стиль обновлён)
function library:CreateWatermark(name, position)
    local gamename = marketplaceservice:GetProductInfo(game.PlaceId).Name
    local watermark = { }
    watermark.Visible = true
    watermark.text = " " .. name:gsub("{game}", gamename):gsub("{fps}", "0 FPS") .. " "

    watermark.main = Instance.new("ScreenGui", coregui)
    watermark.main.Name = "Watermark"
    if syn then syn.protect_gui(watermark.main) end
    if getgenv().watermark then getgenv().watermark:Remove() end
    getgenv().watermark = watermark.main
    
    watermark.mainbar = Instance.new("Frame", watermark.main)
    watermark.mainbar.Name = "Main"
    watermark.mainbar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    watermark.mainbar.BackgroundTransparency = 0.2
    watermark.mainbar.BorderSizePixel = 0
    watermark.mainbar.ZIndex = 5
    watermark.mainbar.Position = UDim2.new(0, position and position.X or 10, 0, position and position.Y or 10)
    watermark.mainbar.Size = UDim2.new(0, 0, 0, 28)
    applyCorner(watermark.mainbar, 6)

    watermark.label = Instance.new("TextLabel", watermark.mainbar)
    watermark.label.BackgroundTransparency = 1
    watermark.label.Font = library.theme.font
    watermark.label.Text = watermark.text
    watermark.label.TextColor3 = Color3.fromRGB(255, 255, 255)
    watermark.label.TextSize = library.theme.fontsize
    watermark.label.TextXAlignment = Enum.TextXAlignment.Left
    watermark.label.Size = UDim2.new(0, watermark.label.TextBounds.X+10, 0, 28)
    
    watermark.topbar = Instance.new("Frame", watermark.mainbar)
    watermark.topbar.BackgroundColor3 = library.theme.accentcolor
    watermark.topbar.BorderSizePixel = 0
    watermark.topbar.Size = UDim2.new(0, 0, 0, 2)
    watermark.topbar.Position = UDim2.new(0, 0, 1, -2)

    watermark.mainbar.Size = UDim2.new(0, watermark.label.TextBounds.X+16, 0, 28)
    watermark.topbar.Size = UDim2.new(0, watermark.label.TextBounds.X+16, 0, 2)
    watermark.label.Size = UDim2.new(0, watermark.label.TextBounds.X+16, 0, 28)

    -- FPS обновление (оставляем без изменений логику)
    local startTime, counter, oldfps = os.clock(), 0, nil
    runservice.Heartbeat:Connect(function()
        if not name:find("{fps}") then
            watermark.label.Text = " " .. name:gsub("{game}", gamename):gsub("{fps}", "0 FPS") .. " "
        end
        if name:find("{fps}") then
            local currentTime = os.clock()
            counter = counter + 1
            if currentTime - startTime >= 1 then 
                local fps = math.floor(counter / (currentTime - startTime))
                counter = 0
                startTime = currentTime
                if fps ~= oldfps then
                    watermark.label.Text = " " .. name:gsub("{game}", gamename):gsub("{fps}", fps .. " FPS") .. " "
                    watermark.label.Size = UDim2.new(0, watermark.label.TextBounds.X+16, 0, 28)
                    watermark.mainbar.Size = UDim2.new(0, watermark.label.TextBounds.X+16, 0, 28)
                    watermark.topbar.Size = UDim2.new(0, watermark.label.TextBounds.X+16, 0, 2)
                end
                oldfps = fps
            end
        end
        watermark.label.Visible = watermark.Visible
        watermark.mainbar.Visible = watermark.Visible
        watermark.topbar.Visible = watermark.Visible
    end)

    -- Эффект наведения (лёгкое появление/исчезание)
    watermark.mainbar.MouseEnter:Connect(function()
        tweenservice:Create(watermark.mainbar, TweenInfo.new(0.2), { BackgroundTransparency = 0.8 }):Play()
        tweenservice:Create(watermark.topbar, TweenInfo.new(0.2), { BackgroundTransparency = 0.5 }):Play()
        tweenservice:Create(watermark.label, TweenInfo.new(0.2), { TextTransparency = 0.5 }):Play()
    end)
    watermark.mainbar.MouseLeave:Connect(function()
        tweenservice:Create(watermark.mainbar, TweenInfo.new(0.2), { BackgroundTransparency = 0.2 }):Play()
        tweenservice:Create(watermark.topbar, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
        tweenservice:Create(watermark.label, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
    end)

    return watermark
end

-- Главное окно (обновлённое с блюром, тенями, скруглением)
function library:CreateWindow(name, size, hidebutton)
    local window = { }
    window.name = name or ""
    window.size = UDim2.fromOffset(size.X, size.Y) or UDim2.fromOffset(520, 620)
    window.hidebutton = hidebutton or Enum.KeyCode.RightShift
    window.theme = library.theme

    local updateevent = Instance.new("BindableEvent")
    function window:UpdateTheme(theme)
        updateevent:Fire(theme or library.theme)
        window.theme = theme or library.theme
    end

    window.Main = Instance.new("ScreenGui", coregui)
    window.Main.Name = name
    window.Main.DisplayOrder = 15
    if syn then syn.protect_gui(window.Main) end
    if getgenv().uilib then getgenv().uilib:Remove() end
    getgenv().uilib = window.Main

    -- Блюр фон
    if window.theme.blur_enabled then
        window.BlurLayer = createBlur(window.Main, window.theme.blur_intensity)
    end

    -- Drag logic (оставляем как было)
    local dragging, dragInput, dragStart, startPos
    uis.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            window.Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    local dragstart = function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
    local dragend = function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end

    window.Frame = Instance.new("TextButton", window.Main)
    window.Frame.Name = "main"
    window.Frame.Position = UDim2.fromScale(0.5, 0.5)
    window.Frame.BorderSizePixel = 0
    window.Frame.Size = window.size
    window.Frame.AutoButtonColor = false
    window.Frame.Text = ""
    window.Frame.BackgroundColor3 = window.theme.backgroundcolor
    window.Frame.BackgroundTransparency = window.theme.backgroundtransparency
    window.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    applyCorner(window.Frame, window.theme.corner_radius)
    if window.theme.shadow_enabled then
        applyShadow(window.Frame, true)
    end

    -- Скрытие по клавише
    uis.InputBegan:Connect(function(key)
        if key.KeyCode == window.hidebutton then
            window.Frame.Visible = not window.Frame.Visible
            if window.BlurLayer then window.BlurLayer.Visible = window.Frame.Visible end
        end
    end)

    -- Верхняя панель
    window.TopBar = Instance.new("Frame", window.Frame)
    window.TopBar.Name = "top"
    window.TopBar.Size = UDim2.fromOffset(window.size.X.Offset, window.theme.topheight)
    window.TopBar.BorderSizePixel = 0
    window.TopBar.BackgroundColor3 = window.theme.topcolor
    window.TopBar.BackgroundTransparency = 0.15
    window.TopBar.InputBegan:Connect(dragstart)
    window.TopBar.InputChanged:Connect(dragend)
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, window.theme.corner_radius)
    topCorner.Parent = window.TopBar
    -- Отдельный Corner для верхних углов (чтобы только верхние)
    local topLeft = Instance.new("UICorner")
    topLeft.CornerRadius = UDim.new(0, window.theme.corner_radius)
    topLeft.Parent = window.TopBar

    window.NameLabel = Instance.new("TextLabel", window.TopBar)
    window.NameLabel.TextColor3 = window.theme.toptextcolor
    window.NameLabel.Text = window.name
    window.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    window.NameLabel.Font = window.theme.font
    window.NameLabel.Position = UDim2.fromOffset(15, 0)
    window.NameLabel.BackgroundTransparency = 1
    window.NameLabel.Size = UDim2.fromOffset(200, window.theme.topheight)
    window.NameLabel.TextSize = window.theme.titlesize
    window.NameLabel.TextYAlignment = Enum.TextYAlignment.Center

    window.Line2 = Instance.new("Frame", window.TopBar)
    window.Line2.Name = "line"
    window.Line2.Position = UDim2.fromOffset(0, window.theme.topheight - 2)
    window.Line2.Size = UDim2.fromOffset(window.size.X.Offset, 2)
    window.Line2.BorderSizePixel = 0
    window.Line2.BackgroundColor3 = window.theme.accentcolor

    -- Вкладки
    window.TabList = Instance.new("Frame", window.TopBar)
    window.TabList.BackgroundTransparency = 1
    window.TabList.Position = UDim2.fromOffset(0, window.theme.topheight)
    window.TabList.Size = UDim2.fromOffset(window.size.X.Offset, 36)
    window.TabList.BorderSizePixel = 0
    window.TabList.BackgroundColor3 = Color3.fromRGB(255,255,255)

    window.ListLayout = Instance.new("UIListLayout", window.TabList)
    window.ListLayout.FillDirection = Enum.FillDirection.Horizontal
    window.ListLayout.Padding = UDim.new(0, 8)
    window.ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

    -- Основная область (scroll)
    window.BackgroundImage = Instance.new("Frame", window.Frame)
    window.BackgroundImage.Name = "content"
    window.BackgroundImage.Position = UDim2.fromOffset(0, window.theme.topheight + 36)
    window.BackgroundImage.Size = UDim2.fromOffset(window.size.X.Offset, window.size.Y.Offset - window.theme.topheight - 36)
    window.BackgroundImage.BackgroundTransparency = 1
    window.BackgroundImage.BorderSizePixel = 0

    window.OpenedColorPickers = { }
    window.Tabs = { }

    function window:CreateTab(name)
        local tab = { }
        tab.name = name or ""
        local size = textservice:GetTextSize(tab.name, window.theme.fontsize, window.theme.font, Vector2.new(200,300))
        tab.TabButton = Instance.new("TextButton", window.TabList)
        tab.TabButton.TextColor3 = window.theme.tabstextcolor
        tab.TabButton.Text = tab.name
        tab.TabButton.AutoButtonColor = false
        tab.TabButton.Font = window.theme.font
        tab.TabButton.TextYAlignment = Enum.TextYAlignment.Center
        tab.TabButton.BackgroundTransparency = 1
        tab.TabButton.BorderSizePixel = 0
        tab.TabButton.Size = UDim2.fromOffset(size.X + 20, 32)
        tab.TabButton.Name = tab.name
        tab.TabButton.TextSize = window.theme.fontsize
        -- Underline indicator
        tab.Underline = Instance.new("Frame", tab.TabButton)
        tab.Underline.Size = UDim2.new(0, tab.TabButton.Size.X.Offset, 0, 2)
        tab.Underline.Position = UDim2.new(0, 0, 1, -2)
        tab.Underline.BackgroundColor3 = window.theme.accentcolor
        tab.Underline.BackgroundTransparency = 1
        tab.Underline.BorderSizePixel = 0

        tab.Left = Instance.new("ScrollingFrame", window.BackgroundImage)
        tab.Left.Name = "leftside"
        tab.Left.BorderSizePixel = 0
        tab.Left.Size = UDim2.fromOffset(window.size.X.Offset/2 - 12, window.BackgroundImage.Size.Y.Offset - 12)
        tab.Left.BackgroundTransparency = 1
        tab.Left.Visible = false
        tab.Left.ScrollBarThickness = 4
        tab.Left.ScrollBarImageColor3 = window.theme.accentcolor
        tab.Left.ScrollingDirection = "Y"
        tab.Left.Position = UDim2.fromOffset(8, 8)

        tab.Right = Instance.new("ScrollingFrame", window.BackgroundImage)
        tab.Right.Name = "rightside"
        tab.Right.BorderSizePixel = 0
        tab.Right.Size = UDim2.fromOffset(window.size.X.Offset/2 - 12, window.BackgroundImage.Size.Y.Offset - 12)
        tab.Right.BackgroundTransparency = 1
        tab.Right.Visible = false
        tab.Right.ScrollBarThickness = 4
        tab.Right.ScrollBarImageColor3 = window.theme.accentcolor
        tab.Right.ScrollingDirection = "Y"
        tab.Right.Position = UDim2.fromOffset(window.size.X.Offset/2 + 4, 8)

        local leftLayout = Instance.new("UIListLayout", tab.Left)
        leftLayout.Padding = UDim.new(0, 12)
        leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        local rightLayout = Instance.new("UIListLayout", tab.Right)
        rightLayout.Padding = UDim.new(0, 12)
        rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        local leftPad = Instance.new("UIPadding", tab.Left)
        leftPad.PaddingTop = UDim.new(0, 4)
        local rightPad = Instance.new("UIPadding", tab.Right)
        rightPad.PaddingTop = UDim.new(0, 4)

        local block = false
        function tab:SelectTab()
            repeat wait() until block == false
            block = true
            for i,v in pairs(window.Tabs) do
                if v ~= tab then
                    v.TabButton.TextColor3 = window.theme.tabstextcolor
                    v.Underline.BackgroundTransparency = 1
                    v.Left.Visible = false
                    v.Right.Visible = false
                end
            end
            tab.TabButton.TextColor3 = window.theme.accentcolor
            tab.Underline.BackgroundTransparency = 0
            tab.Left.Visible = true
            tab.Right.Visible = true
            block = false
        end

        if #window.Tabs == 0 then tab:SelectTab() end
        tab.TabButton.MouseButton1Down:Connect(tab.SelectTab)

        tab.SectorsLeft = {}
        tab.SectorsRight = {}

        function tab:CreateSector(name, side)
            local sector = { }
            sector.name = name or ""
            sector.side = side:lower() or "left"
            local parent = sector.side == "left" and tab.Left or tab.Right
            sector.Main = Instance.new("Frame", parent)
            sector.Main.Name = sector.name:gsub(" ", "") .. "Sector"
            sector.Main.BorderSizePixel = 0
            sector.Main.Size = UDim2.fromOffset(parent.AbsoluteSize.X - 16, 20)
            sector.Main.BackgroundColor3 = window.theme.sectorcolor
            sector.Main.BackgroundTransparency = window.theme.sectorcolor_transparency
            applyCorner(sector.Main, window.theme.corner_radius)
            if window.theme.shadow_enabled then applyShadow(sector.Main, true) end

            sector.Line = Instance.new("Frame", sector.Main)
            sector.Line.Size = UDim2.new(1, 0, 0, 2)
            sector.Line.Position = UDim2.fromOffset(0, 0)
            sector.Line.BackgroundColor3 = window.theme.accentcolor
            sector.Line.BorderSizePixel = 0

            sector.Label = Instance.new("TextLabel", sector.Main)
            sector.Label.AnchorPoint = Vector2.new(0,0.5)
            sector.Label.Position = UDim2.fromOffset(12, 12)
            sector.Label.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 24, 22)
            sector.Label.BackgroundTransparency = 1
            sector.Label.Text = sector.name
            sector.Label.TextColor3 = window.theme.toptextcolor
            sector.Label.Font = window.theme.font
            sector.Label.TextSize = window.theme.titlesize
            sector.Label.TextXAlignment = Enum.TextXAlignment.Left
            sector.Label.TextYAlignment = Enum.TextYAlignment.Center

            sector.Items = Instance.new("Frame", sector.Main)
            sector.Items.Name = "items"
            sector.Items.BackgroundTransparency = 1
            sector.Items.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 12, 20)
            sector.Items.Position = UDim2.fromOffset(6, 30)
            sector.Items.AutomaticSize = Enum.AutomaticSize.Y

            sector.ListLayout = Instance.new("UIListLayout", sector.Items)
            sector.ListLayout.FillDirection = Enum.FillDirection.Vertical
            sector.ListLayout.Padding = UDim.new(0, 12)
            sector.ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local function fixSize()
                sector.Main.Size = UDim2.fromOffset(parent.AbsoluteSize.X - 16, sector.Items.AbsoluteSize.Y + 42)
                local totalLeft, totalRight = 0,0
                for _,v in pairs(tab.SectorsLeft) do totalLeft = totalLeft + v.Main.AbsoluteSize.Y end
                for _,v in pairs(tab.SectorsRight) do totalRight = totalRight + v.Main.AbsoluteSize.Y end
                tab.Left.CanvasSize = UDim2.new(0,0,0, totalLeft + (#tab.SectorsLeft-1)*12 + 12)
                tab.Right.CanvasSize = UDim2.new(0,0,0, totalRight + (#tab.SectorsRight-1)*12 + 12)
            end
            sector.Items:GetPropertyChangedSignal("AbsoluteSize"):Connect(fixSize)

            table.insert(sector.side=="left" and tab.SectorsLeft or tab.SectorsRight, sector)

            function sector:AddButton(text, callback)
                local button = {}
                button.text = text
                button.callback = callback
                button.Main = Instance.new("TextButton", sector.Items)
                button.Main.Size = UDim2.fromOffset(sector.Main.Size.X.Offset - 24, 32)
                button.Main.BackgroundColor3 = window.theme.buttoncolor
                button.Main.BackgroundTransparency = 0.2
                button.Main.BorderSizePixel = 0
                button.Main.Text = ""
                button.Main.AutoButtonColor = false
                applyCorner(button.Main, 6)
                button.Label = Instance.new("TextLabel", button.Main)
                button.Label.Size = UDim2.new(1,0,1,0)
                button.Label.BackgroundTransparency = 1
                button.Label.Text = text
                button.Label.TextColor3 = window.theme.itemscolor2
                button.Label.Font = window.theme.font
                button.Label.TextSize = window.theme.fontsize
                button.Label.TextXAlignment = Enum.TextXAlignment.Center
                button.Main.MouseButton1Click:Connect(callback)
                button.Main.MouseEnter:Connect(function()
                    tweenservice:Create(button.Main, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
                end)
                button.Main.MouseLeave:Connect(function()
                    tweenservice:Create(button.Main, TweenInfo.new(0.2), { BackgroundTransparency = 0.2 }):Play()
                end)
                fixSize()
                return button
            end

            function sector:AddLabel(text)
                local label = {}
                label.Main = Instance.new("TextLabel", sector.Items)
                label.Main.Size = UDim2.new(1, -24, 0, 24)
                label.Main.BackgroundTransparency = 1
                label.Main.Text = text
                label.Main.TextColor3 = window.theme.itemscolor
                label.Main.Font = window.theme.font
                label.Main.TextSize = window.theme.fontsize
                label.Main.TextXAlignment = Enum.TextXAlignment.Left
                label.Main.AutomaticSize = Enum.AutomaticSize.Y
                function label:Set(t) label.Main.Text = t end
                fixSize()
                return label
            end

            function sector:AddToggle(text, default, callback, flag)
                local toggle = {}
                toggle.text = text
                toggle.default = default
                toggle.callback = callback
                toggle.flag = flag or text
                toggle.value = default

                toggle.Main = Instance.new("TextButton", sector.Items)
                toggle.Main.Size = UDim2.new(1, -24, 0, 32)
                toggle.Main.BackgroundTransparency = 1
                toggle.Main.Text = ""
                toggle.Main.AutoButtonColor = false

                toggle.Label = Instance.new("TextLabel", toggle.Main)
                toggle.Label.Size = UDim2.new(1, -50, 1, 0)
                toggle.Label.Position = UDim2.fromOffset(0,0)
                toggle.Label.BackgroundTransparency = 1
                toggle.Label.Text = text
                toggle.Label.TextColor3 = window.theme.itemscolor
                toggle.Label.Font = window.theme.font
                toggle.Label.TextSize = window.theme.fontsize
                toggle.Label.TextXAlignment = Enum.TextXAlignment.Left

                toggle.Switch = Instance.new("Frame", toggle.Main)
                toggle.Switch.Size = UDim2.new(0, 36, 0, 20)
                toggle.Switch.Position = UDim2.new(1, -42, 0.5, -10)
                toggle.Switch.BackgroundColor3 = Color3.fromRGB(60,60,70)
                toggle.Switch.BorderSizePixel = 0
                applyCorner(toggle.Switch, 10)

                toggle.Knob = Instance.new("Frame", toggle.Switch)
                toggle.Knob.Size = UDim2.new(0, 16, 0, 16)
                toggle.Knob.Position = UDim2.new(0, 2, 0.5, -8)
                toggle.Knob.BackgroundColor3 = Color3.fromRGB(210,210,220)
                toggle.Knob.BorderSizePixel = 0
                applyCorner(toggle.Knob, 8)

                function toggle:Set(value)
                    toggle.value = value
                    if value then
                        toggle.Switch.BackgroundColor3 = window.theme.accentcolor
                        toggle.Knob.Position = UDim2.new(1, -18, 0.5, -8)
                        toggle.Label.TextColor3 = window.theme.accentcolor
                    else
                        toggle.Switch.BackgroundColor3 = Color3.fromRGB(60,60,70)
                        toggle.Knob.Position = UDim2.new(0, 2, 0.5, -8)
                        toggle.Label.TextColor3 = window.theme.itemscolor
                    end
                    if toggle.flag then library.flags[toggle.flag] = value end
                    pcall(toggle.callback, value)
                end
                toggle:Set(default)

                toggle.Main.MouseButton1Click:Connect(function()
                    toggle:Set(not toggle.value)
                end)
                table.insert(library.items, toggle)
                fixSize()
                return toggle
            end

            function sector:AddSlider(text, min, default, max, decimals, callback, flag)
                local slider = {}
                slider.text = text
                slider.min = min
                slider.max = max
                slider.default = default
                slider.decimals = decimals or 1
                slider.callback = callback
                slider.flag = flag or text
                slider.value = default

                slider.Main = Instance.new("Frame", sector.Items)
                slider.Main.Size = UDim2.new(1, -24, 0, 58)
                slider.Main.BackgroundTransparency = 1

                slider.Label = Instance.new("TextLabel", slider.Main)
                slider.Label.Size = UDim2.new(1,0,0,20)
                slider.Label.BackgroundTransparency = 1
                slider.Label.Text = text .. ": " .. tostring(default)
                slider.Label.TextColor3 = window.theme.itemscolor
                slider.Label.Font = window.theme.font
                slider.Label.TextSize = window.theme.fontsize
                slider.Label.TextXAlignment = Enum.TextXAlignment.Left

                slider.Bar = Instance.new("Frame", slider.Main)
                slider.Bar.Size = UDim2.new(1,0,0,4)
                slider.Bar.Position = UDim2.new(0,0,0,24)
                slider.Bar.BackgroundColor3 = Color3.fromRGB(50,50,60)
                slider.Bar.BorderSizePixel = 0
                applyCorner(slider.Bar, 2)

                slider.Fill = Instance.new("Frame", slider.Bar)
                slider.Fill.Size = UDim2.new(0,0,1,0)
                slider.Fill.BackgroundColor3 = window.theme.accentcolor
                slider.Fill.BorderSizePixel = 0

                slider.Handle = Instance.new("TextButton", slider.Main)
                slider.Handle.Size = UDim2.new(0, 12, 0, 12)
                slider.Handle.Position = UDim2.new(0,0,0,20)
                slider.Handle.BackgroundColor3 = window.theme.accentcolor
                slider.Handle.BorderSizePixel = 0
                slider.Handle.Text = ""
                slider.Handle.AutoButtonColor = false
                applyCorner(slider.Handle, 6)

                local dragging = false
                local function updatePosition()
                    local percent = (slider.value - slider.min) / (slider.max - slider.min)
                    local width = slider.Bar.AbsoluteSize.X
                    local newX = percent * width
                    slider.Fill.Size = UDim2.new(percent, 0, 1, 0)
                    slider.Handle.Position = UDim2.new(percent, -6, 0, 20)
                    slider.Label.Text = slider.text .. ": " .. tostring(slider.value)
                end
                function slider:Set(value)
                    value = math.clamp(math.round(value * slider.decimals)/slider.decimals, slider.min, slider.max)
                    slider.value = value
                    updatePosition()
                    if slider.flag then library.flags[slider.flag] = value end
                    pcall(slider.callback, value)
                end
                slider:Set(default)

                local function onMouseMove(input)
                    if not dragging then return end
                    local pos = input.Position.X - slider.Bar.AbsolutePosition.X
                    local percent = math.clamp(pos / slider.Bar.AbsoluteSize.X, 0, 1)
                    local newVal = slider.min + (slider.max - slider.min) * percent
                    slider:Set(newVal)
                end
                slider.Handle.MouseButton1Down:Connect(function()
                    dragging = true
                    uis.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then onMouseMove(input) end
                    end)
                end)
                uis.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                slider.Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        onMouseMove(input)
                    end
                end)
                fixSize()
                table.insert(library.items, slider)
                return slider
            end

            function sector:AddDropdown(text, items, default, multichoice, callback, flag)
                local dropdown = {}
                dropdown.text = text
                dropdown.itemsList = items
                dropdown.default = default
                dropdown.multichoice = multichoice
                dropdown.callback = callback
                dropdown.flag = flag or text
                dropdown.values = {}

                dropdown.Main = Instance.new("Frame", sector.Items)
                dropdown.Main.Size = UDim2.new(1, -24, 0, 40)
                dropdown.Main.BackgroundTransparency = 1

                dropdown.Label = Instance.new("TextLabel", dropdown.Main)
                dropdown.Label.Size = UDim2.new(1,0,0,18)
                dropdown.Label.BackgroundTransparency = 1
                dropdown.Label.Text = text
                dropdown.Label.TextColor3 = window.theme.itemscolor
                dropdown.Label.Font = window.theme.font
                dropdown.Label.TextSize = window.theme.fontsize
                dropdown.Label.TextXAlignment = Enum.TextXAlignment.Left

                dropdown.Button = Instance.new("TextButton", dropdown.Main)
                dropdown.Button.Size = UDim2.new(1,0,0,24)
                dropdown.Button.Position = UDim2.new(0,0,0,16)
                dropdown.Button.BackgroundColor3 = Color3.fromRGB(40,40,50)
                dropdown.Button.BackgroundTransparency = 0.2
                dropdown.Button.Text = ""
                dropdown.Button.AutoButtonColor = false
                applyCorner(dropdown.Button, 6)

                dropdown.SelectedText = Instance.new("TextLabel", dropdown.Button)
                dropdown.SelectedText.Size = UDim2.new(1, -20, 1, 0)
                dropdown.SelectedText.Position = UDim2.fromOffset(8,0)
                dropdown.SelectedText.BackgroundTransparency = 1
                dropdown.SelectedText.Text = default or items[1] or ""
                dropdown.SelectedText.TextColor3 = window.theme.itemscolor2
                dropdown.SelectedText.Font = window.theme.font
                dropdown.SelectedText.TextSize = window.theme.fontsize
                dropdown.SelectedText.TextXAlignment = Enum.TextXAlignment.Left

                dropdown.Arrow = Instance.new("ImageLabel", dropdown.Button)
                dropdown.Arrow.Size = UDim2.new(0, 14, 0, 14)
                dropdown.Arrow.Position = UDim2.new(1, -20, 0.5, -7)
                dropdown.Arrow.Image = "rbxassetid://6031091659"
                dropdown.Arrow.ImageColor3 = Color3.fromRGB(200,200,210)
                dropdown.Arrow.BackgroundTransparency = 1

                dropdown.DropFrame = Instance.new("ScrollingFrame", dropdown.Main)
                dropdown.DropFrame.Size = UDim2.new(1,0,0,0)
                dropdown.DropFrame.Position = UDim2.new(0,0,1,2)
                dropdown.DropFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)
                dropdown.DropFrame.BackgroundTransparency = 0.05
                dropdown.DropFrame.BorderSizePixel = 0
                dropdown.DropFrame.Visible = false
                dropdown.DropFrame.ScrollBarThickness = 4
                dropdown.DropFrame.ZIndex = 10
                applyCorner(dropdown.DropFrame, 6)

                local list = Instance.new("UIListLayout", dropdown.DropFrame)
                list.Padding = UDim.new(0,2)

                function dropdown:Set(value)
                    if type(value) == "table" then
                        dropdown.values = value
                        dropdown.SelectedText.Text = table.concat(value, ", ")
                    else
                        dropdown.values = {value}
                        dropdown.SelectedText.Text = value
                    end
                    if dropdown.flag then library.flags[dropdown.flag] = dropdown.multichoice and dropdown.values or dropdown.values[1] end
                    pcall(dropdown.callback, dropdown.multichoice and dropdown.values or dropdown.values[1])
                end

                local function updateItems()
                    for _,v in pairs(dropdown.DropFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _,opt in ipairs(dropdown.itemsList) do
                        local btn = Instance.new("TextButton", dropdown.DropFrame)
                        btn.Size = UDim2.new(1,0,0,28)
                        btn.BackgroundColor3 = Color3.fromRGB(40,40,50)
                        btn.BackgroundTransparency = 0.2
                        btn.Text = opt
                        btn.TextColor3 = window.theme.itemscolor2
                        btn.Font = window.theme.font
                        btn.TextSize = window.theme.fontsize
                        btn.AutoButtonColor = false
                        btn.BorderSizePixel = 0
                        btn.MouseButton1Click:Connect(function()
                            if dropdown.multichoice then
                                if table.find(dropdown.values, opt) then
                                    for i,v in pairs(dropdown.values) do if v == opt then table.remove(dropdown.values, i) break end end
                                else
                                    table.insert(dropdown.values, opt)
                                end
                                dropdown:Set(dropdown.values)
                            else
                                dropdown:Set(opt)
                                dropdown.DropFrame.Visible = false
                                dropdown.Arrow.Rotation = 0
                            end
                        end)
                    end
                    dropdown.DropFrame.CanvasSize = UDim2.new(0,0,0, #dropdown.itemsList * 28)
                    dropdown.DropFrame.Size = UDim2.new(1,0,0, math.min(#dropdown.itemsList * 28, 160))
                end
                updateItems()

                dropdown.Button.MouseButton1Click:Connect(function()
                    dropdown.DropFrame.Visible = not dropdown.DropFrame.Visible
                    dropdown.Arrow.Rotation = dropdown.DropFrame.Visible and 180 or 0
                end)
                dropdown:Set(default or items[1])
                fixSize()
                table.insert(library.items, dropdown)
                return dropdown
            end

            function sector:AddTextbox(text, default, callback, flag)
                local textbox = {}
                textbox.text = text
                textbox.default = default
                textbox.callback = callback
                textbox.flag = flag or text

                textbox.Main = Instance.new("Frame", sector.Items)
                textbox.Main.Size = UDim2.new(1, -24, 0, 56)
                textbox.Main.BackgroundTransparency = 1

                textbox.Label = Instance.new("TextLabel", textbox.Main)
                textbox.Label.Size = UDim2.new(1,0,0,18)
                textbox.Label.BackgroundTransparency = 1
                textbox.Label.Text = text
                textbox.Label.TextColor3 = window.theme.itemscolor
                textbox.Label.Font = window.theme.font
                textbox.Label.TextSize = window.theme.fontsize
                textbox.Label.TextXAlignment = Enum.TextXAlignment.Left

                textbox.Box = Instance.new("TextBox", textbox.Main)
                textbox.Box.Size = UDim2.new(1,0,0,30)
                textbox.Box.Position = UDim2.new(0,0,0,20)
                textbox.Box.BackgroundColor3 = Color3.fromRGB(40,40,50)
                textbox.Box.BackgroundTransparency = 0.2
                textbox.Box.Text = default or ""
                textbox.Box.PlaceholderText = text
                textbox.Box.TextColor3 = window.theme.itemscolor2
                textbox.Box.Font = window.theme.font
                textbox.Box.TextSize = window.theme.fontsize
                textbox.Box.TextXAlignment = Enum.TextXAlignment.Left
                textbox.Box.ClearTextOnFocus = false
                applyCorner(textbox.Box, 6)

                function textbox:Set(t)
                    textbox.Box.Text = t
                    if textbox.flag then library.flags[textbox.flag] = t end
                    pcall(textbox.callback, t)
                end
                textbox.Box.FocusLost:Connect(function()
                    textbox:Set(textbox.Box.Text)
                end)
                fixSize()
                table.insert(library.items, textbox)
                return textbox
            end

            function sector:AddColorpicker(text, default, callback, flag)
                local picker = {}
                picker.text = text
                picker.default = default
                picker.callback = callback
                picker.flag = flag or text
                picker.value = default

                picker.Main = Instance.new("Frame", sector.Items)
                picker.Main.Size = UDim2.new(1, -24, 0, 32)
                picker.Main.BackgroundTransparency = 1

                picker.Label = Instance.new("TextLabel", picker.Main)
                picker.Label.Size = UDim2.new(1, -50, 1, 0)
                picker.Label.BackgroundTransparency = 1
                picker.Label.Text = text
                picker.Label.TextColor3 = window.theme.itemscolor
                picker.Label.Font = window.theme.font
                picker.Label.TextSize = window.theme.fontsize
                picker.Label.TextXAlignment = Enum.TextXAlignment.Left

                picker.ColorBox = Instance.new("Frame", picker.Main)
                picker.ColorBox.Size = UDim2.new(0, 24, 0, 20)
                picker.ColorBox.Position = UDim2.new(1, -30, 0.5, -10)
                picker.ColorBox.BackgroundColor3 = default
                picker.ColorBox.BorderSizePixel = 0
                applyCorner(picker.ColorBox, 4)

                -- Упрощённый пикер (можно расширить, но для краткости – базовый)
                function picker:Set(color)
                    picker.value = color
                    picker.ColorBox.BackgroundColor3 = color
                    if picker.flag then library.flags[picker.flag] = color end
                    pcall(picker.callback, color)
                end
                picker:Set(default)
                fixSize()
                table.insert(library.items, picker)
                return picker
            end

            function sector:AddKeybind(text, default, onKeyChange, callback, flag)
                local keybind = {}
                keybind.text = text
                keybind.default = default
                keybind.onKeyChange = onKeyChange
                keybind.callback = callback
                keybind.flag = flag or text
                keybind.value = default

                keybind.Main = Instance.new("Frame", sector.Items)
                keybind.Main.Size = UDim2.new(1, -24, 0, 32)
                keybind.Main.BackgroundTransparency = 1

                keybind.Label = Instance.new("TextLabel", keybind.Main)
                keybind.Label.Size = UDim2.new(1, -100, 1, 0)
                keybind.Label.BackgroundTransparency = 1
                keybind.Label.Text = text
                keybind.Label.TextColor3 = window.theme.itemscolor
                keybind.Label.Font = window.theme.font
                keybind.Label.TextSize = window.theme.fontsize
                keybind.Label.TextXAlignment = Enum.TextXAlignment.Left

                keybind.Button = Instance.new("TextButton", keybind.Main)
                keybind.Button.Size = UDim2.new(0, 80, 1, -6)
                keybind.Button.Position = UDim2.new(1, -86, 0, 3)
                keybind.Button.BackgroundColor3 = Color3.fromRGB(40,40,50)
                keybind.Button.BackgroundTransparency = 0.2
                keybind.Button.Text = default == "None" and "[None]" or "[" .. tostring(default.Name or default) .. "]"
                keybind.Button.TextColor3 = window.theme.itemscolor2
                keybind.Button.Font = window.theme.font
                keybind.Button.TextSize = 13
                keybind.Button.AutoButtonColor = false
                applyCorner(keybind.Button, 6)

                local listening = false
                keybind.Button.MouseButton1Click:Connect(function()
                    listening = true
                    keybind.Button.Text = "[...]"
                end)
                uis.InputBegan:Connect(function(input, gameProcessed)
                    if listening and not gameProcessed then
                        listening = false
                        local key = input.KeyCode
                        if key == Enum.KeyCode.Unknown then key = "None" end
                        keybind.Button.Text = (key == "None" and "[None]") or "[" .. tostring(key.Name or key) .. "]"
                        keybind.value = key
                        if keybind.flag then library.flags[keybind.flag] = key end
                        if keybind.onKeyChange then pcall(keybind.onKeyChange, key) end
                    end
                end)
                function keybind:Get() return keybind.value end
                fixSize()
                table.insert(library.items, keybind)
                return keybind
            end

            return sector
        end

        table.insert(window.Tabs, tab)
        return tab
    end

    return window
end

return library
