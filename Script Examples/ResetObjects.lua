--LuaScript template for reseting objects in a game
--location: ServerLogic

local objFolder = WorkSpace.FOLDER --folder containing objects, FOLDER denotes folder name
local newObj = ServerStorage.FOLDER:GetAllChild() --gets all children of a folder in server storage (important: this folder is a copy of the original folder in WorkSpace for an identical reset)

--function deletes all objects in the WorkSpace folder and replaces them with objects in the ServerStorage folder
--in this example, the function is triggered by the player's death
Players.PlayerDead:Connect(function()
	platformFolder:DelAllChild() 
	for i = 1,#newPlatforms do
		local clone = newPlatforms[i]:Clone() --clone the replacement objects to ensure the process can be repeated
		clone.Parent = WorkSpace.FallingPlatforms --change the Parent of the clone to move it to the WorkSpace
	end
end)


--here is what the function looks like on its own
function reset() --note that the function is named here so it can be called in other instances
	platformFolder:DelAllChild()
	for i = 1,#newPlatforms do
		local clone = newPlatforms[i]:Clone()
		clone.Parent = WorkSpace.FallingPlatforms
	end
end