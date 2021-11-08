local MatchManager = {}

--| Services |--
local Players = game:GetService("Players")
local RepStorage = game:GetService("ReplicatedStorage")

--| Modules |--
local Character = require(RepStorage:WaitForChild("Modules").Character)
local CameraClass = require(RepStorage:WaitForChild("Modules").Camera)
local Tweens = require(RepStorage:WaitForChild("Modules").Tweens)

--| Remotes |--
local Remotes = RepStorage:WaitForChild("Remotes")
local PrepareMatch = Remotes:WaitForChild("PrepareMatch")

--| Variables |--
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ScreenGui = PlayerGui:WaitForChild("ScreenGui")

PrepareMatch.OnClientEvent:Connect(function(Stage,Player2)
    warn("[CLIENT]: Preparing match")

    warn("[CLIENT]: Updating UI")
    local MatchUIPlayer1 = ScreenGui.Match.Player1
    local MatchUIPlayer2 = ScreenGui.Match.Player2
    MatchUIPlayer1.Name = Player.Name
    MatchUIPlayer1.Username.Text = Player.Name

    MatchUIPlayer2.Name = Player2.Name
    MatchUIPlayer2.Username.Text = Player2.Name

    warn("[CLIENT]: Setting up default camera")
    CameraClass:Setup()
    local DefaultCam = CameraClass.new(nil,true,"2DCam",{0,2,11},0.05)

    warn("[CLIENT]: Setting up character")
    Character:Setup(Stage.MiddlePoint,Player2)

    warn("[CLIENT]: switching to default camera")
    DefaultCam:SwitchTo()

    for _,Character in pairs(workspace.Game:GetDescendants()) do
        if Character:FindFirstChild("Humanoid") then
            Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                --warn("[CLIENT]: Health Changed")

                local NewHealth = math.floor(Character.Humanoid.Health)
                local MaxHealth = Character.Humanoid.MaxHealth
                local HealthBar = ScreenGui.Match[Player2.Name].HealthBarBackground.HealthBar
                local Health = math.clamp((NewHealth/MaxHealth),0,1)
                local HealthBarRed
                
                --Tween Health Bar
                local Info = TweenInfo.new(0,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0)
                local Goals = {Size = UDim2.fromScale(Health,HealthBar.Size.Y.Scale)}
                local HealthBarTween = Tweens.new(HealthBar,Info,Goals)
                HealthBarTween.Tween:Play()
                
                -- if not Active then
                --     Active = true
                --     if not HealthBar.Parent:FindFirstChild("HealthBarRed") then
                --         HealthBarRed = HealthBar:Clone()
                --         HealthBarRed.Name = "HealthBarRed"
                --         HealthBarRed.BackgroundColor3 = Color3.fromRGB(167, 21, 21)
                --         HealthBarRed.Parent = HealthBar.Parent
                --         HealthBarRed.ZIndex = 1
                --         HealthBarRed.BorderSizePixel = 0	
                --     else
                --         HealthBarRed = HealthBar.Parent:FindFirstChild("HealthBarRed")
                --     end
                    
                --     --| Tween Red Part Of Health Bar After 2 Seconds	
                --     local Connection
                --     Connection = Main.RunService.Stepped:Connect(function()
                --         if Cooldowns[Character.Name] and os.clock() - Cooldowns[Character.Name] > 2.5 then
                --             local Info = TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0)
                --             Modules.TweenManager.MakeTween(Info,HealthBarRed,{Transparency = 1},true,true)
                --             Active = false
                --             Connection:Disconnect()
                --         end
                --     end)
                    
                --     Cooldowns[Character.Name] = os.clock()
                -- end
            end)

            Character.Stun:GetPropertyChangedSignal("Value"):Connect(function()
                --warn("[CLIENT]: Stun Changed")    
                local NewStun = Character.Stun.Value
                local StunBar = ScreenGui.Match[Player2.Name].StunBarBackground.StunBar
                local StunClamp = math.clamp((NewStun/1000),0,1)

                local Info = TweenInfo.new(0,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0)
                local Goals = {Size = UDim2.fromScale(StunClamp,StunBar.Size.Y.Scale)}
                local StunBarTween = Tweens.new(StunBar,Info,Goals)
                StunBarTween.Tween:Play()
            end)

            Character.Guage:GetPropertyChangedSignal("Value"):Connect(function()
               -- warn("[CLIENT]: Guage Changed")    
                local NewGuage = Character.Guage.Value
                local GuageBar = ScreenGui.Match[Player.Name].GuageBarBackground.GuageBar
                local GuageClamp = math.clamp((NewGuage/1000),0,1)

                local Info = TweenInfo.new(0,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0,false,0)
                local Goals = {Size = UDim2.fromScale(GuageClamp,GuageBar.Size.Y.Scale)}
                local StunBarTween = Tweens.new(GuageBar,Info,Goals)
                StunBarTween.Tween:Play() 
            end)
        end
    end
end)

return MatchManager