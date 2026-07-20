local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Library = {}
Library.__index = Library

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
	local window = {}

	-- ScreenGui setup
	local player = Players.LocalPlayer
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CustomLibraryGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	-- Main Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.Size = UDim2.new(0, 480, 0, 310)
	mainFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui
	applyCorner(mainFrame, UDim.new(0, 8))

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = mainFrame

	-- TitleBar with 8px Corner Radius
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.LayoutOrder = 1
	titleBar.Size = UDim2.new(1, 0, 0, 36)
	titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	titleBar.Parent = mainFrame
	applyCorner(titleBar, UDim.new(0, 8))

	-- Filler Frame to square off the bottom corners of TitleBar
	local titleBarFiller = Instance.new("Frame")
	titleBarFiller.Name = "TitleBarFiller"
	titleBarFiller.AnchorPoint = Vector2.new(0, 1)
	titleBarFiller.Position = UDim2.new(0, 0, 1, 0)
	titleBarFiller.Size = UDim2.new(1, 0, 0, 8)
	titleBarFiller.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	titleBarFiller.BorderSizePixel = 0
	titleBarFiller.Parent = titleBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleText"
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.Size = UDim2.new(1, -24, 1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	titleLabel.Text = titleText or "Window Title"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 2
	titleLabel.Parent = titleBar

	local separator = Instance.new("Frame")
	separator.Name = "Separator"
	separator.AnchorPoint = Vector2.new(0.5, 1)
	separator.Position = UDim2.new(0.5, 0, 1, 0)
	separator.Size = UDim2.new(1, 0, 0, 2)
	separator.BackgroundColor3 = Color3.fromRGB(27, 42, 53)
	separator.BorderSizePixel = 0
	separator.ZIndex = 3
	separator.Parent = titleBar

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
	sideBar.Position = UDim2.new(0, 8, 0, 8)
	sideBar.Size = UDim2.new(0, 60, 1, -16)
	sideBar.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
	sideBar.Parent = body
	applyCorner(sideBar, UDim.new(0, 6))
	applyPadding(sideBar, 8, 8, 4, 4)

	local sideBarLayout = Instance.new("UIListLayout")
	sideBarLayout.Padding = UDim.new(0, 6)
	sideBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	sideBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sideBarLayout.Parent = sideBar

	-- Content Area
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Position = UDim2.new(0, 76, 0, 8)
	contentArea.Size = UDim2.new(1, -84, 1, -16)
	contentArea.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	contentArea.BackgroundTransparency = 0.2
	contentArea.ClipsDescendants = true
	contentArea.Parent = body
	applyCorner(contentArea, UDim.new(0, 6))

	-- Bottom-Right Toggle Button (Opens & Closes Main GUI)
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.AnchorPoint = Vector2.new(1, 1)
	toggleButton.Position = UDim2.new(1, -10, 1, -10)
	toggleButton.Size = UDim2.new(0, 72, 0, 32)
	toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	toggleButton.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	toggleButton.Text = "CLOSE"
	toggleButton.TextColor3 = Color3.fromRGB(243, 243, 243)
	toggleButton.TextSize = 14
	toggleButton.Parent = screenGui

	local toggleStroke = Instance.new("UIStroke")
	toggleStroke.Color = Color3.fromRGB(60, 60, 60)
	toggleStroke.Thickness = 1
	toggleStroke.Parent = toggleButton

	applyCorner(toggleButton, UDim.new(0, 6))

	-- Open/Close Click Handler
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

	-- Method: Add Tab
	function window:AddTab(iconId)
		local tab = {}

		local iconButton = Instance.new("ImageButton")
		iconButton.Name = "TabIcon"
		iconButton.Size = UDim2.new(0, 44, 0, 44)
		iconButton.BackgroundTransparency = 1
		iconButton.Image = iconId or "rbxassetid://13060262529"
		iconButton.HoverImage = iconId or "rbxassetid://13060262529"
		iconButton.Parent = window.SideBar
		applyCorner(iconButton, UDim.new(0, 6))

		-- Adjusted ScrollingFrame size & scrollbar thickness
		local itemList = Instance.new("ScrollingFrame")
		itemList.Name = "ItemList"
		itemList.AnchorPoint = Vector2.new(0.5, 0.5)
		itemList.Position = UDim2.new(0.5, 0, 0.5, 0)
		itemList.Size = UDim2.new(1, -16, 1, -16)
		itemList.BackgroundTransparency = 1
		itemList.ClipsDescendants = true
		itemList.ScrollingDirection = Enum.ScrollingDirection.Y
		itemList.AutomaticCanvasSize = Enum.AutomaticSize.None
		itemList.CanvasSize = UDim2.new(0, 0, 0, 0)
		itemList.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
		itemList.ScrollBarThickness = 4
		itemList.Visible = false
		itemList.Parent = window.ContentArea

		applyPadding(itemList, 6, 6, 6, 6)

		local itemLayout = Instance.new("UIListLayout")
		itemLayout.Padding = UDim.new(0, 6)
		itemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
		itemLayout.Parent = itemList

		-- Dynamically resize CanvasSize when items are added or expanded
		local function updateCanvasSize()
			itemList.CanvasSize = UDim2.new(0, 0, 0, itemLayout.AbsoluteContentSize.Y + 16)
		end

		itemLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

		iconButton.MouseButton1Click:Connect(function()
			for _, child in ipairs(window.ContentArea:GetChildren()) do
				if child:IsA("ScrollingFrame") then
					child.Visible = false
				end
			end
			itemList.Visible = true
		end)

		if not window.ActiveTab then
			window.ActiveTab = itemList
			itemList.Visible = true
		end

		-- Method: Add Toggle Switch
		function tab:AddToggle(title, description, defaultValue, callback)
			local toggled = defaultValue or false

			local itemFrame = Instance.new("Frame")
			itemFrame.Name = "ToggleItem"
			itemFrame.Size = UDim2.new(1, -12, 0, 48)
			itemFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			itemFrame.Parent = itemList
			applyCorner(itemFrame)
			applyPadding(itemFrame, 6, 6, 10, 10)

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Size = UDim2.new(0.7, 0, 0, 18)
			titleLbl.BackgroundTransparency = 1
			titleLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			titleLbl.Text = title or "Toggle Item"
			titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
			titleLbl.TextSize = 14
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.Parent = itemFrame

			local descLbl = Instance.new("TextLabel")
			descLbl.Position = UDim2.new(0, 0, 0, 18)
			descLbl.Size = UDim2.new(0.7, 0, 0, 14)
			descLbl.BackgroundTransparency = 1
			descLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			descLbl.Text = description or ""
			descLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
			descLbl.TextSize = 11
			descLbl.TextXAlignment = Enum.TextXAlignment.Left
			descLbl.Parent = itemFrame

			local switchFrame = Instance.new("Frame")
			switchFrame.AnchorPoint = Vector2.new(1, 0.5)
			switchFrame.Position = UDim2.new(1, 0, 0.5, 0)
			switchFrame.Size = UDim2.new(0, 46, 0, 24)
			switchFrame.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(20, 20, 20)
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

			local function updateToggle()
				local targetPos = toggled and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
				local targetColor = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(20, 20, 20)

				TweenService:Create(ball, TweenInfo.new(0.2), {Position = targetPos}):Play()
				TweenService:Create(switchFrame, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()

				if callback then
					task.spawn(callback, toggled)
				end
			end

			clickBtn.MouseButton1Click:Connect(function()
				toggled = not toggled
				updateToggle()
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
			dropdownItem.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			dropdownItem.ClipsDescendants = true
			dropdownItem.Parent = itemList
			applyCorner(dropdownItem)
			applyPadding(dropdownItem, 6, 6, 10, 10)

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Size = UDim2.new(1, -20, 0, 18)
			titleLbl.BackgroundTransparency = 1
			titleLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			titleLbl.Text = title or "Dropdown Menu"
			titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
			titleLbl.TextSize = 14
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.Parent = dropdownItem

			local descLbl = Instance.new("TextLabel")
			descLbl.Position = UDim2.new(0, 0, 0, 18)
			descLbl.Size = UDim2.new(1, -20, 0, 14)
			descLbl.BackgroundTransparency = 1
			descLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			descLbl.Text = "Select an option..."
			descLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
			descLbl.TextSize = 11
			descLbl.TextXAlignment = Enum.TextXAlignment.Left
			descLbl.Parent = dropdownItem

			local openBtn = Instance.new("TextButton")
			openBtn.Size = UDim2.new(1, 0, 0, 36)
			openBtn.BackgroundTransparency = 1
			openBtn.Text = ""
			openBtn.Parent = dropdownItem

			-- Expandable Sub-Container
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
				optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				optBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
				optBtn.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
				optBtn.Text = optionText
				optBtn.TextSize = 11
				optBtn.Parent = listFrame
				applyCorner(optBtn, UDim.new(0, 4))

				optBtn.MouseButton1Click:Connect(function()
					descLbl.Text = "Selected: " .. optionText
					isOpen = false
					local tween = TweenService:Create(dropdownItem, TweenInfo.new(0.2), {Size = UDim2.new(1, -12, 0, 48)})
					tween:Play()
					if callback then
						task.spawn(callback, optionText)
					end
				end)
			end

			openBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local targetHeight = isOpen and (44 + #options * 30) or 48
				local tween = TweenService:Create(dropdownItem, TweenInfo.new(0.25), {Size = UDim2.new(1, -12, 0, targetHeight)})
				tween:Play()
			end)

			return dropdownItem
		end

		-- Method: Add Slider Menu
		function tab:AddSlider(title, min, max, defaultValue, callback)
			min = min or 0
			max = max or 100
			defaultValue = math.clamp(defaultValue or min, min, max)

			local isOpen = false
			local dragging = false
			local currentValue = defaultValue

			local sliderItem = Instance.new("Frame")
			sliderItem.Name = "SliderItem"
			sliderItem.Size = UDim2.new(1, -12, 0, 48)
			sliderItem.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			sliderItem.ClipsDescendants = true
			sliderItem.Parent = itemList
			applyCorner(sliderItem)
			applyPadding(sliderItem, 6, 6, 10, 10)

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Size = UDim2.new(1, -20, 0, 18)
			titleLbl.BackgroundTransparency = 1
			titleLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			titleLbl.Text = title or "Slider"
			titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
			titleLbl.TextSize = 14
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.Parent = sliderItem

			local descLbl = Instance.new("TextLabel")
			descLbl.Position = UDim2.new(0, 0, 0, 18)
			descLbl.Size = UDim2.new(1, -20, 0, 14)
			descLbl.BackgroundTransparency = 1
			descLbl.FontFace = Font.new("rbxasset://fonts/families/DenkOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			descLbl.Text = "Value: " .. tostring(currentValue)
			descLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
			descLbl.TextSize = 11
			descLbl.TextXAlignment = Enum.TextXAlignment.Left
			descLbl.Parent = sliderItem

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
			track.Name = "Track"
			track.AnchorPoint = Vector2.new(0.5, 0.5)
			track.Position = UDim2.new(0.5, 0, 0.5, 0)
			track.Size = UDim2.new(1, 0, 0, 6)
			track.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			track.Parent = sliderContainer
			applyCorner(track, UDim.new(0, 3))

			local fill = Instance.new("Frame")
			fill.Name = "Fill"
			fill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
			fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
			fill.Parent = track
			applyCorner(fill, UDim.new(0, 3))

			local knob = Instance.new("Frame")
			knob.Name = "Knob"
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.Position = UDim2.new(1, 0, 0.5, 0)
			knob.Size = UDim2.new(0, 14, 0, 14)
			knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			knob.Parent = fill
			applyCorner(knob, UDim.new(0, 7))

			local sliderBtn = Instance.new("TextButton")
			sliderBtn.Name = "SliderBtn"
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
					if callback then
						task.spawn(callback, currentValue)
					end
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
				local tween = TweenService:Create(sliderItem, TweenInfo.new(0.25), {Size = UDim2.new(1, -12, 0, targetHeight)})
				tween:Play()
			end)

			return sliderItem
		end

		return tab
	end

	return window
end

return Library
