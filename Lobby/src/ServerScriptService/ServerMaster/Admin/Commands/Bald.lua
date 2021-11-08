local module = {}

--| Services |--
local SSS = game:GetService("ServerScriptService")

--| Modules |--
local Admin = require(SSS:WaitForChild("ServerMaster").Admin)

module.Aliases = {"L","jadia","hairless"}

module.Run = function(self,Player,Args)
	if #Args ~= 0 then
		local Target = Admin:FindPlayer(Args[1])
		table.remove(Args,1)

		if Target then
			for _,Hair in pairs(Target.Character:GetChildren()) do
				if Hair:IsA("Accessory") and Hair.AccessoryType == Enum.AccessoryType.Hair then
					Hair:Destroy()
				end
			end
		else
			Admin:SendMessage(Player,"Player was not found")
		end
	else
		Admin:SendMessage(Player," Command usage: ;bald [username]")
	end
end

return module
