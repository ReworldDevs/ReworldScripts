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
--initialize variables
local ship = WorkSpace.Ship
local camera = WorkSpace.Camera

--initialization function
function cameraControl.Init()
	GameRun.Update:Connect(cameraControl.Run)
end

--update camera yaw to match ship object rotation
function cameraControl.Run(delta)
	camera.Yaw = ship.Rotation.y
	if math.abs(ship.Velocity.x)+math.abs(ship.Velocity.z)>15 and camera.FieldOfView<75 then camera.FieldOfView=camera.FieldOfView+2 end
	if math.abs(ship.Velocity.x)+math.abs(ship.Velocity.z)<15 and camera.FieldOfView>55 then camera.FieldOfView=camera.FieldOfView-2 end
end

cameraControl.Init()
