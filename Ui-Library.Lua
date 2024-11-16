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

-- Create a Frame
function UILibrary:CreateFrame(parent, color, cornerRadius)
    local Frame = Instance.new("Frame")
    Frame.BackgroundColor3 = color or Color3.fromRGB(30, 30, 30)  -- Default color
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    if cornerRadius then
        local UICorner = Instance.new("UICorner", Frame)
        UICorner.CornerRadius = cornerRadius or UDim.new(0, 12)  -- Default corner radius
    end

    return Frame
end

-- Make Frame Draggable
function UILibrary:MakeDraggable(frame, dragHandle)
    local UIS = game:GetService("UserInputService")
    local dragging, dragStart, startPos

    dragHandle = dragHandle or frame
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Create a Text Label
function UILibrary:CreateLabel(parent, text, color)
    local Label = Instance.new("TextLabel")
    Label.Text = text or "Label"
    Label.TextColor3 = color or Color3.fromRGB(255, 255, 255)  -- Default text color
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 20
    Label.BackgroundTransparency = 1
    Label.Parent = parent

    return Label
end

-- Create a Button
function UILibrary:CreateButton(parent, text, color, onClick)
    local Button = Instance.new("TextButton")
    Button.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)  -- Default button color
    Button.Text = text or "Button"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 18
    Button.Parent = parent

    local UICorner = Instance.new("UICorner", Button)
    UICorner.CornerRadius = UDim.new(0, 8)

    Button.MouseButton1Click:Connect(function()
        if onClick then
            onClick()
        end
    end)

    return Button
end

-- Create a Toggle Button
function UILibrary:CreateToggle(parent, text, color, defaultState, onToggle)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)  -- Default toggle color
    ToggleButton.Text = text or "Toggle"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextSize = 16
    ToggleButton.Parent = parent

    local UICorner = Instance.new("UICorner", ToggleButton)
    UICorner.CornerRadius = UDim.new(0, 8)

    local toggleState = defaultState or false -- Initial state
    local function updateState()
        toggleState = not toggleState
        ToggleButton.Text = text .. ": " .. (toggleState and "ON" or "OFF")
        if onToggle then
            onToggle(toggleState)
        end
    end

    ToggleButton.MouseButton1Click:Connect(updateState)
    updateState() -- Initialize button text

    return ToggleButton
end

-- Create a TextBox
function UILibrary:CreateTextBox(parent, placeholder, color, onSubmit)
    local TextBox = Instance.new("TextBox")
    TextBox.PlaceholderText = placeholder or "Type here..."
    TextBox.Text = ""
    TextBox.BackgroundColor3 = color or Color3.fromRGB(60, 60, 60)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 18
    TextBox.Parent = parent

    local UICorner = Instance.new("UICorner", TextBox)
    UICorner.CornerRadius = UDim.new(0, 5)

    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and onSubmit then
            onSubmit(TextBox.Text)
            TextBox.Text = ""
        end
    end)

    return TextBox
end

-- Create a Tab
function UILibrary:CreateTab(parent, tabName, color)
    local Tab = Instance.new("Frame")
    Tab.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)  -- Default tab color
    Tab.BorderSizePixel = 0
    Tab.Parent = parent

    local TabLabel = UILibrary:CreateLabel(Tab, tabName, Color3.fromRGB(255, 255, 255))

    -- Add a button to the tab
    local AddButton = UILibrary:CreateButton(Tab, "Add Button", Color3.fromRGB(70, 70, 70), function()
        print(tabName .. " Add Button clicked!")
    end)

    return Tab
end

-- Animation: Fade In
function UILibrary:FadeIn(instance, duration)
    instance.BackgroundTransparency = 1
    local tween = game:GetService("TweenService"):Create(instance, TweenInfo.new(duration or 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    })
    tween:Play()
end

return UILibrary
