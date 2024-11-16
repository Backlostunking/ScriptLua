-- UI Library Module
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
function UILibrary:CreateFrame(parent, size, position, color, cornerRadius)
    local Frame = Instance.new("Frame")
    Frame.Size = size or UDim2.new(0.3, 0, 0.5, 0)
    Frame.Position = position or UDim2.new(0.35, 0, 0.25, 0)
    Frame.BackgroundColor3 = color or Color3.fromRGB(15, 15, 15)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    if cornerRadius then
        local UICorner = Instance.new("UICorner", Frame)
        UICorner.CornerRadius = cornerRadius or UDim.new(0, 10)
    end

    return Frame
end

-- Make Frame Draggable (Mobile + PC Support)
function UILibrary:MakeDraggable(frame, dragHandle)
    local UIS = game:GetService("UserInputService")
    local dragging, dragStart, startPos

    dragHandle = dragHandle or frame
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Create a Text Label
function UILibrary:CreateLabel(parent, text, size, position, color)
    local Label = Instance.new("TextLabel")
    Label.Size = size or UDim2.new(1, 0, 0.1, 0)
    Label.Position = position or UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text or "Label"
    Label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 18
    Label.Parent = parent

    return Label
end

-- Create a Button
function UILibrary:CreateButton(parent, text, size, position, color, onClick)
    local Button = Instance.new("TextButton")
    Button.Size = size or UDim2.new(0.2, 0, 0.1, 0)
    Button.Position = position or UDim2.new(0, 0, 0.1, 0)
    Button.BackgroundColor3 = color or Color3.fromRGB(25, 25, 25)
    Button.Text = text or "Button"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 16
    Button.Parent = parent

    local UICorner = Instance.new("UICorner", Button)
    UICorner.CornerRadius = UDim.new(0, 10)

    Button.MouseButton1Click:Connect(function()
        if onClick then
            onClick()
        end
    end)

    return Button
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
