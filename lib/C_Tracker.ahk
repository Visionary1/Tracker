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

		this.AimPixelX := OutputVarX
		this.AimPixelY := OutputVarY

		; snap := new CGdipSnapshot(AimPixelX,AimPixelY,150,150)
		; snap.TakeSnapshot()
		; Loop, 150
		; {
		; 	Tick := snap.PixelScreen[AimPixelX + A_Index, AimPixelY].rgb
		; 	snap.TakeSnapshot(

		; 	;ToolTip, % Tick "`n" this.ColorID
		; 	If ( Tick := !(this.ColorID) )
		; 	{
		; 		snap.SetCoords({w:AimPixelX + A_Index})
		; 		Break
		; 	}
		; }
		
		; snap.SaveSnapshot("Snap.png")
		
		; snap.SaveSnapshot(AimPixelX "x" AimPixelY ".png")

		;Return {X: this.AimPixelX, Y: this.AimPixelY}
	}

	Search_v2()
	{
		snap := new CGdipSnapshot(this.X1, this.Y1, this.X2, this.Y2)
		snap.TakeSnapshot()
		Loop
		{
			x := 0
			y := 0
			foundHadle := snap.PixelSnap[x, y].rgb
			
		} 
		snap.PixelSnap[0,0].rgb
	}

	Calculate_v2(Sensitivity := 7)
	{
		this.headX := 42 + this.xa*3
		this.headY := 80 + this.ya*5
		this.AimPixelX := (this.AimPixelX - A_ScreenWidth/2 + this.headX) / (Sensitivity/10)
		this.AimPixelY := (this.AimPixelY - A_ScreenHeight/2 + this.headY) / (Sensitivity/10)

		If ( Abs(this.AimPixelY) < 3 ) && ( Abs(this.AimPixelX) < 1 )
			Return

		this.MoveMouse(this.AimPixelX, this.AimPixelY)
	}

	Calculate(Sensitivity := 10)
	{
		this.moveToRight := False
		this.headX := 42 + this.xa*3
		this.headY := 90 + this.ya*5 
		this.AimX := this.AimPixelX - A_ScreenWidth/2 + this.headX
		this.AimY := this.AimPixelY - A_ScreenHeight/2 + this.headY
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