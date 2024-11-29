local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local NotificationLib = {}

-- GUI Setup
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "FireNotifGui"
NotifGui.Parent = RunService:IsStudio() and Player.PlayerGui or game:GetService("CoreGui")

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Position = UDim2.new(0, 20, 0.5, -20)
Container.Size = UDim2.new(0, 350, 1, 0) -- Full vertical space
Container.BackgroundTransparency = 1
Container.ClipsDescendants = true
Container.Parent = NotifGui

local Padding = 10 -- Spacing between notifications
local Notifications = {}

-- Utility Functions
local function CreateRoundedBackground()
    local Frame = Instance.new("Frame")
    Frame.BackgroundTransparency = 0.2
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BorderSizePixel = 0

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    return Frame
end

local function CreateShadow()
    local Shadow = Instance.new("ImageLabel")
    Shadow.Image = "rbxassetid://5761498316"
    Shadow.BackgroundTransparency = 1
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(17, 17, 283, 283)
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    return Shadow
end

local function CreateLabel(Text, Font, TextSize, Color)
    local Label = Instance.new("TextLabel")
    Label.Text = Text
    Label.Font = Font
    Label.TextSize = TextSize
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color or Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.RichText = true
    return Label
end

local function FadeOut(Frame, Duration)
    task.delay(Duration, function()
        local FadeTween = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Position = Frame.Position + UDim2.new(0, 0, 0, 50),
        })
        FadeTween:Play()

        for _, Descendant in ipairs(Frame:GetDescendants()) do
            if Descendant:IsA("TextLabel") or Descendant:IsA("ImageLabel") then
                TweenService:Create(Descendant, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    TextTransparency = 1,
                    ImageTransparency = 1,
                }):Play()
            end
        end

        FadeTween.Completed:Connect(function()
            Frame:Destroy()
            table.remove(Notifications, table.find(Notifications, Frame))
            NotificationLib.UpdatePositions()
        end)
    end)
end

-- Update all notification positions
function NotificationLib.UpdatePositions()
    local TotalHeight = 0
    for _, Frame in ipairs(Notifications) do
        local TargetPos = UDim2.new(0, 0, 0, TotalHeight + Padding)
        TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = TargetPos,
        }):Play()
        TotalHeight = TotalHeight + Frame.AbsoluteSize.Y + Padding
    end
end

-- Main Notification Function
function NotificationLib.Notify(Properties)
    local Title = Properties.Title or "Notification"
    local Description = Properties.Description or ""
    local Duration = Properties.Duration or 5
    local Icon = Properties.Icon -- Optional icon
    local Color = Properties.Color or Color3.fromRGB(255, 255, 255)

    -- Calculate height dynamically
    local TotalHeight = 50 -- Base height
    local TextSize = TextService:GetTextSize(Description, 14, Enum.Font.Gotham, Vector2.new(300, math.huge))
    if Description ~= "" then
        TotalHeight = TotalHeight + TextSize.Y + 10
    end

    -- Create Notification Frame
    local Frame = CreateRoundedBackground()
    Frame.Size = UDim2.new(1, 0, 0, TotalHeight)
    Frame.Position = UDim2.new(0, 0, 0, -TotalHeight) -- Start offscreen
    Frame.Parent = Container

    -- Add Shadow
    local Shadow = CreateShadow()
    Shadow.Parent = Frame

    -- Add Icon if provided
    if Icon then
        local IconImage = Instance.new("ImageLabel")
        IconImage.Image = Icon
        IconImage.Size = UDim2.new(0, 40, 0, 40)
        IconImage.Position = UDim2.new(0, 10, 0, 5)
        IconImage.BackgroundTransparency = 1
        IconImage.Parent = Frame
    end

    -- Add Title
    local TitleLabel = CreateLabel(Title, Enum.Font.GothamBold, 16, Color)
    TitleLabel.Position = UDim2.new(0, Icon and 60 or 10, 0, 5)
    TitleLabel.Size = UDim2.new(1, -(Icon and 70 or 20), 0, 20)
    TitleLabel.Parent = Frame

    -- Add Description
    if Description ~= "" then
        local DescLabel = CreateLabel(Description, Enum.Font.Gotham, 14)
        DescLabel.Position = UDim2.new(0, Icon and 60 or 10, 0, 30)
        DescLabel.Size = UDim2.new(1, -(Icon and 70 or 20), 0, TextSize.Y)
        DescLabel.TextWrapped = true
        DescLabel.Parent = Frame
    end

    -- Add to active notifications
    table.insert(Notifications, Frame)
    NotificationLib.UpdatePositions()

    -- Fade out after duration
    FadeOut(Frame, Duration)
end

return NotificationLib
