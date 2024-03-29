local original = ServerStorage:GetChildByName("Part")  
--The variable original now refers to the Part or Union called Part under ServerStorage. ServerStorage.Part would have worked too.

local copy
--initialize the variable that will refer to the clones

local x
local y = 2
local z
--Position of the first clone will be determined later, but y sets a base height to begin placing them

local rho = 0
local dRho = 5
--angle from center and how fast the angle changes, based on 360 degrees system

local r = 2.5
--distance from center

local i = 1
--i will be the counter for how many total clones
while i <= 200 do
	--the while loop sort of functions as an update, with the wait(0.5) at the end meaning it updates twice a second
	--we will clone at least 200 times (could be more if it is in the middle of the for loop by then)
	for j = 1, 5, 1 do
		--every update, this for loop runs 5 times, creating 5 clones
		i = i + 1
		copy = original:Clone()
		--this is the line creating the new Part or Union and assigns it to the variable copy
		copy.Parent = WorkSpace
		--move the copy from ServerStorage to WorkSpace so that it's visible
		copy.Rotation = Vector3.New(0,0,rho)
		--rotate the copy about the z axis depending on where it is in the overall circle
		
		x = r * math.sin(rho/360*6.283)
		z = r * math.cos(rho/360*6.283)
		--set the x and z so that the clones arranged themselves in a circle. math.sin and cos use 2*pi for the angle, so convert 360 degrees to that
		y = y + 0.01
		--cause the clones to slowly rise up to form a spiral
		copy.Position = Vector3.New(x, y, z)
		--moves the clone to its designated x,y and z
		rho = rho + dRho
		--increase the angle in preparation for the next clone
	end
	wait(0.5)
end