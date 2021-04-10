local framework = Nexus:ClassManager("Framework")
local panels = framework:Class("Panels")

local PANEL = {}

function PANEL:Init()
	self.Tabs = panels:Call("Create", "Nexus.PingSystem.SubTabs", self)
	self.Tabs:AddTab("PING", "Nexus.PingSystem.Settings.Ping")
	self.Tabs:AddTab("KEYS", "Nexus.PingSystem.Settings.Keys")
	self.Tabs:AddTab("WHEEL UI", "Nexus.PingSystem.Settings.Wheel")
	self.Tabs.OnTabChanged = function(pnl, id)
		LocalPlayer().PIS_LastSelectedSubTabSettings = id
	end
	self.Tabs:Select(LocalPlayer().PIS_LastSelectedSubTabSettings or 1)
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

vgui.Register("Nexus.PingSystem.Settings", PANEL)

PSI_SETTINGS_SLIDER = 0
PSI_SETTINGS_COMBOBOX = 1
PSI_SETTINGS_KEY = 2

PIS.Settings = {
	{ Name = "Ping sound", 
		Input = PSI_SETTINGS_COMBOBOX, 
		Default = function(settings) return settings.PingSound or 1 end, 
		Options = { "All pings", "Targeted pings", "Disabled"}, 
		Desc = "Should other peoples pings give off sound?\n\n- All pings means every single ping will give off a sound\n\n- Targeted pings means only pings directly targeted at you will give off sounds\n\n- Disabled means disabled",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "PingSound", value)
		end
	},
	{ Name = "Ping pulsating", 
		Input = PSI_SETTINGS_COMBOBOX, 
		Default = function(settings) return settings.PingPulsating or 2 end, 
		Options = { "All pings", "Targeted pings", "Disabled" },
		Desc = "Should pings pulsate?\n\n- All pings means every single ping will pulsate constantly or until confirmed\n\n- Targeted pings means only pings directly targeted at you will pulsate\n\n- Disabled means disabled",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "PingPulsating", value)
		end
	},
	{ Name = "Ping offscreen 2D render", 
		Input = PSI_SETTINGS_COMBOBOX, 
		Default = function(settings) return settings.PingOffscreen or 1 end, 
		Options = { "All pings", "Targeted pings", "Disabled" },
		Desc = "Should that you can't see in the 3D world be rendered at the edge of your screen?\n\n- All pings means every single ping will be rendered\n\n- Targeted pings means only pings directly targeted at you will be rendered\n\n- Disabled means disabled",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "PingOffscreen", value)
		end,
		TitleReplacement = "Offscreen Rendering"
	},
	{ Name = "Ping icon set", 
		Input = PSI_SETTINGS_COMBOBOX, 
		Default = function(settings) return settings.PingIconSet or 1 end, 
		Options = function()
			local tbl = {}

			for i, v in ipairs(PIS.Config.PingSets) do
				tbl[i] = v.name
			end

			return tbl
		end,
		Desc = "Changes the icons you see according to the theme",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "PingIconSet", value)
		end
	},
	{ Name = "Ping overhead",
		Input = PSI_SETTINGS_COMBOBOX,
		Default = function(settings) return settings.PingOverhead or 1 end,
		Options = { "Avatar", "Square" },
		Desc = "Should the avatar of the player be displayed above the ping if it's a command ping? Or should it be a rotated square",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "PingOverhead", value)
		end
	},
	{ Name = "Ping icon size", 
		Input = PSI_SETTINGS_SLIDER, 
		Default = function(settings) return (settings.Scale or 1) * 128 end, 
		Min = 64, 
		Max = 256, 
		Desc = "Changes the size of the pings in 3D.\n\nDefault is 128, and is technically 100% size.\n\nThis is independent of ping detection, and therefore having a really big icon, but low ping detection might make it not accurate",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "Scale", value / 128)
		end
	},
	{ Name = "Ping avatar vertices", 
		Input = PSI_SETTINGS_SLIDER, 
		Default = function(settings) return settings.PingAvatarVertices end, 
		Min = 8, 
		Max = 90, 
		Desc = "Changes the size of the pings in 3D.\n\nDefault is 128, and is technically 100% size.\n\nThis is independent of ping detection, and therefore having a really big icon, but low ping detection might make it not accurate",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "PingAvatarVertices", value)
		end
	},
	{ Name = "Ping detection size", 
		Input = PSI_SETTINGS_SLIDER, 
		Default = function(settings) return (settings.DetectionScale or 1) * 128 end, 
		Min = 64, 
		Max = 256, 
		Desc = "This determines if you are looking at a ping.\n\nDefault is 100",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "DetectionScale", value / 128)
		end
	}
}

PIS.SettingsKeys = {
	{ 
		Name = "Wheel key hold time", 
		Input = PSI_SETTINGS_SLIDER, 
		Default = function(settings) return settings.WheelDelay or 0.1 end,
		Min = 0,
		Max = 1, 
		Desc = "How long should you hold the wheel key in seconds for the wheel menu to open?\n\nDefault is 0.1",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "WheelDelay", value)
		end
	},
	{ 
		Name = "Wheel key", 
		Input = PSI_SETTINGS_KEY, 
		Default = function(settings) return settings.WheelKey or MOUSE_MIDDLE end, 
		Desc = "What key should you hold to open the wheel menu?\n\nDefault is middle mouse button (scroll wheel press)",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "WheelKey", value)
		end
	},
	{ 
		Name = "Interaction key", 
		Input = PSI_SETTINGS_KEY, 
		Default = function(settings) return settings.InteractionKey or KEY_F end, 
		Desc = "What key should you use to interact with pings?\n\nDeafult is F",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "InteractionKey", value)
		end
	},
}

PIS.SettingsWheel = {
	{ Name = "Wheel blur", Input = PSI_SETTINGS_COMBOBOX, Default = function(settings) return settings.WheelBlur or 1 end, Options = { "Enabled", "Disabled" },
		Desc = "Should the wheel be blurred? Disabling this might increase performance somewhat for users with a low-end CPU\n\nDefault is enabled",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "WheelBlur", value)
		end
	},
	{ Name = "Wheel UI scale", Input = PSI_SETTINGS_SLIDER, Default = function(settings) return (settings.WheelScale or 1) * 100 end, Min = 20, Max = 300,
		Desc = "Changes the UI to be bigger or smaller. This is listed in percentage, i.e. 100 = 100%\n\nDefault is 100",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "WheelScale", value / 100)
		end
	},
	{ Name = "Wheel monochrome", Input = PSI_SETTINGS_COMBOBOX, Default = function(settings) return settings.WheelMonochrome or 1 end, Options = function()
			return PIS.Config.WheelColors
		end,
		Desc = "Should the wheel's ping colors be one color?\nThis might be helpful for people that are colorblind and can't see specific colors very well\n\nDefault is disabled",
		OnChange = function(self, value)
			PIS:SetSetting(LocalPlayer(), "WheelMonochrome", value)
		end
	},
}
