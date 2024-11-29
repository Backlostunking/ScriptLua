local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local NotificationLib = {}

-- Main GUI Setup
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "EpicNotifGui"
NotifGui.Parent = RunService:IsStudio() and game:GetService("CoreGui")

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Position = UDim2.new(0, 20, 0.5, -20)
Container.Size = UDim2.new(0, 300, 1, 0) -- Full vertical space
Container.BackgroundTransparency = 1
Container.ClipsDescendants = true
Container.Parent = NotifGui

local Padding = 10 -- Spacing between notifications
local MaxVisibleNotifications = 6 -- Limit to 6 visible notifications
local InstructionObjects = {}

-- Utility Functions
local function CreateImage(ID)
    local NewImage = Instance.new("ImageLabel")
    NewImage.Image = ID
    NewImage.BackgroundTransparency = 1
    return NewImage
end

local function CreateBackground()
    local Background = CreateImage("http://www.roblox.com/asset/?id=5761488251")
    Background.ScaleType = Enum.ScaleType.Slice
    Background.SliceCenter = Rect.new(2, 2, 298, 298)
    Background.ImageColor3 = Color3.fromRGB(12, 4, 20)
    Background.ImageTransparency = 0.14
    return Background
end

local function CreateShadow()
    local Shadow = CreateImage("http://www.roblox.com/asset/?id=5761498316")
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(17, 17, 283, 283)
    Shadow.Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30)
    Shadow.Position = -UDim2.fromOffset(15, 15)
    Shadow.ImageColor3 = Color3.fromRGB(26, 26, 26)
    return Shadow
end

local TitleSettings = {
    Font = Enum.Font.GothamSemibold,
    Size = 14,
}

local DescriptionSettings = {
    Font = Enum.Font.Gotham,
    Size = 14,
}

local function CreateLabel(Text, Font, Size)
    local Label = Instance.new("TextLabel")
    Label.Text = Text
    Label.Font = Font
    Label.TextSize = Size
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.RichText = true
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    return Label
end

local function TitleLabel(Text)
    return CreateLabel(Text, TitleSettings.Font, TitleSettings.Size)
end

local function DescriptionLabel(Text)
    return CreateLabel(Text, DescriptionSettings.Font, DescriptionSettings.Size)
end

-- Remove the oldest notification
local function RemoveOldestNotification()
    if #InstructionObjects > MaxVisibleNotifications then
        local Oldest = InstructionObjects[1]
        table.remove(InstructionObjects, 1)

        -- Tween the oldest notification out
        local TweenOut = TweenService:Create(Oldest[1], TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 20, 0.5, -50), -- Slide out of view
            BackgroundTransparency = 1,
        })
        TweenOut:Play()

        for _, Descendant in ipairs(Oldest[1]:GetDescendants()) do
            if Descendant:IsA("TextLabel") or Descendant:IsA("ImageLabel") then
                TweenService:Create(Descendant, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    TextTransparency = 1,
                    ImageTransparency = 1,
                }):Play()
            end
        end

        TweenOut.Completed:Connect(function()
            Oldest[1]:Destroy()
        end)
    end
end

-- Update notification positions dynamically
local function UpdateNotificationPositions()
    local TotalHeight = 0
    for _, Object in ipairs(InstructionObjects) do
        local Label = Object[1]
        local TargetPos = UDim2.new(0, 0, 0, TotalHeight)
        TweenService:Create(Label, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = TargetPos,
        }):Play()
        TotalHeight = TotalHeight + Label.AbsoluteSize.Y + Padding
    end
end

-- Fades out the notification after a duration
local function FadeOutAfter(Label, Seconds)
    task.wait(Seconds)
    TweenService:Create(Label, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1,
        Position = Label.Position + UDim2.new(0, 0, 0, 50),
    }):Play()

    for _, Descendant in ipairs(Label:GetDescendants()) do
        if Descendant:IsA("TextLabel") or Descendant:IsA("ImageLabel") then
            TweenService:Create(Descendant, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                ImageTransparency = 1,
            }):Play()
        end
    end

    task.wait(0.5)
    Label:Destroy()
    table.remove(InstructionObjects, table.find(InstructionObjects, Label))
    UpdateNotificationPositions()
end

-- Main Notification Function
function NotificationLib.Notify(Properties)
    local Title = Properties.Title or "Epic Notification"
    local Description = Properties.Description or ""
    local Duration = Properties.Duration or 5

    -- Calculate height dynamically
    local TotalHeight = Title and 26 or 0
    if Description then
        local TextSize = TextService:GetTextSize(Description, DescriptionSettings.Size, DescriptionSettings.Font, Vector2.new(Container.AbsoluteSize.X, math.huge))
        TotalHeight = TotalHeight + TextSize.Y + 8
    end

    -- Create notification frame
    local NewLabel = CreateBackground()
    NewLabel.Size = UDim2.new(1, 0, 0, TotalHeight)
    NewLabel.Position = UDim2.new(0, 20, 0.5, 0) -- Temporary position for animation
    NewLabel.Parent = Container

    -- Add shadow
    local Shadow = CreateShadow()
    Shadow.Parent = NewLabel

    -- Add title and description
    if Title then
        local NewTitle = TitleLabel(Title)
        NewTitle.Size = UDim2.new(1, -10, 0, 26)
        NewTitle.Position = UDim2.fromOffset(10, 0)
        NewTitle.Parent = NewLabel
    end

    if Description then
        local NewDescription = DescriptionLabel(Description)
        NewDescription.Size = UDim2.new(1, -10, 0, TotalHeight - 26)
        NewDescription.Position = UDim2.fromOffset(10, 26)
        NewDescription.Parent = NewLabel
    end

    -- Insert into active notifications
    table.insert(InstructionObjects, {NewLabel, 0, false})
    RemoveOldestNotification() -- Check if we need to remove any old notifications
    UpdateNotificationPositions()

    -- Fade out after duration
    coroutine.wrap(FadeOutAfter)(NewLabel, Duration)
end

return NotificationLib
