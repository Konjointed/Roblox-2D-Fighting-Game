--| Services |--
local RepStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TPS = game:GetService("TeleportService")
local SSS = game:GetService("ServerScriptService")

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")

--| Modules |--
local ServerCombat = require(SSS.ServerMaster:WaitForChild("ServerCombat"))
local ServerMatchManager = require(SSS.ServerMaster:WaitForChild("ServerMatchManager"))

--| Variables |--
local SinglePlayerTest = RepStorage:WaitForChild("Settings").SinglePlayerTest
local PlayersNeeded = 2

if SinglePlayerTest.Value == true then
	PlayersNeeded = 1
end

--Teleport the player back to the main game if their opponent leaves
Players.PlayerRemoving:Connect(function(Player)
	if #Players:GetPlayers() == 1 then
		Remotes.OpponentLeft:FireAllClients()
		TPS:Teleport(6936140530,Players:GetPlayers()[1])		
	end
end)

Players.PlayerAdded:Connect(function(Player)
	warn("[SERVER]: Player joined")	
	Player.CharacterAdded:Connect(function()
		warn("[SERVER]: Character added")	
	end)
end)

local function WaitForCharacters(PlayerTable)
	local Amount = 0

	for _,Player in pairs(PlayerTable) do
		if Player then
			if Player.Character then
				local Character = Player.Character
				local Humanoid = Character.Humanoid
				Humanoid.AutoRotate = false
				Humanoid.BreakJointsOnDeath = false
				Amount += 1
			end	
		end
	end

	return Amount
end

--Wait for players needed
repeat 
	local Characters = WaitForCharacters(Players:GetPlayers())
	task.wait(1)
	warn("[SERVER]: Waiting for opponent")
until Characters >= PlayersNeeded	

warn("[SERVER]: Ready to prepare match")

ServerMatchManager:Prepare()