function PIS:SetSettings(ply, tbl)
	ply.pingsSettings = tbl
end

function PIS:SetSetting(ply, setting, value, ignoreSave)
	ply.pingsSettings[setting] = value

	if (ignoreSave) then return end

	PIS:SaveSettings(ply)	
end

function PIS:GetSettings(ply)
	if (!ply.pingsSettings) then
		ply.pingsSettings = PIS.Config.DefaultSettings
	end

	return ply.pingsSettings
end

PING_STATUS_DEFAULT = 0
PING_STATUS_CONFIRMED = 1
PING_STATUS_REJECTED = 2

PING_COMMAND_CONFIRM = 0

function PIS:GetKeyName(key)
	if (!isnumber(key)) then return "UNKNOWN KEY" end

	if (key >= MOUSE_MIDDLE) then
		if (key == MOUSE_MIDDLE) then
			return "MIDDLE MOUSE"
		elseif (key == MOUSE_4) then
			return "MOUSE 4"
		elseif (key == MOUSE_5) then
			return "MOUSE 5"
		elseif (key == MOUSE_WHEEL_UP) then
			return "MOUSE WHEEL UP"
		elseif (key == MOUSE_WHEEL_DOWN) then
			return "MOUSE WHEEL DOWN"
		else
			return "UNKNOWN MOUSE"
		end
	else
		return input.GetKeyName(key) and input.GetKeyName(key):upper() or "UNKNOWN KEY"
	end
end


PIS.PingCache = {}
function PIS:GetPingIcon(mat)

	if not PIS.PingCache[mat] then 
		PIS.PingCache[mat] = Material("inflexible/"..mat..".png","smooth")
	end

	return PIS.PingCache[mat]

end
