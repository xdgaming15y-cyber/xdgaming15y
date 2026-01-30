repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESP_ON = true
local labels = {}
local highlights = {}

-- แปลง Stud -> เมตร (ประมาณ)
local STUD_TO_METER = 0.28

--------------------------------------------------
-- สี + ชื่อทีม
--------------------------------------------------
local function getColor(player)
	if not player.Team then
		return Color3.fromRGB(160,160,160)
	end
	if player.Team.Name == "Guards" then
		return Color3.fromRGB(0,170,255)
	elseif player.Team.Name == "Inmates" then
		return Color3.fromRGB(255,140,0)
	elseif player.Team.Name == "Criminals" then
		return Color3.fromRGB(0,255,0)
	else
		return Color3.fromRGB(160,160,160)
	end
end

local function getTeam(player)
	return player.Team and player.Team.Name or "Neutral"
end

--------------------------------------------------
-- ESP
--------------------------------------------------
local function applyESP(player)
	if player == LocalPlayer then return end

	local function onChar(char)
		if labels[player] then labels[player]:Destroy() end
		if highlights[player] then highlights[player]:Destroy() end

		local hrp = char:WaitForChild("HumanoidRootPart",5)
		if not hrp then return end

		-- Billboard (ชื่อทีม + ระยะ)
		local gui = Instance.new("BillboardGui")
		gui.Name = "TeamESP"
		gui.Parent = hrp
		gui.Adornee = hrp
		gui.Size = UDim2.fromOffset(140,36)
		gui.StudsOffsetWorldSpace = Vector3.new(0,0,0)
		gui.AlwaysOnTop = true
		gui.MaxDistance = 0 -- ไม่จำกัดระยะ
		gui.Enabled = ESP_ON

		local txt = Instance.new("TextLabel", gui)
		txt.Size = UDim2.fromScale(1,1)
		txt.BackgroundTransparency = 1
		txt.TextScaled = false
		txt.TextSize = 14
		txt.Font = Enum.Font.GothamBold
		txt.TextColor3 = getColor(player)
		txt.TextStrokeColor3 = Color3.new(0,0,0)
		txt.TextStrokeTransparency = 0

		labels[player] = gui

		-- Highlight บาง ๆ
		local hl = Instance.new("Highlight")
		hl.Parent = char
		hl.Adornee = char
		hl.FillColor = getColor(player)
		hl.OutlineColor = getColor(player)
		hl.FillTransparency = 0.8     -- บาง
		hl.OutlineTransparency = 0.2  -- เส้นบาง
		hl.Enabled = ESP_ON

		highlights[player] = hl
	end

	player.CharacterAdded:Connect(onChar)
	if player.Character then onChar(player.Character) end

	player:GetPropertyChangedSignal("Team"):Connect(function()
		if labels[player] then
			local t = labels[player]:FindFirstChildOfClass("TextLabel")
			if t then t.TextColor3 = getColor(player) end
		end
		if highlights[player] then
			highlights[player].FillColor = getColor(player)
			highlights[player].OutlineColor = getColor(player)
		end
	end)
end

--------------------------------------------------
-- ผู้เล่นทั้งหมด
--------------------------------------------------
for _,p in ipairs(Players:GetPlayers()) do
	applyESP(p)
end
Players.PlayerAdded:Connect(applyESP)

--------------------------------------------------
-- อัปเดตข้อความ (ทีม + ระยะเป็นเมตร)
--------------------------------------------------
RunService.RenderStepped:Connect(function()
	if not ESP_ON then return end
	local myChar = LocalPlayer.Character
	local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end

	for player,gui in pairs(labels) do
		if player.Character and gui and gui.Parent then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			local txt = gui:FindFirstChildOfClass("TextLabel")
			if hrp and txt then
				local studs = (myHRP.Position - hrp.Position).Magnitude
				local meters = math.floor(studs * STUD_TO_METER)
				txt.Text = string.format("%s | %dm", getTeam(player), meters)
			end
		end
	end
end)

--------------------------------------------------
-- ปุ่มเปิด / ปิด
--------------------------------------------------
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromScale(0.13,0.06)
btn.Position = UDim2.fromScale(0.02,0.45)
btn.Text = "ESP ON"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(60,200,60)
btn.TextColor3 = Color3.new(1,1,1)

btn.MouseButton1Click:Connect(function()
	ESP_ON = not ESP_ON
	for _,b in pairs(labels) do if b then b.Enabled = ESP_ON end end
	for _,h in pairs(highlights) do if h then h.Enabled = ESP_ON end end
	btn.Text = ESP_ON and "ESP ON" or "ESP OFF"
	btn.BackgroundColor3 = ESP_ON and Color3.fromRGB(60,200,60) or Color3.fromRGB(200,60,60)
end)
