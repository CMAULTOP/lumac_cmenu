local framework = Nexus:ClassManager("Framework")
local _draw = framework:Class("Draw")
local anim = framework:Class("Animations")
local panels = framework:Class("Panels")

surface.CreateFont("Nexus.PingSystem.3D.Type", {
	font = "Montserrat",
	size = 24,
	weight = 800
})

surface.CreateFont("Nexus.PingSystem.3D.Cancel", {
	font = "Montserrat",
	size = 24,
	weight = 500
})

surface.CreateFont("Nexus.PingSystem.3D.CancelButton", {
	font = "Montserrat",
	size = 20,
	weight = 1200
})


surface.CreateFont("Nexus.PingSystem.3D.Dist", {
	font = "Montserrat",
	size = 20,
	weight = 500
})

function PIS:Render2D()
	local ply = LocalPlayer()
	local plyPos = ply:GetPos()

	local lookingAt = self:IsLookingAtPing()
	if (lookingAt) then
		local settings = PIS:GetSettings(ply)
		local ping = self.Pings[lookingAt.key]
		if (!IsValid(ping.author)) then
			PIS:RemovePing(lookingAt.key)
		end
		local pingTbl = self.Config.Pings[ping.ping]
		local tr = ply:GetEyeTrace()
		local hitPos = tr.HitPos
		hitPos = LocalToWorld(Vector(0, -50, -15), Angle(0, 0, 0), hitPos, ply:GetAngles())
		local sPos = ping.pos:ToScreen()
		local x = ScrW() / 2 + 75--100
		local y = ScrH() / 2 - 75--100
		local sX = sPos.x
		local sY = sPos.y

		local dist = plyPos:Distance(ping.pos)
		local distY = math.Clamp(dist * 0.5 >= 525 and dist * 0.5 - 525 or 0, 0, dist * 0.3)
		local scale = math.max(dist / 250, 1)
		local matSize = 128 * scale
		local matX = (matSize * -1) / 2
		local matY = -10 + matSize * -1
		matY =	math.abs(matY - (distY * math.Clamp(scale * 0.4, 0, 1.5)))
		local distModifier = ((ply:GetFOV() * 2) / dist)
		local matYOffset = matSize * 0.1 * distModifier + matY * 0.1 * distModifier
		draw.NoTexture()
		surface.SetDrawColor(color_black)
		local tbl = {
			{ x = sX, y = sY - matYOffset },
			{ x = sX + 50, y = sY - matYOffset - 50 },
			{ x = sX + 50, y = sY - matYOffset }
		}
		--surface.DrawPoly(tbl)
		--surface.DrawRect(sX, sY, 20, 20)

		surface.SetFont("Nexus.PingSystem.3D.Type")
		local tw, th = surface.GetTextSize(ping.directedAt and pingTbl.command .. " " or pingTbl.text)
		local dist = math.Round(plyPos:Distance(ping.pos) * (0.0254 / (4/3))) .. "m"
		surface.SetFont("Nexus.PingSystem.3D.Type")
		local _tw = surface.GetTextSize(dist)
		local height = 2
		local width = 10 + tw + _tw
		surface.SetFont("Nexus.PingSystem.3D.Cancel")
		local isLocalPlayer = LocalPlayer() == ping.author
		local cancelStr = isLocalPlayer and "CANCEL" or ping.author:Nick()
		local tw, th = surface.GetTextSize(cancelStr)
		local topWidth = 10 + tw + 5
		if (isLocalPlayer) then
			local _tw, th = surface.GetTextSize(PIS:GetKeyName(settings.InteractionKey))
			topWidth = topWidth + _tw + 10
		end
		local status = ping.status
		local str = status == PING_STATUS_CONFIRMED and "Confirmed" or "Confirm - " .. PIS:GetKeyName(settings.InteractionKey)

		surface.SetFont("Nexus.PingSystem.3D.Type")
		if (ping.directedAt == LocalPlayer()) then
			local str = status == PING_STATUS_CONFIRMED and "Confirmed" or "Confirm - " .. PIS:GetKeyName(settings.InteractionKey)
			local _tw, th = surface.GetTextSize(str)

			topWidth = topWidth + _tw + (isLocalPlayer and -10 or 10)
		elseif (ping.directedAt) then
			local str = status == PING_STATUS_CONFIRMED and "Confirmed" or "Unconfirmed"
			local _tw, th = surface.GetTextSize(str)

			topWidth = topWidth + _tw + (isLocalPlayer and -10 or 10)
		end
		width = math.max(topWidth, width)
		local lineX = x

		surface.SetFont("Nexus.PingSystem.3D.Type")
		
		local commandStr = (ping.directedAt and pingTbl.command .. " " or pingTbl.text)
		local tw, th = surface.GetTextSize(commandStr)
		_draw:Call("ShadowText", commandStr, "Nexus.PingSystem.3D.Type", x, y + 4, pingTbl.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		if (ping.directedAt) then
			local _tw = surface.GetTextSize(ping.directedAt:Nick())
			local col = ping.status == PING_STATUS_DEFAULT and Color(215, 215, 215)
				or ping.status == PING_STATUS_CONFIRMED and PIS.Config.Colors.Green
				or ping.status == PING_STATUS_REJECTED and PIS.Config.Colors.Red
			_draw:Call("ShadowText", ping.directedAt:Nick(), "Nexus.PingSystem.3D.Type", x + tw, y + 4, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			tw = tw + _tw
		end
		_draw:Call("ShadowText", dist, "Nexus.PingSystem.3D.Dist", x + tw + 5, y + 4 + 2, pingTbl.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		surface.SetFont("Nexus.PingSystem.3D.Cancel")
		local _tw = surface.GetTextSize(cancelStr)
		_draw:Call("ShadowText", cancelStr, "Nexus.PingSystem.3D.Cancel", x, y - 4, Color(215, 215, 215), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		if (!isLocalPlayer) then
			x = x + _tw + 5
		end

		surface.SetFont("Nexus.PingSystem.3D.Type")
		local tw, th = surface.GetTextSize(cancelStr)
		local _tw, _th = surface.GetTextSize(PIS:GetKeyName(settings.InteractionKey))
		local __tw, __th = surface.GetTextSize(cancelStr)
	
		if (isLocalPlayer) then
			x = x + tw + 5
			draw.RoundedBox(6, x, math.ceil(y - 4 - th), _tw + 8, th, Color(215, 215, 215))
			draw.SimpleText(PIS:GetKeyName(settings.InteractionKey), "Nexus.PingSystem.3D.CancelButton", x + _tw / 2 + 4, y - th / 2 - 4, Color(62, 62, 62), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			x = x + _tw + 8 + 5
		end

		if (ping.directedAt == LocalPlayer()) then
			local status = ping.status
			local str = status == PING_STATUS_CONFIRMED and "Confirmed" or "Confirm - " .. PIS:GetKeyName(settings.InteractionKey)
			local col = status == PING_STATUS_CONFIRMED and PIS.Config.Colors.Green or Color(183, 183, 183)
			local textCol = color_black

			local _tw, th = surface.GetTextSize(str)

			draw.RoundedBox(6, x, math.ceil(y - 4 - __th), _tw + 8, __th, col)
			draw.SimpleText(str, "Nexus.PingSystem.3D.CancelButton", x + _tw / 2 + 4, y - __th / 2 - 4, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			x = x + _tw + 5
		elseif (ping.directedAt) then
			local status = ping.status
			local str = status == PING_STATUS_CONFIRMED and "Confirmed" or "Unconfirmed"
			local col = status == PING_STATUS_CONFIRMED and PIS.Config.Colors.Green or PIS.Config.Colors.Red
			local textCol = status == PING_STATUS_CONFIRMED and Color(222, 222, 222) or color_black

			local _tw, th = surface.GetTextSize(str)

			draw.RoundedBox(6, x, math.ceil(y - 4 - __th), _tw + 8, __th, col)
			draw.SimpleText(str, "Nexus.PingSystem.3D.CancelButton", x + _tw / 2 + 4, y - __th / 2 - 4, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			x = x + _tw + 5
		end

		draw.RoundedBox(0, lineX - 5, y, width, height, pingTbl.color)
	end
end

hook.Add("HUDPaint", "PIS.RenderPings", function()
	PIS:Render2D()
end)

hook.Add("PostDrawHUD", "PIS.RenderOffscreenPings", function()
	local settings = PIS:GetSettings(LocalPlayer())
	if (settings.PingOffscreen == 3) then return end

	for i, v in pairs(PIS.Pings) do
		local ping = PIS.Config.Pings[v.ping]
		if (!ping) then continue end
		if (settings.PingOffscreen == 2 and v.directedAt != LocalPlayer()) then continue end
		local mat = PIS:GetPingIcon(v.ping)
		local col = ping.color
		local pos = v.pos
		local sPos = pos:ToScreen()
		local x = sPos.x
		local y = sPos.y

		local size = 64

		local drawPing

		if (x < -50) then
			drawPing = true
		elseif (y < -20) then
			drawPing = true
		elseif (y > ScrH() + 80) then
			drawPing = true
		elseif (x > ScrW() + 50) then
			drawPing = true
		end

		if (!drawPing) then continue end

		local x = math.Clamp(x - size / 2, 16, ScrW() - 16 - size)
		local y = math.Clamp(y, 16, ScrH() - size - 16)

		_draw:Call("BlurHUD", x - 2, y - 2, size + 2, size)

		surface.SetMaterial(mat)
		surface.SetDrawColor(0, 0, 0, 255)
		for i = 1, 3 do
			surface.DrawTexturedRect(x - 1, y - 1, size + 2, size + 2)
		end
		surface.SetDrawColor(col)
		surface.DrawTexturedRect(x, y, size, size)
	end
end)