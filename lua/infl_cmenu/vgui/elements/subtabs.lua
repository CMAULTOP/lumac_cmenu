local framework = Nexus:ClassManager("Framework")
local panels = framework:Class("Panels")

local PANEL = {}

surface.CreateFont("Nexus.PingSystem.Menu.SubTabs", {
	font = "TT Lakes Medium",
	size = 21
})

function PANEL:Init()
	self.Tabs = {}
end

function PANEL:Select(id)
	if (self.ActiveTab == id) then return end

	local btn = self.Tabs[self.ActiveTab]
	if (IsValid(btn)) then
		btn.TextColor = Color(180, 180, 180)
		btn.BarColor = Color(180, 180, 180)
		btn.BackgroundColor = Color(68, 68, 68, 200)
		
		local pnl = btn.Panel
		if (IsValid(pnl)) then
			pnl:SetVisible(false)
		end
	end

	self.ActiveTab = id

	local btn = self.Tabs[id]
	if (IsValid(btn)) then
		btn.TextColor = color_white
		btn.BarColor = PIS.Config.HighlightColor
		btn.BackgroundColor = Color(146, 36, 41, 200)

		local pnl = btn.Panel
		if (IsValid(pnl)) then
			pnl:SetVisible(true)
		end
	end

	if (self.OnTabChanged) then
		self:OnTabChanged(id)
	end
end

function PANEL:AddTab(name, panelClass)
	local button = panels:Call("Create", "DButton", self)
	button:SetText("")
	button.TextColor = Color(180, 180, 180)
	button.BarColor = Color(180, 180, 180)
	button.Paint = function(pnl, w, h)
		local polygon = {
			{ x = 0, y = 0 },
			{ x = w, y = 0 },
			{ x = w + w * 0.084, y = h },
			{ x = w * 0.084, y = h }
		}

		DisableClipping(true)
			draw.NoTexture()
			surface.SetDrawColor(ColorAlpha(self.ActiveTab == pnl.Id and PIS.Config.HighlightTabColor or Color(180, 180, 180), self.ActiveTab == pnl.Id and 75 or 20))
			surface.DrawPoly(polygon)

			local polygon = {
				{ x = w * 0.082, y = h - 4 },
				{ x = w + w * 0.084 - 1, y = h - 4 },
				{ x = w + w * 0.084, y = h },
				{ x = w * 0.082 + 1, y = h }
			}
			surface.SetDrawColor(pnl.BarColor)
			surface.DrawPoly(polygon)
		DisableClipping(false)

		draw.SimpleText(name, "Nexus.PingSystem.Menu.SubTabs", w / 2 + (w * 0.042), h / 2 - 2, pnl.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	button.DoClick = function(pnl)
		surface.PlaySound("ping_system/accept.wav")

		self:Select(pnl.Id)
	end

	local panel = panels:Call("Create", panelClass or "Panel", self:GetParent())
	panel:Dock(FILL)
	panel:DockMargin(0, 60, 0, 0)
	panel:SetVisible(false)

	button.Panel = panel

	local id = table.insert(self.Tabs, button)
	self.Tabs[id].Id = id
end

function PANEL:PerformLayout(w, h)
	local x = 52
	local width = 145
	for i, v in pairs(self.Tabs) do
		v:SetSize(width, h)
		v:SetPos(x, 0)

		x = x + width + 2
	end
end

vgui.Register("Nexus.PingSystem.SubTabs", PANEL)