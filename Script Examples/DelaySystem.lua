--code created by one of our user submission!
--creates a part that gradually shifts a Part's transparency
--location: Part

--create a time tracking variable
local timeScale = 0

--function update checks timeScale variable and executes expression
local function update(delay) --delay is the tick speed, automatically passed in by GameRun.Update
    local part = script.Parent 
    --adds delay to time
    timeScale = timeScale + delay
    --check timeScale
    if timeScale <= 2 then
        part.Transparency = 1.0
    elseif timeScale <= 3 then
        part.Transparency = part.Transparency - delay --gradually changing transparency based in delay tick speed
    elseif timeScale <= 6 then
        part.Transparency = 0.0
    elseif timeScale <= 7 then
        part.Transparency = part.Transparency + delay
    else
        --reset timeScale
        timeScale = 0
    end
end

--continuously update the update function
GameRun.Update:Connect(update)