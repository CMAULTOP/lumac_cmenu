local PANEL = {}

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect(0, 0, w, h)

	local num = self.Active and 2 or self:IsHovered() and 1 or 0
	surface.SetDrawColor((self.Active or self:IsHovered()) and PIS.Config.HighlightColor or Color(83, 83, 83))
	for i = 0, num do
		surface.DrawOutlinedRect(i, i, w - (i * 2), h - (i * 2))
	end

	local code = PIS:GetKeyName(self.Key)
	draw.SimpleText(code, "Nexus.PingSystem.Settings.Option.Combobox", w / 2, h / 2, Color(222, 222, 222), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:OnFocusChanged(gained)
	if (!gained and self.Active) then
		self.Active = nil
	end
end

function PANEL:OnChange()

end

function PANEL:OnKeyCodeReleased(keyCode)
	if (!self.Active) then return end

	if (keyCode != KEY_ESCAPE) then
		self.Key = keyCode

		self:OnChange(self.Key)
	end

	self:KillFocus()
	self.Active = nil
end

function PANEL:OnMouseReleased(mouseCode)
	if (mouseCode >= MOUSE_MIDDLE) then
		-- Not left or right

		self.Key = mouseCode

		self:KillFocus()
		self.Active = nil

		self:OnChange(self.Key)

		return
	end

	surface.PlaySound("ping_system/accept.wav")
	self.Active = true

	self:RequestFocus()
end

vgui.Register("Nexus.PingSystem.Settings.Key", PANEL)