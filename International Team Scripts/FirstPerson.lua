local player = Players:GetLocalPlayer()
if player == nil then
	Players.PlayerAdded:Connect(function(playerId)
		player = Players:GetPlayerByUserId(playerId)
	end)
	while(player == nil) do
		wait(0.1)
	end
end

local avatar = player.Avatar
if avatar == nil then
	player.AvatarAdded:Connect(function(obj) 
		avatar = obj
	end)
	while(avatar == nil) do
		wait(0.1)
	end
end

local FirstControl = {}
FirstControl.nStatus = "None"
local folder = script.Parent
local firstLeftHand = folder:WaitForChild("左手")
local firstLeftArm = folder:WaitForChild("左大臂")
local firstRightHand = folder:WaitForChild("右手")
local firstRightArm = folder:WaitForChild("右大臂")
local actionStand = folder:WaitForChild("站立")
local actionRun = folder:WaitForChild("跑步")
local actionJump = folder:WaitForChild("起跳")
local actionFall = folder:WaitForChild("下落")

local avatarLeftHand = avatar:WaitForChild("左手")
local avatarLeftPalm = avatar:WaitForChild("左手掌")
local avatarLeftArm = avatar:WaitForChild("左大臂")
local avatarRightHand = avatar:WaitForChild("右手")
local avatarRightPalm = avatar:WaitForChild("右手掌")
local avatarRightArm = avatar:WaitForChild("右大臂")


function FirstControl.Update()
	local player = Players:GetLocalPlayer()
	if folder == nil or actionStand == nil then
		return
	end
	if WorkSpace.CurCamera ~= nil and WorkSpace.CurCamera.Distance <= 0.5 then
		FirstControl.nStatus = "First"
		avatarLeftHand.Transparency = 0
		avatarLeftPalm.Transparency = 0
		avatarLeftArm.Transparency = 0
		avatarRightHand.Transparency = 0	
		avatarRightPalm.Transparency = 0	
		avatarRightArm.Transparency = 0	
		
		firstLeftHand.Transparency = 1
		firstLeftArm.Transparency = 1
		firstRightHand.Transparency = 1	
		firstRightArm.Transparency = 1
		if(actionRun.Action ~= Enum.AnimationType.run)then
        actionRun.Action = Enum.AnimationType.run 
end
        if(actionStand.Action ~= Enum.AnimationType.stand)then
        actionStand.Action = Enum.AnimationType.stand 
end
		 if(actionJump.Action ~= Enum.AnimationType.jump)then
        actionJump.Action = Enum.AnimationType.jump 
end
		if(actionFall.Action ~= Enum.AnimationType.fall)then
        actionFall.Action = Enum.AnimationType.fall 
end
		
		--print("切换到第一人称模式")
	elseif WorkSpace.CurCamera.Distance > 0.5 then
		FirstControl.nStatus = "Three"
		firstLeftHand.Transparency = 0
		firstLeftArm.Transparency = 0
		firstRightHand.Transparency = 0	
		firstRightArm.Transparency = 0
		
		avatarLeftHand.Transparency = 1
		avatarLeftPalm.Transparency = 1
		avatarLeftArm.Transparency = 1
		avatarRightHand.Transparency = 1	
		avatarRightPalm.Transparency = 1	
		avatarRightArm.Transparency = 1
		if (actionStand.Action ~= Enum.AnimationType.none)then
		actionStand.Action = Enum.AnimationType.none
end		
		if (actionRun.Action ~= Enum.AnimationType.none)then
		actionRun.Action = Enum.AnimationType.none
end
		if (actionJump.Action ~= Enum.AnimationType.none)then
		actionJump.Action = Enum.AnimationType.none
end
		if (actionFall.Action ~= Enum.AnimationType.none)then
		actionFall.Action = Enum.AnimationType.none
end
		--print("切换到第三人称模式")
	end
end
function FirstControl.Start()
	GameRun.Update:Connect(FirstControl.Update)
end
FirstControl.Start()

