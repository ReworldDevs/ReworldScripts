--wall and infinite scroll initialization and mechanism script
--location: ServerLogic

local walls = WorkSpace.Walls:GetAllChild()
local maxheight = 2.75
local minheight = -1
local x = 5 --initial wall Position.x
local z = walls[1].Position.z --wall Position.z
local wallCounter = 1 --counter var for walls table

--response function for "start" server event
--randomly sets a wall height between minheight and maxheight for each wall
--initializes wall velocity 
function start(Uid)
	for i=1,#walls do
		walls[i].Position = Vector3.New(x+(i-1)*3.5,math.random(minheight,maxheight),z)
		walls[i].BodyVelocity.Velocity = Vector3.New(-2,0,0)
	end
	wallCounter = 1 --resets counter for each new round
end

--response function for "end" server event
--sets wall velocity to 0
function endFunct(Uid)
	for i=1,#walls do
		walls[i].BodyVelocity.Velocity = Vector3.New(0,0,0)
	end
end

MessageEvent.ServerEventCallBack("start"):Connect(start)
MessageEvent.ServerEventCallBack("end"):Connect(endFunct)

--cycles walls while game is running to simulate infinite scroll
function wallsRun()
	if walls[wallCounter].Position.x < -15 then
		walls[wallCounter].Position = Vector3.New((walls[wallCounter].Position.x)+(#walls*3.5),math.random(minheight,maxheight),z)
		wallCounter=wallCounter+1
	end
	if wallCounter>#walls then wallCounter=1 end
end

GameRun.Update:Connect(wallsRun)