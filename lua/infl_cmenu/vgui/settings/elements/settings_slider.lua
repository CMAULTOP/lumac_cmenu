local PANEL = {}

AccessorFunc(PANEL, "m_min", "Min")
AccessorFunc(PANEL, "m_max", "Max")

function PANEL:Init()
	self:SetMin(0)
	self:SetMax(100)

	self.Slider = self:Add("Nexus.PingSystem.Slider")
	self.Slider:Dock(FILL)
	self.Slider:DockMargin(0, 0, 12, 0)
	self.Slider.OnValueChanged = function(pnl, frac)
		self:OnValueChanged(frac)
	end

	self.TextEntry = self:Add("Nexus.PingSystem.TextEntry")
	self.TextEntry:Dock(RIGHT)
	self.TextEntry:SetWide(54)
	self.TextEntry.TextEntry.OnValueChange = function(pnl, text)
		text = tonumber(text)
		text = text or 0

		text = math.Clamp(text, self:GetMin(), self:GetMax())
		self:OnValueChanged((text - self:GetMin()) / (self:GetMax() - self:GetMin()), true)
	end
	self.TextEntry.TextEntry.OnFocusChanged = function(pnl, gained)
		if (!gained) then
			local text = tonumber(pnl:GetText())
			text = text or 0

			text = math.Clamp(text, self:GetMin(), self:GetMax())
			pnl:SetText(text)
		end
	end

	self:OnValueChanged(0.5)
end

function PANEL:OnValueChanged(frac, ignoreText)
	local min = self:GetMin()
	local max = self:GetMax()
	local num = math.Round(((1 - frac) * min) + (frac * max), max >= 10 and 0 or 2)

	if (!ignoreText) then
		self.TextEntry:SetText(num)
	end
	self.Slider.Frac = frac

	if (self.OnChange) then
		self:OnChange(num)
	end
end

vgui.Register("Nexus.PingSystem.Settings.Slider", PANEL)