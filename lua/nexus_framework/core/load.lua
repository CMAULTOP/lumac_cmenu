Nexus.Scripts = Nexus.Scripts or {}

local LOADER = {}
LOADER.__index = LOADER

AccessorFunc(LOADER, "m_name", "Name")
AccessorFunc(LOADER, "m_acronym", "Acronym")
AccessorFunc(LOADER, "m_loadDirectory", "LoadDirectory")
AccessorFunc(LOADER, "m_color", "Color")

LOADER.Realms = {
	["SERVER"] = SERVER and include or function() end,
	["CLIENT"] = CLIENT and include or AddCSLuaFile,
	["SHARED"] = function(path)
		if (SERVER) then
			include(path)
			AddCSLuaFile(path)
		else
			include(path)
		end
	end
}

function LOADER:GetRealm(realm)
	realm = self.Realms[realm]

	if (realm) then 
		return realm
	end
end

function LOADER:GetLoadColor()
	return self:GetColor()
end

function LOADER:GetLoadMessage(realm, path)
end

function LOADER:RegisterAcronym()
	Nexus.Scripts[self:GetAcronym()] = self
end

function LOADER:Load(dir, realm, recursive, ignoreFiles)
	ignoreFiles = ignoreFiles or {}
	local path = self:GetLoadDirectory()
	if (!string.EndsWith(path, "/")) then path = path .. "/" end
	if (!string.EndsWith(dir, "/")) then dir = dir .. "/" end
	
	realm = realm:upper()
	local realmFunc = self:GetRealm(realm)
	if (!realmFunc) then return end

	local files, folders = file.Find(path .. dir .. "*", "LUA")

	for fileIndex, file in ipairs(files) do
		if (ignoreFiles[file]) then continue end

		local path = path .. dir .. file
		self:GetLoadMessage(realm, path)
		
		realmFunc(path)
	end

	if (recursive) then
		for folderIndex, folder in ipairs(folders) do
			self:Load(dir .. folder, realm, recursive, ignoreFiles)
		end
	end
end

function LOADER:Register()
	local time = SysTime() - self.start
	time = math.Round(time, 4) .. "s"
end

function Nexus:Loader()
	local tbl = table.Copy(LOADER)
	tbl.start = SysTime()

	return tbl
end