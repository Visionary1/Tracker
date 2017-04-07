Class Tracker
{
	__New() {
		this.MouseAlloc := DynaCall("mouse_event", ["iiiii"], 1, _X := "", _Y := "")
		this.MouseSpeed := new SetMouseSpeed(10)

		; this.buffer := new hHookMouse(Func("__hHookMouse"))
		; this.buffer := new hHookKeybd(Func("__hHookKeybd"))
		; this.bufferflag := 0

		; xa := 1
		; ya := -3
		this.offset := {dx: 0.3712
			, x: 0.022916666667 - A_ScreenWidth/2  ;x: (41 + xa * 3) - A_ScreenWidth/2
			, y: 0.064814814815 - A_ScreenHeight/2} ;(85 + ya * 5) - A_ScreenHeight/2}



		this.X1 := (A_ScreenWidth)/2 - (A_ScreenWidth)/5
		this.Y1 := (A_ScreenHeight)/2 - (A_ScreenHeight)/4
		this.X2 := (A_ScreenWidth)/2 + (A_ScreenWidth)/5
		this.Y2 := (A_ScreenHeight)/2 + (A_ScreenHeight)/4
		this.ColorID := 0xFF0013
		this.ColorVariation := 0
	}

	__Delete() {
		this.MouseAlloc := ""
		this.MouseSpeed := ""
	}

	Firing(Key) {
		Return GetKeyState(Key, "P")
	}

	Search() {
		Loop {
			PixelSearch, OutputVarX, OutputVarY, this.X1, this.Y1, this.X2, this.Y2, this.ColorID, this.ColorVariation, Fast RGB
		} Until ErrorLevel = 0

		this.Aim := {X: OutputVarX, Y: OutputVarY}
	}

	Calculate(Sensitivity) {
		x := this.Aim.X + this.offset.x
		y := this.Aim.Y + this.offset.y

		If ( this.AntiShake(x, y) )
			Return

		this.MoveMouse( (x * this.offset.dx * Sensitivity), (y * this.offset.dx * Sensitivity) )
	}

	AntiShake(x, y) {
		static block := {x: 12, y: 6}

		If ( Abs(x) <= block.x ) && ( Abs(y) <= block.y )
			Return 1

		Return 0
	}

	MoveMouse(x, y) {
		Return this.MouseAlloc.(1, Floor(x), Floor(y))
	}
}

#Include %A_LineFile%\..\3rd-party\Class SetMouseSpeed.ahk
