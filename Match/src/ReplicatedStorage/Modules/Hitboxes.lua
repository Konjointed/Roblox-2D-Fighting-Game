local MessagingService = game:GetService("MessagingService")
local Hitbox = {}
Hitbox.__index = Hitbox

--| Services |--
local RepStorage = game:GetService("ReplicatedStorage")

--| Modules |--
local Zone = require(RepStorage:WaitForChild("APIs").Zone)

--| Variables |--
local Colors = {
    ["Hitbox"] = Color3.fromRGB(151, 0, 0);
	["BlockRange"] = Color3.fromRGB(91, 154, 76);
	["GrabBox"] = Color3.fromRGB(0, 85, 255);
}

function Hitbox.new(Character,Size,Position,Rotation,Name,FD,VisualHitbox)
    local self = {}

    --Make the part
    local Part = Instance.new("Part")
    Part.CastShadow = false
    Part.Name = Name
    Part.Size = Size
    Part.Position = Position
    Part.CanCollide = false
    Part.Massless = true
    Part.Color = Colors[Name]
    Part.Material = Enum.Material.Neon
    Part.Transparency = 0.5
    if not Rotation then
        Part.Orientation = Vector3.new(0,90,0)
    else
		Part.Orientation = Vector3.new(math.abs(Rotation[1])*FD,Rotation[2],Rotation[3])
    end

    --Weld it
    local Weld = Instance.new("WeldConstraint")
    Weld.Parent = Part
    Weld.Part0 = Part
    Weld.Part1 = Character.HumanoidRootPart

    --Put it in the character (will probably change later)
    Part.Parent = Character

    self.Part = Part
    self.Zone = Zone.new(Part)

    return setmetatable(self,Hitbox)
end

return Hitbox
