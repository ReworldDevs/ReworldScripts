local MapClient = {}
MapClient.MapTable = {}
MapClient.StartPos = Vector3(0, 0, 0)
function MapClient.InitMap()
	MapClient.InitMapData()
	MapClient.InitMapPart()
end
function MapClient.InitMapData()
	MapClient.MapTable = {
		{x = 5, z = 14}, 
		{x = 5, z = 3}, 
		{x = 5, z = 6}, 
		{x = 8, z = 3}, 
		{x = 5, z = 10}, 
		{x = 7, z = 4},
		{x = 5, z = 8},
		{x = 7, z = 4},
	}
end
function MapClient.InitMapPart()
	MapClient.StartPos = Vector3(MapClient.MapTable[1].x / 2, 0, 0)
	local endZ = 0
	for k, v in pairs(MapClient.MapTable) do
		local part = WorkSpace.地图.标准块:Clone()
		part.Scale = Vector3(v.x, 0, v.z)
		if k % 2 == 1 then
			part.Position = Vector3(MapClient.StartPos.x - v.x / 2, 0, MapClient.StartPos.z + v.z / 2)
			MapClient.StartPos = MapClient.StartPos + Vector3(0, 0, v.z)
		else
			part.Position = Vector3(MapClient.StartPos.x + v.x / 2, 0, MapClient.StartPos.z - v.z / 2)
			MapClient.StartPos = MapClient.StartPos + Vector3(v.x, 0, 0)
		end
		endZ = v.z
	end
	local endPart = WorkSpace.地图.终点
	
	local vectorDis = WorkSpace.地图.终点补长.Position - endPart.Position
	local posEnd = Vector3(MapClient.StartPos.x + endPart.Scale.x / 2, 0, MapClient.StartPos.z - endZ / 2)
	endPart.Position = posEnd
	endPart.Scale = Vector3(endPart.Scale.x, 0, endPart.Scale.z)
	WorkSpace.地图.终点补长.Position = posEnd + vectorDis
	WorkSpace.地图.终点补长.Scale = Vector3(WorkSpace.地图.终点补长.Scale.x, 0, WorkSpace.地图.终点补长.Scale.z)
end
MapClient.InitMap()