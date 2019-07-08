--LuaScript template for accessing avatar properties
--location: ServerLogic

wait(1) --wait for the avatar to be loaded in game

local avatar = WorkSpace:GetChildByClassName("Avatar") --get the Avatar, a child of WorkSpace 
--note: avatars are deleted and replaced upon player death. get the avatar again after death to avoid bugs

--examples of some avatar properties that can be modifies
avatar.MoveSpeed = 0
avatar.JumpSpeed = 0
avatar.Health = 0
