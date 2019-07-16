--custom controls for flying vehicle
--location: ServerLogic

--initialize variables and shipControl function table
local ship = WorkSpace.Ship
local shipControl = {}
local w = false
local s = false
local a = false
local d = false
local q = false
local e = false
local c = false

--initialization function
function shipControl.Init()
	GameRun.Update:Connect(shipControl.Run)
end

--update ship object velocity and rotation based on bool variables
function shipControl.Run(delta)
	local x = math.cos(math.rad(ship.Rotation.y))
	local y = math.sin(math.rad(ship.Rotation.y))
	if not w and not s and not e and not q then ship.Velocity = ship.Velocity/1.05 end
	if not a and not d then ship.RotVelocity = Vector3.New(0,0,0) end
	if w and not c then ship.Velocity = Vector3.New(10*y,0,10*x) end
	if w and c then ship.Velocity = Vector3.New(40*y,0,40*x) end
	if s then ship.Velocity = Vector3.New(-10*y,0,-10*x) end
	if e then ship.Velocity = Vector3.New(0,10,0) end
	if q and ship.Position.y>1 then ship.Velocity = Vector3.New(0,-10,0) end
	if a then ship.RotVelocity = Vector3.New(0,-1.5,0) end
	if d then ship.RotVelocity = Vector3.New(0,1.5,0) end
end

--detect user input begin and change bool variables accordingly
function inputBegin(inputobject) 
    if tostring(inputobject.InputKeyCode) == "W" and tostring(inputobject.InputState) == "Begin" then w = true end
    if tostring(inputobject.InputKeyCode) == "C" and tostring(inputobject.InputState) == "Begin" then c = true end
	if tostring(inputobject.InputKeyCode) == "S" and tostring(inputobject.InputState) == "Begin" then s = true end
	if tostring(inputobject.InputKeyCode) == "E" and tostring(inputobject.InputState) == "Begin" then e = true end
    if tostring(inputobject.InputKeyCode) == "Q" and tostring(inputobject.InputState) == "Begin" then q = true end
	if tostring(inputobject.InputKeyCode) == "A" and tostring(inputobject.InputState) == "Begin" then a = true end
	if tostring(inputobject.InputKeyCode) == "D" and tostring(inputobject.InputState) == "Begin" then d = true end
end

--detect user input end and change bool variables accordingly
function inputEnd(inputobject) 
	if tostring(inputobject.InputKeyCode) == "W" and tostring(inputobject.InputState) == "End" then w = false end
	if tostring(inputobject.InputKeyCode) == "C" and tostring(inputobject.InputState) == "End" then c = false end
	if tostring(inputobject.InputKeyCode) == "S" and tostring(inputobject.InputState) == "End" then s = false end
	if tostring(inputobject.InputKeyCode) == "E" and tostring(inputobject.InputState) == "End" then e = false end
    if tostring(inputobject.InputKeyCode) == "Q" and tostring(inputobject.InputState) == "End" then q = false end
	if tostring(inputobject.InputKeyCode) == "A" and tostring(inputobject.InputState) == "End" then a = false end
	if tostring(inputobject.InputKeyCode) == "D" and tostring(inputobject.InputState) == "End" then d = false end
end

--optional firing function
--clones a beam object from ServerStorage, places it in from of the ship object and shoots it out
function fire()
	local x = math.cos(math.rad(ship.Rotation.y))
	local y = math.sin(math.rad(ship.Rotation.y))
	local beam = ServerStorage.Beam:Clone()
	beam.Position = ship.Position+Vector3.New(2*y,0,2*x)
	beam.Rotation = ship.Rotation
	beam.Velocity = Vector3.New(70*y,0,70*x)
	beam.Parent = WorkSpace
end

--key bind and input detection service functions
ContextActionService.BindInput("fire", fire, false, Enum.KeyCode.Space)
UserInputService.InputBegan:Connect(inputBegin)
UserInputService.InputEnded:Connect(inputEnd)

--initialize functions
shipControl.Init()

