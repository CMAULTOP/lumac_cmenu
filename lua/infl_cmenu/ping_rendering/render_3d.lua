local recFilled = Material("ping_system/rec_fill.png", "smooth")
local gradientDown = Material("vgui/gradient_down")

local framework = Nexus:ClassManager("Framework")
local _draw = framework:Class("Draw")

-- Missing texture, so why not go with it?
local loadingMaterial = Material("vgui/error.png")

function PIS:Render3D()
	local ply = LocalPlayer()
	local settings = PIS:GetSettings(ply)
	local pos = ply:GetPos()
	local ang = ply:EyeAngles()
	--local lookPos = ply:EyePos()
	--local lookAimVector = ply:GetAimVector()
	
	for i, v in pairs(self.Pings) do
		local ping = self.Config.Pings[v.ping]
		if (!ping) then continue end
		if (!IsValid(v.author)) then
			PIS:RemovePing(i)

			continue
		end
		if (v.directedAt and !IsValid(v.directedAt)) then
			PIS:RemovePing(i)

			continue
		end

		local mat = PIS:GetPingIcon(v.ping)
		local col = ping.color

		--local intersect = v.pos - lookPos
		--local normalized = intersect:GetNormalized()
		--local dotProduct = normalized:Dot(lookAimVector)

		local pingPos = v.pos
		-- Get angle between the two positions
		local diffAng = (pos - pingPos):GetNormalized():Angle()
		local pingAng = Angle(0, 0, 0)

		-- Rotate axises
		pingAng:RotateAroundAxis(pingAng:Forward(), 90)
		pingAng:RotateAroundAxis(pingAng:Right(), 90 - ang.y)
		pingAng:RotateAroundAxis(pingAng:Forward(), -ang.x)

		--if (dotProduct < dotProductNeed) then
		--	mat = recFilled
		--end

		cam.Start3D2D(pingPos, pingAng, 0.1)
			cam.IgnoreZ(true)

			local dist = pos:Distance(pingPos)
			local distY = math.Clamp(dist * 0.5 >= 525 and dist * 0.5 - 525 or 0, 0, dist * 0.3)
			local scale = math.max(dist / 250, 1)
			local matSize = 128 * scale
			matSize = matSize * settings.Scale or 1

			local x = (matSize * -1) / 2
			local y = -10 + matSize * -1
			y = y - (distY * math.Clamp(scale * 0.4, 1, 1.5))

			v.PingStartAnimationEnd = v.PingStartAnimationEnd or CurTime() + 0.4

			surface.SetMaterial(mat)
			if (CurTime() < v.PingStartAnimationEnd) then
				local frac = math.TimeFraction(v.PingStartAnimationEnd - 0.4, v.PingStartAnimationEnd, CurTime())

				local startSize = matSize * 0.6
				local endSize = matSize * 2
				local alpha = 255 - (frac * 255)
				local size = Lerp(frac, startSize, endSize)

				local y = -10 - size / 2 - matSize / 2 - (distY * math.Clamp(scale * 0.4, 1, 1.5))
				surface.SetDrawColor(ColorAlpha(col, alpha))
				surface.DrawTexturedRect((size * -1) / 2, y, size, size)
			elseif (settings.PingPulsating == 1 or v.dontDrawIcon or (!v.dontDrawIcon and v.directedAt == ply and v.status == PING_STATUS_DEFAULT)) then
				if (settings.PingPulsating != 3) then
					v.PingScatterAnimation = v.PingScatterAnimation or CurTime() + 1

					-- Radiate
					local frac = math.TimeFraction(v.PingScatterAnimation - 1, v.PingScatterAnimation, CurTime())
					local startSize = matSize * 0.6
					local endSize = v.directedAt == ply and matSize * 2 or matSize * 1.8
					local alpha = 255 - (frac * 255)
					local size = Lerp(frac, startSize, endSize)

					local y = -10 - size / 2 - matSize / 2 - (distY * math.Clamp(scale * 0.4, 1, 1.5))
					surface.SetDrawColor(ColorAlpha(col, alpha))
					surface.DrawTexturedRect((size * -1) / 2, y, size, size)

					if (frac >= 0.99) then
						v.PingScatterAnimation = nil
						frac = 0
					end
				end
			end

			surface.SetMaterial(mat)
			surface.SetDrawColor(color_black)
			surface.DrawTexturedRect(x - 4 * scale, y - 4 * scale, matSize + 8 * scale, matSize + 8 * scale)
			surface.DrawTexturedRect(x + 4 * scale, y + 4 * scale, matSize - 8 * scale, matSize - 8 * scale)
			surface.SetDrawColor(col)
			surface.DrawTexturedRect(x, y, matSize, matSize)
	
			-- Draw icon above lul
			if (v.directedAt) then
				--local icon = v.status == PING_STATUS_DEFAULT and questionMark
				--	or v.status == PING_STATUS_CONFIRMED and confirmed
				--	or v.status == PING_STATUS_REJECTED and rejected
				local col = v.status == PING_STATUS_DEFAULT and Color(215, 215, 215)
					or v.status == PING_STATUS_CONFIRMED and PIS.Config.Colors.Green
					or v.status == PING_STATUS_REJECTED and PIS.Config.Colors.Red
				local size = matSize * 0.15
				local vertices = 4
				local playerIcon = PIS.Avatars[v.directedAt:IsBot() and "BOT" or v.directedAt:SteamID64()] or loadingMaterial
				local width = size * 2

				if (settings.PingOverhead == 1) then
					_draw:Call("Circle", x + width * 2 - size / 2 - matSize * 0.02, y - width * 0.75 - matSize * 0.04, size * 1.18, settings.PingAvatarVertices or 30, color_black)
					_draw:Call("Circle", x + width * 2 - size / 2 - matSize * 0.02, y - width * 0.75 - matSize * 0.04, size * 1.1, settings.PingAvatarVertices or 30, col)
					_draw:Call("MaskInclude", function()
						_draw:Call("Circle", x + width * 2 - size / 2 - matSize * 0.02, y - width * 0.75 - matSize * 0.04, size * 0.9, settings.PingAvatarVertices or 30, col)
					end, function()
						surface.SetMaterial(playerIcon)
						surface.SetDrawColor(255, 255, 255)
						surface.DrawTexturedRect(x + matSize / 2 - size, y - width * 0.75 - size - matSize * 0.05, width, width)
					end)
				else
					size = matSize * 0.2
					width = size * 2
					surface.SetMaterial(recFilled)
					surface.SetDrawColor(color_black)
					surface.DrawTexturedRect(x + matSize / 2 - size, y - width * 0.75 - size - matSize * 0.05, width, width)
					surface.SetDrawColor(col)
					width = width * 0.88
					surface.DrawTexturedRect(x + matSize / 2 - size + -1 + 4, y - width * 0.75 - size - matSize * 0.05 - 2, width, width)
				end
			end

			local gY = y + matSize + 12.5 * scale
			local gW = 12.5 * scale
			local gX = x - gW / 2 + matSize / 2
			local gH = distY * math.Clamp(scale * 0.4, 1, 1.5)

			_draw:Call("MaskInclude", function()
				draw.NoTexture()
				surface.DrawPoly({
					{ x = gX - 2 * scale, y = gY - 2 * scale },
					{ x = gX + gW + 2 * scale, y = gY - 2 * scale },
					{ x = gX + gW / 2, y = gY + gH + 2 * scale }
				})
			end, function()
				surface.SetMaterial(gradientDown)
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawTexturedRect(gX - 2 * scale, gY - 2 * scale, gW + 4 * scale, gH + 4 * scale)
			end)

			_draw:Call("MaskInclude", function()
				draw.NoTexture()
				surface.DrawPoly({
					{ x = gX, y = gY },
					{ x = gX + gW, y = gY },
					{ x = gX + gW / 2, y = gY + gH }
				})
			end, function()
				surface.SetMaterial(gradientDown)
				surface.SetDrawColor(col)
				surface.DrawTexturedRect(gX, gY, gW, gH)
			end)


			cam.IgnoreZ(false)
		cam.End3D2D()
	end

	/*
	local lookingAt = self:IsLookingAtPing()
	if (lookingAt) then
		local ping = self.Pings[lookingAt.key]
		local dist = pos:Distance(ping.pos)
		local distY = math.Clamp(dist * 0.5 >= 525 and dist * 0.5 - 525 or 0, 0, dist * 0.3)
		local scale = math.max(dist / 250, 1)
		local matSize = 128 * scale
		matSize = matSize * settings.Scale
		local x = (matSize * -1) / 2
		local y = -10 + matSize * -1
		y = y - (distY * math.Clamp(scale * 0.4, 1, 1.5))
		x = x + matSize
		y = y - matSize

		local tr = ply:GetEyeTrace()
		local hitPos = tr.HitPos
		hitPos = LocalToWorld(Vector(0, -50, -15), Angle(0, 0, 0), hitPos, ply:GetAngles())

		local z = 14.5 * scale + ((distY * math.Clamp(scale * 0.4, 1, 1.5)) / 11)
		for i = 1, 10 do
			--render.DrawLine(
			--	LocalToWorld(Vector(0, 0.2, z + (i * 0.05)), Angle(0, 0, 0), ping.pos, LocalPlayer():GetAngles()), 
			--	LocalToWorld(Vector(0, 0.2, 0), Angle(0, 0, 0), hitPos, LocalPlayer():GetAngles()), 
			--	color_black
			--)
			--render.DrawLine(
			--	LocalToWorld(Vector(0, -0.2, z + (i * 0.05)), Angle(0, 0, 0), ping.pos, LocalPlayer():GetAngles()), 
			--	LocalToWorld(Vector(0, -0.2, 0), Angle(0, 0, 0), hitPos, LocalPlayer():GetAngles()), 
			--	color_black
			--)
			--render.DrawLine(
			--	LocalToWorld(Vector(0, 0, z + (i * 0.05)), Angle(0, 0, 0), ping.pos, LocalPlayer():GetAngles()), 
			--	hitPos, 
			--	self.Config.Pings[ping.ping].color
			--)
		end
	end
	*/
end

hook.Add("PostDrawTranslucentRenderables", "PIS.RenderPings", function()
	PIS:Render3D()
end)