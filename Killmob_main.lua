do
	local _G,_s,_n,_u,_c,_e,_v =
		game.GetService,string.char,Instance.new,UDim2,Color3,Enum,Vector2

	repeat task.wait() until game:IsLoaded()

	local _={}
	_[0]=function(x)return _G(game,x)end

	local P=_[0](_s(80,108,97,121,101,114,115))
	local T=_[0](_s(84,119,101,101,110,83,101,114,118,105,99,101))
	local S=_[0](_s(83,111,117,110,100,83,101,114,118,105,99,101))

	local L=P.LocalPlayer
	local G=L:WaitForChild(_s(80,108,97,121,101,114,71,117,105))

	------------------------------------------------
	-- LOADING + MAIN (กองรวม)
	------------------------------------------------
	local A=_n(_s(83,99,114,101,101,110,71,117,105),G)
	A.ResetOnSpawn=false

	local B=_n(_s(70,114,97,109,101),A)
	B.Size=_u.fromOffset(420,180)
	B.Position=_u.fromScale(.5,.5)
	B.AnchorPoint=_v.new(.5,.5)
	B.BackgroundColor3=_c.fromRGB(0,0,0)
	_n(_s(85,73,67,111,114,110,101,114),B).CornerRadius=UDim.new(0,14)
	_n(_s(85,73,83,116,114,111,107,101),B).Color=_c.fromRGB(255,0,0)

	local C=_n(_s(84,101,120,116,76,97,98,101,108),B)
	C.Size=_u.new(1,0,0,50)
	C.BackgroundTransparency=1
	C.Text=_s(84,104,97,110,107,32,121,111,117,32,102,111,114,32,117,115,105,110,103,46)
	C.TextColor3=_c.fromRGB(255,0,0)
	C.Font=_e.Font.Arcade
	C.TextScaled=true

	local D=_n(_s(70,114,97,109,101),B)
	D.Position=_u.new(.1,0,.75,0)
	D.Size=_u.new(.8,0,0,18)
	D.BackgroundColor3=_c.fromRGB(25,25,25)
	_n(_s(85,73,67,111,114,110,101,114),D)

	local E=_n(_s(70,114,97,109,101),D)
	E.Size=_u.new(0,0,1,0)
	E.BackgroundColor3=_c.fromRGB(255,0,0)
	_n(_s(85,73,67,111,114,110,101,114),E)

	T:Create(E,TweenInfo.new(2),{Size=_u.new(1,0,1,0)}):Play()
	task.wait(2.2)
	A:Destroy()

	------------------------------------------------
	-- MAIN UI
	------------------------------------------------
	local A=_n(_s(83,99,114,101,101,110,71,117,105),G)
	A.ResetOnSpawn=false

	local B=_n(_s(70,114,97,109,101),A)
	B.Size=_u.fromOffset(300,140)
	B.Position=_u.fromScale(.5,.5)
	B.AnchorPoint=_v.new(.5,.5)
	B.BackgroundColor3=_c.fromRGB(0,0,0)
	B.Active=true
	B.Draggable=true
	_n(_s(85,73,67,111,114,110,101,114),B).CornerRadius=UDim.new(0,16)
	_n(_s(85,73,83,116,114,111,107,101),B).Color=_c.fromRGB(255,0,0)

	local C=_n(_s(84,101,120,116,76,97,98,101,108),B)
	C.Size=_u.new(1,0,0,40)
	C.BackgroundTransparency=1
	C.Text=_s(84,104,97,110,107,32,121,111,117,32,102,111,114,32,117,115,105,110,103,46)
	C.TextColor3=_c.fromRGB(255,0,0)
	C.Font=_e.Font.Arcade
	C.TextScaled=true

	local D=_n(_s(84,101,120,116,66,117,116,116,111,110),B)
	D.Position=_u.new(.1,0,.45,0)
	D.Size=_u.new(.8,0,0,50)
	D.BackgroundColor3=_c.fromRGB(15,15,15)
	D.Text=_s(75,73,76,76,32,77,79,66,32,58,32,79,70,70)
	D.TextColor3=_c.fromRGB(255,0,0)
	D.Font=_e.Font.GothamBlack
	D.TextScaled=true
	_n(_s(85,73,67,111,114,110,101,114),D)

	------------------------------------------------
	-- SOUND + LOGIC (กองเดียว)
	------------------------------------------------
	local Q=_n(_s(83,111,117,110,100),S)
	Q.SoundId=_s(114,98,120,97,115,115,101,116,105,100,58,47,47,49,50,50,50,49,57,54,55)
	Q.Volume=1

	local X=false
	local Y={}
	local Z=false

	D.MouseButton1Click:Connect(function()
		Q:Play()
		X=not X
		D.Text=X and _s(75,73,76,76,32,77,79,66,32,58,32,79,78)
			or _s(75,73,76,76,32,77,79,66,32,58,32,79,70,70)
		D.TextColor3=X and _c.fromRGB(0,255,0) or _c.fromRGB(255,0,0)
	end)

	workspace.DescendantAdded:Connect(function()
		if Z then return end
		Z=true
		table.clear(Y)
		for _,m in ipairs(workspace:GetDescendants()) do
			if m:IsA("Model")
			and m:FindFirstChild("Humanoid")
			and m:FindFirstChild("HumanoidRootPart")
			and not P:GetPlayerFromCharacter(m) then
				Y[#Y+1]=m
			end
		end
		task.delay(1,function()Z=false end)
	end)

	task.spawn(function()
		while true do
			task.wait(.1)
			if not X then continue end
			local c=L.Character
			local r=c and c:FindFirstChild("HumanoidRootPart")
			local t=c and c:FindFirstChildOfClass("Tool")
			local h=t and t:FindFirstChild("Handle")
			if not (r and h) then continue end
			t:Activate()
			local n=0
			for _,m in ipairs(Y) do
				if n>=20 then break end
				local u=m:FindFirstChild("Humanoid")
				local p=m:FindFirstChild("HumanoidRootPart")
				if u and p and u.Health>0 then
					firetouchinterest(h,p,0)
					firetouchinterest(h,p,1)
					n+=1
				end
			end
		end
	end)
end
