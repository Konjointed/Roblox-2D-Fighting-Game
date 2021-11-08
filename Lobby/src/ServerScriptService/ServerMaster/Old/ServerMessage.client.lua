wait(.1)
game.StarterGui:SetCore('ChatMakeSystemMessage', {
	Text="[Server]: "..script.Text.Value,
	Color=script.Color.Value
})
wait()
script:Destroy()