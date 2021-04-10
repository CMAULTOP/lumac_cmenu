local PANEL = {}

function PANEL:Init()
	self.TextEntry = self:Add("DTextEntry")
	self.TextEntry:Dock(FILL)
	self.TextEntry:DockMargin(4, 4, 4, 4)
	self.TextEntry:SetFont("Nexus.PingSystem.Settings.Option.Name")
	self.TextEntry:SetDrawLanguageID(false)
	self.TextEntry:SetNumeric(true)
	self.TextEntry:SetUpdateOnType(true)
	self.TextEntry.Paint = function(pnl, w, h)
		local col = pnl:HasFocus() and color_white or Color(202, 202, 202)

		pnl:DrawTextEntryText(col, color_black, color_white)
	end
end

function PANEL:SetText(text)
	self.TextEntry:SetText(text)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(self.TextEntry:HasFocus() and PIS.Config.HighlightColor or Color(83, 83, 83))
	for i = 0, self.TextEntry:HasFocus() and 1 or 0 do
		surface.DrawOutlinedRect(i, i, w - (i * 2), h - (i * 2))
	end
end

vgui.Register("Nexus.PingSystem.TextEntry", PANEL)