--LuaLocalScript template for creating a custom UI display 
--location: StartUI.UiPanel (your UI panel located in StarterUI)

wait(1) --wait for GameUI to load 

local ui = script.Parent --the UiPanel that this script is a child of

--in this example, the visibility of the UI panel is triggered upon the player's death
Players.PlayerDead:Connect(function()
	ui.IsVisable = true
end)

--here is what the function looks like on its own
function showUI() --note that the function is named here so it can be called in other instances
	ui.IsVisable = true
end