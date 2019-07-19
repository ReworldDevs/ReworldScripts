--round reset script
--location: ServerLogic

--response function for "start" server event
--resets Counter UiPanel and hides Endgame UiPanel
function reset(Uid)
	local player = Players:GetPlayerByUserId(Uid)
	local endgame = player:GetChildByName("Endgame",true)
	local counter = player:GetChildByName("Counter",true)
	counter.Score.Text = tostring(0)
	endgame.IsVisable = false
end

MessageEvent.ServerEventCallBack("start"):Connect(reset)
