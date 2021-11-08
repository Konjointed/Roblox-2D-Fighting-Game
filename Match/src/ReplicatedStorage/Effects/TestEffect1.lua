local Effect = {}

local Vt3n 		=	 Vector3.new
local Vt2n 		=	 Vector2.new
local Vt3i16 	=	 Vector3int16.new
local Vt2i16 	=	 Vector2int16.new
local Cfn 		=	 CFrame.new
local Cfa		=	 CFrame.Angles
local Clr3n		=	 Color3.new
local ClrRgb	=	 Color3.fromRGB
local ClrHsv	=	 Color3.fromHSV
local InNew 	=	 Instance.new
local Ran 		=	 math.random
local Rad 		=	 math.rad
local Bc		=	 BrickColor.new
local FrameTime	=	 0.016666


Effect.Effect = function(Player) -- This is the effect function, you can see how it works pretty easily if you understand scripting much
	local RefP = Player.Character["Right Leg"]
	
	for i = 1,10000 do -- Using for loops instead of tween service is more optimized and allows for 60fps effects :O
		
		coroutine.resume(coroutine.create(function() -- coroutine.resume(coroutine.create(function() is like spawn() but more optimized :O
			
			local FirePart = InNew("Part")
			
			FirePart.Parent = workspace
			FirePart.CFrame = RefP.CFrame*Cfn(0,-2,0)*Cfa(Rad(Ran(-180,180)),Rad(Ran(-180,180)),Rad(Ran(-180,180)))
			FirePart.BrickColor = Bc("White")
			FirePart.Size = Vt3n(2,2,2)
			FirePart.Material = Enum.Material.Neon
			FirePart.Anchored = true
			FirePart.CanCollide = false
			
			coroutine.resume(coroutine.create(function()
				
				for i = 1,30 do
					
					FirePart.Position = FirePart.Position+Vt3n(0,Ran(15,33)*0.001,0)
					FirePart.Transparency = FirePart.Transparency+FrameTime*2
					FirePart.Size = FirePart.Size-Vt3n(FrameTime*4,FrameTime*4,FrameTime*4)
					
					game["Run Service"].RenderStepped:Wait() -- Using RenderStepped:Wait() allows for 60fps+ effects which are buttery smooth compared to tween service, which is 30fps
					
				end
				
				FirePart:Destroy()
				
			end))
			
		end))
		
		game["Run Service"].RenderStepped:Wait()
		
	end
	
end

return Effect
