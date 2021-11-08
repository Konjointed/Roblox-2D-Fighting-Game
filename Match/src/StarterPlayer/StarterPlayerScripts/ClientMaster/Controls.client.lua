--| Services |--
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

--| Modules |--
local RepStorage = game:GetService("ReplicatedStorage")
local Character = require(RepStorage:WaitForChild("Modules").Character)
local Buffer = require(RepStorage:WaitForChild("Modules").Buffer)

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")
local Jumped = Remotes:WaitForChild("Jumped")  --this might be dumb

--| Variables |--
local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

function IsKeyDown(Key)
	return UIS:IsKeyDown(Key)
end

function IsFalling()
	if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		return true
	else
		return false
	end
end

local function Jump()
	while IsKeyDown(Enum.KeyCode.W) do
		if not IsFalling() then
			Humanoid.Jump = true
			Character.State = "Jumping"
			Jumped:FireServer()
		end
		wait(0.01) --for some reason task.wait() doesn't work here
	end
end

local function Crouch()
	while IsKeyDown(Enum.KeyCode.S) do
		if Character.State ~= "Jumping" and not IsFalling() then
			Character.State = "Crouching"
			Character:PlayAnimation("Crouch")
			Character:AdjustMovement(nil,0,0)
			task.wait()
		else
			Character:StopAnimation()			
		end
		task.wait()
	end
	Character:AdjustMovement(nil,9,17)
	Character:StopAnimation()	
end

local function Walk()
	
end

UIS.InputBegan:Connect(function(Input,GP)
	if GP then return end
	
	warn(Character.State)

	local KeyCodeString = UIS:GetStringForKeyCode(Input.KeyCode)
	Buffer:CheckInput(KeyCodeString)

	if Input.KeyCode == Enum.KeyCode.W then
		Character.State = "Jumping"
		Jump()
	elseif Input.KeyCode == Enum.KeyCode.S then
		Character.State = "Crouching"
		Crouch()
	elseif Input.KeyCode == Enum.KeyCode.A or Input.KeyCode == Enum.KeyCode.D then
		Character.State = "Walking"
		Walk(Input.KeyCode)
	end
end)

UIS.InputEnded:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.W or Input.KeyCode == Enum.KeyCode.S 
		or Input.KeyCode == Enum.KeyCode.A or Input.KeyCode == Enum.KeyCode.D then
			if not IsFalling() then
				Character.State = "Standing"
			end
	end
end)