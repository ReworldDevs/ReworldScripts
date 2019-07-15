--custom camera for flying vehicle
--location: ClientfirstLogic

--wait for Camera to load in game
wait(1) 
--initialize camera subject and position position
WorkSpace.Camera.Subject = WorkSpace.Ship
WorkSpace.Camera.FieldOfView = 55
WorkSpace.Camera.Distance = 8
WorkSpace.Camera.Pitch = 20
WorkSpace.Camera.Yaw = 0

--initialize cameraControl function table
local cameraControl = {}
--initialize ship object variable 
local ship = WorkSpace.Ship

--initialization function
function cameraControl.Init()
	GameRun.Update:Connect(cameraControl.Run)
end

--update camera yaw to match ship object rotation
function cameraControl.Run(delta)
	WorkSpace.Camera.Yaw = ship.Rotation.y
end

cameraControl.Init()
