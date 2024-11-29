local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Player = game:GetService("Players").LocalPlayer

-- Create GUI
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "DynamicNotifGui"
NotifGui.Parent = RunService:IsStudio() and Player.PlayerGui or game:GetService("CoreGui")

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Position = UDim2.new(0, 20, 0.1, 0)
Container.Size = UDim2.new(0, 350, 0.8, 0) -- Adjustable height to fit more notifications
Container.BackgroundTransparency = 1
Container.Parent = NotifGui

local Padding = 10
local CachedObjects = {}
local MaxNotifications = 5 -- Maximum number of visible notifications at once
local TweenTime = 0.3
local TweenStyle = Enum.EasingStyle.Quint
local TweenDirection = Enum.EasingDirection.Out

-- Utility Functions
local function Round2px()
    local Frame = Instance.new("Frame")
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    Frame.ClipsDescendants = true
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    return Frame
end

local function Shadow2px()
    local Shadow = Instance.new("ImageLabel")
    Shadow.Image = "rbxassetid://5761498316"
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(17, 17, 283, 283)
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundTransparency = 1
    Shadow.ImageTransparency = 0.5
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    return Shadow
end

local function TitleLabel(Text)
    local Title = Instance.new("TextLabel")
    Title.Text = Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    return Title
end

local function DescriptionLabel(Text)
    local Desc = Instance.new("TextLabel")
    Desc.Text = Text
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 14
    Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    Desc.BackgroundTransparency = 1
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextWrapped = true
    return Desc
end

local function RepositionNotifications()
    for index, Notification in ipairs(CachedObjects) do
        local TargetPosition = UDim2.new(0, Padding, 0, (index - 1) * (Notification.AbsoluteSize.Y + Padding))
        TweenService:Create(Notification, TweenInfo.new(TweenTime, TweenStyle, TweenDirection), {
            Position = TargetPosition
        }):Play()
    end
end

local function FadeOutAfter(Object, Duration)
    wait(Duration)
    local Tween = TweenService:Create(Object, TweenInfo.new(0.5, TweenStyle, TweenDirection), {
        BackgroundTransparency = 1
    })
    Tween:Play()
    for _, Descendant in ipairs(Object:GetDescendants()) do
        if Descendant:IsA("TextLabel") then
            TweenService:Create(Descendant, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        end
    end
    Tween.Completed:Wait()
    Object:Destroy()
    table.remove(CachedObjects, table.find(CachedObjects, Object))
    RepositionNotifications()
end

-- Notification Module
return {
    Notify = function(Properties)
        Properties = typeof(Properties) == "table" and Properties or {}
        local Title = Properties.Title or "Notification"
        local Description = Properties.Description or ""
        local Duration = Properties.Duration or 5

        -- Calculate Height
        local Height = 50 -- Base height for the title
        if Description ~= "" then
            local TextSize = TextService:GetTextSize(Description, 14, Enum.Font.Gotham, Vector2.new(Container.AbsoluteSize.X - Padding * 2, math.huge))
            Height += TextSize.Y + 10
        end

        -- Create Notification
        local Notification = Round2px()
        Notification.Size = UDim2.new(1, 0, 0, Height)
        Notification.Position = UDim2.new(0, Padding, 0, (#CachedObjects * (Height + Padding)))
        Notification.Parent = Container

        -- Add Title
        local TitleObj = TitleLabel(Title)
        TitleObj.Size = UDim2.new(1, -20, 0, 30)
        TitleObj.Position = UDim2.new(0, 10, 0, 5)
        TitleObj.Parent = Notification

        -- Add Description
        if Description ~= "" then
            local DescObj = DescriptionLabel(Description)
            DescObj.Size = UDim2.new(1, -20, 0, Height - 40)
            DescObj.Position = UDim2.new(0, 10, 0, 35)
            DescObj.Parent = Notification
        end

        -- Add Shadow
        local Shadow = Shadow2px()
        Shadow.Parent = Notification

        -- Add to CachedObjects
        table.insert(CachedObjects, Notification)

        -- Reposition Notifications if they exceed MaxNotifications
        if #CachedObjects > MaxNotifications then
            local Oldest = table.remove(CachedObjects, 1)
            Oldest:Destroy()
        end

        RepositionNotifications()

        -- Fade Out
        coroutine.wrap(FadeOutAfter)(Notification, Duration)
    end,
}
