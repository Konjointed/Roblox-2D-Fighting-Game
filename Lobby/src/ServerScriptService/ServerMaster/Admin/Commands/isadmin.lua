local module = {}

--| Services |--
local SSS = game:GetService("ServerScriptService")

--| Modules |--
local Admin = require(SSS:WaitForChild("ServerMaster").Admin)
local Admins = require(SSS:WaitForChild("ServerMaster").Admin.Admins)
local Data = require(SSS:WaitForChild("ServerMaster").Profile)

module.Aliases = {"hasadmin","admincheck"}

module.Run = function(self,Player,Args)
	if #Args ~= 0 then
		local Target = Admin:FindPlayer(Args[1])

		if Target then
			local Profile = Data.Profiles[Target]
			if Profile.Data.IsAdmin or table.find(Admins,Target.UserId) then
				Admin:SendMessage(Player,Target.Name.." is an admin")
			else
				Admin:SendMessage(Player,Target.Name.." is not an admin")
			end		
		else
			Admin:SendMessage(Player,"Player was not found")
		end
	else
		Admin:SendMessage(Player," Command usage: ;isadmin [username]")
	end
end

return module
