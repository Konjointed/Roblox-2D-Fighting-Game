local Tween = {}
Tween.__index = Tween

--| Services |--
local TS = game:GetService("TweenService")

function Tween.new(Object,Info,Goals)
    local self = {}

    self.Tween = TS:Create(Object,Info,Goals)

    return setmetatable(self,Tween)
end

return Tween