local module = {}

--| Services |--
local SSS = game:GetService("ServerScriptService")

--| Modules |--
local Admin = require(SSS:WaitForChild("ServerMaster").Admin)

module.Aliases = {} 

module.Run = function(self,Player,Args)
	local Reason = Args[1]
	
	for _,Player in pairs(game:GetService("Players"):GetPlayers()) do
		Player:Kick(Reason)
	end
end

return module
