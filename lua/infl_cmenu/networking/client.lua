net.Receive("PIS.PlacePing", function(len)
	local tbl = net.ReadTable()

	if (PIS:IsMuted(LocalPlayer(), tbl.author)) then return end

	PIS:AddPing(tbl.author, tbl.id, tbl.pos, tbl.directedAt)
end)

net.Receive("PIS.RemovePing", function(len)
	PIS:RemovePing(net.ReadEntity())
end)

net.Receive("PIS.ReactPing", function(len)
	local tbl = net.ReadTable()
	local ping = PIS:GetPing(tbl.id)

	if (!ping) then return end

	if (tbl.command == PING_COMMAND_CONFIRM) then
		ping.status = PING_STATUS_CONFIRMED
	end
end)

