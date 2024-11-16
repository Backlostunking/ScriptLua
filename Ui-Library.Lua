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

-- Create a Frame with improved color and size customization
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

-- Create a Tab System
function UILibrary:CreateTab(parent, tabNames)
    local TabFrame = self:CreateFrame(parent, UDim2.new(1, 0, 0.1, 0), nil, Color3.fromRGB(25, 25, 25), UDim.new(0, 0))
    local Buttons = {}
    
    for i, tabName in ipairs(tabNames) do
        local TabButton = self:CreateButton(TabFrame, tabName, UDim2.new(1 / #tabNames, 0, 1, 0), UDim2.new((i - 1) / #tabNames, 0, 0, 0), Color3.fromRGB(50, 50, 50))
        table.insert(Buttons, TabButton)
    end
    
    return TabFrame, Buttons
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

-- Create a Button with hover color effect
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

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)

    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = color or Color3.fromRGB(25, 25, 25)
    end)

    return Button
end

-- Add more functionalities below as needed...

return UILibrary
