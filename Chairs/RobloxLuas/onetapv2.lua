local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Size = UDim2.new(1, -10, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 18
    TitleText.Font = Enum.Font.SourceSansBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar

    local TabsHolder = Instance.new("Frame")
    TabsHolder.Name = "TabsHolder"
    TabsHolder.Size = UDim2.new(0.3, 0, 1, -30)
    TabsHolder.Position = UDim2.new(0, 0, 0, 30)
    TabsHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabsHolder.BorderSizePixel = 0
    TabsHolder.Parent = MainFrame

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(0.7, 0, 1, -30)
    ContentHolder.Position = UDim2.new(0.3, 0, 0, 30)
    ContentHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ContentHolder.BorderSizePixel = 0
    ContentHolder.Parent = MainFrame

    local Window = {}

    function Window:AddTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.Position = UDim2.new(0, 0, 0, #TabsHolder:GetChildren() * 30)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.SourceSans
        TabButton.Parent = TabsHolder

        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = name .. "Content"
        ContentFrame.Size = UDim2.new(1, 0, 1, 0)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderSizePixel = 0
        ContentFrame.ScrollBarThickness = 4
        ContentFrame.Visible = false
        ContentFrame.Parent = ContentHolder

        local Tab = {}

        function Tab:AddToggle(toggleName, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = toggleName .. "Toggle"
            ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
            ToggleFrame.Position = UDim2.new(0, 10, 0, #ContentFrame:GetChildren() * 40)
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
                ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
                if callback then callback(toggled) end
            end)
        end

        function Tab:AddSlider(sliderName, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = sliderName .. "Slider"
            SliderFrame.Size = UDim2.new(1, -20, 0, 50)
            SliderFrame.Position = UDim2.new(0, 10, 0, #ContentFrame:GetChildren() * 60)
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

            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBack

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
            DropdownFrame.Size = UDim2.new(1, -20, 0, 30)
            DropdownFrame.Position = UDim2.new(0, 10, 0, #ContentFrame:GetChildren() * 40)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = ContentFrame

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

    -- Make the window draggable
    local dragging
    local dragInput
    local dragStart
    local startPos

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return Window
end

return Library