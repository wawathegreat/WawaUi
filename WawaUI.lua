local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

-- Color Themes Table
Library.Themes = {
	["Midnight"] = {
		Main = Color3.fromRGB(15, 15, 25),
		SideBar = Color3.fromRGB(10, 10, 18),
		TitleBar = Color3.fromRGB(20, 20, 32),
		Content = Color3.fromRGB(5, 5, 10),
		ItemBg = Color3.fromRGB(22, 22, 35),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(140, 140, 170),
		Accent = Color3.fromRGB(114, 137, 218),
		ButtonUnselected = Color3.fromRGB(25, 25, 40)
	},
	["Dark"] = {
		Main = Color3.fromRGB(34, 34, 34),
		SideBar = Color3.fromRGB(27, 27, 27),
		TitleBar = Color3.fromRGB(40, 40, 40),
		Content = Color3.fromRGB(0, 0, 0),
		ItemBg = Color3.fromRGB(30, 30, 30),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(160, 160, 160),
		Accent = Color3.fromRGB(0, 170, 255),
		ButtonUnselected = Color3.fromRGB(45, 45, 45)
	},
	["White"] = {
		Main = Color3.fromRGB(240, 240, 240),
		SideBar = Color3.fromRGB(220, 220, 220),
		TitleBar = Color3.fromRGB(255, 255, 255),
		Content = Color3.fromRGB(255, 255, 255),
		ItemBg = Color3.fromRGB(225, 225, 225),
		Text = Color3.fromRGB(20, 20, 20),
		SubText = Color3.fromRGB(90, 90, 90),
		Accent = Color3.fromRGB(0, 120, 215),
		ButtonUnselected = Color3.fromRGB(200, 200, 200)
	}
}

-- Utility: Helper to format Roblox asset IDs safely
local function formatAssetId(id)
	if not id then return "rbxassetid://6031068426" end
	if type(id) == "number" or (type(id) == "string" and tonumber(id)) then
		return "rbxassetid://" .. tostring(id)
	end
	return id
end

-- Utility: Apply UICorner
local function applyCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UDim.new(0, 6)
	corner.Parent = instance
	return corner
end

-- Utility: Apply UIPadding
local function applyPadding(instance, top, bottom, left, right)
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, top or 8)
	padding.PaddingBottom = UDim.new(0, bottom or 8)
	padding.PaddingLeft = UDim.new(0, left or 8)
	padding.PaddingRight = UDim.new(0, right or 8)
	padding.Parent = instance
	return padding
end

-- Create Window Function
function Library.CreateWindow(titleText)
	local window = {
		CurrentTheme = Library.Themes["Dark"],
		ThemeableObjects = {},
		TabCount = 0
	}

	local function registerThemeObject(object, colorProperty, themeKey)
		table.insert(window.ThemeableObjects, {Object = object, Property = colorProperty, Key = themeKey})
		object[colorProperty] = window.CurrentTheme[themeKey]
	end

	-- ScreenGui setup
	local player = Players.LocalPlayer
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CustomLibraryGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = gethui()

	-- Main Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.Size = UDim2.new(0, 480, 0, 310)
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui
	applyCorner(mainFrame, UDim.new(0, 8))
	registerThemeObject(mainFrame, "BackgroundColor3", "Main")

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = mainFrame

	-- TitleBar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.LayoutOrder = 1
	titleBar.Size = UDim2.new(1, 0, 0, 36)
	titleBar.Parent = mainFrame
	applyCorner(titleBar, UDim.new(0, 8))
	registerThemeObject(titleBar, "BackgroundColor3", "TitleBar")

	local titleBarFiller = Instance.new("Frame")
	titleBarFiller.Name = "TitleBarFiller"
	titleBarFiller.AnchorPoint = Vector2.new(0, 1)
	titleBarFiller.Position = UDim2.new(0, 0, 1, 0)
	titleBarFiller.Size = UDim2.new(1, 0, 0, 8)
	titleBarFiller.BorderSizePixel = 0
	titleBarFiller.Parent = titleBar
	registerThemeObject(titleBarFiller, "BackgroundColor3", "TitleBar")

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleText"
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.Size = UDim2.new(1, -24, 1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	titleLabel.Text = titleText or "Window Title"
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 2
	titleLabel.Parent = titleBar
	registerThemeObject(titleLabel, "TextColor3", "Text")

	local separator = Instance.new("Frame")
	separator.Name = "Separator"
	separator.AnchorPoint = Vector2.new(0.5, 1)
	separator.Position = UDim2.new(0.5, 0, 1, 0)
	separator.Size = UDim2.new(1, 0, 0, 2)
	separator.BorderSizePixel = 0
	separator.ZIndex = 3
	separator.Parent = titleBar
	registerThemeObject(separator, "BackgroundColor3", "Accent")

	-- Body Container
	local body = Instance.new("Frame")
	body.Name = "Body"
	body.LayoutOrder = 2
	body.Size = UDim2.new(1, 0, 1, -36)
	body.BackgroundTransparency = 1
	body.ClipsDescendants = true
	body.Parent = mainFrame

	-- SideBar
	local sideBar = Instance.new("Frame")
	sideBar.Name = "SideBar"
	sideBar.BorderSizePixel = 0
	sideBar.Position = UDim2.new(0, 8, 0, 8)
	sideBar.Size = UDim2.new(0, 52, 1, -16)
	sideBar.Selectable = false
	sideBar.Parent = body
	applyCorner(sideBar, UDim.new(0, 6))
	applyPadding(sideBar, 6, 6, 4, 4)
	registerThemeObject(sideBar, "BackgroundColor3", "SideBar")

	local sideBarLayout = Instance.new("UIListLayout")
	sideBarLayout.Padding = UDim.new(0, 8)
	sideBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	sideBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sideBarLayout.Parent = sideBar

	-- Content Area
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Position = UDim2.new(0, 68, 0, 8)
	contentArea.Size = UDim2.new(1, -76, 1, -16)
	contentArea.BackgroundTransparency = 0.2
	contentArea.ClipsDescendants = true
	contentArea.Parent = body
	applyCorner(contentArea, UDim.new(0, 6))
	registerThemeObject(contentArea, "BackgroundColor3", "Content")

	-- Bottom-Right Toggle Button
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.AnchorPoint = Vector2.new(1, 1)
	toggleButton.Position = UDim2.new(1, -10, 1, -10)
	toggleButton.Size = UDim2.new(0, 72, 0, 32)
	toggleButton.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	toggleButton.Text = "CLOSE"
	toggleButton.TextSize = 14
	toggleButton.Parent = screenGui
	applyCorner(toggleButton, UDim.new(0, 6))
	registerThemeObject(toggleButton, "BackgroundColor3", "Main")
	registerThemeObject(toggleButton, "TextColor3", "Text")

	local toggleStroke = Instance.new("UIStroke")
	toggleStroke.Thickness = 1
	toggleStroke.Parent = toggleButton
	registerThemeObject(toggleStroke, "Color", "Accent")

	toggleButton.MouseButton1Click:Connect(function()
		mainFrame.Visible = not mainFrame.Visible
		toggleButton.Text = mainFrame.Visible and "CLOSE" or "OPEN"
	end)

	window.ScreenGui = screenGui
	window.MainFrame = mainFrame
	window.SideBar = sideBar
	window.ContentArea = contentArea
	window.ToggleButton = toggleButton
	window.ActiveTab = nil

	function window:SetTheme(themeName)
		local theme = Library.Themes[themeName]
		if not theme then return end

		window.CurrentTheme = theme
		for _, data in ipairs(window.ThemeableObjects) do
			if data.Object and data.Object.Parent then
				data.Object[data.Property] = theme[data.Key]
			end
		end
	end

	-- Method: Add Tab
	function window:AddTab(iconId)
		local tab = {}
		window.TabCount = window.TabCount + 1
		local tabIndex = window.TabCount

		local tabButton = Instance.new("ImageButton")
		tabButton.Name = "TabButton_" .. tostring(tabIndex)
		tabButton.Size = UDim2.new(0, 40, 0, 40)
		tabButton.BorderSizePixel = 0
		tabButton.LayoutOrder = tabIndex
		tabButton.Image = ""
		tabButton.Parent = window.SideBar
		applyCorner(tabButton, UDim.new(0, 6))

		local icon = Instance.new("ImageLabel")
		icon.Name = "Icon"
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		icon.Size = UDim2.new(0, 24, 0, 24)
		icon.BackgroundTransparency = 1
		icon.Image = formatAssetId(iconId)
		icon.ScaleType = Enum.ScaleType.Fit
		icon.Parent = tabButton
		registerThemeObject(icon, "ImageColor3", "Text")

		local itemList = Instance.new("ScrollingFrame")
		itemList.Name = "ItemList_" .. tostring(tabIndex)
		itemList.AnchorPoint = Vector2.new(0.5, 0.5)
		itemList.Position = UDim2.new(0.5, 0, 0.5, 0)
		itemList.Size = UDim2.new(1, -16, 1, -16)
		itemList.BackgroundTransparency = 1
		itemList.ClipsDescendants = true
		itemList.ScrollingDirection = Enum.ScrollingDirection.Y
		itemList.AutomaticCanvasSize = Enum.AutomaticSize.None
		itemList.CanvasSize = UDim2.new(0, 0, 0, 0)
		itemList.ScrollBarThickness = 4
		itemList.Visible = false
		itemList.Parent = window.ContentArea
		applyPadding(itemList, 6, 6, 6, 6)
		registerThemeObject(itemList, "ScrollBarImageColor3", "SubText")

		local itemLayout = Instance.new("UIListLayout")
		itemLayout.Padding = UDim.new(0, 6)
		itemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
		itemLayout.Parent = itemList

		itemLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			itemList.CanvasSize = UDim2.new(0, 0, 0, itemLayout.AbsoluteContentSize.Y + 16)
		end)

		local function updateTabVisuals()
			for _, btn in ipairs(window.SideBar:GetChildren()) do
				if btn:IsA("ImageButton") then
					btn.BackgroundColor3 = window.CurrentTheme.ButtonUnselected
					btn.BackgroundTransparency = 0.4
				end
			end
			tabButton.BackgroundColor3 = window.CurrentTheme.Accent
			tabButton.BackgroundTransparency = 0
		end

		tabButton.MouseButton1Click:Connect(function()
			for _, child in ipairs(window.ContentArea:GetChildren()) do
				if child:IsA("ScrollingFrame") then
					child.Visible = false
				end
			end
			updateTabVisuals()
			itemList.Visible = true
		end)

		if not window.ActiveTab then
			window.ActiveTab = itemList
			itemList.Visible = true
			updateTabVisuals()
		else
			tabButton.BackgroundColor3 = window.CurrentTheme.ButtonUnselected
			tabButton.BackgroundTransparency = 0.4
		end

		-- Method: Add Toggle
		function tab:AddToggle(title, description, defaultValue, callback)
			local toggled = defaultValue or false

			local itemFrame = Instance.new("Frame")
			itemFrame.Name = "ToggleItem"
			itemFrame.Size = UDim2.new(1, -12, 0, 48)
			itemFrame.Parent = itemList
			applyCorner(itemFrame)
			applyPadding(itemFrame, 6, 6, 10, 10)
			registerThemeObject(itemFrame, "BackgroundColor3", "ItemBg")

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Size = UDim2.new(0.7, 0, 0, 18)
			titleLbl.BackgroundTransparency = 1
			titleLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			titleLbl.Text = title or "Toggle Item"
			titleLbl.TextSize = 14
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.Parent = itemFrame
			registerThemeObject(titleLbl, "TextColor3", "Text")

			local descLbl = Instance.new("TextLabel")
			descLbl.Position = UDim2.new(0, 0, 0, 18)
			descLbl.Size = UDim2.new(0.7, 0, 0, 14)
			descLbl.BackgroundTransparency = 1
			descLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			descLbl.Text = description or ""
			descLbl.TextSize = 11
			descLbl.TextXAlignment = Enum.TextXAlignment.Left
			descLbl.Parent = itemFrame
			registerThemeObject(descLbl, "TextColor3", "SubText")

			local switchFrame = Instance.new("Frame")
			switchFrame.AnchorPoint = Vector2.new(1, 0.5)
			switchFrame.Position = UDim2.new(1, 0, 0.5, 0)
			switchFrame.Size = UDim2.new(0, 46, 0, 24)
			switchFrame.BackgroundColor3 = toggled and window.CurrentTheme.Accent or Color3.fromRGB(20, 20, 20)
			switchFrame.Parent = itemFrame
			applyCorner(switchFrame, UDim.new(0, 24))

			local ball = Instance.new("Frame")
			ball.AnchorPoint = Vector2.new(0, 0.5)
			ball.Position = toggled and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
			ball.Size = UDim2.new(0, 17, 0, 17)
			ball.BackgroundColor3 = Color3.fromRGB(226, 226, 226)
			ball.Parent = switchFrame
			applyCorner(ball, UDim.new(0, 24))

			local clickBtn = Instance.new("TextButton")
			clickBtn.Size = UDim2.new(1, 0, 1, 0)
			clickBtn.BackgroundTransparency = 1
			clickBtn.Text = ""
			clickBtn.Parent = switchFrame

			clickBtn.MouseButton1Click:Connect(function()
				toggled = not toggled
				local targetPos = toggled and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
				local targetColor = toggled and window.CurrentTheme.Accent or Color3.fromRGB(20, 20, 20)

				TweenService:Create(ball, TweenInfo.new(0.2), {Position = targetPos}):Play()
				TweenService:Create(switchFrame, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()

				if callback then task.spawn(callback, toggled) end
			end)

			return itemFrame
		end

		-- Method: Add Dropdown Menu
		function tab:AddDropdown(title, options, callback)
			options = options or {}
			local isOpen = false

			local dropdownItem = Instance.new("Frame")
			dropdownItem.Name = "DropdownItem"
			dropdownItem.Size = UDim2.new(1, -12, 0, 48)
			dropdownItem.ClipsDescendants = true
			dropdownItem.Parent = itemList
			applyCorner(dropdownItem)
			applyPadding(dropdownItem, 6, 6, 10, 10)
			registerThemeObject(dropdownItem, "BackgroundColor3", "ItemBg")

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Size = UDim2.new(1, -20, 0, 18)
			titleLbl.BackgroundTransparency = 1
			titleLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			titleLbl.Text = title or "Dropdown Menu"
			titleLbl.TextSize = 14
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.Parent = dropdownItem
			registerThemeObject(titleLbl, "TextColor3", "Text")

			local descLbl = Instance.new("TextLabel")
			descLbl.Position = UDim2.new(0, 0, 0, 18)
			descLbl.Size = UDim2.new(1, -20, 0, 14)
			descLbl.BackgroundTransparency = 1
			descLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			descLbl.Text = "Select an option..."
			descLbl.TextSize = 11
			descLbl.TextXAlignment = Enum.TextXAlignment.Left
			descLbl.Parent = dropdownItem
			registerThemeObject(descLbl, "TextColor3", "SubText")

			local openBtn = Instance.new("TextButton")
			openBtn.Size = UDim2.new(1, 0, 0, 36)
			openBtn.BackgroundTransparency = 1
			openBtn.Text = ""
			openBtn.Parent = dropdownItem

			local listFrame = Instance.new("Frame")
			listFrame.Position = UDim2.new(0, 0, 0, 38)
			listFrame.Size = UDim2.new(1, 0, 0, #options * 30)
			listFrame.BackgroundTransparency = 1
			listFrame.Parent = dropdownItem

			local dropLayout = Instance.new("UIListLayout")
			dropLayout.Padding = UDim.new(0, 4)
			dropLayout.Parent = listFrame

			for _, optionText in ipairs(options) do
				local optBtn = Instance.new("TextButton")
				optBtn.Size = UDim2.new(1, 0, 0, 26)
				optBtn.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
				optBtn.Text = optionText
				optBtn.TextSize = 11
				optBtn.Parent = listFrame
				applyCorner(optBtn, UDim.new(0, 4))
				registerThemeObject(optBtn, "BackgroundColor3", "Main")
				registerThemeObject(optBtn, "TextColor3", "Text")

				optBtn.MouseButton1Click:Connect(function()
					descLbl.Text = "Selected: " .. optionText
					isOpen = false
					TweenService:Create(dropdownItem, TweenInfo.new(0.2), {Size = UDim2.new(1, -12, 0, 48)}):Play()
					if callback then task.spawn(callback, optionText) end
				end)
			end

			openBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetHeight = isOpen and (44 + #options * 30) or 48
				TweenService:Create(dropdownItem, TweenInfo.new(0.25), {Size = UDim2.new(1, -12, 0, targetHeight)}):Play()
			end)

			return dropdownItem
		end

		-- Method: Add Slider Menu
		function tab:AddSlider(title, min, max, defaultValue, callback)
			min = min or 0
			max = max or 100
			defaultValue = math.clamp(defaultValue or min, min, max)

			local isOpen, dragging = false, false
			local currentValue = defaultValue

			local sliderItem = Instance.new("Frame")
			sliderItem.Name = "SliderItem"
			sliderItem.Size = UDim2.new(1, -12, 0, 48)
			sliderItem.ClipsDescendants = true
			sliderItem.Parent = itemList
			applyCorner(sliderItem)
			applyPadding(sliderItem, 6, 6, 10, 10)
			registerThemeObject(sliderItem, "BackgroundColor3", "ItemBg")

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Size = UDim2.new(1, -20, 0, 18)
			titleLbl.BackgroundTransparency = 1
			titleLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			titleLbl.Text = title or "Slider"
			titleLbl.TextSize = 14
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.Parent = sliderItem
			registerThemeObject(titleLbl, "TextColor3", "Text")

			local descLbl = Instance.new("TextLabel")
			descLbl.Position = UDim2.new(0, 0, 0, 18)
			descLbl.Size = UDim2.new(1, -20, 0, 14)
			descLbl.BackgroundTransparency = 1
			descLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			descLbl.Text = "Value: " .. tostring(currentValue)
			descLbl.TextSize = 11
			descLbl.TextXAlignment = Enum.TextXAlignment.Left
			descLbl.Parent = sliderItem
			registerThemeObject(descLbl, "TextColor3", "SubText")

			local openBtn = Instance.new("TextButton")
			openBtn.Size = UDim2.new(1, 0, 0, 36)
			openBtn.BackgroundTransparency = 1
			openBtn.Text = ""
			openBtn.Parent = sliderItem

			local sliderContainer = Instance.new("Frame")
			sliderContainer.Position = UDim2.new(0, 0, 0, 38)
			sliderContainer.Size = UDim2.new(1, 0, 0, 26)
			sliderContainer.BackgroundTransparency = 1
			sliderContainer.Parent = sliderItem

			local track = Instance.new("Frame")
			track.AnchorPoint = Vector2.new(0.5, 0.5)
			track.Position = UDim2.new(0.5, 0, 0.5, 0)
			track.Size = UDim2.new(1, 0, 0, 6)
			track.Parent = sliderContainer
			applyCorner(track, UDim.new(0, 3))
			registerThemeObject(track, "BackgroundColor3", "Main")

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
			fill.Parent = track
			applyCorner(fill, UDim.new(0, 3))
			registerThemeObject(fill, "BackgroundColor3", "Accent")

			local knob = Instance.new("Frame")
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.Position = UDim2.new(1, 0, 0.5, 0)
			knob.Size = UDim2.new(0, 14, 0, 14)
			knob.Parent = fill
			applyCorner(knob, UDim.new(0, 7))
			registerThemeObject(knob, "BackgroundColor3", "Text")

			local sliderBtn = Instance.new("TextButton")
			sliderBtn.Size = UDim2.new(1, 0, 1, 0)
			sliderBtn.BackgroundTransparency = 1
			sliderBtn.Text = ""
			sliderBtn.Active = true
			sliderBtn.Parent = sliderContainer

			local function updateSlider(input)
				local relativeX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
				local alpha = track.AbsoluteSize.X > 0 and (relativeX / track.AbsoluteSize.X) or 0
				local value = math.floor(min + (max - min) * alpha)

				fill.Size = UDim2.new(alpha, 0, 1, 0)
				descLbl.Text = "Value: " .. tostring(value)

				if value ~= currentValue then
					currentValue = value
					if callback then task.spawn(callback, currentValue) end
				end
			end

			sliderBtn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					updateSlider(input)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			openBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetHeight = isOpen and 76 or 48
				TweenService:Create(sliderItem, TweenInfo.new(0.25), {Size = UDim2.new(1, -12, 0, targetHeight)}):Play()
			end)

			return sliderItem
		end

		return tab
	end

	return window
end

return Library
