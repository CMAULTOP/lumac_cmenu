local framework = Nexus:ClassManager("Framework")
local _draw = framework:Class("Draw")
local anim = framework:Class("Animations")
local panels = framework:Class("Panels")
local testing = framework:Class("Testing")

local PANEL = {}

surface.CreateFont("Nexus.PingSystem.Menu.Tabs", {
	font = "TT Lakes Medium",
	size = 28
})

local closeButton = Material("xenin/closebutton.png", "smooth")

function PANEL:Select(id)
	if (self.ActiveTab == id) then return end

	local btn = self.Tab.Tabs[self.ActiveTab]
	if (IsValid(btn)) then
		btn.TextColor = Color(180, 180, 180)
		btn.BarColor = Color(180, 180, 180)

		local pnl = btn.Panel
		if (IsValid(pnl)) then
			pnl:SetVisible(false)
		end
	end

	self.ActiveTab = id

	local btn = self.Tab.Tabs[id]
	if (IsValid(btn)) then
		btn.TextColor = color_white
		btn.BarColor = PIS.Config.HighlightColor

		local pnl = btn.Panel
		if (IsValid(pnl)) then
			pnl:SetVisible(true)
		end
	end

	LocalPlayer().PIS_LastSelectedTab = id
end

function PANEL:Init()
	self.Tab = panels:Call("Create", "Panel", self)
	self.Tab:Dock(TOP)
	self.Tab.Tabs = {}
	self.Tab.AddTab = function(pnl, name, panelType)
		local button = panels:Call("Create", "DButton", self.Tab)
		button:SetText("")
		button.TextColor = Color(180, 180, 180)
		button.BarColor = Color(180, 180, 180)
		button.Paint = function(pnl, w, h)
			local polygon = {
				{ x = 0, y = 0 },
				{ x = w, y = 0 },
				{ x = w + w * 0.15, y = h },
				{ x = w * 0.15, y = h }
			}
			DisableClipping(true)
				draw.NoTexture()
				surface.SetDrawColor(ColorAlpha(self.ActiveTab == pnl.Id and PIS.Config.HighlightTabColor or Color(180, 180, 180), self.ActiveTab == pnl.Id and 75 or 20))
				surface.DrawPoly(polygon)

				local polygon = {
					{ x = w * 0.14, y = h - 4 },
					{ x = w + w * 0.15 - 1, y = h - 4 },
					{ x = w + w * 0.15, y = h },
					{ x = w * 0.14 + 1, y = h }
				}
				surface.SetDrawColor(pnl.BarColor)
				surface.DrawPoly(polygon)
			DisableClipping(false)

			draw.SimpleText(name, "Nexus.PingSystem.Menu.Tabs", w / 2 + (w * 0.15 / 2), h - 12, pnl.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end
		button.DoClick = function(pnl)
			surface.PlaySound("ping_system/accept.wav")

			self:Select(pnl.Id)
		end

		local id = table.insert(pnl.Tabs, button)
		pnl.Tabs[id].Id = id

		local panel = panels:Call("Create", panelType or "DPanel", self)
		panel:SetVisible(false)

		button.Panel = panel
		pnl.Tabs[id].Panel = panel
	end
	self.Tab:AddTab("PLAYERS", "Nexus.PingSystem.Players")
	self.Tab:AddTab("SETTINGS", "Nexus.PingSystem.Settings")
	--self.Tab:AddTab("ADMIN", "Nexus.PingSystem.Admin")
	self:Select(LocalPlayer().PIS_LastSelectedTab or 1)

	self.CloseButton = panels:Call("Create", "DButton", self.Tab)
	self.CloseButton:Dock(RIGHT)
	self.CloseButton:SetText("")
	self.CloseButton.Paint = function(pnl, w, h)
		local margin = 24
		
		surface.SetDrawColor(color_white)
		surface.SetMaterial(closeButton)
		surface.DrawTexturedRect(w - (w - (margin * 2)) - margin, margin + 2, w - (margin * 2), h - (margin * 2))
	end
	self.CloseButton.DoClick = function(pnl)
		self:Close()
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(PIS.Config.BackgroundColor)
	surface.DrawRect(0, 0, w, h)
	
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(0, 0, w, self.Tab:GetTall())
end

function PANEL:PerformLayout(w, h)
	self.Tab:SetTall(64)

	local width = 160
	local x = 16
	local amt = table.Count(self.Tab.Tabs)
	for i, v in pairs(self.Tab.Tabs) do
		/*
		local x
		if (i == 1) then
			x = w / 2 - width / 2
		elseif (i % 2 == 0) then
			x = w / 2 + (width / 2 * math.floor(i / 2)) + 4
		elseif (i % 2 == 1) then
			x = w / 2 - (width / 2 * math.floor(i / 2)) - width - 4
		end*/

		v:SetPos(x, 0)
		v:SetSize(width, self.Tab:GetTall())

		x = x + v:GetWide() + 2

		v.Panel:SetPos(0, v:GetTall())
		v.Panel:SetSize(w, h - v:GetTall())
	end
end

function PANEL:Close()
	self:Remove()
end

vgui.Register("Nexus.PingSystem.Frame", PANEL, "EditablePanel")

testing:Call("Add", "ping_frame", function()
	local frame = panels:Call("Create", "Nexus.PingSystem.Frame")
	frame:SetSize(1060 * 0.75, 628)
	frame:Center()
	frame:MakePopup()
end)