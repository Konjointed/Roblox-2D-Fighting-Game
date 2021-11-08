local Combat = {}

--| Services |--
local RunService = game:GetService("RunService")
local PolicyService = game:GetService("PolicyService")
local RepStorage = game:GetService("ReplicatedStorage")

--| Modules |--
local ES = require(RepStorage:WaitForChild("Modules").EffectService)

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")
local Hit = Remotes:WaitForChild("Hit")
local Action = Remotes:WaitForChild("Action")
local Jumped = Remotes:WaitForChild("Jumped")

--| Variables |--
local TimeSinceLastHit = {}

--Stun timer
RunService.Heartbeat:Connect(function()
	for CharacterName,Time in pairs(TimeSinceLastHit) do
		if os.clock() - Time > 3 then
			local Stun = workspace.Game:FindFirstChild(CharacterName).Stun
			if Stun.Value > 0 then
				Stun.Value -= 5
			end
		end
	end
end)

Jumped.OnServerEvent:Connect(function(Player)
	ES:FireAllClients("DefaultEffect", "Jump", Player)
end)

Action.OnServerEvent:Connect(function(Player,Move)
	if Move.Effect then
		ES:FireAllClients(Move.Effect, "Effect", Player)	
	end
end)

Hit.OnServerEvent:Connect(function(Player,Target,MoveData)
	ES:FireAllClients("DefaultEffect", "Effect", Target) --The default effects for hitting (hit sound and stuff)

	--Even though I send the move from the client it's probably better to just get it again from the server
	local Moveset = require(RepStorage:WaitForChild("Modules").Moveset)

	TimeSinceLastHit[Target.Name] = os.clock() --Reset targets last hit

	for _,Move in pairs(Moveset) do 
		if Move.Name == MoveData.Name then
			--Do specific effects if any
			if Move.HitEffect then
				ES:FireAllClients(Move.HitEffect, "Effect", Player)
			end
		
			local Damage = Move.Damage 
			local Stun = Move.Stun
			local Guage = Move.Stun

			Target.Stun.Value += Stun
			Target.Humanoid:TakeDamage(Damage)
			Player.Character.Guage.Value += Guage

			if Target.Stun.Value >= 1000 then
				ES:FireAllClients("DefaultEffect", "Stunned", Target)
			end
		end
	end
end)


return Combat