local PANEL = {}

function PANEL:SetDescription(title, desc)
	self.Explain.Title:SetText(title)
	self.Explain.Title:SizeToContentsY()

	self.Explain.Desc:SetText(desc)
end

function PANEL:OnCursorEntered()
	self:SetDescription("", "")
end

function PANEL:Init()
	self:DockPadding(16, 16, 16, 16)

	self.Explain = self:Add("DPanel")
	self.Explain:Dock(RIGHT)
	self.Explain:DockMargin(0, 0, 0, 0)
	self.Explain.Paint = function(pnl, w, h)
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(83, 83, 83)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	self.Explain:DockPadding(8, 8, 8, 8)

	self.Explain.Title = self.Explain:Add("DLabel")
	self.Explain.Title:Dock(TOP)
	self.Explain.Title:SetFont("Nexus.PingSystem.Settings.Desc.Title")
	self.Explain.Title:SetTextColor(color_white)

	self.Explain.Desc = self.Explain:Add("DLabel")
	self.Explain.Desc:Dock(TOP)
	self.Explain.Desc:SetFont("Nexus.PingSystem.Settings.Desc.Desc")
	self.Explain.Desc:SetTextColor(Color(212, 212, 212))
	self.Explain.Desc:SetMultiline(true)
	self.Explain.Desc:SetWrap(true)
	self.Explain.Desc:SetContentAlignment(7)

	self.Explain.PerformLayout = function(pnl, w, h)
		self.Explain.Desc:SetPos(8, 8 + self.Explain.Title:GetTall())
		self.Explain.Desc:SetSize(w - 16, h) 
	end

	self:SetDescription("", "")

	self.Scroll = self:Add("DScrollPanel")
	self.Scroll:Dock(FILL)
	self.Scroll:DockMargin(0, 0, 16, 0)
	self.Scroll.OnCursorEntered = function(pnl, w, h)
		self:SetDescription("", "")
	end

	for i, v in ipairs(PIS.SettingsWheel) do
		local panel = self.Scroll:Add("DPanel")
		panel:Dock(TOP)
		panel:DockMargin(0, 0, 0, 8)
		panel:SetTall(52)
		panel.Paint = function(pnl, w, h)
			local hovered = pnl:IsHovered()
			if (!hovered) then
				local function recursiveCheck(panel)
					for i, v in pairs(panel:GetChildren()) do
						if (v:IsHovered()) then
							hovered = true

							break
						else
							recursiveCheck(v)
						end
					end
				end

				recursiveCheck(pnl)
			end

			if (pnl.hovered != hovered and hovered) then
				surface.PlaySound("ping_system/hover.wav")
			end

			pnl.hovered = hovered

			surface.SetDrawColor(0, 0, 0, hovered and 160 or 100)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(pnl.hovered and PIS.Config.HighlightColor or Color(83, 83, 83))
			surface.DrawOutlinedRect(0, 0, w, h)

			draw.SimpleText(v.Name, "Nexus.PingSystem.Settings.Option.Name", 12, h / 2, hovered and color_white or Color(183, 183, 183), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		local options = v.Options and isfunction(v.Options) and v.Options() or v.Options
		local optionsLen = options and #options or 0
		panel.Input = panel:Add(
			v.Input == PSI_SETTINGS_SLIDER and "Nexus.PingSystem.Settings.Slider"
			or (v.Input == PSI_SETTINGS_COMBOBOX and optionsLen != 2) and "Nexus.PingSystem.Settings.Combobox"
			or v.Input == PSI_SETTINGS_COMBOBOX and "Nexus.PingSystem.Settings.Boolean"
			or v.Input == PSI_SETTINGS_KEY and "Nexus.PingSystem.Settings.Key")
		panel.Input:Dock(RIGHT)
		panel.Input:DockMargin(8, 8, 8, 8)
		panel.Input:SetWide(238)

		local default = isfunction(v.Default) and v.Default(PIS:GetSettings(LocalPlayer())) or 0
		if (v.Input == PSI_SETTINGS_SLIDER) then
			panel.Input:SetMin(v.Min)
			panel.Input:SetMax(v.Max)
			panel.Input:OnValueChanged((default - v.Min) / (v.Max - v.Min))
		elseif (v.Input == PSI_SETTINGS_COMBOBOX) then
			panel.Input:SetOptions(isfunction(v.Options) and v.Options() or v.Options)
			panel.Input:SetSelected(default)
		elseif (v.Input == PSI_SETTINGS_KEY) then
			panel.Input.Key = default
		end

		panel.Input.OnChange = v.OnChange

		panel.OnCursorEntered = function(pnl)
			self:SetDescription(v.TitleReplacement or v.Name, v.Desc or "")
		end
	end
end

function PANEL:PerformLayout(w, h)
	self.Explain:SetWide(240)
end

vgui.Register("Nexus.PingSystem.Settings.Wheel", PANEL)
