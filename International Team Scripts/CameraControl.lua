--照相机控制类，主要处理与照相机相关逻辑

--是否开启照相机相关打印信息
local openCameraControlDebug = false
local TOUCH_ROTATION_HORIZONTAL_SPEED = 23;
local TOUCH_ROTATION_VERTICALLY_SPEED = 7;
local AUTODRIVEROTATIONTIME = 2
local SightsLeftRightParam = 100;
local SightsUpDownParam = 100; 
local ManualMarkTime = 0;

local YawOffect = 0
local PitchOffect = 0
local AvatarRotationY = 0

CameraControl = {}
CameraControl.binAvatarHideParts = false
CameraControl.AvatarFirstInit = false
CameraControl.AvatarInit = false

local function RotationValue(value)
    if value > 180 then
        value = math.fmod(value,360)
        if value > 180 then
            value = value - 360    
        end
    end
    if value < -180 then
        value = math.fmod(value,360)
        if value < -180 then
            value = -180 - value;
        end       
    end
    return value
end

function CameraControl.Main()
    Players:GetLocalPlayer().CharacterAdded:Connect(CameraControl.OnCharacterAdded)
	local player = Players:GetLocalPlayer()
    local function update(delayTime)
        
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
			

		end

		if player and player.Avatar and player.Avatar:GetState() == Enum.AvatarActionStatus.DriverSeat and WorkSpace.CurCamera.Subject then
			if Time.time - ManualMarkTime > AUTODRIVEROTATIONTIME then
				local lerpRotation =  Quaternion.Slerp(Quaternion.Euler(WorkSpace.CurCamera.Rotation.x, 
				WorkSpace.CurCamera.Rotation.y, 
				WorkSpace.CurCamera.Rotation.z), 
				Quaternion.Euler(WorkSpace.CurCamera.Subject.Rotation.x,
				WorkSpace.CurCamera.Subject.Rotation.y,
				WorkSpace.CurCamera.Subject.Rotation.z)
				, delayTime * 6);
				dump(math.abs(RotationValue(AvatarRotationY - player.Avatar.Rotation.y)))
				if math.abs(RotationValue(AvatarRotationY - player.Avatar.Rotation.y)) < 0.5 then
					WorkSpace.CurCamera.Yaw = lerpRotation:ToEulerAngles().y;
				else				
					if RotationValue(WorkSpace.CurCamera.Yaw - player.Avatar.Rotation.y) > 20  then
						WorkSpace.CurCamera.Yaw = lerpRotation:ToEulerAngles().y;
						if RotationValue(WorkSpace.CurCamera.Yaw - player.Avatar.Rotation.y) < 20 then
							WorkSpace.CurCamera.Yaw = player.Avatar.Rotation.y + 20	
						end
					elseif RotationValue(WorkSpace.CurCamera.Yaw - player.Avatar.Rotation.y) < -20 then
						WorkSpace.CurCamera.Yaw = lerpRotation:ToEulerAngles().y;
						if RotationValue(WorkSpace.CurCamera.Yaw - player.Avatar.Rotation.y) > -20 then
							WorkSpace.CurCamera.Yaw = player.Avatar.Rotation.y - 20	
						end
					end	
				end
			end
		end
		if player.Avatar then
			AvatarRotationY	= player.Avatar.Rotation.y	
		end
		WorkSpace.CurCamera.Yaw = WorkSpace.CurCamera.Yaw + YawOffect;
		WorkSpace.CurCamera.Pitch = WorkSpace.CurCamera.Pitch + PitchOffect;
		

		YawOffect = 0
		PitchOffect = 0
	end
	GameRun.FixedUpdate:Connect(update)
end

function CameraControl.SetSightsLeftRightParam(param)
    SightsLeftRightParam = param; 
end

function CameraControl.SetSightsUpDownParam(param)
    SightsUpDownParam = param; 
end

--当人物模型加载完成
function CameraControl.OnCharacterAdded(avatar)
	GameUI["摇杆控件"].IsVisable = true
    GameUI["跳跃"].IsVisable = true
    local player = Players:GetLocalPlayer()
    local handleType = player.ControlType
    local camera = nil
    
    --将相应照相机的属性赋值给当前摄像机
    if handleType == HandleMode.TheThreePerson then
        camera = StarterPlayers["第三人称摄像机"]
    elseif handleType == HandleMode.TheFirstPerson then
        camera = StarterPlayers["第一人称摄像机"]
    end

    if openCameraControlDebug then
        print("CameraControl.OnCharacterAdded avatar:" .. avatar.Name)
    end

    CameraControl.onCharacterAddedResetCamera(camera, avatar)
	HandleControl.ProcessGestureDrag(Vector3.zero)
end
--当人物模型加载完成重置摄像机参数
function CameraControl.onCharacterAddedResetCamera(camera, Character)
    
	local player = Players:GetLocalPlayer()
	if  player.Avatar ~= Character then
		return
	end
    --初始化变量
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
    
    --将照相机的目标设置为角色
    curCamera.Subject = Character
    if openCameraControlDebug then
        print("camera.camera.Rotation.x:" .. curCamera.Rotation.x)
        print("camera.camera.Rotation.y:" .. curCamera.Rotation.y)
        print("camera.camera.Rotation.z:" .. curCamera.Rotation.z)
    end

    --隐藏身体部位
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

	YawOffect = TOUCH_ROTATION_HORIZONTAL_SPEED * x 
	PitchOffect = TOUCH_ROTATION_VERTICALLY_SPEED * y 

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
        if v.Name ~= "左手" and v.Name ~= "右手" and v.Name ~= "左大臂" and v.Name ~= "右大臂" and v.Name ~= "左手掌" and v.Name ~= "右手掌" then
            if CameraControl.binAvatarHideParts then
                v.Transparency = 0
            else
                v.Transparency = 1
            end
        end
    elseif v:IsClass("Accessory") then
        if CameraControl.binAvatarHideParts then
            if v["挂接零件"] then
                v["挂接零件"].Transparency = 0
            end
        else
            if v["挂接零件"] then
                v["挂接零件"].Transparency = 1
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

