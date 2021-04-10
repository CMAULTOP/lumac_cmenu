local framework = Nexus:ClassManager("Framework")
local settings = framework:Class("Settings")

settings:Add("Config", {})
settings:Add("GetEase", function(self)
	return "Default"
end)
settings:Add("Language", function(self)
	return self:Get("Config").Language
end)