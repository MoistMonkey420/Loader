local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Size = UDim2.new(0, 600, 0, 30)
    TabsFrame.Position = UDim2.new(0.5, -300, 0, 20)
    TabsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = TabsFrame

    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 5)
    TabsLayout.Parent = TabsFrame

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0, 60)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = MainFrame

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -20, 1, -20)
    ContentHolder.Position = UDim2.new(0, 10, 0, 10)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = MainFrame

    local Window = {}

    function Window:AddTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(0, 100, 1, -10)
        TabButton.Position = UDim2.new(0, 5, 0, 5)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.Parent = TabsFrame

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = TabButton

        local UIGradient = Instance.new("UIGradient")
        UIGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 128, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 0))
        }
        UIGradient.Rotation = 90
        UIGradient.Parent = TabButton

        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = name .. "Content"
        ContentFrame.Size = UDim2.new(1, 0, 1, 0)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderSizePixel = 0
        ContentFrame.ScrollBarThickness = 4
        ContentFrame.Visible = false
        ContentFrame.Parent = ContentHolder

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = ContentFrame

        local Tab = {}

        function Tab:AddToggle(toggleName, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = toggleName .. "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Parent = ContentFrame

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(0, 20, 0, 20)
            ToggleButton.Position = UDim2.new(0, 0, 0.5, -10)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = ToggleButton

            local ToggleText = Instance.new("TextLabel")
            ToggleText.Name = "ToggleText"
            ToggleText.Size = UDim2.new(1, -30, 1, 0)
            ToggleText.Position = UDim2.new(0, 30, 0, 0)
            ToggleText.BackgroundTransparency = 1
            ToggleText.Text = toggleName
            ToggleText.TextColor3 = Color3.fromRGB(200, 200, 200)
            ToggleText.TextSize = 14
            ToggleText.Font = Enum.Font.SourceSans
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left
            ToggleText.Parent = ToggleFrame

            local toggled = false
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(60, 60, 60)
                if callback then callback(toggled) end
            end)
        end

        function Tab:AddSlider(sliderName, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = sliderName .. "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = ContentFrame

            local SliderText = Instance.new("TextLabel")
            SliderText.Name = "SliderText"
            SliderText.Size = UDim2.new(1, 0, 0, 20)
            SliderText.BackgroundTransparency = 1
            SliderText.Text = sliderName
            SliderText.TextColor3 = Color3.fromRGB(200, 200, 200)
            SliderText.TextSize = 14
            SliderText.Font = Enum.Font.SourceSans
            SliderText.TextXAlignment = Enum.TextXAlignment.Left
            SliderText.Parent = SliderFrame

            local SliderBack = Instance.new("Frame")
            SliderBack.Name = "SliderBack"
            SliderBack.Size = UDim2.new(1, 0, 0, 5)
            SliderBack.Position = UDim2.new(0, 0, 0.5, 0)
            SliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderBack.BorderSizePixel = 0
            SliderBack.Parent = SliderFrame

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 2)
            UICorner.Parent = SliderBack

            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBack

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 2)
            UICorner.Parent = SliderFill

            local SliderValue = Instance.new("TextLabel")
            SliderValue.Name = "SliderValue"
            SliderValue.Size = UDim2.new(1, 0, 0, 20)
            SliderValue.Position = UDim2.new(0, 0, 1, -20)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Color3.fromRGB(200, 200, 200)
            SliderValue.TextSize = 14
            SliderValue.Font = Enum.Font.SourceSans
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame

            local function updateSlider(input)
                local sizeX = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                SliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
                local value = math.floor(min + (max - min) * sizeX)
                SliderValue.Text = tostring(value)
                if callback then callback(value) end
            end

            SliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    updateSlider(input)
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            updateSlider(input)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if connection then connection:Disconnect() end
                        end
                    end)
                end
            end)
        end

        function Tab:AddDropdown(dropdownName, options, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = dropdownName .. "Dropdown"
            DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = ContentFrame

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = DropdownFrame

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 1, 0)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = dropdownName
            DropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            DropdownButton.TextSize = 14
            DropdownButton.Font = Enum.Font.SourceSans
            DropdownButton.Parent = DropdownFrame

            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Name = "OptionsFrame"
            OptionsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
            OptionsFrame.Position = UDim2.new(0, 0, 1, 0)
            OptionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            OptionsFrame.BorderSizePixel = 0
            OptionsFrame.Visible = false
            OptionsFrame.Parent = DropdownFrame

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = OptionsFrame

            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptionButton.TextSize = 14
                OptionButton.Font = Enum.Font.SourceSans
                OptionButton.Parent = OptionsFrame

                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = option
                    OptionsFrame.Visible = false
                    if callback then callback(option) end
                end)
            end

            DropdownButton.MouseButton1Click:Connect(function()
                OptionsFrame.Visible = not OptionsFrame.Visible
            end)
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, content in pairs(ContentHolder:GetChildren()) do
                content.Visible = false
            end
            ContentFrame.Visible = true
        end)

        return Tab
    end

    -- Make the windows draggable
    local function makeDraggable(topbarObject, object)
        local dragging
        local dragInput
        local dragStart
        local startPos

        local function update(input)
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        topbarObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = object.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        topbarObject.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    -- Make both windows draggable
    makeDraggable(TabsFrame, TabsFrame)
    makeDraggable(MainFrame, MainFrame)

    -- Initialize the first tab
    local firstTab = next(ContentHolder:GetChildren())
    if firstTab then
        firstTab.Visible = true
    end

    return Window
end

-- Add a function to create a section within a tab
function Tab:AddSection(sectionName)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = sectionName .. "Section"
    SectionFrame.Size = UDim2.new(1, 0, 0, 30)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Parent = ContentFrame

    local SectionText = Instance.new("TextLabel")
    SectionText.Name = "SectionText"
    SectionText.Size = UDim2.new(1, 0, 1, 0)
    SectionText.BackgroundTransparency = 1
    SectionText.Text = sectionName
    SectionText.TextColor3 = Color3.fromRGB(255, 170, 0)
    SectionText.TextSize = 16
    SectionText.Font = Enum.Font.SourceSansBold
    SectionText.TextXAlignment = Enum.TextXAlignment.Left
    SectionText.Parent = SectionFrame

    return SectionFrame
end

-- Add a function to create a button
function Tab:AddButton(buttonName, callback)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = buttonName .. "Button"
    ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.Parent = ContentFrame

    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.BorderSizePixel = 0
    Button.Text = buttonName
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSans
    Button.Parent = ButtonFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- Add a function to create a color picker
function Tab:AddColorPicker(colorPickerName, defaultColor, callback)
    local ColorPickerFrame = Instance.new("Frame")
    ColorPickerFrame.Name = colorPickerName .. "ColorPicker"
    ColorPickerFrame.Size = UDim2.new(1, 0, 0, 30)
    ColorPickerFrame.BackgroundTransparency = 1
    ColorPickerFrame.Parent = ContentFrame

    local ColorPickerButton = Instance.new("TextButton")
    ColorPickerButton.Name = "ColorPickerButton"
    ColorPickerButton.Size = UDim2.new(0, 30, 0, 30)
    ColorPickerButton.Position = UDim2.new(0, 0, 0, 0)
    ColorPickerButton.BackgroundColor3 = defaultColor
    ColorPickerButton.BorderSizePixel = 0
    ColorPickerButton.Text = ""
    ColorPickerButton.Parent = ColorPickerFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = ColorPickerButton

    local ColorPickerText = Instance.new("TextLabel")
    ColorPickerText.Name = "ColorPickerText"
    ColorPickerText.Size = UDim2.new(1, -40, 1, 0)
    ColorPickerText.Position = UDim2.new(0, 40, 0, 0)
    ColorPickerText.BackgroundTransparency = 1
    ColorPickerText.Text = colorPickerName
    ColorPickerText.TextColor3 = Color3.fromRGB(200, 200, 200)
    ColorPickerText.TextSize = 14
    ColorPickerText.Font = Enum.Font.SourceSans
    ColorPickerText.TextXAlignment = Enum.TextXAlignment.Left
    ColorPickerText.Parent = ColorPickerFrame

    -- Implement color picker functionality here
    -- This could involve creating a color wheel or using a plugin

    ColorPickerButton.MouseButton1Click:Connect(function()
        -- Open color picker UI
        -- Update ColorPickerButton.BackgroundColor3
        -- Call callback with new color
    end)
end

return Library
