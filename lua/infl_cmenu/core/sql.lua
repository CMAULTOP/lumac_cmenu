if (SERVER) then return end

function PIS:GetServerID()
	return game.GetIPAddress() or "192.168.0.0:27015"
end

function PIS:CreateSQLTables()
	sql.Query([[
		CREATE TABLE IF NOT EXISTS nexus_psi_settings (
			id TEXT(50),
			settings TEXT(4000),
			PRIMARY KEY (id)
		)
	]])
end

function PIS:LoadSettings(ply)
	local id = sql.SQLStr(PIS:GetServerID())

	local result = sql.Query([[
		SELECT * FROM nexus_psi_settings
		WHERE id = ]] .. id
	)

	if (istable(result) and #result > 0) then
		PIS:SetSettings(ply, util.JSONToTable(result[1].settings))
	end
end

function PIS:SaveSettings(ply)
	local settings = sql.SQLStr(util.TableToJSON(self:GetSettings(ply)))
	local id = sql.SQLStr(PIS:GetServerID())

	local result = sql.Query([[
		SELECT * FROM nexus_psi_settings
		WHERE id = ]] .. id
	)

	if (istable(result) and #result > 0) then
		sql.Query([[
			UPDATE nexus_psi_settings
			SET settings = ]] .. settings .. [[
			WHERE id = ]] .. id
		)
	else
		sql.Query([[
			INSERT INTO nexus_psi_settings (id, settings)
			VALUES (]] .. id .. [[, ]] .. settings .. [[)
		]])
	end
end

hook.Add("Initialize", "PIS.SQLCreation", function()
	PIS:CreateSQLTables()
end)

hook.Add("HUDPaint", "PIS.LoadSettings", function()
	hook.Remove("HUDPaint", "PIS.LoadSettings")

	timer.Simple(3, function()
		PIS:LoadSettings(LocalPlayer())
	end)
end)