-- Destroy existing GUI if it exists
pcall(function() game.CoreGui.RoundTracker:Destroy() end)

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "RoundTracker"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 300, 0, 250)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Name = "MainFrame"

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local InputBox = Instance.new("TextBox", Frame)
InputBox.PlaceholderText = "Enter round (e.g., 3/6)"
InputBox.Size = UDim2.new(1, -20, 0, 30)
InputBox.Position = UDim2.new(0, 10, 0, 10)
InputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local OutputLabel = Instance.new("TextLabel", Frame)
OutputLabel.Size = UDim2.new(1, -20, 0, 60)
OutputLabel.Position = UDim2.new(0, 10, 0, 50)
OutputLabel.BackgroundTransparency = 1
OutputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OutputLabel.TextWrapped = true
OutputLabel.Text = "Waiting for input..."
OutputLabel.TextYAlignment = Enum.TextYAlignment.Top

local Buttons = {}
local Commands = {"+", "-", "r", "h"}

for i, cmd in ipairs(Commands) do
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0, 60, 0, 30)
    Button.Position = UDim2.new(0, 10 + ((i - 1) * 70), 0, 130)
    Button.Text = cmd
    Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Buttons[cmd] = Button
end

-- State
local data = { numerator = 0, denominator = 0, result = 0 }
local original = { numerator = 0, denominator = 0 }

-- Functions
local function calc(n, d)
    local percentage = (n / d) * 100
    OutputLabel.Text = string.format("Live Round Probability: %.2f%%\nLive Rounds: %d\nBlank Rounds: %d", percentage, n, d - n)
    return percentage
end

local function resetData(n, d)
    data.numerator = n
    data.denominator = d
    data.result = calc(n, d)
    original.numerator = n
    original.denominator = d
end

-- InputBox Enter
InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local input = InputBox.Text
        local func = loadstring("return " .. input)
        if func then
            local success, _ = pcall(func)
            local n = tonumber(string.match(input, "^(%d+)"))
            local d = tonumber(string.match(input, "/(%d+)$"))
            if success and n and d and n <= d and d > 0 then
                resetData(n, d)
            else
                OutputLabel.Text = "Invalid input format or logic.\nUse format like 3/6"
            end
        else
            OutputLabel.Text = "Error parsing input."
        end
    end
end)

-- Button Events
Buttons["+"]:Connect(function()
    if data.numerator > 0 and data.denominator > 0 then
        data.numerator -= 1
        data.denominator -= 1
        data.result = calc(data.numerator, data.denominator)
    else
        OutputLabel.Text = "Error: Invalid game state."
    end
end)

Buttons["-"]:Connect(function()
    if data.denominator > 0 then
        data.denominator -= 1
        data.result = calc(data.numerator, data.denominator)
    else
        OutputLabel.Text = "Error: Invalid game state."
    end
end)

Buttons["r"]:Connect(function()
    OutputLabel.Text = "Round restarted."
    resetData(original.numerator, original.denominator)
end)

Buttons["h"]:Connect(function()
    OutputLabel.Text = "Commands:\n+ = Remove live\n- = Remove blank\nr = Restart\nEnter input like 3/6"
end)
