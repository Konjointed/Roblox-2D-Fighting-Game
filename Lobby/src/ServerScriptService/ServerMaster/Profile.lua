local ProfileModule = {}


local ProfileTemplate = {
	IsBanned = false,
	IsAdmin = false,
	IsTester = false,
	
	--Match preferences (this is what gets used when they go into a match)
	PreferredTime = 99,
	PreferredRounds = 3,
	PreferredCharacter = "AnimDummy", 
	PreferredStage = "Grid 2",
	
	--Stats
	Wins = 0,
	Loses = 0,
	Rank = "Bronze",
	Draws = 0,
	Gold = 0,
	
	Inventory = {},
}

--| Services |--
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
local HTTP = game:GetService("HttpService")

--| Modules |--
local PS = require(SSS:WaitForChild("APIs").ProfileService)
local Admin = require(SSS:WaitForChild("ServerMaster").Admin)
local Admins = require(SSS:WaitForChild("ServerMaster").Admin.Admins)

--| Vaiables |--
ProfileModule.ProfileStore = PS.GetProfileStore(
	"PlayerData",
	ProfileTemplate
)

ProfileModule.Profiles = {}

function ProfileModule:GiveCash(Profile,Amount)
	if Profile.Data.Cash == nil then
		Profile.Data.Cash = 0
	end

	Profile.Data.Cash += Amount
end

local function LoadedProfile(Player,Profile)
	if Profile.Data.IsAdmin then
		warn("[SERVER]: is an admin (manually added)")
		table.insert(Admins,Player.UserId)
	end
end

local function PlayerAdded(Player)
	warn("[SERVER]: Player joined")
	
	Admin:PlayerAdded(Player)
	
	local Profile = ProfileModule.ProfileStore:LoadProfileAsync("Player_"..Player.UserId)
	if Profile ~= nil then
		Profile:Reconcile() --Fill in missing variables from template (optional)
		Profile:ListenToRelease(function()
			ProfileModule.Profiles[Player] = nil
			Player:Kick()
		end)
		if Player:IsDescendantOf(Players) == true then
			ProfileModule.Profiles[Player] = Profile
			--A profile has been successfully loaded:
			LoadedProfile(Player,Profile)
		else
			--Player left before the profile loaded.
			Profile:Release()
		end
	else
		Player:Kick()		
	end
	
	local PlayerGui = Player:WaitForChild("PlayerGui")
	local ServerRegion = PlayerGui:WaitForChild("ScreenGui").Frame.ServerRegion
	local Long = HTTP:JSONDecode(HTTP:GetAsync('http://ip-api.com/json/')).lon

	if(Long>-180 and Long<=-105)then
		ServerRegion.Text = "Server Region: West US"
	elseif(Long>-105 and Long<=-90)then
		ServerRegion.Text = "Server Region: Central US"
	elseif(Long>-90 and Long<=0)then
		ServerRegion.Text = "Server Region: East US"
	elseif(Long<=75 and Long>0)then
		ServerRegion.Text = "Server Region: Europe"
	elseif(Long<=180 and Long>75)then
		ServerRegion.Text = "Server Region: Australia"
	else
		ServerRegion.Text = "Server Region: N\A"
	end
end

--In case Players have joined the server earlier than this script ran
for _,Player in ipairs(Players:GetPlayers()) do
	task.spawn(PlayerAdded,Player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(Player)
	local Profile = ProfileModule.Profiles[Player]
	if Profile ~= nil then
		Profile:Release()
	end
end)

return ProfileModule
