-- Destroy existing GUI
pcall(function() game.CoreGui:FindFirstChild("AbyssalHub"):Destroy() end)

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AbyssalHub"
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 300, 0, 220)
main.Position = UDim2.new(0.35, 0, 0.35, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "AbyssalHub - Round Tracker"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = main

local minimize = Instance.new("TextButton")
minimize.Text = "-"
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -30, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 14
minimize.Parent = main

local body = Instance.new("Frame")
body.Name = "Body"
body.Position = UDim2.new(0, 0, 0, 30)
body.Size = UDim2.new(1, 0, 1, -30)
body.BackgroundTransparency = 1
body.Parent = main

local input = Instance.new("TextBox")
input.PlaceholderText = "Total/Live Rounds (e.g., 6/2)"
input.Size = UDim2.new(1, -20, 0, 30)
input.Position = UDim2.new(0, 10, 0, 10)
input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.Parent = body

local output = Instance.new("TextLabel")
output.Text = "Waiting for input..."
output.Size = UDim2.new(1, -20, 0, 50)
output.Position = UDim2.new(0, 10, 0, 50)
output.TextWrapped = true
output.BackgroundTransparency = 1
output.TextColor3 = Color3.fromRGB(255, 255, 255)
output.Font = Enum.Font.Gotham
output.TextSize = 14
output.TextYAlignment = Enum.TextYAlignment.Top
output.Parent = body

local buttons = {}
local state = { live = 0, total = 0 }

local function updateText()
	local blank = state.total - state.live
	local chance = state.total > 0 and (state.live / state.total * 100) or 0
	output.Text = string.format("Live: %d\nBlank: %d\nChance: %.2f%%", state.live, blank, chance)
end

local function addButton(text, posY, callback)
	local btn = Instance.new("TextButton")
	btn.Text = text
	btn.Size = UDim2.new(0.45, 0, 0, 30)
	btn.Position = posY
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Parent = body
	btn.MouseButton1Click:Connect(callback)
	table.insert(buttons, btn)
end

input.FocusLost:Connect(function(enter)
	if not enter then return end
	local live, total = string.match(input.Text, "(%d+)%s*/%s*(%d+)")
	live, total = tonumber(live), tonumber(total)
	if live and total and live <= total then
		state.live = live
		state.total = total
		updateText()
	else
		output.Text = "Invalid format. Example: 3/6"
	end
end)

addButton("Live Fired", UDim2.new(0, 10, 0, 110), function()
	if state.live > 0 and state.total > 0 then
		state.live -= 1
		state.total -= 1
		updateText()
	else
		output.Text = "No rounds left."
	end
end)

addButton("Blank Fired", UDim2.new(0.55, 10, 0, 110), function()
	if state.total > 0 then
		state.total -= 1
		updateText()
	else
		output.Text = "No rounds left."
	end
end)

addButton("Reset", UDim2.new(0, 10, 0, 150), function()
	state.live = 0
	state.total = 0
	output.Text = "Waiting for input..."
end)

-- Minimize
local isMinimized = false
minimize.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	body.Visible = not isMinimized
	minimize.Text = isMinimized and "+" or "-"
end)

-- Dragging
local dragging, offset
title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		offset = input.Position - main.Position
	end
end)
title.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		main.Position = UDim2.new(0, input.Position.X - offset.X, 0, input.Position.Y - offset.Y)
	end
end)
