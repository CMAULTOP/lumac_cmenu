local framework = Nexus:ClassManager("Framework")
local panels = framework:Class("Panels")

local PANEL = {}

function PANEL:Init()
	self.Tabs = panels:Call("Create", "Nexus.PingSystem.SubTabs", self)
	self.Tabs:AddTab("PINGS", "Nexus.PingSystem.Players.Pings")
	self.Tabs:AddTab("COMMANDS", "Nexus.PingSystem.Players.Commands")
	self.Tabs.OnTabChanged = function(pnl, id)
		LocalPlayer().PIS_LastSelectedSubTabPlayers = id
	end
	self.Tabs:Select(LocalPlayer().PIS_LastSelectedSubTabPlayers or 1)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect(0, 0, w, 60)
end

function PANEL:PerformLayout(w, h)
	self.Tabs:SetTall(36)
	self.Tabs:SetPos(0, 12)
	self.Tabs:SetWide(w)
end

vgui.Register("Nexus.PingSystem.Players", PANEL)
