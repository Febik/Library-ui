-- DOLLARWARE UI LIBRARY
-- MODIFIED BY ASSISTANT
-- Added: larger default windows, bottom-edge resizing, improved visuals, dropdown & multidropdown

local inputService = game:GetService('UserInputService')
local renderService = game:GetService('RunService')
local tweenService = game:GetService('TweenService')
local guiService = game:GetService('GuiService')

-- tween(object, {Property = 'value'}, 0.2, 1)
local tween
do
    local styleEnum = Enum.EasingStyle
    local dirEnum = Enum.EasingDirection
    
    local direction = dirEnum.Out
    local styles = {styleEnum.Exponential, styleEnum.Linear}
    
    function tween(object, shit, duration, style) 
        local tweenInfo = TweenInfo.new(duration, styles[style], direction)
        local tween = tweenService:Create(object, tweenInfo, shit)
        tween:Play()
        return tween 
    end
end

-- ui config
local args = {...}
local theme
local rounding
local animSpeed = 1e-12

-- theme 
do
    if (#args > 0 and typeof(args[1]) == 'table') then
        local settings = args[1]
        theme = settings.theme
        rounding = settings.rounding
        if (settings.smoothDragging == nil) then 
            settings.smoothDragging = true 
        end
        animSpeed = settings.smoothDragging and 1e-12 or 0
        if (typeof(theme) == 'string') then
            if (theme == 'cherry') then          -- red
                theme = {
                    Primary = Color3.fromRGB(249, 22, 52);
                    Secondary = Color3.fromRGB(247, 22, 149);
                    Window1 = Color3.fromRGB(11, 11, 11);
                    Window2 = Color3.fromRGB(5, 5, 5);
                    Window3 = Color3.fromRGB(8, 8, 8);
                    Button1 = Color3.fromRGB(12, 12, 12);
                    Button2 = Color3.fromRGB(15, 15, 15);
                    Button3 = Color3.fromRGB(21, 21, 21);
                    Button4 = Color3.fromRGB(24, 24, 24);
                    Stroke = Color3.fromRGB(30, 30, 30);
                    StrokeHover = Color3.fromRGB(83, 23, 31);
                    Inset1 = Color3.fromRGB(3, 3, 3);
                    Inset2 = Color3.fromRGB(1, 1, 1);
                    Inset3 = Color3.fromRGB(2, 2, 2);
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(164, 164, 164);
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(200, 200, 200);
                }
            elseif (theme == 'orange') then
                theme = {
                    Primary = Color3.fromRGB(244, 148, 22);
                    Secondary = Color3.fromRGB(247, 37, 22);
                    Window1 = Color3.fromRGB(20, 20, 22);
                    Window2 = Color3.fromRGB(10, 10, 12);
                    Window3 = Color3.fromRGB(15, 15, 17);
                    Button1 = Color3.fromRGB(18, 18, 20);
                    Button2 = Color3.fromRGB(20, 20, 22);
                    Button3 = Color3.fromRGB(28, 28, 30);
                    Button4 = Color3.fromRGB(30, 30, 32);
                    Stroke = Color3.fromRGB(60, 60, 60);
                    StrokeHover = Color3.fromRGB(110, 110, 110);
                    Inset1 = Color3.fromRGB(10, 10, 12);
                    Inset2 = Color3.fromRGB(0, 0, 2);
                    Inset3 = Color3.fromRGB(5, 5, 7);
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(192, 192, 192);
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'lemon') then
                theme = {
                    Primary = Color3.fromRGB(220, 255, 66);
                    Secondary = Color3.fromRGB(232, 173, 25);
                    Window1 = Color3.fromRGB(30, 30, 30);
                    Window2 = Color3.fromRGB(20, 20, 20);
                    Window3 = Color3.fromRGB(25, 25, 25);
                    Button1 = Color3.fromRGB(35, 35, 35);
                    Button2 = Color3.fromRGB(40, 40, 40);
                    Button3 = Color3.fromRGB(50, 50, 50);
                    Button4 = Color3.fromRGB(55, 55, 55);
                    Stroke = Color3.fromRGB(55, 55, 55);
                    StrokeHover = Color3.fromRGB(80, 80, 80);
                    Inset1 = Color3.fromRGB(18, 18, 18);
                    Inset2 = Color3.fromRGB(8, 8, 8);
                    Inset3 = Color3.fromRGB(13, 13, 13);
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(192, 192, 192);
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'lime') then
                theme = {
                    Primary = Color3.fromRGB(33, 255, 120);
                    Secondary = Color3.fromRGB(120, 255, 33);
                    Window1 = Color3.fromRGB(30, 30, 32);
                    Window2 = Color3.fromRGB(24, 24, 26);
                    Window3 = Color3.fromRGB(28, 28, 30);
                    Button1 = Color3.fromRGB(36, 36, 38);
                    Button2 = Color3.fromRGB(40, 40, 42);
                    Button3 = Color3.fromRGB(46, 46, 48);
                    Button4 = Color3.fromRGB(50, 50, 52);
                    Stroke = Color3.fromRGB(60, 60, 60);
                    StrokeHover = Color3.fromRGB(110, 110, 110);
                    Inset1 = Color3.fromRGB(20, 20, 22);
                    Inset2 = Color3.fromRGB(14, 14, 16);
                    Inset3 = Color3.fromRGB(18, 18, 20);
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(192, 192, 192);
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'raspberry') then
                theme = {
                    Primary = Color3.fromRGB(0, 190, 255);
                    Secondary = Color3.fromRGB(0, 255, 190);
                    Window1 = Color3.fromRGB(25, 25, 27);
                    Window2 = Color3.fromRGB(19, 19, 21);
                    Window3 = Color3.fromRGB(23, 23, 25);
                    Button1 = Color3.fromRGB(24, 24, 26);
                    Button2 = Color3.fromRGB(28, 28, 30);
                    Button3 = Color3.fromRGB(34, 40, 42);
                    Button4 = Color3.fromRGB(38, 44, 46);
                    Stroke = Color3.fromRGB(60, 60, 60);
                    StrokeHover = Color3.fromRGB(110, 110, 110);
                    Inset1 = Color3.fromRGB(20, 20, 22);
                    Inset2 = Color3.fromRGB(14, 14, 16);
                    Inset3 = Color3.fromRGB(18, 18, 20);
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(192, 192, 192);
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'blueberry') then
                theme = {
                    Primary = Color3.fromRGB(91, 77, 249);
                    Secondary = Color3.fromRGB(130, 76, 247);
                    Window1 = Color3.fromRGB(20, 20, 23);
                    Window2 = Color3.fromRGB(12, 12, 15);
                    Window3 = Color3.fromRGB(15, 15, 18);
                    Button1 = Color3.fromRGB(18, 18, 21);
                    Button2 = Color3.fromRGB(21, 21, 24);
                    Button3 = Color3.fromRGB(38, 38, 41);
                    Button4 = Color3.fromRGB(41, 41, 44);
                    Stroke = Color3.fromRGB(50, 50, 53);
                    StrokeHover = Color3.fromRGB(60, 60, 63);
                    Inset1 = Color3.fromRGB(15, 15, 18);
                    Inset2 = Color3.fromRGB(7, 7, 10);
                    Inset3 = Color3.fromRGB(13, 13, 16);
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(168, 168, 168);
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'grape') then
                theme = {
                    Primary = Color3.fromRGB(134, 53, 255);
                    Secondary = Color3.fromRGB(211, 53, 255);
                    Window1 = Color3.fromRGB(20, 20, 20);
                    Window2 = Color3.fromRGB(10, 10, 10);
                    Window3 = Color3.fromRGB(15, 15, 15);
                    Button1 = Color3.fromRGB(15, 15, 15);
                    Button2 = Color3.fromRGB(20, 20, 20);
                    Button3 = Color3.fromRGB(35, 35, 35);
                    Button4 = Color3.fromRGB(40, 40, 40);
                    Stroke = Color3.fromRGB(34, 34, 34);
                    StrokeHover = Color3.fromRGB(89, 49, 150);
                    Inset1 = Color3.fromRGB(5, 5, 5);
                    Inset2 = Color3.fromRGB(0, 0, 0);
                    Inset3 = Color3.fromRGB(3, 3, 3);
                    TextPrimary = Color3.fromRGB(255, 255, 255);
                    TextStroke = Color3.fromRGB(0, 0, 0);
                    TextDim = Color3.fromRGB(74, 42, 122);
                    ControlGradient1 = Color3.fromRGB(255, 255, 255);
                    ControlGradient2 = Color3.fromRGB(192, 192, 192);
                }
            elseif (theme == 'watermelon') then
                theme = nil
            end
        end
    end
    
    if (rounding == nil) then
        rounding = true 
    end
    if (typeof(theme) ~= 'table') then
        theme = {
            Primary = Color3.fromRGB(38, 233, 195);
            Secondary = Color3.fromRGB(233, 38, 115);
            Window1 = Color3.fromRGB(30, 30, 35);
            Window2 = Color3.fromRGB(20, 20, 25);
            Window3 = Color3.fromRGB(25, 25, 30);
            Button1 = Color3.fromRGB(35, 35, 40);
            Button2 = Color3.fromRGB(45, 45, 50);
            Button3 = Color3.fromRGB(65, 65, 70);
            Button4 = Color3.fromRGB(75, 75, 80);
            Stroke = Color3.fromRGB(50, 50, 55);
            StrokeHover = Color3.fromRGB(70, 70, 75);
            Inset1 = Color3.fromRGB(20, 20, 25);
            Inset2 = Color3.fromRGB(10, 10, 15);
            Inset3 = Color3.fromRGB(15, 15, 20);
            TextPrimary = Color3.fromRGB(255, 255, 255);
            TextStroke = Color3.fromRGB(0, 0, 0);
            TextDim = Color3.fromRGB(164, 164, 164);
            ControlGradient1 = Color3.fromRGB(255, 255, 255);
            ControlGradient2 = Color3.fromRGB(192, 192, 192);
        }
    end
end

-- screen gui 
local uiScreen = Instance.new('ScreenGui') do 
    uiScreen.OnTopOfCoreBlur = true
    uiScreen.DisplayOrder = 9e9
    uiScreen.ZIndexBehavior = 'Global'
    
    local str = ''
    for i = 1, 8 do
        str = str .. utf8.char(math.random(97, 2500))
    end
    uiScreen.Name = str
    str = nil 
    
    if (gethui) then
        uiScreen.Parent = gethui()
    else
        uiScreen.Parent = game:GetService('CoreGui')
    end
    
    local notifContainer = Instance.new('Frame') do 
        notifContainer.Active = false 
        notifContainer.BackgroundTransparency = 1
        notifContainer.Name = '#notif-container'
        notifContainer.Position = UDim2.new(1, -250, 0, -50)
        notifContainer.Size = UDim2.new(0, 200, 1, 0)
        notifContainer.ZIndex = 0
        notifContainer.Parent = uiScreen
    end
end

-- tooltip (unchanged)
local tooltip = {} do 
    do
        local instances = {}
        local main = Instance.new('Frame')
        main.BackgroundColor3 = theme.Window2
        main.BorderColor3 = theme.Inset2
        main.BorderMode = 'Inset'
        main.Name = '#main'
        main.Size = UDim2.fromOffset(140, 60)
        main.Visible = false
        main.ZIndex = 3800
        main.Parent = uiScreen
        do 
            local stroke = Instance.new('UIStroke') do 
                stroke.ApplyStrokeMode = 'Border'
                stroke.Color = theme.Stroke
                stroke.LineJoinMode = 'Round'
                stroke.Thickness = 1 
                stroke.Name = '#stroke'
                stroke.Parent = main
            end
            local shadow = Instance.new('ImageLabel') do 
                shadow.AnchorPoint = Vector2.new(0.5, 0.5)
                shadow.BackgroundTransparency = 1
                shadow.BorderSizePixel = 0 
                shadow.Image = 'rbxassetid://7331400934'
                shadow.ImageColor3 = Color3.fromRGB(0, 0, 5)
                shadow.Name = '#shadow'
                shadow.Position = UDim2.fromScale(0.5, 0.5)
                shadow.ScaleType = 'Slice'
                shadow.Size = UDim2.new(1, 50, 1, 50)
                shadow.SliceCenter = Rect.new(40, 40, 260, 260)
                shadow.SliceScale = 1
                shadow.ZIndex = 3799
                shadow.Parent = main
            end
            local trim = Instance.new('Frame') do 
                trim.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                trim.BackgroundTransparency = 0
                trim.BorderSizePixel = 0 
                trim.Name = '#trim'
                trim.Position = UDim2.fromOffset(0, -2)
                trim.Size = UDim2.new(1, 0, 0, 1)
                trim.ZIndex = 3805
                trim.Parent = main
                local gradient = Instance.new('UIGradient') do 
                    gradient.Color = ColorSequence.new(theme.Primary, theme.Secondary)
                    gradient.Enabled = true
                    gradient.Name = '#gradient'
                    gradient.Rotation = 0
                    gradient.Parent = trim
                end
            end
            local titleBar = Instance.new('Frame') do 
                titleBar.BackgroundColor3 = theme.Window3
                titleBar.BackgroundTransparency = 0 
                titleBar.BorderColor3 = theme.Inset3
                titleBar.BorderSizePixel = 1
                titleBar.BorderMode = 'Inset'
                titleBar.Name = '#title-bar'
                titleBar.Size = UDim2.new(1, 2, 0, 16)
                titleBar.Position = UDim2.fromOffset(-1, 0)
                titleBar.Visible = true
                titleBar.ZIndex = 3801
                titleBar.Parent = main
                local stroke = Instance.new('UIStroke') do 
                    stroke.ApplyStrokeMode = 'Border'
                    stroke.Color = theme.Stroke
                    stroke.LineJoinMode = 'Round'
                    stroke.Thickness = 1 
                    stroke.Name = '#stroke'
                    stroke.Parent = titleBar
                end
                local title = Instance.new('TextLabel') do 
                    title.BackgroundTransparency = 1
                    title.Font = 'SourceSans'
                    title.Name = '#title'
                    title.RichText = true
                    title.Size = UDim2.fromScale(1, 1)
                    title.Text = 'tooltip'
                    title.TextColor3 = theme.TextPrimary
                    title.TextSize = 14
                    title.TextStrokeColor3 = theme.TextStroke
                    title.TextStrokeTransparency = 0.8
                    title.TextTransparency = 0
                    title.TextWrapped = false
                    title.TextXAlignment = 'Left'
                    title.TextYAlignment = 'Center'
                    title.Visible = true
                    title.ZIndex = 3801
                    title.Parent = titleBar
                    local padding = Instance.new('UIPadding') do 
                        padding.Name = '#padding'
                        padding.PaddingLeft = UDim.new(0, 4)
                        padding.Parent = title
                    end
                    instances.title = title 
                end
            end
            local menu = Instance.new('Frame') do 
                menu.BackgroundColor3 = theme.Window2
                menu.BorderColor3 = theme.Inset2
                menu.BorderMode = 'Inset'
                menu.BorderSizePixel = 1
                menu.ClipsDescendants = true 
                menu.Name = '#menu'
                menu.Position = UDim2.fromOffset(-1, 17)
                menu.Size = UDim2.new(1, 2, 1, -16)
                menu.Visible = true
                menu.ZIndex = 3801
                menu.Parent = main
                local desc = Instance.new('TextLabel') do 
                    desc.BackgroundTransparency = 1
                    desc.Font = 'SourceSans'
                    desc.Name = '#desc'
                    desc.RichText = true
                    desc.Size = UDim2.fromScale(1, 1)
                    desc.Text = 'tooltip description'
                    desc.TextColor3 = theme.TextPrimary
                    desc.TextSize = 14
                    desc.TextStrokeColor3 = theme.TextStroke
                    desc.TextStrokeTransparency = 0.8
                    desc.TextTransparency = 0
                    desc.TextWrapped = true
                    desc.TextXAlignment = 'Left'
                    desc.TextYAlignment = 'Top'
                    desc.Visible = true
                    desc.ZIndex = 3801
                    desc.Parent = menu
                    local padding = Instance.new('UIPadding') do 
                        padding.Name = '#padding'
                        padding.PaddingLeft = UDim.new(0, 4)
                        padding.PaddingTop = UDim.new(0, 2)
                        padding.Parent = desc
                    end
                    instances.desc = desc 
                end
            end
        end
        instances.main = main
        tooltip.instances = instances
    end
    tooltip.handle = nil 
    tooltip.showing = false
    tooltip.update = nil
end

-- hint (unchanged)
local hint = {} do 
    do
        local instances = {}
        local main = Instance.new('Frame')
        main.BackgroundColor3 = theme.Window2
        main.BorderColor3 = theme.Inset2
        main.BorderMode = 'Inset'
        main.Name = '#main'
        main.Size = UDim2.fromOffset(140, 84)
        main.Visible = false
        main.ZIndex = 3900
        main.Parent = uiScreen
        do 
            local stroke = Instance.new('UIStroke') do 
                stroke.ApplyStrokeMode = 'Border'
                stroke.Color = theme.Stroke
                stroke.LineJoinMode = 'Round'
                stroke.Thickness = 1 
                stroke.Name = '#stroke'
                stroke.Parent = main
            end
            local shadow = Instance.new('ImageLabel') do 
                shadow.AnchorPoint = Vector2.new(0.5, 0.5)
                shadow.BackgroundTransparency = 1
                shadow.BorderSizePixel = 0 
                shadow.Image = 'rbxassetid://7331400934'
                shadow.ImageColor3 = Color3.fromRGB(0, 0, 5)
                shadow.Name = '#shadow'
                shadow.Position = UDim2.fromScale(0.5, 0.5)
                shadow.ScaleType = 'Slice'
                shadow.Size = UDim2.new(1, 50, 1, 50)
                shadow.SliceCenter = Rect.new(40, 40, 260, 260)
                shadow.SliceScale = 1
                shadow.ZIndex = 3899
                shadow.Parent = main
            end
            local trim = Instance.new('Frame') do 
                trim.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                trim.BackgroundTransparency = 0
                trim.BorderSizePixel = 0 
                trim.Name = '#trim'
                trim.Position = UDim2.fromOffset(0, -2)
                trim.Size = UDim2.new(1, 0, 0, 1)
                trim.ZIndex = 3905
                trim.Parent = main
                local gradient = Instance.new('UIGradient') do 
                    gradient.Color = ColorSequence.new(theme.Primary, theme.Secondary)
                    gradient.Enabled = true
                    gradient.Name = '#gradient'
                    gradient.Rotation = 0
                    gradient.Parent = trim
                end
            end
            local menu = Instance.new('Frame') do 
                menu.BackgroundColor3 = theme.Window2
                menu.BorderColor3 = theme.Inset2
                menu.BorderMode = 'Inset'
                menu.BorderSizePixel = 1
                menu.ClipsDescendants = true 
                menu.Name = '#menu'
                menu.Position = UDim2.fromOffset(0, 0)
                menu.Size = UDim2.fromScale(1, 1)
                menu.Visible = true
                menu.ZIndex = 3901
                menu.Parent = main
                do
                    local selectionFrame = Instance.new('Frame') do 
                        selectionFrame.BackgroundColor3 = theme.Button2
                        selectionFrame.BorderSizePixel = 0
                        selectionFrame.Name = '#select'
                        selectionFrame.Size = UDim2.new(1, 0, 0, 16)
                        selectionFrame.Visible = true
                        selectionFrame.ZIndex = 3902
                        selectionFrame.Parent = menu
                        instances.optionHighlight = selectionFrame
                    end
                    local hintContainer = Instance.new('ScrollingFrame') do 
                        hintContainer.AutomaticCanvasSize = 'Y'
                        hintContainer.BackgroundTransparency = 1
                        hintContainer.BorderSizePixel = 0
                        hintContainer.Name = '#container'
                        hintContainer.ScrollBarImageTransparency = 1
                        hintContainer.ScrollingEnabled = false 
                        hintContainer.Size = UDim2.fromScale(1, 1)
                        hintContainer.Visible = true
                        hintContainer.ZIndex = 3902
                        hintContainer.Parent = menu
                        do
                            local layout = Instance.new('UIListLayout') do 
                                layout.FillDirection = 'Vertical'
                                layout.HorizontalAlignment = 'Left'
                                layout.SortOrder = 'Name'
                                layout.VerticalAlignment = 'Top'
                                layout.Parent = hintContainer
                            end
                            local hintOption = Instance.new('TextLabel') do 
                                hintOption.BackgroundTransparency = 1
                                hintOption.Name = '#hint'
                                hintOption.RichText = true
                                hintOption.Size = UDim2.new(1, 0, 0, 16)
                                hintOption.Text = 'no suggestions'
                                hintOption.TextColor3 = theme.TextPrimary
                                hintOption.TextSize = 14
                                hintOption.TextStrokeColor3 = theme.TextStroke
                                hintOption.TextStrokeTransparency = 0.8
                                hintOption.TextWrapped = false
                                hintOption.TextXAlignment = 'Left'
                                hintOption.TextYAlignment = 'Center'
                                hintOption.Visible = false
                                hintOption.ZIndex = 3902
                                hintOption.Parent = hintContainer
                                local padding = Instance.new('UIPadding') do 
                                    padding.Name = '#padding'
                                    padding.PaddingLeft = UDim.new(0, 4)
                                    padding.PaddingBottom = UDim.new(0, 2)
                                    padding.Parent = hintOption
                                end
                                instances.hintTemplate = hintOption
                            end
                        end
                    end
                end
            end
        end
        instances.main = main
        hint.instances = instances
    end
    hint.selection = 1
    hint.handle = nil 
    hint.hintCount = 0
    hint.showing = false
    hint.updateCn = nil
    hint.inputCn = nil
    hint.previousHint = ''
    hint.hints = {}
end

local defaultWinPos = UDim2.fromScale(0.6, 0.6)

local ui = {}

-- classes
local elemClasses = {} 
do 
    -- GLOBAL
    do 
        local baseElement = {} do 
            baseElement.__index = baseElement
            baseElement.bindToEvent = function(self, event, callback) 
                self.binds[event] = callback
                return self
            end
            baseElement.fireEvent = function(self, event, ...) 
                local t = self.binds[event]
                if (t) then task.spawn(t, ...) end
                return self
            end
            baseElement.name = '' 
            baseElement.tooltip = nil
            baseElement.setTooltip = function(self, tooltip) 
                self.tooltip = tostring(tooltip)
                return self
            end
            baseElement.showTooltip = function(self) 
                if (self.tooltip) then 
                    tooltip.showing = true
                    tooltip.handle = self
                    local desc, title, main = tooltip.instances.desc, tooltip.instances.title, tooltip.instances.main
                    title.Text = self.name
                    main.Size = UDim2.fromOffset(140, 20)
                    desc.Text = self.tooltip 
                    local c = 0
                    while (true) do 
                        c += 1 
                        main.Size += UDim2.fromOffset(0, 20)
                        if (c > 30) then
                            desc.Text = 'stop fucking spamming the tooltip jesus christ'
                            main.Size = UDim2.fromOffset(140, 60)
                            break
                        end
                        local _ = desc.TextFits
                        if (desc.TextFits == true) then break end 
                    end
                    main.Visible = true
                    tooltip.update = renderService.RenderStepped:Connect(function() 
                        local mpos = inputService:GetMouseLocation()
                        main.Position = UDim2.fromOffset(mpos.X,mpos.Y)
                    end)
                end
                return self
            end
            baseElement.hideTooltip = function(self) 
                if (tooltip.handle == self) then 
                    tooltip.showing = false
                    tooltip.handle = nil
                    tooltip.update:Disconnect()
                    tooltip.instances.main.Visible = false
                end
                return self
            end
        end
        elemClasses.baseElement = baseElement
    end
    -- WINDOW (modified: larger default size, bottom resize handle)
    do
        local window = {} do 
            window.__index = window
            setmetatable(window, elemClasses.baseElement)
            window.class = 'window'
            window.minimized = false
            window.size = UDim2.fromOffset(600, 450) -- bigger default window
            window.icon = nil
            window.minFocused = false
            
            local instances = {} do 
                local mainFrame = Instance.new('Frame') do 
                    mainFrame.BackgroundColor3 = theme.Window2
                    mainFrame.BackgroundTransparency = 0
                    mainFrame.BorderSizePixel = 0
                    mainFrame.Name = '#main_frame'
                    mainFrame.Position = UDim2.fromScale(0.6, 0.6)
                    mainFrame.Size = UDim2.fromOffset(600, 450)
                    mainFrame.Visible = true
                    mainFrame.ZIndex = 5 
                end
                local scale = Instance.new('UIScale') do 
                    scale.Scale = 1 
                    scale.Name = '#scale'
                    scale.Parent = mainFrame
                end
                local backgroundFrame = Instance.new('Frame') do 
                    backgroundFrame.BackgroundTransparency = 0 
                    backgroundFrame.BackgroundColor3 = theme.Window2
                    backgroundFrame.BorderSizePixel = 0 
                    backgroundFrame.Name = '#background'
                    backgroundFrame.Position = UDim2.fromOffset(0, 0)
                    backgroundFrame.Size = UDim2.fromScale(1, 1)
                    backgroundFrame.Visible = true 
                    backgroundFrame.ZIndex = 4
                    backgroundFrame.Parent = mainFrame
                end
                local stroke = Instance.new('UIStroke') do 
                    stroke.ApplyStrokeMode = 'Border'
                    stroke.Color = theme.Stroke
                    stroke.LineJoinMode = 'Round'
                    stroke.Thickness = 1 
                    stroke.Name = '#stroke'
                    stroke.Parent = mainFrame
                end
                local shadow = Instance.new('ImageLabel') do 
                    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
                    shadow.BackgroundTransparency = 1
                    shadow.BorderSizePixel = 0 
                    shadow.Image = 'rbxassetid://7331400934'
                    shadow.ImageColor3 = Color3.fromRGB(0, 0, 5)
                    shadow.Name = '#shadow'
                    shadow.Position = UDim2.fromScale(0.5, 0.5)
                    shadow.ScaleType = 'Slice'
                    shadow.Size = UDim2.new(1, 50, 1, 50)
                    shadow.SliceCenter = Rect.new(40, 40, 260, 260)
                    shadow.SliceScale = 1
                    shadow.ZIndex = 4
                    shadow.Parent = mainFrame
                end
                local trimLine = Instance.new('Frame') do 
                    trimLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    trimLine.BackgroundTransparency = 0
                    trimLine.BorderSizePixel = 0 
                    trimLine.Name = '#trim'
                    trimLine.Position = UDim2.fromOffset(0, -1)
                    trimLine.Size = UDim2.new(1, 0, 0, 1)
                    trimLine.ZIndex = 64
                    trimLine.Parent = mainFrame
                    local gradient = Instance.new('UIGradient') do 
                        gradient.Color = ColorSequence.new(theme.Primary, theme.Secondary)
                        gradient.Enabled = true
                        gradient.Name = '#gradient'
                        gradient.Rotation = 0
                        gradient.Parent = trimLine
                    end
                end
                local titleBar = Instance.new('Frame') do 
                    titleBar.Active = true
                    titleBar.BackgroundColor3 = theme.Window1
                    titleBar.BackgroundTransparency = 0
                    titleBar.BorderColor3 = theme.Inset1
                    titleBar.BorderMode = 'Inset'
                    titleBar.BorderSizePixel = 1
                    titleBar.ClipsDescendants = true
                    titleBar.Name = '#title-bar'
                    titleBar.Selectable = true
                    titleBar.Size = UDim2.new(1, 0, 0, 26)
                    titleBar.ZIndex = 50
                    titleBar.Parent = mainFrame 
                    local stroke = Instance.new('UIStroke') do 
                        stroke.ApplyStrokeMode = 'Border'
                        stroke.Color = theme.Stroke
                        stroke.LineJoinMode = 'Round'
                        stroke.Thickness = 1 
                        stroke.Name = '#stroke'
                        stroke.Parent = titleBar
                    end
                    local fade = Instance.new('Frame') do 
                        fade.BackgroundColor3 = theme.Window1
                        fade.BackgroundTransparency = 1
                        fade.BorderColor3 = theme.Inset1
                        fade.BorderMode = 'Inset'
                        fade.BorderSizePixel = 1
                        fade.Name = '#fade'
                        fade.Size = UDim2.new(1, 4, 1, 4)
                        fade.Position = UDim2.fromOffset(-2, -2)
                        fade.Visible = false
                        fade.ZIndex = 60
                        fade.Parent = titleBar
                    end
                    local buttonClose = Instance.new('TextButton') do 
                        buttonClose.AnchorPoint = Vector2.new(1, 0)
                        buttonClose.AutoButtonColor = false
                        buttonClose.BackgroundColor3 = theme.Button1
                        buttonClose.BorderSizePixel = 0
                        buttonClose.Name = '#button-close'
                        buttonClose.Position = UDim2.new(1, -3, 0, 2)
                        buttonClose.Size = UDim2.fromOffset(20, 20)
                        buttonClose.Visible = true
                        buttonClose.ZIndex = 52 
                        buttonClose.Text = ''
                        buttonClose.Parent = titleBar
                        local round = Instance.new('UICorner') do 
                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                            round.Name = '#round'
                            round.Parent = buttonClose
                        end
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = buttonClose
                        end
                        local icon = Instance.new('ImageLabel') do 
                            icon.Active = false
                            icon.BackgroundTransparency = 1
                            icon.BorderSizePixel = 0
                            icon.Image = 'rbxassetid://9801460300'
                            icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                            icon.Name = '#icon'
                            icon.Position = UDim2.fromOffset(0, 0)
                            icon.Size = UDim2.fromScale(1, 1)
                            icon.Visible = true
                            icon.ZIndex = 52 
                            icon.Parent = buttonClose
                            local gradient = Instance.new('UIGradient') do 
                                gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                gradient.Rotation = 90
                                gradient.Enabled = true
                                gradient.Name = '#gradient'
                                gradient.Parent = icon
                            end
                        end
                    end
                    local buttonMin = Instance.new('TextButton') do 
                        buttonMin.AnchorPoint = Vector2.new(1, 0)
                        buttonMin.AutoButtonColor = false
                        buttonMin.BackgroundColor3 = theme.Button1
                        buttonMin.BorderSizePixel = 0
                        buttonMin.Name = '#button-min'
                        buttonMin.Position = UDim2.new(1, -27, 0, 2)
                        buttonMin.Size = UDim2.fromOffset(20, 20)
                        buttonMin.Visible = true
                        buttonMin.ZIndex = 52 
                        buttonMin.Text = ''
                        buttonMin.Parent = titleBar
                        local round = Instance.new('UICorner') do 
                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                            round.Name = '#round'
                            round.Parent = buttonMin
                        end
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = buttonMin
                        end
                        local icon = Instance.new('ImageLabel') do 
                            icon.Active = false
                            icon.BackgroundTransparency = 1
                            icon.BorderSizePixel = 0
                            icon.Image = 'rbxassetid://9801458532'
                            icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                            icon.Name = '#icon'
                            icon.Position = UDim2.fromOffset(0, 0)
                            icon.Size = UDim2.fromScale(1, 1)
                            icon.Visible = true
                            icon.ZIndex = 52 
                            icon.Parent = buttonMin
                            local gradient = Instance.new('UIGradient') do 
                                gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                gradient.Rotation = 90
                                gradient.Enabled = true
                                gradient.Name = '#gradient'
                                gradient.Parent = icon
                            end
                        end
                    end
                    local icon = Instance.new('ImageLabel') do 
                        icon.BackgroundTransparency = 1
                        icon.BorderSizePixel = 0
                        icon.Image = 'rbxassetid://10152328589'
                        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                        icon.ImageTransparency = 0
                        icon.Name = '#icon'
                        icon.Position = UDim2.fromOffset(2, 1)
                        icon.Size = UDim2.fromOffset(22, 22)
                        icon.Visible = true
                        icon.ZIndex = 51
                        icon.Parent = titleBar
                    end
                    local title = Instance.new('TextLabel') do 
                        title.BackgroundTransparency = 1
                        title.BorderSizePixel = 0
                        title.Font = 'RobotoCondensed'
                        title.Name = '#title'
                        title.Position = UDim2.fromOffset(24, 0)
                        title.RichText = true
                        title.Size = UDim2.new(1, -74, 1, 0)
                        title.Text = 'j'
                        title.TextColor3 = theme.TextPrimary
                        title.TextScaled = false
                        title.TextSize = 17
                        title.TextStrokeColor3 = theme.TextStroke
                        title.TextStrokeTransparency = 0.8
                        title.TextTransparency = 0
                        title.TextXAlignment = 'Left'
                        title.TextYAlignment = 'Center'
                        title.Visible = true
                        title.ZIndex = 52 
                        title.Parent = titleBar
                        local padding = Instance.new('UIPadding') do 
                            padding.PaddingLeft = UDim.new(0, 4)
                            padding.Name = '#padding'
                            padding.Parent = title
                        end
                    end
                end
                local pageRegion = Instance.new('Frame') do 
                    pageRegion.BackgroundColor3 = theme.Window2
                    pageRegion.BackgroundTransparency = 0
                    pageRegion.BorderColor3 = theme.Inset2
                    pageRegion.BorderMode = 'Inset'
                    pageRegion.BorderSizePixel = 1
                    pageRegion.ClipsDescendants = true 
                    pageRegion.Name = '#page-region'
                    pageRegion.Position = UDim2.new(0, 126, 0, 27)
                    pageRegion.Size = UDim2.new(1, -126, 1, -27)
                    pageRegion.Visible = true
                    pageRegion.ZIndex = 30
                    pageRegion.Parent = mainFrame
                end
                local sideBar = Instance.new('Frame') do 
                    sideBar.BackgroundColor3 = theme.Window3
                    sideBar.BackgroundTransparency = 0 
                    sideBar.BorderColor3 = theme.Inset3
                    sideBar.BorderMode = 'Inset'
                    sideBar.BorderSizePixel = 1
                    sideBar.Name = '#sidebar'
                    sideBar.Position = UDim2.fromOffset(0, 27)
                    sideBar.Size = UDim2.new(0, 125, 1, -27)
                    sideBar.Visible = true
                    sideBar.ZIndex = 50
                    sideBar.Parent = mainFrame
                    local stroke = Instance.new('UIStroke') do 
                        stroke.ApplyStrokeMode = 'Border'
                        stroke.Color = theme.Stroke
                        stroke.LineJoinMode = 'Round'
                        stroke.Name = '#stroke'
                        stroke.Thickness = 1 
                        stroke.Parent = sideBar
                    end
                    local menu = Instance.new('ScrollingFrame') do 
                        menu.AutomaticCanvasSize = 'Y'
                        menu.BackgroundTransparency = 1
                        menu.BorderSizePixel = 0
                        menu.BottomImage = 'rbxassetid://9416839567'
                        menu.CanvasSize = UDim2.fromOffset(0, 0)
                        menu.MidImage = 'rbxassetid://9416839567'
                        menu.Name = '#menu'
                        menu.Position = UDim2.fromOffset(1, 1)
                        menu.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
                        menu.ScrollBarImageTransparency = 0.9
                        menu.ScrollBarThickness = 1
                        menu.ScrollingDirection = 'Y'
                        menu.ScrollingEnabled = true
                        menu.Size = UDim2.new(1, -2, 1, -2)
                        menu.TopImage = 'rbxassetid://9416839567'
                        menu.Visible = true
                        menu.ZIndex = 51
                        menu.Parent = sideBar
                        local layout = Instance.new('UIListLayout') do 
                            layout.FillDirection = 'Vertical'
                            layout.HorizontalAlignment = 'Center'
                            layout.Name = '#layout'
                            layout.Padding = UDim.new(0, 6)
                            layout.SortOrder = 'LayoutOrder'
                            layout.VerticalAlignment = 'Top'
                            layout.Parent = menu
                        end
                        local padding = Instance.new('UIPadding') do 
                            padding.Name = '#padding'
                            padding.PaddingTop = UDim.new(0, 5)
                            padding.Parent = menu
                        end
                    end
                end
                -- corner resize handle
                local resizeHandle = Instance.new('ImageLabel') do 
                    resizeHandle.BackgroundTransparency = 1
                    resizeHandle.Image = 'rbxassetid://9995727737'
                    resizeHandle.ImageColor3 = theme.Primary
                    resizeHandle.Name = '#resize-handle'
                    resizeHandle.Position = UDim2.new(1, -10, 1, -10)
                    resizeHandle.Size = UDim2.fromOffset(10, 10)
                    resizeHandle.ZIndex = 34
                    resizeHandle.Parent = mainFrame
                end
                -- bottom resize handle (new)
                local resizeBottom = Instance.new('Frame') do 
                    resizeBottom.BackgroundColor3 = theme.Primary
                    resizeBottom.BackgroundTransparency = 0.75
                    resizeBottom.Name = '#resize-bottom'
                    resizeBottom.Position = UDim2.new(0, 0, 1, -4)
                    resizeBottom.Size = UDim2.new(1, 0, 0, 4)
                    resizeBottom.ZIndex = 34
                    resizeBottom.Visible = true
                    resizeBottom.Parent = mainFrame
                    local round = Instance.new('UICorner') do 
                        round.CornerRadius = UDim.new(0, 2)
                        round.Parent = resizeBottom
                    end
                end
                instances.mainFrame = mainFrame
                instances.resizeBottom = resizeBottom
            end
            window.instances = instances 
            window.signals = {
                buttonClose = {
                    MouseEnter = function(self) 
                        tween(self, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        tween(self['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(self) 
                        tween(self, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        tween(self['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(_, self) 
                        self:destroy()
                    end
                },
                buttonMin = {
                    MouseEnter = function(self, w) 
                        w.minFocused = true
                        if (w.minimized) then
                            tween(self, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                        else
                            tween(self, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        end
                        tween(self['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(self, w) 
                        w.minFocused = false
                        if (w.minimized) then
                            tween(self, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                        else
                            tween(self, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        end
                        tween(self['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(_, self) 
                        self:minimize()
                    end
                }
            }
            
            window.destroy = function(self) 
                if (ui.autoDisableToggles) then 
                    for _, menu in ipairs(self.menus) do 
                        for _, section in ipairs(menu.sections) do 
                            for _, control in ipairs(section.controls) do 
                                if (control.class == 'picker') then
                                    if (control.chromaCon) then 
                                        control.chromaCon:Disconnect()
                                    end
                                    local pwin = control.pickerWindow
                                    if (pwin) then
                                        if (pwin.chromaCon) then 
                                            pwin.chromaCon:Disconnect()
                                        end
                                        pwin:bindToEvent('close',nil)
                                        pwin:destroy()
                                    end
                                elseif (control.class == 'toggle') then 
                                    if (control.toggled) then
                                        control:disable()
                                    end
                                end
                            end
                        end
                    end
                end
                local mainFrame = self.instances.mainFrame
                task.spawn(function()
                    local animCon
                    task.spawn(function() 
                        local backgroundTransparency = {}
                        local scrollBarImageTransparency = {}
                        local imageTransparency = {}
                        local transparency = {}
                        local textTransparency = {}
                        local s = {
                            Frame = {backgroundTransparency}, 
                            ImageButton = {backgroundTransparency, imageTransparency},
                            ImageLabel = {backgroundTransparency, imageTransparency},
                            TextButton = {backgroundTransparency, textTransparency},
                            TextLabel = {backgroundTransparency, textTransparency},
                            TextBox = {backgroundTransparency, textTransparency},
                            ScrollingFrame = {backgroundTransparency, scrollBarImageTransparency},
                            UIStroke = {transparency},
                        }
                        local d = mainFrame:GetDescendants()
                        table.insert(d, mainFrame)
                        for i, v in ipairs(d) do 
                            local a = s[v.ClassName]
                            if (a) then
                                for i = 1, #a do 
                                    table.insert(a[i], v)
                                end
                            end
                        end
                        for i,v in ipairs(transparency) do
                            v.Transparency = 1
                        end
                        for i,v in ipairs(scrollBarImageTransparency) do 
                            v.ScrollBarImageTransparency = 1 
                        end
                        transparency = nil
                        scrollBarImageTransparency = nil
                        animCon = renderService.RenderStepped:Connect(function(dt) 
                            dt *= 8
                            for i= 1, #backgroundTransparency do 
                                backgroundTransparency[i].BackgroundTransparency += dt
                            end
                            for i= 1, #imageTransparency do 
                                imageTransparency[i].ImageTransparency += dt
                            end
                            for i= 1, #textTransparency do 
                                textTransparency[i].TextTransparency += dt
                            end
                        end)
                    end)
                    tween(mainFrame['#scale'], {Scale = 0.6}, 0.5, 1).Completed:Wait()
                    animCon:Disconnect()
                    mainFrame:Destroy()
                end)
                table.remove(ui.windows, table.find(ui.windows, self))
                if (#ui.windows == 0) then
                    wait(0.3)
                    ui.destroy(true) 
                end
                self:fireEvent('destroyInternal')
                return self 
            end
            window.setTitle = function(self, title) 
                self.instances.title.Text = tostring(title)
                return self 
            end
            window.setIcon = function(self, newIcon) 
                self.instances.mainFrame['#title-bar']['#icon'].Image = newIcon
                return self
            end
            window.setPosition = function(self, newPosition)
                if (typeof(newPosition) == 'Vector2') then
                    newPosition = UDim2.fromOffset(newPosition.X, newPosition.Y)
                elseif (typeof(newPosition) ~= 'UDim2') then
                    return error('expected type UDim2 or Vector2', 2)
                end
                self.instances.mainFrame.Position = newPosition
                return self 
            end
            window.setSize = function(self, size)
                if (typeof(size) == 'Vector2') then
                    size = UDim2.fromOffset(size.X, size.Y)
                elseif (typeof(size) ~= 'UDim2') then
                    return error('expected type UDim2 or Vector2', 2)
                end
                self.size = size
                self.instances.mainFrame.Size = size
                return self 
            end
            window.getPosition = function(self) 
                return self.instances.mainFrame.Position
            end
            window.getSize = function(self, targetSize) 
                return targetSize and self.size or self.instances.mainFrame.Size
            end
            window.new = function(self, resize) 
                local new = setmetatable({}, self)
                new.menus = {}
                new.binds = {}
                table.insert(ui.windows, new)
                local instances = {}
                instances.mainFrame = self.instances.mainFrame:Clone()
                local titleBar = instances.mainFrame['#title-bar']
                instances.buttonClose = titleBar['#button-close']
                instances.buttonMin = titleBar['#button-min']
                instances.titleBar = titleBar
                instances.title = titleBar['#title']
                instances.gradient = instances.mainFrame['#trim']['#gradient']
                instances.sideBar = instances.mainFrame['#sidebar']
                instances.tabMenu = instances.sideBar['#menu']
                instances.pageRegion = instances.mainFrame['#page-region']
                instances.resizeHandle = instances.mainFrame['#resize-handle']
                instances.resizeBottom = instances.mainFrame['#resize-bottom']
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                -- dragging
                do 
                    local dCon
                    local aCon
                    local mainFrame = instances.mainFrame
                    local targetPos
                    titleBar.InputBegan:Connect(function(io) 
                        if (io.UserInputType.Value == 0) then
                            local rootPos = mainFrame.AbsolutePosition
                            local startPos = io.Position
                            startPos = Vector2.new(startPos.X, startPos.Y)
                            targetPos = UDim2.fromOffset(rootPos.X, rootPos.Y)
                            aCon = renderService.RenderStepped:Connect(function(dt) 
                                mainFrame.Position = mainFrame.Position:lerp(targetPos, 1 - animSpeed^dt)
                            end)
                            dCon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Value == 4) then
                                    local curPos = io.Position
                                    curPos = Vector2.new(curPos.X, curPos.Y) 
                                    local dest = rootPos + (curPos - startPos)
                                    targetPos = UDim2.fromOffset(dest.X, dest.Y)
                                end
                            end)
                        end
                    end)
                    titleBar.InputEnded:Connect(function(io)
                        if (io.UserInputType.Value == 0) then
                            dCon:Disconnect()
                            aCon:Disconnect()
                            tween(mainFrame, {Position = targetPos}, 0.2, 1)
                        end
                    end)
                end
                -- corner resizing
                if (resize) then
                    local dCon
                    local aCon
                    local mainFrame = instances.mainFrame
                    local resizeHandle = instances.resizeHandle
                    local targetSize
                    resizeHandle.InputBegan:Connect(function(io) 
                        if (io.UserInputType.Value == 0 and not new.minimized) then
                            local rootSize = mainFrame.AbsoluteSize
                            local startPos = io.Position
                            startPos = Vector2.new(startPos.X, startPos.Y)
                            targetSize = UDim2.fromOffset(rootSize.X, rootSize.Y)
                            aCon = renderService.RenderStepped:Connect(function(dt) 
                                mainFrame.Size = mainFrame.Size:lerp(targetSize, 1 - animSpeed^dt)
                                new.size = mainFrame.Size
                            end)
                            dCon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Value == 4) then
                                    local curPos = io.Position
                                    curPos = Vector2.new(curPos.X, curPos.Y) 
                                    local dest = rootSize + (curPos - startPos)
                                    targetSize = UDim2.fromOffset(math.clamp(dest.X, 400, 1000), math.clamp(dest.Y, 300, 800))
                                end
                            end)
                        end
                    end)
                    resizeHandle.InputEnded:Connect(function(io)
                        if (io.UserInputType.Value == 0 and not new.minimized) then
                            dCon:Disconnect()
                            aCon:Disconnect()
                            tween(mainFrame, {Size = targetSize}, 0.2, 1)
                            new.size = targetSize
                        end
                    end)
                else
                    instances.resizeHandle.Visible = false
                end
                -- bottom edge resizing (new)
                if (resize) then
                    local dCon
                    local aCon
                    local mainFrame = instances.mainFrame
                    local resizeBottom = instances.resizeBottom
                    local targetSize
                    resizeBottom.InputBegan:Connect(function(io) 
                        if (io.UserInputType.Value == 0 and not new.minimized) then
                            local rootSize = mainFrame.AbsoluteSize
                            local startPos = io.Position
                            startPos = Vector2.new(startPos.X, startPos.Y)
                            targetSize = UDim2.fromOffset(rootSize.X, rootSize.Y)
                            aCon = renderService.RenderStepped:Connect(function(dt) 
                                mainFrame.Size = mainFrame.Size:lerp(targetSize, 1 - animSpeed^dt)
                                new.size = mainFrame.Size
                            end)
                            dCon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Value == 4) then
                                    local curPos = io.Position
                                    curPos = Vector2.new(curPos.X, curPos.Y) 
                                    local dh = curPos.Y - startPos.Y
                                    local newHeight = math.clamp(rootSize.Y + dh, 300, 800)
                                    targetSize = UDim2.fromOffset(rootSize.X, newHeight)
                                end
                            end)
                        end
                    end)
                    resizeBottom.InputEnded:Connect(function(io)
                        if (io.UserInputType.Value == 0 and not new.minimized) then
                            dCon:Disconnect()
                            aCon:Disconnect()
                            tween(mainFrame, {Size = targetSize}, 0.2, 1)
                            new.size = targetSize
                        end
                    end)
                    -- change cursor on hover
                    resizeBottom.MouseEnter:Connect(function()
                        resizeBottom.BackgroundColor3 = theme.Primary
                    end)
                    resizeBottom.MouseLeave:Connect(function()
                        resizeBottom.BackgroundColor3 = theme.Primary
                        resizeBottom.BackgroundTransparency = 0.75
                    end)
                else
                    instances.resizeBottom.Visible = false
                end
                instances.mainFrame.Parent = uiScreen
                new.instances = instances
                return new
            end
            window.minimize = function(self) 
                local newState = not self.minimized
                local mf = self.instances.mainFrame
                local bmin = mf['#title-bar']['#button-min']
                local bminIcon = bmin['#icon']
                if (newState) then
                    tween(mf, {Size = UDim2.fromOffset(self.size.X.Offset, 26)}, 0.3, 1)
                    bminIcon.Image = 'rbxassetid://9642646619'
                    tween(bminIcon, {Rotation = 45, ImageColor3 = theme.Primary}, 0.3, 1)
                    if (self.minFocused) then
                        tween(bmin, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                    else
                        tween(bmin, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                    end
                    mf['#page-region'].Visible = false
                    mf['#sidebar'].Visible = false
                else
                    tween(mf, {Size = self.size}, 0.3, 1)
                    bminIcon.Image = 'rbxassetid://9642680675'
                    tween(bminIcon, {Rotation = 0, ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.3, 1)
                    if (self.minFocused) then
                        tween(bmin, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                    else
                        tween(bmin, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                    end
                    mf['#page-region'].Visible = true
                    mf['#sidebar'].Visible = true
                end
                self.minimized = newState
            end            
        end
        elemClasses.window = window
    end
    -- PICKER WINDOW (size increased)
    do 
        local function polarToCart(r, theta) 
            return r * math.cos(theta), r * math.sin(theta)
        end
        local function cartToPolar(x, y) 
            return math.sqrt((x^2) + (y^2)), math.atan2(y, x)
        end
        local pickerWindow = {} do 
            pickerWindow.__index = pickerWindow
            setmetatable(pickerWindow, elemClasses.baseElement)
            pickerWindow.class = 'pickerWindow'
            pickerWindow.minimized = false
            pickerWindow.minFocused = false
            pickerWindow.hue = 0
            pickerWindow.sat = 0
            pickerWindow.val = 1
            pickerWindow.red = 255
            pickerWindow.green = 255
            pickerWindow.blue = 255
            pickerWindow.color = Color3.fromHSV(0, 0, 1)
            pickerWindow.chromaEnabled = false
            pickerWindow.chromaFocused = false
            pickerWindow.pickerMoving = false
            
            pickerWindow.toggleChroma = function(self) 
                local newState = not self.chromaEnabled
                local chromaButton = self.instances.chromaButton
                if (newState) then
                    if (self.chromaFocused) then
                        tween(chromaButton, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                    else
                        tween(chromaButton, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                    end
                    tween(chromaButton['#icon'], {Rotation = 360}, 0.5, 1)
                    tween(self.instances.speedSlider, {Position = UDim2.new(0, 4, 1, -24)}, 0.5, 1)
                    chromaButton['#icon'].Image = 'rbxassetid://9840988620'
                    self:fireEvent('chroma', true)
                else
                    if (self.chromaFocused) then
                        tween(chromaButton, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                    else
                        tween(chromaButton, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                    end
                    tween(chromaButton['#icon'], {Rotation = 0}, 0.5, 1)
                    tween(self.instances.speedSlider, {Position = UDim2.new(0, -44, 1, -24)}, 0.5, 1)
                    chromaButton['#icon'].Image = 'rbxassetid://9841673199'
                    self:fireEvent('chroma', false)
                end
                self.chromaEnabled = newState 
                return newState
            end
            
            pickerWindow.displayRGB = function(self) 
                local r, g, b = self.red, self.green, self.blue
                self.color = Color3.fromRGB(r, g, b)
                local hue, sat, val = self.color:ToHSV()
                self.hue = hue
                self.sat = sat
                self.val = val
                local radius = sat / 2
                local theta = (hue * (math.pi * 2)) - (math.pi * 2)
                local x, y = radius * math.cos(theta), radius * math.sin(theta)
                self.instances.valSlider['#slider-container'].BackgroundColor3 = Color3.fromHSV(hue, sat, 1)
                tween(self.instances.valCursor, {Position = UDim2.fromScale(val, 0)}, 0.3, 1)
                tween(self.instances.pickerCursor, {Position = UDim2.fromScale(x+0.5, y+0.5)}, 0.3, 1)
                self:fireEvent('newColor', self.color, {hue, sat, val})
            end
            
            pickerWindow.displayHSV = function(self, moveCursor) 
                local hue, sat, val = self.hue, self.sat, self.val
                self.color = Color3.fromHSV(hue, sat, val)
                local r, g, b = self.color.R * 255, self.color.G * 255, self.color.B * 255
                self.red = r
                self.green = g
                self.blue = b
                local instances = self.instances 
                instances.valSlider['#slider-container'].BackgroundColor3 = Color3.fromHSV(hue, sat, 1)
                tween(instances.redFill, {Size = UDim2.fromScale(r/255, 1)}, 0.3, 1)
                tween(instances.greenFill, {Size = UDim2.fromScale(g/255, 1)}, 0.3, 1)
                tween(instances.blueFill, {Size = UDim2.fromScale(b/255, 1)}, 0.3, 1)
                instances.redSlider['#val'].Text = math.floor(r)
                instances.greenSlider['#val'].Text = math.floor(g)
                instances.blueSlider['#val'].Text = math.floor(b)
                if (moveCursor) then
                    local radius = sat / 2
                    local theta = (hue * (math.pi * 2)) - (math.pi * 2)
                    local x, y = radius * math.cos(theta), radius * math.sin(theta)
                    tween(instances.valCursor, {Position = UDim2.fromScale(val, 0)}, 0.3, 1)
                    tween(instances.pickerCursor, {Position = UDim2.fromScale(x+0.5, y+0.5)}, 0.3, 1)
                end
                self:fireEvent('newColor', self.color, {hue, sat, val})
            end
            
            local instances = {} do 
                local main = Instance.new('Frame') do 
                    main.BackgroundColor3 = theme.Window2
                    main.BackgroundTransparency = 0
                    main.BorderSizePixel = 0
                    main.Name = '#main_frame'
                    main.Size = UDim2.fromOffset(350, 350) -- larger picker window
                    main.Visible = true
                    main.ZIndex = 100
                end
                local scale = Instance.new('UIScale') do 
                    scale.Scale = 1 
                    scale.Name = '#scale'
                    scale.Parent = main
                end
                local backgroundFrame = Instance.new('Frame') do 
                    backgroundFrame.BackgroundTransparency = 0 
                    backgroundFrame.BackgroundColor3 = theme.Window2
                    backgroundFrame.BorderSizePixel = 0 
                    backgroundFrame.Name = '#background'
                    backgroundFrame.Size = UDim2.fromScale(1, 1)
                    backgroundFrame.Visible = true 
                    backgroundFrame.ZIndex = 99
                    backgroundFrame.Parent = main
                end
                local stroke = Instance.new('UIStroke') do 
                    stroke.ApplyStrokeMode = 'Border'
                    stroke.Color = theme.Stroke
                    stroke.LineJoinMode = 'Round'
                    stroke.Thickness = 1 
                    stroke.Name = '#stroke'
                    stroke.Parent = main
                end
                local shadow = Instance.new('ImageLabel') do 
                    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
                    shadow.BackgroundTransparency = 1
                    shadow.BorderSizePixel = 0 
                    shadow.Image = 'rbxassetid://7331400934'
                    shadow.ImageColor3 = Color3.fromRGB(0, 0, 5)
                    shadow.Name = '#shadow'
                    shadow.Position = UDim2.fromScale(0.5, 0.5)
                    shadow.ScaleType = 'Slice'
                    shadow.Size = UDim2.new(1, 50, 1, 50)
                    shadow.SliceCenter = Rect.new(40, 40, 260, 260)
                    shadow.SliceScale = 1
                    shadow.ZIndex = 98
                    shadow.Parent = main
                end
                local trim = Instance.new('Frame') do 
                    trim.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    trim.BackgroundTransparency = 0
                    trim.BorderSizePixel = 0 
                    trim.Name = '#trim'
                    trim.Position = UDim2.fromOffset(0, -1)
                    trim.Size = UDim2.new(1, 0, 0, 1)
                    trim.ZIndex = 111
                    trim.Parent = main
                    local gradient = Instance.new('UIGradient') do 
                        gradient.Color = ColorSequence.new(theme.Primary, theme.Secondary)
                        gradient.Enabled = true
                        gradient.Name = '#gradient'
                        gradient.Rotation = 0
                        gradient.Parent = trim
                    end
                end
                local titleBar = Instance.new('Frame') do 
                    titleBar.Active = true
                    titleBar.BackgroundColor3 = theme.Window1
                    titleBar.BackgroundTransparency = 0
                    titleBar.BorderColor3 = theme.Inset1
                    titleBar.BorderMode = 'Inset'
                    titleBar.BorderSizePixel = 1
                    titleBar.ClipsDescendants = true
                    titleBar.Name = '#title-bar'
                    titleBar.Selectable = true
                    titleBar.Size = UDim2.new(1, 0, 0, 26)
                    titleBar.ZIndex = 101
                    titleBar.Parent = main 
                    local stroke = Instance.new('UIStroke') do 
                        stroke.ApplyStrokeMode = 'Border'
                        stroke.Color = theme.Stroke
                        stroke.LineJoinMode = 'Round'
                        stroke.Thickness = 1 
                        stroke.Name = '#stroke'
                        stroke.Parent = titleBar
                    end
                    local fade = Instance.new('Frame') do 
                        fade.BackgroundColor3 = theme.Window1
                        fade.BackgroundTransparency = 1
                        fade.BorderColor3 = theme.Inset1
                        fade.BorderMode = 'Inset'
                        fade.BorderSizePixel = 1
                        fade.Name = '#fade'
                        fade.Size = UDim2.new(1, 4, 1, 4)
                        fade.Position = UDim2.fromOffset(-2, -2)
                        fade.Visible = false
                        fade.ZIndex = 110
                        fade.Parent = titleBar
                    end
                    local buttonClose = Instance.new('TextButton') do 
                        buttonClose.AnchorPoint = Vector2.new(1, 0)
                        buttonClose.AutoButtonColor = false
                        buttonClose.BackgroundColor3 = theme.Button1
                        buttonClose.BorderSizePixel = 0
                        buttonClose.Name = '#button-close'
                        buttonClose.Position = UDim2.new(1, -3, 0, 2)
                        buttonClose.Size = UDim2.fromOffset(20, 20)
                        buttonClose.Visible = true
                        buttonClose.ZIndex = 102 
                        buttonClose.Text = ''
                        buttonClose.Parent = titleBar
                        local round = Instance.new('UICorner') do 
                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                            round.Name = '#round'
                            round.Parent = buttonClose
                        end
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = buttonClose
                        end
                        local icon = Instance.new('ImageLabel') do 
                            icon.Active = false
                            icon.BackgroundTransparency = 1
                            icon.BorderSizePixel = 0
                            icon.Image = 'rbxassetid://9801460300'
                            icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                            icon.Name = '#icon'
                            icon.Position = UDim2.fromOffset(0, 0)
                            icon.Size = UDim2.fromScale(1, 1)
                            icon.Visible = true
                            icon.ZIndex = 102
                            icon.Parent = buttonClose
                            local gradient = Instance.new('UIGradient') do 
                                gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                gradient.Rotation = 90
                                gradient.Enabled = true
                                gradient.Name = '#gradient'
                                gradient.Parent = icon
                            end
                        end
                    end
                    local buttonMin = Instance.new('TextButton') do 
                        buttonMin.AnchorPoint = Vector2.new(1, 0)
                        buttonMin.AutoButtonColor = false
                        buttonMin.BackgroundColor3 = theme.Button1
                        buttonMin.BorderSizePixel = 0
                        buttonMin.Name = '#button-min'
                        buttonMin.Position = UDim2.new(1, -27, 0, 2)
                        buttonMin.Size = UDim2.fromOffset(20, 20)
                        buttonMin.Visible = true
                        buttonMin.ZIndex = 102 
                        buttonMin.Text = ''
                        buttonMin.Parent = titleBar
                        local round = Instance.new('UICorner') do 
                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                            round.Name = '#round'
                            round.Parent = buttonMin
                        end
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = buttonMin
                        end
                        local icon = Instance.new('ImageLabel') do 
                            icon.Active = false
                            icon.BackgroundTransparency = 1
                            icon.BorderSizePixel = 0
                            icon.Image = 'rbxassetid://9801458532'
                            icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                            icon.Name = '#icon'
                            icon.Position = UDim2.fromOffset(0, 0)
                            icon.Size = UDim2.fromScale(1, 1)
                            icon.Visible = true
                            icon.ZIndex = 102 
                            icon.Parent = buttonMin
                            local gradient = Instance.new('UIGradient') do 
                                gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                gradient.Rotation = 90
                                gradient.Enabled = true
                                gradient.Name = '#gradient'
                                gradient.Parent = icon
                            end
                        end
                    end
                    local icon = Instance.new('ImageLabel') do 
                        icon.BackgroundTransparency = 1
                        icon.BorderSizePixel = 0
                        icon.Image = 'rbxassetid://9658988382'
                        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                        icon.ImageTransparency = 0
                        icon.Name = '#icon'
                        icon.Position = UDim2.fromOffset(2, 2)
                        icon.Size = UDim2.fromOffset(22, 22)
                        icon.Visible = true
                        icon.ZIndex = 103
                        icon.Parent = titleBar
                    end
                    local title = Instance.new('TextLabel') do 
                        title.BackgroundTransparency = 1
                        title.BorderSizePixel = 0
                        title.Font = 'RobotoCondensed'
                        title.Name = '#title'
                        title.Position = UDim2.fromOffset(24, 0)
                        title.RichText = true
                        title.Size = UDim2.new(1, -74, 1, 0)
                        title.Text = 'color picker'
                        title.TextColor3 = theme.TextPrimary
                        title.TextScaled = false
                        title.TextSize = 17
                        title.TextStrokeColor3 = theme.TextStroke
                        title.TextStrokeTransparency = 0.8
                        title.TextTransparency = 0
                        title.TextXAlignment = 'Left'
                        title.TextYAlignment = 'Center'
                        title.Visible = true
                        title.ZIndex = 102 
                        title.Parent = titleBar
                        local padding = Instance.new('UIPadding') do 
                            padding.PaddingLeft = UDim.new(0, 4)
                            padding.Name = '#padding'
                            padding.Parent = title
                        end
                    end
                end
                local region = Instance.new('Frame') do 
                    region.BackgroundColor3 = theme.Window2
                    region.BackgroundTransparency = 0
                    region.BorderColor3 = theme.Inset2
                    region.BorderMode = 'Inset'
                    region.BorderSizePixel = 1
                    region.ClipsDescendants = true 
                    region.Name = '#region'
                    region.Position = UDim2.fromOffset(0, 27)
                    region.Size = UDim2.new(1, 0, 1, -27)
                    region.Visible = true
                    region.ZIndex = 102
                    region.Parent = main
                    local pickerRegion = Instance.new('Frame') do 
                        pickerRegion.BackgroundColor3 = theme.Window2
                        pickerRegion.BackgroundTransparency = 0
                        pickerRegion.BorderColor3 = theme.Inset2
                        pickerRegion.BorderMode = 'Inset'
                        pickerRegion.BorderSizePixel = 1 
                        pickerRegion.ClipsDescendants = true
                        pickerRegion.Name = '#region-picker'
                        pickerRegion.Position = UDim2.fromOffset(2, 2)
                        pickerRegion.Size = UDim2.new(1, -4, 0.75, -4)
                        pickerRegion.Visible = true 
                        pickerRegion.ZIndex = 102
                        pickerRegion.Parent = region 
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = pickerRegion
                        end
                        local picker = Instance.new('ImageLabel') do 
                            picker.AnchorPoint = Vector2.new(0.5, 0.5)
                            picker.BackgroundTransparency = 1
                            picker.Image = 'rbxassetid://9801454501'
                            picker.Name = '#picker'
                            picker.Position = UDim2.fromScale(0.5, 0.5)
                            picker.Size = UDim2.fromScale(0.7, 0.7)
                            picker.SizeConstraint = 'RelativeYY'
                            picker.Visible = true
                            picker.ZIndex = 104
                            picker.Parent = pickerRegion
                            local cursorInner = Instance.new('Frame') do 
                                cursorInner.AnchorPoint = Vector2.new(0.5, 0.5)
                                cursorInner.BackgroundTransparency = 1
                                cursorInner.Name = '#cursor-inner'
                                cursorInner.Position = UDim2.fromScale(0.5, 0.5)
                                cursorInner.Size = UDim2.fromOffset(8, 8)
                                cursorInner.Visible = true
                                cursorInner.ZIndex = 106 
                                cursorInner.Parent = picker 
                                local round = Instance.new('UICorner') do 
                                    round.CornerRadius = UDim.new(1, 0)
                                    round.Name = '#round'
                                    round.Parent = cursorInner
                                end
                                local stroke = Instance.new('UIStroke') do 
                                    stroke.ApplyStrokeMode = 'Border'
                                    stroke.Color = Color3.fromRGB(255, 255, 255)
                                    stroke.LineJoinMode = 'Round'
                                    stroke.Name = '#stroke'
                                    stroke.Thickness = 1
                                    stroke.Parent = cursorInner
                                end
                                local cursorOuter = Instance.new('Frame') do 
                                    cursorOuter.BackgroundTransparency = 1
                                    cursorOuter.Name = '#cursor-outer'
                                    cursorOuter.Position = UDim2.fromOffset(-1, -1)
                                    cursorOuter.Size = UDim2.fromOffset(10, 10)
                                    cursorOuter.Visible = true
                                    cursorOuter.ZIndex = 106 
                                    cursorOuter.Parent = cursorInner 
                                    local round = Instance.new('UICorner') do 
                                        round.CornerRadius = UDim.new(1, 0)
                                        round.Name = '#round'
                                        round.Parent = cursorOuter
                                    end
                                    local stroke = Instance.new('UIStroke') do 
                                        stroke.ApplyStrokeMode = 'Border'
                                        stroke.Color = Color3.fromRGB(0, 0, 5)
                                        stroke.LineJoinMode = 'Round'
                                        stroke.Name = '#stroke'
                                        stroke.Thickness = 1
                                        stroke.Parent = cursorOuter
                                    end
                                end
                            end
                            local outline = Instance.new('Frame') do 
                                outline.BackgroundColor3 = theme.Stroke
                                outline.BorderSizePixel = 0
                                outline.Name = '#outline'
                                outline.Position = UDim2.fromOffset(1,1)
                                outline.Size = UDim2.new(1, -2, 1, -2)
                                outline.SizeConstraint = 'RelativeYY'
                                outline.Visible = true
                                outline.ZIndex = 103
                                outline.Parent = picker
                                local round = Instance.new('UICorner') do 
                                    round.CornerRadius = UDim.new(1, 0)
                                    round.Name = '#round'
                                    round.Parent = outline
                                end
                                local stroke = Instance.new('UIStroke') do 
                                    stroke.ApplyStrokeMode = 'Border'
                                    stroke.Color = theme.Stroke
                                    stroke.LineJoinMode = 'Round'
                                    stroke.Name = '#stroke'
                                    stroke.Thickness = 2 
                                    stroke.Parent = outline
                                end
                            end
                        end
                        local valueSlider = Instance.new('Frame') do 
                            valueSlider.AnchorPoint = Vector2.new(0.5, 1)
                            valueSlider.BackgroundTransparency = 1
                            valueSlider.Name = '#value-slider'
                            valueSlider.Position = UDim2.fromScale(0.5, 1)
                            valueSlider.Size = UDim2.new(0.8, 0, 0, 24)
                            valueSlider.ZIndex = 103
                            valueSlider.Visible = true
                            valueSlider.Parent = pickerRegion
                            local sliderContainer = Instance.new('Frame') do 
                                sliderContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                sliderContainer.Position = UDim2.fromOffset(3, 6)
                                sliderContainer.Size = UDim2.new(1, -6, 0, 12)
                                sliderContainer.Visible = true
                                sliderContainer.ZIndex = 103
                                sliderContainer.Name = '#slider-container'
                                sliderContainer.Parent = valueSlider
                                local round = Instance.new('UICorner') do 
                                    round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                    round.Name = '#round'
                                    round.Parent = sliderContainer
                                end
                                local stroke = Instance.new('UIStroke') do 
                                    stroke.ApplyStrokeMode = 'Border'
                                    stroke.Color = theme.Stroke
                                    stroke.LineJoinMode = 'Round'
                                    stroke.Name = '#stroke'
                                    stroke.Thickness = 1 
                                    stroke.Parent = sliderContainer
                                end
                                local valueGradient = Instance.new('Frame') do 
                                    valueGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                    valueGradient.BackgroundTransparency = 0
                                    valueGradient.Name = '#value-gradient'
                                    valueGradient.Size = UDim2.fromScale(1, 1)
                                    valueGradient.Visible = true
                                    valueGradient.ZIndex = 104 
                                    valueGradient.Parent = sliderContainer
                                    local gradient = Instance.new('UIGradient') do 
                                        gradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
                                        gradient.Enabled = true
                                        gradient.Name = '#gradient'
                                        gradient.Rotation = 180
                                        gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
                                        gradient.Parent = valueGradient
                                    end
                                    local round = Instance.new('UICorner') do 
                                        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                        round.Name = '#round'
                                        round.Parent = valueGradient
                                    end
                                    local stroke = Instance.new('UIStroke') do 
                                        stroke.ApplyStrokeMode = 'Border'
                                        stroke.Color = theme.Stroke
                                        stroke.LineJoinMode = 'Round'
                                        stroke.Name = '#stroke'
                                        stroke.Thickness = 1 
                                        stroke.Parent = valueGradient
                                    end
                                end
                                local cursorInner = Instance.new('Frame') do 
                                    cursorInner.AnchorPoint = Vector2.new(0.5, 0)
                                    cursorInner.BackgroundTransparency = 1
                                    cursorInner.Name = '#cursor-inner'
                                    cursorInner.Position = UDim2.fromScale(1, 0)
                                    cursorInner.Size = UDim2.fromOffset(4, 12)
                                    cursorInner.Visible = true
                                    cursorInner.ZIndex = 104 
                                    cursorInner.Parent = sliderContainer 
                                    local round = Instance.new('UICorner') do 
                                        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                        round.Name = '#round'
                                        round.Parent = cursorInner
                                    end
                                    local stroke = Instance.new('UIStroke') do 
                                        stroke.ApplyStrokeMode = 'Border'
                                        stroke.Color = Color3.fromRGB(255, 255, 255)
                                        stroke.LineJoinMode = 'Round'
                                        stroke.Name = '#stroke'
                                        stroke.Thickness = 1
                                        stroke.Parent = cursorInner
                                    end
                                    local cursorOuter = Instance.new('Frame') do 
                                        cursorOuter.AnchorPoint = Vector2.new(0.5, 0.5)
                                        cursorOuter.BackgroundTransparency = 1
                                        cursorOuter.Name = '#cursor-outer'
                                        cursorOuter.Position = UDim2.fromScale(0.5, 0.5)
                                        cursorOuter.Size = UDim2.new(1, 2, 1, 2)
                                        cursorOuter.Visible = true
                                        cursorOuter.ZIndex = 104 
                                        cursorOuter.Parent = cursorInner 
                                        local round = Instance.new('UICorner') do 
                                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                            round.Name = '#round'
                                            round.Parent = cursorOuter
                                        end
                                        local stroke = Instance.new('UIStroke') do 
                                            stroke.ApplyStrokeMode = 'Border'
                                            stroke.Color = Color3.fromRGB(0, 0, 5)
                                            stroke.LineJoinMode = 'Round'
                                            stroke.Name = '#stroke'
                                            stroke.Thickness = 1
                                            stroke.Parent = cursorOuter
                                        end
                                    end
                                end
                            end
                        end
                        local speedSlider = Instance.new('Frame') do 
                            speedSlider.AnchorPoint = Vector2.new(0, 1)
                            speedSlider.BackgroundTransparency = 1
                            speedSlider.Name = '#speed-slider'
                            speedSlider.Position = UDim2.new(0, -40, 1, -24)
                            speedSlider.Size = UDim2.new(0, 24, 1, -26)
                            speedSlider.ZIndex = 103
                            speedSlider.Visible = true
                            speedSlider.Parent = pickerRegion
                            local sliderContainer = Instance.new('Frame') do 
                                sliderContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                sliderContainer.Position = UDim2.fromOffset(6, 3)
                                sliderContainer.Size = UDim2.new(0, 12, 1, -6)
                                sliderContainer.Visible = true
                                sliderContainer.ZIndex = 103
                                sliderContainer.Name = '#slider-container'
                                sliderContainer.Parent = speedSlider
                                local round = Instance.new('UICorner') do 
                                    round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                    round.Name = '#round'
                                    round.Parent = sliderContainer
                                end
                                local stroke = Instance.new('UIStroke') do 
                                    stroke.ApplyStrokeMode = 'Border'
                                    stroke.Color = theme.Stroke
                                    stroke.LineJoinMode = 'Round'
                                    stroke.Name = '#stroke'
                                    stroke.Thickness = 1 
                                    stroke.Parent = sliderContainer
                                end
                                local speedGradient = Instance.new('Frame') do 
                                    speedGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                    speedGradient.BackgroundTransparency = 0
                                    speedGradient.Name = '#speed-gradient'
                                    speedGradient.Size = UDim2.fromScale(1, 1)
                                    speedGradient.Visible = true
                                    speedGradient.ZIndex = 104 
                                    speedGradient.Parent = sliderContainer
                                    local gradient = Instance.new('UIGradient') do 
                                        gradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
                                        gradient.Enabled = true
                                        gradient.Name = '#gradient'
                                        gradient.Rotation = 90
                                        gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
                                        gradient.Parent = speedGradient
                                    end
                                    local round = Instance.new('UICorner') do 
                                        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                        round.Name = '#round'
                                        round.Parent = speedGradient
                                    end
                                    local stroke = Instance.new('UIStroke') do 
                                        stroke.ApplyStrokeMode = 'Border'
                                        stroke.Color = theme.Stroke
                                        stroke.LineJoinMode = 'Round'
                                        stroke.Name = '#stroke'
                                        stroke.Thickness = 1 
                                        stroke.Parent = speedGradient
                                    end
                                end
                                local cursorInner = Instance.new('Frame') do 
                                    cursorInner.AnchorPoint = Vector2.new(0, 0.5)
                                    cursorInner.BackgroundTransparency = 1
                                    cursorInner.Name = '#cursor-inner'
                                    cursorInner.Position = UDim2.fromScale(0, 0)
                                    cursorInner.Size = UDim2.fromOffset(12, 4)
                                    cursorInner.Visible = true
                                    cursorInner.ZIndex = 104 
                                    cursorInner.Parent = sliderContainer 
                                    local round = Instance.new('UICorner') do 
                                        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                        round.Name = '#round'
                                        round.Parent = cursorInner
                                    end
                                    local stroke = Instance.new('UIStroke') do 
                                        stroke.ApplyStrokeMode = 'Border'
                                        stroke.Color = Color3.fromRGB(255, 255, 255)
                                        stroke.LineJoinMode = 'Round'
                                        stroke.Name = '#stroke'
                                        stroke.Thickness = 1
                                        stroke.Parent = cursorInner
                                    end
                                    local cursorOuter = Instance.new('Frame') do 
                                        cursorOuter.AnchorPoint = Vector2.new(0.5, 0.5)
                                        cursorOuter.BackgroundTransparency = 1
                                        cursorOuter.Name = '#cursor-outer'
                                        cursorOuter.Position = UDim2.fromScale(0.5, 0.5)
                                        cursorOuter.Size = UDim2.new(1, 2, 1, 2)
                                        cursorOuter.Visible = true
                                        cursorOuter.ZIndex = 104 
                                        cursorOuter.Parent = cursorInner 
                                        local round = Instance.new('UICorner') do 
                                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                            round.Name = '#round'
                                            round.Parent = cursorOuter
                                        end
                                        local stroke = Instance.new('UIStroke') do 
                                            stroke.ApplyStrokeMode = 'Border'
                                            stroke.Color = Color3.fromRGB(0, 0, 5)
                                            stroke.LineJoinMode = 'Round'
                                            stroke.Name = '#stroke'
                                            stroke.Thickness = 1
                                            stroke.Parent = cursorOuter
                                        end
                                    end
                                end
                            end
                        end
                        local chroma = Instance.new('TextButton') do 
                            chroma.Active = true
                            chroma.AnchorPoint = Vector2.new(0, 1)
                            chroma.AutoButtonColor = false
                            chroma.BackgroundColor3 = theme.Button1
                            chroma.Name = '#chroma'
                            chroma.Position = UDim2.new(0, 8, 1, -4)
                            chroma.Size = UDim2.fromOffset(16, 16)
                            chroma.Text = ''
                            chroma.Visible = true
                            chroma.ZIndex = 103
                            chroma.Parent = pickerRegion
                            local round = Instance.new('UICorner') do 
                                round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                round.Name = '#round'
                                round.Parent = chroma
                            end
                            local stroke = Instance.new('UIStroke') do 
                                stroke.ApplyStrokeMode = 'Border'
                                stroke.Color = theme.Stroke
                                stroke.LineJoinMode = 'Round'
                                stroke.Name = '#stroke'
                                stroke.Thickness = 1 
                                stroke.Parent = chroma
                            end
                            local icon = Instance.new('ImageLabel') do 
                                icon.Active = false
                                icon.BackgroundTransparency = 1
                                icon.BorderSizePixel = 0
                                icon.Image = 'rbxassetid://9841673199'
                                icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                                icon.Name = '#icon'
                                icon.Position = UDim2.fromOffset(0, 0)
                                icon.Rotation = 0
                                icon.Size = UDim2.fromScale(1, 1)
                                icon.Visible = true
                                icon.ZIndex = 103 
                                icon.Parent = chroma
                            end
                        end
                    end
                    local inputRegion = Instance.new('Frame') do 
                        inputRegion.BackgroundColor3 = theme.Window2
                        inputRegion.BackgroundTransparency = 0
                        inputRegion.BorderColor3 = theme.Inset2
                        inputRegion.BorderMode = 'Inset'
                        inputRegion.BorderSizePixel = 1 
                        inputRegion.ClipsDescendants = true
                        inputRegion.Name = '#region-input'
                        inputRegion.Position = UDim2.new(0, 2, 0.75, 2)
                        inputRegion.Size = UDim2.new(1, -4, 0.25, -4)
                        inputRegion.Visible = true 
                        inputRegion.ZIndex = 102
                        inputRegion.Parent = region 
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = inputRegion
                        end
                        local redSlider = Instance.new('Frame') do 
                            redSlider.BackgroundTransparency = 1
                            redSlider.Name = '#red-slider'
                            redSlider.Position = UDim2.fromOffset(0, -1)
                            redSlider.Size = UDim2.new(1, 0, 0, 24)
                            redSlider.ZIndex = 103
                            redSlider.Visible = true
                            redSlider.Parent = inputRegion
                            local sliderContainer = Instance.new('Frame') do 
                                sliderContainer.BackgroundColor3 = theme.Button1
                                sliderContainer.Position = UDim2.fromOffset(3, 6)
                                sliderContainer.Size = UDim2.new(1, -6, 0, 12)
                                sliderContainer.Visible = true
                                sliderContainer.ZIndex = 103
                                sliderContainer.Name = '#slider-container'
                                sliderContainer.Parent = redSlider
                                local round = Instance.new('UICorner') do 
                                    round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                    round.Name = '#round'
                                    round.Parent = sliderContainer
                                end
                                local stroke = Instance.new('UIStroke') do 
                                    stroke.ApplyStrokeMode = 'Border'
                                    stroke.Color = theme.Stroke
                                    stroke.LineJoinMode = 'Round'
                                    stroke.Name = '#stroke'
                                    stroke.Thickness = 1 
                                    stroke.Parent = sliderContainer
                                end
                                local sliderFill = Instance.new('Frame') do 
                                    sliderFill.Active = false
                                    sliderFill.BackgroundColor3 = theme.Primary
                                    sliderFill.BackgroundTransparency = 0.6
                                    sliderFill.BorderSizePixel = 0
                                    sliderFill.Name = '#slider-fill'
                                    sliderFill.Size = UDim2.fromScale(1, 1)
                                    sliderFill.Visible = true
                                    sliderFill.ZIndex = 104
                                    sliderFill.Parent = sliderContainer
                                    local round = Instance.new('UICorner') do 
                                        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                        round.Name = '#round'
                                        round.Parent = sliderFill
                                    end
                                    local gradient = Instance.new('UIGradient') do 
                                        gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                        gradient.Rotation = 90
                                        gradient.Enabled = true
                                        gradient.Name = '#gradient'
                                        gradient.Parent = sliderFill
                                    end
                                end
                                local inputBox = Instance.new('TextBox') do 
                                    inputBox.Active = true 
                                    inputBox.BackgroundColor3 = theme.Window1
                                    inputBox.BackgroundTransparency = 0.1
                                    inputBox.ClearTextOnFocus = true
                                    inputBox.ClipsDescendants = true
                                    inputBox.Font = 'SourceSans'
                                    inputBox.Name = '#input-box'
                                    inputBox.PlaceholderColor3 = theme.TextDim
                                    inputBox.PlaceholderText = 'enter value'
                                    inputBox.Size = UDim2.fromScale(1, 1)
                                    inputBox.Text = 'enter value'
                                    inputBox.TextColor3 = theme.TextPrimary
                                    inputBox.TextSize = 14
                                    inputBox.TextStrokeColor3 = theme.TextStroke
                                    inputBox.TextStrokeTransparency = 0.8
                                    inputBox.TextWrapped = true
                                    inputBox.TextXAlignment = 'Center'
                                    inputBox.TextYAlignment = 'Center'
                                    inputBox.Visible = false
                                    inputBox.ZIndex = 105
                                    inputBox.Parent = sliderContainer
                                    local round = Instance.new('UICorner') do 
                                        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                        round.Name = '#round'
                                        round.Parent = inputBox
                                    end
                                    local stroke = Instance.new('UIStroke') do 
                                        stroke.ApplyStrokeMode = 'Border'
                                        stroke.Color = theme.Stroke
                                        stroke.LineJoinMode = 'Round'
                                        stroke.Name = '#stroke'
                                        stroke.Thickness = 1 
                                        stroke.Parent = inputBox
                                    end
                                    local padding = Instance.new('UIPadding') do 
                                        padding.PaddingLeft = UDim.new(0, 4)
                                        padding.Name = '#padding'
                                        padding.Parent = inputBox
                                    end
                                end
                            end
                            local title = Instance.new('TextLabel') do 
                                title.BackgroundTransparency = 1
                                title.Font = 'SourceSans'
                                title.Name = '#title'
                                title.Size = UDim2.new(1, 0, 1, -1)
                                title.Text = 'red'
                                title.TextColor3 = theme.TextPrimary
                                title.TextSize = 14
                                title.TextStrokeColor3 = theme.TextStroke
                                title.TextStrokeTransparency = 0.8
                                title.TextTransparency = 0
                                title.TextWrapped = false
                                title.TextXAlignment = 'Left'
                                title.TextYAlignment = 'Center'
                                title.Visible = true
                                title.ZIndex = 104
                                title.Parent = redSlider
                                local padding = Instance.new('UIPadding') do 
                                    padding.PaddingLeft = UDim.new(0, 6)
                                    padding.Parent = title
                                end
                            end
                            local val = Instance.new('TextLabel') do 
                                val.BackgroundTransparency = 1
                                val.Font = 'SourceSans'
                                val.Name = '#val'
                                val.Size = UDim2.new(1, 0, 1, -1)
                                val.Text = '255'
                                val.TextColor3 = theme.TextPrimary
                                val.TextSize = 14
                                val.TextStrokeColor3 = theme.TextStroke
                                val.TextStrokeTransparency = 0.8
                                val.TextTransparency = 0
                                val.TextWrapped = false
                                val.TextXAlignment = 'Right'
                                val.TextYAlignment = 'Center'
                                val.Visible = true
                                val.ZIndex = 104
                                val.Parent = redSlider
                                local padding = Instance.new('UIPadding') do 
                                    padding.PaddingRight = UDim.new(0, 6)
                                    padding.Parent = val
                                end
                            end
                        end
                        local greenSlider = Instance.new('Frame') do 
                            greenSlider.BackgroundTransparency = 1
                            greenSlider.Name = '#green-slider'
                            greenSlider.Position = UDim2.fromOffset(0, 19)
                            greenSlider.Size = UDim2.new(1, 0, 0, 24)
                            greenSlider.ZIndex = 103
                            greenSlider.Visible = true
                            greenSlider.Parent = inputRegion
                            local sliderContainer = Instance.new('Frame') do 
                                sliderContainer.BackgroundColor3 = theme.Button1
                                sliderContainer.Position = UDim2.fromOffset(3, 6)
                                sliderContainer.Size = UDim2.new(1, -6, 0, 12)
                                sliderContainer.Visible = true
                                sliderContainer.ZIndex = 103
                                sliderContainer.Name = '#slider-container'
                                sliderContainer.Parent = greenSlider
                                local round = Instance.new('UICorner') do 
                                    round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                    round.Name = '#round'
                                    round.Parent = sliderContainer
                                end
                                local stroke = Instance.new('UIStroke') do 
                                    stroke.ApplyStrokeMode = 'Border'
                                    stroke.Color = theme.Stroke
                                    stroke.LineJoinMode = 'Round'
                                    stroke.Name = '#stroke'
                                    stroke.Thickness = 1 
                                    stroke.Parent = sliderContainer
                                end
                                local sliderFill = Instance.new('Frame') do 
                                    sliderFill.Active = false
                                    sliderFill.BackgroundColor3 = theme.Primary
                                    sliderFill.BackgroundTransparency = 0.6
                                    sliderFill.BorderSizePixel = 0
                                    sliderFill.Name = '#slider-fill'
                                    sliderFill.Size = UDim2.fromScale(1, 1)
                                    sliderFill.Visible = true
                                    sliderFill.ZIndex = 104
                                    sliderFill.Parent = sliderContainer
                                    local round = Instance.new('UICorner') do 
                                        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                        round.Name = '#round'
                                        round.Parent = sliderFill
                                    end
                                    local gradient = Instance.new('UIGradient') do 
                                        gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                        gradient.Rotation = 90
                                        gradient.Enabled = true
                                        gradient.Name = '#gradient'
                                        gradient.Parent = sliderFill
                                    end
                                end
                                local inputBox = Instance.new('TextBox') do 
                                    inputBox.Active = true 
                                    inputBox.BackgroundColor3 = theme.Window1
                                    inputBox.BackgroundTransparency = 0.1
                                    inputBox.ClearTextOnFocus = true
                                    inputBox.ClipsDescendants = true
                                    inputBox.Font = 'SourceSans'
                                    inputBox.Name = '#input-box'
                                    inputBox.PlaceholderColor3 = theme.TextDim
                                    inputBox.PlaceholderText = 'enter value'
                                    inputBox.Size = UDim2.fromScale(1, 1)
                                    inputBox.Text = 'enter value'
                                    inputBox.TextColor3 = theme.TextPrimary
                                    inputBox.TextSize = 14
                                    inputBox.TextStrokeColor3 = theme.TextStroke
                                    inputBox.TextStrokeTransparency = 0.8
                                    inputBox.TextWrapped = true
                                    inputBox.TextXAlignment = 'Center'
                                    inputBox.TextYAlignment = 'Center'
                                    inputBox.Visible = false
                                    inputBox.ZIndex = 105
                                    inputBox.Parent = sliderContainer
                                    local round = Instance.new('UICorner') do 
                                        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                        round.Name = '#round'
                                        round.Parent = inputBox
                                    end
                                    local stroke = Instance.new('UIStroke') do 
                                        stroke.ApplyStrokeMode = 'Border'
                                        stroke.Color = theme.Stroke
                                        stroke.LineJoinMode = 'Round'
                                        stroke.Name = '#stroke'
                                        stroke.Thickness = 1 
                                        stroke.Parent = inputBox
                                    end
                                end
                            end
                            local title = Instance.new('TextLabel') do 
                                title.BackgroundTransparency = 1
                                title.Font = 'SourceSans'
                                title.Name = '#title'
                                title.Size = UDim2.new(1, 0, 1, -1)
                                title.Text = 'green'
                                title.TextColor3 = theme.TextPrimary
                                title.TextSize = 14
                                title.TextStrokeColor3 = theme.TextStroke
                                title.TextStrokeTransparency = 0.8
                                title.TextTransparency = 0
                                title.TextWrapped = false
                                title.TextXAlignment = 'Left'
                                title.TextYAlignment = 'Center'
                                title.Visible = true
                                title.ZIndex = 104
                                title.Parent = greenSlider
                                local padding = Instance.new('UIPadding') do 
                                    padding.PaddingLeft = UDim.new(0, 6)
                                    padding.Parent = title
                                end
                            end
                            local val = Instance.new('TextLabel') do 
                                val.BackgroundTransparency = 1
                                val.Font = 'SourceSans'
                                val.Name = '#val'
                                val.Size = UDim2.new(1, 0, 1, -1)
                                val.Text = '255'
                                val.TextColor3 = theme.TextPrimary
                                val.TextSize = 14
                                val.TextStrokeColor3 = theme.TextStroke
                                val.TextStrokeTransparency = 0.8
                                val.TextTransparency = 0
                                val.TextWrapped = false
                                val.TextXAlignment = 'Right'
                                val.TextYAlignment = 'Center'
                                val.Visible = true
                                val.ZIndex = 104
                                val.Parent = greenSlider
                                local padding = Instance.new('UIPadding') do 
                                    padding.PaddingRight = UDim.new(0, 6)
                                    padding.Parent = val
                                end
                            end
                        end
                        local blueSlider = Instance.new('Frame') do 
                            blueSlider.BackgroundTransparency = 1
                            blueSlider.Name = '#blue-slider'
                            blueSlider.Position = UDim2.fromOffset(0, 39)
                            blueSlider.Size = UDim2.new(1, 0, 0, 24)
                            blueSlider.ZIndex = 103
                            blueSlider.Visible = true
                            blueSlider.Parent = inputRegion
                            local sliderContainer = Instance.new('Frame') do 
                                sliderContainer.BackgroundColor3 = theme.Button1
                                sliderContainer.Position = UDim2.fromOffset(3, 6)
                                sliderContainer.Size = UDim2.new(1, -6, 0, 12)
                                sliderContainer.Visible = true
                                sliderContainer.ZIndex = 103
                                sliderContainer.Name = '#slider-container'
                                sliderContainer.Parent = blueSlider
                                local round = Instance.new('UICorner') do 
                                    round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                    round.Name = '#round'
                                    round.Parent = sliderContainer
                                end
                                local stroke = Instance.new('UIStroke') do 
                                    stroke.ApplyStrokeMode = 'Border'
                                    stroke.Color = theme.Stroke
                                    stroke.LineJoinMode = 'Round'
                                    stroke.Name = '#stroke'
                                    stroke.Thickness = 1 
                                    stroke.Parent = sliderContainer
                                end
                                local sliderFill = Instance.new('Frame') do 
                                    sliderFill.Active = false
                                    sliderFill.BackgroundColor3 = theme.Primary
                                    sliderFill.BackgroundTransparency = 0.6
                                    sliderFill.BorderSizePixel = 0
                                    sliderFill.Name = '#slider-fill'
                                    sliderFill.Size = UDim2.fromScale(1, 1)
                                    sliderFill.Visible = true
                                    sliderFill.ZIndex = 104
                                    sliderFill.Parent = sliderContainer
                                    local round = Instance.new('UICorner') do 
                                        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                        round.Name = '#round'
                                        round.Parent = sliderFill
                                    end
                                    local gradient = Instance.new('UIGradient') do 
                                        gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                        gradient.Rotation = 90
                                        gradient.Enabled = true
                                        gradient.Name = '#gradient'
                                        gradient.Parent = sliderFill
                                    end
                                end
                                local inputBox = Instance.new('TextBox') do 
                                    inputBox.Active = true 
                                    inputBox.BackgroundColor3 = theme.Window1
                                    inputBox.BackgroundTransparency = 0.1
                                    inputBox.ClearTextOnFocus = true
                                    inputBox.ClipsDescendants = true
                                    inputBox.Font = 'SourceSans'
                                    inputBox.Name = '#input-box'
                                    inputBox.PlaceholderColor3 = theme.TextDim
                                    inputBox.PlaceholderText = 'enter value'
                                    inputBox.Size = UDim2.fromScale(1, 1)
                                    inputBox.Text = 'enter value'
                                    inputBox.TextColor3 = theme.TextPrimary
                                    inputBox.TextSize = 14
                                    inputBox.TextStrokeColor3 = theme.TextStroke
                                    inputBox.TextStrokeTransparency = 0.8
                                    inputBox.TextWrapped = true
                                    inputBox.TextXAlignment = 'Center'
                                    inputBox.TextYAlignment = 'Center'
                                    inputBox.Visible = false
                                    inputBox.ZIndex = 105
                                    inputBox.Parent = sliderContainer
                                    local round = Instance.new('UICorner') do 
                                        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                        round.Name = '#round'
                                        round.Parent = inputBox
                                    end
                                    local stroke = Instance.new('UIStroke') do 
                                        stroke.ApplyStrokeMode = 'Border'
                                        stroke.Color = theme.Stroke
                                        stroke.LineJoinMode = 'Round'
                                        stroke.Name = '#stroke'
                                        stroke.Thickness = 1 
                                        stroke.Parent = inputBox
                                    end
                                end
                            end
                            local title = Instance.new('TextLabel') do 
                                title.BackgroundTransparency = 1
                                title.Font = 'SourceSans'
                                title.Name = '#title'
                                title.Size = UDim2.new(1, 0, 1, -1)
                                title.Text = 'blue'
                                title.TextColor3 = theme.TextPrimary
                                title.TextSize = 14
                                title.TextStrokeColor3 = theme.TextStroke
                                title.TextStrokeTransparency = 0.8
                                title.TextTransparency = 0
                                title.TextWrapped = false
                                title.TextXAlignment = 'Left'
                                title.TextYAlignment = 'Center'
                                title.Visible = true
                                title.ZIndex = 104
                                title.Parent = blueSlider
                                local padding = Instance.new('UIPadding') do 
                                    padding.PaddingLeft = UDim.new(0, 6)
                                    padding.Parent = title
                                end
                            end
                            local val = Instance.new('TextLabel') do 
                                val.BackgroundTransparency = 1
                                val.Font = 'SourceSans'
                                val.Name = '#val'
                                val.Size = UDim2.new(1, 0, 1, -1)
                                val.Text = '255'
                                val.TextColor3 = theme.TextPrimary
                                val.TextSize = 14
                                val.TextStrokeColor3 = theme.TextStroke
                                val.TextStrokeTransparency = 0.8
                                val.TextTransparency = 0
                                val.TextWrapped = false
                                val.TextXAlignment = 'Right'
                                val.TextYAlignment = 'Center'
                                val.Visible = true
                                val.ZIndex = 104
                                val.Parent = blueSlider
                                local padding = Instance.new('UIPadding') do 
                                    padding.PaddingRight = UDim.new(0, 6)
                                    padding.Parent = val
                                end
                            end
                        end
                    end
                end
                instances.main = main
            end
            pickerWindow.instances = instances 
            pickerWindow.signals = {
                buttonClose = {
                    MouseEnter = function(inst, win) 
                        tween(inst, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        tween(inst['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, win) 
                        tween(inst, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        tween(inst['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(inst, win) 
                        win:destroy()
                    end
                },
                buttonMin = {
                    MouseEnter = function(inst, win) 
                        win.minFocused = true
                        if (win.minimized) then
                            tween(inst, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                        else
                            tween(inst, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        end
                        tween(inst['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, win) 
                        win.minFocused = false
                        if (win.minimized) then
                            tween(inst, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                        else
                            tween(inst, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        end
                        tween(inst['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(_, self) 
                        self:minimize()
                    end
                },
                redSlider = {
                    MouseEnter = function(inst, win) 
                        local sliderCont = inst['#slider-container']
                        tween(sliderCont, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        tween(sliderCont['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, win) 
                        local sliderCont = inst['#slider-container']
                        tween(sliderCont, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        tween(sliderCont['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end
                },
                greenSlider = {
                    MouseEnter = function(inst, win) 
                        local sliderCont = inst['#slider-container']
                        tween(sliderCont, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        tween(sliderCont['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, win) 
                        local sliderCont = inst['#slider-container']
                        tween(sliderCont, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        tween(sliderCont['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end
                },
                blueSlider = {
                    MouseEnter = function(inst, win) 
                        local sliderCont = inst['#slider-container']
                        tween(sliderCont, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        tween(sliderCont['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, win) 
                        local sliderCont = inst['#slider-container']
                        tween(sliderCont, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        tween(sliderCont['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end
                },
                chromaButton = {
                    MouseEnter = function(inst, win) 
                        win.chromaFocused = true
                        if (win.chromaEnabled) then
                            tween(inst, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                        else
                            tween(inst, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        end
                        tween(inst['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, win) 
                        win.chromaFocused = false
                        if (win.chromaEnabled) then
                            tween(inst, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                        else
                            tween(inst, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        end
                        tween(inst['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(inst, win) 
                        win:toggleChroma()
                    end
                }
            }
            
            pickerWindow.destroy = function(self) 
                self:fireEvent('close')
                local main = self.instances.main
                task.spawn(function()
                    local animCon
                    task.spawn(function() 
                        local backgroundTransparency = {}
                        local imageTransparency = {}
                        local transparency = {}
                        local textTransparency = {}
                        local s = {
                            Frame = {backgroundTransparency}, 
                            ImageButton = {backgroundTransparency, imageTransparency},
                            ImageLabel = {backgroundTransparency, imageTransparency},
                            TextButton = {backgroundTransparency, textTransparency},
                            TextLabel = {backgroundTransparency, textTransparency},
                            UIStroke = {transparency},
                        }
                        local d = main:GetDescendants()
                        table.insert(d, main)
                        for i, v in ipairs(d) do 
                            local a = s[v.ClassName]
                            if (a) then
                                for i = 1, #a do 
                                    table.insert(a[i], v)
                                end
                            end
                        end
                        for i,v in ipairs(transparency) do
                            v.Transparency = 1
                        end
                        transparency = nil
                        scrollBarImageTransparency = nil
                        animCon = renderService.RenderStepped:Connect(function(dt) 
                            dt *= 8
                            for i= 1, #backgroundTransparency do 
                                backgroundTransparency[i].BackgroundTransparency += dt
                            end
                            for i= 1, #imageTransparency do 
                                imageTransparency[i].ImageTransparency += dt
                            end
                            for i= 1, #textTransparency do 
                                textTransparency[i].TextTransparency += dt
                            end
                        end)
                    end)
                    tween(main['#scale'], {Scale = 0.6}, 0.5, 1).Completed:Wait()
                    animCon:Disconnect()
                    main:Destroy()
                end)
                return self 
            end
            pickerWindow.setTitle = function(self, title) 
                self.instances.title.Text = tostring(title)
                return self 
            end
            pickerWindow.setPosition = function(self, newPosition)
                if (typeof(newPosition) == 'Vector2') then
                    newPosition = UDim2.fromOffset(newPosition.X, newPosition.Y)
                elseif (typeof(newPosition) ~= 'UDim2') then
                    return error('expected type UDim2 or Vector2', 2)
                end
                self.instances.main.Position = newPosition
                return self 
            end
            pickerWindow.new = function(self, resize) 
                local new = setmetatable({}, self)
                new.binds = {}
                table.insert(ui.pickerWindows, new)
                local instances = {}
                instances.main = self.instances.main:Clone()
                local titleBar = instances.main['#title-bar']
                instances.buttonClose = titleBar['#button-close']
                instances.buttonMin = titleBar['#button-min']
                instances.titleBar = titleBar
                instances.title = titleBar['#title']
                instances.pickerRegion = instances.main['#region']['#region-picker']
                instances.inputRegion = instances.main['#region']['#region-input']
                instances.colorPicker = instances.pickerRegion['#picker']
                instances.pickerCursor = instances.colorPicker['#cursor-inner']
                instances.valSlider = instances.pickerRegion['#value-slider']
                instances.valCursor = instances.valSlider['#slider-container']['#cursor-inner']
                instances.speedSlider = instances.pickerRegion['#speed-slider']
                instances.speedCursor = instances.speedSlider['#slider-container']['#cursor-inner']
                instances.redSlider = instances.inputRegion['#red-slider']
                instances.greenSlider = instances.inputRegion['#green-slider']
                instances.blueSlider = instances.inputRegion['#blue-slider']
                instances.redFill = instances.inputRegion['#red-slider']['#slider-container']['#slider-fill']
                instances.greenFill = instances.inputRegion['#green-slider']['#slider-container']['#slider-fill']
                instances.blueFill = instances.inputRegion['#blue-slider']['#slider-container']['#slider-fill']
                instances.chromaButton = instances.pickerRegion['#chroma']
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                -- dragging
                do 
                    local dCon
                    local aCon
                    local mainFrame = instances.main
                    local targetPos
                    titleBar.InputBegan:Connect(function(io) 
                        if (io.UserInputType.Value == 0) then
                            local rootPos = mainFrame.AbsolutePosition
                            local startPos = io.Position
                            startPos = Vector2.new(startPos.X, startPos.Y)
                            targetPos = UDim2.fromOffset(rootPos.X, rootPos.Y)
                            aCon = renderService.RenderStepped:Connect(function(dt) 
                                mainFrame.Position = mainFrame.Position:lerp(targetPos, 1 - animSpeed^dt)
                            end)
                            dCon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Value == 4) then
                                    local curPos = io.Position
                                    curPos = Vector2.new(curPos.X, curPos.Y) 
                                    local dest = rootPos + (curPos - startPos)
                                    targetPos = UDim2.fromOffset(dest.X, dest.Y)
                                end
                            end)
                        end
                    end)
                    titleBar.InputEnded:Connect(function(io)
                        if (io.UserInputType.Value == 0) then
                            dCon:Disconnect()
                            aCon:Disconnect()
                            tween(mainFrame, {Position = targetPos}, 0.2, 1)
                        end
                    end)
                end
                -- red slider
                do 
                    local slider = instances.redSlider
                    local container = slider['#slider-container']
                    local fill = container['#slider-fill'] 
                    local val = slider['#val']
                    local inputbox = container['#input-box']
                    local dcon
                    local acon
                    inputbox.FocusLost:Connect(function(enter, io) 
                        local tx = inputbox.Text
                        local n = tonumber(tx)
                        if (n) then
                            inputbox.Visible = false
                            local fixed = math.clamp(n / 255, 0, 1)
                            local rounded = math.floor((fixed) * 255) / 255
                            local newVal = rounded * 255
                            tween(fill, {Size = UDim2.fromScale(rounded, 1)}, 0.3, 1)
                            val.Text = newVal
                            new.red = newVal
                            new:displayRGB()
                        elseif (tx == '') then
                            inputbox.Visible = false
                        else
                            inputbox.Text = 'not a valid number'
                            wait(1)
                            inputbox:CaptureFocus()
                        end
                    end)
                    local targetSize
                    container.InputBegan:Connect(function(io) 
                        local inputName = io.UserInputType.Name
                        if (inputName == 'MouseButton1') then
                            local containerPos = container.AbsolutePosition
                            local containerWidth = container.AbsoluteSize.X
                            local startInput do 
                                local position = io.Position
                                startInput = Vector2.new(position.X, position.Y)
                            end
                            local rawValue = math.clamp((startInput - containerPos).X / containerWidth, 0, 1)
                            local roundedValue = math.floor((rawValue) * 255) / 255
                            local newValue = roundedValue * 255 
                            targetSize = UDim2.fromScale(roundedValue, 1)
                            val.Text = newValue
                            new.red = newValue
                            new:displayRGB()
                            acon = renderService.RenderStepped:Connect(function(dt) 
                                fill.Size = fill.Size:lerp(targetSize, 1 - 1e-12^dt)
                            end)
                            dcon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Name == 'MouseMovement') then
                                    local curInput do 
                                        local position = io.Position
                                        curInput = Vector2.new(position.X, position.Y)
                                    end
                                    local rawValue = math.clamp((curInput - containerPos).X / containerWidth, 0, 1)
                                    local roundedValue = math.floor((rawValue) * 255) / 255
                                    local newValue = roundedValue * 255 
                                    targetSize = UDim2.fromScale(roundedValue, 1)
                                    val.Text = newValue
                                    new.red = newValue
                                    new:displayRGB()
                                end
                            end)
                        elseif (inputName == 'MouseButton2') then
                            inputbox.Visible = true
                            inputbox:CaptureFocus()
                        end
                    end)
                    container.InputEnded:Connect(function(io) 
                        if (io.UserInputType.Name == 'MouseButton1') then
                            dcon:Disconnect()
                            acon:Disconnect()
                            tween(fill, {Size = targetSize}, 0.2, 1)
                        end
                    end)
                end
                -- green slider
                do 
                    local slider = instances.greenSlider
                    local container = slider['#slider-container']
                    local fill = container['#slider-fill'] 
                    local val = slider['#val']
                    local inputbox = container['#input-box']
                    local dcon
                    local acon
                    inputbox.FocusLost:Connect(function(enter, io) 
                        local tx = inputbox.Text
                        local n = tonumber(tx)
                        if (n) then
                            inputbox.Visible = false
                            local fixed = math.clamp(n / 255, 0, 1)
                            local rounded = math.floor((fixed) * 255) / 255
                            local newVal = rounded * 255
                            tween(fill, {Size = UDim2.fromScale(rounded, 1)}, 0.3, 1)
                            val.Text = newVal
                            new.green = newVal
                            new:displayRGB()
                        elseif (tx == '') then
                            inputbox.Visible = false
                        else
                            inputbox.Text = 'not a valid number'
                            wait(1)
                            inputbox:CaptureFocus()
                        end
                    end)
                    local targetSize
                    container.InputBegan:Connect(function(io) 
                        local inputName = io.UserInputType.Name
                        if (inputName == 'MouseButton1') then
                            local containerPos = container.AbsolutePosition
                            local containerWidth = container.AbsoluteSize.X
                            local startInput do 
                                local position = io.Position
                                startInput = Vector2.new(position.X, position.Y)
                            end
                            local rawValue = math.clamp((startInput - containerPos).X / containerWidth, 0, 1)
                            local roundedValue = math.floor((rawValue) * 255) / 255
                            local newValue = roundedValue * 255 
                            targetSize = UDim2.fromScale(roundedValue, 1)
                            val.Text = newValue
                            new.green = newValue
                            new:displayRGB()
                            acon = renderService.RenderStepped:Connect(function(dt) 
                                fill.Size = fill.Size:lerp(targetSize, 1 - 1e-12^dt)
                            end)
                            dcon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Name == 'MouseMovement') then
                                    local curInput do 
                                        local position = io.Position
                                        curInput = Vector2.new(position.X, position.Y)
                                    end
                                    local rawValue = math.clamp((curInput - containerPos).X / containerWidth, 0, 1)
                                    local roundedValue = math.floor((rawValue) * 255) / 255
                                    local newValue = roundedValue * 255 
                                    targetSize = UDim2.fromScale(roundedValue, 1)
                                    val.Text = newValue
                                    new.green = newValue
                                    new:displayRGB()
                                end
                            end)
                        elseif (inputName == 'MouseButton2') then
                            inputbox.Visible = true
                            inputbox:CaptureFocus()
                        end
                    end)
                    container.InputEnded:Connect(function(io) 
                        if (io.UserInputType.Name == 'MouseButton1') then
                            dcon:Disconnect()
                            acon:Disconnect()
                            tween(fill, {Size = targetSize}, 0.2, 1)
                        end
                    end)
                end
                -- blue slider
                do 
                    local slider = instances.blueSlider
                    local container = slider['#slider-container']
                    local fill = container['#slider-fill'] 
                    local val = slider['#val']
                    local inputbox = container['#input-box']
                    local dcon
                    local acon
                    inputbox.FocusLost:Connect(function(enter, io) 
                        local tx = inputbox.Text
                        local n = tonumber(tx)
                        if (n) then
                            inputbox.Visible = false
                            local fixed = math.clamp(n / 255, 0, 1)
                            local rounded = math.floor((fixed) * 255) / 255
                            local newVal = rounded * 255
                            tween(fill, {Size = UDim2.fromScale(rounded, 1)}, 0.3, 1)
                            val.Text = newVal
                            new.blue = newVal
                            new:displayRGB()
                        elseif (tx == '') then
                            inputbox.Visible = false
                        else
                            inputbox.Text = 'not a valid number'
                            wait(1)
                            inputbox:CaptureFocus()
                        end
                    end)
                    local targetSize
                    container.InputBegan:Connect(function(io) 
                        local inputName = io.UserInputType.Name
                        if (inputName == 'MouseButton1') then
                            local containerPos = container.AbsolutePosition
                            local containerWidth = container.AbsoluteSize.X
                            local startInput do 
                                local position = io.Position
                                startInput = Vector2.new(position.X, position.Y)
                            end
                            local rawValue = math.clamp((startInput - containerPos).X / containerWidth, 0, 1)
                            local roundedValue = math.floor((rawValue) * 255) / 255
                            local newValue = roundedValue * 255 
                            targetSize = UDim2.fromScale(roundedValue, 1)
                            val.Text = newValue
                            new.blue = newValue
                            new:displayRGB()
                            acon = renderService.RenderStepped:Connect(function(dt) 
                                fill.Size = fill.Size:lerp(targetSize, 1 - 1e-12^dt)
                            end)
                            dcon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Name == 'MouseMovement') then
                                    local curInput do 
                                        local position = io.Position
                                        curInput = Vector2.new(position.X, position.Y)
                                    end
                                    local rawValue = math.clamp((curInput - containerPos).X / containerWidth, 0, 1)
                                    local roundedValue = math.floor((rawValue) * 255) / 255
                                    local newValue = roundedValue * 255 
                                    targetSize = UDim2.fromScale(roundedValue, 1)
                                    val.Text = newValue
                                    new.blue = newValue
                                    new:displayRGB()
                                end
                            end)
                        elseif (inputName == 'MouseButton2') then
                            inputbox.Visible = true
                            inputbox:CaptureFocus()
                        end
                    end)
                    container.InputEnded:Connect(function(io) 
                        if (io.UserInputType.Name == 'MouseButton1') then
                            dcon:Disconnect()
                            acon:Disconnect()
                            tween(fill, {Size = targetSize}, 0.2, 1)
                        end
                    end)
                end
                -- value slider
                do 
                    local slider = instances.valSlider
                    local container = slider['#slider-container']
                    local cursor = container['#cursor-inner']
                    local dcon
                    local acon
                    local targetPos
                    container.InputBegan:Connect(function(io) 
                        if (io.UserInputType.Name == 'MouseButton1') then
                            local containerPos = container.AbsolutePosition
                            local containerWidth = container.AbsoluteSize.X
                            local startInput do 
                                local position = io.Position
                                startInput = Vector2.new(position.X, position.Y)
                            end
                            local rawValue = math.clamp((startInput - containerPos).X / containerWidth, 0, 1)
                            targetPos = UDim2.fromScale(rawValue, 0)
                            new.val = rawValue
                            new:displayHSV()
                            acon = renderService.RenderStepped:Connect(function(dt) 
                                cursor.Position = cursor.Position:lerp(targetPos, 1 - 1e-12^dt)
                            end)
                            dcon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Name == 'MouseMovement') then
                                    local curInput do 
                                        local position = io.Position
                                        curInput = Vector2.new(position.X, position.Y)
                                    end
                                    local rawValue = math.clamp((curInput - containerPos).X / containerWidth, 0, 1)
                                    targetPos = UDim2.fromScale(rawValue, 0)
                                    new.val = rawValue
                                    new:displayHSV()
                                end
                            end)
                        end
                    end)
                    container.InputEnded:Connect(function(io) 
                        if (io.UserInputType.Name == 'MouseButton1') then
                            dcon:Disconnect()
                            acon:Disconnect()
                            tween(cursor, {Position = targetPos}, 0.2, 1)
                        end
                    end)
                    container.MouseEnter:Connect(function() 
                        tween(container['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                        tween(container['#value-gradient']['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                        tween(cursor['#stroke'], {Color = theme.Primary}, 0.2, 1)
                    end)
                    container.MouseLeave:Connect(function() 
                        tween(container['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                        tween(container['#value-gradient']['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                        tween(cursor['#stroke'], {Color = Color3.fromRGB(255, 255, 255)}, 0.2, 1)
                    end)
                end
                -- speed slider 
                do 
                    local slider = instances.speedSlider
                    local container = slider['#slider-container']
                    local cursor = container['#cursor-inner']
                    local dcon
                    local acon
                    local targetPos
                    container.InputBegan:Connect(function(io) 
                        if (io.UserInputType.Name == 'MouseButton1') then
                            local containerPos = container.AbsolutePosition
                            local containerHeight = container.AbsoluteSize.Y
                            local startInput do 
                                local position = io.Position
                                startInput = Vector2.new(position.X, position.Y)
                            end
                            local rawValue = math.clamp((startInput - containerPos).Y / containerHeight, 0, 1)
                            targetPos = UDim2.fromScale(0, rawValue)
                            new.linkedPicker.chromaSpeed = 1 - rawValue
                            acon = renderService.RenderStepped:Connect(function(dt) 
                                cursor.Position = cursor.Position:lerp(targetPos, 1 - 1e-12^dt)
                            end)
                            dcon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Name == 'MouseMovement') then
                                    local curInput do 
                                        local position = io.Position
                                        curInput = Vector2.new(position.X, position.Y)
                                    end
                                    local rawValue = math.clamp((curInput - containerPos).Y / containerHeight, 0, 1)
                                    targetPos = UDim2.fromScale(0, rawValue)
                                    new.linkedPicker.chromaSpeed = 1 - rawValue
                                end
                            end)
                        end
                    end)
                    container.InputEnded:Connect(function(io) 
                        if (io.UserInputType.Name == 'MouseButton1') then
                            dcon:Disconnect()
                            acon:Disconnect()
                            tween(cursor, {Position = targetPos}, 0.2, 1)
                        end
                    end)
                    container.MouseEnter:Connect(function() 
                        tween(container['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                        tween(container['#speed-gradient']['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                        tween(cursor['#stroke'], {Color = theme.Primary}, 0.2, 1)
                    end)
                    container.MouseLeave:Connect(function() 
                        tween(container['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                        tween(container['#speed-gradient']['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                        tween(cursor['#stroke'], {Color = Color3.fromRGB(255, 255, 255)}, 0.2, 1)
                    end)
                end
                -- color picker
                do 
                    local picker = instances.colorPicker
                    local cursor = instances.pickerCursor
                    local center = Vector2.new(0.5, 0.5)
                    local targetPos
                    picker.InputBegan:Connect(function(io) 
                        if (io.UserInputType.Name == 'MouseButton1') then
                            new.pickerMoving = true
                            local pickerPos = picker.AbsolutePosition
                            local pickerWidth = picker.AbsoluteSize.X
                            local curInput do 
                                local position = io.Position
                                curInput = Vector2.new(position.X, position.Y)
                            end
                            local x, y do 
                                local fixedPos = curInput - pickerPos
                                x, y = fixedPos.X / pickerWidth, fixedPos.Y / pickerWidth
                            end
                            local radius, theta = cartToPolar(x-0.5, y-0.5)
                            local centerMag = (Vector2.new(x, y) - center).Magnitude
                            if (centerMag > 0.5) then
                                x,y = polarToCart(radius - (centerMag - 0.5), theta)
                                x += 0.5
                                y += 0.5
                                centerMag = (Vector2.new(x, y) - center).Magnitude
                            end
                            targetPos = UDim2.fromScale(x, y)
                            new.hue  = ((theta/math.pi + 2) / 2) % 1
                            new.sat = math.clamp(centerMag*2, 0, 1)
                            new:displayHSV()
                            if (acon) then acon:Disconnect() end
                            acon = renderService.RenderStepped:Connect(function(dt) 
                                cursor.Position = cursor.Position:lerp(targetPos, 1 - 1e-12^dt)
                            end)
                            if (dcon) then dcon:Disconnect() end
                            dcon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Name == 'MouseMovement') then
                                    local curInput do 
                                        local position = io.Position
                                        curInput = Vector2.new(position.X, position.Y)
                                    end
                                    local x, y do 
                                        local fixedPos = curInput - pickerPos
                                        x, y = fixedPos.X / pickerWidth, fixedPos.Y / pickerWidth
                                    end
                                    local radius, theta = cartToPolar(x-0.5, y-0.5)
                                    local centerMag = (Vector2.new(x, y) - center).Magnitude
                                    if (centerMag > 0.5) then
                                        x,y = polarToCart(radius - (centerMag - 0.5), theta)
                                        x += 0.5
                                        y += 0.5
                                        centerMag = (Vector2.new(x, y) - center).Magnitude
                                    end
                                    targetPos = UDim2.fromScale(x, y)
                                    new.hue  = ((theta/math.pi + 2) / 2) % 1
                                    new.sat = math.clamp(centerMag*2, 0, 1)
                                    new:displayHSV()
                                end
                            end)
                        end
                    end)
                    picker.InputEnded:Connect(function(io) 
                        if (io.UserInputType.Name == 'MouseButton1') then
                            new.pickerMoving = false
                            dcon:Disconnect()
                            acon:Disconnect()
                            tween(cursor, {Position = targetPos}, 0.2, 1)
                        end
                    end)
                end
                instances.main.Parent = uiScreen
                new.instances = instances
                return new
            end
            pickerWindow.minimize = function(self) 
                local newState = not self.minimized
                local mf = self.instances.main
                local bmin = mf['#title-bar']['#button-min']
                local bminIcon = bmin['#icon']
                if (newState) then
                    tween(mf, {Size = UDim2.fromOffset(350, 26)}, 0.3, 1)
                    bminIcon.Image = 'rbxassetid://9642646619'
                    tween(bminIcon, {Rotation = 45, ImageColor3 = theme.Primary}, 0.3, 1)
                    if (self.minFocused) then
                        tween(bmin, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                    else
                        tween(bmin, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                    end
                    mf['#region'].Visible = false
                else
                    tween(mf, {Size = UDim2.fromOffset(350, 350)}, 0.3, 1)
                    bminIcon.Image = 'rbxassetid://9642680675'
                    tween(bminIcon, {Rotation = 0, ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.3, 1)
                    if (self.minFocused) then
                        tween(bmin, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                    else
                        tween(bmin, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                    end
                    mf['#region'].Visible = true
                end
                self.minimized = newState
            end
        end
        elemClasses.pickerWindow = pickerWindow
    end
    -- MENU (unchanged)
    do 
        local menu = {} do 
            menu.__index = menu
            setmetatable(menu, elemClasses.baseElement)
            menu.class = 'menu'
            menu.selectorFocused = false
            menu.selected = false
            local instances = {} do 
                local menuFrame = Instance.new('ScrollingFrame') do 
                    menuFrame.AutomaticCanvasSize = 'Y'
                    menuFrame.BackgroundTransparency = 1
                    menuFrame.BorderSizePixel = 0 
                    menuFrame.BottomImage = 'rbxassetid://9416839567'
                    menuFrame.MidImage = 'rbxassetid://9416839567'
                    menuFrame.Name = '#menuFrame'
                    menuFrame.Position = UDim2.fromOffset(1, 1)
                    menuFrame.ScrollBarImageTransparency = 0.9
                    menuFrame.ScrollBarThickness = 1 
                    menuFrame.ScrollingDirection = 'Y'
                    menuFrame.ScrollingEnabled = true
                    menuFrame.Size = UDim2.new(1, -2, 1, -2)
                    menuFrame.TopImage = 'rbxassetid://9416839567'
                    menuFrame.Visible = true
                    menuFrame.ZIndex = 30
                    instances.menuFrame = menuFrame
                    local leftRegion = Instance.new('Frame') do 
                        leftRegion.AutomaticSize = 'Y'
                        leftRegion.BackgroundTransparency = 1 
                        leftRegion.BorderSizePixel = 0
                        leftRegion.Name = '#left-region'
                        leftRegion.Size = UDim2.fromScale(0.5, 0)
                        leftRegion.Visible = true
                        leftRegion.ZIndex = 31
                        leftRegion.Parent = menuFrame
                        local layout = Instance.new('UIListLayout') do 
                            layout.Name = '#layout'
                            layout.Padding = UDim.new(0, 4)
                            layout.FillDirection = 'Vertical'
                            layout.HorizontalAlignment = 'Center'
                            layout.VerticalAlignment = 'Top'
                            layout.Parent = leftRegion
                        end
                        local padding = Instance.new('UIPadding') do 
                            padding.PaddingLeft = UDim.new(0, 1)
                            padding.PaddingTop = UDim.new(0, 3)
                            padding.PaddingBottom = UDim.new(0, 3)
                            padding.Parent = leftRegion
                        end
                    end
                    local rightRegion = Instance.new('Frame') do 
                        rightRegion.BackgroundTransparency = 1 
                        rightRegion.BorderSizePixel = 0
                        rightRegion.Name = '#right-region'
                        rightRegion.Size = UDim2.fromScale(0.5, 1)
                        rightRegion.Position = UDim2.fromScale(0.5, 0)
                        rightRegion.Visible = true
                        rightRegion.ZIndex = 31
                        rightRegion.Parent = menuFrame
                        local layout = Instance.new('UIListLayout') do 
                            layout.Name = '#layout'
                            layout.Padding = UDim.new(0, 4)
                            layout.FillDirection = 'Vertical'
                            layout.HorizontalAlignment = 'Center'
                            layout.VerticalAlignment = 'Top'
                            layout.Parent = rightRegion
                        end
                        local padding = Instance.new('UIPadding') do 
                            padding.PaddingRight = UDim.new(0, 1)
                            padding.PaddingTop = UDim.new(0, 3)
                            padding.PaddingBottom = UDim.new(0, 3)
                            padding.Parent = rightRegion
                        end
                    end
                end
                local pageSelector = Instance.new('TextButton') do 
                    pageSelector.AutoButtonColor = false
                    pageSelector.BackgroundColor3 = theme.Button1
                    pageSelector.BackgroundTransparency = 0
                    pageSelector.Font = 'SourceSans'
                    pageSelector.Name = '#page-selector'
                    pageSelector.Size = UDim2.new(1, -8, 0, 20)
                    pageSelector.Text = ''
                    pageSelector.TextColor3 = theme.TextPrimary
                    pageSelector.TextSize = 17
                    pageSelector.TextStrokeColor3 = theme.TextStroke
                    pageSelector.TextStrokeTransparency = 0.8
                    pageSelector.TextXAlignment = 'Center'
                    pageSelector.TextYAlignment = 'Center'
                    pageSelector.Visible = true
                    pageSelector.ZIndex = 52 
                    instances.pageSelector = pageSelector
                    local round = Instance.new('UICorner') do 
                        round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                        round.Name = '#round'
                        round.Parent = pageSelector
                    end
                    local stroke = Instance.new('UIStroke') do 
                        stroke.ApplyStrokeMode = 'Border'
                        stroke.Color = theme.Stroke
                        stroke.LineJoinMode = 'Round'
                        stroke.Name = '#stroke'
                        stroke.Thickness = 1 
                        stroke.Parent = pageSelector
                    end
                end
            end
            menu.instances = instances 
            menu.select = function(self) 
                for i, m in ipairs(self.window.menus) do 
                    tween(m.instances.menuFrame, {Position = UDim2.new(0, 1, m.id - self.id, 1)}, 0.5, 1)
                    if (m ~= self) then 
                        m:deselect()
                    end
                end
                self.selected = true
                if (self.selectorFocused) then
                    tween(self.instances.pageSelector, {BackgroundColor3 = theme.Button4, TextColor3 = theme.Primary}, 0.2, 1)
                else
                    tween(self.instances.pageSelector, {BackgroundColor3 = theme.Button3, TextColor3 = theme.Primary}, 0.2, 1)
                end
            end
            menu.deselect = function(self) 
                self.selected = false
                if (self.selectorFocused) then
                    tween(self.instances.pageSelector, {BackgroundColor3 = theme.Button2, TextColor3 = theme.TextPrimary}, 0.2, 1)
                else
                    tween(self.instances.pageSelector, {BackgroundColor3 = theme.Button1, TextColor3 = theme.TextPrimary}, 0.2, 1)
                end
            end
            menu.signals = {
                pageSelector = {
                    MouseEnter = function(inst, self) 
                        self.selectorFocused = true
                        local pageSelector = self.instances.pageSelector
                        if (self.selected) then
                            tween(pageSelector, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                        else
                            tween(pageSelector, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        end
                        tween(pageSelector['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, self) 
                        self.selectorFocused = false 
                        local pageSelector = self.instances.pageSelector
                        if (self.selected) then
                            tween(pageSelector, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                        else
                            tween(pageSelector, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        end
                        tween(pageSelector['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end
                }
            }
            menu.new = function(self) 
                local new = setmetatable({}, self)
                new.sections = {}
                new.binds = {}
                local instances = {}
                instances.menuFrame = self.instances.menuFrame:Clone()
                instances.leftRegion = instances.menuFrame['#left-region']
                instances.rightRegion = instances.menuFrame['#right-region']
                instances.pageSelector = self.instances.pageSelector:Clone()
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                new.instances = instances
                return new
            end
            elemClasses.window.addMenu = function(self, settings) 
                if (not typeof(settings) == 'table') then
                    return error('expected table for settings', 2) 
                end
                local s_text = settings.text or 'nil'
                local menu = menu:new()
                menu.window = self
                menu.name = s_text
                table.insert(self.menus, menu)
                menu.id = #self.menus
                if (menu.id == 1) then
                    menu:select()
                end
                local menuTab = menu.instances.pageSelector
                local menuFrame = menu.instances.menuFrame
                menuTab.MouseButton1Click:Connect(function() 
                    menu:select()
                end)
                menuTab.Text = s_text
                menuFrame.Position = UDim2.new(0, 1, menu.id - 1, 1)
                menuTab.Parent = self.instances.tabMenu
                menuFrame.Parent = self.instances.pageRegion
                return menu
            end
        end
        elemClasses.menu = menu
    end
    -- SECTION (unchanged)
    do 
        local section = {} do 
            section.__index = section 
            setmetatable(section, elemClasses.baseElement)
            section.class = 'section'
            section.minimized = false
            section.minFocused = false
            local instances = {} do 
                local sectionFrame = Instance.new('Frame')
                sectionFrame.BackgroundColor3 = theme.Window2
                sectionFrame.BorderColor3 = theme.Inset2
                sectionFrame.BorderMode = 'Inset'
                sectionFrame.BorderSizePixel = 0
                sectionFrame.Name = '#section'
                sectionFrame.AutomaticSize = 'Y'
                sectionFrame.Size = UDim2.new(1, -4, 0, 16)
                sectionFrame.Visible = true
                sectionFrame.ZIndex = 32
                instances.sectionFrame = sectionFrame
                local stroke = Instance.new('UIStroke') do 
                    stroke.ApplyStrokeMode = 'Border'
                    stroke.Color = theme.Stroke
                    stroke.LineJoinMode = 'Round'
                    stroke.Name = '#stroke'
                    stroke.Thickness = 1 
                    stroke.Parent = sectionFrame
                end
                local menu = Instance.new('Frame') do 
                    menu.AutomaticSize = 'Y'
                    menu.BackgroundColor3 = theme.Window2
                    menu.BorderColor3 = theme.Inset2
                    menu.BorderMode = 'Inset'
                    menu.BorderSizePixel = 1
                    menu.Name = '#menu'
                    menu.Visible = true
                    menu.ZIndex = 33
                    menu.Position = UDim2.fromOffset(0, 17)
                    menu.Size = UDim2.fromScale(1, 0)
                    menu.Parent = sectionFrame
                    local layout = Instance.new('UIListLayout') do 
                        layout.FillDirection = 'Vertical'
                        layout.HorizontalAlignment = 'Center'
                        layout.Padding = UDim.new(0, 4)
                        layout.VerticalAlignment = 'Top'
                        layout.Parent = menu
                    end
                    local padding = Instance.new('UIPadding') do 
                        padding.PaddingTop = UDim.new(0, 3)
                        padding.PaddingBottom = UDim.new(0, 3)
                        padding.Parent = menu 
                    end
                end
                local titleBar = Instance.new('Frame') do 
                    titleBar.BackgroundColor3 = theme.Window3
                    titleBar.BorderColor3 = theme.Inset3
                    titleBar.BorderMode = 'Inset'
                    titleBar.BorderSizePixel = 1
                    titleBar.Name = '#title-bar'
                    titleBar.Size = UDim2.new(1, 0, 0, 16)
                    titleBar.Visible = true
                    titleBar.ZIndex = 33
                    titleBar.Parent = sectionFrame
                    local stroke = Instance.new('UIStroke') do 
                        stroke.ApplyStrokeMode = 'Border'
                        stroke.Color = theme.Stroke
                        stroke.LineJoinMode = 'Round'
                        stroke.Name = '#stroke'
                        stroke.Thickness = 1 
                        stroke.Parent = titleBar
                    end
                    local minimize = Instance.new('TextButton') do 
                        minimize.Active = true
                        minimize.AnchorPoint = Vector2.new(1, 0)
                        minimize.AutoButtonColor = false
                        minimize.BackgroundColor3 = theme.Button1
                        minimize.BackgroundTransparency = 0
                        minimize.BorderSizePixel = 0
                        minimize.Name = '#min'
                        minimize.Position = UDim2.new(1, -1, 0, 1)
                        minimize.Size = UDim2.fromOffset(12, 12)
                        minimize.Text = ''
                        minimize.Visible = true
                        minimize.ZIndex = 35
                        minimize.Parent = titleBar
                        local round = Instance.new('UICorner') do 
                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                            round.Name = '#round'
                            round.Parent = minimize
                        end
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = minimize
                        end
                        local icon = Instance.new('ImageLabel') do 
                            icon.Active = false
                            icon.BackgroundTransparency = 1
                            icon.BorderSizePixel = 0
                            icon.Rotation = 180
                            icon.Image = 'rbxassetid://9801471573'
                            icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                            icon.Name = '#icon'
                            icon.Position = UDim2.fromOffset(0, 0)
                            icon.Size = UDim2.fromScale(1, 1)
                            icon.Visible = true
                            icon.ZIndex = 36 
                            icon.Parent = minimize
                            local gradient = Instance.new('UIGradient') do 
                                gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                gradient.Rotation = 90
                                gradient.Enabled = true
                                gradient.Name = '#gradient'
                                gradient.Parent = icon
                            end
                        end
                    end
                    instances.minimizeButton = minimize
                    local title = Instance.new('TextLabel') do 
                        title.BackgroundTransparency = 1
                        title.Font = 'SourceSans'
                        title.Name = '#title'
                        title.RichText = true
                        title.Size = UDim2.fromScale(1, 1)
                        title.Text = 'section'
                        title.TextColor3 = theme.TextPrimary
                        title.TextSize = 14
                        title.TextStrokeColor3 = theme.TextStroke
                        title.TextStrokeTransparency = 0.8
                        title.TextTransparency = 0
                        title.TextWrapped = false
                        title.TextXAlignment = 'Left'
                        title.TextYAlignment = 'Center'
                        title.Visible = true
                        title.ZIndex = 35
                        title.Parent = titleBar
                        instances.title = title 
                        local padding = Instance.new('UIPadding') do 
                            padding.Name = '#padding'
                            padding.PaddingLeft = UDim.new(0, 4)
                            padding.Parent = title
                        end
                    end
                    local trim = Instance.new('Frame') do 
                        trim.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        trim.BackgroundTransparency = 0
                        trim.BorderSizePixel = 0 
                        trim.Name = '#trim'
                        trim.Position = UDim2.fromOffset(-1, -2)
                        trim.Size = UDim2.new(1, 2, 0, 1)
                        trim.ZIndex = 33
                        trim.Parent = titleBar
                        local gradient = Instance.new('UIGradient') do 
                            gradient.Color = ColorSequence.new(theme.Primary, theme.Secondary)
                            gradient.Enabled = true
                            gradient.Name = '#gradient'
                            gradient.Rotation = 0
                            gradient.Parent = trim
                        end
                    end
                end
            end
            section.instances = instances 
            section.minimize = function(self) 
                local newState = not self.minimized
                local mf = self.instances.sectionFrame
                local min = mf['#title-bar']['#min']
                if (newState) then
                    tween(min['#icon'], {Rotation = 0}, 0.3, 1)
                    mf['#menu'].Visible = false
                    mf.AutomaticSize = 'None'
                else
                    tween(min['#icon'], {Rotation = 180}, 0.3, 1)
                    tween(min, {BackgroundColor3 = self.minFocused and theme.Button2 or theme.Button1}, 0.2, 1)
                    mf['#menu'].Visible = true
                    mf.AutomaticSize = 'Y'
                end
                self.minimized = newState
            end
            section.signals = {
                minimizeButton = {
                    mouseButton1Click = function(instance, self)
                        self:minimize()
                    end,
                    MouseEnter = function(instance, self) 
                        self.minFocused = true
                        if (self.minimized) then
                            tween(instance, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                        else
                            tween(instance, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        end
                        tween(instance['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(instance, self) 
                        self.minFocused = false 
                        if (self.minimized) then
                            tween(instance, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                        else
                            tween(instance, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        end
                        tween(instance['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end
                }
            }
            section.new = function(self) 
                local new = setmetatable({}, self)
                new.controls = {}
                new.binds = {}
                local instances = {}
                instances.sectionFrame = self.instances.sectionFrame:Clone()
                instances.title = instances.sectionFrame['#title-bar']['#title']
                instances.minimizeButton = instances.sectionFrame['#title-bar']['#min']
                instances.controlMenu = instances.sectionFrame['#menu']
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                new.instances = instances
                return new
            end
            elemClasses.menu.addSection = function(self, settings) 
                if (not typeof(settings) == 'table') then
                    return error('expected type table for settings', 2) 
                end
                local s_text = settings.text or 'nil'
                local s_side = settings.side or 'auto'
                local s_min do 
                    if (settings.showMinButton == nil) then
                        s_min = true
                    else
                        s_min = settings.showMinButton
                    end 
                end
                local section = section:new()
                section.menu = self
                table.insert(self.sections, section)
                section.id = #self.sections
                section.instances.title.Text = s_text
                do
                    local sectionFrame = section.instances.sectionFrame
                    if (s_side == 'auto') then 
                        if (section.id%2 == 0) then
                            sectionFrame.Parent = self.instances.rightRegion
                        else
                            sectionFrame.Parent = self.instances.leftRegion
                        end
                    else
                        sectionFrame.Parent = self.instances[(s_side == 'left' and 'leftRegion' or 'rightRegion')]
                    end
                    if (not s_min) then
                        section.instances.minimizeButton.Visible = false
                    end
                end
                return section
            end
        end
        elemClasses.section = section
    end
    -- TOGGLE (unchanged)
    do 
        local toggle = {} do 
            toggle.__index = toggle 
            setmetatable(toggle, elemClasses.baseElement)
            toggle.class = 'toggle'
            do
                local instances = {} do 
                    local controlFrame = Instance.new('Frame')
                    controlFrame.BackgroundTransparency = 1
                    controlFrame.Name = '#control'
                    controlFrame.Size = UDim2.new(1, 0, 0, 20)
                    controlFrame.Visible = true
                    controlFrame.ZIndex = 34
                    instances.controlFrame = controlFrame
                    local backToggle = Instance.new('TextButton') do 
                        backToggle.BackgroundTransparency = 1
                        backToggle.Name = '#back-toggle'
                        backToggle.Size = UDim2.fromScale(1, 1)
                        backToggle.Text = ''
                        backToggle.TextTransparency = 1
                        backToggle.ZIndex = 34
                        backToggle.Parent = controlFrame
                        local label = Instance.new('TextLabel') do 
                            label.BackgroundTransparency = 1
                            label.Font = 'SourceSans'
                            label.Name = '#label'
                            label.RichText = true
                            label.Size = UDim2.fromScale(1, 1)
                            label.Text = 'toggle'
                            label.TextColor3 = theme.TextPrimary
                            label.TextSize = 14
                            label.TextStrokeColor3 = theme.TextStroke
                            label.TextStrokeTransparency = 0.8
                            label.TextTransparency = 0
                            label.TextWrapped = false
                            label.TextXAlignment = 'Left'
                            label.TextYAlignment = 'Center'
                            label.Visible = true
                            label.ZIndex = 35
                            label.Parent = backToggle
                            local padding = Instance.new('UIPadding') do 
                                padding.Name = '#padding'
                                padding.PaddingLeft = UDim.new(0, 6)
                                padding.Parent = label
                            end
                        end
                        local toggle = Instance.new('Frame') do 
                            toggle.Active = true
                            toggle.AnchorPoint = Vector2.new(1, 0)
                            toggle.BackgroundColor3 = theme.Button1
                            toggle.Name = '#toggle'
                            toggle.Position = UDim2.new(1, -3, 0, 2)
                            toggle.Size = UDim2.fromOffset(16, 16)
                            toggle.Visible = true
                            toggle.ZIndex = 35
                            toggle.Parent = backToggle
                            local round = Instance.new('UICorner') do 
                                round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                round.Name = '#round'
                                round.Parent = toggle
                            end
                            local stroke = Instance.new('UIStroke') do 
                                stroke.ApplyStrokeMode = 'Border'
                                stroke.Color = theme.Stroke
                                stroke.LineJoinMode = 'Round'
                                stroke.Name = '#stroke'
                                stroke.Thickness = 1 
                                stroke.Parent = toggle
                            end
                            local icon = Instance.new('ImageLabel') do 
                                icon.Active = false
                                icon.BackgroundTransparency = 1
                                icon.BorderSizePixel = 0
                                icon.Image = 'rbxassetid://9801456486'
                                icon.ImageColor3 = theme.Secondary
                                icon.Name = '#icon'
                                icon.Position = UDim2.fromOffset(0, 0)
                                icon.Rotation = 360
                                icon.Size = UDim2.fromScale(1, 1)
                                icon.Visible = true
                                icon.ZIndex = 35 
                                icon.Parent = toggle
                                local gradient = Instance.new('UIGradient') do 
                                    gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                    gradient.Enabled = true
                                    gradient.Name = '#gradient'
                                    gradient.Rotation = 90
                                    gradient.Parent = icon
                                end
                            end
                        end
                    end
                end
                toggle.instances = instances 
            end
            toggle.toggled = false
            toggle.focused = false
            toggle.toggle = function(self) 
                local newState = not self.toggled
                self.toggled = newState
                local toggle = self.instances.toggle
                local icon = toggle['#icon']
                if (newState) then
                    icon.Image = 'rbxassetid://9801457539'
                    tween(icon, {Rotation = 0, ImageColor3 = theme.Primary}, 0.3, 1)
                    if (self.focused) then
                        tween(toggle, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                    else
                        tween(toggle, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                    end
                    self:fireEvent('onEnable')
                else
                    icon.Image = 'rbxassetid://9801456486'
                    tween(icon, {Rotation = 360, ImageColor3 = theme.Secondary}, 0.3, 1)
                    if (self.focused) then
                        tween(toggle, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                    else
                        tween(toggle, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                    end
                    self:fireEvent('onDisable')
                end
                self:fireEvent('onToggle', newState)
                return self
            end
            toggle.__hotkeyFunc = toggle.toggle
            toggle.enable = function(self) 
                self.toggled = true
                local toggle = self.instances.toggle
                local icon = toggle['#icon']
                icon.Image = 'rbxassetid://9801457539'
                tween(icon, {Rotation = 0, ImageColor3 = theme.Primary}, 0.3, 1)
                if (self.focused) then
                    tween(toggle, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                    tween(toggle['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                else
                    tween(toggle, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                    tween(toggle['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                end
                self:fireEvent('onEnable')
                self:fireEvent('onToggle', true)
                return self
            end
            toggle.disable = function(self) 
                self.toggled = false
                local toggle = self.instances.toggle
                local icon = toggle['#icon']
                icon.Image = 'rbxassetid://9801456486'
                tween(icon, {Rotation = 360, ImageColor3 = theme.Secondary}, 0.3, 1)
                if (self.focused) then
                    tween(toggle, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                    tween(toggle['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                else
                    tween(toggle, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                    tween(toggle['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                end
                self:fireEvent('onDisable')
                self:fireEvent('onToggle', false)
                return self
            end
            toggle.reset = function(self) 
                self:toggle()
                self:toggle()
            end
            toggle.signals = {
                backToggle = {
                    MouseEnter = function(inst, toggle) 
                        toggle.focused = true
                        toggle:showTooltip()
                        local togInst = toggle.instances.toggle
                        if (toggle.toggled) then
                            tween(togInst, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                        else
                            tween(togInst, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        end
                        tween(togInst['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, toggle) 
                        toggle.focused = false
                        toggle:hideTooltip()
                        local togInst = toggle.instances.toggle
                        if (toggle.toggled) then
                            tween(togInst, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                        else
                            tween(togInst, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        end
                        tween(togInst['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(inst, toggle) 
                        toggle:toggle()
                    end
                }
            }
            toggle.new = function(self) 
                local new = setmetatable({}, self)
                new.binds = {}
                local instances = {}
                instances.controlFrame = self.instances.controlFrame:Clone()
                instances.backToggle = instances.controlFrame['#back-toggle']
                instances.label = instances.backToggle['#label']
                instances.toggle = instances.backToggle['#toggle']
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                new.instances = instances
                return new
            end
            toggle.getState = function(self) return self.toggled end
            toggle.isEnabled = toggle.getState
            toggle.getValue = toggle.getState
            elemClasses.section.addToggle = function(self, settings, callback) 
                if (not typeof(settings) == 'table') then
                    return error('expected type table for settings', 2) 
                end
                local s_title = settings.text or 'nil'
                local s_state = settings.state or false
                local toggle = toggle:new()
                toggle.section = self 
                toggle.name = s_title
                table.insert(self.controls, toggle)
                toggle.instances.label.Text = s_title
                if (s_state) then 
                    toggle:enable()
                end
                toggle.instances.controlFrame.Parent = self.instances.controlMenu
                if (typeof(callback) == 'function') then
                    toggle:bindToEvent('onToggle', callback) 
                end
                return toggle
            end
        end
        elemClasses.toggle = toggle
    end
    -- BUTTONS (unchanged)
    do
        do 
            local buttonSmall = {} do 
                buttonSmall.__index = buttonSmall 
                setmetatable(buttonSmall, elemClasses.baseElement)
                buttonSmall.class = 'buttonSmall'
                do
                    local instances = {} do 
                        local controlFrame = Instance.new('Frame')
                        controlFrame.BackgroundTransparency = 1
                        controlFrame.Name = '#control'
                        controlFrame.Size = UDim2.new(1, 0, 0, 20)
                        controlFrame.Visible = true
                        controlFrame.ZIndex = 34
                        instances.controlFrame = controlFrame
                        local clickSensor = Instance.new('TextButton') do 
                            clickSensor.BackgroundTransparency = 1
                            clickSensor.Name = '#click-sensor'
                            clickSensor.Size = UDim2.fromScale(1, 1)
                            clickSensor.Text = ''
                            clickSensor.TextTransparency = 1
                            clickSensor.ZIndex = 34
                            clickSensor.Parent = controlFrame
                            local label = Instance.new('TextLabel') do 
                                label.BackgroundTransparency = 1
                                label.Font = 'SourceSans'
                                label.Name = '#label'
                                label.RichText = true
                                label.Size = UDim2.fromScale(1, 1)
                                label.Text = 'button'
                                label.TextColor3 = theme.TextPrimary
                                label.TextSize = 14
                                label.TextStrokeColor3 = theme.TextStroke
                                label.TextStrokeTransparency = 0.8
                                label.TextTransparency = 0
                                label.TextWrapped = false
                                label.TextXAlignment = 'Left'
                                label.TextYAlignment = 'Center'
                                label.Visible = true
                                label.ZIndex = 35
                                label.Parent = clickSensor
                                local padding = Instance.new('UIPadding') do 
                                    padding.Name = '#padding'
                                    padding.PaddingLeft = UDim.new(0, 6)
                                    padding.Parent = label
                                end
                            end
                            local button = Instance.new('Frame') do 
                                button.Active = true
                                button.AnchorPoint = Vector2.new(1, 0)
                                button.BackgroundColor3 = theme.Button1
                                button.Name = '#button'
                                button.Position = UDim2.new(1, -3, 0, 2)
                                button.Size = UDim2.fromOffset(16, 16)
                                button.Visible = true
                                button.ZIndex = 35
                                button.Parent = clickSensor
                                local round = Instance.new('UICorner') do 
                                    round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                    round.Name = '#round'
                                    round.Parent = button
                                end
                                local stroke = Instance.new('UIStroke') do 
                                    stroke.ApplyStrokeMode = 'Border'
                                    stroke.Color = theme.Stroke
                                    stroke.LineJoinMode = 'Round'
                                    stroke.Name = '#stroke'
                                    stroke.Thickness = 1 
                                    stroke.Parent = button
                                end
                                local icon = Instance.new('ImageLabel') do 
                                    icon.Active = false
                                    icon.BackgroundTransparency = 1
                                    icon.BorderSizePixel = 0
                                    icon.Image = 'rbxassetid://9801455339'
                                    icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                                    icon.Name = '#icon'
                                    icon.Position = UDim2.fromOffset(0, 0)
                                    icon.Rotation = 360
                                    icon.Size = UDim2.fromScale(1, 1)
                                    icon.Visible = true
                                    icon.ZIndex = 35 
                                    icon.Parent = button
                                    local gradient = Instance.new('UIGradient') do 
                                        gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                        gradient.Enabled = true
                                        gradient.Name = '#gradient'
                                        gradient.Rotation = 90
                                        gradient.Parent = icon
                                    end
                                end
                            end
                        end
                    end
                    buttonSmall.instances = instances 
                end
                buttonSmall.focused = false
                buttonSmall.click = function(self) 
                    self:fireEvent('onClick')
                    local button = self.instances.button
                    local icon = button['#icon']
                    if (self.focused) then
                        button.BackgroundColor3 = theme.Button4
                        tween(button, {BackgroundColor3 = theme.Button2}, 1, 1)
                    else
                        button.BackgroundColor3 = theme.Button3
                        tween(button, {BackgroundColor3 = theme.Button1}, 1, 1)
                    end
                    icon.ImageColor3 = theme.Primary
                    tween(icon, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 1, 1)
                    return self
                end
                buttonSmall.__hotkeyFunc = buttonSmall.click
                buttonSmall.signals = {
                    clickSensor = {
                        MouseEnter = function(inst, button) 
                            button.focused = true
                            button:showTooltip()
                            local inst = button.instances.button
                            tween(inst, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                            tween(inst['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                        end,
                        MouseLeave = function(inst, button) 
                            button.focused = false
                            button:hideTooltip()
                            local inst = button.instances.button
                            tween(inst, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                            tween(inst['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                        end,
                        MouseButton1Click = function(inst, button) 
                            button:click()
                        end
                    }
                }
                buttonSmall.new = function(self) 
                    local new = setmetatable({}, self)
                    new.binds = {}
                    local instances = {}
                    instances.controlFrame = self.instances.controlFrame:Clone()
                    instances.clickSensor = instances.controlFrame['#click-sensor']
                    instances.label = instances.clickSensor['#label']
                    instances.button = instances.clickSensor['#button']
                    for i, signals in pairs(self.signals) do 
                        local inst = instances[i]
                        for signal, func in pairs(signals) do
                            local h = inst[signal]:Connect(function() 
                                func(inst, new)
                            end)
                        end
                    end
                    new.instances = instances
                    return new
                end
            end
            elemClasses.buttonSmall = buttonSmall
        end
        do 
            local buttonLarge = {} do 
                buttonLarge.__index = buttonLarge 
                setmetatable(buttonLarge, elemClasses.baseElement)
                buttonLarge.class = 'buttonLarge'
                do
                    local instances = {} do 
                        local controlFrame = Instance.new('Frame')
                        controlFrame.BackgroundTransparency = 1
                        controlFrame.Name = '#control'
                        controlFrame.Size = UDim2.new(1, 0, 0, 20)
                        controlFrame.Visible = true
                        controlFrame.ZIndex = 34
                        instances.controlFrame = controlFrame
                        local clickSensor = Instance.new('TextButton') do 
                            clickSensor.BackgroundTransparency = 1
                            clickSensor.Name = '#click-sensor'
                            clickSensor.Size = UDim2.fromScale(1, 1)
                            clickSensor.Text = ''
                            clickSensor.TextTransparency = 1
                            clickSensor.ZIndex = 34
                            clickSensor.Parent = controlFrame
                            local button = Instance.new('Frame') do 
                                button.Active = true
                                button.AnchorPoint = Vector2.new(1, 0)
                                button.BackgroundColor3 = theme.Button1
                                button.Name = '#button'
                                button.Position = UDim2.new(1, -3, 0, 2)
                                button.Size = UDim2.new(1, -6, 0, 16)
                                button.Visible = true
                                button.ZIndex = 35
                                button.Parent = clickSensor
                                local round = Instance.new('UICorner') do 
                                    round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                    round.Name = '#round'
                                    round.Parent = button
                                end
                                local stroke = Instance.new('UIStroke') do 
                                    stroke.ApplyStrokeMode = 'Border'
                                    stroke.Color = theme.Stroke
                                    stroke.LineJoinMode = 'Round'
                                    stroke.Name = '#stroke'
                                    stroke.Thickness = 1 
                                    stroke.Parent = button
                                end
                                local label = Instance.new('TextLabel') do 
                                    label.BackgroundTransparency = 1
                                    label.Font = 'SourceSans'
                                    label.Name = '#label'
                                    label.RichText = true
                                    label.Size = UDim2.fromScale(1, 1)
                                    label.Text = 'button'
                                    label.TextColor3 = theme.TextPrimary
                                    label.TextSize = 14
                                    label.TextStrokeColor3 = theme.TextStroke
                                    label.TextStrokeTransparency = 0.8
                                    label.TextTransparency = 0
                                    label.TextWrapped = false
                                    label.TextXAlignment = 'Center'
                                    label.TextYAlignment = 'Center'
                                    label.Visible = true
                                    label.ZIndex = 35
                                    label.Parent = button
                                end
                            end
                        end
                    end
                    buttonLarge.instances = instances 
                end
                buttonLarge.focused = false
                buttonLarge.click = function(self) 
                    self:fireEvent('onClick')
                    local button = self.instances.button
                    local label = button['#label']
                    if (self.focused) then
                        button.BackgroundColor3 = theme.Button4
                        tween(button, {BackgroundColor3 = theme.Button2}, 1, 1)
                    else
                        button.BackgroundColor3 = theme.Button3
                        tween(button, {BackgroundColor3 = theme.Button1}, 1, 1)
                    end
                    label.TextColor3 = theme.Primary
                    tween(label, {TextColor3 = theme.TextPrimary}, 1, 1)
                    return self
                end
                buttonLarge.__hotkeyFunc = buttonLarge.click
                buttonLarge.signals = {
                    clickSensor = {
                        MouseEnter = function(inst, button) 
                            button.focused = true
                            button:showTooltip()
                            local inst = button.instances.button
                            tween(inst, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                            tween(inst['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                        end,
                        MouseLeave = function(inst, button) 
                            button.focused = false
                            button:hideTooltip()
                            local inst = button.instances.button
                            tween(inst, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                            tween(inst['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                        end,
                        MouseButton1Click = function(inst, button) 
                            button:click()
                        end
                    }
                }
                buttonLarge.new = function(self) 
                    local new = setmetatable({}, self)
                    new.binds = {}
                    local instances = {}
                    instances.controlFrame = self.instances.controlFrame:Clone()
                    instances.clickSensor = instances.controlFrame['#click-sensor']
                    instances.button = instances.clickSensor['#button']
                    instances.label = instances.button['#label']
                    for i, signals in pairs(self.signals) do 
                        local inst = instances[i]
                        for signal, func in pairs(signals) do
                            local h = inst[signal]:Connect(function() 
                                func(inst, new)
                            end)
                        end
                    end
                    new.instances = instances
                    return new
                end
            end
            elemClasses.buttonLarge = buttonLarge
        end
        elemClasses.section.addButton = function(self, settings, callback) 
            if (not typeof(settings) == 'table') then
                return error('expected type table for settings', 2) 
            end
            local s_title = settings.text or 'nil'
            local s_style = settings.style or 'small'
            if (typeof(s_style) == 'number') then
                if (s_style == 2) then
                    s_style = 'large'
                else
                    s_style = 'small'
                end
            elseif (typeof(s_style) ~= 'string') then
                s_style = 'small'
            end
            local new
            if (s_style == 'large') then
                new = elemClasses.buttonLarge:new()
            else
                new = elemClasses.buttonSmall:new()
            end
            new.section = self 
            new.name = s_title
            table.insert(self.controls, new)
            new.instances.label.Text = s_title
            new.instances.controlFrame.Parent = self.instances.controlMenu
            if (typeof(callback) == 'function') then
                new:bindToEvent('onClick', callback) 
            end
            return new
        end
    end
    -- LABEL (unchanged)
    do 
        local label = {} do 
            label.__index = label 
            local instances = {} do 
                local controlFrame = Instance.new('Frame')
                controlFrame.BackgroundTransparency = 1
                controlFrame.Name = '#control'
                controlFrame.Size = UDim2.new(1, 0, 0, 20)
                controlFrame.Visible = true
                controlFrame.ZIndex = 34
                instances.controlFrame = controlFrame
                local label = Instance.new('TextLabel') do 
                    label.BackgroundTransparency = 1
                    label.Font = 'SourceSans'
                    label.Name = '#label'
                    label.RichText = true
                    label.Size = UDim2.fromScale(1, 1)
                    label.Text = 'label'
                    label.TextColor3 = theme.TextPrimary
                    label.TextSize = 14
                    label.TextStrokeColor3 = theme.TextStroke
                    label.TextStrokeTransparency = 0.8
                    label.TextTransparency = 0
                    label.TextWrapped = false
                    label.TextXAlignment = 'Left'
                    label.TextYAlignment = 'Center'
                    label.Visible = true
                    label.ZIndex = 35
                    label.Parent = controlFrame
                    local padding = Instance.new('UIPadding') do 
                        padding.Name = '#padding'
                        padding.PaddingLeft = UDim.new(0, 6)
                        padding.Parent = label
                    end
                end
            end
            label.instances = instances 
            label.new = function(self) 
                local new = setmetatable({}, self)
                new.controls = {}
                local instances = {}
                instances.controlFrame = self.instances.controlFrame:Clone()
                instances.label = instances.controlFrame['#label']
                new.instances = instances
                return new
            end
            label.setText = function(self, newText) 
                self.instances.label.Text = tostring(newText)
                return self
            end
            label.getText = function(self) 
                return self.instances.label.Text
            end
            elemClasses.section.addLabel = function(self, settings) 
                if (not typeof(settings) == 'table') then
                    return error('expected type table for settings', 2) 
                end
                local s_title = settings.text or 'nil'
                local s_center = settings.center or false
                local s_dim = settings.dim or false 
                local label = label:new()
                label.section = self 
                table.insert(self.controls, label)
                local labelInstance = label.instances.label
                labelInstance.Text = s_title
                if (s_dim) then
                    labelInstance.TextColor3 = theme.TextDim 
                end
                if (s_center) then
                    labelInstance.TextXAlignment = 'Center'
                    labelInstance['#padding'].PaddingLeft = UDim.new(0, 0)
                end
                label.instances.controlFrame.Parent = self.instances.controlMenu
                return label
            end
        end
        label.section = section
    end
    -- SLIDER (unchanged)
    do 
        local slider = {} do 
            slider.__index = slider 
            setmetatable(slider, elemClasses.baseElement)
            slider.class = 'slider'
            do
                local instances = {} do 
                    local controlFrame = Instance.new('Frame')
                    controlFrame.BackgroundTransparency = 1
                    controlFrame.Name = '#control'
                    controlFrame.Size = UDim2.new(1, 0, 0, 20)
                    controlFrame.Visible = true
                    controlFrame.ZIndex = 34
                    instances.controlFrame = controlFrame
                    local sliderContainer = Instance.new('Frame') do 
                        sliderContainer.BackgroundColor3 = theme.Button1
                        sliderContainer.Position = UDim2.fromOffset(3, 2)
                        sliderContainer.Size = UDim2.new(1, -6, 0, 16)
                        sliderContainer.Visible = true
                        sliderContainer.ZIndex = 35
                        sliderContainer.Name = '#slider-container'
                        sliderContainer.Parent = controlFrame
                        local round = Instance.new('UICorner') do 
                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                            round.Name = '#round'
                            round.Parent = sliderContainer
                        end
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = sliderContainer
                        end
                        local sliderFill = Instance.new('Frame') do 
                            sliderFill.Active = false
                            sliderFill.BackgroundColor3 = theme.Primary
                            sliderFill.BackgroundTransparency = 0.6
                            sliderFill.BorderSizePixel = 0
                            sliderFill.Name = '#slider-fill'
                            sliderFill.Size = UDim2.fromScale(1, 1)
                            sliderFill.Visible = true
                            sliderFill.ZIndex = 36
                            sliderFill.Parent = sliderContainer
                            local round = Instance.new('UICorner') do 
                                round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                round.Name = '#round'
                                round.Parent = sliderFill
                            end
                            local gradient = Instance.new('UIGradient') do 
                                gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                gradient.Rotation = 90
                                gradient.Enabled = true
                                gradient.Name = '#gradient'
                                gradient.Parent = sliderFill
                            end
                        end
                        local inputBox = Instance.new('TextBox') do 
                            inputBox.Active = true 
                            inputBox.BackgroundColor3 = theme.Window1
                            inputBox.BackgroundTransparency = 0.1
                            inputBox.ClearTextOnFocus = true
                            inputBox.ClipsDescendants = true
                            inputBox.Font = 'SourceSans'
                            inputBox.Name = '#input-box'
                            inputBox.PlaceholderColor3 = theme.TextDim
                            inputBox.PlaceholderText = 'enter value'
                            inputBox.Size = UDim2.fromScale(1, 1)
                            inputBox.Text = 'enter value'
                            inputBox.TextColor3 = theme.TextPrimary
                            inputBox.TextSize = 14
                            inputBox.TextStrokeColor3 = theme.TextStroke
                            inputBox.TextStrokeTransparency = 0.8
                            inputBox.TextWrapped = true
                            inputBox.TextXAlignment = 'Center'
                            inputBox.TextYAlignment = 'Center'
                            inputBox.Visible = false
                            inputBox.ZIndex = 38
                            inputBox.Parent = sliderContainer
                            local round = Instance.new('UICorner') do 
                                round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                round.Name = '#round'
                                round.Parent = inputBox
                            end
                            local stroke = Instance.new('UIStroke') do 
                                stroke.ApplyStrokeMode = 'Border'
                                stroke.Color = theme.Stroke
                                stroke.LineJoinMode = 'Round'
                                stroke.Name = '#stroke'
                                stroke.Thickness = 1 
                                stroke.Parent = inputBox
                            end
                        end
                    end
                    local title = Instance.new('TextLabel') do 
                        title.BackgroundTransparency = 1
                        title.Font = 'SourceSans'
                        title.Name = '#label'
                        title.Size = UDim2.fromScale(1, 1)
                        title.Text = 'slider'
                        title.TextColor3 = theme.TextPrimary
                        title.TextSize = 14
                        title.TextStrokeColor3 = theme.TextStroke
                        title.TextStrokeTransparency = 0.8
                        title.TextTransparency = 0
                        title.TextWrapped = false
                        title.TextXAlignment = 'Left'
                        title.TextYAlignment = 'Center'
                        title.Visible = true
                        title.ZIndex = 37
                        title.Parent = controlFrame
                        local padding = Instance.new('UIPadding') do 
                            padding.PaddingLeft = UDim.new(0, 6)
                            padding.Parent = title
                        end
                    end
                    local val = Instance.new('TextLabel') do 
                        val.BackgroundTransparency = 1
                        val.Font = 'SourceSans'
                        val.Name = '#val'
                        val.Size = UDim2.fromScale(1, 1)
                        val.Text = '0'
                        val.TextColor3 = theme.TextPrimary
                        val.TextSize = 14
                        val.TextStrokeColor3 = theme.TextStroke
                        val.TextStrokeTransparency = 0.8
                        val.TextTransparency = 0
                        val.TextWrapped = false
                        val.TextXAlignment = 'Right'
                        val.TextYAlignment = 'Center'
                        val.Visible = true
                        val.ZIndex = 37
                        val.Parent = controlFrame
                        local padding = Instance.new('UIPadding') do 
                            padding.PaddingRight = UDim.new(0, 6)
                            padding.Parent = val
                        end
                    end
                end
                slider.instances = instances 
            end
            slider.focused = false
            slider.step = 0
            slider.min = 0
            slider.max = 100
            slider.format = '%d'
            slider.signals = {
                container = {
                    MouseEnter = function(inst, win) 
                        win:showTooltip()
                        tween(inst, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        tween(inst['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, win) 
                        win:hideTooltip()
                        tween(inst, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        tween(inst['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end
                }
            }
            slider.new = function(self) 
                local new = setmetatable({}, self)
                new.binds = {}
                local instances = {}
                instances.controlFrame = self.instances.controlFrame:Clone()
                instances.label = instances.controlFrame['#label']
                instances.value = instances.controlFrame['#val']
                instances.container = instances.controlFrame['#slider-container']
                instances.fill = instances.container['#slider-fill']
                instances.input = instances.container['#input-box']
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                do 
                    local slider = instances.container
                    local fill = instances.fill
                    local val = instances.value
                    local inputbox = instances.input
                    local dcon
                    local acon
                    local targetSize
                    inputbox.FocusLost:Connect(function(enter, io) 
                        local tx = inputbox.Text
                        local n = tonumber(tx)
                        if (n) then
                            inputbox.Visible = false
                            local rangeValue = math.clamp(n, new.min, new.max)
                            local roundedValue = math.floor((rangeValue+new.step/2) / new.step) * new.step
                            local fillValue = (roundedValue - new.min) / (new.max - new.min)
                            tween(fill, {Size = UDim2.fromScale(fillValue, 1)}, 0.3, 1)
                            val.Text = new.format:format(roundedValue)
                            new.value = roundedValue
                            new:fireEvent('onNewValue', roundedValue)
                        elseif (tx == '') then
                            inputbox.Visible = false
                        else
                            inputbox.Text = 'not a valid number'
                            wait(1)
                            inputbox:CaptureFocus()
                        end
                    end)
                    slider.InputBegan:Connect(function(io) 
                        local inputName = io.UserInputType.Name
                        if (inputName == 'MouseButton1') then
                            local sliderPos = slider.AbsolutePosition
                            local sliderWidth = slider.AbsoluteSize.X
                            local startInput do 
                                local position = io.Position
                                startInput = Vector2.new(position.X, position.Y)
                            end
                            local rangeValue = math.clamp(((startInput - sliderPos).X / sliderWidth), 0, 1)
                            local scaledValue = rangeValue * (new.max - new.min) + new.min
                            local roundedValue = math.floor((scaledValue+new.step/2) / new.step) * new.step
                            local fillValue = (roundedValue - new.min) / (new.max - new.min)
                            targetSize = UDim2.fromScale(fillValue, 1)
                            val.Text = new.format:format(roundedValue)
                            new.value = roundedValue
                            new:fireEvent('onNewValue', roundedValue)
                            acon = renderService.RenderStepped:Connect(function(dt) 
                                fill.Size = fill.Size:lerp(targetSize, 1 - 1e-12^dt)
                            end)
                            dcon = inputService.InputChanged:Connect(function(io) 
                                if (io.UserInputType.Name == 'MouseMovement') then
                                    local curInput do 
                                        local position = io.Position
                                        curInput = Vector2.new(position.X, position.Y)
                                    end
                                    local rangeValue = math.clamp(((curInput - sliderPos).X / sliderWidth), 0, 1)
                                    local scaledValue = rangeValue * (new.max - new.min) + new.min
                                    local roundedValue = math.floor((scaledValue+new.step/2) / new.step) * new.step
                                    local fillValue = (roundedValue - new.min) / (new.max - new.min)
                                    targetSize = UDim2.fromScale(fillValue, 1)
                                    val.Text = new.format:format(roundedValue)
                                    new.value = roundedValue
                                    new:fireEvent('onNewValue', roundedValue)
                                end
                            end)
                        elseif (inputName == 'MouseButton2') then
                            inputbox.Visible = true
                            inputbox:CaptureFocus()
                        end
                    end)
                    slider.InputEnded:Connect(function(io) 
                        if (io.UserInputType.Name == 'MouseButton1') then
                            dcon:Disconnect()
                            acon:Disconnect()
                            tween(fill, {Size = targetSize}, 0.2, 1)
                        end
                    end)
                end
                new.instances = instances
                return new
            end
            slider.getValue = function(self) 
                return self.value 
            end
            slider.setValue = function(self, value) 
                self.value = value
                self:fireEvent('onNewValue', value)
                local rangeValue = math.clamp(value, self.min, self.max)
                local roundedValue = math.floor((rangeValue+self.step/2) / self.step) * self.step
                local fillValue = (roundedValue - self.min) / (self.max - self.min)
                tween(self.instances.fill, {Size = UDim2.fromScale(fillValue, 1)}, 0.3, 1)
                self.instances.value.Text = self.format:format(roundedValue)
            end
            elemClasses.section.addSlider = function(self, settings, callback) 
                if (not typeof(settings) == 'table') then
                    return error('expected type table for settings', 2) 
                end
                local s_title = settings.text or 'nil'
                local s_min = settings.min or 0
                local s_max = settings.max or 100
                local s_step = settings.step or 1
                local s_value = settings.value or s_min
                if (typeof(s_min) ~= 'number') then
                    return error('expected type \'number\' for setting \'min\'', 2)
                end
                if (typeof(s_max) ~= 'number') then
                    return error('expected type \'number\' for setting \'max\'', 2)
                end
                if (typeof(s_step) ~= 'number') then
                    return error('expected type \'number\' for setting \'step\'', 2)
                end
                if (typeof(s_value) ~= 'number') then
                    return error('expected type \'number\' for setting \'value\'', 2)
                end
                local slider = slider:new()
                slider.section = self 
                slider.name = s_title
                slider.min = s_min
                slider.max = s_max
                slider.step = s_step
                do 
                    if (s_step >= 1) then
                        slider.format = '%d'
                    elseif (s_step >= 0.1) then 
                        slider.format = '%.1f'
                    elseif (s_step >= 0.01) then 
                        slider.format = '%.2f'
                    elseif (s_step >= 0.001) then 
                        slider.format = '%.3f'
                    else 
                        slider.format = '%.4f'
                    end
                end
                table.insert(self.controls, slider)
                slider:setValue(s_value) 
                slider.instances.label.Text = s_title
                slider.instances.controlFrame.Parent = self.instances.controlMenu
                if (typeof(callback) == 'function') then
                    slider:bindToEvent('onNewValue', callback)
                end
                return slider
            end
        end
        elemClasses.slider = slider
    end
    -- COLOR PICKER (unchanged)
    do 
        local picker = {} do 
            picker.__index = picker 
            setmetatable(picker, elemClasses.baseElement)
            picker.class = 'picker'
            do
                local instances = {} do 
                    local controlFrame = Instance.new('Frame') do
                        controlFrame.BackgroundTransparency = 1
                        controlFrame.Name = '#control'
                        controlFrame.Size = UDim2.new(1, 0, 0, 20)
                        controlFrame.Visible = true
                        controlFrame.ZIndex = 34
                    end
                    instances.controlFrame = controlFrame
                    local clickRegion = Instance.new('TextButton') do 
                        clickRegion.BackgroundTransparency = 1
                        clickRegion.Name = '#click-region'
                        clickRegion.Size = UDim2.fromScale(1, 1)
                        clickRegion.Text = ''
                        clickRegion.TextTransparency = 1
                        clickRegion.ZIndex = 34
                        clickRegion.Parent = controlFrame
                        local label = Instance.new('TextLabel') do 
                            label.BackgroundTransparency = 1
                            label.Font = 'SourceSans'
                            label.Name = '#label'
                            label.RichText = true
                            label.Size = UDim2.fromScale(1, 1)
                            label.Text = 'picker'
                            label.TextColor3 = theme.TextPrimary
                            label.TextSize = 14
                            label.TextStrokeColor3 = theme.TextStroke
                            label.TextStrokeTransparency = 0.8
                            label.TextTransparency = 0
                            label.TextWrapped = false
                            label.TextXAlignment = 'Left'
                            label.TextYAlignment = 'Center'
                            label.Visible = true
                            label.ZIndex = 35
                            label.Parent = clickRegion
                            local padding = Instance.new('UIPadding') do 
                                padding.Name = '#padding'
                                padding.PaddingLeft = UDim.new(0, 6)
                                padding.Parent = label
                            end
                        end
                        local picker = Instance.new('Frame') do 
                            picker.Active = true
                            picker.AnchorPoint = Vector2.new(1, 0)
                            picker.BackgroundColor3 = theme.Button1
                            picker.Name = '#picker'
                            picker.Position = UDim2.new(1, -3, 0, 2)
                            picker.Size = UDim2.fromOffset(16, 16)
                            picker.Visible = true
                            picker.ZIndex = 35
                            picker.Parent = clickRegion
                            local round = Instance.new('UICorner') do 
                                round.CornerRadius = UDim.new(1, 0)
                                round.Name = '#round'
                                round.Parent = picker
                            end
                            local stroke = Instance.new('UIStroke') do 
                                stroke.ApplyStrokeMode = 'Border'
                                stroke.Color = theme.Stroke
                                stroke.LineJoinMode = 'Round'
                                stroke.Name = '#stroke'
                                stroke.Thickness = 1 
                                stroke.Parent = picker
                            end
                            local display = Instance.new('Frame') do 
                                display.Active = false
                                display.BorderSizePixel = 0
                                display.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                display.Name = '#display'
                                display.Position = UDim2.fromOffset(2, 2)
                                display.Size = UDim2.fromOffset(12, 12)
                                display.Visible = true
                                display.ZIndex = 35 
                                display.Parent = picker
                                local gradient = Instance.new('UIGradient') do 
                                    gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                    gradient.Rotation = 90
                                    gradient.Enabled = true
                                    gradient.Name = '#gradient'
                                    gradient.Parent = display
                                end
                                local round = Instance.new('UICorner') do 
                                    round.CornerRadius = UDim.new(1, 0)
                                    round.Name = '#round'
                                    round.Parent = display
                                end
                            end
                        end
                    end
                end
                picker.instances = instances 
            end
            picker.color = Color3.fromRGB(255, 255, 255)
            picker.hue = 0
            picker.sat = 0 
            picker.val = 1
            picker.chroma = false
            picker.chromaSpeed = 0.1
            picker.focused = false
            picker.pickerWindow = nil
            picker.openPrompt = function(self) 
                local window = elemClasses.pickerWindow:new()
                local mouseLoc = inputService:GetMouseLocation()
                local screenSize = guiService:GetScreenResolution()
                local new = Vector2.new(math.clamp(mouseLoc.X, 50, screenSize.X - 400), math.clamp(mouseLoc.Y, 50, screenSize.Y - 400))
                window:setPosition(new)
                window.hue = self.hue
                window.sat = self.sat
                window.val = self.val
                window.linkedPicker = self
                window.instances.speedCursor.Position = UDim2.fromScale(0, 1 - self.chromaSpeed)
                window:displayHSV(true)
                window:setTitle(self.name)
                window:bindToEvent('newColor', function(color, HSV) 
                    self.color = color
                    self.hue = HSV[1]
                    self.sat = HSV[2]
                    self.val = HSV[3]
                    self:fireEvent('onNewColor', color)
                    self.instances.display.BackgroundColor3 = color
                end)
                window:bindToEvent('close', function() 
                    if (window.chromaCon) then 
                        window.chromaCon:Disconnect()
                    end
                    self.pickerWindow = nil
                    if (self.chroma) then
                        if (self.chromaCon) then self.chromaCon:Disconnect() end 
                        self.chromaCon = renderService.RenderStepped:Connect(function(dt) 
                            dt *= self.chromaSpeed
                            local hue = self.hue
                            hue += dt
                            hue = (hue > 1 and hue - 1) or hue
                            self.hue = hue 
                            self.color = Color3.fromHSV(hue, self.sat, self.val)
                            self.instances.display.BackgroundColor3 = self.color
                            self:fireEvent('onNewColor', self.color)
                        end)
                    end
                end)
                window:bindToEvent('chroma', function(t) 
                    self.chroma = t 
                    if (t) then
                        if (window.chromaCon) then window.chromaCon:Disconnect() end 
                        if (self.chromaCon) then self.chromaCon:Disconnect() end 
                        window.chromaCon = renderService.RenderStepped:Connect(function(dt) 
                            dt *= self.chromaSpeed
                            if (window.pickerMoving) then 
                                return 
                            end 
                            local hue = window.hue
                            hue += dt
                            hue = (hue > 1 and hue - 1) or hue
                            window.hue = hue
                            window:displayHSV(true)
                        end)
                    else 
                        if (window.chromaCon) then window.chromaCon:Disconnect() end 
                        if (self.chromaCon) then self.chromaCon:Disconnect() end 
                    end
                end)
                if (self.chroma) then 
                    window:toggleChroma()
                end
                task.spawn(function()
                    local instances = window.instances 
                    local main = instances.main 
                    local offsetIndex = 50 * math.random(1,20)
                    main.ZIndex += offsetIndex
                    for i,v in ipairs(main:GetDescendants()) do 
                        if (v:IsA('GuiObject')) then 
                            v.ZIndex += offsetIndex
                        end
                    end
                    local titleBar = instances.titleBar
                    main.Size = UDim2.fromOffset(350, 30)
                    tween(main, {Size = UDim2.fromOffset(350, 350)}, 0.5, 1)
                    task.spawn(function() 
                        local icon = titleBar['#icon']
                        local bClose = titleBar['#button-close']
                        local bMin = titleBar['#button-min']
                        local title = titleBar['#title']
                        local offset = UDim2.fromOffset(50, 0) 
                        bClose.Position += offset
                        bMin.Position += offset
                        icon.Position -= offset
                        title.Position -= offset
                        tween(bClose, {Position = bClose.Position - offset}, 1, 1)
                        tween(bMin, {Position = bMin.Position - offset}, 1, 1)
                        tween(icon, {Position = icon.Position + offset}, 1, 1)
                        tween(title, {Position = title.Position + offset}, 1, 1)
                    end)
                    local fade = titleBar['#fade']
                    fade.BackgroundTransparency = 0
                    fade.Visible = true
                    tween(fade, {BackgroundTransparency = 1}, 2, 1).Completed:Wait()
                end)
                return window
            end
            picker.click = function(self) 
                self:fireEvent('onClick')
                local picker = self.instances.picker
                if (self.focused) then
                    picker.BackgroundColor3 = theme.Button4
                    tween(picker, {BackgroundColor3 = theme.Button2}, 1, 1)
                else
                    picker.BackgroundColor3 = theme.Button3
                    tween(picker, {BackgroundColor3 = theme.Button1}, 1, 1)
                end
                local pickerWindow = self.pickerWindow
                if (pickerWindow) then
                    self.pickerWindow:destroy()
                else
                    self.pickerWindow = self:openPrompt()
                end
                return picker
            end
            picker.__hotkeyFunc = picker.click 
            picker.getColor = function(self) 
                return self.color
            end
            picker.setColor = function(self, color) 
                if (typeof(color) ~= 'Color3') then
                    return error('expected Color3, got ' .. typeof(color), 2)
                end
                self.color = color
                local h,s,v = color:ToHSV()
                self.hue = h
                self.sat = s
                self.val = v 
                self.instances.display.BackgroundColor3 = self.color
            end
            picker.signals = {
                clickRegion = {
                    MouseEnter = function(inst, picker) 
                        picker.focused = true
                        picker:showTooltip()
                        local inst = picker.instances.picker
                        tween(inst, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        tween(inst['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, picker) 
                        picker.focused = false
                        picker:hideTooltip()
                        local inst = picker.instances.picker
                        tween(inst, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        tween(inst['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(inst, picker) 
                        picker:click()
                    end
                }
            }
            picker.new = function(self) 
                local new = setmetatable({}, self)
                new.binds = {}
                local instances = {}
                instances.controlFrame = self.instances.controlFrame:Clone()
                instances.clickRegion = instances.controlFrame['#click-region']
                instances.picker = instances.clickRegion['#picker']
                instances.label = instances.clickRegion['#label']
                instances.display = instances.picker['#display']
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                new.instances = instances
                return new
            end
            elemClasses.section.addColorPicker = function(self, settings, callback) 
                if (not typeof(settings) == 'table') then
                    return error('expected type table for settings', 2) 
                end
                local s_title = settings.text or 'nil'
                local s_color = settings.color or Color3.fromRGB(255, 255, 255)
                local picker = picker:new()
                picker.section = self 
                picker.name = s_title
                table.insert(self.controls, picker)
                picker.instances.label.Text = s_title
                picker:setColor(s_color)
                picker.instances.controlFrame.Parent = self.instances.controlMenu
                if (typeof(callback) == 'function') then
                    picker:bindToEvent('onNewColor', callback) 
                end
                return picker
            end
        end
        elemClasses.picker = picker
    end
    -- TEXTBOX (unchanged)
    do 
        local textbox = {} do 
            textbox.__index = textbox 
            setmetatable(textbox, elemClasses.baseElement)
            textbox.class = 'textbox'
            do
                local instances = {} do 
                    local controlFrame = Instance.new('Frame')
                    controlFrame.BackgroundTransparency = 1
                    controlFrame.BackgroundColor3 = Color3.new(1, 0, 1)
                    controlFrame.Name = '#control'
                    controlFrame.Size = UDim2.new(1, 0, 0, 20)
                    controlFrame.Visible = true
                    controlFrame.ZIndex = 34
                    instances.controlFrame = controlFrame
                    local inputBox = Instance.new('TextBox') do 
                        inputBox.Active = true 
                        inputBox.BackgroundColor3 = theme.Window1
                        inputBox.BackgroundTransparency = 0
                        inputBox.ClearTextOnFocus = true
                        inputBox.ClipsDescendants = true
                        inputBox.Font = 'SourceSans'
                        inputBox.Name = '#textbox'
                        inputBox.PlaceholderColor3 = theme.TextDim
                        inputBox.PlaceholderText = '...'
                        inputBox.Position = UDim2.fromOffset(3, 2)
                        inputBox.Size = UDim2.new(1, -6, 0, 16)
                        inputBox.Text = 'textbox'
                        inputBox.TextColor3 = theme.TextPrimary
                        inputBox.TextSize = 14
                        inputBox.TextStrokeColor3 = theme.TextStroke
                        inputBox.TextStrokeTransparency = 0.8
                        inputBox.TextWrapped = false
                        inputBox.TextXAlignment = 'Left'
                        inputBox.TextYAlignment = 'Center'
                        inputBox.Visible = true
                        inputBox.ZIndex = 35
                        inputBox.Parent = controlFrame
                        local round = Instance.new('UICorner') do 
                            round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                            round.Name = '#round'
                            round.Parent = inputBox
                        end
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Name = '#stroke'
                            stroke.Thickness = 1 
                            stroke.Parent = inputBox
                        end
                        local padding = Instance.new('UIPadding') do 
                            padding.Name = '#padding'
                            padding.PaddingLeft = UDim.new(0, 4)
                            padding.Parent = inputBox
                        end
                    end
                end
                textbox.instances = instances 
            end
            textbox.hovering = false
            textbox.focused = false
            textbox.signals = {
                controlFrame = {
                    MouseEnter = function(inst, obj) 
                        obj.hovering = true
                        obj:showTooltip()
                        local boxInst = obj.instances.textBox
                        if (obj.focused) then
                            tween(boxInst, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                        else
                            tween(boxInst, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        end
                        tween(boxInst['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, obj) 
                        obj.hovering = false
                        obj:hideTooltip()
                        local boxInst = obj.instances.textBox
                        if (obj.focused) then
                            tween(boxInst, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                        else
                            tween(boxInst, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        end
                        tween(boxInst['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                },
                textBox = {
                    Focused = function(inst, obj) 
                        obj.focused = true
                        obj.textUpdCn = inst:GetPropertyChangedSignal('Text'):Connect(function() 
                            obj:fireEvent('onTextChange', inst.Text)
                            obj:fireEvent('__txtUpdInternal', inst.Text)
                        end)
                        if (obj.hovering) then
                            tween(inst, {BackgroundColor3 = theme.Button4, TextColor3 = theme.Primary}, 0.2, 1)
                        else
                            tween(inst, {BackgroundColor3 = theme.Button3, TextColor3 = theme.Primary}, 0.2, 1)
                        end
                        obj:fireEvent('onFocus')
                    end,
                    FocusLost = function(inst, obj) 
                        obj.focused = false
                        if (obj.textUpdCn) then 
                            obj.textUpdCn:Disconnect()
                        end
                        if (obj.hovering) then
                            tween(inst, {BackgroundColor3 = theme.Button2, TextColor3 = theme.TextPrimary}, 0.2, 1)
                        else
                            tween(inst, {BackgroundColor3 = theme.Button1, TextColor3 = theme.TextPrimary}, 0.2, 1)
                        end
                        local inputText = inst.Text
                        inst.Text = obj.name
                        obj:fireEvent('onFocusLost', inputText)
                    end,
                }
            }
            textbox.getText = function(self) 
                return self.instances.textBox.Text
            end
            textbox.setText = function(self, newText) 
                self.instances.textBox.Text = tostring(newText)
                self:fireEvent('onTextChange', newText)
            end
            textbox.new = function(self) 
                local new = setmetatable({}, self)
                new.binds = {}
                local instances = {}
                instances.controlFrame = self.instances.controlFrame:Clone()
                instances.textBox = instances.controlFrame['#textbox']
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function(...) 
                            func(inst, new, ...)
                        end)
                    end
                end
                new.instances = instances
                return new
            end
            elemClasses.section.addTextbox = function(self, settings, callback) 
                if (not typeof(settings) == 'table') then
                    return error('expected type table for settings', 2) 
                end
                local s_title = settings.text or 'nil'
                local new = textbox:new()
                new.section = self 
                new.name = s_title
                table.insert(self.controls, new)
                new.instances.textBox.Text = s_title
                new.instances.controlFrame.Parent = self.instances.controlMenu
                if (typeof(callback) == 'function') then
                    new:bindToEvent('onTextChange', callback)
                end
                return new
            end
        end
        elemClasses.textbox = textbox
    end    
    -- NOTIF (unchanged)
    do 
        local notif = {} do 
            notif.__index = notif
            setmetatable(notif, elemClasses.baseElement) 
            notif.class = 'notif'
            do 
                local instances = {} do                     
                    local main = Instance.new('Frame') do 
                        main.AnchorPoint = Vector2.new(1, 1)
                        main.BackgroundColor3 = theme.Window2
                        main.BackgroundTransparency = 0
                        main.BorderSizePixel = 0
                        main.LayoutOrder = 50
                        main.Name = '#notif-frame'
                        main.Size = UDim2.fromOffset(200, 100)
                        main.Visible = true
                        main.ZIndex = 3000
                    end
                    local scale = Instance.new('UIScale') do 
                        scale.Scale = 1 
                        scale.Name = '#scale'
                        scale.Parent = main
                                        end
                    local backgroundFrame = Instance.new('Frame') do 
                        backgroundFrame.BackgroundTransparency = 0 
                        backgroundFrame.BackgroundColor3 = theme.Window2
                        backgroundFrame.BorderSizePixel = 0 
                        backgroundFrame.Name = '#background'
                        backgroundFrame.Size = UDim2.fromScale(1, 1)
                        backgroundFrame.Visible = true 
                        backgroundFrame.ZIndex = 2999
                        backgroundFrame.Parent = main
                    end
                    local stroke = Instance.new('UIStroke') do 
                        stroke.ApplyStrokeMode = 'Border'
                        stroke.Color = theme.Stroke
                        stroke.LineJoinMode = 'Round'
                        stroke.Thickness = 1 
                        stroke.Name = '#stroke'
                        stroke.Parent = main
                    end
                    local shadow = Instance.new('ImageLabel') do 
                        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
                        shadow.BackgroundTransparency = 1
                        shadow.BorderSizePixel = 0 
                        shadow.Image = 'rbxassetid://7331400934'
                        shadow.ImageColor3 = Color3.fromRGB(0, 0, 5)
                        shadow.Name = '#shadow'
                        shadow.Position = UDim2.fromScale(0.5, 0.5)
                        shadow.ScaleType = 'Slice'
                        shadow.Size = UDim2.new(1, 50, 1, 50)
                        shadow.SliceCenter = Rect.new(40, 40, 260, 260)
                        shadow.SliceScale = 1
                        shadow.ZIndex = 2999
                        shadow.Parent = main
                    end
                    local trim = Instance.new('Frame') do 
                        trim.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        trim.BackgroundTransparency = 0
                        trim.BorderSizePixel = 0 
                        trim.Name = '#trim'
                        trim.Position = UDim2.fromOffset(0, -1)
                        trim.Size = UDim2.new(1, 0, 0, 1)
                        trim.ZIndex = 3005
                        trim.Parent = main
                        local gradient = Instance.new('UIGradient') do 
                            gradient.Color = ColorSequence.new(theme.Primary, theme.Secondary)
                            gradient.Enabled = true
                            gradient.Name = '#gradient'
                            gradient.Rotation = 0
                            gradient.Parent = trim
                        end
                    end
                    local titleBar = Instance.new('Frame') do 
                        titleBar.BackgroundColor3 = theme.Window1
                        titleBar.BackgroundTransparency = 0
                        titleBar.BorderColor3 = theme.Inset1
                        titleBar.BorderMode = 'Inset'
                        titleBar.BorderSizePixel = 1
                        titleBar.ClipsDescendants = true
                        titleBar.Name = '#title-bar'
                        titleBar.Size = UDim2.new(1, 0, 0, 26)
                        titleBar.ZIndex = 3001
                        titleBar.Parent = main 
                        local stroke = Instance.new('UIStroke') do 
                            stroke.ApplyStrokeMode = 'Border'
                            stroke.Color = theme.Stroke
                            stroke.LineJoinMode = 'Round'
                            stroke.Thickness = 1 
                            stroke.Name = '#stroke'
                            stroke.Parent = titleBar
                        end
                        local fade = Instance.new('Frame') do 
                            fade.BackgroundColor3 = theme.Window1
                            fade.BackgroundTransparency = 1
                            fade.BorderColor3 = theme.Inset1
                            fade.BorderMode = 'Inset'
                            fade.BorderSizePixel = 1
                            fade.Name = '#fade'
                            fade.Size = UDim2.new(1, 4, 1, 4)
                            fade.Position = UDim2.fromOffset(-2, -2)
                            fade.Visible = false
                            fade.ZIndex = 3009
                            fade.Parent = titleBar
                        end
                        local icon = Instance.new('ImageLabel') do 
                            icon.BackgroundTransparency = 1
                            icon.BorderSizePixel = 0
                            icon.Image = 'rbxassetid://9865915364'
                            icon.ImageColor3 = theme.Primary
                            icon.ImageTransparency = 0
                            icon.Name = '#icon'
                            icon.Position = UDim2.fromOffset(2, 2)
                            icon.Size = UDim2.fromOffset(22, 22)
                            icon.Visible = true
                            icon.ZIndex = 3002
                            icon.Parent = titleBar
                        end
                        local title = Instance.new('TextLabel') do 
                            title.BackgroundTransparency = 1
                            title.BorderSizePixel = 0
                            title.Font = 'SourceSans'
                            title.Name = '#title'
                            title.Position = UDim2.fromOffset(24, 0)
                            title.RichText = true
                            title.Size = UDim2.new(1, -22, 1, 0)
                            title.Text = 'notification'
                            title.TextColor3 = theme.TextPrimary
                            title.TextScaled = false
                            title.TextSize = 17
                            title.TextStrokeColor3 = theme.TextStroke
                            title.TextStrokeTransparency = 0.8
                            title.TextTransparency = 0
                            title.TextXAlignment = 'Left'
                            title.TextYAlignment = 'Center'
                            title.Visible = true
                            title.ZIndex = 3002 
                            title.Parent = titleBar
                            local padding = Instance.new('UIPadding') do 
                                padding.PaddingLeft = UDim.new(0, 4)
                                padding.Name = '#padding'
                                padding.Parent = title
                            end
                        end
                    end
                    local region = Instance.new('Frame') do 
                        region.BackgroundColor3 = theme.Window2
                        region.BackgroundTransparency = 0
                        region.BorderColor3 = theme.Inset2
                        region.BorderMode = 'Inset'
                        region.BorderSizePixel = 1
                        region.ClipsDescendants = true 
                        region.Name = '#region'
                        region.Position = UDim2.fromOffset(0, 27)
                        region.Size = UDim2.new(1, 0, 1, -27)
                        region.Visible = true
                        region.ZIndex = 3001
                        region.Parent = main
                        local desc = Instance.new('TextLabel') do 
                            desc.BackgroundTransparency = 1
                            desc.BorderSizePixel = 0
                            desc.Font = 'SourceSans'
                            desc.Name = '#desc'
                            desc.RichText = true
                            desc.Size = UDim2.fromScale(1, 1)
                            desc.Text = 'notification'
                            desc.TextColor3 = theme.TextPrimary
                            desc.TextScaled = false
                            desc.TextSize = 14
                            desc.TextStrokeColor3 = theme.TextStroke
                            desc.TextStrokeTransparency = 0.8
                            desc.TextTransparency = 0
                            desc.TextWrapped = true
                            desc.TextXAlignment = 'Left'
                            desc.TextYAlignment = 'Top'
                            desc.Visible = true
                            desc.ZIndex = 3002 
                            desc.Parent = region
                            local padding = Instance.new('UIPadding') do 
                                padding.PaddingLeft = UDim.new(0, 6)
                                padding.PaddingTop = UDim.new(0, 6)
                                padding.Name = '#padding'
                                padding.Parent = desc
                            end
                        end
                    end
                    instances.main = main
                end
                notif.instances = instances 
            end
            notif.destroy = function(self)                 
                local main = self.instances.main
                task.spawn(function()
                    local animCon
                    task.spawn(function() 
                        local backgroundTransparency = {}
                        local imageTransparency = {}
                        local transparency = {}
                        local textTransparency = {}
                        local s = {
                            Frame = {backgroundTransparency}, 
                            ImageButton = {backgroundTransparency, imageTransparency},
                            ImageLabel = {backgroundTransparency, imageTransparency},
                            TextButton = {backgroundTransparency, textTransparency},
                            TextLabel = {backgroundTransparency, textTransparency},
                            UIStroke = {transparency},
                        }
                        local d = main:GetDescendants()
                        table.insert(d, main)
                        for i, v in ipairs(d) do 
                            local a = s[v.ClassName]
                            if (a) then
                                for i = 1, #a do 
                                    table.insert(a[i], v)
                                end
                            end
                        end
                        for i,v in ipairs(transparency) do
                            v.Transparency = 1
                        end
                        transparency = nil
                        scrollBarImageTransparency = nil
                        animCon = renderService.RenderStepped:Connect(function(dt) 
                            dt *= 8
                            for i= 1, #backgroundTransparency do 
                                backgroundTransparency[i].BackgroundTransparency += dt
                            end
                            for i= 1, #imageTransparency do 
                                imageTransparency[i].ImageTransparency += dt
                            end
                            for i= 1, #textTransparency do 
                                textTransparency[i].TextTransparency += dt
                            end
                        end)
                    end)
                    tween(main, {Size = UDim2.fromOffset(main.AbsoluteSize.X, 0)}, 0.5, 1).Completed:Wait()
                    animCon:Disconnect()
                    main:Destroy()
                end)
                return self 
            end
            notif.setTitle = function(self, title) 
                self.instances.title.Text = tostring(title)
                return self 
            end
            notif.setDesc = function(self, text) 
                local desc = self.instances.desc
                local main = self.instances.main
                desc.Text = tostring(text)
                local c = 0
                while (true) do 
                    c += 1 
                    if (c > 31) then
                        break
                    end
                    local _ = desc.TextFits
                    if (desc.TextFits == true) then break end 
                    main.Size += UDim2.fromOffset(0, 20)
                end
                return self 
            end
            notif.new = function(self) 
                local new = setmetatable({}, self)
                new.binds = {}
                local instances = {}
                instances.main = self.instances.main:Clone()
                instances.title = instances.main['#title-bar']['#title']
                instances.desc = instances.main['#region']['#desc']
                instances.main.Parent = uiScreen['#notif-container']
                new.instances = instances
                return new
            end
        end
        elemClasses.notif = notif
    end
    -- HOTKEY (unchanged)
    do 
        local hotkey = {} do 
            hotkey.__index = hotkey
            setmetatable(hotkey, elemClasses.baseElement)
            hotkey.class = 'hotkey'
            do
                local instances = {} do 
                    local controlFrame = Instance.new('Frame')
                    controlFrame.BackgroundTransparency = 1
                    controlFrame.Name = '#control'
                    controlFrame.Size = UDim2.new(1, 0, 0, 20)
                    controlFrame.Visible = true
                    controlFrame.ZIndex = 34
                    instances.controlFrame = controlFrame
                    local back = Instance.new('TextButton') do 
                        back.BackgroundTransparency = 1
                        back.Name = '#back'
                        back.Size = UDim2.fromScale(1, 1)
                        back.Text = ''
                        back.TextTransparency = 1
                        back.ZIndex = 34
                        back.Parent = controlFrame
                        local label = Instance.new('TextLabel') do 
                            label.BackgroundTransparency = 1
                            label.Font = 'SourceSans'
                            label.Name = '#label'
                            label.RichText = true
                            label.Size = UDim2.fromScale(1, 1)
                            label.Text = 'hotkey'
                            label.TextColor3 = theme.TextPrimary
                            label.TextSize = 14
                            label.TextStrokeColor3 = theme.TextStroke
                            label.TextStrokeTransparency = 0.8
                            label.TextTransparency = 0
                            label.TextWrapped = false
                            label.TextXAlignment = 'Left'
                            label.TextYAlignment = 'Center'
                            label.Visible = true
                            label.ZIndex = 35
                            label.Parent = back
                            local padding = Instance.new('UIPadding') do 
                                padding.Name = '#padding'
                                padding.PaddingLeft = UDim.new(0, 6)
                                padding.Parent = label
                            end
                        end
                        local hotkey = Instance.new('TextLabel') do 
                            hotkey.Active = false
                            hotkey.AnchorPoint = Vector2.new(1, 0)
                            hotkey.BackgroundTransparency = 1 
                            hotkey.Font = 'SourceSans'
                            hotkey.Name = '#hotkey'
                            hotkey.Position = UDim2.new(1, -3, 0, 2)
                            hotkey.Size = UDim2.fromOffset(50, 16)
                            hotkey.Text = '[None]'
                            hotkey.TextColor3 = theme.TextDim
                            hotkey.TextScaled = false
                            hotkey.TextSize = 14
                            hotkey.TextStrokeColor3 = theme.TextStroke
                            hotkey.TextStrokeTransparency = 0.8
                            hotkey.TextWrapped = false 
                            hotkey.TextXAlignment = 'Right'
                            hotkey.TextYAlignment = 'Center'
                            hotkey.Visible = true
                            hotkey.ZIndex = 35
                            hotkey.Parent = back
                        end
                    end
                end
                hotkey.instances = instances 
            end
            hotkey.set = nil
            hotkey.hotkey = nil 
            hotkey.focused = false
            hotkey.inputCon = nil 
            hotkey.click = function(self) 
                if (self.inputCon) then return end 
                local display = self.instances.hotkey 
                tween(display, {TextColor3 = theme.Primary}, 0.3, 1)
                self.inputCon = inputService.InputBegan:Connect(function(io, gpe) 
                    local kc = io.KeyCode.Name
                    if (kc == 'Unknown' or kc == 'Escape') then 
                        self.hotkey = nil
                        display.Text = '[None]'
                        self.inputCon:Disconnect()
                        self.inputCon = nil 
                        if (self.focused) then 
                            tween(display, {TextColor3 = theme.TextPrimary}, 0.3, 1)
                        else
                            tween(display, {TextColor3 = theme.TextDim}, 0.3, 1)
                        end
                    else 
                        self.hotkey = io.KeyCode
                        self.set = time()
                        display.Text = ('[%s]'):format(kc)
                        self.inputCon:Disconnect()
                        self.inputCon = nil 
                        if (self.focused) then 
                            tween(display, {TextColor3 = theme.TextPrimary}, 0.3, 1)
                        else
                            tween(display, {TextColor3 = theme.TextDim}, 0.3, 1)
                        end
                    end
                end)
                return self
            end
            hotkey.__hotkeyFunc = hotkey.click
            hotkey.signals = {
                back = {
                    MouseEnter = function(inst, self) 
                        self.focused = true
                        self:showTooltip()
                        if (self.inputCon) then 
                            tween(self.instances.hotkey, {TextColor3 = theme.Primary}, 0.2, 1)
                        else 
                            tween(self.instances.hotkey, {TextColor3 = theme.TextPrimary}, 0.2, 1)
                        end
                    end,
                    MouseLeave = function(inst, self) 
                        self.focused = false
                        self:hideTooltip()
                        if (self.inputCon) then 
                            tween(self.instances.hotkey, {TextColor3 = theme.Primary}, 0.2, 1)
                        else
                            tween(self.instances.hotkey, {TextColor3 = theme.TextDim}, 0.2, 1)
                        end
                    end,
                    MouseButton1Click = function(inst, self) 
                        self:click()
                    end
                }
            }
            hotkey.new = function(self) 
                local new = setmetatable({}, self)
                new.binds = {}
                local instances = {}
                instances.controlFrame = self.instances.controlFrame:Clone()
                instances.back = instances.controlFrame['#back']
                instances.label = instances.back['#label']
                instances.hotkey = instances.back['#hotkey']
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                table.insert(ui.hotkeys, new)
                new.instances = instances
                return new
            end
            hotkey.linkToControl = function(self, control) 
                if (control and control.__hotkeyFunc == nil) then
                    return error('couldn\'t find control function', 2)
                elseif (not control) then 
                    control = nil 
                end
                self.linkedControl = control 
                return self
            end
            hotkey.setHotkey = function(self, hotkey) 
                if (hotkey) then 
                    if (typeof(hotkey) == 'EnumItem') then
                        if (hotkey.EnumType ~= Enum.KeyCode) then
                            return error('expected EnumItem of EnumType KeyCode for hotkey', 2) 
                        end
                    else
                        if (Enum.KeyCode[hotkey]) then
                            hotkey = Enum.KeyCode[hotkey]
                        else
                            return error('expected valid Enum.KeyCode Name, or Enum.KeyCode EnumItem', 2)  
                        end
                    end
                    self.hotkey = hotkey 
                    self.instances.hotkey.Text = ('[%s]'):format(hotkey.Name)
                else
                    self.hotkey = nil
                    self.instances.hotkey.Text = '[None]'
                end
            end
            hotkey.getHotkey = function(self) return self.hotkey end 
            elemClasses.section.addHotkey = function(self, settings) 
                if (not typeof(settings) == 'table') then
                    return error('expected type table for settings', 2) 
                end
                local s_title = settings.text or 'nil'
                local s_bind = settings.bind or nil
                if (s_bind) then 
                    if (typeof(s_bind) == 'EnumItem') then
                        if (s_bind.EnumType ~= Enum.KeyCode) then
                            return error('expected EnumItem of EnumType KeyCode for settings.bind', 2) 
                        end
                    else
                        if (Enum.KeyCode[s_bind]) then
                            s_bind = Enum.KeyCode[s_bind]
                        else
                            return error('expected valid Enum.KeyCode Name, or Enum.KeyCode EnumItem', 2)  
                        end
                    end
                end
                local hotkey = hotkey:new()
                hotkey.section = self 
                hotkey.name = s_title
                table.insert(self.controls, hotkey)
                hotkey.instances.label.Text = s_title
                if (s_bind) then 
                    hotkey:setHotkey(s_bind)
                end
                hotkey.instances.controlFrame.Parent = self.instances.controlMenu
                return hotkey
            end
        end
        elemClasses.hotkey = hotkey
    end
    
    -- DROPDOWN (new)
    do 
        local dropdown = {} do 
            dropdown.__index = dropdown 
            setmetatable(dropdown, elemClasses.baseElement)
            dropdown.class = 'dropdown'
            do
                local instances = {} do 
                    local controlFrame = Instance.new('Frame')
                    controlFrame.BackgroundTransparency = 1
                    controlFrame.Name = '#control'
                    controlFrame.Size = UDim2.new(1, 0, 0, 24)
                    controlFrame.Visible = true
                    controlFrame.ZIndex = 34
                    instances.controlFrame = controlFrame
                    local clickSensor = Instance.new('TextButton') do 
                        clickSensor.BackgroundTransparency = 1
                        clickSensor.Name = '#click-sensor'
                        clickSensor.Size = UDim2.fromScale(1, 1)
                        clickSensor.Text = ''
                        clickSensor.TextTransparency = 1
                        clickSensor.ZIndex = 34
                        clickSensor.Parent = controlFrame
                        local button = Instance.new('Frame') do 
                            button.Active = true
                            button.BackgroundColor3 = theme.Button1
                            button.Name = '#button'
                            button.Position = UDim2.fromOffset(3, 2)
                            button.Size = UDim2.new(1, -6, 0, 20)
                            button.Visible = true
                            button.ZIndex = 35
                            button.Parent = clickSensor
                            local round = Instance.new('UICorner') do 
                                round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                round.Name = '#round'
                                round.Parent = button
                            end
                            local stroke = Instance.new('UIStroke') do 
                                stroke.ApplyStrokeMode = 'Border'
                                stroke.Color = theme.Stroke
                                stroke.LineJoinMode = 'Round'
                                stroke.Name = '#stroke'
                                stroke.Thickness = 1 
                                stroke.Parent = button
                            end
                            local label = Instance.new('TextLabel') do 
                                label.BackgroundTransparency = 1
                                label.Font = 'SourceSans'
                                label.Name = '#label'
                                label.RichText = true
                                label.Size = UDim2.new(1, -20, 1, 0)
                                label.Text = 'dropdown'
                                label.TextColor3 = theme.TextPrimary
                                label.TextSize = 14
                                label.TextStrokeColor3 = theme.TextStroke
                                label.TextStrokeTransparency = 0.8
                                label.TextTransparency = 0
                                label.TextWrapped = false
                                label.TextXAlignment = 'Left'
                                label.TextYAlignment = 'Center'
                                label.Visible = true
                                label.ZIndex = 35
                                label.Parent = button
                                local padding = Instance.new('UIPadding') do 
                                    padding.PaddingLeft = UDim.new(0, 6)
                                    padding.Parent = label
                                end
                            end
                            local icon = Instance.new('ImageLabel') do 
                                icon.AnchorPoint = Vector2.new(1, 0.5)
                                icon.BackgroundTransparency = 1
                                icon.Image = 'rbxassetid://9801473013'
                                icon.ImageColor3 = theme.Secondary
                                icon.Name = '#icon'
                                icon.Position = UDim2.new(1, -6, 0.5, 0)
                                icon.Size = UDim2.fromOffset(12, 12)
                                icon.Visible = true
                                icon.ZIndex = 35
                                icon.Parent = button
                                local gradient = Instance.new('UIGradient') do 
                                    gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                    gradient.Rotation = 90
                                    gradient.Enabled = true
                                    gradient.Name = '#gradient'
                                    gradient.Parent = icon
                                end
                            end
                        end
                        local menu = Instance.new('ScrollingFrame') do 
                            menu.BackgroundColor3 = theme.Window3
                            menu.BorderSizePixel = 0
                            menu.BottomImage = 'rbxassetid://9416839567'
                            menu.ClipsDescendants = true
                            menu.CanvasSize = UDim2.fromOffset(0, 0)
                            menu.MidImage = 'rbxassetid://9416839567'
                            menu.Name = '#menu'
                            menu.Position = UDim2.fromOffset(3, 22)
                            menu.ScrollBarImageTransparency = 0.9
                            menu.ScrollBarThickness = 1
                            menu.ScrollingDirection = 'Y'
                            menu.ScrollingEnabled = true
                            menu.Size = UDim2.new(1, -6, 0, 0)
                            menu.TopImage = 'rbxassetid://9416839567'
                            menu.ZIndex = 34
                            menu.Visible = false
                            menu.Parent = controlFrame
                            local layout = Instance.new('UIListLayout') do 
                                layout.Padding = UDim.new(0, 2)
                                layout.Name = '#layout'
                                layout.FillDirection = 'Vertical'
                                layout.HorizontalAlignment = 'Center'
                                layout.VerticalAlignment = 'Top'
                                layout.SortOrder = 'LayoutOrder'
                                layout.Parent = menu
                            end
                            local padding = Instance.new('UIPadding') do 
                                padding.PaddingTop = UDim.new(0, 4)
                                padding.PaddingBottom = UDim.new(0, 4)
                                padding.Name = '#padding'
                                padding.Parent = menu
                            end
                            local stroke = Instance.new('UIStroke') do 
                                stroke.ApplyStrokeMode = 'Border'
                                stroke.Color = theme.Stroke
                                stroke.LineJoinMode = 'Round'
                                stroke.Name = '#stroke'
                                stroke.Thickness = 1 
                                stroke.Parent = menu
                            end
                        end
                    end
                end
                dropdown.instances = instances 
            end
            dropdown.focused = false
            dropdown.openState = false
            dropdown.options = {}
            dropdown.selectedIndex = 1
            dropdown.selectedValue = nil
            dropdown.onOptionSelected = nil
            
            dropdown.open = function(self) 
                self.openState = true 
                self.instances.menu.Visible = true
                self:fireEvent('onOpen')
                local button = self.instances.button
                if (self.focused) then
                    tween(button, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                else
                    tween(button, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                end
                tween(self.instances.icon, {Rotation = 180, ImageColor3 = theme.Primary}, 0.3, 1)
                local menuHeight = math.min(#self.options * 22 + 8, 132)
                tween(self.instances.menu, {Size = UDim2.new(1, -6, 0, menuHeight)}, 0.2, 1)
                tween(self.instances.controlFrame, {Size = UDim2.new(1, 0, 0, 24 + menuHeight)}, 0.2, 1)
            end
            dropdown.close = function(self) 
                self.openState = false
                self:fireEvent('onClose')
                local button = self.instances.button
                if (self.focused) then
                    tween(button, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                else
                    tween(button, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                end
                tween(self.instances.icon, {Rotation = 0, ImageColor3 = theme.Secondary}, 0.3, 1)
                tween(self.instances.menu, {Size = UDim2.new(1, -6, 0, 0)}, 0.2, 1)
                tween(self.instances.controlFrame, {Size = UDim2.new(1, 0, 0, 24)}, 0.2, 1).Completed:Wait()
                self.instances.menu.Visible = false
            end
            dropdown.setOptions = function(self, options, defaultIndex) 
                for _, opt in ipairs(self.options) do
                    if (opt.button) then opt.button:Destroy() end
                end
                self.options = {}
                local menu = self.instances.menu
                for i, opt in ipairs(options) do
                    local optButton = Instance.new('TextButton')
                    optButton.BackgroundColor3 = theme.Button1
                    optButton.BackgroundTransparency = 0
                    optButton.Font = 'SourceSans'
                    optButton.Size = UDim2.new(1, -4, 0, 20)
                    optButton.Text = tostring(opt)
                    optButton.TextColor3 = theme.TextPrimary
                    optButton.TextSize = 14
                    optButton.TextStrokeColor3 = theme.TextStroke
                    optButton.TextStrokeTransparency = 0.8
                    optButton.ZIndex = 35
                    optButton.Parent = menu
                    local round = Instance.new('UICorner')
                    round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                    round.Parent = optButton
                    local stroke = Instance.new('UIStroke')
                    stroke.ApplyStrokeMode = 'Border'
                    stroke.Color = theme.Stroke
                    stroke.Thickness = 1
                    stroke.Parent = optButton
                    optButton.MouseEnter:Connect(function()
                        tween(optButton, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                    end)
                    optButton.MouseLeave:Connect(function()
                        tween(optButton, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                    end)
                    optButton.MouseButton1Click:Connect(function()
                        self.selectedIndex = i
                        self.selectedValue = opt
                        self.instances.label.Text = tostring(opt)
                        if (self.onOptionSelected) then
                            self.onOptionSelected(opt, i)
                        end
                        self:fireEvent('onSelect', opt, i)
                        self:close()
                    end)
                    table.insert(self.options, {value = opt, button = optButton})
                end
                if (defaultIndex and defaultIndex <= #options) then
                    self.selectedIndex = defaultIndex
                    self.selectedValue = options[defaultIndex]
                    self.instances.label.Text = tostring(options[defaultIndex])
                elseif (#options > 0) then
                    self.selectedIndex = 1
                    self.selectedValue = options[1]
                    self.instances.label.Text = tostring(options[1])
                end
            end
            dropdown.getValue = function(self)
                return self.selectedValue
            end
            dropdown.setValue = function(self, value)
                for i, opt in ipairs(self.options) do
                    if (opt.value == value) then
                        self.selectedIndex = i
                        self.selectedValue = value
                        self.instances.label.Text = tostring(value)
                        break
                    end
                end
            end
            dropdown.click = function(self) 
                if (self.openState) then
                    self:close()
                else
                    self:open()
                end
                return self
            end
            dropdown.__hotkeyFunc = dropdown.click
            dropdown.signals = {
                clickSensor = {
                    MouseEnter = function(inst, self) 
                        self.focused = true
                        self:showTooltip()
                        local button = self.instances.button
                        if (self.openState) then
                            tween(button, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                        else
                            tween(button, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        end
                        tween(button['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, self) 
                        self.focused = false
                        self:hideTooltip()
                        local button = self.instances.button
                        if (self.openState) then
                            tween(button, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                        else
                            tween(button, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        end
                        tween(button['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(inst, self) 
                        self:click()
                    end
                }
            }
            dropdown.new = function(self) 
                local new = setmetatable({}, self)
                new.binds = {}
                new.options = {}
                local instances = {}
                instances.controlFrame = self.instances.controlFrame:Clone()
                instances.clickSensor = instances.controlFrame['#click-sensor']
                instances.button = instances.clickSensor['#button']
                instances.label = instances.button['#label']
                instances.icon = instances.button['#icon']
                instances.menu = instances.controlFrame['#menu']
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                new.instances = instances
                return new
            end
            elemClasses.section.addDropdown = function(self, settings, callback) 
                if (not typeof(settings) == 'table') then
                    return error('expected type table for settings', 2) 
                end
                local s_title = settings.text or 'nil'
                local s_options = settings.options or {}
                local s_default = settings.default or 1
                local dropdown = dropdown:new()
                dropdown.section = self 
                dropdown.name = s_title
                table.insert(self.controls, dropdown)
                dropdown.instances.label.Text = s_title
                dropdown.instances.controlFrame.Parent = self.instances.controlMenu
                dropdown:setOptions(s_options, s_default)
                if (typeof(callback) == 'function') then
                    dropdown.onOptionSelected = callback
                end
                return dropdown
            end
        end
        elemClasses.dropdown = dropdown
    end
    
    -- MULTIDROPDOWN (new)
    do 
        local multidropdown = {} do 
            multidropdown.__index = multidropdown 
            setmetatable(multidropdown, elemClasses.baseElement)
            multidropdown.class = 'multidropdown'
            do
                local instances = {} do 
                    local controlFrame = Instance.new('Frame')
                    controlFrame.BackgroundTransparency = 1
                    controlFrame.Name = '#control'
                    controlFrame.Size = UDim2.new(1, 0, 0, 24)
                    controlFrame.Visible = true
                    controlFrame.ZIndex = 34
                    instances.controlFrame = controlFrame
                    local clickSensor = Instance.new('TextButton') do 
                        clickSensor.BackgroundTransparency = 1
                        clickSensor.Name = '#click-sensor'
                        clickSensor.Size = UDim2.fromScale(1, 1)
                        clickSensor.Text = ''
                        clickSensor.TextTransparency = 1
                        clickSensor.ZIndex = 34
                        clickSensor.Parent = controlFrame
                        local button = Instance.new('Frame') do 
                            button.Active = true
                            button.BackgroundColor3 = theme.Button1
                            button.Name = '#button'
                            button.Position = UDim2.fromOffset(3, 2)
                            button.Size = UDim2.new(1, -6, 0, 20)
                            button.Visible = true
                            button.ZIndex = 35
                            button.Parent = clickSensor
                            local round = Instance.new('UICorner') do 
                                round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                                round.Name = '#round'
                                round.Parent = button
                            end
                            local stroke = Instance.new('UIStroke') do 
                                stroke.ApplyStrokeMode = 'Border'
                                stroke.Color = theme.Stroke
                                stroke.LineJoinMode = 'Round'
                                stroke.Name = '#stroke'
                                stroke.Thickness = 1 
                                stroke.Parent = button
                            end
                            local label = Instance.new('TextLabel') do 
                                label.BackgroundTransparency = 1
                                label.Font = 'SourceSans'
                                label.Name = '#label'
                                label.RichText = true
                                label.Size = UDim2.new(1, -20, 1, 0)
                                label.Text = 'multidropdown'
                                label.TextColor3 = theme.TextPrimary
                                label.TextSize = 14
                                label.TextStrokeColor3 = theme.TextStroke
                                label.TextStrokeTransparency = 0.8
                                label.TextTransparency = 0
                                label.TextWrapped = false
                                label.TextXAlignment = 'Left'
                                label.TextYAlignment = 'Center'
                                label.Visible = true
                                label.ZIndex = 35
                                label.Parent = button
                                local padding = Instance.new('UIPadding') do 
                                    padding.PaddingLeft = UDim.new(0, 6)
                                    padding.Parent = label
                                end
                            end
                            local icon = Instance.new('ImageLabel') do 
                                icon.AnchorPoint = Vector2.new(1, 0.5)
                                icon.BackgroundTransparency = 1
                                icon.Image = 'rbxassetid://9801473013'
                                icon.ImageColor3 = theme.Secondary
                                icon.Name = '#icon'
                                icon.Position = UDim2.new(1, -6, 0.5, 0)
                                icon.Size = UDim2.fromOffset(12, 12)
                                icon.Visible = true
                                icon.ZIndex = 35
                                icon.Parent = button
                                local gradient = Instance.new('UIGradient') do 
                                    gradient.Color = ColorSequence.new(theme.ControlGradient1, theme.ControlGradient2)
                                    gradient.Rotation = 90
                                    gradient.Enabled = true
                                    gradient.Name = '#gradient'
                                    gradient.Parent = icon
                                end
                            end
                        end
                        local menu = Instance.new('ScrollingFrame') do 
                            menu.BackgroundColor3 = theme.Window3
                            menu.BorderSizePixel = 0
                            menu.BottomImage = 'rbxassetid://9416839567'
                            menu.ClipsDescendants = true
                            menu.CanvasSize = UDim2.fromOffset(0, 0)
                            menu.MidImage = 'rbxassetid://9416839567'
                            menu.Name = '#menu'
                            menu.Position = UDim2.fromOffset(3, 22)
                            menu.ScrollBarImageTransparency = 0.9
                            menu.ScrollBarThickness = 1
                            menu.ScrollingDirection = 'Y'
                            menu.ScrollingEnabled = true
                            menu.Size = UDim2.new(1, -6, 0, 0)
                            menu.TopImage = 'rbxassetid://9416839567'
                            menu.ZIndex = 34
                            menu.Visible = false
                            menu.Parent = controlFrame
                            local layout = Instance.new('UIListLayout') do 
                                layout.Padding = UDim.new(0, 2)
                                layout.Name = '#layout'
                                layout.FillDirection = 'Vertical'
                                layout.HorizontalAlignment = 'Center'
                                layout.VerticalAlignment = 'Top'
                                layout.SortOrder = 'LayoutOrder'
                                layout.Parent = menu
                            end
                            local padding = Instance.new('UIPadding') do 
                                padding.PaddingTop = UDim.new(0, 4)
                                padding.PaddingBottom = UDim.new(0, 4)
                                padding.Name = '#padding'
                                padding.Parent = menu
                            end
                            local stroke = Instance.new('UIStroke') do 
                                stroke.ApplyStrokeMode = 'Border'
                                stroke.Color = theme.Stroke
                                stroke.LineJoinMode = 'Round'
                                stroke.Name = '#stroke'
                                stroke.Thickness = 1 
                                stroke.Parent = menu
                            end
                        end
                    end
                end
                multidropdown.instances = instances 
            end
            multidropdown.focused = false
            multidropdown.openState = false
            multidropdown.options = {}
            multidropdown.selectedValues = {}
            multidropdown.onSelectionChanged = nil
            
            multidropdown.open = function(self) 
                self.openState = true 
                self.instances.menu.Visible = true
                self:fireEvent('onOpen')
                local button = self.instances.button
                if (self.focused) then
                    tween(button, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                else
                    tween(button, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                end
                tween(self.instances.icon, {Rotation = 180, ImageColor3 = theme.Primary}, 0.3, 1)
                local menuHeight = math.min(#self.options * 22 + 8, 132)
                tween(self.instances.menu, {Size = UDim2.new(1, -6, 0, menuHeight)}, 0.2, 1)
                tween(self.instances.controlFrame, {Size = UDim2.new(1, 0, 0, 24 + menuHeight)}, 0.2, 1)
            end
            multidropdown.close = function(self) 
                self.openState = false
                self:fireEvent('onClose')
                local button = self.instances.button
                if (self.focused) then
                    tween(button, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                else
                    tween(button, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                end
                tween(self.instances.icon, {Rotation = 0, ImageColor3 = theme.Secondary}, 0.3, 1)
                tween(self.instances.menu, {Size = UDim2.new(1, -6, 0, 0)}, 0.2, 1)
                tween(self.instances.controlFrame, {Size = UDim2.new(1, 0, 0, 24)}, 0.2, 1).Completed:Wait()
                self.instances.menu.Visible = false
            end
            multidropdown.setOptions = function(self, options) 
                for _, opt in ipairs(self.options) do
                    if (opt.button) then opt.button:Destroy() end
                end
                self.options = {}
                self.selectedValues = {}
                local menu = self.instances.menu
                for i, opt in ipairs(options) do
                    local optButton = Instance.new('TextButton')
                    optButton.BackgroundColor3 = theme.Button1
                    optButton.BackgroundTransparency = 0
                    optButton.Font = 'SourceSans'
                    optButton.Size = UDim2.new(1, -4, 0, 20)
                    optButton.Text = tostring(opt)
                    optButton.TextColor3 = theme.TextPrimary
                    optButton.TextSize = 14
                    optButton.TextStrokeColor3 = theme.TextStroke
                    optButton.TextStrokeTransparency = 0.8
                    optButton.ZIndex = 35
                    optButton.Parent = menu
                    local round = Instance.new('UICorner')
                    round.CornerRadius = UDim.new(0, rounding and 2 or 0)
                    round.Parent = optButton
                    local stroke = Instance.new('UIStroke')
                    stroke.ApplyStrokeMode = 'Border'
                    stroke.Color = theme.Stroke
                    stroke.Thickness = 1
                    stroke.Parent = optButton
                    local checkIcon = Instance.new('ImageLabel')
                    checkIcon.AnchorPoint = Vector2.new(1, 0.5)
                    checkIcon.BackgroundTransparency = 1
                    checkIcon.Image = 'rbxassetid://9801457539'
                    checkIcon.ImageColor3 = theme.Primary
                    checkIcon.Name = '#check'
                    checkIcon.Position = UDim2.new(1, -6, 0.5, 0)
                    checkIcon.Size = UDim2.fromOffset(12, 12)
                    checkIcon.Visible = false
                    checkIcon.ZIndex = 36
                    checkIcon.Parent = optButton
                    optButton.MouseEnter:Connect(function()
                        tween(optButton, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                    end)
                    optButton.MouseLeave:Connect(function()
                        tween(optButton, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                    end)
                    optButton.MouseButton1Click:Connect(function()
                        local wasSelected = false
                        for idx, val in ipairs(self.selectedValues) do
                            if (val == opt) then
                                table.remove(self.selectedValues, idx)
                                wasSelected = true
                                break
                            end
                        end
                        if (not wasSelected) then
                            table.insert(self.selectedValues, opt)
                        end
                        checkIcon.Visible = not wasSelected
                        local displayText = (#self.selectedValues > 0) and table.concat(self.selectedValues, ', ') or 'None'
                        self.instances.label.Text = displayText
                        if (self.onSelectionChanged) then
                            self.onSelectionChanged(self.selectedValues)
                        end
                        self:fireEvent('onSelect', self.selectedValues)
                    end)
                    table.insert(self.options, {value = opt, button = optButton, check = checkIcon})
                end
                self.instances.label.Text = 'None'
            end
            multidropdown.getValues = function(self)
                return self.selectedValues
            end
            multidropdown.setValues = function(self, values)
                self.selectedValues = {}
                for _, opt in ipairs(self.options) do
                    opt.check.Visible = false
                end
                for _, val in ipairs(values) do
                    for _, opt in ipairs(self.options) do
                        if (opt.value == val) then
                            table.insert(self.selectedValues, val)
                            opt.check.Visible = true
                            break
                        end
                    end
                end
                local displayText = (#self.selectedValues > 0) and table.concat(self.selectedValues, ', ') or 'None'
                self.instances.label.Text = displayText
                if (self.onSelectionChanged) then
                    self.onSelectionChanged(self.selectedValues)
                end
                self:fireEvent('onSelect', self.selectedValues)
            end
            multidropdown.click = function(self) 
                if (self.openState) then
                    self:close()
                else
                    self:open()
                end
                return self
            end
            multidropdown.__hotkeyFunc = multidropdown.click
            multidropdown.signals = {
                clickSensor = {
                    MouseEnter = function(inst, self) 
                        self.focused = true
                        self:showTooltip()
                        local button = self.instances.button
                        if (self.openState) then
                            tween(button, {BackgroundColor3 = theme.Button4}, 0.2, 1)
                        else
                            tween(button, {BackgroundColor3 = theme.Button2}, 0.2, 1)
                        end
                        tween(button['#stroke'], {Color = theme.StrokeHover}, 0.2, 1)
                    end,
                    MouseLeave = function(inst, self) 
                        self.focused = false
                        self:hideTooltip()
                        local button = self.instances.button
                        if (self.openState) then
                            tween(button, {BackgroundColor3 = theme.Button3}, 0.2, 1)
                        else
                            tween(button, {BackgroundColor3 = theme.Button1}, 0.2, 1)
                        end
                        tween(button['#stroke'], {Color = theme.Stroke}, 0.2, 1)
                    end,
                    MouseButton1Click = function(inst, self) 
                        self:click()
                    end
                }
            }
            multidropdown.new = function(self) 
                local new = setmetatable({}, self)
                new.binds = {}
                new.options = {}
                new.selectedValues = {}
                local instances = {}
                instances.controlFrame = self.instances.controlFrame:Clone()
                instances.clickSensor = instances.controlFrame['#click-sensor']
                instances.button = instances.clickSensor['#button']
                instances.label = instances.button['#label']
                instances.icon = instances.button['#icon']
                instances.menu = instances.controlFrame['#menu']
                for i, signals in pairs(self.signals) do 
                    local inst = instances[i]
                    for signal, func in pairs(signals) do
                        local h = inst[signal]:Connect(function() 
                            func(inst, new)
                        end)
                    end
                end
                new.instances = instances
                return new
            end
            elemClasses.section.addMultiDropdown = function(self, settings, callback) 
                if (not typeof(settings) == 'table') then
                    return error('expected type table for settings', 2) 
                end
                local s_title = settings.text or 'nil'
                local s_options = settings.options or {}
                local s_default = settings.default or {}
                local multidropdown = multidropdown:new()
                multidropdown.section = self 
                multidropdown.name = s_title
                table.insert(self.controls, multidropdown)
                multidropdown.instances.label.Text = s_title
                multidropdown.instances.controlFrame.Parent = self.instances.controlMenu
                multidropdown:setOptions(s_options)
                if (#s_default > 0) then
                    multidropdown:setValues(s_default)
                end
                if (typeof(callback) == 'function') then
                    multidropdown.onSelectionChanged = callback
                end
                return multidropdown
            end
        end
        elemClasses.multidropdown = multidropdown
    end
end

-- UI main object
do
    ui.__index = ui 
    setmetatable(ui, elemClasses.baseElement)
    ui.class = 'ui'
    
    ui.binds = {}
    ui.windows = {}
    ui.pickerWindows = {}
    ui.notifs = {}
    ui.hotkeys = {}
    ui.scriptCns = {}
    ui.autoDisableToggles = true
    
    local windows = ui.windows
    local pickerWindows = ui.pickerWindows
    local notifs = ui.notifs
    
    ui.newWindow = function(settings) 
        if (typeof(settings) ~= 'table') then
            return error('expected type table for settings', 2)
        end
        local s_title = settings.text or 'nil'
        local s_resize = settings.resize == nil and true or settings.resize
        local s_position = settings.position
        if (not s_position) then
            s_position = defaultWinPos
            defaultWinPos += UDim2.fromScale(0.02, 0.02)
        end
        local window = elemClasses.window:new(s_resize)
        local s_winSize = settings.size or window.size
        if (typeof(s_winSize) == 'Vector2') then
            s_winSize = UDim2.fromOffset(s_winSize.X, s_winSize.Y) 
        end
        local s_icon = settings.icon
        if (s_icon) then
            window:setIcon(s_icon) 
        end
        window:setPosition(s_position)
        window:setTitle(s_title)
        window.size = s_winSize
        task.spawn(function()
            local instances = window.instances 
            local mainFrame = instances.mainFrame 
            local titleBar = instances.titleBar
            mainFrame.Size = UDim2.fromOffset(s_winSize.X.Offset, 30)
            tween(mainFrame, {Size = s_winSize}, 0.5, 1)
            task.spawn(function() 
                local icon = titleBar['#icon']
                local bClose = titleBar['#button-close']
                local bMin = titleBar['#button-min']
                local title = titleBar['#title']
                local offset = UDim2.fromOffset(50, 0) 
                bClose.Position += offset
                bMin.Position += offset
                icon.Position -= offset
                title.Position -= offset
                tween(bClose, {Position = bClose.Position - offset}, 1, 1)
                tween(bMin, {Position = bMin.Position - offset}, 1, 1)
                tween(icon, {Position = icon.Position + offset}, 1, 1)
                tween(title, {Position = title.Position + offset}, 1, 1)
            end)
            task.spawn(function()
                local fade = titleBar['#fade']
                fade.BackgroundTransparency = 0
                fade.Visible = true
                tween(fade, {BackgroundTransparency = 1}, 2, 1).Completed:Wait()
                fade.Visible = false 
            end)
        end)
        return window
    end
    
    ui.destroy = function(noWindows)
        ui:fireEvent('onPreDestroy')
        delay(0.4, function() 
            uiScreen:Destroy()
            uiScreen = nil
        end)
        if (noWindows ~= true) then  
            for _, win in ipairs(windows) do 
                win:destroy()
            end
        end
        for i,v in pairs(elemClasses) do 
            if not (v.instances) then continue end 
            for i,v in pairs(v.instances) do 
                v:Destroy() 
            end
        end
        ui.hkCon:Disconnect()
        for _, hotkey in ipairs(ui.hotkeys) do 
            if (hotkey.inputCon) then
                hotkey.inputCon:Disconnect()
            end
        end
        elemClasses = nil 
        tooltip.instances.main:Destroy()
        hint.instances.main:Destroy()
        ui:fireEvent('onDestroy')
        for _, v in pairs(ui.scriptCns) do v:Disconnect() end
    end
    
    ui.setTheme = function(newTheme) 
        if (typeof(newTheme) ~= 'table') then
            return error('expected type table for theme', 2)
        end
        theme = newTheme 
    end
    
    do 
        ui.notify = function(settings)
            if (settings == ui) then
                return error('ui.notify is not a namecall function', 2) 
            end
            local s_title = settings.title or 'nil'
            local s_desc = settings.message or 'nil'
            local s_duration = settings.duration or 2
            if (typeof(s_duration) ~= 'number') then
                return error('expected type \'number\' for setting \'duration\'',2) 
            end
            local startingOffset = 0 do 
                for i, notif in ipairs(notifs) do 
                    startingOffset += notif.size.Y.Offset + 20
                end
            end
            local notif = elemClasses.notif:new()
            local main = notif.instances.main
            main.Position = UDim2.new(4, 0, 1, -startingOffset)
            main.Parent = uiScreen['#notif-container']
            notif:setTitle(s_title)
            notif:setDesc(s_desc)
            notif.size = main.Size
            table.insert(notifs, notif)
            tween(main, {Position = UDim2.new(1, 0, 1, -startingOffset)}, 0.3, 1)
            task.delay(s_duration, function()
                notif:destroy()
                table.remove(notifs, table.find(notifs, notif))
                local mainPos = main.AbsolutePosition.Y
                for i, n in ipairs(notifs) do 
                    local nmain = n.instances.main
                    if (nmain.AbsolutePosition.Y > mainPos) then continue end
                    local p = UDim2.new(1, 0, 1, nmain.Position.Y.Offset + 20 + notif.size.Y.Offset)
                    tween(nmain, {Position = p}, 0.3, 1)
                end
            end)
        end
    end
    
    do 
        local hotkeys = ui.hotkeys
        ui.hkCon = inputService.InputBegan:Connect(function(io, gpe) 
            if ((not gpe) and (io.UserInputType.Name == 'Keyboard')) then
                local kc = io.KeyCode
                for i = 1, #hotkeys do 
                    local hotkey = hotkeys[i]
                    if (hotkey.hotkey == kc and hotkey.set ~= time()) then
                        local linkedControl = hotkey.linkedControl
                        if (linkedControl) then 
                            task.spawn(linkedControl.__hotkeyFunc, linkedControl)
                        end
                    end
                end 
            end
        end)
    end
end

return ui
