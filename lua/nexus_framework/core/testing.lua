local framework = Nexus:ClassManager("Framework")
local testing = framework:Class("Testing")
testing:Add("Tests", {})
testing:Add("Add", function(self, name, func)
	self:Get("Tests")[name] = func
end)
testing:Add("AutoComplete", function(self, cmd, args)
	local tests = self:Get("Tests")

	args = string.Trim(args)
	args = string.lower(args)

	local tbl = {}

	for i, v in pairs(tests) do
		if (i:lower():find(args)) then
			table.insert(tbl, "nexus_test " .. i:lower())
		end
	end

	return tbl
end)

concommand.Add("nexus_test", function(ply, cmd, args)
	local name = args[1]
	local tbl = testing:Get("Tests")[name]
	if (!tbl) then print("No such test") return end

	tbl(ply, cmd, args)
end, function(cmd, args)
	return testing:Call("AutoComplete", cmd, args)
end)