local MatchMaking = {}

--| Services |-
local RepStorage = game:GetService("ReplicatedStorage")
local TS = game:GetService("TeleportService")
local MS = game:GetService("MessagingService")
local SSS = game:GetService("ServerScriptService")

--| Modules |--
local PS = require(SSS:WaitForChild("APIs").ProfileService)
local Profile = require(SSS:WaitForChild("ServerMaster").Profile)
local Teleport = require(SSS:WaitForChild("ServerMaster").TeleportManager)
local Admins = require(SSS:WaitForChild("ServerMaster").Admin.Admins)
local Testers = require(SSS:WaitForChild("ServerMaster").Admin.Testers)

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")
local MatchMaking = Remotes.MatchMaking
local Warning = Remotes.Warning

--| Constants |--
local Requirement = 2

--| Variables |--
local Queue = {}
local MatchPlace = 7932499281

MS:SubscribeAsync("Teleport",function(Message)
	warn("[SERVER]: Teleporting")
	
	local Candidates = {}
	local PlayersToTeleport = {}
	local ServerCode = TS:ReserveServer(MatchPlace)
	
	for _,Player in pairs(game.Players:GetPlayers()) do
		if table.find(Queue,Player.UserId) then
			table.insert(Candidates,Player)
		end		
	end	
	
	if #Candidates >= Requirement then
		warn("[SERVER]: Getting Players For Teleport")
		
		local RandomNum1 = math.random(1,#Candidates)
		local Player1 = Candidates[RandomNum1]
		table.insert(PlayersToTeleport,Candidates[RandomNum1])
		table.remove(Candidates,RandomNum1)
		--local RandomNum2 = math.random(1,#Candidates)
		--local Player2 = Candidates[math.random(1,#Candidates)]
		--table.insert(PlayersToTeleport,Candidates[RandomNum2])
		--table.remove(Candidates,RandomNum2)

		for i,Player in pairs(PlayersToTeleport) do
			if table.find(Queue,Player.UserId) then
				table.remove(Queue,i)
			end
		end
		
		--> I wanna implement the players region as a factor for match making
		--> So players in the same region will be matched if possible
		--local Result,Code = pcall(function()
		--	return Main.LS:GetCountryRegionForPlayerAsync(Player1)
		--end)
		
		--warn(Result,Code)
		
		if #PlayersToTeleport == Requirement then
			--warn("Teleporting "..PlayersToTeleport[1].Name.." and "..PlayersToTeleport[2].Name)
			TS:TeleportToPrivateServer(MatchPlace,ServerCode,PlayersToTeleport)
			PlayersToTeleport = {}
		end
	end
end)

MS:SubscribeAsync("JoinQueue",function(Message)
	local PlayerUserId = Message.Data	
	warn("[SERVER]:"..PlayerUserId.." joined the queue")
	table.insert(Queue,PlayerUserId)
	warn("[SERVER]: Queue Size: "..#Queue)

	if #Queue >= Requirement then
		MS:PublishAsync("Teleport")		
	end	
end)

MS:SubscribeAsync("LeaveQueue",function(Message)
	local PlayerUserId = Message.Data
	warn("[SERVER]:"..PlayerUserId.." left the queue")
	for i,UserId in pairs(Queue) do
		if UserId == PlayerUserId then
			table.remove(Queue,i)	
		end
	end
	warn("[SERVER]: Queue Size: "..#Queue)
end)

MatchMaking.OnServerInvoke = function(Player)
	local PlayerProfileData = Profile.Profiles[Player].Data
	if PlayerProfileData.IsTester or table.find(Testers,Player.UserId) or PlayerProfileData.IsAdmin or table.find(Admins,Player.UserId) then
		if not table.find(Queue,Player.UserId) then
			MS:PublishAsync("JoinQueue",Player.UserId)
		else
			MS:PublishAsync("LeaveQueue",Player.UserId)	
		end
		return true
	else
		Warning:FireClient(Player,"This is option is currently avaialble \nto testers only")
		return false
	end
end

return MatchMaking
