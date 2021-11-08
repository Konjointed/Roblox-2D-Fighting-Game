local EffectService = {}

--[[
EffectService  Module: Made by yours truly, Sweet_Smoothies!
Organize your effects and simplify them with ease.

Steps to using this module:

1. Set your source (the parent to where you'll put all your "category" scripts)
2. Insert a module inside the source and rename it to whatever you'd like.
3. Inside, insert functions (as a table PROPERTY, not an actual function) just like you would normally.
4. Require this module from ONE local script in STARTERPLAYERSCRIPTS.
5. From the server, call one of the server functions and enjoy!

------------------------------
EXAMPLE USAGE:
Insert a module named "Test" inside the source.
Inside the module, replace all code with the following:
--
local Test = {}

Test.Print = function(String)
	print(String)
end

return Test
--

Make sure you've followed step 4.
From the server, do EffectService:FireAllClients("Test","Print","This is a test string!")

All clients will then print out, "This is a test string!"
------------------------------

Documentation:

(Server sided only)

EffectService:FireClient(Player, Category, Action, ...)
-Fires to said client with Category, Action, and other needed variables.

EffectService:FireCharacter(Character, Category, Action, ...)
-Fires to the owner of the character with Category, Action, and other needed variables. Will error (but not yield the script) if not given a player character.

EffectService:FireAllClients(Category, Action, ...)
-Fires to all clients with Category, Action, and other needed variables.

EffectService:FireClientsWithList(List, Category, Action, ...)
-Fires to all clients within the list given. (ARRAY, STRINGS)
]]

local Effects = game:GetService("ReplicatedStorage"):WaitForChild("Effects")
local Event = game:GetService("ReplicatedStorage"):WaitForChild("Remotes").Event
local RS = game:GetService("RunService")

if RS:IsClient() then
	local Mods = {}
	for _,Module in pairs(Effects:GetChildren()) do
		if Module:IsA("ModuleScript") then Mods[Module.Name] = require(Module) end
	end
	Event.OnClientEvent:Connect(function(C,A,...)
		Mods[C][A](...)
	end)
	
else
	
	function EffectService:FireClient(P,C,A,...)
		Event:FireClient(P,C,A,...)
	end
	
	function EffectService:FireCharacter(CH,C,A,...)
		local P = game.Players:GetPlayerFromCharacter(CH)
		if not P then warn("Object given was not a character model!") return end
		Event:FireClient(P,C,A,...)
	end
	
	function EffectService:FireAllClients(C,A,...)
		Event:FireAllClients(C,A,...)
	end
	
	function EffectService:FireClientsWithList(L,C,A,...)
		for i, v in pairs(L) do
			if game.Players:FindFirstChild(v) then Event:FireClient(game.Players[v],C,A,...) end
		end
	end
	
end
return EffectService
