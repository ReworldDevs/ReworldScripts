--Script template for a nserver wide event

--location (part 1): ClientLogic (or other LuaLocalScript)
--creates message

local ui = script.Parent
local x = 7

--an arbitrary function that creates a server message when called
function onKeyPressE() 
	ui.IsVisable = false
	MessageEvent.FireServer("move", x) --creates the server message (x is a parameter passed in)
	print("E pressed")
end

ContextActionService.BindInput("keyPressE", onKeyPressE, false, Enum.KeyCode.E)


--location (part 2): ServerLogic
--receives message

--arbitrary function that is called when the message is received
function Move(Uid, x)
	print("responded")
	local part = RWObject.Create("Part")
	part.Position = Vector3.New(0,x,0)
	part.Anchored = true
	part.Parent = WorkSpace
end

MessageEvent.ServerEventCallBack("move"):Connect(move) --looks for "move" message amd calls function Move when received