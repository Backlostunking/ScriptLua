-- Pro-Level GUI Library by lua god
local ProGuiLibrary = {}

-- Create a Screen GUI
function ProGuiLibrary:CreateGui(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = title

    -- Parent it to CoreGui (executor compatibility)
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
    ScreenGui.Parent = game.CoreGui

    return ScreenGui
end

-- Create a Draggable Frame
function ProGuiLibrary:CreateMainFrame(parent, title)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = parent
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Active = true
    MainFrame.Draggable = true -- Draggable for desktop and mobile!

    -- Add smooth round corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- Add Title Bar
    local TitleBar = Instance.new("TextLabel")
    TitleBar.Name = "TitleBar"
    TitleBar.Text = title
    TitleBar.Font = Enum.Font.GothamBold
    TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Parent = MainFrame

    local UICornerBar = Instance.new("UICorner")
    UICornerBar.CornerRadius = UDim.new(0, 10)
    UICornerBar.Parent = TitleBar

    return MainFrame
end

-- Create Tabs Section
function ProGuiLibrary:CreateTabSystem(parent)
    local TabFrame = Instance.new("Frame")
    TabFrame.Name = "TabFrame"
    TabFrame.Parent = parent
    TabFrame.Size = UDim2.new(0, 100, 1, -30)
    TabFrame.Position = UDim2.new(0, 0, 0, 30)
    TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabFrame.BorderSizePixel = 0

    -- Add round corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = TabFrame

    return TabFrame
end

-- Add Tab Button
function ProGuiLibrary:AddTab(tabFrame, tabName, onClick)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName
    TabButton.Text = tabName
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.Parent = tabFrame

    -- Add round corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = TabButton

    -- Hover effect
    TabButton.MouseEnter:Connect(function()
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    TabButton.MouseLeave:Connect(function()
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    TabButton.MouseButton1Click:Connect(onClick)

    return TabButton
end

-- Create Content Area
function ProGuiLibrary:CreateContentArea(parent)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = parent
    ContentArea.Size = UDim2.new(1, -100, 1, -30)
    ContentArea.Position = UDim2.new(0, 100, 0, 30)
    ContentArea.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ContentArea.BorderSizePixel = 0

    -- Add smooth round corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = ContentArea

    return ContentArea
end

-- Add a Button to Content Area
function ProGuiLibrary:AddButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Text = text
    Button.Font = Enum.Font.GothamBold
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Size = UDim2.new(0, 200, 0, 50)
    Button.Parent = parent

    -- Add hover effects
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)

    Button.MouseButton1Click:Connect(callback)

    -- Add round corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Button

    return Button
end

return ProGuiLibrary
