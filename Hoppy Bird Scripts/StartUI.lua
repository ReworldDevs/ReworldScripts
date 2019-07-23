--StartUI script
--location: LuaLocalScript, StarterUI.UiPanel

wait(1) --wait for GameUI to load in

local ui = script.Parent

--create custom F key bind for starting a round
--hides StartUI UiPanel
--fires "start" server event
function onKeyPressF()
	ui.IsVisable = false
	MessageEvent.FireServer("start")
end
ContextActionService.BindInput("keyPressF", onKeyPressF, false, Enum.KeyCode.F)
