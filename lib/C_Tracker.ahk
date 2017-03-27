Class Tracker
{
	__New(Resolution := "High")
	{
		this.MouseAlloc := DynaCall("mouse_event", ["iiiii"], 1, _X := "", _Y := "", 0, 0)

		If (Resolution == "High")
		{
			this.xa := 1
			this.ya := -3
			this.LtoRaddendOffset := 1.2

			;this.xrange := 1
			;this.yrange := 1
			;this.X1 := 0 + (A_ScreenWidth * (this.xrange/10))
			this.X1 := (A_ScreenWidth)/2 - (A_ScreenWidth)/5
			;this.Y1 := 0 + (A_ScreenHeight * (this.yrange/10))-40
			this.Y1 := (A_ScreenHeight)/2 - (A_ScreenHeight)/4
			;this.X2 := A_ScreenWidth - (A_ScreenWidth * (this.xrange/10))
			this.X2 := (A_ScreenWidth)/2 + (A_ScreenWidth)/5
			;this.Y2 := A_ScreenHeight - (A_ScreenHeight * (this.yrange / 10))-75
			this.Y2 := (A_ScreenHeight)/2 + (A_ScreenHeight)/4
			this.ColorID := 0xFF0013

			; 0x960000 ~ 0xFF4B5A
			this.ColorVariation := 0
		}
	}

	; Debug(Version := 1)
	; {
	; 	If (Version = 1)
	; 	{
	; 		this.Search(), this.Calculate(), this.Aim()
	; 	}
	; 	Else If (Version = 2)
	; 	{
	; 		this.Search(), this.Calculate_v2()
	; 	}
	; }

	Firing(Key)
	{
		Return GetKeyState(Key, "P")
	}

	Search()
	{
		Loop {
			PixelSearch, OutputVarX, OutputVarY, this.X1, this.Y1, this.X2, this.Y2, this.ColorID, this.ColorVariation, Fast RGB
		} Until ErrorLevel = 0

		this.Aim := {X: OutputVarX, Y: OutputVarY}

	}

	PixelSeach()
	{
		snap := new CGdipSnapshot(this.X1, this.Y1, this.X2 - this.X1, this.Y2 - this.Y1)
		snap.TakeSnapshot()

		x := this.X1
		y := this.Y1
		Loop
		{
			x++
			If ( x = this.X2 - this.X1 ) {
				x := this.X1
				y++
			}
			snap.PixelScreen[x, y].rgb
		} Until snap.PixelScreen[x, y].rgb = this.ColorID
		
		MsgBox, % snap.PixelScreen[x, y].rgb
		MouseMove, x, y
	}

	Search_v2()
	{
		this.Search()

		MsgBox, % this.Aim.X "x" this.Aim.Y
		Loop
		{
			PixelGetColor, OutputVar, this.Aim.X + A_Index, this.Aim.Y, RGB
			finalX := this.Aim.X + A_Index
		} Until OutputVar != 0xFF0013

		MsgBox, % finalX

		snap := new CGdipSnapshot(this.Aim.X, this.Aim.Y, finalX - this.Aim.X, this.Y2 - this.Y1)
		snap.TakeSnapshot()
		snap.PixelScreen[x, y].rgb
		;snap.SaveSnapshot("myfile.png")		; PNG format


		/*
		x := this.X1, y := this.Y1
		snap := new CGdipSnapshot(this.X1, this.Y1, this.X2 - this.X1, this.Y2 - this.Y1)
		snap.TakeSnapshot()

		; get the coordinate of left health bar
		found := snap.PixelScreen[x, y].rgb
		While, found != this.ColorID
		{
			x++
			If ( x = this.X2 )
			{
				y++
				x := this.X1
			}
			If ( y = this.Y2 )
				Break

			MouseMove, x, y
			;ToolTip, % x "x" y "`n" snap.PixelSnap[x, y].rgb
			found := snap.PixelSnap[x, y].rgb
		}
		MouseMove, x, y
		*/
	}

	isRed(Var)
	{
		; static min := {R: 150, G: 0, B:= 0}, max := {R: 255, G: 75, B:= 90}

		; Var := SubStr(Var, 3)


		; if (pixel.rgbRed >= minR && pixel.rgbRed <= maxR &&
		; 	pixel.rgbGreen >= minG && pixel.rgbGreen <= maxG &&
		; 	pixel.rgbBlue >= minB && pixel.rgbBlue <= maxB)
		; {
		; 	return true;
		; }
		; else
		; 	return false;
	}

	Calculate_v2(Sensitivity := 7)
	{
		this.headX := 42 + this.xa*3
		this.headY := 80 + this.ya*5
		this.Aim.X := (this.Aim.X - A_ScreenWidth/2 + this.headX) / (Sensitivity/10)
		this.Aim.Y := (this.Aim.Y - A_ScreenHeight/2 + this.headY) / (Sensitivity/10)

		If ( Abs(this.Aim.Y) < 3 ) && ( Abs(this.Aim.X) < 1 )
			Return

		this.MoveMouse(this.Aim.X, this.Aim.Y)
	}

	Calculate(Sensitivity := 10)
	{
		this.moveToRight := False
		this.headX := 42 + this.xa*3
		this.headY := 90 + this.ya*5 
		this.AimX := this.Aim.X - A_ScreenWidth/2 + this.headX
		this.AimY := this.Aim.Y - A_ScreenHeight/2 + this.headY
		If ( this.AimX+4 > 0 ) {
			this.DirX := Sensitivity / 10
			this.moveToRight := True
		}
		Else If ( this.AimX+4 < 0 )
			this.DirX := (-Sensitivity) / 10
		If ( this.AimY+2 > 0 )
			this.DirY := Sensitivity / 10
		Else If ( this.AimY+2 < 0 )
			this.DirY := (-Sensitivity) / 10

		this.AimOffsetX := this.AimX * this.DirX
		this.AimOffsetY := this.AimY * this.DirY

		this.MoveX := this.AimOffsetX * this.DirX + ( (this.moveToRight) ? (this.LtoRaddendOffset) : 0 )
		this.MoveY := this.AimOffsetY * this.DirY
		this.MoveMouse(this.MoveX, this.MoveY)
	}

	MoveMouse(X, Y)
	{
		Return this.MouseAlloc.(1, X, Y)
	}
}

#Include %A_LineFile%\..\CGdipSnapshot.ahk