local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

-- Screen GUI
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "UnNotifTrue"
NotifGui.Parent = RunService:IsStudio() and Player.PlayerGui or game:GetService("CoreGui")

-- Notification Container
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Position = UDim2.new(0, 20, 0.5, -20)
Container.Size = UDim2.new(0, 400, 0.5, 0)
Container.BackgroundTransparency = 1
Container.Parent = NotifGui

-- Constants
local Padding = 10
local TweenTime = 0.3
local TweenStyle = Enum.EasingStyle.Quint
local TweenDirection = Enum.EasingDirection.Out
local NotificationList = {}

-- Function to calculate stacked notification bounds
local function CalculateBounds()
    local TotalHeight = 0
    for _, Notification in pairs(NotificationList) do
        TotalHeight += Notification.AbsoluteSize.Y + Padding
    end
    return TotalHeight
end

-- Animate Notifications
local function AnimateNotifications()
    local CurrentY = 0
    for _, Notification in ipairs(NotificationList) do
        local Tween = TweenService:Create(Notification, TweenInfo.new(TweenTime, TweenStyle, TweenDirection), {
            Position = UDim2.new(0, Padding, 0, CurrentY + Padding)
        })
        Tween:Play()
        CurrentY += Notification.AbsoluteSize.Y + Padding
    end
end

-- Fade-out Animation
local function FadeOutNotification(Notification)
    local Tween = TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    Tween:Play()

    for _, Descendant in pairs(Notification:GetDescendants()) do
        if Descendant:IsA("TextLabel") or Descendant:IsA("ImageLabel") then
            TweenService:Create(Descendant, TweenInfo.new(0.5), {TextTransparency = 1, ImageTransparency = 1}):Play()
        end
    end

    Tween.Completed:Wait()
    Notification:Destroy()
end

-- Function to Create Notification
local function CreateNotification(Title, Description, Duration)
    -- Notification Frame
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    NotificationFrame.Size = UDim2.new(0, 400, 0, 80)
    NotificationFrame.Position = UDim2.new(-1, 0, 0, 0)
    NotificationFrame.Parent = Container
    NotificationFrame.ClipsDescendants = true

    -- Add Corner Radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = NotificationFrame

    -- Shadow Effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Image = "rbxassetid://5761498316"
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(17, 17, 283, 283)
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundTransparency = 1
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.Parent = NotificationFrame

    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -20, 0, 30)
    TitleLabel.Position = UDim2.fromOffset(10, 10)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotificationFrame

    -- Description Label
    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Text = Description
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.TextSize = 14
    DescriptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Size = UDim2.new(1, -20, 0, 40)
    DescriptionLabel.Position = UDim2.fromOffset(10, 40)
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescriptionLabel.Parent = NotificationFrame

    -- Insert Notification into List
    table.insert(NotificationList, NotificationFrame)
    AnimateNotifications()

    -- Auto-destroy After Duration
    task.delay(Duration, function()
        for i, Notif in pairs(NotificationList) do
            if Notif == NotificationFrame then
                table.remove(NotificationList, i)
                break
            end
        end
        FadeOutNotification(NotificationFrame)
        AnimateNotifications()
    end)
end

-- Return Notification Functionality
return {
    Notify = function(Properties)
        CreateNotification(Properties.Title or "Notification", Properties.Description or "", Properties.Duration or 5)
    end
}
