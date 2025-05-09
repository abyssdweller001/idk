-- Create the main GUI container
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "RoundTracker"

-- Frame for the main GUI
local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 300, 0, 350)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Name = "MainFrame"

-- UICorner for rounded corners
local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Title label
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Round Tracker"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextAlign = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center

-- Input for live rounds
local InputBoxLiveRounds = Instance.new("TextBox", Frame)
InputBoxLiveRounds.PlaceholderText = "Enter Live Rounds"
InputBoxLiveRounds.Size = UDim2.new(1, -20, 0, 30)
InputBoxLiveRounds.Position = UDim2.new(0, 10, 0, 50)
InputBoxLiveRounds.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputBoxLiveRounds.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Input for total rounds
local InputBoxTotalRounds = Instance.new("TextBox", Frame)
InputBoxTotalRounds.PlaceholderText = "Enter Total Rounds"
InputBoxTotalRounds.Size = UDim2.new(1, -20, 0, 30)
InputBoxTotalRounds.Position = UDim2.new(0, 10, 0, 90)
InputBoxTotalRounds.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputBoxTotalRounds.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Start Button
local StartButton = Instance.new("TextButton", Frame)
StartButton.Text = "Start"
StartButton.Size = UDim2.new(1, -20, 0, 30)
StartButton.Position = UDim2.new(0, 10, 0, 130)
StartButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Live Fired Button
local LiveFiredButton = Instance.new("TextButton", Frame)
LiveFiredButton.Text = "Live Fired"
LiveFiredButton.Size = UDim2.new(0, 120, 0, 30)
LiveFiredButton.Position = UDim2.new(0, 10, 0, 170)
LiveFiredButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
LiveFiredButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Blank Fired Button
local BlankFiredButton = Instance.new("TextButton", Frame)
BlankFiredButton.Text = "Blank Fired"
BlankFiredButton.Size = UDim2.new(0, 120, 0, 30)
BlankFiredButton.Position = UDim2.new(0, 150, 0, 170)
BlankFiredButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
BlankFiredButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Reset Button
local ResetButton = Instance.new("TextButton", Frame)
ResetButton.Text = "Reset"
ResetButton.Size = UDim2.new(1, -20, 0, 30)
ResetButton.Position = UDim2.new(0, 10, 0, 210)
ResetButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Data storage for live and total rounds
local data = { liveRounds = 0, totalRounds = 0 }

-- Function to update the screen
local function updateScreen()
    Title.Text = "Round Tracker\nLive: " .. data.liveRounds .. " / Blank: " .. (data.totalRounds - data.liveRounds)
end

-- Start Button functionality
StartButton.MouseButton1Click:Connect(function()
    local liveRounds = tonumber(InputBoxLiveRounds.Text)
    local totalRounds = tonumber(InputBoxTotalRounds.Text)

    if liveRounds and totalRounds and liveRounds <= totalRounds and totalRounds > 0 then
        data.liveRounds = liveRounds
        data.totalRounds = totalRounds
        updateScreen()

        -- Hide inputs and start button, show other controls
        InputBoxLiveRounds.Visible = false
        InputBoxTotalRounds.Visible = false
        StartButton.Visible = false

        LiveFiredButton.Visible = true
        BlankFiredButton.Visible = true
        ResetButton.Visible = true
    else
        Title.Text = "Invalid input. Please try again!"
    end
end)

-- Live Fired Button functionality
LiveFiredButton.MouseButton1Click:Connect(function()
    if data.liveRounds > 0 then
        data.liveRounds = data.liveRounds - 1
        data.totalRounds = data.totalRounds - 1
        updateScreen()
    else
        Title.Text = "No live rounds left!"
    end
end)

-- Blank Fired Button functionality
BlankFiredButton.MouseButton1Click:Connect(function()
    if data.totalRounds > 0 then
        data.totalRounds = data.totalRounds - 1
        updateScreen()
    else
        Title.Text = "No blank rounds left!"
    end
end)

-- Reset Button functionality
ResetButton.MouseButton1Click:Connect(function()
    InputBoxLiveRounds.Visible = true
    InputBoxTotalRounds.Visible = true
    StartButton.Visible = true

    LiveFiredButton.Visible = false
    BlankFiredButton.Visible = false
    ResetButton.Visible = false

    InputBoxLiveRounds.Text = ""
    InputBoxTotalRounds.Text = ""
    Title.Text = "Round Tracker"
end)

-- Show the GUI
ScreenGui.Parent = game:GetService("CoreGui")
