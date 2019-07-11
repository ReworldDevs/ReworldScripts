--round reset script
--location: ServerLogic

local flappy = WorkSpace.Flappy
local startPos = flappy.Position

--response function for "start" server event
--resets Counter UiPanel and hides Endgame UiPanel
--returns flappy bird object to startPos
function reset(Uid)
	local player = Players:GetPlayerByUserId(Uid)
	local ui = player:GetChildByName("Endgame",true)
	local n = player:GetChildByName("Counter",true)
	n.Score.Text = tostring(0)
	ui.IsVisable = false
	flappy.Position = startPos
	flappy.Velocity = Vector3.New(0,0,0)
end

MessageEvent.ServerEventCallBack("start"):Connect(reset)
