
	local inflexible = inflexible

	function PIS.OpenTextBox(text1, text2, cmd)


		local bg = vgui.Create("DFrame")
		bg:SetSize(400, 130)
		bg:ShowCloseButton(false)
		bg:MakePopup()
		bg:Center()
		bg.lblTitle:SetFont("infl.20")
		bg:SetTitle(text1)
		bg.Paint = function(self,w,h) draw.RoundedBox(0,0,0,w,h,Color(10,10,10,200)) end
		
		local label = vgui.Create("DLabel", bg)
		label:Dock(TOP)
		label:DockMargin(0,5,0,0)
		label:SetWrap(true)
		label:SetText(text2)
		label:SetFont("infl.20")
		label:SetTextColor(Color(255,255,255))
		
		local exit = vgui.Create("DButton", bg)
		exit:SetSize(20, 20)
		exit:SetPos(bg:GetWide() - 22,2)
		exit:SetText("r")
		exit:SetFont("marlett")
		exit:SetTextColor(Color(200,30,30))
		exit.Paint = function() end
		exit.DoClick = function() bg:Close() end

		local myText = vgui.Create("DTextEntry", bg)
		myText:Dock(TOP)
		myText:SetTall(30)
		myText:DockMargin(0,5,0,0)
		myText:SetText("")

		local ybut = vgui.Create( "DButton", bg )
		ybut:Dock(TOP)
		ybut:DockMargin(0,5,0,0)
		ybut:SetTall(30)
		ybut:SetText("Принять")
		ybut:SetFont("infl.20")
		ybut:SetTextColor(Color(255,255,255))
		ybut.Paint = function(self, w, h) draw.RoundedBox(0,0,0,w,h,Color(50,50,50)) end

		ybut.DoClick = function()
			local amt = myText:GetValue()
			local str = cmd.." "..amt
			if amt then
				RunConsoleCommand( "say", str )
			end
			bg:Close()
			textOpen = false
		end
	end

	function PIS.OpenPlyBox( text1, text2, cmd )

		local bg = vgui.Create("DFrame")
		bg:SetSize(400, 130)
		bg:ShowCloseButton(false)
		bg:MakePopup()
		bg:Center()
		bg.lblTitle:SetFont("infl.20")
		bg:SetTitle(text1)
		bg.Paint = function(self,w,h) draw.RoundedBox(0,0,0,w,h,Color(10,10,10,200)) end
		
		local label = vgui.Create("DLabel", bg)
		label:Dock(TOP)
		label:DockMargin(0,5,0,0)
		label:SetWrap(true)
		label:SetText(text2)
		label:SetFont("infl.20")
		label:SetTextColor(Color(255,255,255))
		
		local exit = vgui.Create("DButton", bg)
		exit:SetSize(20, 20)
		exit:SetPos(bg:GetWide() - 22,2)
		exit:SetText("r")
		exit:SetFont("marlett")
		exit:SetTextColor(Color(200,30,30))
		exit.Paint = function() end
		exit.DoClick = function() bg:Close() end

		local hl = vgui.Create( "DComboBox", bg)
		hl:Dock(TOP)
		hl:DockMargin(0,5,0,0)
		hl:SetTall(30)
		for k,v in pairs(player.GetAll()) do hl:AddChoice(v:Name()) end

		hl.OnSelect = function(_,_,value) target = string.Explode(" ", value)[1] end

		local ybut = vgui.Create( "DButton", bg )
		ybut:Dock(TOP)
		ybut:DockMargin(0,5,0,0)
		ybut:SetTall(30)
		ybut:SetText("Принять")
		ybut:SetFont("infl.20")
		ybut:SetTextColor(Color(255,255,255))
		ybut.Paint = function(self, w, h) draw.RoundedBox(0,0,0,w,h,Color(50,50,50)) end
		ybut.DoClick = function()
			local str = cmd.." "..target
			if target then
				RunConsoleCommand( "say", str )
			end
			bg:Close()
			textOpen = false
		end
	end

	function PIS.OpenPlyReasonBox( text1, text2, text3, cmd )

		local bg = vgui.Create("DFrame")
		bg:SetSize(400, 190)
		bg:ShowCloseButton(false)
		bg:MakePopup()
		bg:Center()
		bg.lblTitle:SetFont("infl.20")
		bg:SetTitle(text1)
		bg.Paint = function(self,w,h) draw.RoundedBox(0,0,0,w,h,Color(10,10,10,200)) end
		
		local label = vgui.Create("DLabel", bg)
		label:Dock(TOP)
		label:DockMargin(0,5,0,0)
		label:SetWrap(true)
		label:SetText(text2)
		label:SetFont("infl.20")
		label:SetTextColor(Color(255,255,255))
		
		local exit = vgui.Create("DButton", bg)
		exit:SetSize(20, 20)
		exit:SetPos(bg:GetWide() - 22,2)
		exit:SetText("r")
		exit:SetFont("marlett")
		exit:SetTextColor(Color(200,30,30))
		exit.Paint = function() end
		exit.DoClick = function() bg:Close() end
		
		local target

		local hl = vgui.Create( "DComboBox", bg)
		hl:Dock(TOP)
		hl:DockMargin(0,5,0,0)
		hl:SetTall(30)
		for k,v in pairs(player.GetAll()) do hl:AddChoice(v:Name()) end

		hl.OnSelect = function(_,_,value) target = string.Explode(" ", value)[1] end

		local label2 = vgui.Create("DLabel", bg)
		label2:Dock(TOP)
		label2:DockMargin(0,5,0,0)
		label2:SetWrap(true)
		label2:SetText(text3)
		label2:SetFont("infl.20")
		label2:SetTextColor(Color(255,255,255))

		local myText = vgui.Create("DTextEntry", bg)
		myText:Dock(TOP)
		myText:SetTall(30)
		myText:DockMargin(0,5,0,0)
		myText:SetText("")

		local ybut = vgui.Create( "DButton", bg )
		ybut:Dock(TOP)
		ybut:DockMargin(0,5,0,0)
		ybut:SetTall(30)
		ybut:SetText("Принять")
		ybut:SetFont("infl.20")
		ybut:SetTextColor(Color(255,255,255))
		ybut.Paint = function(self, w, h) draw.RoundedBox(0,0,0,w,h,Color(50,50,50)) end
		ybut.DoClick = function()
			local amt = myText:GetValue()
			local str = cmd.." "..target.." "..amt
			if amt and target then
				RunConsoleCommand( "say", str )
			end
			bg:Close()
			textOpen = false
		end
	end