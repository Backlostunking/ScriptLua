local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Player = game:GetService("Players").LocalPlayer

-- Create Notification GUI
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "FireNotifLibrary"
NotifGui.Parent = RunService:IsStudio() and Player.PlayerGui or game:GetService("CoreGui")

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Position = UDim2.new(0, 20, 0.5, -20)
Container.Size = UDim2.new(0, 350, 0.5, 0)
Container.BackgroundTransparency = 1
Container.Parent = NotifGui

-- Helper Functions
local function RoundFrame()
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 1
    local RoundImage = Instance.new("ImageLabel")
    RoundImage.Image = "http://www.roblox.com/asset/?id=5761488251"
    RoundImage.ScaleType = Enum.ScaleType.Slice
    RoundImage.SliceCenter = Rect.new(2, 2, 298, 298)
    RoundImage.ImageColor3 = Color3.fromRGB(25, 25, 35)
    RoundImage.ImageTransparency = 0.1
    RoundImage.Size = UDim2.new(1, 0, 1, 0)
    RoundImage.BackgroundTransparency = 1
    RoundImage.Parent = Frame
    return Frame
end

local function ShadowEffect()
    local Shadow = Instance.new("ImageLabel")
    Shadow.Image = "http://www.roblox.com/asset/?id=5761498316"
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(17, 17, 283, 283)
    Shadow.Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(40, 40)
    Shadow.Position = -UDim2.fromOffset(20, 20)
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.BackgroundTransparency = 1
    return Shadow
end

-- Configuration
local Padding = 10
local TweenTime = 0.8
local TweenStyle = Enum.EasingStyle.Quint
local TweenDirection = Enum.EasingDirection.Out

-- Notification Management
local NotificationQueue = {}
local LastTick = tick()

local function UpdateNotifications()
    local DeltaTime = tick() - LastTick
    local CurrentY = 0
    for _, Notification in ipairs(NotificationQueue) do
        local Label, Progress, Done = Notification[1], Notification[2], Notification[3]
        if not Done then
            if Progress < TweenTime then
                Notification[2] = math.clamp(Progress + DeltaTime, 0, TweenTime)
            else
                Notification[3] = true
            end
        end
        local NewPos = UDim2.new(0, Padding, 0, CurrentY + Padding)
        Label.Position = Label.Position:Lerp(NewPos, TweenService:GetValue(Progress / TweenTime, TweenStyle, TweenDirection))
        CurrentY = CurrentY + Label.AbsoluteSize.Y + Padding
    end
    LastTick = tick()
end

RunService:BindToRenderStep("NotificationUpdater", Enum.RenderPriority.Last.Value, UpdateNotifications)

-- Notification Creation
local function CreateNotification(Properties)
    local Title = Properties.Title or "Notification"
    local Description = Properties.Description or ""
    local Duration = Properties.Duration or 5

    -- Calculate Size
    local TextBounds = TextService:GetTextSize(Description, 16, Enum.Font.Gotham, Vector2.new(Container.AbsoluteSize.X - Padding * 2, math.huge))
    local TotalHeight = 40 + TextBounds.Y + Padding

    -- Create Notification Frame
    local Notification = RoundFrame()
    Notification.Size = UDim2.new(0, Container.AbsoluteSize.X - Padding * 2, 0, TotalHeight)
    Notification.Position = UDim2.new(-1, 0, 0, Padding)
    Notification.ClipsDescendants = true

    -- Add Shadow
    ShadowEffect().Parent = Notification

    -- Add Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -Padding * 2, 0, 20)
    TitleLabel.Position = UDim2.fromOffset(Padding, Padding)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Title
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notification

    -- Add Description
    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Size = UDim2.new(1, -Padding * 2, 1, -40)
    DescriptionLabel.Position = UDim2.new(0, Padding, 0, 30)
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.Text = Description
    DescriptionLabel.TextSize = 14
    DescriptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.Parent = Notification

    Notification.Parent = Container
    table.insert(NotificationQueue, {Notification, 0, false})

    -- Auto Remove
    task.delay(Duration, function()
        if Notification.Parent then
            TweenService:Create(Notification, TweenInfo.new(0.5, TweenStyle, TweenDirection), {BackgroundTransparency = 1}):Play()
            task.delay(0.5, function()
                Notification:Destroy()
            end)
        end
    end)
end

-- Return Notify Function
return {
    Notify = function(Properties)
        CreateNotification(Properties)
    end
}
