local UI = {}

--| Services |--
local RepStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

--| Modules |--
local Tweens = require(RepStorage:WaitForChild("Modules").TweenManager)

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")
local Warning = Remotes:WaitForChild("Warning")

--| Constants |--
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ScreenGui = PlayerGui:WaitForChild("ScreenGui")
local Music = RepStorage.Music
local ButtonsFrame = ScreenGui.Frame.Buttons

ScreenGui.Frame.Visible = true --> Enables the main menu frame 

function UI:PopUp(Text)
	local Notification = ScreenGui.Frame.Notification
	Notification.Text = Text
	Notification:TweenPosition(UDim2.new(0.786, 0,0.851, 0),"Out","Sine",1,true)
	task.wait(2)
	Notification:TweenPosition(UDim2.new(3, 0,0.851, 0),"Out","Sine",2,true)
end

function UI:ButtonPressed(Button)
	local ButtonFuncs = require(RepStorage:WaitForChild("Modules").ButtonFunctionality)
	if ButtonFuncs[Button.Name] then
		ButtonFuncs[Button.Name](Button.Parent,Button)
	else
		warn("No function for TextButton..".. Button.Name)
		UI:PopUp("Your current selection is unavailable")
	end	
end

--function UI:SelectButton(Button)	
--	if Button ~= UI.SelectedButton then
--		if UI.SelectedButton:FindFirstChild("Pattern2") then
--			UI.SelectedButton.Pattern2:Destroy()
--		end
--		if Button:FindFirstChild("Pattern2") then
--			Button.Pattern2:Destroy()
--		end
--		UI.SelectedButton.TextColor3 = Color3.fromRGB(48, 48, 48)
--		for _,Child in pairs(UI.SelectedButton:GetChildren()) do
--			if Child:IsA("ImageLabel") then
--				Child.ImageColor3 = Color3.fromRGB(48, 48, 48)		
--			elseif Child:IsA("TextLabel") then
--				Child.TextColor3 = Color3.fromRGB(48, 48, 48)		
--			end
--		end
--		UI.SelectedButton.BackgroundColor3 = Color3.fromRGB(154, 154, 154)
--		UI.SelectedButton.BackgroundTransparency = 0.3
--		Tweens:PauseTweens()
--	end
	
--	if not Button:FindFirstChild("Pattern2") then
--		local Pattern = ScreenGui.MainMenu.Pattern2:Clone()
--		Pattern.Parent = Button
--		Pattern.Visible = true

--		UI.SelectedButton = Button

--		local Info = TweenInfo.new(
--			100, -- Time
--			Enum.EasingStyle.Linear, -- EasingStyle
--			Enum.EasingDirection.Out, -- EasingDirection
--			-1, -- RepeatCount (when less than zero the tween will loop indefinitely)
--			false, -- Reverses (tween will reverse once reaching it's goal)
--			0 -- DelayTime
--		)
--		Tweens:MakeTween(Info,Pattern,{Position = UDim2.new(-20,0,0,0)},false,true)		
--	end

--	RepStorage.Music.ButtonHover:Play()
--	UI.SelectedButton.TextColor3 = Color3.fromRGB(225, 254, 137)
--	for _,Child in pairs(UI.SelectedButton:GetChildren()) do
--		if Child:IsA("ImageLabel") then
--			Child.ImageColor3 = Color3.fromRGB(225, 254, 137)		
--		elseif Child:IsA("TextLabel") then
--			Child.TextColor3 = Color3.fromRGB(225, 254, 137)		
--		end
--	end
--	UI.SelectedButton.BackgroundColor3 = Color3.fromRGB(46,46,46)
--	UI.SelectedButton.BackgroundTransparency = 0	
--end

Warning.OnClientEvent:Connect(function(Text)
	UI:PopUp(Text)
end)

function SetupButton(Button)
	Button.MouseEnter:Connect(function()
		--UI:SelectButton(Button)
		if Button.Parent.Name == "Buttons" then
			Button.ImageColor3 = Color3.fromRGB(40,40,40)
			RepStorage.Music.ButtonHover:Play()	
		end
	end)
	
	Button.MouseLeave:Connect(function()
		if Button.Parent.Name == "Buttons" then
			Button.ImageColor3 = Color3.fromRGB(255,255,255)
		end
	end)

	Button.MouseButton1Click:Connect(function()
		RepStorage.Music.ButtonSelect:Play()
		UI:ButtonPressed(Button)
	end)	
end

ScreenGui.DescendantAdded:Connect(function(Child)
	if Child:IsA("TextButton") or Child:IsA("ImageButton") then
		SetupButton(Child)
	end
end)

for _,Object in pairs(ScreenGui:GetDescendants()) do
	if  Object:IsA("TextButton") or Object:IsA("ImageButton") then
		SetupButton(Object)	
	end
end

return UI


