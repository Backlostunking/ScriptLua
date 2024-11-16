-- Initialize the library
local UILibrary = {}

-- Create GUI
function UILibrary:CreateGui(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = title

    -- Parent it to CoreGui (executor-compatible)
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui) -- Synapse GUI protection
    end
    ScreenGui.Parent = game.CoreGui

    return ScreenGui
end

-- Create Tab System
function UILibrary:CreateTabSystem(parent)
    local TabSystem = Instance.new("Frame")
    TabSystem.Name = "TabSystem"
    TabSystem.Parent = parent
    TabSystem.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    TabSystem.Size = UDim2.new(0, 300, 0, 50)
    TabSystem.Position = UDim2.new(0, 10, 0, 10)
    TabSystem.Active = true -- Allow dragging
    TabSystem.Draggable = true -- For desktop & mobile

    return TabSystem
end

-- Add a Tab
function UILibrary:AddTab(tabSystem, tabName)
    local Tab = Instance.new("TextButton")
    Tab.Name = tabName
    Tab.Text = tabName
    Tab.Size = UDim2.new(0, 100, 0, 50)
    Tab.Parent = tabSystem
    Tab.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    return Tab
end

-- Add a Button
function UILibrary:AddButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Text = text
    Button.Size = UDim2.new(0, 200, 0, 50)
    Button.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    Button.Parent = parent

    Button.MouseButton1Click:Connect(function()
        callback()
    end)

    return Button
end

-- Add a Toggle
function UILibrary:AddToggle(parent, text, default, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Text = text .. (default and " [ON]" or " [OFF]")
    Toggle.Size = UDim2.new(0, 200, 0, 50)
    Toggle.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    Toggle.Parent = parent

    local state = default
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Toggle.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)

    return Toggle
end

-- Add Dropdown
function UILibrary:AddDropdown(parent, text, options, callback)
    local Dropdown = Instance.new("TextButton")
    Dropdown.Text = text .. " (Click to Select)"
    Dropdown.Size = UDim2.new(0, 200, 0, 50)
    Dropdown.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    Dropdown.Parent = parent

    Dropdown.MouseButton1Click:Connect(function()
        local option = options[math.random(1, #options)] -- Randomly select for now
        Dropdown.Text = text .. ": " .. option
        callback(option)
    end)

    return Dropdown
end

return UILibrary
