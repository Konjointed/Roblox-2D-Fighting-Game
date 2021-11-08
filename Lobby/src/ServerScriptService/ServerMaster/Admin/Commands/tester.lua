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
			Profile.Data.IsTester = true
			Admin:SendMessage(Player,Target.Name.." is now a tester")
			Admin:SendMessage(Target,"You're now a tester")		
		else
			Admin:SendMessage(Player,"Player was not found")
		end
	else
		Admin:SendMessage(Player," Command usage: ;tester [username]")
	end
end

return module
