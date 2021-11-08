local Teleport = {}

--| Services |-
local RepStorage = game:GetService("ReplicatedStorage")
local TS = game:GetService("TeleportService")
local Players = game:GetService("Players")

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")
local ToTraining = Remotes.TeleportToTraining


ToTraining.OnServerEvent:Connect(function(Player,MatchSettings)
	warn("Teleporting To Training")
	TS:Teleport(6963145520,Player,MatchSettings)
end)

function Teleport:TeleportToMatch(MatchSettings)
	warn("Teleporting To Match")
	local Player1 = Players:GetPlayerFromCharacter(MatchSettings.Player1Character)	
	local Player2 = Players:GetPlayerFromCharacter(MatchSettings.Player2Character)	
	local Players = {Player1,Player2}
	local Code = TS:ReserveServer(6962511190)
	TS:TeleportToPrivateServer(6962511190,Code,Players)
end

return Teleport
