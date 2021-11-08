local Combat = {}

--| Services |--
local Players = game:GetService("Players")
local RepStorage = game:GetService("ReplicatedStorage")

--| Modules |--
local Character = require(RepStorage:WaitForChild("Modules").Character)
local HitboxClass = require(RepStorage:WaitForChild("Modules").Hitboxes)

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")
local Hit = Remotes:WaitForChild("Hit")
local Action = Remotes:WaitForChild("Action")

--| Variables |--
local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Deb = true
local Connections = {}

function Combat:Action(Move,Player2)
	warn("[CLIENT]: Move inputted")
	
	if Deb then
		Deb = false
		
		Action:FireServer(Move)
		
        --Play the moves assigned animation
        Character:StopAnimation()
        Character:PlayAnimation(Move.Animation)
    
        --Make the hitbox ONLY when  the "Active" marker is reached
        Connections["Active"] = Character.CurrentAnimation:GetMarkerReachedSignal("Active"):Connect(function()
            warn("[CLIENT]: Hitbox active")
    
            local FD = Character.CurrentFacingDirection --Facing direction
    
            local HitboxSize = Move.HitboxData.HitboxSize
            local HitboxPos1 = Move.HitboxData.HitboxPos[1]
            local HitboxPos2 = Move.HitboxData.HitboxPos[2]
            local Rotation = Move.HitboxData.Orientation
    
            local Hitbox = HitboxClass.new(Player.Character,HitboxSize,HRP.Position+Vector3.new(HitboxPos1*FD,HitboxPos2,0),Rotation,"Hitbox",FD)

            --kind of sloppy but oh well need a better system for tracking each player
            local Player2
            for _,Char in pairs(workspace.Game:GetChildren()) do
                if Char.Name ~= Player.Name then
                    Player2 = Char
                end
            end
            --Track Player2
            Hitbox.Zone:trackItem(Player2)

            --Using ZonePlus module by ForeverHD to detect hits
            Hitbox.Zone.itemEntered:Connect(function(Item)
                warn("[CLIENT]: HIT")
                Hit:FireServer(Item,Move) --Fire the server that a hit was made pog
            end)

            --Destroy the hitbox when it reaches the "Recovery" marker
            Connections["Recovery"] = Character.CurrentAnimation:GetMarkerReachedSignal("Recovery"):Connect(function()
                warn("[CLIENT]: Attack finished")
                Connections["Recovery"]:Disconnect()
				Connections["Active"]:Disconnect()
				game.Debris:AddItem(Hitbox.Part,0.1)
            end)  
		end)   
		
		task.wait(1)
		Deb = true
	else
		warn("[CLIENT]: Can't attack yet")
    end
end

return Combat
