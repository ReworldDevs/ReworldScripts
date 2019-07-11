--flappy bird object initialization and mechanism script
--location: ServerLogic

local flappy = WorkSpace.Flappy
local walls = WorkSpace.Walls:GetAllChild()
local velY = 7
local startPos = flappy.Position

--response function to "start" server event
--unanchors flappy bird object
function start(Uid)
	flappy.Anchored = false
end
MessageEvent.ServerEventCallBack("start"):Connect(start)

--create custom space key bind for a "jump" action
function onKeyPressSpace()
	flappy.Velocity = Vector3.New(0,velY,0)
	velY=velY+0.01 --temporary workaround for a bug, can be removed later
end
ContextActionService.BindInput("keyPressSpace", onKeyPressSpace, false, Enum.KeyCode.Space)

--create collision event for flappy bird object
--fires "end" server event, and resets flappy bird object location and velocity
flappy.IsCollisionCallBack = true
flappy.CollisionEnter:Connect(function(hit)
	MessageEvent.FireServer("end")
	flappy.Position = startPos
	flappy.Velocity = Vector3.New(0,0,0)
	flappy.Anchored = true
end)