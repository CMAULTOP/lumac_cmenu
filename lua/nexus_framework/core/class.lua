local CLASS = {}
CLASS.__constructor = function(self, name) end
CLASS.__data = {}
CLASS.__index = CLASS.__data

AccessorFunc(CLASS, "m_acronym", "Acronym")

function CLASS:SetConstructor(func)
	self.__constructor = func
end

function CLASS:Add(name, input)
	self.__data[name] = input
end

function CLASS:Get(name)
	return self.__data[name]
end

function CLASS:TernaryExistance(name, condition, success, failure)
	local lookup = self:Get(name)[condition]
	if (lookup) then
		if (success) then
			success(self, lookup)
		end
	else
		if (failure) then
			failure(self, lookup)
		end
	end
end

function CLASS:Call(name, ...)
	if (self.__data[name]) then
		return self.__data[name](self, ...)
	end
end

function CLASS:Merge(name, input)
	self.__data[name] = table.Merge(self:Get(name), input)
end

function CLASS:Class(name, ...)
	local acronym = self:GetAcronym()

	if (Nexus.Scripts[acronym].classManager[name]) then
		return Nexus.Scripts[acronym].classManager[name]
	end

	Nexus.Scripts[acronym].classManager[name] = self
	self:__constructor(name, ...)
	local col = Nexus.Scripts[acronym]:GetLoadColor()

	return self
end

function Nexus:ClassManager(acronym)
	if (Nexus.Scripts[acronym].classManager) then
		return Nexus.Scripts[acronym].classManager
	end

	local copy = table.Copy(CLASS)
	copy:SetAcronym(acronym)

	Nexus.Scripts[acronym].classManager = copy

	return Nexus.Scripts[acronym].classManager
end