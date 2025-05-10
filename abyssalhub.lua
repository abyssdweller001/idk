-- Destroy existing GUI if it exists
pcall(function() game.CoreGui:FindFirstChild("AbyssalHub"):Destroy() end)

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local dragging
local dragInput
local dragStart
local startPos

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AbyssalHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 400)
Frame.Position = UDim2.new(0.5, -175, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = false -- We'll implement custom dragging

-- UICorner for rounded edges
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TopBar.BorderSizePixel = 0
TopBar.Parent = Frame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AbyssalHub - Round Tracker"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 18
MinimizeButton.Parent = TopBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 5)
MinimizeCorner.Parent = MinimizeButton

-- Body Frame
local Body = Instance.new("Frame")
Body.Size = UDim2.new(1, 0, 1, -40)
Body.Position = UDim2.new(0, 0, 0, 40)
Body.BackgroundTransparency = 1
Body.Parent = Frame

-- Input Fields
local TotalRoundsInput = Instance.new("TextBox")
TotalRoundsInput.Size = UDim2.new(0.8, 0, 0, 30)
TotalRoundsInput.Position = UDim2.new(0.1, 0, 0, 20)
TotalRoundsInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TotalRoundsInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TotalRoundsInput.PlaceholderText = "Enter Total Rounds"
TotalRoundsInput.Font = Enum.Font.SourceSans
TotalRoundsInput.TextSize = 14
TotalRoundsInput.Parent = Body

local TotalRoundsCorner = Instance.new("UICorner")
TotalRoundsCorner.CornerRadius = UDim.new(0, 5)
TotalRoundsCorner.Parent = TotalRoundsInput

local LiveRoundsInput = Instance.new("TextBox")
LiveRoundsInput.Size = UDim2.new(0.8, 0, 0, 30)
LiveRoundsInput.Position = UDim2.new(0.1, 0, 0, 60)
LiveRoundsInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
LiveRoundsInput.TextColor3 = Color3.fromRGB(255, 255, 255)
LiveRoundsInput.PlaceholderText = "Enter Live Rounds"
LiveRoundsInput.Font = Enum.Font.SourceSans
LiveRoundsInput.TextSize = 14
LiveRoundsInput.Parent = Body

local LiveRoundsCorner = Instance.new("UICorner")
LiveRoundsCorner.CornerRadius = UDim.new(0, 5)
LiveRoundsCorner.Parent = LiveRoundsInput

-- Start Button
local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(0.8, 0, 0, 30)
StartButton.Position = UDim2.new(0.1, 0, 0, 100)
StartButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
StartButton.Text = "Start"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.SourceSansBold
StartButton.TextSize = 14
StartButton.Parent = Body

local StartButtonCorner = Instance.new("UICorner")
StartButtonCorner.CornerRadius = UDim.new(0, 5)
StartButtonCorner.Parent = StartButton

-- Probability Display
local ProbabilityLabel = Instance.new("TextLabel")
ProbabilityLabel.Size = UDim2.new(0.8, 0, 0, 60)
ProbabilityLabel.Position = UDim2.new(0.1, 0, 0, 150)
ProbabilityLabel.BackgroundTransparency = 1
ProbabilityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ProbabilityLabel.Font = Enum.Font.SourceSans
ProbabilityLabel.TextSize = 14
ProbabilityLabel.TextWrapped = true
ProbabilityLabel.Text = ""
ProbabilityLabel.Visible = false
ProbabilityLabel.Parent = Body

-- Live Fired Button
local LiveFiredButton = Instance.new("TextButton")
LiveFiredButton.Size = UDim2.new(0.35, 0, 0, 30)
LiveFiredButton.Position = UDim2.new(0.1, 0, 0, 220)
LiveFiredButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
LiveFiredButton.Text = "Live Fired"
LiveFiredButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LiveFiredButton.Font = Enum.Font.SourceSansBold
LiveFiredButton.TextSize = 14
LiveFiredButton.Visible = false
LiveFiredButton.Parent = Body

local LiveFiredCorner = Instance.new("UICorner")
LiveFiredCorner.CornerRadius = UDim.new(0, 5)
LiveFiredCorner.Parent = LiveFiredButton

-- Blank Fired Button
local BlankFiredButton = Instance.new("TextButton")
BlankFiredButton.Size = UDim2.new(0.35, 0, 0, 30)
BlankFiredButton.Position = UDim2.new(0.55, 0, 0, 220)
BlankFiredButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
BlankFiredButton.Text = "Blank Fired"
BlankFiredButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BlankFiredButton.Font = Enum.Font.SourceSansBold
BlankFiredButton.TextSize = 14
BlankFiredButton.Visible = false
BlankFiredButton.Parent = Body

local BlankFiredCorner = Instance.new("UICorner")
BlankFiredCorner.CornerRadius = UDim.new(0, 5)
BlankFiredCorner.Parent = BlankFiredButton

-- Reset Button
local ResetButton = Instance.new("TextButton")
ResetButton.Size = UDim2.new(0.8, 0, 0, 30)
ResetButton.Position = UDim2.new(0.1, 0, 0, 270)
ResetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ResetButton.Text = "Reset"
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.Font = Enum.Font.SourceSansBold
ResetButton.TextSize = 14
ResetButton.Visible = false
ResetButton.Parent = Body

local ResetButtonCorner = Instance.new("UICorner")
ResetButtonCorner.CornerRadius = UDim.new(0, 5)
ResetButtonCorner.Parent = ResetButton

-- Variables for tracking rounds
local totalRounds = 0
local liveRounds = 0

-- Function to update probability display
local function updateProbability()
	if totalRounds > 0 then
		local probability = (liveRounds / totalRounds) * 100
		ProbabilityLabel.Text = string.format("Live Rounds: %d\nBlank Rounds: %d\nProbability of Live: %.2f%%", liveRounds, totalRounds - liveRounds, probability)
	else
		ProbabilityLabel.Text = "No rounds left."
	end
end

-- Start Button functionality
StartButton.MouseButton1Click:Connect(function()
	local totalInput = tonumber(TotalRoundsInput.Text)
	local liveInput = tonumber(LiveRoundsInput.Text)
	if totalInput and liveInput and liveInput <= totalInput then
		totalRounds = totalInput
		liveRounds = liveInput
		
::contentReference[oaicite:4]{index=4}
 
