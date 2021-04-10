util.AddNetworkString("PIS.PlacePing")
util.AddNetworkString("PIS.RemovePing")
util.AddNetworkString("PIS.ReactPing")

net.Receive("PIS.PlacePing", function(len, ply)
	if (!PIS.Gamemode:GetPingCondition()(ply)) then return end

	local tbl = net.ReadTable()
	local id = tbl.id
	local pos = tbl.pos
	local directedAt = tbl.directedAt

	if (IsValid(tbl.directedAt)) then
		if (!PIS.Gamemode:GetCommandCondition()(ply, tbl.directedAt)) then return end
	end

	PIS:AddPing(ply, id, pos, directedAt)

	net.Start("PIS.PlacePing")
		net.WriteTable({
			author = ply,
			id = id,
			pos = pos,
			directedAt = directedAt
		})
	net.Send(PIS.Gamemode:GetPlayers()(ply))
end)

net.Receive("PIS.RemovePing", function(len, ply)
	if (!PIS.Gamemode:GetPingCondition()(ply)) then return end

	local ping = PIS:GetPing(ply)

	if (ping) then
		PIS:RemovePing(ply)

		net.Start("PIS.RemovePing")
			net.WriteEntity(ply)
		
		net.Broadcast()
	end
end)

net.Receive("PIS.ReactPing", function(len, ply)
	if (!PIS.Gamemode:GetInteractionCondition()(ply)) then return end

	local command = net.ReadUInt(8)
	local ping = PIS:GetPing(pingId)

	if (ping) then
		local command = tbl.command
		if (!command) then return end

		if (command == PING_COMMAND_CONFIRM and ping.directedAt == ply) then
			ping.status = PING_STATUS_CONFIRMED

			net.Start("PIS.ReactPing")
				net.WriteTable({
					id = ply:SteamID64(),
					command = command
				})
			net.Send(PIS.Gamemode:GetPlayers()(ply))
		end
	end
end)