--LuaScript template for custom key bindings
--location: StarterPlayers.StartPlayerScripts.PlayerOperationScript
--note: custom key bindings will override each other based on latest bind
--note: custom key bindings will NOT override default keys 
	--(to change default keys, delete script in StarterPlayers.StartPlayerScripts.PlayerOperationScript.OperationControl and transfer the functionality as needed)

--in this example, we create example custom bindings for the E and R keys

--Defines an arbitrary function to be called if E key pressed
function onKeyPressE() 
	print("E pressed")
end

--jump function, taken from StarterPlayers.StarterPlayerScripts.PlayerOperationScript.OperationControl
--for overriding default bindings, cut this script from StarterPlayers.StartPlayerScripts.PlayerOperationScript.OperationControl and move it here
function HandleControl.ProcessJump()
    local player = Players:GetLocalPlayer()
    if player == nil then
        return
    end
    if player.Avatar == nil then
        return
    end
    player.Avatar:Jump()
end

--define a function to be called if R key pressed
function onKeyPressR()  
	--calls the jump function defined above
	--Pressing R will now make the player jump
	HandleControl.ProcessJump() 
end

--use ContextActionService.BindInput to bind custom input functions to keys
ContextActionService.BindInput("keyPressE", onKeyPressE, false, Enum.KeyCode.E)
ContextActionService.BindInput("keyPressR", onKeyPressR, false, Enum.KeyCode.R)

--prints all custom key binds in console, used for debugging
for _,v in pairs(ContextActionService.GetAllBindInputInfo()) do
	print(tostring(v.keyCode).."  "..tostring(v.actionName).."  "..tostring(v.functionName))
end
