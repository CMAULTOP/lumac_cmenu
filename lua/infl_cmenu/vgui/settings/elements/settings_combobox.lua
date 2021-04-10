local PANEL = {}

surface.CreateFont("Nexus.PingSystem.Settings.Option.Arrow", {
	font = "TT Lakes Medium",
	size = 40
})

surface.CreateFont("Nexus.PingSystem.Settings.Option.Combobox", {
	font = "TT Lakes Medium",
	size = 22,
	weight = 500
})

local arrow = Material("ping_system/arrow.png", "smooth")

function PANEL:Init()
	self.LeftArrow = self:Add("DButton")
	self.LeftArrow:Dock(LEFT)
	self.LeftArrow:SetText("")
	self.LeftArrow:SetContentAlignment(2)
	self.LeftArrow:SetFont("Nexus.PingSystem.Settings.Option.Arrow")
	self.LeftArrow.Paint = function(pnl, w, h)
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(pnl:IsHovered() and PIS.Config.HighlightColor or Color(83, 83, 83))
		for i = 0, pnl:IsHovered() and 1 or 0 do
			surface.DrawOutlinedRect(i, i, w - (i * 2), h - (i * 2))
		end

		local margin = 10
		local size = w - (margin * 2)
		local sizeW = size * 0.7
		local marginX = w / 2 - sizeW / 2
		surface.SetMaterial(arrow)
		surface.SetDrawColor(pnl:IsHovered() and color_white or Color(212, 212, 212))
		surface.DrawTexturedRect(marginX, margin, sizeW, size)
	end
	self.LeftArrow.DoClick = function(pnl)
		self:RequestFocus()

		self:SetSelected(math.Clamp(self.Selected - 1, 1, #self.Options))

		surface.PlaySound("ping_system/accept.wav")
	end

	self.RightArrow = self:Add("DButton")
	self.RightArrow:Dock(RIGHT)
	self.RightArrow:SetText("")
	self.RightArrow:SetContentAlignment(2)
	self.RightArrow:SetFont("Nexus.PingSystem.Settings.Option.Arrow")
	self.RightArrow.Paint = function(pnl, w, h)
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(pnl:IsHovered() and PIS.Config.HighlightColor or Color(83, 83, 83))
		for i = 0, pnl:IsHovered() and 1 or 0 do
			surface.DrawOutlinedRect(i, i, w - (i * 2), h - (i * 2))
		end

		local margin = 10
		local size = w - (margin * 2)
		local sizeW = size * 0.7
		local marginX = w / 2 - sizeW / 2
		surface.SetMaterial(arrow)
		surface.SetDrawColor(pnl:IsHovered() and color_white or Color(212, 212, 212))
		surface.DrawTexturedRectRotated(marginX + sizeW / 2, margin + size / 2, sizeW, size, 180)
	end
	self.RightArrow.DoClick = function(pnl)
		self:RequestFocus()

		self:SetSelected(math.Clamp(self.Selected + 1, 1, #self.Options))

		surface.PlaySound("ping_system/accept.wav")
	end

	self.Options = {}

	self.Box = self:Add("DPanel")
	self.Box:Dock(FILL)
	self.Box:DockMargin(8, 0, 8, 0)
	self.Box.Paint = function(pnl, w, h)
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(83, 83, 83)
		surface.DrawOutlinedRect(0, 0, w, h)

		local x = 1
		local width = w / #self.Options - (4 / #self.Options) - 2
		for i = 0, #self.Options - 1 do
			surface.SetDrawColor(self.Selected == (i + 1) and PIS.Config.HighlightColor or Color(222, 222, 222))
			surface.DrawRect(x, h - 3, width, 2)

			x = x + width + 4
		end

		local options = self.Options[self.Selected]
		local name = istable(options) and options[1] or options
		draw.SimpleText(name, "Nexus.PingSystem.Settings.Option.Combobox", w / 2, h / 2 - 1, Color(222, 222, 222), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	self.Selected = 1
end

function PANEL:SetOptions(tbl)
	self.Options = tbl
end

function PANEL:SetSelected(index)
	self.Selected = index

	if (self.OnChange) then
		self:OnChange(index)
	end
end

function PANEL:PerformLayout(w, h)
	self.LeftArrow:SetWide(self.LeftArrow:GetTall())
	self.RightArrow:SetWide(self.RightArrow:GetTall())
end

vgui.Register("Nexus.PingSystem.Settings.Combobox", PANEL)