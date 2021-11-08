local module = {}

--| Services |--
local SSS = game:GetService("ServerScriptService")

--| Modules |--
local Admin = require(SSS:WaitForChild("ServerMaster").Admin)

module.Aliases = {"cmds","cmd","help"} 

module.Run = function(self,Player)
	local String = "Commands: "
	for i,v in pairs(script.Parent:GetChildren()) do
		if i == #script.Parent:GetChildren() then
			String ..= string.lower(v.Name)
		else
			String ..= string.lower(v.Name)..", "
		end
	end
	Admin:SendMessage(Player,String)
end

return module
