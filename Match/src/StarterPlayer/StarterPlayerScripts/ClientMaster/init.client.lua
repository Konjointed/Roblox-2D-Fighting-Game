--| Services |--
local RepStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--| Modules |--
local CameraClass = require(RepStorage:WaitForChild("Modules").Camera)
local TweenClass = require(RepStorage:WaitForChild("Modules").Tweens)
local Character = require(RepStorage:WaitForChild("Modules").Character)
local ES = require(RepStorage:WaitForChild("Modules").EffectService)
local ClientMatchManager = require(RepStorage:WaitForChild("Modules").ClientMatchManager)

task.wait(1)

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false) 

