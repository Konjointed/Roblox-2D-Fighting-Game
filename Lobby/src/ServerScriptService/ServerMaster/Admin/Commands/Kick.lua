local module = {}

--| Services |--
local SSS = game:GetService("ServerScriptService")

--| Modules |--
local Admin = require(SSS:WaitForChild("ServerMaster").Admin)

module.Aliases = {} 

module.Run = function(self,Player,Args)
	if #Args ~= 0 then
		local Target = Admin:FindPlayer(Args[1])
		local Reason = Args[2]
		
		if Target then
			Target:Kick(Reason)
		else
			Admin:SendMessage(Player,"Player not found")
		end
	else
		Admin:SendMessage(Player,"Command Usage: ;kick [username] [reason]")
	end
end

return module
