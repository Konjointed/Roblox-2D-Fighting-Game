--| Services |-
local RepStorage = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local HTTP = game:GetService("HttpService")
local Players = game:GetService("Players")
local MS = game:GetService("MessagingService")

--| Modules |--
local PS = require(SSS:WaitForChild("APIs").ProfileService)
local MatchMaking = require(SSS:WaitForChild("ServerMaster").MatchMaking)
local Profile = require(SSS:WaitForChild("ServerMaster").Profile)
local Teleport = require(SSS:WaitForChild("ServerMaster").TeleportManager)
local Admin = require(SSS:WaitForChild("ServerMaster").Admin)

--| Variables |--
local ServerAge = RepStorage:WaitForChild("Settings").ServerAge
local Time = os.clock()
local Outdated = false
local CurrentGameVer = game.PlaceVersion
local Updates = {
	"- First version of \nthe lobby!",
	"- Bug fixes",
}

MS:PublishAsync("Updated",game.PlaceVersion)

--When a new server is created that has a higher place version
--if the other servers aren't on the same version then it's outdated
MS:SubscribeAsync("Updated",function(Message)
	local GameVersion = Message.Data
	if GameVersion > CurrentGameVer then
		Outdated = true
	end
end)

--Add updates to the update board
for _,v in pairs(Updates) do
	local TextLabel = Instance.new("TextLabel")
	TextLabel.BackgroundTransparency = 1
	--TextLabel.TextScaled = true
	TextLabel.TextSize = 30
	TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
	TextLabel.Text = v
	TextLabel.Parent = workspace:WaitForChild("Lobby").Stage["Update Board"].Board.SurfaceGui.ScrollingFrame
end

--Increment server age value
while true do
	if Outdated then
		ServerAge.Value = math.floor(os.clock()-Time).."s (Outdated)"
	else
		ServerAge.Value = math.floor(os.clock()-Time)	
	end
	task.wait(1)
end