--Modified default CameraControl script
--location: StarterPlayers.StarterPlayerScripts.PlayerOperationScript
--note: see comments for modifications

--?????????????
local openCameraControlDebug = false
local TOUCH_ROTATION_HORIZONTAL_SPEED = 23;
local TOUCH_ROTATION_VERTICALLY_SPEED = 7;
local AUTODRIVEROTATIONTIME = 2
local SightsLeftRightParam = 100;
local SightsUpDownParam = 100; 
local ManualMarkTime = 0;


CameraControl = {}
CameraControl.binAvatarHideParts = false
CameraControl.AvatarFirstInit = false
CameraControl.AvatarInit = false
function CameraControl.Main()
    Players:GetLocalPlayer().CharacterAdded:Connect(CameraControl.OnCharacterAdded)
    local function update(delayTime)
        local player = Players:GetLocalPlayer()
        if player.Avatar and player.ControlType == HandleMode.TheFirstPerson then
			if player.Avatar.Health == 0 then
				if CameraControl.AvatarFirstInit == false then
					CameraControl.binAvatarHideParts = false
					CameraControl.HideAvatarParts()
				end
				CameraControl.AvatarFirstInit = true
				WorkSpace.CurCamera.MinPitchDistance = 0
				WorkSpace.CurCamera.MaxPitchDistance = 90
				WorkSpace.CurCamera.MinZoomDistance = 0.5
				WorkSpace.CurCamera.MaxZoomDistance = 10
				WorkSpace.CurCamera.Distance = 5
				
				--WorkSpace.CurCamera.Yaw = player.Avatar.Rotation.y +135
				WorkSpace.CurCamera.FieldOfView = 60
				WorkSpace.CurCamera.Pitch = 20
				WorkSpace.CurCamera.Offset = Vector3.New(0, 0, 0)
			else
				CameraControl.AvatarFirstInit = false
			end
			
			if WorkSpace.CurCamera.Distance <= 0.5 then
				if CameraControl.binAvatarHideParts == false then
					CameraControl.HideAvatarParts()
				end
				CameraControl.binAvatarHideParts = true
			else
				if CameraControl.binAvatarHideParts == true then
					CameraControl.HideAvatarParts()
				end
				CameraControl.binAvatarHideParts = false
			end
			
            if player.Avatar:GetState() == Enum.AnimationType.Seat and WorkSpace.CurCamera.Subject then
                if Time.time - ManualMarkTime > AUTODRIVEROTATIONTIME then
                    local lerpRotation =  Quaternion.Slerp(Quaternion.Euler(WorkSpace.CurCamera.Rotation.x, 
                    WorkSpace.CurCamera.Rotation.y, 
                    WorkSpace.CurCamera.Rotation.z), 
                    Quaternion.Euler(WorkSpace.CurCamera.Subject.Rotation.x,
                    WorkSpace.CurCamera.Subject.Rotation.y,
                    WorkSpace.CurCamera.Subject.Rotation.z)
                    , delayTime * 4);
                    WorkSpace.CurCamera.Yaw = lerpRotation:ToEulerAngles().y;
                end
            end
        end
	end
	GameRun.Update:Connect(update)
end

function CameraControl.SetSightsLeftRightParam(param)
    SightsLeftRightParam = param; 
end

function CameraControl.SetSightsUpDownParam(param)
    SightsUpDownParam = param; 
end

--?????????
function CameraControl.OnCharacterAdded(avatar)
	GameUI["UIJoystick"].IsVisable = true
    GameUI["Leap"].IsVisable = true
    local player = Players:GetLocalPlayer()
    local handleType = player.ControlType
    local camera = nil
    
    --?????????????????
	camera = StarterPlayers["First Person Camera"] --change the camera control

    if openCameraControlDebug then
        print("CameraControl.OnCharacterAdded avatar:" .. avatar.Name)
    end

    CameraControl.onCharacterAddedResetCamera(camera, avatar)

end
--????????????????
function CameraControl.onCharacterAddedResetCamera(camera, Character)
    
    --?????
    CameraControl.binAvatarHideParts = false

    if openCameraControlDebug then
        print("CameraControl.onCharacterAddedResetCamera")
    end

    local handleType = StarterPlayers.ControlType

    local curCamera = WorkSpace.CurCamera
    curCamera.CameraType = camera.CameraType
    --curCamera.Subject = camera.Subject
    curCamera.Transparency = camera.Transparency
    curCamera.FieldOfView = camera.FieldOfView
    
    curCamera.CrateFollow = camera.CrateFollow
    curCamera.Occlusion = camera.Occlusion
    curCamera.MinZoomDistance = camera.MinZoomDistance
    curCamera.MaxZoomDistance = camera.MaxZoomDistance
    curCamera.MinPitchDistance = camera.MinPitchDistance
    curCamera.MaxPitchDistance = camera.MaxPitchDistance

	curCamera.Distance = camera.Distance

    curCamera.Pitch = camera.Pitch
    curCamera.Yaw = camera.Yaw

    curCamera.Offset = camera.Offset
    
    --????????????
    curCamera.Subject = Character
    if openCameraControlDebug then
        print("camera.camera.Rotation.x:" .. curCamera.Rotation.x)
        print("camera.camera.Rotation.y:" .. curCamera.Rotation.y)
        print("camera.camera.Rotation.z:" .. curCamera.Rotation.z)
    end

    --??????
    if curCamera.Distance <= 0.5 then
        CameraControl.binAvatarHideParts = true
    else
        CameraControl.binAvatarHideParts = false
    end
    CameraControl.HideAvatarParts()

    coroutine.start(function()
         coroutine.wait(0.1)
         CameraControl.HideAvatarParts()
    end)

    Character.ChildAdded:Connect(function(v)
        CameraControl.SetPartTransparency(v)
    end)
end

function CameraControl.ProcessTurn(x, y)
    if WorkSpace.CurCamera == nil then
        return
    end

    CameraControl.ReSetManualMarkTime()

    x = x * (SightsLeftRightParam / 100);
    y = y * (SightsUpDownParam / 100);
    WorkSpace.CurCamera.Yaw = WorkSpace.CurCamera.Yaw + TOUCH_ROTATION_HORIZONTAL_SPEED * x;
    WorkSpace.CurCamera.Pitch = WorkSpace.CurCamera.Pitch + TOUCH_ROTATION_VERTICALLY_SPEED * y;
end
function CameraControl.ReSetManualMarkTime()
    ManualMarkTime = Time.time
end
function CameraControl.ProcessZoom(value)
    if WorkSpace.CurCamera == nil then
        return
    end
    WorkSpace.CurCamera.Distance = WorkSpace.CurCamera.Distance - value

    if WorkSpace.CurCamera.Distance <= 0.5 then
		if CameraControl.binAvatarHideParts == false then
			CameraControl.HideAvatarParts()
		end
        CameraControl.binAvatarHideParts = true
    else
		if CameraControl.binAvatarHideParts == true then
			CameraControl.HideAvatarParts()
		end
        CameraControl.binAvatarHideParts = false
    end
    CameraControl.HideAvatarParts()
end
function CameraControl.SetPartTransparency(v)
    if v:IsClass("MeshPart") then
        if v.Name ~= "LeftHand" and v.Name ~= "RightHand" and v.Name ~= "LeftArm" and v.Name ~= "RightArm" and v.Name ~= "Left Palm" and v.Name ~= "Right Palm" then
            if CameraControl.binAvatarHideParts then
                v.Transparency = 0
            else
                v.Transparency = 1
            end
        end
    elseif v:IsClass("Accessory") then
        if CameraControl.binAvatarHideParts then
            if v["Hook"] then
                v["Hook"].Transparency = 0
            end
        else
            if v["Hook"] then
                v["Hook"].Transparency = 1
            end
        end
    end
end
function CameraControl.HideAvatarParts()
    local player = Players:GetLocalPlayer()
    if player == nil then
        return
    end
    if player.Avatar == nil then
        return
    end
    
    local tableParts = player.Avatar:GetAllChild()
    for _, v in pairs(tableParts) do
        CameraControl.SetPartTransparency(v)
    end
end
CameraControl.Main()