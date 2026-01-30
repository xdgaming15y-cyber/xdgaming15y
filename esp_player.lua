repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESP_ON = true
local billboards = {}
local highlights = {}

-- Stud → เมตร (ประมาณ)
local STUD_TO_METER = 0.28

--------------------------------------------------
-- สี HP%
--------------------------------------------------
local function getHPColor(percent)
	if percent >= 0.7 then
		return Color3.fromRGB(0,255,0)      -- เขียว
	elseif percent >= 0.3 then
		return Color3.fromRGB(255,170,0)    -- ส้ม
	else
		return Color3.fromRGB(255,0,0)      -- แดง
	end
end

--------------------------------------------------
-- สร้าง ESP
--------------------------------------------------
local function applyESP(player)
	if player == LocalPlayer then return end

	local function onCharacter(char)
		if billboards[player] then billboards[player]:Destroy() end
		if highlights[player] then highlights[player]:Destroy() end

		local hrp = char:WaitForChild("HumanoidRootPart",5)
		local hum = char:WaitForChild("Humanoid",5)
		if not hrp or not hum then return end

		-- ===== Billboard (กลางตัว) =====
		local gui = Instance.new("BillboardGui")
		gui.Name = "ESP_Billboard"
		gui.Adornee = hrp
		gui.Parent = hrp
		gui.Size = UDim2.fromOffset(260, 36)
		gui.StudsOffsetWorldSpace = Vector3.new(0,0,0)
		gui.AlwaysOnTop = true
		gui.MaxDistance = 0
		gui.Enabled = ESP_ON

		local txt = Instance.new("TextLabel")
		txt.Parent = gui
		txt.Size = UDim2.fromScale(1,1)
		txt.BackgroundTransparency = 1
		txt.TextSize = 14
		txt.Font = Enum.Font.GothamBold
		txt.TextXAlignment = Enum.TextXAlignment.Center
		txt.TextYAlignment = Enum.TextYAlignment.Center
		txt.TextStrokeTransparency = 0
		txt.TextStrokeColor3 = Color3.new(0,0,0)

		billboards[player] = gui

		-- ===== Highlight (เขียว บาง เห็นทะลุกำแพง) =====
		local hl = Instance.new("Highlight")
		hl.Adornee = char
		hl.Parent = char
		hl.FillColor = Color3.fromRGB(0,255,0)
		hl.OutlineColor = Color3.fromRGB(0,255,0)
		hl.FillTransparency = 0.85
		hl.OutlineTransparency = 0.3
		hl.Enabled = ESP_ON

		highlights[player] = hl
	end

	player.CharacterAdded:Connect(onCharacter)
	if player.Character then
		onCharacter(player.Character)
	end
end

--------------------------------------------------
-- ใส่ ESP ให้ทุกคน
--------------------------------------------------
for _,p in ipairs(Players:GetPlayers()) do
	applyESP(p)
end
Players.PlayerAdded:Connect(applyESP)

--------------------------------------------------
-- อัปเดต ชื่อ | ระยะ | HP% (ทุกเฟรม)
--------------------------------------------------
RunService.RenderStepped:Connect(function()
	if not ESP_ON then return end

	local myChar = LocalPlayer.Character
	local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end

	for player, gui in pairs(billboards) do
		local char = player.Character
		if char and gui and gui.Parent then
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChild("Humanoid")
			local txt = gui:FindFirstChildOfClass("TextLabel")

			if hrp and hum and txt then
				local studs = (myHRP.Position - hrp.Position).Magnitude
				local meters = math.floor(studs * STUD_TO_METER)

				local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
				txt.TextColor3 = getHPColor(hpPercent)

				txt.Text = string.format(
					"%s | %dm | %d%%",
					player.Name,
					meters,
					math.floor(hpPercent * 100)
				)
			end
		end
	end
end)

--------------------------------------------------
-- ปุ่มเปิด / ปิด ESP (รองรับมือถือ)
--------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.fromScale(0.15,0.065)
btn.Position = UDim2.fromScale(0.02,0.45)
btn.Text = "ESP ON"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(60,200,60)
btn.TextColor3 = Color3.new(1,1,1)
btn.Parent = screenGui

btn.MouseButton1Click:Connect(function()
	ESP_ON = not ESP_ON

	for _, g in pairs(billboards) do
		if g then g.Enabled = ESP_ON end
	end
	for _, h in pairs(highlights) do
		if h then h.Enabled = ESP_ON end
	end

	btn.Text = ESP_ON and "ESP ON" or "ESP OFF"
	btn.BackgroundColor3 = ESP_ON
		and Color3.fromRGB(60,200,60)
		or Color3.fromRGB(200,60,60)
end)
