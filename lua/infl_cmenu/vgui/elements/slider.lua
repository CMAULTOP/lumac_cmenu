local PANEL = {}

function PANEL:Init()
	self.Frac = 0.5
end

function PANEL:OnMousePressed()
	self:MouseCapture(true)
	self.Depressed = true

	self:ChangeFraction()
end

function PANEL:ChangeFraction()
	local x, y = self:CursorPos()
	local w = self:GetWide()
	local frac = math.Clamp(x / w, 0, 1)

	if (frac != self.Frac) then
		self:OnValueChanged(frac)
	end

	self.Frac = frac
end

function PANEL:OnValueChanged(frac)

end

function PANEL:OnCursorMoved()
	if (!self.Depressed) then return end

	self:ChangeFraction()
end

function PANEL:OnMouseReleased()
	self:MouseCapture(false)
	self.Depressed = false
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(138, 137, 138)
	surface.DrawRect(0, 0, (w * self.Frac) - 4, h)

	surface.SetDrawColor(PIS.Config.HighlightColor)
	surface.DrawRect(math.Clamp((w * self.Frac) - 4, 0, w), 0, 4, h)

	surface.SetDrawColor(self.Depressed and PIS.Config.HighlightColor or Color(83, 83, 83))
	for i = 0, self.Depressed and 1 or 0 do
		surface.DrawOutlinedRect(i, i, w - (i * 2), h - (i * 2))
	end
end

vgui.Register("Nexus.PingSystem.Slider", PANEL)