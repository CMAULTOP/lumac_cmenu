local PANEL = {}

surface.CreateFont("Nexus.PingSystem.Settings.Boolean", {
	font = "TT Lakes Medium",
	size = 20
})

function PANEL:SetOptions(tbl)
	self.Left = self:Add("DButton")
	self.Left:Dock(LEFT)
	self.Left.Id = 1
	self.Left:SetText(tbl[self.Left.Id])
	self.Left:SetFont("Nexus.PingSystem.Settings.Boolean")
	self.Left.Paint = function(pnl, w, h)
		pnl:SetTextColor(self.Selected == pnl.Id and color_white or Color(183, 183, 183))

		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(pnl:IsHovered() and PIS.Config.HighlightColor or Color(83, 83, 83))
		surface.DrawOutlinedRect(0, 0, w, h)

		if (self.Selected == pnl.Id) then
			surface.SetDrawColor(PIS.Config.HighlightColor)
			surface.DrawRect(0, h - 2, w, 2)
		end
	end
	self.Left.DoClick = function(pnl)
		self:RequestFocus()

		self:SetSelected(pnl.Id)

		surface.PlaySound("ping_system/accept.wav")
	end

	self.Right = self:Add("DButton")
	self.Right:Dock(FILL)
	self.Right:DockMargin(8, 0, 0, 0)
	self.Right.Id = 2
	self.Right:SetText(tbl[self.Right.Id])
	self.Right:SetFont("Nexus.PingSystem.Settings.Boolean")
	self.Right.Paint = function(pnl, w, h)
		pnl:SetTextColor(self.Selected == pnl.Id and color_white or Color(183, 183, 183))

		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(pnl:IsHovered() and PIS.Config.HighlightColor or Color(83, 83, 83))
		surface.DrawOutlinedRect(0, 0, w, h)

		if (self.Selected == pnl.Id) then
			surface.SetDrawColor(PIS.Config.HighlightColor)
			surface.DrawRect(0, h - 2, w, 2)
		end
	end
	self.Right.DoClick = function(pnl)
		self:RequestFocus()

		self:SetSelected(pnl.Id)

		surface.PlaySound("ping_system/accept.wav")
	end
end

function PANEL:SetSelected(index)
	self.Selected = index

	if (self.OnChange) then
		self:OnChange(index)
	end
end

function PANEL:PerformLayout(w, h)
	self.Left:SetWide(w / 2 - 4)
end

vgui.Register("Nexus.PingSystem.Settings.Boolean", PANEL)