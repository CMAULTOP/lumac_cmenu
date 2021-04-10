local framework = Nexus:ClassManager("Framework")
local _draw = framework:Class("Draw")

local PANEL = {}

surface.CreateFont("Nexus.PingSystem.Players.Buddies.Title", {
	font = "Lato",
	size = 24,
	weight = 500
})

surface.CreateFont("Nexus.PingSystem.Players.Buddies.Name", {
	font = "Lato",
	size = 28,
	weight = 800
})

surface.CreateFont("Nexus.PingSystem.Players.Buddies.Desc", {
	font = "Lato",
	size = 22,
	weight = 500
})

local muted = Material("ping_system/muted.png", "smooth")
local unmuted = Material("ping_system/unmuted.png", "smooth")

function PANEL:Init()
	self:DockPadding(16, 16, 16, 16)

	self.Title = self:Add("DLabel")
	self.Title:Dock(TOP)
	self.Title:SetText("People that can see your pings, and the people's pings you can see")
	self.Title:SetFont("Nexus.PingSystem.Players.Buddies.Title")
	self.Title:SetTextColor(color_white)
	self.Title:SizeToContents()

	self.Scroll = self:Add("DScrollPanel")
	self.Scroll:Dock(FILL)
	self.Scroll:DockMargin(0, 16, 0, 0)

	self.Layout = self.Scroll:Add("DIconLayout")
	self.Layout:Dock(FILL)
	self.Layout:SetSpaceX(8)
	self.Layout:SetSpaceY(8)

	local players = {}
	for i, v in pairs(player.GetAll()) do
		if (v == LocalPlayer()) then continue end
		if (!PIS.Gamemode:GetViewCondition()(LocalPlayer(), v)) then continue end

		table.insert(players, v)
	end

	for i, v in pairs(players) do
		local panel = self.Layout:Add("DButton")
		panel:SetText("")
		panel:SetTall(64)
		panel.Paint = function(pnl, w, h)
			local border = (pnl:IsHovered() or pnl.Muted:IsHovered()) and 2 or 1
			local outer = {
				{ x = 0, y = 0 },
				{ x = w, y = 0 },
				{ x = w, y = h * 0.7 },
				{ x = w - 16, y = h },
				{ x = 0, y = h }
			}
			local inner = {
				{ x = border, y = border },
				{ x = w - border, y = border },
				{ x = w - border, y = h * 0.7 - border },
				{ x = w - border - 16, y = h - border },
				{ x = border, y = h - border }
			}

			draw.NoTexture()

			surface.SetDrawColor(Color(0, 0, 0, 100))
			surface.DrawPoly(inner)

			_draw:Call("MaskExclude", function()
				surface.SetDrawColor(color_white)
				surface.DrawPoly(inner)
			end, function()
				surface.SetDrawColor((pnl:IsHovered() or pnl.Muted:IsHovered()) and PIS.Config.HighlightColor or Color(83, 83, 83))
				surface.DrawPoly(outer)
			end)

			local x = 8 + pnl.Avatar:GetWide() + 8

			draw.SimpleText(v:Nick(), "Nexus.PingSystem.Players.Buddies.Name", x, h / 2 + 3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(PIS.Gamemode:GetSubtitleDisplay()(v), "Nexus.PingSystem.Players.Buddies.Desc", x, h / 2, Color(224, 224, 222), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		panel.OnCursorEntered = function(pnl)
			surface.PlaySound("ping_system/hover.wav")
		end
		panel.DoClick = function(pnl)
			surface.PlaySound("ping_system/accept.wav")

			pnl.Muted:DoClick()
		end

		panel.Avatar = panel:Add("AvatarImage")
		panel.Avatar:SetPlayer(v, 128)
		panel.Avatar:Dock(LEFT)
		panel.Avatar:DockMargin(8, 8, 8, 8)
		panel.Avatar:SetWide(48)

		panel.Muted = panel:Add("DButton")
		panel.Muted:SetMouseInputEnabled(false)
		panel.Muted:SetText("")
		panel.Muted.Muted = false
		panel.Muted.Paint = function(pnl, w, h)
			surface.SetDrawColor(panel:IsHovered() and color_white or Color(183, 183, 183))
			surface.SetMaterial(pnl.Muted and muted or unmuted)
			surface.DrawTexturedRect(0, 0, w, h)
		end
		panel.Muted.DoClick = function(pnl)
			pnl.Muted = !pnl.Muted

			PIS:SetMuted(LocalPlayer(), v, pnl.Muted)
		end
		
		panel.PerformLayout = function(pnl, w, h)
			panel.Muted:AlignRight(20)
			panel.Muted:AlignTop(15)
			panel.Muted:SetTall(h - 30)
			panel.Muted:SetWide(panel.Muted:GetTall())
		end
	end
end

function PANEL:PerformLayout(w, h)
	for i, v in pairs(self.Layout:GetChildren()) do
		v:SetWide(self.Layout:GetWide() / 2 - 4)
	end
end

function PANEL:Paint(w, h)
	if (#self.Layout:GetChildren() == 0) then
		_draw:Call("ShadowText", "Nobody can see your pings :(", "Nexus.PingSystem.Players.Buddies.Name", w / 2, 72, Color(212, 212, 218), TEXT_ALIGN_CENTER)
	end
end

vgui.Register("Nexus.PingSystem.Players.Pings", PANEL)
