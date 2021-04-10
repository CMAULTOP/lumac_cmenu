local framework = Nexus:ClassManager("Framework")
local _draw = framework:Class("Draw")
local anim = framework:Class("Animations")
local panels = framework:Class("Panels")

-- Register panel
local PANEL = {}

local rightClick = Material("inflexible/rmb.png","smooth")
local leftClick = Material("inflexible/lmb.png","smooth")

local soundHover = Sound("ping_system/hover2.wav")
local soundSelect = Sound("ping_system/accept2.wav")
local yellow = Color(253, 177, 3)
local red = Color(223, 70, 24)
local green = Color(129, 163, 19)

local surface = surface 

local sin = math.sin 
local cos = math.cos 
local mrad = math.rad 
local abs = math.abs

	inflexible = inflexible or {}
	inflexible.hud = inflexible.hud or {}
	
	local surface = surface
	local Lerp = Lerp 
	local draw = draw
	local math = math

	local shadow = 1
	local ico_wide = 32
	local font = "base"
	local meta = FindMetaTable("Player")

	local black = Color(0,0,0,200)
	local lp = LocalPlayer

	
	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	local function ss(px) return ScreenScale(px)/3 end 

	function inflexible.hud:CreateFont(name,size,font,weight,scale)
		scale = scale or false 
		if scale then size = ss(size) end

		surface.CreateFont("infl.hud."..name,{font = font, size = size, weight = weight, extended = true})
		surface.CreateFont("infl.hud."..name.."_blur",{font = font, size = size, weight = weight, extended = true, blursize = 1})
	end

	function inflexible.hud:GetFont(name) return "infl.hud."..name,"infl.hud."..name.."_blur" end

	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	function inflexible.hud:DrawText(text,font,x,y,col,xa,ya)
		local font_def,font_blur = inflexible.hud:GetFont(font)
		xa = xa or 0
		ya = ya or 0

		draw.SimpleText(text,font_blur,x+shadow,y+shadow,ColorAlpha(color_black,col.a),xa,ya)
		return draw.SimpleText(text,font_def,x,y,col,xa,ya)
	end

	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	function inflexible.LerpColor(t,col1,col2)
		return Color    (
						Lerp(t,col1.r,col2.r),
						Lerp(t,col1.g,col2.g),
						Lerp(t,col1.b,col2.b),
						Lerp(t,col1.a,col2.a)
						)
	end

	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

function PANEL:SetContents(name)
	local settings = PIS:GetSettings(LocalPlayer())

	self.SectionsTbl = {}
	self.ContentType = name 

	for i, v in pairs(self.SectionsTbl) do
		if (!ispanel(v)) then continue end

		v:Remove()
	end

	if name == "pings" then
		for i, v in ipairs(PIS.Config.PingsSorted) do
			local ping = PIS.Config.Pings[v]
			if (!ping) then continue end
			if ping.customcheck and not ping.customcheck(LocalPlayer()) then continue end
			self:AddSection(ping.text, ping.mat, settings.WheelMonochrome != 1 and PIS.Config.WheelColors[settings.WheelMonochrome][2] or ping.color, ping.commands, v)
		end
	elseif name == "commands" and istable(self.DisplayCommand) then
		local ping = self.DisplayCommand
		for k,t in pairs(ping) do if t.customcheck and not t.customcheck(LocalPlayer()) then continue end self:AddSection(t.name, t.mat, settings.WheelMonochrome != 1 and PIS.Config.WheelColors[settings.WheelMonochrome][2] or t.col, t.func, t.name) end
	end

	self.Sections = #self.SectionsTbl
end

function PANEL:PerformLayout(w, h)
	local sectionSize = 360 / self.Sections
	local rad = self.Radius * 0.4
	for i, v in ipairs(self.SectionsTbl) do
		if (!ispanel(v)) then continue end

		local ang = (i - 1) * sectionSize
		ang = mrad(ang)
		local size = self.Sections > 12 and self.Radius * 2 / self.Sections or (56 * self.Settings.WheelScale)
		if (self.selectedArea and self.selectedArea + 1 == i) then
			size = size * 1.285
		end
		local r = self.Radius - rad / 2
		local sin = sin(ang) * r
		local cos = cos(ang) * r
		local x = self.Center.X - size / 2 + sin
		local y = self.Center.Y - size / 2 - cos
		
		v:SetSize(size, size)
		v:SetPos(x, y)
	end
end

function PANEL:Init()
	PIS.RadialMenu = self

	self.Settings = PIS:GetSettings(LocalPlayer())

	surface.CreateFont("Nexus.PingSystem.Ping", {
		font = "Roboto",
		size = math.Round(46 * self.Settings.WheelScale),
		weight = 600
	})

	surface.CreateFont("Nexus.PingSystem.Name", {
		font = "Roboto",
		size = math.Round(30 * self.Settings.WheelScale),
		weight = 600
	})

	surface.CreateFont("Nexus.PingSystem.Info", {
		font = "Roboto",
		size = math.Round(26 * self.Settings.WheelScale)
	})

	self.Radius = 325 * self.Settings.WheelScale

	self.Center = {
		X = ScrW() / 2,
		Y = ScrH() / 2
	}

	self.SectionsTbl = {}

	self:SetContents("pings")

	self.CircleColor = Color(0, 0, 0, 0)
	self:SetAlpha(0)
	self:AlphaTo(255, 0.2)

	self.selectable = true

	self:MakePopup()
	self:SetKeyboardInputEnabled(false)

	self.InnerArcColor = color_white
	self.OuterArcColor = color_white

	local rad = self.Radius * 0.4

	self.MainCircle = _draw:Call("PrecacheCircle",self.Center.X, self.Center.Y, self.Radius,360,90)
	self.MainArc = _draw:Call("PrecacheArc",self.Center.X, self.Center.Y, self.Radius,rad, 0, 360, 1)
	self.MainArc2 = _draw:Call("PrecacheArc",self.Center.X, self.Center.Y, self.Radius - rad, 3, 0, 360, 1)
	--_draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius - rad, 3, 0, 360, 1, Color(188, 188, 188))
	--_draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius, rad, 0, 360, 1, Color(0, 0, 0, 150))
	--_draw:Call("Circle", self.Center.X, self.Center.Y, self.Radius, 90, Color(0, 0, 0, 150))

end

function PANEL:Select(id)
	if (self.FadingOut) then return end

	surface.PlaySound(soundSelect)

	local tbl = self.SectionsTbl[id + 1]
	if isfunction(tbl.command) then tbl.command() self:Close() return 
	else 
		self.DisplayCommand = self.SectionsTbl[self.selectedArea+1].command
		self:SetContents("commands")
		self.Command = self.selectedTbl
		self.selectedTbl = self.SectionsTbl[self.selectedArea + 1] or self.SectionsTbl[1]
	end

	self.selectable = false 
	timer.Simple(.1,function() if ValidPanel(self) then self.selectable = true end end)

end

function PANEL:AddSection(name, mat, col, command, id)
	table.insert(self.SectionsTbl, {
		name = name,
		mat = mat,
		col = col,
		command = command,
		id = id
	})
end

function PANEL:Think()

		commandKeyDown = input.IsMouseDown(MOUSE_RIGHT)
		if commandKeyDown and self.selectable and self.ContentType == "commands" then 


		self:SetContents("pings")
		self.Command = function() end
		self.selectedTbl = self.SectionsTbl[self.selectedArea+1]
		self.DisplayCommand = nil
		surface.PlaySound(soundHover)
		timer.Simple(.1,function() if ValidPanel(self) then self.selectable = true end end)

		end

	if not input.IsMouseDown(MOUSE_LEFT) then return end
	if self.selectedArea and self.HasMovedSlightly and self.selectable then
		self:Select(self.selectedArea)

		return
	end

end


function PANEL:Close()
	if (self.FadingOut) then return end

	self.FadingOut = true
	self:AlphaTo(0, 0.2, nil, function()
		self:Remove()
	end)
end

function PANEL:Paint(w, h)
	local rad = self.Radius * 0.4
	local settings = PIS:GetSettings(LocalPlayer())

	if (settings.WheelBlur == 1) then
		_draw:Call("MaskInclude", function()
			_draw:Call("CachedArc",self.MainArc,Color(0, 0, 0, 150))
		end, function()
			_draw:Call("Blur", self, 6, 4)

			draw.NoTexture()
			_draw:Call("CachedCircle",self.MainCircle,Color(0, 0, 0, 150))
			--_draw:Call("Circle", self.Center.X, self.Center.Y, self.Radius, 90, Color(0, 0, 0, 150))
		end)
	else
		_draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius, rad, 0, 360, 1, Color(0, 0, 0, 245))
	end

	_draw:Call("CachedArc",self.MainArc2,Color(188, 188, 188))
	--_draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius - rad, 3, 0, 360, 1, Color(188, 188, 188))

	-- Found somewhere else, don't remember where but it's a workshop addon
	local cursorAng = 180 - ( -- 360
		math.deg(
			math.atan2(
				gui.MouseX() - self.Center.X, 
				gui.MouseY() - self.Center.Y
			)
		)
		--+ 180
	)

	if (self.HasMovedSlightly) then
		_draw:Call("Circle", self.Center.X, self.Center.Y, self.Radius - rad - 3, 90, self.CircleColor)
		local sectionSize = 360 / self.Sections
		
		local selectedArea = abs(cursorAng + sectionSize / 2) / sectionSize
		selectedArea = math.floor(selectedArea)
		if (selectedArea >= self.Sections) then
			selectedArea = 0
		end

		if (self.selectedArea != selectedArea) then
			if (#self.SectionsTbl > 0) then
				surface.PlaySound(soundHover)
			end

			self.selectedTbl = self.SectionsTbl[selectedArea + 1]

			self:InvalidateLayout()
		end

		self.InnerArcColor = inflexible.LerpColor(FrameTime()*10,self.InnerArcColor,self.selectedTbl.col)
		self.OuterArcColor = self.selectedTbl.col
	
		self.selectedArea = selectedArea
		local selectedAng = selectedArea * sectionSize
		local outerArcScale = math.Round(4 * self.Settings.WheelScale)
		_draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius + outerArcScale, outerArcScale, 90 - selectedAng - sectionSize / 2, 90 - selectedAng + sectionSize / 2, 1, self.OuterArcColor)
		_draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius, rad, 90 - selectedAng - sectionSize / 2, 90 - selectedAng + sectionSize / 2, 1, Color(0, 0, 0, 180))

		local innerArcScale = math.Round(6 * self.Settings.WheelScale)
		_draw:Call("Arc", self.Center.X, self.Center.Y, self.Radius - rad + innerArcScale * 2, innerArcScale, -cursorAng - 21 + 90 - 0, -cursorAng + 90 + 21, 1, self.InnerArcColor)

		if (self.selectedTbl) then
			inflexible.hud:DrawText(self.selectedTbl.name, "notify", w / 2, h / 2 - 24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			--_draw:Call("ShadowText",self.selectedTbl.name, "Nexus.PingSystem.Name", w / 2, h / 2 - 24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

			local str = istable(self.selectedTbl.command) and "Открыть меню" or "Выбрать"
			surface.SetFont("Nexus.PingSystem.Info")
			local tw, th = surface.GetTextSize(str)
			local iconSize = th
			local x = w / 2 - iconSize / 2 - tw / 2 - 4
			local y = h / 2 + 20 + th / 2

			surface.SetDrawColor(color_white)
			surface.SetMaterial(leftClick)
			surface.DrawTexturedRect(x, y, iconSize, iconSize)

			inflexible.hud:DrawText(str, "icon", x + iconSize + 8, y + 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			--_draw:Call("ShadowText", str, "Nexus.PingSystem.Info", x + iconSize + 8, y + 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			if self.ContentType == "commands" then 

			local str = "Назад"
			surface.SetFont("Nexus.PingSystem.Info")
			local tw, th = surface.GetTextSize(str)

			local iconSize = th
			local x = w / 2 - iconSize / 2 - tw / 2 - 4
			local y = h / 2 + (56 * self.Settings.WheelScale) + th / 2
			surface.SetDrawColor(color_white)
			surface.SetMaterial(rightClick)
			surface.DrawTexturedRect(x, y, iconSize, iconSize)
			inflexible.hud:DrawText(str,"icon",x + iconSize + 8, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			--_draw:Call("ShadowText", str, "Nexus.PingSystem.Info", x + iconSize + 8, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)			


			end

			end
	else
		
		local xDist = abs(self.Center.X - gui.MouseX())
		local yDist = abs(self.Center.Y - gui.MouseY())
		-- Euclidean distance
		local dist = math.sqrt(xDist ^ 2 + yDist ^ 2)
		if (dist > 20) then
			self.HasMovedSlightly = true
			self:Anim():Call("AnimateColor", self, "CircleColor", Color(0, 0, 0, 200))
		end
	end

	local sectionSize = 360 / self.Sections
	for i, v in ipairs(self.SectionsTbl) do
		if (ispanel(v)) then continue end

		local ang = (i - 1) * sectionSize
		ang = mrad(ang)
		local size = (56 * self.Settings.WheelScale)
		if (self.selectedArea and self.selectedArea + 1 == i) then
			size = (72 * self.Settings.WheelScale)
		end
		local r = self.Radius - rad / 2
		local sin = sin(ang) * r
		local cos = cos(ang) * r
		local x = self.Center.X - size / 2 + sin
		local y = self.Center.Y - size / 2 - cos
		
		surface.SetMaterial(PIS:GetPingIcon(v.mat))
		surface.SetDrawColor(v.col or color_white)
		surface.DrawTexturedRect(x, y, size, size)
	end
end

vgui.Register("PIS.Radial", PANEL)

function PIS:OpenRadialMenu()
	local frame = panels:Call("Create", "PIS.Radial")
	frame:SetSize(ScrW(), ScrH())
	frame:SetPos(0, 0)
end

local KeyDown

hook.Add("OnContextMenuOpen","infl.Cmenu",function() if not ValidPanel(PIS.RadialMenu) then PIS:OpenRadialMenu() end end)
hook.Add("OnContextMenuClose","infl.Cmenu",function() if ValidPanel(PIS.RadialMenu) then PIS.RadialMenu:Close() end end)

	inflexible.hud:CreateFont("icon",26,"Roboto",400)
	inflexible.hud:CreateFont("base",36,"Consolas",700)
	inflexible.hud:CreateFont("small",20,"Roboto",700)
	inflexible.hud:CreateFont("notify",26,"Roboto",700)
	inflexible.hud:CreateFont("safezone",40,"Roboto",700)
	inflexible.hud:CreateFont("safezone_small",30,"Roboto",500)
	inflexible.hud:CreateFont("entitydisplay",170,"Roboto",1600)
	inflexible.hud:CreateFont("wsel",24,"Roboto",600)
	inflexible.hud:CreateFont("wsel-small",19,"Roboto",500)
	inflexible.hud:CreateFont("ban",52,"Consolas",800)


--[[
hook.Add("CreateMove", "PIS.CircleMenu", function()
	local settings = PIS:GetSettings(LocalPlayer())
	local code = settings.WheelKey
	local isDown
	local isUp
	if (code >= MOUSE_MIDDLE) then
		isDown = input.WasMousePressed(code)
		isUp = input.WasMouseReleased(code)
	else
		isDown = input.WasKeyPressed(code)
		isUp = input.WasKeyReleased(code)
	end

	if (KeyDown and !isUp and !isDown) then
		if (CurTime() - KeyDown >= settings.WheelDelay) then
			local focus = vgui.GetKeyboardFocus()
			if (!IsValid(focus) and !IsValid(PIS.RadialMenu)) then
				PIS:OpenRadialMenu()
			end
		end
	elseif (!KeyDown and isDown) then
		KeyDown = CurTime()
	elseif (KeyDown and isUp) then
		KeyDown = nil
	end

	if (IsValid(PIS.RadialMenu)) then
		local rightClick = input.WasMouseReleased(MOUSE_RIGHT)
		local leftClick = input.WasMouseReleased(MOUSE_LEFT)
		if (rightClick) then
			hook.Run("Nexus.PingSystem.RightClick")
		elseif (leftClick) then
			hook.Run("Nexus.PingSystem.LeftClick")
		end
	end
end)
]]