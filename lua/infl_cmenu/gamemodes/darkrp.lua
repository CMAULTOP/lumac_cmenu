local GAMEMODE = PIS:GetGamemode()
GAMEMODE:SetName("DarkRP")
GAMEMODE:SetID("darkrp")
GAMEMODE:SetDetectionCondition(function()
	return DarkRP
end)
GAMEMODE:SetPlayers(function(author)
	local tbl = {}

	for i, v in pairs(player.GetAll()) do
		if (v == author) then continue end
		for _, tbl in pairs(PIS.Config.RPTeamViews) do
			if (table.HasValue(tbl, team.GetName(v:Team()))) then
				table.insert(tbl, v)

				break
			end
		end
		table.insert(tbl, v)
	end

	return tbl
end)
GAMEMODE:SetSubtitleDisplay(function(player)
	return team.GetName(player:Team())
end)
GAMEMODE:SetViewCondition(function(author, target)
	for i, v in pairs(PIS.Config.RPTeamViews) do
		if (table.HasValue(v, team.GetName(target:Team()))) then
			return true
		end
	end
end)
GAMEMODE:SetPingCondition(function(author)
	return author:Alive()
end)
GAMEMODE:SetCommandCondition(function(author, target)
	local authorAuth = PIS.Config.RPTeamAuthority[team.GetName(author:Team())] or 1
	local targetAuth = PIS.Config.RPTeamAuthority[team.GetName(target:Team())] or 1

	return authorAuth > targetAuth
end)
GAMEMODE:SetInteractionCondition(function(author)
	return author:Alive()
end)
GAMEMODE:SetOnDeath(function(author)
	
end)

GAMEMODE:Register()
