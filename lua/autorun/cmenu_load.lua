	
	PIS = {}

	local function Load()
		local loader = Nexus:Loader()
		loader:SetName("CMenu")
		loader:SetColor(Color(48, 100, 255))
		loader:SetAcronym("PIS")
		loader:RegisterAcronym()
		loader:SetLoadDirectory("infl_cmenu")
		loader:Load("config", "SHARED", true)
		loader:Load("core", "SHARED", true)
		loader:Load("vgui", "CLIENT", true)
		loader:Load("misc", "SHARED", true)
		loader:Load("gamemodes", "SHARED", true)

		for i, v in pairs(PIS.Gamemodes) do
			if (v:GetDetectionCondition()()) then
				PIS.Gamemode = v
			end
		end

		if (!PIS.Gamemode) then
			for i, v in pairs(PIS.Gamemodes) do
				if (v:GetID() == "backup") then
					PIS.Gamemode = v

					break
				end
			end
		end

			loader:Register()
		end

	if (Nexus) then Load()
	else hook.Add("Nexus.PostLoaded", "CMenu", Load) end
