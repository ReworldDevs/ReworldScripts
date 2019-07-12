local btn = script.Parent
local eventDown = WorkSpace.汽车.按下漂移
local eventUp = WorkSpace.汽车.抬起漂移
local function BtnDown()
	eventDown:FireServer()
end
local function BtnUp()
	eventUp:FireServer()
end
btn.OnPointerDown:Connect(BtnDown)
--btn.OnPointerExit:Connect(BtnUp)
btn.OnPointerUp:Connect(BtnUp)