--Modified default OperationControl script
--location: StarterPlayers.StarterPlayerScripts.PlayerOperationScript
--note: see comments for modifications

--?????,????????????????????
HandleControl = {}

--??????????????
HandleControl.JumpEnable = false  
HandleControl.LastInput = Vector3.zero
function HandleControl.ProcessGestureDrag(touch)
    if WorkSpace.CurCamera == nil then
        return
    end
    local player = Players:GetLocalPlayer()
    if player == nil or player.Avatar == nil then
		CameraControl.ProcessTurn(touch.x, touch.y * -1);
        return
    end 
    local handleType = player.ControlType
    local Pitch = WorkSpace.CurCamera.Pitch
    --?????????
    CameraControl.ProcessTurn(touch.x, touch.y * -1);

    --??fps ??????????? ??????
    if WorkSpace.CurCamera.Distance <= 0.5 and player.Avatar:GetCurrentEquip() then 
        player.Avatar:RotationSkeleton("Spine", -WorkSpace.CurCamera.Pitch)
    end

    if HandleControl.LastInput ~= Vector3.zero then
        HandleControl.PlayerMove(HandleControl.LastInput)
    end
end
function HandleControl.ProcessGestureZoom(value)
    CameraControl.ProcessZoom(value)
end
function HandleControl.ProcessJump()
    local player = Players:GetLocalPlayer()
    if player == nil then
        return
    end
    if player.Avatar == nil then
        return
    end
    player.Avatar:Jump()
end
function HandleControl.Main()


    --??????????
    local JumpBtn = GameUI["Leap"]["Leap"]
    JumpBtn.OnPointerDown:Connect(HandleControl.OnJumpPointerDown)
    JumpBtn.OnPointerExit:Connect(HandleControl.OnJumpPointerExit)
    JumpBtn.OnPointerUp:Connect(HandleControl.OnJumpPointerExit)

    --todo ????inputservice??
    --MessageEvent.ClientEventCallBack("JoyStickCOntroller_Event"):Connect(HandleControl.MoveCallBack)
    --MessageEvent.ClientEventCallBack("EventDrag"):Connect(HandleControl.ProcessGestureDrag)
    --MessageEvent.ClientEventCallBack("EventZoom"):Connect(HandleControl.ProcessGestureZoom)
    --MessageEvent.ClientEventCallBack("EventJump"):Connect(HandleControl.ProcessJump)
end
function HandleControl.MoveCallBack(input)
    HandleControl.LastInput = input
    HandleControl.PlayerMove(input);
end
function HandleControl.PlayerMove(input)

    if WorkSpace.CurCamera == nil then
        return
    end
    local player = Players:GetLocalPlayer()
    if player == nil or player.Avatar == nil then
        return
    end

    local blnAutoTurn = false
    if player.ControlType == HandleMode.TheFirstPerson then
        blnAutoTurn =  false
    else
        if WorkSpace.CurCamera.Distance <= 0.5  then
            blnAutoTurn = false
        else
            blnAutoTurn = true
        end
    end
    local Dir = Quaternion.Euler(0, WorkSpace.CurCamera.Rotation.y, WorkSpace.CurCamera.Rotation.z)  * input;
	player.Avatar:Move(Vector2(Dir.x, Dir.z), blnAutoTurn, Vector2(input.x, input.z));
end
function HandleControl.OnJumpPointerDown()
    HandleControl.JumpEnable = true
    coroutine.start(HandleControl.coroutineUpdate)
end
function HandleControl.OnJumpPointerExit()
    HandleControl.JumpEnable = false
    coroutine.stop(HandleControl.coroutineUpdate)
end
function HandleControl.coroutineUpdate()
    while HandleControl.JumpEnable do
        coroutine.wait(0.1)
        HandleControl.ProcessJump()
    end
end
HandleControl.Main()