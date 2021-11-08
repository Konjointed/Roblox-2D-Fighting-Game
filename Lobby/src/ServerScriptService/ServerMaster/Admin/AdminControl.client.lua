--| Service |--
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RepStorage = game:GetService("ReplicatedStorage")

--| Variables |--
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ScreenGui = PlayerGui.ScreenGui
local Remotes = RepStorage:WaitForChild("Remotes")
local Opened = false
local AdminCommand = ScreenGui.AdminFrame.AdminCommand

UIS.InputBegan:Connect(function(Input,IsTyping)
	if IsTyping then return end
	
	local Key = UIS:GetStringForKeyCode(Input.KeyCode)
	if Key == ";" then
		if Opened == false then
			Opened = true
			AdminCommand:TweenPosition(UDim2.new(-0.002, 0,0.468, 0),"Out","Back",0.4,true)		
		else
			Opened = false
			AdminCommand:TweenPosition(UDim2.new(-0.002, 0,-1, 0),"Out","Back",0.4,true)				
		end
	elseif Input.KeyCode == Enum.KeyCode.Return then
		if AdminCommand.Text ~= nil then
			Remotes.Command:FireServer(AdminCommand.Text)
		end
	end
end)