local Buffer = {}

--| Services |--
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RepStorage = game:GetService("ReplicatedStorage")

--| Modules |--
local FIFO = require(RepStorage:WaitForChild("Modules").FIFO)
local ClientCombat = require(RepStorage:WaitForChild("Modules").ClientCombat)
local Character = require(RepStorage:WaitForChild("Modules").Character)
local Inputs = require(RepStorage:WaitForChild("Modules").Inputs)
local PlayerMoveset = require(RepStorage:WaitForChild("Modules").Moveset)

--| Remotes |-
local Remotes = RepStorage:WaitForChild("Remotes")

--| Constants |--
local ActionExpire = 0.5

--| Variables |--
local Queue = FIFO.new({INPUT = "None", TIME = 0})
local InputSequence = {} --List of buttons the player presses

function Buffer:CheckInput(Input)
	Queue:push( 
		{ 
			INPUT = Inputs.CommandList[Input], 
			TIME = os.time() 
		}
	) 
end

local function CheckIfMoveIsValid(Move)
	if Move.MoveType == "Crouch" then
		if Character.State == "Crouching" then
			warn("[CLIENT]: valid crouch attack")
			return true
		end
	elseif Move.MoveType == "Ground" then
		if Character.State == "Standing" then
			warn("[CLIENT]: valid ground attack")
			return true
		end
	elseif Move.MoveType == "Air" then
		if Character.State == "Jumping" then
			warn("[CLIENT]: valid air attack")
			return true
		end
	else
		warn("[CLIENT]: invalid")
	end
end

local function CheckSequence()
	--warn("[CLIENT]: checking sequence")
	local BufferIndex = 0
	local LastMatchIndex = 0
	local MatchedInputCount = 0

	for MoveIndex = 1, #PlayerMoveset do
		BufferIndex = ((#InputSequence - 1) + 1) --Makes sure that it always stays at 1
		MatchedInputCount = 0

		for InputIndex = #PlayerMoveset[MoveIndex].Sequence,1,-1 do
			while (BufferIndex >= 0) do
				if PlayerMoveset[MoveIndex].Sequence[InputIndex] == InputSequence[BufferIndex] then
					MatchedInputCount += 1
					break
				end

				BufferIndex -= 1
			end
		end

		if (MatchedInputCount == #PlayerMoveset[MoveIndex].Sequence) then
			LastMatchIndex = MoveIndex
			local Move = PlayerMoveset[LastMatchIndex]

			if CheckIfMoveIsValid(Move) then
				InputSequence = {}
				ClientCombat:Action(Move)
				break
			end
		end
	end
end

local function AddToSequence(Input)
	--warn("[CLIENT]: Adding to sequence")
	table.insert(InputSequence,Input)
	CheckSequence()
end

local function TryBufferedInput()
    local Length = Queue:length()

    for i = 1,Length do
        local Object = Queue:peek(i)
        local OldTime = Object["TIME"]

		if ((os.time() - OldTime) > ActionExpire) then
			--warn("[CLIENT]: Expired")
			Queue:remove(i)
			break
		else
			AddToSequence(Object["INPUT"])
		end
    end
end

RunService.RenderStepped:Connect(TryBufferedInput)

return Buffer