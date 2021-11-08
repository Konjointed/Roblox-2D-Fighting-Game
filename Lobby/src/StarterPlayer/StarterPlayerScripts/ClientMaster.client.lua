--| Services |--
local MPS = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local HTTP = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local RepStorage = game:GetService("ReplicatedStorage")

--| Modules |--
local UIMaster = require(RepStorage:WaitForChild("Modules").UIMaster)
local ButtonFuncs = require(RepStorage:WaitForChild("Modules").ButtonFunctionality)
local Tweens = require(RepStorage:WaitForChild("Modules").TweenManager)

--| Constants |-
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local MusicPlayer = script.Music
local ServerAge = PlayerGui:WaitForChild("ScreenGui").Frame.ServerAge
local GameVersion = PlayerGui:WaitForChild("ScreenGui").Frame.Version
local UpdateBoard = workspace:WaitForChild("Lobby").Stage["Update Board"]
local Songs = {
	--5351923715, --Spark The Electric Jester - Lightoria Bay
	--2772578334, --Spark The Electric Jester - Kerana Forest
	--6783445328, --Bomberman Hero - Redial
	--838603523, --Spark The Electric Jester - Caria Valley
	--1272594398, --Sonic Unleashed - Werehog Battle Theme
	--150516749, --MvsC 2 - Clock Tower Stage
	--5351322302, --Spleunky - Yeti Caves
	--6356853814, --Nyakuza Manholes
	--164032450, --Sonic Unleashed - Windmill Isle
	4975280218, --Streets of Rage 4 - Funky HQ
	7927256479, --Let's Solve the Mystery - Judgment
	7927253860, --Shuffle Up - Uno Music
}

--| Variables |--
local PreviousSong
local Time = os.clock()
local ServerAgeValue = RepStorage:WaitForChild("Settings").ServerAge

GameVersion.Text = "Ver"..RepStorage:WaitForChild("Settings").GameVer.Value --Set version text label
UpdateBoard.Board.SurfaceGui.ScrollingFrame.Updates.Text = "Updates ("..RepStorage:WaitForChild("Settings").GameVer.Value..")" --Add version number to updates board

--Set the server age text label when the value changes
ServerAgeValue:GetPropertyChangedSignal("Value"):Connect(function()
	ServerAge.Text = "Server Age: "..ServerAgeValue.Value
end)

--Random music player
while true do
	local Song = math.random(1,#Songs)
	if Song == Song then
		repeat Song = math.random(1,#Songs) until Song ~= PreviousSong
	end
	PreviousSong = Song
	MusicPlayer.SoundId = "rbxassetid://"..Songs[Song]

	songInfo = MPS:GetProductInfo(Songs[Song])

	if not MusicPlayer.IsLoaded then MusicPlayer.Loaded:Wait() end

	MusicPlayer.TimePosition = 0
	MusicPlayer:Play()
	
	MusicPlayer.Ended:Wait()
end
