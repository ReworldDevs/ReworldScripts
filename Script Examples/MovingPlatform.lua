--LuaScript template for a modular oscillating moving platform
--location: ServerLogic

local platform = WorkSpace.Transport1.PART --platform object, PART denotes part object name
local startpos = WorkSpace.Transport1.PART.Position --non colliding start position marker
local endpos = WorkSpace.Transport1.PART.Position --non colliding end position marker

local distance = platform.PrismaticComponent.CurrentDistance --maximum distance of the connecting prismatic component (sliding joint)

--function approximate(Vector3, Vector3)
--takes in two Vector3 parameters
--returns true if the distance between the vectors is less than sqrt(3)
function approximate(pos, target)
	if target.x-1 < pos.x and pos.x < target.x+2 and
	target.y-1 < pos.y and pos.y < target.y+2 and
	target.z-1 < pos.z and pos.z < target.z+2 then 
		return true
	end
end

wait(1) 

platform.BodyPosition.Position = endpos --initializes target body position to endpos
platform.PrismaticComponent.DUpperLimit = distance --initializes travel distance to the max distance

--continuously checks position of platform and changes target position appropriately
while true do
	if approximate(platform.Position,startpos) then
		wait(1)
		platform.BodyPosition.Position = endpos
	end
	if approximate(platform.Position,endpos) then
		wait(1)
		platform.BodyPosition.Position = startpos
	end
	wait(0.1)
end