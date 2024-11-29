--[[
Here How You Can Use My Notifications Reamke From Nameless admin!
local Notifications = loadstring(game:HttpGet("https://raw.githubusercontent.com/Backlostunking/ScriptLua/refs/heads/main/NotificationRemakeTrue.Lua"))()

Notifications.Notify({
    Title = "🔥 Welcome!",
    Description = "This is Notification!",
    Duration = 5
})

Notifications.Notify({
    Title = "Info",
    Description = "You can now stack up to 6 notifications!",
    Duration = 5
})
--]]
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local Player = game:GetService("Players").LocalPlayer

-- Create ScreenGui
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "YNotifO"
NotifGui.IgnoreGuiInset = true -- Ignore system UI inset
NotifGui.Parent = RunService:IsStudio() and Player.PlayerGui or game:GetService("CoreGui")

-- Container for Notifications
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.AnchorPoint = Vector2.new(1, 1) -- Align notifications to the bottom-right
Container.Position = UDim2.new(1, -20, 1, -20) -- Bottom-right corner with margin
Container.Size = UDim2.new(0.3, 0, 0.8, 0) -- Max width 30%, height 80%
Container.BackgroundTransparency = 1
Container.ClipsDescendants = true
Container.Parent = NotifGui

-- Constants
local Padding = 10
local CachedObjects = {}
local TweenTime = 0.3
local TweenStyle = Enum.EasingStyle.Quint
local TweenDirection = Enum.EasingDirection.Out

-- Utility Functions
local function CalculateBounds()
    local Y = 0
    for _, Object in ipairs(CachedObjects) do
        Y += Object.AbsoluteSize.Y + Padding
    end
    return Y
end

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
    Title.TextSize = 16 -- Reduced for compact design
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    return Title
end

local function DescriptionLabel(Text)
    local Desc = Instance.new("TextLabel")
    Desc.Text = Text
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 13 -- Reduced for compact design
    Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    Desc.BackgroundTransparency = 1
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextWrapped = true
    return Desc
end

-- Fade-Out Effect
local function FadeOutAfter(Object, Duration)
    task.wait(Duration)
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
end

-- Notification Module
return {
    Notify = function(Properties)
        Properties = typeof(Properties) == "table" and Properties or {}
        local Title = Properties.Title or "Notification"
        local Description = Properties.Description or ""
        local Duration = Properties.Duration or 5

        -- Calculate Height
        local Height = 40 -- Base height
        if Description ~= "" then
            local TextSize = TextService:GetTextSize(Description, 13, Enum.Font.Gotham, Vector2.new(Container.AbsoluteSize.X - Padding * 2, math.huge))
            Height += TextSize.Y + 10
        end

        -- Create Notification
        local NewNotification = Round2px()
        NewNotification.Size = UDim2.new(1, 0, 0, Height)
        NewNotification.Position = UDim2.new(1, 0, 1, -CalculateBounds() - Padding * (#CachedObjects + 1))
        NewNotification.AnchorPoint = Vector2.new(1, 1) -- Align to bottom-right

        -- Add Title
        local TitleObj = TitleLabel(Title)
        TitleObj.Size = UDim2.new(1, -20, 0, 20)
        TitleObj.Position = UDim2.new(0, 10, 0, 5)
        TitleObj.Parent = NewNotification

        -- Add Description
        if Description ~= "" then
            local DescObj = DescriptionLabel(Description)
            DescObj.Size = UDim2.new(1, -20, 0, Height - 30)
            DescObj.Position = UDim2.new(0, 10, 0, 25)
            DescObj.Parent = NewNotification
        end

        -- Add Shadow
        local Shadow = Shadow2px()
        Shadow.Parent = NewNotification

        -- Parent and Animate
        NewNotification.Parent = Container
        table.insert(CachedObjects, NewNotification)

        -- Move to Visible Position
        local Tween = TweenService:Create(NewNotification, TweenInfo.new(TweenTime, TweenStyle, TweenDirection), {
            Position = UDim2.new(1, 0, 1, -CalculateBounds())
        })
        Tween:Play()

        -- Fade Out After Duration
        coroutine.wrap(FadeOutAfter)(NewNotification, Duration)
    end,
}
