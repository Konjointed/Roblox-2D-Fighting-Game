local rngplayer = {
	2596934398, -- dom
	649296822, -- waffle
	88146999, -- ohuum
	302713152 -- cocolloelrkalkckkkkk
}


while wait(60) do
	local funnie = math.random(1,#rngplayer)
	local rplayer = rngplayer[funnie]
	script.Parent.Humanoid:ApplyDescription(game.Players:GetHumanoidDescriptionFromUserId(rplayer))
end	