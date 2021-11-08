local Admin = {}

--| Services |--
local Players = game:GetService("Players")
local Http = game:GetService("HttpService")
local RepStorage = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

--| Modules |--
local Admins = require(SSS:WaitForChild("ServerMaster").Admin.Admins)
local BannedAdmins = require(SSS:WaitForChild("ServerMaster").Admin.BannedAdmins)

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")

--| Constants |--
local Prefix = ";"
local BanLogBot = "https://discord.com/api/webhooks/904771424248533033/RjWdcFvAn6pR0blXXJagX7b2VGDnAtdMd-_zA7RBVEjUlfR3CUBBO4U7MpKfIEDofFvX"
local CommandLogBot = "https://discord.com/api/webhooks/904771543660372079/rIPczup4nBAZnBlSgSFM5T_Ub8Hf09uGFta7ns2659TILU3shNuaStqdmUFVyekX9RKY"

function Admin:SendMessage(Player,Text)
	local Message = script.ServerMessage:Clone()
	Message.Text.Value = Text
	Message.Color.Value = Color3.new(1, 0, 0)
	Message.Parent = Player.PlayerGui
end

function Admin:FindPlayer(Target)
	for _,Player in pairs(Players:GetPlayers()) do
		if Target:lower() == (Player.Name:lower()):sub(1,#Target) then
			return Player
		end
	end
end

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

local function ParseMessage(Player,Message)
	Message = string.lower(Message)

	local PrefixMatch = string.match(Message,"^"..Prefix)

	if PrefixMatch then --only do the command if their is a prefix
		Message = string.gsub(Message,PrefixMatch,"",1)

		local Arguments = {}

		for Argument in string.gmatch(Message,"[^%s]+") do
			table.insert(Arguments,Argument)
		end

		local CommandName = string.lower(Arguments[1])
		table.remove(Arguments,1)
		local CommandFound = false
		
		--see if the command name matches the module name or check it's aliases table
		for _,v in pairs(script.Commands:GetChildren()) do
			if CommandName == string.lower(v.Name) or table.find(require(v).Aliases,CommandName) then
				CommandFound = true
				require(v):Run(Player,Arguments)
				CommandUsedWebhook(Player,CommandName)
				break
			end
		end
		
		if not CommandFound then
			Admin:SendMessage(Player,"That command doesn't exist")
		end

	end
end

local function IsAdmin(Player)
	if table.find(BannedAdmins,Player.UserId) then warn(Player.Name.."is a banned admin") return end
	
	local Data = require(SSS:WaitForChild("ServerMaster").Profile)
	local Profile = Data.Profiles[Player]
	
	if table.find(Admins,Player.UserId) or table.find(Admins,Player.Name) or Profile.IsAdmin then
		return true
	end
end

function Admin:PlayerAdded(Player)
	if IsAdmin(Player) then
		Admin:SendMessage(Player,"You're an admin! Do ;cmds for a list of commands and press ; to open the command bar.")
		Admin:SendMessage(Player,"Please don't abuse commands they are logged :]")
		local AdminFrame = script.AdminFrame:Clone()
		AdminFrame.Parent = Player.PlayerGui:WaitForChild("ScreenGui")
		local AdminScript = script.AdminControl:Clone()
		AdminScript.Parent = Player.PlayerGui:WaitForChild("ScreenGui")
		local AdminButton = script.AdminButton:Clone()
		AdminButton.Parent = Player.PlayerGui:WaitForChild("ScreenGui").Frame.Buttons
		Player.Chatted:Connect(function(Message,Recipient)
			if not Recipient then --if they're not messaging someone
				ParseMessage(Player,Message)
			end
		end)
	end
end

--For doing commands through the command bar
Remotes.Command.OnServerEvent:Connect(function(Player,Command)
	if IsAdmin(Player) then
		ParseMessage(Player,Command)
	end
end)

return Admin
