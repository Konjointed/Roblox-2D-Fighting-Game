local TweenManager = {}

--| Services |--
local TS = game:GetService("TweenService")

local Tweens = {}

function TweenManager:MakeTween(Info,Frame,Goals,DeleteWhenFinished,PlayTween)
	local Tween = TS:Create(Frame,Info,Goals)	
	table.insert(Tweens,Tween)
	if PlayTween then
		Tween:Play()
	end
	if DeleteWhenFinished then
		Tween.Completed:Connect(function()
			Frame:Destroy()
		end)
	end
end

function TweenManager.PauseTweens()
	for _,Tween in pairs(Tweens) do
		Tween:Pause()
	end
end

function TweenManager.PlayTweens()
	for _,Tween in pairs(Tweens) do
		Tween:Play()
	end
end

return TweenManager
