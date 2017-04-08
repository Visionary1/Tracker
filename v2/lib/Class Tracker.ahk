Class Tracker
{
	__New() {
		this.Mouse := []
		this.Mouse.Move := DynaCall("mouse_event", ["iiiii"], 1, _X := "", _Y := "")
		this.Mouse.Speed := new SetMouseSpeed(10)

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

	class Calculate extends Public
	{
		Call(self, Sensitivity, AntiShake, Humanizer) {

			If ( this.Search(self) != 0 )
				Return

			x := self.Aim.x + self.offset.x
			y := self.Aim.y + self.offset.y
			delta := {x: Abs(x), y: Abs(y)}

			If (AntiShake) && (this.AntiShake(delta.x, delta.y))
				Return

			x := x * self.offset.dx * Sensitivity
			y := y * self.offset.dx * Sensitivity
			
			Return ( Humanizer ? this.Humanizer(self, delta, x, y) : this.MoveMouse(self, x, y) )

		}

		; private methods callable only from within Tracker.Calculate()
		Search(self) {
			PixelSearch, OutputVarX, OutputVarY, self.X1, self.Y1, self.X2, self.Y2, self.ColorID, self.ColorVariation, Fast RGB
			self.Aim := {x: OutputVarX, y: OutputVarY}
			Return ErrorLevel
		}

		AntiShake(x, y) {
			static block := {x: Ceil(0.00208333333*A_ScreenWidth), y: Ceil(0.00277777777*A_ScreenHeight)}

			If ( x <= block.x ) && ( y <= block.y )
				Return 1

			Return 0
		}

		Humanizer(self, delta, x, y) {
			static limit := {x: 15, y: 15}

			If ( delta.x < limit.x ) && ( delta.y < limit.y )
			{
				Return this.MoveMouse(self, x, y)
			}
			Else If ( delta.x >= limit.x ) && ( delta.y < limit.y )
			{
				this.MoveMouse(self, 0, y)
				Return LLMouse.Move(Ceil(x/3), 0, 3, 2)
			}
			Else If ( delta.x < limit.x ) && ( delta.y >= limit.y )
			{
				this.MoveMouse(self, x, 0)
				Return LLMouse.Move(0, Ceil(y/3), 3, 2)
			}
			Else If ( delta.x >= limit.x ) && ( delta.y >= limit.y )
			{
				Return LLMouse.Move(Ceil(x/3), Ceil(y/3), 3, 2)
			}
		}

		MoveMouse(self, x, y) {
			Return self.Mouse.Move.(1, Ceil(x), Ceil(y))
		}
	}
}


#Include %A_LineFile%\..\3rd-party\Class SetMouseSpeed.ahk
#Include %A_LineFile%\..\3rd-party\Class LLMouse.ahk
#Include %A_LineFile%\..\3rd-party\Class Public.ahk