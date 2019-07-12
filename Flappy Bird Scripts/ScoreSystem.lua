--Score track and display system script
--location: ServerLogic

local score = 0
local go = false
local walls = WorkSpace.Walls:GetAllChild()
local scoreList = {} --keeps track of scores, used to display high score
local c = 1 --counter var for walls table
local UpdateEvent = ServerLogic.UE

--response function for "start" server event
--displays Counter UiPanel
function start(Uid)
	go = true
	local player = Players:GetPlayerByUserId(Uid)
	local n = player:GetChildByName("Counter",true)
	n.IsVisable = true
	score = 0 --resets score for each round
	c = 1 --resets counter for each round
end

--response function for "end" server event
--hides Counter UiPanel
--sorts updates and sorts scoreList
--updates score and high score UiText
--displays Endgame UiPanel
function endFunct(Uid)
	local player = Players:GetPlayerByUserId(Uid)
	local ui = player:GetChildByName("Endgame",true)
	local n = player:GetChildByName("Counter",true)
	n.IsVisable = false
	--scoreList[#scoreList+1] = score
	table.insert(scoreList, score)
	table.sort(scoreList)
	ui.ScoreUI.Text = "Score: "..score
	ui.HighScore.Text = "High Score: "..scoreList[#scoreList]
	--wait(1)
	ui.IsVisable = true
end

--response function for "addOne" server event
--updates Counter UiPanel for new score
function updateScore(Uid,localscore)
	local player = Players:GetPlayerByUserId(Uid)
	local count = player:GetChildByName("Counter",true)
	count.Score.Text = tostring(localscore)
end

MessageEvent.ServerEventCallBack("start"):Connect(start)
MessageEvent.ServerEventCallBack("end"):Connect(endFunct)
MessageEvent.ServerEventCallBack("addOne"):Connect(updateScore)

--fires "addOne" server event for each wall passed
function scoreRun()
	if go then
		if walls[c].Position.x <-1.5 then
			score=score+1
			MessageEvent.FireServer("addOne",score)
			c=c+1
		end
		if c>#walls then c=1 end
	end
end

UpdateEvent.Update:Connect(scoreRun)
