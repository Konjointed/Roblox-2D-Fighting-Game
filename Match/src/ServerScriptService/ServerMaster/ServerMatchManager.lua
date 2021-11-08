local MatchManager = {}

--| Services |--
local RepStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
local ServStorage = game:GetService("ServerStorage")

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")
local PrepareMatch = Remotes:WaitForChild("PrepareMatch")

--| Modules |--
local NPC = require(SSS.ServerMaster:WaitForChild("NPC"))
local StageMusic = require(SSS.ServerMaster:WaitForChild("StageMusic"))

--| Variables |--
local SinglePlayerTest = RepStorage:WaitForChild("Settings").SinglePlayerTest
local UseDummy = RepStorage:WaitForChild("Settings").UseDummy
local Player1
local Player2

local function SpawnStage(StageName)
    warn("[SERVER]: Spawning stage: "..StageName)
    
    local Stages = ServStorage.Stages
    local StageModel

    if StageName then
        if string.lower(StageName) == "random" then
            local RandomNumber = math.random(1,#Stages:GetChildren())
            StageModel = Stages:GetChildren()[RandomNumber]:Clone()
        else
            if Stages:FindFirstChild(StageName) then
                StageModel = Stages:FindFirstChild(StageName):Clone()
            else
                warn("[SERVER]: Stage "..StageName.." doesn't exist")    
                return false      
            end
        end
    else
        warn("[SERVER]: No stage was provided")
        return false
    end

    local Sound = Instance.new("Sound")
	Sound.SoundId = "http://www.roblox.com/asset/?id="..StageMusic[StageModel.Name]
	Sound.Looped = true
	Sound.Playing = true
	Sound.Parent = workspace
	Sound.Volume = 0.5

    StageModel.Parent = workspace

    warn("[SERVER]: Successfully spawned stage")
    return StageModel
end

local function TeleportToStage(Stage)
    warn("[SERVER]: Teleporting to stage")

    local StartingPoints = Stage:FindFirstChild("StartingPositions")

	Player1.Character.HumanoidRootPart.CFrame = StartingPoints.Position1.CFrame + Vector3.new(0,6,0)
	Player1.Character.Parent = workspace.Game
	
	if Players:FindFirstChild(Player2.Name) then
		Player2.Character.HumanoidRootPart.CFrame = StartingPoints.Position2.CFrame + Vector3.new(0,6,0)  
		Player2.Character.Parent = workspace.Game
	else
		Player2.HRP.CFrame = StartingPoints.Position2.CFrame + Vector3.new(0,6,0) 
		Player2.HRP.Parent.Parent = workspace.Game
	end
end

local function SetupCharacter(Character)
    local function MakeTag(Name,Parent,InstanceType)
        local Tag = Instance.new(InstanceType)
        Tag.Name = Name
        Tag.Parent = Parent
    end

    MakeTag("Stun",Character,"IntValue")
    MakeTag("Guage",Character,"IntValue")
end

--Note: Probably gonna need to add a thing where if something goes wrong while preparing it retries or kicks both players
function MatchManager:Prepare()
    warn("[SERVER]: Preparing match")

    Player1 = Players:GetPlayers()[1]

    local Stage = SpawnStage("Lobby") --Spawn a random stage

    --Figure out who Player2 is
    --For debugging purposes I did this so I can use a dummy instead of second player
    if SinglePlayerTest.Value == false then
        Player2 = Players:GetPlayers()[2] 
    else
        if UseDummy.Value == true then
            Player2 = NPC.new(Player1,Stage.MiddlePoint)
        end
    end

    SetupCharacter(Player1.Character)
    SetupCharacter(Player2.Character)

    if Stage == nil then --if there's no stage then we're probably gonna need to do something about that
        warn("[SERVER]: No stage... oops..")
    else
        TeleportToStage(Stage)
	end

    --Prepare each client
	PrepareMatch:FireClient(Player1,Stage,Player2)
	if Players:FindFirstChild(Player2.Name) then
		PrepareMatch:FireClient(Player2,Stage,Player1)		
	end

    warn("[SERVER]: Finished preparing match")
end

return MatchManager