local Character = {}

--| Services |--
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RepStorage = game:GetService("ReplicatedStorage")

--| Modules |--
local TweenClass = require(RepStorage:WaitForChild("Modules").Tweens)

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")

--| Variables |--
local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")
local Mouse = Player:GetMouse()

Character.Animations = {}
Character.CurrentFacingDirection = 0
Character.CurrentAnimation = nil
Character.State = "Standing"
Character.SelectedCharacter = "Dummy"

Humanoid.StateChanged:Connect(function(oldState, newState)
	if newState == Enum.HumanoidStateType.Landed then
		
		--| This code prevents landing on opponents head by putting a bodyvelocity to push the player off
		--| It looks a bit awkward, but better then nothing.
		--local Ray = Ray.new(HRP.Position,Vector3.new(0,-3,0))
		--local IgnoreList = {_G.DefaultCam.CameraPart,Character,workspace:GetChildren()[6]}
		--local Hit,Pos = workspace:FindPartOnRayWithIgnoreList(Ray,IgnoreList)

		--if Hit then
		--	if Hit.Parent ~= Character then
		--		if (Hit.Name ~= "Right Leg") and (Hit.Name ~= "Left Leg") and (Hit.Name ~= "Right Arm") and (Hit.Name ~= "Left Arm") then
		--			local BV = Instance.new("BodyVelocity") 
		--			BV.MaxForce = Vector3.new(math.huge,0,0)
		--			BV.Velocity = HRP.CFrame.LookVector * 25
		--			BV.Parent = HRP
		--			game.Debris:AddItem(BV,0.1)		
		--		end				
		--	end
		--end

		Character.State = "Standing"
		Character:StopAnimation()
		Character:PlayAnimation("Crouch")
		wait(0.1)
		Character:StopAnimation()
	end
end)


local function UpdateDirection(NewFacingDirection,MiddlePoint)
    Character.CurrentFacingDirection = NewFacingDirection

    local NewPos = HRP.Position+Vector3.new(NewFacingDirection,0,0)
	HRP.CFrame = CFrame.new(HRP.Position,NewPos)
end

function Character:AdjustMovement(Movement,Value,Value2)
	if Movement == "WalkSpeed" then
		Humanoid.WalkSpeed = Value
	elseif Movement == "JumpHeight" then
		Humanoid.JumpHeight = Value
	elseif Movement == "Both" or Movement == nil then
		Humanoid.JumpHeight = Value
		Humanoid.WalkSpeed = Value2
	end
end

function Character:PlayAnimation(AnimationName,Type)
	if Character.Animations[AnimationName] then
		if Character.CurrentAnimation ~= Character.Animations[AnimationName] or Type == "Combat" then
			--warn("New Animation: "..AnimationName)
			Character.CurrentAnimation = Character.Animations[AnimationName]
			Character.CurrentAnimation:Play()				
		end		
	else
		warn("[CLIENT]: Animation doesn't exist "..AnimationName)
	end
end

function Character:StopAnimation(AnimationName)
	if Character.CurrentAnimation ~= nil then
		--warn("Stopping Aaimation: "..Character.CurrentAnimation.Name)
		Character.CurrentAnimation:Stop()
		Character.CurrentAnimation = nil
	end
end

function WorldToScreen(Pos) --This function gets a World Position (Pos) and returns a Vector2 value of the screen coordinates
	local point = workspace.CurrentCamera.CoordinateFrame:pointToObjectSpace(Pos)
	local aspectRatio = Mouse.ViewSizeX / Mouse.ViewSizeY
	local hfactor = math.tan(math.rad(workspace.CurrentCamera.FieldOfView) / 2)
	local wfactor = aspectRatio*hfactor

	local x = (point.x/point.z) / -wfactor
	local y = (point.y/point.z) /  hfactor

	return Vector2.new(Mouse.ViewSizeX * (0.5 + 0.5 * x), Mouse.ViewSizeY * (0.5 + 0.5 * y))
end

local Animations = RepStorage:WaitForChild("Characters"):FindFirstChild(Character.SelectedCharacter).Animations
function Character:Setup(MiddlePoint,Player2)
	local ThingToFace
	if Player2 then
		if Players:FindFirstChild(Player2.Name) then
			ThingToFace = Player2.Character.HumanoidRootPart

		else
			ThingToFace = Player2.HRP	
		end
	else
		ThingToFace = MiddlePoint
	end
	
	for _,Animation in pairs(Animations:GetChildren()) do
		if Animation:IsA("Animation") then
			if Animation.AnimationId ~= "" then
				Character.Animations[Animation.Name] = Humanoid:LoadAnimation(Animation)				
			end
		end
	end
	
    RunService.RenderStepped:Connect(function()
        if HRP.CFrame.Z ~= MiddlePoint.CFrame.Z then
            HRP.CFrame = CFrame.new(HRP.CFrame.X, HRP.CFrame.Y, MiddlePoint.CFrame.Z)
        end	

		local FacingDirection = math.floor(ThingToFace.CFrame.X - HRP.CFrame.X)
        FacingDirection = math.sign(math.sign(FacingDirection) + 0.5) 
		UpdateDirection(FacingDirection,ThingToFace)

		--omg such a better way to do this then whatever the hell my old one was doing
		local Vec2 = WorldToScreen(HRP.Position)
		if Vec2.X <= 229 or Vec2.X >= 1111 then
			if (UIS:IsKeyDown(Enum.KeyCode.D) and Character.CurrentFacingDirection == 1) or 
				UIS:IsKeyDown(Enum.KeyCode.A) and (Character.CurrentFacingDirection == -1) then
				Character:AdjustMovement("WalkSpeed",17)
			else
				Character:AdjustMovement("WalkSpeed",0)
			end
		else
			Character:AdjustMovement("WalkSpeed",17)
		end
    end)
end

return Character