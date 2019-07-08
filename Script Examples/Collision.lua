--LuaScript template for detecting collision between an object and the avatar
--location: ServerLogic

local obj = WorkSpace.PART --PART denotes object name

obj.IsCollisionCallBack = true

--detects collision and triggers the function inside
obj.CollisionEnter:Connect(function(hit)
	if hit:IsClass("Avatar") then --ensures that the collision is with an avatar ("hit" is the oject that is collided with)
		hit:BeKilled() --in this example, we kill the avatar upon collsion, but what the function does can be changed
	end
end)

--an alternate version of the same trigger function, with a different action taken
obj.CollisionEnter:Connect(function(hit)
	if hit:IsClass("Avatar") then 
		print("player hit") --this version simply prints in the console
	end
end)

--to detect collision with all objects simply remove the if statement
obj.CollisionEnter:Connect(function(hit)
	print("collision detected") --this version simply prints in the console
end)