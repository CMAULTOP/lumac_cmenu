function PIS:PingIsInBox(pos, pingX, pingY)
	local centerX = ScrW() / 2
	local centerY = ScrH() / 2
	local ySize = 45
	local xSize = 45

	local ply = LocalPlayer()
	local dist =	ply:GetPos():Distance(pos)
	local distModifier = math.Clamp((6000 - dist) / 6000, 0.6, 1)
	local scale = distModifier
	if (dist < 200) then
		scale = math.Clamp(200 / dist, 1, 2.5)
	end

	ySize = ySize * scale
	xSize = xSize * scale

	xSize = xSize * PIS:GetSettings(ply).DetectionScale
	ySize = ySize * PIS:GetSettings(ply).DetectionScale

	local leftX = centerX - xSize
	local leftY = centerY - ySize
	local rightX = centerX + xSize
	local rightY = centerY + ySize

	--draw.RoundedBox(6, leftX, leftY, xSize * 2, ySize * 2, Color(0, 0, 0, 150))

	if (pingX >= leftX and pingY >= leftY and pingX <= rightX and pingY <= rightY) then
		return PIS:Get2DDistance(Vector(centerX, centerY), Vector(pingX, pingY))
	end

	return false
end

function PIS:IsLookingAtPing()
	local ply = LocalPlayer()
	local pos = ply:GetPos()
	local lookPos = ply:GetEyeTrace().HitPos 
	local lookAimVector = ply:GetAimVector()
	local tbl = {}

	for i, v in pairs(self.Pings) do
		local sPos = v.pos:ToScreen()
		local x = sPos.x
		local y = sPos.y
		local dist = self:PingIsInBox(v.pos, x, y)
		if (!dist) then continue end

		table.insert(tbl, { dist = dist, key = i })
	end

	table.sort(tbl, function(a, b)
		return b.dist > a.dist
	end)
	
	return tbl[1]
end

gameevent.Listen("player_connect")
hook.Add("player_connect", "PIS.RemovePings", function(data)
	local sid64 = util.SteamIDTo64(data.networkid)

	if (PIS:GetPing(sid64)) then
		PIS:RemovePing(sid64)
	end
end)