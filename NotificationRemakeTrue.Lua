local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local NotificationLib = {}

-- Main GUI Setup
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "EpicNotifGui"
NotifGui.Parent = RunService:IsStudio() and Player.PlayerGui or game:GetService("CoreGui")

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Position = UDim2.new(0, 20, 0.5, -20)
Container.Size = UDim2.new(0, 300, 0.5, 0)
Container.BackgroundTransparency = 1
Container.Parent = NotifGui

-- Utility Functions
local function CreateImage(ID)
    local NewImage = Instance.new("ImageLabel")
    NewImage.Image = ID
    NewImage.BackgroundTransparency = 1
    return NewImage
end

local function CreateBackground()
    local Background = CreateImage("rbxassetid://5761488251")
    Background.ScaleType = Enum.ScaleType.Slice
    Background.SliceCenter = Rect.new(2, 2, 298, 298)
    Background.ImageColor3 = Color3.fromRGB(10, 10, 25)
    Background.ImageTransparency = 0.1
    return Background
end

local function CreateShadow()
    local Shadow = CreateImage("rbxassetid://5761498316")
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(17, 17, 283, 283)
    Shadow.Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.3
    return Shadow
end

local function CreateTitleLabel(Text)
    local Label = Instance.new("TextLabel")
    Label.Text = Text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 16
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold!
    Label.RichText = true
    return Label
end

local function CreateDescriptionLabel(Text)
    local Label = Instance.new("TextLabel")
    Label.Text = Text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.RichText = true
    Label.TextWrapped = true
    return Label
end

-- Notification List
local Notifications = {}

-- Update notification positions
local function UpdateNotificationPositions()
    local TotalHeight = 0
    for _, Frame in ipairs(Notifications) do
        local TargetPosition = UDim2.new(0, 20, 0.5, -20 - TotalHeight)
        TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = TargetPosition,
        }):Play()
        TotalHeight = TotalHeight + Frame.AbsoluteSize.Y + 10
    end
end

-- Notification Function
function NotificationLib.Notify(Properties)
    local Title = Properties.Title or "Epic Notification"
    local Description = Properties.Description or ""
    local Duration = Properties.Duration or 5
    local Icon = Properties.Icon or nil -- Optional custom icon

    -- Calculate height based on content
    local TextSize = TextService:GetTextSize(Description, 14, Enum.Font.Gotham, Vector2.new(250, math.huge))
    local Height = 40 + TextSize.Y

    -- Create main notification frame
    local Frame = CreateBackground()
    Frame.Size = UDim2.new(1, 0, 0, Height)
    Frame.Position = UDim2.new(0, 20, 0.5, 0) -- Temporary position for animation
    Frame.Parent = Container

    -- Add shadow
    local Shadow = CreateShadow()
    Shadow.Parent = Frame

    -- Add optional icon
    if Icon then
        local IconImage = CreateImage(Icon)
        IconImage.Size = UDim2.fromOffset(30, 30)
        IconImage.Position = UDim2.new(0, 10, 0.5, -15)
        IconImage.Parent = Frame
    end

    -- Add title
    local TitleLabel = CreateTitleLabel(Title)
    TitleLabel.Size = UDim2.new(1, -50, 0, 20)
    TitleLabel.Position = UDim2.new(0, Icon and 50 or 10, 0, 5)
    TitleLabel.Parent = Frame

    -- Add description
    local DescriptionLabel = CreateDescriptionLabel(Description)
    DescriptionLabel.Size = UDim2.new(1, -20, 0, TextSize.Y)
    DescriptionLabel.Position = UDim2.new(0, 10, 0, 25)
    DescriptionLabel.Parent = Frame

    -- Insert to notifications list
    table.insert(Notifications, Frame)

    -- Update positions
    UpdateNotificationPositions()

    -- Tween out after duration
    task.delay(Duration, function()
        local TweenOut = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 20, 0.5, 100),
            Transparency = 1,
        })
        TweenOut:Play()
        TweenOut.Completed:Connect(function()
            Frame:Destroy()
            table.remove(Notifications, table.find(Notifications, Frame))
            UpdateNotificationPositions()
        end)
    end)
end

return NotificationLib
