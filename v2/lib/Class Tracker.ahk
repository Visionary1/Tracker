Class Tracker
{
	__New() {
		this.Mouse := []
		this.Mouse.Move := DynaCall("mouse_event", ["iiiii"], 1, _X := "", _Y := "")
		this.Mouse.Speed := new SetMouseSpeed(10)
		;this.MouseAlloc := DynaCall("mouse_event", ["iiiii"], 1, _X := "", _Y := "")
		;this.MouseSpeed := new SetMouseSpeed(10)

		; this.buffer := new hHookMouse(Func("__hHookMouse"))
		; this.buffer := new hHookKeybd(Func("__hHookKeybd"))
		; this.bufferflag := 0

		; xa := 1
		; ya := -3
		this.offset := {dx: 0.3712
			, x: -0.47708333334 * A_ScreenWidth  ;x: (41 + xa * 3) - A_ScreenWidth/2
			, y: -0.43518518519 * A_ScreenHeight} ;(85 + ya * 5) - A_ScreenHeight/2}

		this.X1 := Ceil(A_ScreenWidth * 0.3) ;A_ScreenWidth/2 - A_ScreenWidth/5
		this.Y1 := Ceil(A_ScreenHeight * 0.25) ;A_ScreenHeight/2 - A_ScreenHeight/4
		this.X2 := Ceil(A_ScreenWidth *0.7) ;A_ScreenWidth/2 + A_ScreenWidth/5
		this.Y2 := Ceil(A_ScreenHeight * 0.75) ;A_ScreenHeight/2 + A_ScreenHeight/4
		this.ColorID := 0xFF0013
		this.ColorVariation := 0
	}

	__Delete() {
		this.Delete("Mouse")
	}

	Firing(Key) {
		Return GetKeyState(Key, "P")
	}

	Search() {

		; Loop {
		; 	PixelSearch, OutputVarX, OutputVarY, this.X1, this.Y1, this.X2, this.Y2, this.ColorID, this.ColorVariation, Fast RGB
		; } Until ErrorLevel = 0

		PixelSearch, OutputVarX, OutputVarY, this.X1, this.Y1, this.X2, this.Y2, this.ColorID, this.ColorVariation, Fast RGB
		this.Aim := {x: OutputVarX, y: OutputVarY}
		Return ErrorLevel
	}

	Calculate(Sensitivity) {

		If ( this.Search() != 0 )
			Return

		;Critical

		x := this.Aim.x + this.offset.x
		y := this.Aim.y + this.offset.y

		If ( this.AntiShake(x, y) )
			Return

		If ( Abs(x) < 12 ) && ( Abs(y) < 8 )
		{
			Return this.MoveMouse( (x * this.offset.dx * Sensitivity), (y * this.offset.dx * Sensitivity) )
		}
		Else If ( Abs(x) >= 12 ) && ( Abs(y) < 8 )
		{
			this.MoveMouse( 0, (y * this.offset.dx * Sensitivity) )
			x := x * this.offset.dx * Sensitivity
			Return LLMouse.Move(Ceil(x/3), 0, 3, 2)
		}
		Else If ( Abs(x) < 12 ) && ( Abs(y) >= 8 )
		{
			this.MoveMouse( (x * this.offset.dx * Sensitivity), 0 )
			y := y * this.offset.dx * Sensitivity
			Return LLMouse.Move(0, Ceil(y/3), 3, 2)
		}
		Else If ( Abs(x) >= 12 ) && ( Abs(y) >= 8 )
		{
			x := x * this.offset.dx * Sensitivity
			y := y * this.offset.dx * Sensitivity
			Return LLMouse.Move(Ceil(x/3), Ceil(y/3), 3, 2)
		}

		;LLMouse.Move(x, y, 4, 2)
		;this.MoveMouse( (x * this.offset.dx * Sensitivity), (y * this.offset.dx * Sensitivity) )
	}

	AntiShake(x, y) {
		static block := {x: 0.00625*A_ScreenWidth, y: 0.00555555555*A_ScreenHeight}

		If ( Abs(x) <= Ceil(block.x) ) && ( Abs(y) <= Ceil(block.y) )
			Return 1

		Return 0
	}

	MoveMouse(x, y) {
		Return this.Mouse.Move.(1, Ceil(x), Ceil(y))
	}
}


#Include %A_LineFile%\..\3rd-party\Class SetMouseSpeed.ahk
#Include %A_LineFile%\..\3rd-party\Class LLMouse.ahk
