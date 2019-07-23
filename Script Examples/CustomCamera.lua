--custom camera for PART
--location: ClientfirstLogic

--wait for Camera to load in game
wait(1) 
--initialize cameraControl function table, camera subject and position position
local cameraControl = {}
--initialize variables
local part = WorkSpace.PART
local camera = WorkSpace.Camera

camera.Subject = part
camera.FieldOfView = 55
camera.Distance = 8
camera.Pitch = 20
camera.Yaw = 0

--*********************************************************************************
--the following lines are for rotating camera to stay behind the PART object
--*********************************************************************************

--initialization function
function cameraControl.Init()
	GameRun.Update:Connect(cameraControl.Run)
end

--update camera yaw to match PART rotation
function cameraControl.Run(delta)
	camera.Yaw = part.Rotation.y --this line automatically rotates camera to stay behind the PART object
end

--initialize functions
cameraControl.Init()