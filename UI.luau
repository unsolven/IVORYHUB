-- Theming and Configuration
local Theme = {
	Colors = {
		PrimaryBackground = Color3.fromRGB(42, 42, 58),
		SecondaryBackground = Color3.fromRGB(40, 45, 62),
		TertiaryBackground = Color3.fromRGB(26, 26, 36),
		TransparentBackground = Color3.fromRGB(40, 45, 62),

		PrimaryAccent = Color3.fromRGB(96, 0, 255),

		Text = Color3.fromRGB(255, 255, 255),
		TextPlaceholder = Color3.fromRGB(155, 155, 155),
		TextMuted = Color3.fromRGB(160, 160, 160),
		TextDark = Color3.fromRGB(5, 6, 23),

		Shadow = Color3.fromRGB(0, 0, 0),
		Stroke = Color3.fromRGB(40, 45, 62),
		Success = Color3.fromRGB(0, 255, 0),

		Gradients = {
			TopBar = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(139, 139, 139)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) }),
			TopBarInner = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(139, 139, 139)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) }),
			ProfileMenu = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(154, 154, 154)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(231, 231, 231)) }),
			ProfileImage = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(213, 213, 213)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) }),
			CloseButton = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(117, 117, 117)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(218, 218, 218)) }),
			MainBar = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(90, 90, 90)), ColorSequenceKeypoint.new(0.23, Color3.fromRGB(154, 154, 154)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) }),
			Logo = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(5, 6, 23)) }),
			Dropdown = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(89, 89, 89)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(139, 139, 139)) }),
			InteractiveBar = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(117, 117, 117)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) }),
			Keybind = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(113, 113, 113)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(194, 194, 194)) }),
			Label = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(166, 166, 166)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) }),
			Slider = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(108, 108, 108)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(232, 232, 232)) }),
			SliderTrack = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(64, 64, 64)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(148, 148, 148)) }),
			SliderFill = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(107, 107, 107)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)) }),
			Toggle = ColorSequence.new({ ColorSequenceKeypoint.new(0.00, Color3.fromRGB(109, 109, 109)), ColorSequenceKeypoint.new(0.77, Color3.fromRGB(181, 181, 181)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(217, 217, 217)) }),
		}
	},
	Transparency = {
		Background = 0.4,
		Shadow = 0.5,
		Invisible = 1,
		Opaque = 0,
	},
	Images = {
		DropShadow = "rbxassetid://6014261993",
		CloseIcon = "rbxassetid://14122651741",
		DefaultLogo = "rbxassetid://14133403065",
	},
	Fonts = {
		SemiBold = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold),
		Bold = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold),
		RegularItalic = Font.new("rbxassetid://11702779517", Enum.FontWeight.Regular, Enum.FontStyle.Italic),
	},
	Radii = {
		Small = UDim.new(0.03, 0),
		Medium = UDim.new(0.1, 0),
		Large = UDim.new(0.2, 0),
		ExtraLarge = UDim.new(0.3, 0),
		Circle = UDim.new(100, 0),
	},
    Sounds = {
        Click = "rbxassetid://12221967",
    }
}

local function Create(instanceType, properties)
    local obj = Instance.new(instanceType)
    local parent = properties.Parent
    properties.Parent = nil
    for prop, value in pairs(properties) do
        obj[prop] = value
    end
    obj.Parent = parent
    return obj
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local UILIB = {}
UILIB.__index = UILIB

local screenGui = Create("ScreenGui", {
	Name = "DrRay",
	Parent = game:GetService("CoreGui"),
	IgnoreGuiInset = true,
	ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local function CreateShadow(parent)
	Create("ImageLabel", {
		Name = "DropShadow",
		Parent = Create("Frame", { Name = "DropShadowHolder", Parent = parent, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 0 }),
		Image = Theme.Images.DropShadow,
		ImageColor3 = Theme.Colors.Shadow,
		ImageTransparency = Theme.Transparency.Shadow,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		Size = UDim2.new(1, 47, 1, 47),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = 0,
	})
end

local topBar = Create("Frame", {
	Name = "TopBar",
	Parent = screenGui,
	Size = UDim2.new(0.54, 0, 0.174, 0),
	Position = UDim2.new(0.23, 0, -0.19, 0),
	BackgroundColor3 = Theme.Colors.PrimaryBackground,
	BorderSizePixel = 0,
	LayoutOrder = 2,
})

Create("UICorner", { Parent = topBar, CornerRadius = Theme.Radii.Medium })
Create("UIGradient", { Parent = topBar, Rotation = 90, Color = Theme.Colors.Gradients.TopBar })
Create("UIAspectRatioConstraint", { Parent = topBar, AspectRatio = 5.725 })
CreateShadow(topBar)

local profileMenu = Create("Frame", {
	Name = "ProfileMenu",
	Parent = topBar,
	Size = UDim2.new(1, 0, 0.465, 0),
	BackgroundTransparency = Theme.Transparency.Invisible,
})

Create("UIListLayout", { Parent = profileMenu, FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0.015, 0) })
Create("UIPadding", { Parent = profileMenu, PaddingLeft = UDim.new(0.014, 0) })

local titleLabel = Create("ImageButton", {
	Name = "Title",
	Parent = profileMenu,
	Size = UDim2.new(0.235, 0, 0.682, 0),
	BackgroundColor3 = Theme.Colors.PrimaryBackground,
	AutoButtonColor = false,
})
Create("UICorner", { Parent = titleLabel, CornerRadius = Theme.Radii.ExtraLarge })
Create("UIGradient", { Parent = titleLabel, Rotation = 90, Color = Theme.Colors.Gradients.ProfileMenu })
Create("TextLabel", {
	Parent = titleLabel,
	Text = "DarkRay",
	FontFace = Theme.Fonts.SemiBold,
	TextColor3 = Theme.Colors.Text,
	TextScaled = true,
	TextWrapped = true,
	Size = UDim2.new(0.72, 0, 0.415, 0),
	Position = UDim2.new(0.134, 0, 0.273, 0),
	BackgroundTransparency = Theme.Transparency.Invisible,
})

local playerProfile = Create("ImageButton", {
	Name = "PlayerProfile",
	Parent = profileMenu,
	Size = UDim2.new(0.235, 0, 0.682, 0),
	Position = UDim2.new(0.015, 0, 0.184, 0),
	BackgroundColor3 = Theme.Colors.PrimaryBackground,
	AutoButtonColor = false,
})
Create("UICorner", { Parent = playerProfile, CornerRadius = Theme.Radii.ExtraLarge })
Create("UIGradient", { Parent = playerProfile, Rotation = 90, Color = Theme.Colors.Gradients.ProfileMenu })
local playerImage = Create("ImageLabel", {
	Parent = playerProfile,
	Size = UDim2.new(0.166, 0, 0.803, 0),
	Position = UDim2.new(0.038, 0, 0.142, 0),
	BackgroundColor3 = Theme.Colors.PrimaryBackground,
})
Create("UICorner", { Parent = playerImage, CornerRadius = Theme.Radii.Circle })
Create("UIAspectRatioConstraint", { Parent = playerImage, AspectRatio = 1 })
Create("UIGradient", { Parent = playerImage, Rotation = 90, Color = Theme.Colors.Gradients.ProfileImage })
Create("TextLabel", {
	Parent = playerProfile,
	Text = LocalPlayer.DisplayName,
	FontFace = Theme.Fonts.SemiBold,
	TextColor3 = Theme.Colors.Text,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextScaled = true,
	TextWrapped = true,
	Size = UDim2.new(0.72, 0, 0.415, 0),
	Position = UDim2.new(0.24, 0, 0.273, 0),
	BackgroundTransparency = Theme.Transparency.Invisible,
})

local clock = Create("ImageButton", {
	Name = "Clock",
	Parent = profileMenu,
	Size = UDim2.new(0.103, 0, 0.682, 0),
	BackgroundColor3 = Theme.Colors.PrimaryBackground,
	AutoButtonColor = false,
})
Create("UICorner", { Parent = clock, CornerRadius = Theme.Radii.ExtraLarge })
Create("UIGradient", { Parent = clock, Rotation = 90, Color = Theme.Colors.Gradients.ProfileMenu })
local clockText = Create("TextLabel", {
	Parent = clock,
	Text = os.date("%H:%M"),
	FontFace = Theme.Fonts.SemiBold,
	TextColor3 = Theme.Colors.Text,
	TextScaled = true,
	TextWrapped = true,
	Size = UDim2.new(0.332, 0, 0.415, 0),
	Position = UDim2.new(0.215, 0, 0.273, 0),
	BackgroundTransparency = Theme.Transparency.Invisible,
})

local topBarStripe = Create("Frame", {
	Name = "TopBarStripe",
	Parent = topBar,
	Size = UDim2.new(1, 0, 0.055, 0),
	Position = UDim2.new(0, 0, 0.465, 0),
	BackgroundColor3 = Theme.Colors.PrimaryBackground,
	BorderSizePixel = 0,
})
Create("UIGradient", { Parent = topBarStripe, Rotation = -90, Color = Theme.Colors.Gradients.TopBarInner })

local tabContainer = Create("ScrollingFrame", {
	Name = "TabContainer",
	Parent = topBar,
	Size = UDim2.new(0.916, 0, 0.52, 0),
	Position = UDim2.new(0, 0, 0.48, 0),
	BackgroundTransparency = Theme.Transparency.Invisible,
	BackgroundColor3 = Theme.Colors.TertiaryBackground,
	ScrollingDirection = Enum.ScrollingDirection.X,
	AutomaticCanvasSize = Enum.AutomaticSize.X,
	ScrollBarThickness = 0,
	Active = true,
})
Create("UIListLayout", { Parent = tabContainer, FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0.01, 0) })
Create("UIPadding", { Parent = tabContainer, PaddingLeft = UDim.new(0.015, 0) })

local closeButton = Create("TextButton", {
	Name = "TopBarClose",
	Parent = topBar,
	Text = "",
	Size = UDim2.new(0.084, 0, 0.48, 0),
	Position = UDim2.new(0.916, 0, 0.52, 0),
	BackgroundColor3 = Theme.Colors.PrimaryBackground,
	AutoButtonColor = false,
})
Create("UICorner", { Parent = closeButton, CornerRadius = Theme.Radii.Large })
Create("UIGradient", { Parent = closeButton, Rotation = 90, Color = Theme.Colors.Gradients.CloseButton })
Create("UIAspectRatioConstraint", { Parent = closeButton })
local closeButtonIcon = Create("ImageLabel", {
	Parent = closeButton,
	Image = Theme.Images.CloseIcon,
	Size = UDim2.new(0.5, 0, 0.6, 0),
	Position = UDim2.new(0.25, 0, 0.23, 0),
	BackgroundTransparency = 1,
})
Create("UIAspectRatioConstraint", { Parent = closeButtonIcon })

local mainBar = Create("Frame", {
	Name = "MainBar",
	Parent = screenGui,
	Size = UDim2.new(0.54, 0, 0.575, 0),
	Position = UDim2.new(0.23, 0, -0.612, 0),
	BackgroundColor3 = Theme.Colors.PrimaryBackground,
	BorderSizePixel = 0,
})

Create("UICorner", { Parent = mainBar, CornerRadius = Theme.Radii.Small })
Create("UIGradient", { Parent = mainBar, Rotation = 90, Color = Theme.Colors.Gradients.MainBar })
Create("UIAspectRatioConstraint", { Parent = mainBar, AspectRatio = 1.733 })
CreateShadow(mainBar)

local logoImage = Create("ImageLabel", {
	Name = "Logo",
	Parent = mainBar,
	Image = Theme.Images.DefaultLogo,
	Size = UDim2.new(0.187, 0, 0.325, 0),
	Position = UDim2.new(0.399, 0, 0.334, 0),
	BackgroundTransparency = 1,
})
Create("UIGradient", { Parent = logoImage, Rotation = 90, Color = Theme.Colors.Gradients.Logo })

local templates = Create("Folder", { Name = "Templates", Parent = screenGui })

local tabTemplate = Create("ScrollingFrame", {
	Name = "TabTemplate",
	Parent = templates,
	Visible = false,
	Size = UDim2.new(1, 0, 0.96, 0),
	Position = UDim2.new(0, 0, 0.04, 0),
	BackgroundTransparency = 1,
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollBarThickness = 0,
	Active = true,
})
Create("UIListLayout", { Parent = tabTemplate, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0.015, 0) })

local tabButtonTemplate = Create("ImageButton", {
	Name = "TabButtonTemplate",
	Parent = templates,
	Visible = false,
	Size = UDim2.new(0.199, 0, 0.632, 0),
	BackgroundColor3 = Theme.Colors.PrimaryBackground,
	AutoButtonColor = false,
})
Create("UICorner", { Parent = tabButtonTemplate, CornerRadius = Theme.Radii.ExtraLarge })
Create("UIGradient", { Parent = tabButtonTemplate, Rotation = 90, Color = Theme.Colors.Gradients.ProfileMenu })
Create("UIListLayout", { Parent = tabButtonTemplate, FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center })
Create("UIPadding", { Parent = tabButtonTemplate, PaddingLeft = UDim.new(0.11, 0) })
Create("ImageLabel", {
	Parent = tabButtonTemplate,
	Size = UDim2.new(0.2, 0, 0.6, 0),
	Position = UDim2.new(0.11, 0, 0.2, 0),
	BackgroundTransparency = 1,
})
local tabButtonTextContainer = Create("Frame", { Parent = tabButtonTemplate, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0) })
Create("UIListLayout", { Parent = tabButtonTextContainer, FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, HorizontalAlignment = Enum.HorizontalAlignment.Center })
Create("TextLabel", {
	Parent = tabButtonTextContainer,
	Text = "Tab1",
	FontFace = Theme.Fonts.Bold,
	TextColor3 = Theme.Colors.Text,
	TextScaled = true,
	TextWrapped = true,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.new(0, 0, 0.415, 0),
	BackgroundTransparency = 1,
})

local function createBaseComponent(name)
	local frame = Create("Frame", {
		Name = name,
		Parent = templates,
		Visible = false,
		Size = UDim2.new(0.96, 0, 0, 0),
		Position = UDim2.new(0.02, 0, 0.12, 0),
		BackgroundColor3 = Theme.Colors.TransparentBackground,
		BackgroundTransparency = Theme.Transparency.Background,
		AutomaticSize = Enum.AutomaticSize.Y
	})
	Create("UICorner", { Parent = frame, CornerRadius = UDim.new(0.04, 0) })
	Create("TextLabel", { Name = "Title", Parent = frame, Text = name, FontFace = Theme.Fonts.Bold, TextColor3 = Theme.Colors.Text, TextXAlignment = Enum.TextXAlignment.Left, TextScaled = true, Size = UDim2.new(0.96, 0, 0.19, 0), Position = UDim2.new(0.02, 0, 0.11, 0), BackgroundTransparency = 1 })
	Create("TextLabel", { Name = "Description", Parent = frame, Text = "Description", FontFace = Theme.Fonts.RegularItalic, TextColor3 = Theme.Colors.Text, TextXAlignment = Enum.TextXAlignment.Left, TextScaled = true, Size = UDim2.new(0.96, 0, 0.15, 0), Position = UDim2.new(0.01, 0, 0.75, 0), BackgroundTransparency = 1 })
	return frame
end

local function createInteractiveBar(parent)
    local bar = Create("Frame", {
        Parent = parent,
        Size = UDim2.new(0.97, 0, 0.29, 0),
        Position = UDim2.new(0.015, 0, 0.34, 0),
        BackgroundColor3 = Theme.Colors.SecondaryBackground,
        LayoutOrder = 10
    })
    Create("UICorner", { Parent = bar, CornerRadius = Theme.Radii.Large })
    Create("UIGradient", { Parent = bar, Rotation = 90, Color = Theme.Colors.Gradients.InteractiveBar })
    Create("UIStroke", { Parent = bar, Color = Theme.Colors.Stroke })
    return bar
end

local dropdownTemplate = createBaseComponent("Dropdown")
Create("UIGradient", { Parent = dropdownTemplate, Rotation = 90, Color = Theme.Colors.Gradients.Dropdown })
local dropdownBar = createInteractiveBar(dropdownTemplate)
dropdownBar.Name = "DropdownBar"
Create("TextLabel", { Name = "Open", Parent = dropdownBar, Text = "none", FontFace = Theme.Fonts.Bold, TextColor3 = Theme.Colors.Text, Size = UDim2.fromScale(1, 0.6), Position = UDim2.fromScale(0, 0.22), BackgroundTransparency = 1 })
Create("ImageLabel", { Name = "Icon", Parent = dropdownBar, Image = Theme.Images.CloseIcon, Rotation = 180, Size = UDim2.new(0.028, 0, 0.59, 0), Position = UDim2.new(0.96, 0, 0.22, 0), BackgroundTransparency = 1 })
Create("TextButton", { Name = "Trigger", Parent = dropdownBar, Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })
local dropdownBox = Create("Frame", { Name = "Box", Parent = dropdownTemplate, Visible = false, Size = UDim2.new(0.97, 0, 0, 0), Position = UDim2.new(0.015, 0, 0.64, 0), BackgroundColor3 = Theme.Colors.SecondaryBackground, LayoutOrder = 10 })
Create("UICorner", { Parent = dropdownBox, CornerRadius = UDim.new(0.06, 0) })
Create("UIGradient", { Parent = dropdownBox, Rotation = 90, Color = Theme.Colors.Gradients.InteractiveBar })
Create("UIStroke", { Parent = dropdownBox, Color = Theme.Colors.Stroke })
local dropdownScroll = Create("ScrollingFrame", { Parent = dropdownBox, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0 })
Create("UIListLayout", { Parent = dropdownScroll, HorizontalAlignment = Enum.HorizontalAlignment.Center })

local keybindTemplate = createBaseComponent("Keybind")
Create("UIGradient", { Parent = keybindTemplate, Rotation = 90, Color = Theme.Colors.Gradients.Keybind })
local bindBox = Create("Frame", { Name = "Bind", Parent = keybindTemplate, Size = UDim2.new(0.15, 0, 0.29, 0), Position = UDim2.new(0.015, 0, 0.34, 0), BackgroundColor3 = Theme.Colors.SecondaryBackground })
Create("UICorner", { Parent = bindBox, CornerRadius = Theme.Radii.Large })
Create("UIGradient", { Parent = bindBox, Rotation = 90, Color = Theme.Colors.Gradients.InteractiveBar })
Create("UIStroke", { Parent = bindBox, Color = Theme.Colors.Stroke })
Create("TextButton", { Name = "Button", Parent = bindBox, Text = "key", FontFace = Theme.Fonts.RegularItalic, TextColor3 = Theme.Colors.TextMuted, TextScaled = true, Size = UDim2.fromScale(1, 0.6), Position = UDim2.fromScale(0, 0.22), BackgroundTransparency = 1, ZIndex = 5 })

local labelTemplate = Create("Frame", { Name = "Label", Parent = templates, Visible = false, Size = UDim2.new(0.96, 0, 0.08, 0), Position = UDim2.new(0.02, 0, 0.02, 0), BackgroundColor3 = Theme.Colors.SecondaryBackground, AutomaticSize = Enum.AutomaticSize.Y })
Create("UICorner", { Parent = labelTemplate, CornerRadius = UDim.new(0.33, 0) })
Create("UIGradient", { Parent = labelTemplate, Rotation = 90, Color = Theme.Colors.Gradients.Label })
Create("TextLabel", { Name = "Title", Parent = labelTemplate, Text = "This is a Label", FontFace = Theme.Fonts.Bold, TextColor3 = Theme.Colors.Text, TextXAlignment = Enum.TextXAlignment.Left, TextScaled = true, Size = UDim2.new(0.96, 0, 0.6, 0), Position = UDim2.new(0.02, 0, 0.22, 0), BackgroundTransparency = 1 })

local sliderTemplate = createBaseComponent("Slider")
Create("UIGradient", { Parent = sliderTemplate, Rotation = 90, Color = Theme.Colors.Gradients.Slider })
local sliderBar = Create("Frame", { Name = "ActualSlider", Parent = sliderTemplate, Size = UDim2.new(0.97, 0, 0.29, 0), Position = UDim2.new(0.015, 0, 0.34, 0), BackgroundColor3 = Theme.Colors.PrimaryAccent, ClipsDescendants = true })
Create("UICorner", { Parent = sliderBar, CornerRadius = Theme.Radii.Large })
Create("UIGradient", { Parent = sliderBar, Rotation = 90, Color = Theme.Colors.Gradients.SliderTrack })
Create("UIStroke", { Parent = sliderBar, Color = Theme.Colors.PrimaryAccent })
local sliderFill = Create("Frame", { Name = "Fill", Parent = sliderBar, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Theme.Colors.PrimaryAccent })
Create("UICorner", { Parent = sliderFill, CornerRadius = Theme.Radii.Large })
Create("UIGradient", { Parent = sliderFill, Rotation = 90, Color = Theme.Colors.Gradients.SliderFill })
Create("TextButton", { Name = "Trigger", Parent = sliderBar, Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, LayoutOrder = 5 })
Create("TextLabel", { Name = "Title", Parent = sliderBar, Text = "100", FontFace = Theme.Fonts.Bold, TextColor3 = Theme.Colors.Text, TextXAlignment = Enum.TextXAlignment.Left, TextScaled = true, Size = UDim2.new(0.96, 0, 0.6, 0), Position = UDim2.new(0.02, 0, 0.23, 0), BackgroundTransparency = 1, LayoutOrder = 3 })

local textboxTemplate = createBaseComponent("Textbox")
Create("UIGradient", { Parent = textboxTemplate, Rotation = 90, Color = Theme.Colors.Gradients.Dropdown })
local textboxBar = createInteractiveBar(textboxTemplate)
textboxBar.Name = "TextboxBar"
Create("TextBox", { Name = "ActualTextbox", Parent = textboxBar, PlaceholderText = "Input Here...", PlaceholderColor3 = Theme.Colors.TextPlaceholder, FontFace = Theme.Fonts.RegularItalic, TextColor3 = Theme.Colors.Text, TextScaled = true, Size = UDim2.fromScale(1, 0.6), Position = UDim2.fromScale(0, 0.22), BackgroundTransparency = 1 })

local toggleTemplate = createBaseComponent("Toggle")
toggleTemplate.Size = UDim2.new(0.96, 0, 0.15, 0)
Create("UIGradient", { Parent = toggleTemplate, Rotation = 90, Color = Theme.Colors.Gradients.Toggle })
local toggleSwitch = Create("Frame", { Name = "Switch", Parent = toggleTemplate, Size = UDim2.new(0.038, 0, 0.43, 0), Position = UDim2.new(0.92, 0, 0.28, 0), BackgroundColor3 = Theme.Colors.PrimaryAccent, AutomaticSize = Enum.AutomaticSize.Y })
Create("UICorner", { Parent = toggleSwitch, CornerRadius = UDim.new(0.33, 0) })
Create("UIGradient", { Parent = toggleSwitch, Rotation = 90, Color = Theme.Colors.Gradients.Label })
Create("UIStroke", { Parent = toggleSwitch, Color = Theme.Colors.Stroke, Thickness = 2.4, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
Create("TextButton", { Name = "Trigger", Parent = toggleSwitch, Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y })

local buttonTemplate = createBaseComponent("Button")
buttonTemplate.Name = "Button"
buttonTemplate.ClassName = "TextButton"
buttonTemplate.Text = ""
buttonTemplate.AutoButtonColor = false
buttonTemplate.Size = UDim2.new(0.96, 0, 0.15, 0)
Create("UIGradient", { Parent = buttonTemplate, Rotation = 90, Color = Theme.Colors.Gradients.Toggle })

local dropdownButtonTemplate = Create("TextButton", {
	Name = "DropdownButton",
	Parent = templates,
	Visible = false,
	Text = "",
	Size = UDim2.new(1, 0, 0.17, 0),
	BackgroundColor3 = Theme.Colors.SecondaryBackground
})
Create("UICorner", { Parent = dropdownButtonTemplate, CornerRadius = Theme.Radii.Large })
Create("UIGradient", { Parent = dropdownButtonTemplate, Rotation = 90, Color = Theme.Colors.Gradients.InteractiveBar })
Create("UIStroke", { Parent = dropdownButtonTemplate, Color = Theme.Colors.Stroke })
Create("TextLabel", { Name = "name", Parent = dropdownButtonTemplate, Text = "none", FontFace = Theme.Fonts.Bold, TextColor3 = Theme.Colors.TextMuted, TextScaled = true, Size = UDim2.fromScale(1, 0.6), Position = UDim2.fromScale(0, 0.22), BackgroundTransparency = 1 })

local clickSound = Create("Sound", { SoundId = Theme.Sounds.Click, Volume = 0.5, Parent = screenGui })
local isGuiOpened = false

function UILIB:Load(name, img)
	local self = setmetatable({}, UILIB)
	titleLabel.TextLabel.Text = name
	logoImage.Image = img or Theme.Images.DefaultLogo
    playerImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)

	task.spawn(function()
		while task.wait(1) do
			clockText.Text = os.date("%H:%M")
		end
	end)

	local function toggleGui(open)
		isGuiOpened = open
		local topBarPos = open and UDim2.new(0.23, 0, 0.012, 0) or UDim2.new(0.23, 0, -0.173, 0)
		local mainBarPos = open and UDim2.new(0.23, 0, 0.212, 0) or UDim2.new(0.23, 0, -0.612, 0)
		local closeButtonRotation = open and 0 or 180

		local mainBarTween = TweenService:Create(mainBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad), { Position = mainBarPos })
		local topBarTween = TweenService:Create(topBar, TweenInfo.new(0.7, Enum.EasingStyle.Quad), { Position = topBarPos })
		local rotateTween = TweenService:Create(closeButtonIcon, TweenInfo.new(0.4, Enum.EasingStyle.Quad), { Rotation = closeButtonRotation })

		if open then
			mainBarTween:Play()
			mainBarTween.Completed:Wait()
			topBarTween:Play()
		else
			topBarTween:Play()
			topBarTween.Completed:Wait()
			mainBarTween:Play()
		end
		rotateTween:Play()
	end

	closeButton.MouseButton1Click:Connect(function()
		toggleGui(not isGuiOpened)
	end)

	function self:Open() toggleGui(true) end
	function self:Close() toggleGui(false) end
	function self:Toggle() toggleGui(not isGuiOpened) end
    function self:Hide() screenGui.Enabled = false end
    function self:Show() screenGui.Enabled = true end
	function self:HideCloseButton() closeButton.Visible = false end

	toggleGui(true)
	return self
end

function UILIB.newTab(name, img)
	local self = setmetatable({}, UILIB)
	local newTab = templates.TabTemplate:Clone()
	newTab.Name = name
	newTab.Parent = mainBar

	local newTabBtn = templates.TabButtonTemplate:Clone()
	newTabBtn.Name = name
	newTabBtn.Parent = tabContainer
	newTabBtn.Visible = true
	newTabBtn.ImageLabel.Image = img or ""
	newTabBtn.Frame.TextLabel.Text = name

	newTabBtn.MouseButton1Click:Connect(function()
		for _, child in ipairs(mainBar:GetChildren()) do
			if child:IsA("ScrollingFrame") then
				child.Visible = (child.Name == name)
			end
		end
		for _, btn in ipairs(tabContainer:GetChildren()) do
			if btn:IsA("ImageButton") then
				local isSelected = (btn.Name == name)
				TweenService:Create(btn, TweenInfo.new(0.2), { ImageTransparency = isSelected and 0 or 0.75 }):Play()
			end
		end
	end)

    local function setupComponentHover(component)
        component.MouseEnter:Connect(function()
            TweenService:Create(component, TweenInfo.new(0.2), { BackgroundTransparency = Theme.Transparency.Opaque }):Play()
        end)
        component.MouseLeave:Connect(function()
            TweenService:Create(component, TweenInfo.new(0.2), { BackgroundTransparency = Theme.Transparency.Background }):Play()
        end)
    end

	function self.newButton(text, desc, func)
		local newBtn = templates.Button:Clone()
		newBtn.Name = text
		newBtn.Title.Text = text
		newBtn.Description.Text = desc
		newBtn.Visible = true
		newBtn.Parent = newTab
        setupComponentHover(newBtn)
		newBtn.MouseButton1Click:Connect(func)
	end

	function self.newLabel(text)
		local newLbl = templates.Label:Clone()
		newLbl.Title.Text = text
		newLbl.Visible = true
		newLbl.Parent = newTab
		return newLbl.Title
	end

	function self.newInput(text, desc, func)
		local newInput = templates.Textbox:Clone()
		newInput.Name = text
		newInput.Title.Text = text
		newInput.Description.Text = desc
		newInput.Visible = true
		newInput.Parent = newTab
        setupComponentHover(newInput)
		newInput.TextboxBar.ActualTextbox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
			    func(newInput.TextboxBar.ActualTextbox.Text)
            end
		end)
	end

	function self.newKeybind(text, desc, func)
		local newKeybind = templates.Keybind:Clone()
		newKeybind.Name = text
		newKeybind.Title.Text = text
		newKeybind.Description.Text = desc
		newKeybind.Visible = true
		newKeybind.Parent = newTab
        setupComponentHover(newKeybind)

		local keybindButton = newKeybind.Bind.Button
		local listening = false
		keybindButton.MouseButton1Click:Connect(function()
			if listening then return end
			listening = true
			keybindButton.Text = "..."
			local connection
			connection = UserInputService.InputBegan:Connect(function(input, processed)
				if processed then return end
                if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType:find("Mouse") then
				    keybindButton.Text = input.KeyCode.Name or input.UserInputType.Name
				    func(input)
				    listening = false
				    connection:Disconnect()
                end
			end)
		end)
	end

	function self.newSlider(text, desc, min, max, defaultValue, func)
		local newSlider = templates.Slider:Clone()
		newSlider.Name = text
		newSlider.Title.Text = text
		newSlider.Description.Text = desc
		newSlider.Visible = true
		newSlider.Parent = newTab
        setupComponentHover(newSlider)

		local trigger = newSlider.ActualSlider.Trigger
		local fill = newSlider.ActualSlider.Fill
		local valueLabel = newSlider.ActualSlider.Title
		local sliderParent = newSlider.ActualSlider
		local isDragging = false
		
		local function updateSlider(value)
			local percent = (value - min) / (max - min)
			fill.Size = UDim2.fromScale(math.clamp(percent, 0, 1), 1)
			valueLabel.Text = tostring(math.floor(value))
			func(value)
		end

		trigger.MouseButton1Down:Connect(function()
			isDragging = true
			while isDragging do
				local percent = (UserInputService:GetMouseLocation().X - sliderParent.AbsolutePosition.X) / sliderParent.AbsoluteSize.X
				local value = min + (max - min) * math.clamp(percent, 0, 1)
				updateSlider(value)
				task.wait()
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				isDragging = false
			end
		end)
		updateSlider(defaultValue)
	end
	
	function self.newToggle(text, desc, defaultState, func)
		local newToggle = templates.Toggle:Clone()
		local currentState = defaultState
		newToggle.Name = text
		newToggle.Title.Text = text
		newToggle.Description.Text = desc
		newToggle.Visible = true
		newToggle.Parent = newTab
        setupComponenthover(newToggle)
		
		local switch = newToggle.Switch
		local function updateVisuals()
			local color = currentState and Theme.Colors.PrimaryAccent or Theme.Colors.SecondaryBackground
			TweenService:Create(switch, TweenInfo.new(0.2), { BackgroundColor3 = color }):Play()
		end
		
		switch.Trigger.MouseButton1Click:Connect(function()
			currentState = not currentState
			updateVisuals()
			func(currentState)
		end)
		updateVisuals()
	end
	
	function self.newDropdown(text, desc, items, func)
		local newDropdown = templates.Dropdown:Clone()
		newDropdown.Name = text
		newDropdown.Title.Text = text
		newDropdown.Description.Text = desc
		newDropdown.Visible = true
		newDropdown.Parent = newTab

		local box = newDropdown.Box
		local scroll = box.ScrollingFrame
		local openLabel = newDropdown.DropdownBar.Open
		local isOpen = false

		for _, item in ipairs(items) do
			local btn = templates.DropdownButton:Clone()
			btn.name.Text = item
			btn.Visible = true
			btn.Parent = scroll
			btn.MouseButton1Click:Connect(function()
				openLabel.Text = item
				isOpen = false
				box.Visible = false
				func(item)
			end)
		end

		newDropdown.DropdownBar.Trigger.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			box.Visible = true
			local targetSize = isOpen and UDim2.new(0.97, 0, 1.7, 0) or UDim2.new(0.97, 0, 0, 0)
			local tween = TweenService:Create(box, TweenInfo.new(0.15), { Size = targetSize })
			tween:Play()
			if not isOpen then
				tween.Completed:Wait()
				box.Visible = false
			end
		end)
	end

	return self
end

return UILIB
