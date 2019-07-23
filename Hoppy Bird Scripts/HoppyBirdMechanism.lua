--hoppy bird object initialization and mechanism script
--location: ServerLogic

local hoppy = WorkSpace.Hoppy
local velY = 7
local startPos = hoppy.Position
local startRot = hoppy.Rotation

--response function to "start" server event
--unanchors hoppy bird object
function start(Uid)
	velY = 7
	hoppy.Anchored = false
end
MessageEvent.ServerEventCallBack("start"):Connect(start)

--create custom space key bind for a "jump" action
function onKeyPressSpace()
	hoppy.Velocity = Vector3.New(0,velY,0)
	velY=velY+0.01 --temporary workaround for a bug, can be removed later
end
ContextActionService.BindInput("keyPressSpace", onKeyPressSpace, false, Enum.KeyCode.Space)

--create collision event for hoppy bird object
--fires "end" server event, and resets hoppy bird object location and velocity
hoppy.IsCollisionCallBack = true
hoppy.CollisionEnter:Connect(function(hit)
	MessageEvent.FireServer("end")
	hoppy.Position = startPos
	hoppy.Velocity = Vector3.New(0,0,0)
	hoppy.Rotation = startRot
	hoppy.Anchored = true
end)