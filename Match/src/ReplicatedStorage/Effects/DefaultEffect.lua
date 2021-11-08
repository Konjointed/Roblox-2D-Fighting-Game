local Effect = {}

Effect.Effect = function(Target)
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://7148420114"
    Sound.PlayOnRemove = true
    Sound.Parent = workspace
    Sound:Destroy()

    local HitParticle = workspace.fx["Hit Particle"]:Clone()
    HitParticle.CFrame = Target.HumanoidRootPart.CFrame
    HitParticle.Parent = workspace
    HitParticle.ParticleEmitter1:Emit(1)
    HitParticle.ParticleEmitter2:Emit(1)
    game.Debris:AddItem(HitParticle,0.3)
end

Effect.Jump = function(Player)
    local JumpParticle = workspace.fx.JumpParticle:Clone()
    JumpParticle.ParticleEmitter.Enabled = true
    JumpParticle.Transparency = 1
    JumpParticle.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0,-3,0)
    JumpParticle.Parent = workspace
    JumpParticle.ParticleEmitter:Emit(30)

    --idk how number sequence works L will do later
    -- JumpParticle.ParticleEmitter.Transparency = NumberSequence.new{
    --     NumberSequenceKeypoint.new(0, 0.5), -- (time, value)
    --     NumberSequenceKeypoint.new(1, 0) -- (time, value)
    -- }
   game.Debris:AddItem(JumpParticle,0.3)
end

Effect.Stunned = function(Target)
    warn("[CLIENT]: Stunned")
end

return Effect