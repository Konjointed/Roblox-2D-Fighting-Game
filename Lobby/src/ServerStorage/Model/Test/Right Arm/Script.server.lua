local RS = game:GetService("ReplicatedStorage")
local RAYCAST_HITBOX  = require(RS.Modules.Universal.RaycastHitbox)

local Hitbox = RAYCAST_HITBOX:Initialize(script.Parent)

Hitbox.OnHit:Connect(function(hit, humanoid)
	print(hit)
	humanoid:TakeDamage(1.85)
end)
Hitbox:DebugMode(false)

while true do
	Hitbox:HitStart()
	wait(.5)
	Hitbox:HitStop()
end