--LuaScript template for creating a checkpoint system for your game
--location: ServerLogic
--note: there are multiple ways to implement a checkpoint system. this script sets checkpoints based on the avatar colliding with a checkpoint object

wait(1) --wait for objects to be spawned in

local cp1 = WorkSpace.PART --checkpount 1, PART denotes the object in WorkSpace
local cp2 = WorkSpace.PART
local cpPos = Vector3.New(0,0,0) --initialize an arbitary Vector3 to keep track of position
local spawn = WorkSpace.Spawn --Spawn part

--function hit sets the position of the spawn to the position of the avatar, thereby creating a checkpoint
function check(hit)
	if hit:IsClass("Avatar") then
		avatar = WorkSpace:GetChildByClassName("Avatar") --get the avatar in the function, since avatar objects are replaced upon death
		cpPos = avatar.Position
		spawn.Position = cpPos
		print("checkpoint set "..tostring(cpPos.x)..","..tostring(cpPos.y)..","..tostring(cpPos.z)) --prints the position of the checkpoint in console, used for testing only
	end
end

--triggers the check function upon collision
cp1.CollisionEnter:Connect(check)
cp2.CollisionEnter:Connect(check)

--note: for a system with multiple checkpoints, create a table to keep track of past checkpoints, and set the Spawn position as needed