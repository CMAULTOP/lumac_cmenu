local GAMEMODE = PIS:GetGamemode()
GAMEMODE:SetName("Trouble in Terrorist Town")
GAMEMODE:SetID("ttt")
GAMEMODE:SetDetectionCondition(function()
	return engine.ActiveGamemode() == "terrortown"
end)
GAMEMODE:SetPlayers(function(author)
	local tbl = {}

	for i, v in pairs(player.GetAll()) do
		if (v == author) then continue end
		if (!v:IsTraitor()) then continue end

		table.insert(tbl, v)
	end

	return tbl
end)
GAMEMODE:SetViewCondition(function(author, target)
	return target:IsTraitor()
end)
GAMEMODE:SetPingCondition(function(author)
	return author:Alive() and author:IsTraitor()
end)
GAMEMODE:SetCommandCondition(function(author)
	return true
end)
GAMEMODE:SetSubtitleDisplay(function(player)
	return player:GetUserGroup():sub(1, 1):upper() .. player:GetUserGroup():sub(2)
end)
GAMEMODE:SetInteractionCondition(function(author)
	return author:Alive()
end)
GAMEMODE:SetOnDeath(function(author)
	
end)

GAMEMODE:Register()
