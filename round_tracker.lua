-- Destroy existing GUI if it exists
pcall(function() game.CoreGui:FindFirstChild("RoundTracker"):Destroy() end)

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "RoundTracker"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 320, 0, 240)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Name = "MainFrame"
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Title Bar
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Text = "Abyssal Hub"
TitleText.Size = UDim2.new(1, -30, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.SourceSansSemibold
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 18

-- Toggle content visibility
local ContentVisible = true
MinBtn.MouseButton1Click:Connect(function()
    ContentVisible = not ContentVisible
    for _, child in ipairs(Frame:GetChildren()) do
        if child ~= TitleBar and child:IsA("GuiObject") then
            child.Visible = ContentVisible
        end
    end
end)

local InputBox = Instance.new("TextBox", Frame)
InputBox.PlaceholderText = "Enter round (e.g., 3/6)"
InputBox.Size = UDim2.new(1, -20, 0, 30)
InputBox.Position = UDim2.new(0, 10, 0, 40)
InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.ClearTextOnFocus = false

local OutputLabel = Instance.new("TextLabel", Frame)
OutputLabel.Size = UDim2.new(1, -20, 0, 60)
OutputLabel.Position = UDim2.new(0, 10, 0, 80)
OutputLabel.BackgroundTransparency = 1
OutputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OutputLabel.TextWrapped = true
OutputLabel.Text = "Waiting for input..."
OutputLabel.TextYAlignment = Enum.TextYAlignment.Top
OutputLabel.TextXAlignment = Enum.TextXAlignment.Left

local Buttons = {}
local Commands = { "+", "-", "r", "h" }

for i, cmd in ipairs(Commands) do
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0, 60, 0, 30)
    Button.Position = UDim2.new(0, 10 + ((i - 1) * 70), 0, 160)
    Button.Text = cmd
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 18
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

-- Input
InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local input = InputBox.Text
        local n = tonumber(string.match(input, "^(%d+)"))
        local d = tonumber(string.match(input, "/(%d+)$"))
        if n and d and n <= d and d > 0 then
            resetData(n, d)
        else
            OutputLabel.Text = "Invalid input format or logic.\nUse format like 3/6"
        end
    end
end)

-- Buttons
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
