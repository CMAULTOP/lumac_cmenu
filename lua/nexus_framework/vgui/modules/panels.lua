local framework = Nexus:ClassManager("Framework")
local panels = framework:Class("Panels")
local anim = framework:Class("Animations")
	
panels:Add("Create", function(self, pnlName, parent)
	local panel = vgui.Create(pnlName, parent)
	panel.__anim = anim
	panel.Anim = function(pnl)
		return pnl.__anim
	end

	return panel
end)