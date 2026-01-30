-- JUMP BOOTS + JUMP LOCK
-- + / - ปรับค่า | เปิดปิด UI ด้วยปุ่มข้างจอ | set ครั้งเดียว
-- ❌ ไม่มีระบบลาก

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local jumpEnabled = false
local jumpValue = 80 -- ค่า Jump เริ่มต้น
local jumpConnection

--------------------------------------------------
-- 🔒 JumpPower Lock
--------------------------------------------------
local function lockJump(humanoid)
	if jumpConnection then
		jumpConnection:Disconnect()
	end

	humanoid.UseJumpPower = true
	humanoid.JumpPower = jumpEnabled and jumpValue or 50

	jumpConnection = humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
		if jumpEnabled and humanoid.JumpPower ~= jumpValue then
			humanoid.JumpPower = jumpValue
		end
	end)
end

--------------------------------------------------
-- ♻️ Respawn
--------------------------------------------------
local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")
	task.wait(0.3)
	lockJump(humanoid)
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
	onCharacterAdded(player.Character)
end

--------------------------------------------------
-- 🧱 UI
--------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.28, 0.3)
frame.Position = UDim2.fromScale(0.64, 0.33) -- 👉 ฝั่งขวา
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.25)
title.Text = "JUMP BOOTS"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

--------------------------------------------------
-- ช่องใส่ JUMP
--------------------------------------------------
local box = Instance.new("TextBox", frame)
box.Size = UDim2.fromScale(0.7,0.2)
box.Position = UDim2.fromScale(0.15,0.32)
box.PlaceholderText = "ใส่ค่า JUMP"
box.Text = tostring(jumpValue)
box.TextScaled = true
box.BackgroundColor3 = Color3.fromRGB(45,45,45)
box.TextColor3 = Color3.new(1,1,1)
box.ClearTextOnFocus = false
Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

box:GetPropertyChangedSignal("Text"):Connect(function()
	box.Text = box.Text:gsub("%D", "")
end)

-- ➖
local minus = Instance.new("TextButton", frame)
minus.Size = UDim2.fromScale(0.12,0.2)
minus.Position = UDim2.fromScale(0.02,0.32)
minus.Text = "-"
minus.TextScaled = true
minus.BackgroundColor3 = Color3.fromRGB(70,70,70)
minus.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minus).CornerRadius = UDim.new(0,8)

-- ➕
local plus = Instance.new("TextButton", frame)
plus.Size = UDim2.fromScale(0.12,0.2)
plus.Position = UDim2.fromScale(0.86,0.32)
plus.Text = "+"
plus.TextScaled = true
plus.BackgroundColor3 = Color3.fromRGB(70,70,70)
plus.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", plus).CornerRadius = UDim.new(0,8)

minus.MouseButton1Click:Connect(function()
	local v = tonumber(box.Text) or 0
	box.Text = tostring(math.max(0, v - 5))
end)

plus.MouseButton1Click:Connect(function()
	local v = tonumber(box.Text) or 0
	box.Text = tostring(v + 5)
end)

--------------------------------------------------
-- ปุ่ม set
--------------------------------------------------
local button = Instance.new("TextButton", frame)
button.Size = UDim2.fromScale(0.8,0.25)
button.Position = UDim2.fromScale(0.1,0.6)
button.Text = "set"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(200,60,60)
button.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", button).CornerRadius = UDim.new(0,12)

button.MouseButton1Click:Connect(function()
	jumpValue = tonumber(box.Text) or jumpValue
	jumpEnabled = true

	button.Text = "OK"
	button.BackgroundColor3 = Color3.fromRGB(60,200,60)

	task.delay(0.3,function()
		button.Text = "set"
		button.BackgroundColor3 = Color3.fromRGB(200,60,60)
	end)

	if player.Character then
		lockJump(player.Character:WaitForChild("Humanoid"))
	end
end)

--------------------------------------------------
-- ➕➖ ปุ่มข้างจอ เปิด / ปิด UI (ฝั่งขวา)
--------------------------------------------------
local sideBtn = Instance.new("TextButton", gui)
sideBtn.Size = UDim2.fromScale(0.06,0.12)
sideBtn.Position = UDim2.fromScale(0.94,0.45) -- 👉 ขวาสุด
sideBtn.Text = "-"
sideBtn.TextScaled = true
sideBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
sideBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", sideBtn).CornerRadius = UDim.new(0,12)

local uiOpen = true
local openPos = frame.Position
local closePos = UDim2.fromScale(1.1, openPos.Y.Scale) -- 👉 ซ่อนออกขวา

sideBtn.MouseButton1Click:Connect(function()
	uiOpen = not uiOpen
	if uiOpen then
		frame:TweenPosition(openPos,"Out","Quad",0.3,true)
		sideBtn.Text = "-"
	else
		frame:TweenPosition(closePos,"Out","Quad",0.3,true)
		sideBtn.Text = "+"
	end
end)
