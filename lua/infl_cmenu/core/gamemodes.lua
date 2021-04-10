PIS.Gamemodes = {}

local GAMEMODE = {}

AccessorFunc(GAMEMODE, "m_name", "Name")
AccessorFunc(GAMEMODE, "m_id", "ID")
AccessorFunc(GAMEMODE, "m_viewCondition", "ViewCondition")
AccessorFunc(GAMEMODE, "m_pingCondition", "PingCondition")
AccessorFunc(GAMEMODE, "m_commandCondition", "CommandCondition")
AccessorFunc(GAMEMODE, "m_interactionCondition", "InteractionCondition")
AccessorFunc(GAMEMODE, "m_detectionCondition", "DetectionCondition")
AccessorFunc(GAMEMODE, "m_players", "Players")
AccessorFunc(GAMEMODE, "m_onDeath", "OnDeath")
AccessorFunc(GAMEMODE, "m_displaySubtitle", "SubtitleDisplay")

function GAMEMODE:Register()
	PIS.Gamemodes[self:GetID()] = self
end

function PIS:GetGamemode()
	return table.Copy(GAMEMODE)
end