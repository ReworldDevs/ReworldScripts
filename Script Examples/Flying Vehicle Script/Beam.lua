--Delete a beam after collision to reduce memory usage
--location: ServerStorage -> Beam

local beam = script.Parent
beam.IsCollisionCallBack = true

function collide()
	beam:Destroy()
end

beam.CollisionEnter:Connect(collide)