repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

------------------------------------------------
-- LOADING UI (เหมือนเดิม)
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
Stroke.Transparency = 0.2

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
Button.Text = "KILL PLAYER : OFF"
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

local HideSound = Instance.new("Sound", SoundService)
HideSound.SoundId = "rbxassetid://9118826047"
HideSound.Volume = 1

------------------------------------------------
-- KILL PLAYER (OPTIMIZED / NO WARP)
------------------------------------------------
local Enabled = false
local PlayerList = {}

Button.MouseButton1Click:Connect(function()
	ClickSound:Play()
	Enabled = not Enabled
	Button.Text = Enabled and "KILL PLAYER : ON" or "KILL PLAYER : OFF"
	Button.TextColor3 = Enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)

-- เก็บ Player list
local function UpdatePlayers()
	table.clear(PlayerList)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP then
			table.insert(PlayerList, plr)
		end
	end
end

UpdatePlayers()
Players.PlayerAdded:Connect(UpdatePlayers)
Players.PlayerRemoving:Connect(UpdatePlayers)

-- Loop เบา ๆ
task.spawn(function()
	while true do
		task.wait(0.1)
		if not Enabled then continue end

		local char = LP.Character
		local tool = char and char:FindFirstChildOfClass("Tool")
		local handle = tool and tool:FindFirstChild("Handle")
		if not handle then continue end

		tool:Activate()

		for _, plr in ipairs(PlayerList) do
			local c = plr.Character
			local hum = c and c:FindFirstChild("Humanoid")
			local hrp = c and c:FindFirstChild("HumanoidRootPart")

			if hum and hrp and hum.Health > 0 then
				firetouchinterest(handle, hrp, 0)
				firetouchinterest(handle, hrp, 1)
			end
		end
	end
end)
