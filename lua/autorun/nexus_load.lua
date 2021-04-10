Nexus = {}

hook.Run("Nexus.PreLoaded")

if (CLIENT) then
	include("nexus_framework/core/load.lua")
elseif (SERVER) then
	include("nexus_framework/core/load.lua")
	AddCSLuaFile("nexus_framework/core/load.lua")
end

local loader = Nexus:Loader()
loader:SetName("Framework")
loader:SetColor(Color(208, 53, 53))
loader:SetAcronym("Framework")
loader:RegisterAcronym()
loader:SetLoadDirectory("nexus_framework")
loader:Load("core", "SHARED", true, {
	["load.lua"] = true
})
loader:Load("database", "SERVER", true)
loader:Load("vgui", "CLIENT")
loader:Load("vgui/modules", "CLIENT", true)
loader:Load("vgui/components", "CLIENT", true)
loader:Register()

hook.Run("Nexus.PostLoaded")