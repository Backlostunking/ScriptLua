local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Player = game:GetService("Players").LocalPlayer

-- Create the main notification GUI
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "AkaliNotif"
NotifGui.Parent = RunService:IsStudio() and Player.PlayerGui or game:GetService("CoreGui")

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Position = UDim2.new(0, 20, 0.5, -20)
Container.Size = UDim2.new(0, 350, 0.5, 0)
Container.BackgroundTransparency = 1
Container.Parent = NotifGui

-- Helper: Create rounded image
local function CreateImage(ID)
    local Image = Instance.new("ImageLabel")
    Image.Image = ID
    Image.BackgroundTransparency = 1
    return Image
end

-- Create a rounded frame
local function RoundFrame()
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    local Image = CreateImage("rbxassetid://5761488251")
    Image.ScaleType = Enum.ScaleType.Slice
    Image.SliceCenter = Rect.new(2, 2, 298, 298)
    Image.ImageColor3 = Color3.fromRGB(20, 20, 40)
    Image.ImageTransparency = 0.1
    Image.Size = UDim2.new(1, 0, 1, 0)
    Image.Parent = Frame
    return Frame
end

-- Add shadow effect
local function AddShadow()
    local Shadow = CreateImage("rbxassetid://5761498316")
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(17, 17, 283, 283)
    Shadow.Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(40, 40)
    Shadow.Position = UDim2.fromOffset(-20, -20)
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    return Shadow
end

-- Configuration
local Padding = 10
local TweenTime = 0.8
local TweenStyle = Enum.EasingStyle.Quint
local TweenDirection = Enum.EasingDirection.Out
local Notifications = {}

local function UpdateNotifications()
    local CurrentY = 0
    for _, Notification in ipairs(Notifications) do
        local Frame, Progress = Notification.Frame, Notification.Progress
        Frame.Position = UDim2.new(0, Padding, 0, CurrentY + Padding)
        CurrentY += Frame.Size.Y.Offset + Padding
    end
end

RunService:BindToRenderStep("UpdateNotifications", Enum.RenderPriority.Last.Value, UpdateNotifications)

-- Add fade-out effect
local function FadeOut(Object, Duration)
    local FadeTween = TweenService:Create(Object, TweenInfo.new(Duration, TweenStyle, TweenDirection), {BackgroundTransparency = 1})
    FadeTween:Play()
    for _, Descendant in ipairs(Object:GetDescendants()) do
        if Descendant:IsA("TextLabel") or Descendant:IsA("ImageLabel") then
            TweenService:Create(Descendant, TweenInfo.new(Duration, TweenStyle, TweenDirection), {TextTransparency = 1, ImageTransparency = 1}):Play()
        end
    end
    FadeTween.Completed:Wait()
    Object:Destroy()
end

-- Create a notification
local function CreateNotification(Title, Description, Duration)
    local TotalHeight = 50
    local DescriptionSize = TextService:GetTextSize(Description, 14, Enum.Font.Gotham, Vector2.new(Container.AbsoluteSize.X - Padding * 2, math.huge))
    TotalHeight += DescriptionSize.Y + Padding

    -- Main notification frame
    local NotificationFrame = RoundFrame()
    NotificationFrame.Size = UDim2.new(0, Container.AbsoluteSize.X - Padding * 2, 0, TotalHeight)
    NotificationFrame.Position = UDim2.new(-1, 0, 0, Padding)

    -- Add shadow
    AddShadow().Parent = NotificationFrame

    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -Padding * 2, 0, 30)
    TitleLabel.Position = UDim2.fromOffset(Padding, Padding)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Title
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotificationFrame

    -- Description Label
    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Size = UDim2.new(1, -Padding * 2, 1, -50)
    DescriptionLabel.Position = UDim2.new(0, Padding, 0, 40)
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.Text = Description
    DescriptionLabel.TextSize = 14
    DescriptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.Parent = NotificationFrame

    -- Parent and add to notifications
    NotificationFrame.Parent = Container
    table.insert(Notifications, {Frame = NotificationFrame, Progress = 0})

    -- Fade out after duration
    task.delay(Duration, function()
        FadeOut(NotificationFrame, 0.5)
    end)
end

-- Return Notify Function
return {
    Notify = function(Properties)
        local Title = Properties.Title or "Notification"
        local Description = Properties.Description or ""
        local Duration = Properties.Duration or 5
        CreateNotification(Title, Description, Duration)
    end
}
