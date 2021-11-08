local Camera = {}
Camera.__index = Camera

--| Services |--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RepStorage = game:GetService("ReplicatedStorage")

--| Modules |--
local TweenClass = require(RepStorage:WaitForChild("Modules").Tweens)

local WorkspaceCam = workspace.CurrentCamera
WorkspaceCam.CameraType = Enum.CameraType.Scriptable
-- WorkspaceCam.FieldOfView = Enum.FieldOfViewMode.MaxAxis

local CurrentCam 
local HRPS = {}

local function CalculateAveragePosition()
	local Total = Vector3.new()
	for _,HRP in pairs(HRPS) do    
		Total += HRP.Position
	end
	return Total / #HRPS
end

-- local function calculateAverageMagnitude()
-- 	local total = 0
-- 	for _, HRP in pairs(HRPS) do    
-- 		total += (HRP.Position - CurrentCam.Position).Magnitude
-- 	end

--     local Test = total / #HRPS
--     if Test >= 20 then
--         return 20
--     elseif Test <= 10 then
--         return 10
--     else
--         return Test
--     end
-- end

function Camera:Setup()
	for _,HRP in pairs(workspace.Game:GetDescendants()) do
		if HRP.Parent.Parent.Name ~= "Characters" then
			if HRP.Name == "HumanoidRootPart" then
				table.insert(HRPS,HRP)
			end
		end
	end	
end

function Camera.new(Position,Anchored,Name,Offset,Speed)
    local self = {}

    local CameraPart = Instance.new("Part")
    CameraPart.CFrame = Position or CFrame.new(0,0,0)
    CameraPart.Anchored = Anchored or false
    CameraPart.Name = Name or "CameraPart"
    CameraPart.CanCollide = false
    CameraPart.Transparency = 1
    CameraPart.Parent = workspace
    
    self.CameraPart = CameraPart
    self.XOffset = Offset[1]
    self.YOffset = Offset[2]
    self.ZOffset = Offset[3]
    self.DefaultMoveSpeed = 0.2
    self.MoveSpeed = Speed --How fast the camera moves (0 = instant)
    -- self.PosTween = TweenClass.new(
    --                 CurrentCam,
    --                 TweenInfo.new(Speed,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0),
    --                 {Position = CalculateAveragePosition()
    --                 })
    -- self.CTween = TweenClass.new(
    --     WorkspaceCam,
    --     TweenInfo.new(Speed,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0),
    --     {CFrame = CurrentCam.CFrame * CFrame.new(Vector3.new(self.XOffset,self.YOffset,self.ZOffset))
    --     })

    return setmetatable(self,Camera)
end

function Camera:SwitchTo()
    CurrentCam = self.CameraPart
    RunService.RenderStepped:Connect(function()
        -- WorkspaceCam.DiagonalFieldOfView = 130
        -- WorkspaceCam.FieldOfView = 70

        CurrentCam.Position = CalculateAveragePosition()
        WorkspaceCam.CFrame = CurrentCam.CFrame * CFrame.new(Vector3.new(self.XOffset,self.YOffset,self.ZOffset))
        
        -- local Info1 = TweenInfo.new(self.MoveSpeed,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0)
        -- local PosTween = TweenClass.new(CurrentCam,Info1,{Position = CalculateAveragePosition()})
        -- PosTween.Tween:Play()
        --PosTween.Tween.Completed:Wait()

        -- local Info2 = TweenInfo.new(self.MoveSpeed,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0)
        -- local CTween = TweenClass.new(WorkspaceCam,Info2,{CFrame = CurrentCam.CFrame * CFrame.new(Vector3.new(self.XOffset,self.YOffset,self.ZOffset))})
        -- CTween.Tween:Play()
        --CTween.Tween.Completed:Wait()
    end)
end

return Camera