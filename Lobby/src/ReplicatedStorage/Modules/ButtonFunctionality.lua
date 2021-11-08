local module = {}

--| Services |--
local RepStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--| Modules |--
local UIMaster = require(RepStorage:WaitForChild("Modules").UIMaster)

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")
local ToTraining = Remotes:WaitForChild("TeleportToTraining")
local MatchMaking = Remotes:WaitForChild("MatchMaking")

--| Constants |--
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ScreenGui = PlayerGui:WaitForChild("ScreenGui")
local Music = RepStorage:WaitForChild("Music")
--local MatchSettings = {
--	Player1Character = Main.Character,
--	SelectedStage = "",
--	SelectedCharacter = "",
--}

function FadeOut()
	for i = 1,0,-0.1 do
		ScreenGui.Fade.BackgroundTransparency = i
		wait()
	end
end

function FadeIn()
	for i = 0,1,0.1 do
		ScreenGui.Fade.BackgroundTransparency = i
		wait()
	end
end

--module.Ranked = function()
	
--end

module.Casual = function()
	local Searching = ScreenGui.Frame.Searching
	if not Searching.Visible then
		local Success = Remotes.MatchMaking:InvokeServer()
		if Success then
			Searching.Visible = true
		end
	end
end

module.LeaveQueue = function()
	local Searching = ScreenGui.Frame.Searching
	local Success = Remotes.MatchMaking:InvokeServer()
	if Success then
		Searching.Visible = false
	end
end

module.Shop = function()
	local Shop = ScreenGui.Frame.Shop
	local MusicPlayer = Player.PlayerScripts.ClientMaster.Music
	Shop.Visible = not Shop.Visible
	Music["shop theme"].Playing = not Music["shop theme"].Playing
	MusicPlayer.Playing = not MusicPlayer.Playing
end

module.Settings = function()
	local Settings = ScreenGui.Frame.Settings
	Settings.Visible = not Settings.Visible
end

module.Challenges = function()
	local Challenges = ScreenGui.Frame.Challenges
	Challenges.Visible = not Challenges.Visible
end

--module.Shop = function()
--end

--module.Settings = function()

--end

--module.Training = function()

--end

--module.Challenges = function()

--end


--module.Training = function()
--	FadeOut()
--	Remotes.TeleportToTraining:FireServer()
--end

--module.Shop = function()
--	local Shop = ScreenGui.Shop
--	local MainMenu = ScreenGui.MainMenu
--	Shop.Visible = true
--	UIMaster.Buttons = {}
--end


--module.CasualMatch = function()
--	local Searching = ScreenGui.Searching
--	local MainMenu = ScreenGui.MainMenu
--	local Success = Remotes.MatchMaking:InvokeServer()
--	if Success then
--		MainMenu.Buttons.Visible = false
--		UIMaster.Buttons = Tables.SearchingButtons
--		UIMaster:SelectButton(Searching.Front.CancelSearch)
--		Searching.Visible = true
--	end
--end

--module.CancelSearch = function()
--	local Searching = ScreenGui.Searching
--	local MainMenu = ScreenGui.MainMenu
--	local Success = Remotes.MatchMaking:InvokeServer()
--	if Success then
--		MainMenu.Buttons.Visible = true
--		UIMaster.Buttons = Tables.MainMenuButtons
--		UIMaster:SelectButton(MainMenu.Buttons.CasualMatch)
--		Searching.Visible = false
--	end
--end

return module
