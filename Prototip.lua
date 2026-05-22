local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Loader = {}
Loader.__index = Loader

local CONFIG = {
	Logo = "rbxassetid://120245531583106",
	Spinner = "rbxassetid://17687447043",

	Primary = Color3.fromRGB(0,180,255),
	Success = Color3.fromRGB(0,255,140),
	Error = Color3.fromRGB(255,80,80),	

	Background = Color3.fromRGB(19,20,22),
	Card = Color3.fromRGB(24,25,28),

	Width = 320,
	Height = 360
}

local function Tween(obj, info, props)
	local tw = TweenService:Create(obj, info, props)
	tw:Play()
	return tw
end
local function GenerateRandomName()
	local symbols = {
		"Α","Β","Γ","Δ","Ε","Ζ","Η","Θ","Κ","Λ","Μ","Ν","Ξ","Ο","Π","Ρ","Σ","Τ","Υ","Φ","Χ","Ψ","Ω",
		"α","β","γ","δ","ε","ζ","η","θ","ι","κ","λ","μ","ν","ξ","ο","π","ρ","σ","τ","υ","φ","χ","ψ","ω",
		"z","ʎ","x","ʍ","ʌ","n","ʇ","s","ɹ","b","d","o","u","ɯ","l","ʞ","ɾ","ı","ɥ","ƃ","ɟ","ǝ","p","ɔ","q","ɐ",
		"ʁ","є","q","q","ı","q","m","m","Һ","ц","х","ф","ʎ","ɯ","ɔ","d","u","о","н","w","v","ʞ","и","ε","ж","ǝ","6","ɹ","ʚ","g","ɐ",
		"∫","∬","∭","∮","∯","∰","∱","∲","∳",
		"∃","∄","∅","∆","∇","∈","∉","∊","∋","∌","∍","∎","∏","∐","∑","−","∓","∔","∕","∖","∗","∘","∙","√","∛","∜","∝","∟","∠","∡","∢","∣","∤","∥","∦","∧","∨","∩","∪","∴","∵","∶","∷","∸","∹","∺","∻","∼","∽","∾","∿","≀","≁","≂","≃","≄","≅","≆","≇","≈","≉","≊","≋","≌","≍","≎","≏","≐","≑","≒","≓","≔","≕","≖","≗","≘","≙","≚","≛","≜","≝","≞","≟","≠","≡","≢","≣","≤","≥","≦","≧","≨","≩","≪","≫","≬","≭","≮","≯","≰","≱","≲","≳","≴","≵","≶","≷","≸","≹","≺","≻","≼","≽","≽","≾","≿","⊀","⊁","⊂","⊃","⊄","⊅","⊆","⊇","⊈","⊉","⊊","⊋","⊌","⊍","⊎","⊏","⊐","⊑","⊒","⊓","⊔","⊕","⊖","⊗","⊘","⊙","⊚","⊛","⊜","⊝","⊞","⊟","⊠","⊡","⊢","⊣","⊤","⊥","⊦","⊧","⊨","⊩","⊪","⊫","⊬","⊭","⊮","⊯","⊰","⊱","⊲","⊳","⊴","⊵","⊶","⊷","⊸","⊹","⊺","⊻","⊼","⊽","⊾","⊿","⋀","⋁","⋂","⋃","⋄","⋅","⋆","⋇","⋈","⋉","⋊","⋋","⋌","⋍","⋎","⋏","⋐","⋑","⋒","⋓","⋔","⋕","⋖","⋗","⋘","⋙","⋚","⋛","⋜","⋝","⋞","⋟","⋠","⋡","⋢","⋣","⋤","⋥","⋦","⋧","⋨","⋩","⋪","⋫","⋬","⋭","⋮","⋯","⋰","⋱","⋲","⋳","⋴","⋵","⋶","⋷","⋸","⋹","⋺","⋻","⋼","⋽","⋾","⋿","✕","✖","✚"
	}

	local length = math.random(8, 14)
	local result = ""

	for i = 1, length do
		result = result .. symbols[math.random(1, #symbols)]
	end

	return result
end
function Loader.Init()
	if shared.CK_LOADER_INITIALIZED then
		warn("CK Loader already initialized")
		return shared.CK_LOADER_INSTANCE
	end

	shared.CK_LOADER_INITIALIZED = true

	local self = setmetatable({}, Loader)

	self.Loading = true
	self.Destroyed = false

	local Gui = Instance.new("ScreenGui")
	Gui.Name = GenerateRandomName()
	Gui.ResetOnSpawn = false
	Gui.IgnoreGuiInset = true

	local Background = Instance.new("Frame")
	Background.Size = UDim2.new(0, CONFIG.Width, 0, CONFIG.Height)
	Background.Position = UDim2.new(0,0,0,0)
	Background.BackgroundColor3 = CONFIG.Background
	Background.BorderSizePixel = 0
	Background.AnchorPoint = Vector2.new(0.5,0.5)
	Background.Active = true
	Background.Draggable = true

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,12)
	Corner.Parent = Background

	local Content = Instance.new("Frame")
	Content.Size = UDim2.new(0,280,0,314)
	Content.Position = UDim2.new(0.5,-140,0.394,-120)
	Content.BackgroundColor3 = CONFIG.Card
	Content.BorderSizePixel = 0

	local Corner2 = Instance.new("UICorner")
	Corner2.CornerRadius = UDim.new(0,8)
	Corner2.Parent = Content

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(35,36,40)
	Stroke.Parent = Content

	local Logo = Instance.new("ImageLabel")
	Logo.BackgroundTransparency = 1
	Logo.AnchorPoint = Vector2.new(0.5,0.5)
	Logo.Position = UDim2.new(0.5, 0,0.619, -38)
	Logo.Size = UDim2.new(0,145,0,145)
	Logo.Image = CONFIG.Logo
	Logo.ImageTransparency = 1
	Logo.ImageColor3 = CONFIG.Primary

	local Spinner = Instance.new("ImageLabel")
	Spinner.BackgroundTransparency = 1
	Spinner.AnchorPoint = Vector2.new(0.5,0.5)
	Spinner.Position = UDim2.new(0.5,0,0.5,45)
	Spinner.Size = UDim2.new(0,42,0,42)
	Spinner.Image = CONFIG.Spinner
	Spinner.ImageColor3 = CONFIG.Primary
	Spinner.ImageTransparency = 1

	local Status = Instance.new("TextLabel")
	Status.BackgroundTransparency = 1
	Status.Size = UDim2.new(1,0,0,30)
	Status.Position = UDim2.new(0,0,0.5,80)
	Status.Font = Enum.Font.GothamMedium
	Status.TextSize = 15
	Status.TextColor3 = Color3.fromRGB(220,220,220)
	Status.TextTransparency = 1
	Status.Text = "Initializing"

	Logo.Parent = Content
	Spinner.Parent = Content
	Status.Parent = Content

	Content.Parent = Background
	Background.Parent = Gui
	Gui.Parent = PlayerGui

	self.Gui = Gui
	self.Background = Background
	self.Content = Content
	self.Logo = Logo
	self.Spinner = Spinner
	self.Status = Status
	self.Stroke = Stroke

	local success = pcall(function()
		ContentProvider:PreloadAsync({
			Logo,
			Spinner
		})
	end)

	if not success then
		warn("CK Loader preload failed")
	end

	local intro = TweenInfo.new(
		0.8,
		Enum.EasingStyle.Quart,
		Enum.EasingDirection.Out
	)

	Tween(Logo, intro, {
		ImageTransparency = 0
	}).Completed:Wait()

	task.wait(0.2)

	Tween(Logo, TweenInfo.new(
		0.5,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		1,
		true
		), {
			ImageTransparency = 0.35
		}).Completed:Wait()

	Tween(Logo, intro, {
		Position = UDim2.new(0.5,0,0.5,-80),
		Size = UDim2.new(0,72,0,72)
	}).Completed:Wait()

	Tween(Spinner, intro, {
		ImageTransparency = 0
	})

	Tween(Status, intro, {
		TextTransparency = 0
	})

	self.RotationConnection =
		RunService.RenderStepped:Connect(function(dt)
			if self.Destroyed then
				return
			end

			Spinner.Rotation += dt * 180
		end)

	task.spawn(function()
		local dots = 0

		while self.Loading and not self.Destroyed do
			dots = (dots + 1) % 4

			local base = self.BaseText or "Loading"

			Status.Text = base .. string.rep(".", dots)

			task.wait(0.4)
		end
	end)

	shared.CK_LOADER_INSTANCE = self

	return self
end

function Loader:InitilizationDependencies(callback)
	if type(callback) ~= "function" then
		self:Error("Invalid Init Function")
		return false
	end

	local success, result = pcall(callback)

	if success and result == true then
		self:Success("Success!")
		return true
	else
		self:Error("Initialization Failed")
	end
end

function Loader:SetStatus(text)
	self.BaseText = text
	self.Status.Text = text
end

function Loader:Step(text, duration)
	self:SetStatus(text)

	if duration then
		task.wait(duration)
	end
end

function Loader:Success(text)
	self.Loading = false

	self.Status.Text = text or "Loaded!"
	self.Status.TextColor3 = CONFIG.Success

	task.wait(1)

	self:Destroy()
end

function Loader:Error(text)
	self.Loading = false

	self.Status.Text = text or "Initialization Failed"
	self.Status.TextColor3 = CONFIG.Error
end

function Loader:Destroy()
	if self.Destroyed then
		return
	end

	self.Destroyed = true
	self.Loading = false

	if self.RotationConnection then
		self.RotationConnection:Disconnect()
	end

	local fade = TweenInfo.new(
		0.8,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)

	Tween(self.Background, fade, {
		BackgroundTransparency = 1
	})

	Tween(self.Content, fade, {
		BackgroundTransparency = 1
	})

	Tween(self.Stroke, fade, {
		Transparency = 1
	})

	Tween(self.Logo, fade, {
		ImageTransparency = 1
	})

	Tween(self.Spinner, fade, {
		ImageTransparency = 1
	})

	Tween(self.Status, fade, {
		TextTransparency = 1
	})

	task.wait(0.85)

	self.Gui:Destroy()

	shared.CK_LOADER_INITIALIZED = nil
	shared.CK_LOADER_INSTANCE = nil
end

return Loader
