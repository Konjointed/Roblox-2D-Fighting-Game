local module = {}

--| Services |--
local SSS = game:GetService("ServerScriptService")

--| Modules |--
local Admin = require(SSS:WaitForChild("ServerMaster").Admin)
local Data = require(SSS:WaitForChild("ServerMaster").Profile)

module.Aliases = {}

module.Run = function(self,Player,Args)
	if #Args ~= 0 then
		local Target = Admin:FindPlayer(Args[1])

		if Target then
			local Profile = Data.Profiles[Target]
			Profile.Data.IsAdmin = true
			Admin:SendMessage(Player,Target.Name.." is now an admin")
			Admin:SendMessage(Target,"You're now an admin")		
		else
			Admin:SendMessage(Player,"Player was not found")
		end
	else
		Admin:SendMessage(Player," Command usage: ;kill [username]")
	end
end

return module
