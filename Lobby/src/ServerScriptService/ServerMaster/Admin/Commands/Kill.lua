local module = {}

--| Services |--
local SSS = game:GetService("ServerScriptService")

--| Modules |--
local Admin = require(SSS:WaitForChild("ServerMaster").Admin)

module.Aliases = {"slay","rekt","destroy"}

module.Run = function(self,Player,Args)
	if #Args ~= 0 then
		local Target = Admin:FindPlayer(Args[1])

		if Target then
			Target.Character.Humanoid.Health = 0
		else
			Admin:SendMessage(Player,"Player was not found")
		end
	else
		Admin:SendMessage(Player," Command usage: ;kill [username]")
	end
end

return module
