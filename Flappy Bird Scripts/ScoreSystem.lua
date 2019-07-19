--Score track and display system script
--location: ServerLogic

local score = 0
local go = false
local walls = WorkSpace.Walls:GetAllChild()
local scoreList = {} --keeps track of scores, used to display high score
local wallCounter = 1 --counter var for walls table

--response function for "start" server event
--displays Counter UiPanel
function start(Uid)
	go = true
	local player = Players:GetPlayerByUserId(Uid)
	local counter = player:GetChildByName("Counter",true)
	counter.IsVisable = true
	score = 0 --resets score for each round
	wallCounter = 1 --resets counter for each round
end

--response function for "end" server event
--hides Counter UiPanel
--sorts updates and sorts scoreList
--updates score and high score UiText
--displays Endgame UiPanel
function endFunct(Uid)
	local player = Players:GetPlayerByUserId(Uid)
	local endgame = player:GetChildByName("Endgame",true)
	local counter = player:GetChildByName("Counter",true)
	counter.IsVisable = false
	table.insert(scoreList, score)
	table.sort(scoreList)
	endgame.ScoreUI.Text = "Score: "..score
	endgame.HighScore.Text = "High Score: "..scoreList[#scoreList]
	--wait(1)
	endgame.IsVisable = true
end

--response function for "addOne" server event
--updates Counter UiPanel for new score
function updateScore(Uid,localscore)
	local player = Players:GetPlayerByUserId(Uid)
	local counter = player:GetChildByName("Counter",true)
	counter.Score.Text = tostring(localscore)
end

MessageEvent.ServerEventCallBack("start"):Connect(start)
MessageEvent.ServerEventCallBack("end"):Connect(endFunct)
MessageEvent.ServerEventCallBack("addOne"):Connect(updateScore)

--fires "addOne" server event for each wall passed
function scoreRun()
	if walls[wallCounter].Position.x <-1.5 then
		score=score+1
		MessageEvent.FireServer("addOne",score)
		wallCounter=wallCounter+1
	end
	if wallCounter>#walls then wallCounter=1 end
end

GameRun.Update:Connect(scoreRun)
