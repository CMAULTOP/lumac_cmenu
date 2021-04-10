local GAMEMODE = PIS:GetGamemode()
GAMEMODE:SetName("Backup")
GAMEMODE:SetID("backup")
GAMEMODE:SetDetectionCondition(function()

	return false
end)
GAMEMODE:SetPlayers(function(author)
	local tbl = {}

	for i, v in pairs(player.GetAll()) do
		if (v == author) then continue end

		table.insert(tbl, v)
	end

	return tbl
end)
GAMEMODE:SetSubtitleDisplay(function(player)
	return player:GetUserGroup():sub(1, 1):upper() .. player:GetUserGroup():sub(2)
end)
GAMEMODE:SetViewCondition(function(author, target)
	return true
end)
GAMEMODE:SetPingCondition(function(author)
	return author:Alive()
end)
GAMEMODE:SetCommandCondition(function(author)
	return true
end)
GAMEMODE:SetInteractionCondition(function(author)
	return author:Alive()
end)
GAMEMODE:SetOnDeath(function(author)
	
end)

GAMEMODE:Register()
