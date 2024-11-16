local UILibrary = {}

-- Theme settings
UILibrary.Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(50, 50, 50),
    ToggleOn = Color3.fromRGB(0, 200, 0),
    ToggleOff = Color3.fromRGB(200, 0, 0),
    Dropdown = Color3.fromRGB(70, 70, 70),
}

-- Create a new ScreenGui
function UILibrary:CreateGui(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = title
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    return screenGui
end

-- Create a new tab system
function UILibrary:CreateTabSystem(parent)
    local tabSystem = Instance.new("Frame")
    tabSystem.Size = UDim2.new(1, 0, 1, 0)
    tabSystem.BackgroundTransparency = 1
    tabSystem.Parent = parent

    local tabs = {}
    local tabButtons = {}
    local currentTab = nil

    -- Create a tab
    function tabSystem:AddTab(tabName)
        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 1, -30) -- Exclude space for buttons
        tabFrame.Position = UDim2.new(0, 0, 0, 30)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = #tabs == 0 -- Show the first tab by default
        tabFrame.Parent = tabSystem

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 100, 0, 30)
        button.Position = UDim2.new(0, (#tabButtons * 100), 0, 0)
        button.BackgroundColor3 = UILibrary.Theme.Button
        button.Text = tabName
        button.TextColor3 = UILibrary.Theme.Text
        button.Parent = tabSystem

        button.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            tabFrame.Visible = true
            currentTab = tabFrame
        end)

        table.insert(tabs, tabFrame)
        table.insert(tabButtons, button)
        return tabFrame
    end

    return tabSystem
end

-- Add widgets with auto positioning
function UILibrary:AddWidget(container, widgetType, properties)
    local widget = Instance.new(widgetType)
    widget.Size = UDim2.new(1, -10, 0, 40)
    widget.Position = UDim2.new(0, 5, 0, (#container:GetChildren() - 1) * 45) -- Auto position
    widget.BackgroundColor3 = UILibrary.Theme.Button
    widget.TextColor3 = UILibrary.Theme.Text
    widget.Font = Enum.Font.SourceSans
    widget.TextSize = 18
    for prop, value in pairs(properties or {}) do
        widget[prop] = value
    end
    widget.Parent = container

    return widget
end

-- Add a toggle
function UILibrary:AddToggle(container, text, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.Position = UDim2.new(0, 5, 0, (#container:GetChildren() - 1) * 45)
    frame.BackgroundTransparency = 1
    frame.Parent = container

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 40, 0, 40)
    toggleButton.BackgroundColor3 = defaultState and UILibrary.Theme.ToggleOn or UILibrary.Theme.ToggleOff
    toggleButton.Text = ""
    toggleButton.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 50, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = UILibrary.Theme.Text
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.Parent = frame

    toggleButton.MouseButton1Click:Connect(function()
        defaultState = not defaultState
        toggleButton.BackgroundColor3 = defaultState and UILibrary.Theme.ToggleOn or UILibrary.Theme.ToggleOff
        callback(defaultState)
    end)

    return frame
end

-- Add a dropdown
function UILibrary:AddDropdown(container, text, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.Position = UDim2.new(0, 5, 0, (#container:GetChildren() - 1) * 45)
    frame.BackgroundTransparency = 1
    frame.Parent = container

    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(0, 200, 0, 40)
    dropdown.BackgroundColor3 = UILibrary.Theme.Dropdown
    dropdown.Text = text
    dropdown.TextColor3 = UILibrary.Theme.Text
    dropdown.Font = Enum.Font.SourceSans
    dropdown.TextSize = 18
    dropdown.Parent = frame

    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(0, 200, 0, #options * 30)
    dropdownList.Position = UDim2.new(0, 0, 1, 0)
    dropdownList.BackgroundColor3 = UILibrary.Theme.Dropdown
    dropdownList.Visible = false
    dropdownList.Parent = frame

    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
        optionButton.BackgroundTransparency = 1
        optionButton.Text = option
        optionButton.TextColor3 = UILibrary.Theme.Text
        optionButton.Font = Enum.Font.SourceSans
        optionButton.TextSize = 18
        optionButton.Parent = dropdownList

        optionButton.MouseButton1Click:Connect(function()
            dropdown.Text = text .. ": " .. option
            dropdownList.Visible = false
            callback(option)
        end)
    end

    dropdown.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)

    return frame
end

return UILibrary
