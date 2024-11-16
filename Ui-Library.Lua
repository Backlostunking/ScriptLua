local UILibrary = {}

-- Create a ScreenGui
function UILibrary:CreateScreenGui(name, parent)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = name or "CustomUI"
    ScreenGui.Parent = parent or game.CoreGui
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    return ScreenGui
end

-- Create a Frame with a slick modern design
function UILibrary:CreateFrame(parent, size, position, color, cornerRadius)
    local Frame = Instance.new("Frame")
    Frame.Size = size or UDim2.new(0.4, 0, 0.5, 0)
    Frame.Position = position or UDim2.new(0.3, 0, 0.25, 0)
    Frame.BackgroundColor3 = color or Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = cornerRadius or UDim.new(0, 10)

    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(60, 60, 60)

    return Frame
end

-- Create a Button with hover effect
function UILibrary:CreateButton(parent, text, size, position, color, onClick)
    local Button = Instance.new("TextButton")
    Button.Size = size or UDim2.new(0.3, 0, 0.1, 0)
    Button.Position = position or UDim2.new(0.05, 0, 0.2, 0)
    Button.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
    Button.Text = text or "Button"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 18
    Button.Parent = parent

    local UICorner = Instance.new("UICorner", Button)
    UICorner.CornerRadius = UDim.new(0, 5)

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)

    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
    end)

    Button.MouseButton1Click:Connect(function()
        if onClick then
            onClick()
        end
    end)

    return Button
end

-- Create a Toggle
function UILibrary:CreateToggle(parent, text, position, onToggle)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(0.3, 0, 0.08, 0)
    Toggle.Position = position or UDim2.new(0.05, 0, 0.4, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.Parent = parent

    local UICorner = Instance.new("UICorner", Toggle)
    UICorner.CornerRadius = UDim.new(0, 5)

    local ToggleText = Instance.new("TextLabel", Toggle)
    ToggleText.Text = text or "Toggle"
    ToggleText.Size = UDim2.new(0.8, 0, 1, 0)
    ToggleText.Position = UDim2.new(0.05, 0, 0, 0)
    ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Font = Enum.Font.SourceSansBold
    ToggleText.TextSize = 18

    local Switch = Instance.new("TextButton", Toggle)
    Switch.Size = UDim2.new(0.15, 0, 0.6, 0)
    Switch.Position = UDim2.new(0.8, 0, 0.2, 0)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Switch.Text = ""
    Switch.BorderSizePixel = 0

    local State = false

    Switch.MouseButton1Click:Connect(function()
        State = not State
        Switch.BackgroundColor3 = State and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
        if onToggle then
            onToggle(State)
        end
    end)

    return Toggle
end

-- Create a Dropdown
function UILibrary:CreateDropdown(parent, options, position, onSelect)
    local Dropdown = Instance.new("Frame")
    Dropdown.Size = UDim2.new(0.4, 0, 0.08, 0)
    Dropdown.Position = position or UDim2.new(0.05, 0, 0.55, 0)
    Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Dropdown.Parent = parent

    local UICorner = Instance.new("UICorner", Dropdown)
    UICorner.CornerRadius = UDim.new(0, 5)

    local Selected = Instance.new("TextButton", Dropdown)
    Selected.Size = UDim2.new(1, 0, 1, 0)
    Selected.Text = options[1] or "Select"
    Selected.TextColor3 = Color3.fromRGB(255, 255, 255)
    Selected.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Selected.Font = Enum.Font.SourceSansBold
    Selected.TextSize = 18

    local OptionsFrame = Instance.new("Frame", Dropdown)
    OptionsFrame.Size = UDim2.new(1, 0, #options * 0.08, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 1, 0)
    OptionsFrame.BackgroundTransparency = 1
    OptionsFrame.Visible = false

    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton", OptionsFrame)
        OptionButton.Size = UDim2.new(1, 0, 1 / #options, 0)
        OptionButton.Position = UDim2.new(0, 0, (i - 1) / #options, 0)
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        OptionButton.Font = Enum.Font.SourceSansBold
        OptionButton.TextSize = 16

        OptionButton.MouseButton1Click:Connect(function()
            Selected.Text = option
            OptionsFrame.Visible = false
            if onSelect then
                onSelect(option)
            end
        end)
    end

    Selected.MouseButton1Click:Connect(function()
        OptionsFrame.Visible = not OptionsFrame.Visible
    end)

    return Dropdown
end

return UILibrary
