hook.Add("PlayerButtonDown", "PIS.RegisterInput", function(ply, btn)
	local settings = PIS:GetSettings(ply)

	if (btn == settings.InteractionKey or btn == settings.WheelKey and !IsValid(PIS.RadialMenu)) then
		PIS:HandleInput(btn)
	end
end)

function PIS:RemovePing(id)
	self.Pings[id] = nil
end

function PIS:HandleInput(btn)
	local lookingAt = self:IsLookingAtPing()
	local settings = PIS:GetSettings(LocalPlayer())
	local ply = LocalPlayer()
	if (lookingAt) then
		local ping = self.Pings[lookingAt.key]
		local pingTbl = self.Config.Pings[ping.ping]

		if (btn == settings.InteractionKey) then
			if (ping.directedAt == ply and ping.status == PING_STATUS_DEFAULT) then
				ping.status = PING_STATUS_CONFIRMED

				net.Start("PIS.ReactPing")
					net.WriteTable({
						id = lookingAt.key,
						command = PING_COMMAND_CONFIRM
					})
				net.SendToServer()
			elseif (ping.author == ply) then
				PIS:RemovePing(lookingAt.key)

				net.Start("PIS.RemovePing")
				net.SendToServer()
			end
		end
	end
end