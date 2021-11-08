local NPC = {}
NPC.__index = NPC

function NPC.new(Opponent,MiddlePoint) --Player1
    local self = {}

    local Model = game:GetService("ReplicatedStorage").CharacterModels.beowulf
    local HRP = Model:WaitForChild("HumanoidRootPart")
	local CurrentFacingDirection = 0

	Model.Parent = workspace
    Model.Humanoid.MaxHealth = 10000
    Model.Humanoid.Health = 10000

    --Note: change this to heartbeat eventually
    task.spawn(function()
        while task.wait() do
            if Opponent then
                if HRP.CFrame.Z ~= MiddlePoint.CFrame.Z then
                    HRP.CFrame = CFrame.new(HRP.CFrame.X, HRP.CFrame.Y, MiddlePoint.CFrame.Z)
                end	
            
                local FacingDirection = math.floor(Opponent.Character.HumanoidRootPart.CFrame.X - HRP.CFrame.X)
                FacingDirection = math.sign(math.sign(FacingDirection) + 0.5) 
                CurrentFacingDirection = FacingDirection
            
                local NewPos = HRP.Position+Vector3.new(FacingDirection,0,0)
                HRP.CFrame = CFrame.new(HRP.Position,NewPos)
            end
        end   
    end)
	
	self.Character = Model
	self.Name = "NPC"
    self.HRP = HRP

    return setmetatable(self,NPC)
end

return NPC