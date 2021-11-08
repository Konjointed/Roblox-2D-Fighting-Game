--| Service |--
local Players = game:GetService("Players")
local Http = game:GetService("HttpService")
local RepStorage = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

--| Modules |--
local Data = require(SSS:WaitForChild("ServerMaster").Profile)

--| Variables |--
local Remotes = RepStorage:WaitForChild("Remotes")
local BanLogBot = "https://discord.com/api/webhooks/904771424248533033/RjWdcFvAn6pR0blXXJagX7b2VGDnAtdMd-_zA7RBVEjUlfR3CUBBO4U7MpKfIEDofFvX"
local CommandLogBot = "https://discord.com/api/webhooks/904771543660372079/rIPczup4nBAZnBlSgSFM5T_Ub8Hf09uGFta7ns2659TILU3shNuaStqdmUFVyekX9RKY"
local Prefix = ";"
local Commands = {}
--hard-coded list admins (only very trusted people)
local Admins = {

	--| Friends / Trusted People
	"Cyrexal", --old main
	"Baldmongold", --alt account
	2596934398, --Konjointed (Me also main account)
	2022410158; --FalseUnderstanding (previous alt)
	85034342; --Salty (friend)

}
--A list of current admins in the game (basically the people who have IsAdmin true in their data)
_G.ServerAdmins = { --to lazy to turn this this script into a module so global variable

}
--hard-coded list of banned admins which gets checked first so if you're in it you don't get admin no matter what
local BannedAdmins = {

}
_G.Testers = {

}

local function BanMsgWebhook(RanBy,BannedUser,BanReason)
	local Data = {
		["content"] = "**Player Banned:**\nUsername: `"..BannedUser.Name.."`\nUserID: `"..BannedUser.UserId.."`\nBanReason: `"..BanReason.."`\nBanned By: `"..
			RanBy.Name.."`"
	}
	Data = Http:JSONEncode(Data)
	Http:PostAsync(BanLogBot, Data)
end

local function CommandUsedWebhook(RanBy,Command)
	local Data = {
		["content"] = "**Command Used:**\nUsername: `"..RanBy.Name.."`\nCommand: `"..Command.."`"
	}
	Data = Http:JSONEncode(Data)
	Http:PostAsync(CommandLogBot, Data)
end

local function SendMessage(Player,Text)
	local Message = script.ServerMessage:Clone()
	Message.Text.Value = Text
	Message.Color.Value = Color3.new(1, 0, 0)
	Message.Parent = Player.PlayerGui
end

local function FindPlayer(Target)
	for _,Player in pairs(Players:GetPlayers()) do
		if Target:lower() == (Player.Name:lower()):sub(1,#Target) then
			return Player
		end
	end
end

--| START OF COMMANDS |--
--Each argument is a word in the message
Commands.tempadmin = function(Sender,Arguments)
	if #Arguments ~= 0 then
		local Target = FindPlayer(Arguments[1])
		table.remove(Arguments,1)
		if Target ~= nil and Target ~= Sender.Name then
			if not table.find(_G.ServerAdmins,Target.UserId) then
				table.insert(_G.ServerAdmins,Target.UserId)
				SendMessage(Sender,Target.Name.." is now a temp admin")
				SendMessage(Target,"You're now a temp admin")
			end
		else
			SendMessage(Sender,"Player not found / can't admin yourself")
		end
	else
		SendMessage(Sender,"Command Usage: ;tempadmin [username]")
	end
end

Commands.admin = function(Sender,Arguments)
	if #Arguments ~= 0 then
		local Target = FindPlayer(Arguments[1])
		table.remove(Arguments,1)
		if Target ~= nil and Target ~= Sender.Name then
			local Profile = Data.Profiles[Target]
			Profile.Data.IsAdmin = true
			SendMessage(Sender,Target.Name.." is now an admin")
			SendMessage(Target,"You're now an admin")
		else
			SendMessage(Sender,"Player not found")
		end
	else
		SendMessage(Sender,"Command Usage: ;admin [username]")
	end
end

Commands.tester = function(Sender,Arguments)
	if #Arguments ~= 0 then
		local Target = FindPlayer(Arguments[1])
		table.remove(Arguments,1)
		if Target ~= nil and Target ~= Sender.Name then
			local Profile = Data.Profiles[Target]
			Profile.Data.IsTester = true
			SendMessage(Sender,Target.Name.." is now a tester")
			SendMessage(Target,"You're now a tester")
		else
			SendMessage(Sender,"Player not found")
		end
	else
		SendMessage(Sender,"Command Usage: ;tester [username]")
	end
end

Commands.unadmin = function(Sender,Arguments)
	if #Arguments ~= 0 then
		local Target = FindPlayer(Arguments[1])
		table.remove(Arguments,1)
		if Target ~= nil then
			if table.find(_G.ServerAdmins,Target.UserId) or table.find(_G.ServerAdmins,Target.Name)  then
				for i,v in pairs(_G.ServerAdmins) do
					if v == Target.UserId or v == Target.Name then
						table.remove(_G.ServerAdmins,i)
						local Profile = Data.Profiles[Target]
						Profile.Data.IsAdmin = false
						SendMessage(Sender,"Is no longer an admin")
					end
				end
			end
		else
			SendMessage(Sender,"Player not found")
		end
	else
		SendMessage(Sender,"Command Usage: ;unadmin [username]")
	end
end

Commands.announce = function(Sender,Arguments)
	local Message = table.concat(Arguments,"")
	for _,Player in pairs(Players:GetPlayers()) do
		SendMessage(Player,Message)
	end
end

Commands.kick = function(Sender,Arguments)
	if #Arguments ~= 0 then
		local Target = FindPlayer(Arguments[1])
		table.remove(Arguments,1)
		if Target ~= nil and Target ~= Sender then
			local Message = table.concat(Arguments,"")
			if Message == "" then
			else
				Target:Kick(Message)
			end
		else
			SendMessage(Sender,"Player not found")
		end
	else
		SendMessage(Sender,"Command Usage: ;kick [username] [reason]")
	end

end

Commands.kickall = function(Sender,Arguments)
	for _,Player in pairs(Players:GetChildren()) do
		if Player.Name ~= Sender.Name then
			Player:Kick()
		end
	end
end

Commands.ban = function(Sender,Arguments)
	if #Arguments ~= 0 then
		local Target = FindPlayer(Arguments[1])
		table.remove(Arguments,1)
		if Target ~= nil --[[and Target ~= Sender.Name]] then
			local Message = table.concat(Arguments,"")
			if Message == "" then
			else
				--Modules.DataManager:ChangeStat(Target,"IsBanned","true")
				--Modules.DataManager:ChangeStat(Target,"BanReason",Message)
				Target:Kick(Message)
				BanMsgWebhook(Sender,Target,Message)
			end
		else
			SendMessage(Sender,"Player not found")
		end
	else
		SendMessage(Sender,"Command Usage: ;ban [username] [reason]")
	end
end

Commands.give = function(Sender,Arguments)
	if #Arguments ~= 0 then
		local Currency = Arguments[1]
		table.remove(Arguments,1)
		local Target = FindPlayer(Arguments[1])
		table.remove(Arguments,1)
		local Amount = tonumber(Arguments[1])
		table.remove(Arguments,1)

		if Target ~= nil and string.lower(Currency) == "gold" then
			local Profile = Data.Profiles[Target]
			Data:GiveCash(Profile,100)
		else
			SendMessage(Sender,"Player not found")
		end
	else
		SendMessage(Sender,"Command Usage: ;give [gold] [username] [amount]")
	end
end

Commands.bald = function(Sender,Arguments)
	if #Arguments ~= 0 then
		local Target = FindPlayer(Arguments[1])
		table.remove(Arguments,1)

		if Target ~= nil then
			for _,Hat in pairs(Target.Character:GetChildren()) do
				if Hat:IsA("Accessory") and Hat.AccessoryType == Enum.AccessoryType.Hair then
					Hat:Destroy()
				end
			end
		else
			SendMessage(Sender,"Player not found")
		end
	else
		SendMessage(Sender,"Command Usage: ;bald [username]")
	end
end

Commands.cmds = function(Sender)
	local String = "Commands: "
	for i,v in pairs(Commands) do
		String ..= i..", "
	end
	SendMessage(Sender,String)
end

--| END OF COMMANDS |--
local function IsAdmin(Player)
	if (table.find(BannedAdmins,Player.UserId)) or (table.find(BannedAdmins,Player.Name)) then
		warn("[SERVER]: is a banned admin")
		local Profile = Data.Profiles[Player]
		Profile.Data.IsAdmin = false
		return false
	end

	if table.find(_G.ServerAdmins,Player.UserId) then
		return true
	end

	for _,Admin in pairs (Admins) do
		if type(Admin) == "string" and string.lower(Admin) == string.lower(Player.Name) then
			return true
		elseif type(Admin) == "number" and Admin == Player.UserId then
			return true
		elseif type(Admin) == "table" then
			local Rank = Player:GetRankInGroup(Admin.GroupId)
			if Rank == (Admin.RankId) then
				return true
			end
		end
	end

	return false
end

local function ParseMessage(Player,Message)
	Message = string.lower(Message)
	local PrefixMatch = string.match(Message,"^"..Prefix)
	if PrefixMatch then
		Message = string.gsub(Message,PrefixMatch,"",1)
		local Arguments = {}

		for Argument in string.gmatch(Message,"[^%s]+") do
			table.insert(Arguments,Argument)
		end

		local CommandFound = false
		local CommandName = Arguments[1]
		local CommandFunc
		table.remove(Arguments,1)
		for CmdName,_ in pairs(Commands) do
			if string.find(string.lower(tostring(CmdName)),string.lower(CommandName)) then
				CommandFound = true
				CommandName = tostring(tostring(CmdName))
				CommandFunc = Commands[CommandName]
				break
			end
		end

		if not CommandFound then
			SendMessage(Player,"That command doesn't exist")
		else
			CommandFunc(Player,Arguments)
			CommandUsedWebhook(Player,CommandName)
		end
	end
end

Players.PlayerAdded:Connect(function(Player)
	if IsAdmin(Player) then
		SendMessage(Player,"You're an admin! Do ;cmds for a list of commands and press ; to open the command bar.")
		SendMessage(Player,"Please don't abuse commands they are logged :]")
		local AdminFrame = script.AdminFrame:Clone()
		AdminFrame.Parent = Player.PlayerGui:WaitForChild("ScreenGui")
		local AdminScript = script.AdminControl:Clone()
		AdminScript.Parent = Player.PlayerGui:WaitForChild("ScreenGui")
	end

	Player.Chatted:Connect(function(Message,Recipient)
		if not Recipient and IsAdmin(Player) then
			ParseMessage(Player,Message)
		end
	end)
end)

Remotes.Command.OnServerEvent:Connect(function(Player,Command)
	if IsAdmin(Player) then
		ParseMessage(Player,Command)
	end
end)
