repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

------------------------------------------------
-- LOADING UI
------------------------------------------------
local LoadGui = Instance.new("ScreenGui", PG)
LoadGui.ResetOnSpawn = false

local LoadFrame = Instance.new("Frame", LoadGui)
LoadFrame.Size = UDim2.fromOffset(420,180)
LoadFrame.Position = UDim2.fromScale(0.5,0.5)
LoadFrame.AnchorPoint = Vector2.new(0.5,0.5)
LoadFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0,14)
Instance.new("UIStroke", LoadFrame).Color = Color3.fromRGB(255,0,0)

local LoadTitle = Instance.new("TextLabel", LoadFrame)
LoadTitle.Size = UDim2.new(1,0,0,50)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "Thank you for using."
LoadTitle.TextColor3 = Color3.fromRGB(255,0,0)
LoadTitle.Font = Enum.Font.Arcade
LoadTitle.TextScaled = true

local LoadText = Instance.new("TextLabel", LoadFrame)
LoadText.Position = UDim2.new(0,0,0,60)
LoadText.Size = UDim2.new(1,0,0,40)
LoadText.BackgroundTransparency = 1
LoadText.Text = "Loading..."
LoadText.TextColor3 = Color3.fromRGB(255,255,255)
LoadText.Font = Enum.Font.GothamBold
LoadText.TextScaled = true

local BarBack = Instance.new("Frame", LoadFrame)
BarBack.Position = UDim2.new(0.1,0,0.75,0)
BarBack.Size = UDim2.new(0.8,0,0,18)
BarBack.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", BarBack)

local Bar = Instance.new("Frame", BarBack)
Bar.Size = UDim2.new(0,0,1,0)
Bar.BackgroundColor3 = Color3.fromRGB(255,0,0)
Instance.new("UICorner", Bar)

TweenService:Create(Bar,TweenInfo.new(2),{Size = UDim2.new(1,0,1,0)}):Play()
task.wait(2.2)
LoadGui:Destroy()

------------------------------------------------
-- MAIN UI
------------------------------------------------
local Gui = Instance.new("ScreenGui", PG)
Gui.ResetOnSpawn = false

local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.fromOffset(300,140)
Frame.Position = UDim2.fromScale(0.5,0.5)
Frame.AnchorPoint = Vector2.new(0.5,0.5)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,16)

local Stroke = Instance.new("UIStroke", Frame)
Stroke.Color = Color3.fromRGB(255,0,0)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "Thank you for using."
Title.TextColor3 = Color3.fromRGB(255,0,0)
Title.Font = Enum.Font.Arcade
Title.TextScaled = true

local Button = Instance.new("TextButton", Frame)
Button.Position = UDim2.new(0.1,0,0.45,0)
Button.Size = UDim2.new(0.8,0,0,50)
Button.BackgroundColor3 = Color3.fromRGB(15,15,15)
Button.Text = "KILL MOB : OFF"
Button.TextColor3 = Color3.fromRGB(255,0,0)
Button.Font = Enum.Font.GothamBlack
Button.TextScaled = true
Instance.new("UICorner", Button)

------------------------------------------------
-- SOUND
------------------------------------------------
local ClickSound = Instance.new("Sound", SoundService)
ClickSound.SoundId = "rbxassetid://12221967"
ClickSound.Volume = 1

------------------------------------------------
-- KILL ALL MOB (SMOOTH VERSION)
------------------------------------------------
local Enabled = false
local MobList = {}

local ATTACK_RANGE = math.huge     -- ระยะตี
local MAX_MOBS = 20          -- จำกัดจำนวน mob ต่อรอบ
local SCAN_COOLDOWN = false  -- กันสแกนรัว

Button.MouseButton1Click:Connect(function()
	ClickSound:Play()
	Enabled = not Enabled
	Button.Text = Enabled and "KILL MOB : ON" or "KILL MOB : OFF"
	Button.TextColor3 = Enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)

-- Scan Mob แบบเบา
local function ScanMobs()
	if SCAN_COOLDOWN then return end
	SCAN_COOLDOWN = true

	table.clear(MobList)
	for _, m in ipairs(workspace:GetDescendants()) do
		if m:IsA("Model")
		and m:FindFirstChild("Humanoid")
		and m:FindFirstChild("HumanoidRootPart")
		and not Players:GetPlayerFromCharacter(m) then
			table.insert(MobList, m)
		end
	end

	task.delay(1, function()
		SCAN_COOLDOWN = false
	end)
end

ScanMobs()
workspace.DescendantAdded:Connect(ScanMobs)

-- Loop ตี Mob
task.spawn(function()
	while true do
		task.wait(0.1)
		if not Enabled then continue end

		local char = LP.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local tool = char and char:FindFirstChildOfClass("Tool")
		local handle = tool and tool:FindFirstChild("Handle")
		if not (hrp and handle) then continue end

		tool:Activate()
		local hit = 0

		for _, mob in ipairs(MobList) do
			if hit >= MAX_MOBS then break end

			local hum = mob:FindFirstChild("Humanoid")
			local mhrp = mob:FindFirstChild("HumanoidRootPart")

			if hum and mhrp and hum.Health > 0 then
				if (mhrp.Position - hrp.Position).Magnitude <= ATTACK_RANGE then
					firetouchinterest(handle, mhrp, 0)
					firetouchinterest(handle, mhrp, 1)
					hit += 1
				end
			end
		end
	end
end)
