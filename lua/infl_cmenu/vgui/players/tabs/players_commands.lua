local framework = Nexus:ClassManager("Framework")
local _draw = framework:Class("Draw")

local PANEL = {}

surface.CreateFont("Nexus.PingSystem.Players.Buddies.Title", {
	font = "Lato",
	size = 24,
	weight = 500
})

surface.CreateFont("Nexus.PingSystem.Players.Buddies.Name", {
	font = "Lato",
	size = 28,
	weight = 800
})

surface.CreateFont("Nexus.PingSystem.Players.Buddies.Desc", {
	font = "Lato",
	size = 22,
	weight = 500
})

local muted = Material("ping_system/muted.png", "smooth")
local unmuted = Material("ping_system/unmuted.png", "smooth")

function PANEL:Init()
	self:DockPadding(16, 16, 16, 16)

	self.Scroll = self:Add("DScrollPanel")
	self.Scroll:Dock(FILL)
	self.Scroll:DockMargin(0, 0, 0, 0)

	self.Title = self.Scroll:Add("DLabel")
	self.Title:Dock(TOP)
	self.Title:DockMargin(0, 0, 0, 16)
	self.Title:SetText("You can command these people")
	self.Title:SetFont("Nexus.PingSystem.Players.Buddies.Title")
	self.Title:SetTextColor(color_white)
	self.Title:SizeToContents()

	self.Layout = self.Scroll:Add("DIconLayout")
	self.Layout:Dock(FILL)
	self.Layout:SetSpaceX(8)
	self.Layout:SetSpaceY(8)

	local players = {}
	for i, v in pairs(player.GetAll()) do
		if (v == LocalPlayer()) then continue end
		if (!PIS.Gamemode:GetCommandCondition()(LocalPlayer(), v)) then continue end

		table.insert(players, v)
	end

	for i, v in pairs(players) do
		local panel = self.Layout:Add("DButton")
		panel:SetText("")
		panel:SetTall(64)
		panel.Paint = function(pnl, w, h)
			local border = pnl:IsHovered() and 2 or 1
			local outer = {
				{ x = 0, y = 0 },
				{ x = w, y = 0 },
				{ x = w, y = h * 0.7 },
				{ x = w - 16, y = h },
				{ x = 0, y = h }
			}
			local inner = {
				{ x = border, y = border },
				{ x = w - border, y = border },
				{ x = w - border, y = h * 0.7 - border },
				{ x = w - border - 16, y = h - border },
				{ x = border, y = h - border }
			}

			draw.NoTexture()

			surface.SetDrawColor(Color(0, 0, 0, 100))
			surface.DrawPoly(inner)

			_draw:Call("MaskExclude", function()
				surface.SetDrawColor(color_white)
				surface.DrawPoly(inner)
			end, function()
				surface.SetDrawColor(pnl:IsHovered() and PIS.Config.HighlightColor or Color(83, 83, 83))
				surface.DrawPoly(outer)
			end)

			local x = 8 + pnl.Avatar:GetWide() + 8

			draw.SimpleText(v:Nick(), "Nexus.PingSystem.Players.Buddies.Name", x, h / 2 + 3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(PIS.Gamemode:GetSubtitleDisplay()(v), "Nexus.PingSystem.Players.Buddies.Desc", x, h / 2, Color(224, 224, 222), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		panel.OnCursorEntered = function(pnl)
			surface.PlaySound("ping_system/hover.wav")
		end
		
		panel.Avatar = panel:Add("AvatarImage")
		panel.Avatar:SetPlayer(v, 128)
		panel.Avatar:Dock(LEFT)
		panel.Avatar:DockMargin(8, 8, 8, 8)
		panel.Avatar:SetWide(48)
	end
end

function PANEL:PerformLayout(w, h)
	for i, v in pairs(self.Layout:GetChildren()) do
		v:SetWide(self.Layout:GetWide() / 2 - 4)
	end
end

function PANEL:Paint(w, h)
	if (#self.Layout:GetChildren() == 0) then
		_draw:Call("ShadowText", "You can't command anyone :(", "Nexus.PingSystem.Players.Buddies.Name", w / 2, 72, Color(212, 212, 218), TEXT_ALIGN_CENTER)
	end
end

vgui.Register("Nexus.PingSystem.Players.Commands", PANEL)