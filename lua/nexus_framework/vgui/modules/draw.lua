
local framework = Nexus:ClassManager("Framework")
local _draw = draw
local draw = framework:Class("Draw")

local sin = math.sin 
local cos = math.cos 
local rad = math.rad

local surface = surface 
local render = render 

-- Reformatted https://gist.github.com/theawesomecoder61/d2c3a3d42bbce809ca446a85b4dda754
draw:Add("Arc", function(self, cx, cy, radius, thickness, startang, endang, roughness,color)
	surface.SetDrawColor(color)

	local arc = self:Call("PrecacheArc", 
		cx,
		cy,
		radius,
		thickness,
		startang,
		endang,
		roughness
	)

	for i, vertex in ipairs(arc) do
		surface.DrawPoly(vertex)
	end
end)

draw:Add("PrecacheArc", function(self, cx, cy, radius, thickness, startang, endang, roughness)
	local triarc = {}
	-- local deg2rad = math.pi / 180
	
	-- Define step
	local roughness = math.max(roughness or 1, 1)
	local step = roughness
	
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	
	if startang > endang then
		step = math.abs(step) * -1
	end
	
	-- Create the inner circle's points.
	local inner = {}
	local r = radius - thickness
	for deg=startang, endang, step do
		local rad = rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(cos(rad)*r), cy+(-sin(rad)*r)
		table.insert(inner, {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end	
	
	-- Create the outer circle's points.
	local outer = {}
	for deg=startang, endang, step do
		local rad = rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(cos(rad)*radius), cy+(-sin(rad)*radius)
		table.insert(outer, {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end	
	
	-- Triangulize the points.
	for tri=1,#inner*2 do -- twice as many triangles as there are degrees.
		local p1,p2,p3
		p1 = outer[math.floor(tri/2)+1]
		p3 = inner[math.floor((tri+1)/2)+1]
		if tri%2 == 0 then --if the number is even use outer.
			p2 = outer[math.floor((tri+1)/2)]
		else
			p2 = inner[math.floor((tri+1)/2)]
		end
	
		table.insert(triarc, {p1,p2,p3})
	end
	
	-- Return a table of triangles to draw.
	return triarc
end)

draw:Add("CachedArc",function(self,arc,col)

	surface.SetDrawColor(col)
	for i, vertex in ipairs(arc) do
		surface.DrawPoly(vertex)
	end	

end)

-- https://forum.facepunch.com/gmoddev/mtdf/I-need-help-making-a-blurred-derma-panel/1/
local blur = Material("pp/blurscreen")
draw:Add("Blur", function(self, panel, intensivity, d)
	local x, y = panel:LocalToScreen()
	surface.SetDrawColor(color_white)
	surface.SetMaterial(blur)

	for i = 1, intensivity do
		blur:SetFloat("$blur", (i / d) * intensivity)
		blur:Recompute()

		render.UpdateScreenEffectTexture()

		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
	end
end)
-- Somewhere on facepunch
draw:Add("BlurHUD", function(self, x, y, w, h, amt)
	local X, Y = 0,0

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(blur)

	for i = 1, amt or 5 do
		blur:SetFloat("$blur", (i / 3) * (5))
		blur:Recompute()

		render.UpdateScreenEffectTexture()

		render.SetScissorRect(x, y, x+w, y+h, true)
			surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
		render.SetScissorRect(0, 0, 0, 0, false)
	end
end)

-- Inflexible
draw:Add("PrecacheCircle", function(self, sx, sy, radius, vertexCount, angle)
	local vertices = {}
	local ang = -rad(angle or 0)
	local c = cos(ang)
	local s = sin(ang)
	for i = 0, 360, 360 / vertexCount do
		local radd = rad(i)
		local x = cos(radd)
		local y = sin(radd)

		local tempx = x * radius * c - y * radius * s + sx
		y = x * radius * s + y * radius * c + sy
		x = tempx

		vertices[#vertices + 1] = {
			x = x, 
			y = y, 
			u = u, 
			v = v 
		}
	end

	return vertices 
end)

-- Found on some GitHub repository a long time ago
-- Inflexible редакция
draw:Add("Circle", function(self, sx, sy, radius, vertexCount, color, angle)
	
	local vertices = self:Call("PrecacheCircle", 
		sx,
		sy,
		radius,
		vertexCount,
		angle
	)

	if vertices and #vertices > 0 then
		_draw.NoTexture()
		surface.SetDrawColor(color)
		surface.DrawPoly(vertices)
	end
end)

-- Inflexible
draw:Add("CachedCircle", function(self,circle,color)
	if circle and #circle > 0 then
		_draw.NoTexture()
		surface.SetDrawColor(color)
		surface.DrawPoly(circle)
	end
end)

draw:Add("ShadowText", function(self, str, font, x, y, col, xAlign, yAlign)
	_draw.SimpleText(str, font, x - 1, y - 1, color_black, xAlign, yAlign)
	_draw.SimpleText(str, font, x - 1, y + 1, color_black, xAlign, yAlign)
	_draw.SimpleText(str, font, x + 1, y - 1, color_black, xAlign, yAlign)
	_draw.SimpleText(str, font, x + 1, y + 1, color_black, xAlign, yAlign)
	
	_draw.SimpleText(str, font, x, y, col, xAlign, yAlign)
end)

-- https://github.com/Bo98/garrysmod-util/blob/master/lua/autorun/client/gradient.lua
-- Gradient helper functions
-- By Bo Anderson
-- Licensed under Mozilla Public License v2.0
local mat_white = Material("vgui/white")
draw:Add("SimpleLinearGradient", function(self, x, y, w, h, startColor, endColor, horizontal)
	self:Call("LinearGradient", x, y, w, h, { {offset = 0, color = startColor}, {offset = 1, color = endColor} }, horizontal)
end)

draw:Add("LinearGradient", function(self, x, y, w, h, stops, horizontal)
	if #stops == 0 then
		return
	elseif #stops == 1 then
		surface.SetDrawColor(stops[1].color)
		surface.DrawRect(x, y, w, h)
		return
	end

	table.SortByMember(stops, "offset", true)

	render.SetMaterial(mat_white)
	mesh.Begin(MATERIAL_QUADS, #stops - 1)
	for i = 1, #stops - 1 do
		local offset1 = math.Clamp(stops[i].offset, 0, 1)
		local offset2 = math.Clamp(stops[i + 1].offset, 0, 1)
		if offset1 == offset2 then continue end

		local deltaX1, deltaY1, deltaX2, deltaY2

		local color1 = stops[i].color
		local color2 = stops[i + 1].color

		local r1, g1, b1, a1 = color1.r, color1.g, color1.b, color1.a
		local r2, g2, b2, a2
		local r3, g3, b3, a3 = color2.r, color2.g, color2.b, color2.a
		local r4, g4, b4, a4

		if horizontal then
			r2, g2, b2, a2 = r3, g3, b3, a3
			r4, g4, b4, a4 = r1, g1, b1, a1
			deltaX1 = offset1 * w
			deltaY1 = 0
			deltaX2 = offset2 * w
			deltaY2 = h
		else
			r2, g2, b2, a2 = r1, g1, b1, a1
			r4, g4, b4, a4 = r3, g3, b3, a3
			deltaX1 = 0
			deltaY1 = offset1 * h
			deltaX2 = w
			deltaY2 = offset2 * h
		end

		mesh.Color(r1, g1, b1, a1)
		mesh.Position(Vector(x + deltaX1, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r2, g2, b2, a2)
		mesh.Position(Vector(x + deltaX2, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r3, g3, b3, a3)
		mesh.Position(Vector(x + deltaX2, y + deltaY2))
		mesh.AdvanceVertex()

		mesh.Color(r4, g4, b4, a4)
		mesh.Position(Vector(x + deltaX1, y + deltaY2))
		mesh.AdvanceVertex()
	end
	mesh.End()
end)

-- Based off the stencil operations found in the code in @vgui/components/avatar.lua
draw:Add("MaskInclude", function(self, maskFunc, renderFunc)
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.DepthRange(0, 1)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	maskFunc()

	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)

	renderFunc()

	render.DepthRange(0, 1)
	render.SetStencilEnable(false)
	render.ClearStencil()
end)

draw:Add("MaskExclude", function(self, maskFunc, renderFunc)
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.DepthRange(0, 1)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	maskFunc()

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(0)

	renderFunc()

	render.DepthRange(0, 1)
	render.SetStencilEnable(false)
	render.ClearStencil()
end)