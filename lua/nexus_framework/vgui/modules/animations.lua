local framework = Nexus:ClassManager("Framework")
local anim = framework:Class("Animations")
local settings = framework:Class("Settings")

anim:Add("Eases", {
	Default = function(t, b, c, d)
		t = t / d
		local ts = t * t
		local tc = ts * t

		return b + c * (-2 * tc + 3 * ts)
	end
})
anim:Add("Ease", function(self, ease, ...)
	return self:Get("Eases")[ease](...)
end)
anim:Add("LerpColor", function(self, fraction, from, to)
	return Color(
		Lerp(fraction, from.r, to.r),
		Lerp(fraction, from.g, to.g),
		Lerp(fraction, from.b, to.b),
		Lerp(fraction, from.a or 255, to.a or 255)
	)
end)
anim:Add("AnimateColor", function(self, pnl, var, toCol, duration, ease, callback)
	duration = duration or 0.2
	ease = ease or settings:Call("GetEase")

	local col = pnl[var]
	local anim = pnl:NewAnimation(duration)
	anim.Color = toCol
	anim.Think = function(anim, pnl, fraction)
		local _fract = self:Call("Ease", ease, fraction, 0, 1, 1)

		if (!anim.StartColor) then
			anim.StartColor = col
		end

		local newCol = self:Call("LerpColor", _fract, anim.StartColor, anim.Color)
		pnl[var] = newCol
	end
	anim.OnEnd = function()
		if (callback) then callback(pnl) end
	end
end)
