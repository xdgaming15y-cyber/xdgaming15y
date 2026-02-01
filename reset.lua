do
	local A,B,C,D,E,F={},string.char,math.random,game.GetService,Instance.new,UDim2
	local G,H,I,J,K,L,M,N,O,P,Q,R,S

	A[1]=function(x)return D(game,x)end
	A[2]=A[1](B(80,108,97,121,101,114,115))
	A[3]=A[2].LocalPlayer
	A[4]=E(B(83,99,114,101,101,110,71,117,105),A[3]:WaitForChild(B(80,108,97,121,101,114,71,117,105)))
	A[4].Name=B(120)..C(100000,999999)
	A[4].ResetOnSpawn=false

	A[5]=E(B(84,101,120,116,66,117,116,116,111,110),A[4])
	A[5].Size=F.fromOffset(120,36)
	A[5].Position=F.fromScale(.05,.45)
	A[5].Text=B(82,69,83,69,84)
	A[5].Font=Enum.Font.GothamBold
	A[5].TextScaled=true
	A[5].TextColor3=Color3.new(1,1,1)
	A[5].BackgroundColor3=Color3.fromRGB(60,220,60)
	A[5].AutoButtonColor=false

	E(B(85,73,67,111,114,110,101,114),A[5]).CornerRadius=UDim.new(0,10)
	G=E(B(85,73,83,116,114,111,107,101),A[5])
	G.Color=Color3.fromRGB(0,255,0)
	G.Thickness=2

	H=A[1](B(84,119,101,101,110,83,101,114,118,105,99,101))
	I=A[1](B(83,111,117,110,100,83,101,114,118,105,99,101))

	J=E(B(83,111,117,110,100),I)
	J.SoundId=B(114,98,120,97,115,115,101,116,105,100,58,47,47,49,50,50,50,49,57,54,55)
	J.Volume=1

	K=function(a,b)
		local c=H:Create(A[5],TweenInfo.new(.08,Enum.EasingStyle.Back),{Size=a})
		local d=H:Create(A[5],TweenInfo.new(.08,Enum.EasingStyle.Back),{Size=b})
		c:Play();c.Completed:Wait();d:Play()
	end

	L=function()
		local c=A[3].Character
		if not c then return end
		for _,v in next,c:GetChildren() do
			if v:IsA(B(72,117,109,97,110,111,105,100)) then
				v.Health=0
				return
			end
		end
	end

	A[5].MouseButton1Click:Connect(function()
		J:Play()
		K(F.fromOffset(130,40),F.fromOffset(120,36))
		L()
	end)
end
