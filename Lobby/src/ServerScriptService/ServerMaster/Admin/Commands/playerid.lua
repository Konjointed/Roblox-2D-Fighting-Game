local module = {}

--| Services |--
local SSS = game:GetService("ServerScriptService")

--| Modules |--
local Admin = require(SSS:WaitForChild("ServerMaster").Admin)

module.Aliases = {"id"} 

module.Run = function(self,Player,Args)
	if #Args ~= 0 then
		local Target = Admin:FindPlayer(Args[1])

		if Target then
			Admin:SendMessage(Player,Target.Name.. "'s user id is: "..Target.UserId)
		else
			Admin:SendMessage(Player,"Player not found")
		end
	else
		Admin:SendMessage(Player,"Command Usage: ;playerid [username]")
	end
end

return module
