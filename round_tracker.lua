-- Clear any previous GUI
pcall(function() game.CoreGui.AbyssalHub:Destroy() end)

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "AbyssalHub"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 300, 0, 250)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Name = "MainFrame"

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Abyssal Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.TextAlign = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center

local InputBoxLiveRounds = Instance.new("TextBox", Frame)
InputBoxLiveRounds.PlaceholderText = "Live rounds (e.g., 3)"
InputBoxLiveRounds.Size = UDim2.new(1, -20, 0, 30)
InputBoxLiveRounds.Position = UDim2.new(0, 10, 0, 50)
InputBoxLiveRounds.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputBoxLiveRounds.TextColor3 = Color3.fromRGB(255, 255, 255)

local InputBoxTotalRounds = Instance.new("TextBox", Frame)
InputBoxTotalRounds.PlaceholderText = "Total rounds (e.g., 6)"
InputBoxTotalRounds.Size = UDim2.new(1, -20, 0, 30)
InputBoxTotalRounds.Position = UDim2.new(0, 10, 0, 90)
InputBoxTotalRounds.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputBoxTotalRounds.TextColor3 = Color3.fromRGB(255, 255, 255)

local StartButton = Instance.new("TextButton", Frame)
StartButton.Text = "Start"
StartButton.Size = UDim2.new(1, -20, 0, 30)
StartButton.Position = UDim2.new(0, 10, 0, 130)
StartButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local LiveFiredButton = Instance.new("TextButton", Frame)
LiveFiredButton.Text = "Live Fired"
LiveFiredButton.Size = UDim2.new(0, 120, 0, 30)
LiveFiredButton.Position = UDim2.new(0, 10, 0, 170)
LiveFiredButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
LiveFiredButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local BlankFiredButton = Instance.new("TextButton", Frame)
BlankFiredButton.Text = "Blank Fired"
BlankFiredButton.Size = UDim2.new(0, 120, 0, 30)
BlankFiredButton.Position = UDim2.new(0, 150, 0, 170)
BlankFiredButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
BlankFiredButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local ResetButton = Instance.new("TextButton", Frame)
ResetButton.Text = "Reset"
ResetButton.Size = UDim2.new(1, -20, 0, 30)
ResetButton.Position = UDim2.new(0, 10, 0, 210)
ResetButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Data storage
local data = { liveRounds = 0, totalRounds = 0 }

-- Function to update the main screen text
local function updateScreen()
    Title.Text = "Abyssal Hub - Live: " .. data.liveRounds .. " / Blank: " .. (data.totalRounds - data.liveRounds)
end

-- Start button function
StartButton.MouseButton1Click:Connect(function()
    local liveRounds = tonumber(InputBoxLiveRounds.Text)
    local totalRounds = tonumber(InputBoxTotalRounds.Text)
    
    if liveRounds and totalRounds and liveRounds <= totalRounds and totalRounds > 0 then
        data.liveRounds = liveRounds
        data.totalRounds = totalRounds
        updateScreen()

        InputBoxLiveRounds.Visible = false
        InputBoxTotalRounds.Visible = false
        StartButton.Visible = false

        LiveFiredButton.Visible = true
        BlankFiredButton.Visible = true
        ResetButton.Visible = true
    else
        Title.Text = "Invalid input, try again!"
    end
end)

-- Live Fired button function
LiveFiredButton.MouseButton1Click:Connect(function()
    if data.liveRounds > 0 then
        data.liveRounds = data.liveRounds - 1
        data.totalRounds = data.totalRounds - 1
        updateScreen()
    else
        Title.Text = "No live rounds left!"
    end
end)

-- Blank Fired button function
BlankFiredButton.MouseButton1Click:Connect(function()
    if data.totalRounds > 0 then
        data.totalRounds = data.totalRounds - 1
        updateScreen()
    else
        Title.Text = "No blank rounds left!"
    end
end)

-- Reset button function
ResetButton.MouseButton1Click:Connect(function()
    InputBoxLiveRounds.Visible = true
    InputBoxTotalRounds.Visible = true
    StartButton.Visible = true

    LiveFiredButton.Visible = false
    BlankFiredButton.Visible = false
    ResetButton.Visible = false

    InputBoxLiveRounds.Text = ""
    InputBoxTotalRounds.Text = ""
    Title.Text = "Abyssal Hub"
end)

-- Display the GUI
ScreenGui.Parent = game:GetService("CoreGui")
