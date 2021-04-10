local framework = Nexus:ClassManager("Framework")
local settings = framework:Class("Settings")
local languages = framework:Class("Languages")

languages:Add("Languages", {})
languages:Add("GetActiveLanguage", function(self)
	return settings:Call("Language")
end)
languages:Add("Register", function(self, script, language, data)
	language = language:lower()

	self:TernaryExistance("Languages", script, nil, function(self, lookup)
		lookup = {}
	end)
	self:Get("Languages")[script][language] = data
end)
languages:Add("GetTranslation", function(self, script, phrase, extraData)
	local activeLanguage = self:Call("GetActiveLanguage")

	local lookup = self:Get("Languages")[script]
	if (!lookup) then
		return "Unknown script"
	end
	local tempLookup = lookup[activeLanguage]
	lookup = lookup or lookup["english"]
	lookup = lookup[phrase] or "Unknown phrase"

	return isfunction(lookup) and lookup(self, extraData, phrase, script) or lookup
end)




