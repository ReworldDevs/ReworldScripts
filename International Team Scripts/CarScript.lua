local CarControl = {}
local UpdateEvent = script.Parent.刷新
local CarSpeed = 0
local CarSpeedDown    = 0
local CarSpeedMax = 8
local CarAddSpeed = 12
local CarRemoveSpeed = 10
local DeltaGameStartTime = 2
local GameStatus = "Wait"
local DownEvent = script.Parent.按下漂移
local UpEvent = script.Parent.抬起漂移
local FinishEvent = WorkSpace.地图.终点.完成
local carRotationY = 0
local carRotationYSpeed = 90 * 3.5

local blnDown = false
function CarControl.Init()
	script.Parent.Velocity = Vector3(0, 0, 0)
	UpdateEvent.Update:Connect(CarControl.Update)
	GameRun.FixedUpdate:Connect(CarControl.FixedUpdate)
	DownEvent.ServerEventCallBack:Connect(CarControl.DownEvent)
	UpEvent.ServerEventCallBack:Connect(CarControl.UpEvent)
	FinishEvent.ServerEventCallBack:Connect(CarControl.FinishEvent)
end
function CarControl.FinishEvent()
	GameStatus = "Finish"
end
function CarControl.DownEvent()
	blnDown = true
	print("按下漂移")
end
function CarControl.UpEvent()
	blnDown = false
	print("抬起漂移")
end
function CarControl.FixedUpdate(delta)
	if GameStatus == "Run" then
		CarControl.RunFixedUpdate(delta)
	elseif GameStatus == "Finish" then
		CarControl.FinishFixedUpdate(delta)
	end

end
function CarControl.RunFixedUpdate(delta)
	--汽车转向
	if blnDown then
		if carRotationY < 90 then
			carRotationY = carRotationY + carRotationYSpeed * delta
		end
		if carRotationY >= 90 then
			carRotationY  = 90
		end
		script.Parent.WorldRotation = Vector3(0, carRotationY, 0)
		script.Parent.特殊模型.Rotation = Vector3(0, carRotationY, 0)
	else
		if carRotationY > 0 then
			carRotationY = carRotationY - carRotationYSpeed * delta
		end
		if carRotationY <= 0 then
			carRotationY  = 0
		end
		script.Parent.WorldRotation = Vector3(0, carRotationY, 0)
		script.Parent.特殊模型.Rotation = Vector3(0, carRotationY, 0)
	end
	--按下
	if blnDown then
		CarSpeedDown = CarSpeedDown + CarAddSpeed * delta
		if CarSpeedDown >= CarSpeedMax then
			CarSpeedDown = CarSpeedMax
		end
		
		CarSpeed = CarSpeed - CarRemoveSpeed * delta
		if CarSpeed <= 0 then
			CarSpeed = 0
		end
		script.Parent.Velocity = Vector3(CarSpeedDown, script.Parent.Velocity.y, CarSpeed)
	else
		CarSpeed = CarSpeed + CarAddSpeed * delta
		if CarSpeed >= CarSpeedMax then
			CarSpeed = CarSpeedMax
		end
		CarSpeedDown = CarSpeedDown - CarRemoveSpeed * delta
		if CarSpeedDown <= 0 then
			CarSpeedDown = 0
		end
		script.Parent.Velocity = Vector3(CarSpeedDown, script.Parent.Velocity.y, CarSpeed)
	end
	
end
function CarControl.FinishFixedUpdate(delta)
	CarSpeed = CarSpeed - CarRemoveSpeed * delta
	if CarSpeed <= 0 then
		CarSpeed = 0
	end
	CarSpeedDown = CarSpeedDown - CarRemoveSpeed * delta
	if CarSpeedDown <= 0 then
		CarSpeedDown = 0
	end
	script.Parent.Velocity = Vector3(CarSpeedDown, script.Parent.Velocity.y, CarSpeed)
	if carRotationY < 270 then
		carRotationY = carRotationY + carRotationYSpeed * delta
	end
	if carRotationY >= 270 then
		carRotationY  = 270
	end
	script.Parent.WorldRotation = Vector3(0, carRotationY, 0)
	script.Parent.特殊模型.Rotation = Vector3(0, carRotationY, 0)
end
function CarControl.Update(delta)
	--游戏开始倒计时
	if DeltaGameStartTime > 0 then
		DeltaGameStartTime = DeltaGameStartTime - delta
		if DeltaGameStartTime <= 0 then
			GameStatus = "Run"
		end
	end

end
CarControl.Init()