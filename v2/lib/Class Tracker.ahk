; #SingleInstance, Force
; #NoEnv

; ;#Warn
; #KeyHistory, 0
; ListLines, Off
; SetBatchLines, -1
; SetWinDelay, -1
; SetControlDelay, -1
; CoordMode, Pixel, Screen

; test := new Tracker()
; Return

; F::
; test.Calculate(1,2,3,4)
; Return


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
		this.offset := {modifier: 2.7
			, x: Round(0.47708333334 * -A_ScreenWidth)  ;x: (41 + xa * 3) - A_ScreenWidth/2
			, y: Round(0.43518518519 * -A_ScreenHeight)} ;(85 + ya * 5) - A_ScreenHeight/2}

		this.X1 := Round(A_ScreenWidth * 0.3) ;A_ScreenWidth/2 - A_ScreenWidth/5
		this.Y1 := Round(A_ScreenHeight * 0.25) ;A_ScreenHeight/2 - A_ScreenHeight/4
		this.X2 := Round(A_ScreenWidth *0.7) ;A_ScreenWidth/2 + A_ScreenWidth/5
		this.Y2 := Round(A_ScreenHeight * 0.75) ;A_ScreenHeight/2 + A_ScreenHeight/4
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

			If (this.Search(self) != 0)
				Return

			x := self.Aim.x + self.offset.x
			y := self.Aim.y + self.offset.y
			delta := {x: Abs(x), y: Abs(y)}

			If (AntiShake)
				this.AntiShake(delta, x, y)

			x := x * (10 / Sensitivity) ;instant move
			y := y * (10 / Sensitivity) ;instant move
			; modifier := Sensitivity * 0.09
			; x := x / modifier
			; y := y / modifier

			Return ( Humanizer ? this.Humanizer(self, delta, x, y) : this.MoveMouse(self, x / self.offset.modifier, y / self.offset.modifier) )
		}

		; private methods callable only from within Tracker.Calculate()
		Search(self) {
			PixelSearch, OutputVarX, OutputVarY, self.X1, self.Y1, self.X2, self.Y2, self.ColorID, self.ColorVariation, Fast RGB
			If (ErrorLevel = 0)
				self.Aim := {x: OutputVarX, y: OutputVarY}

			Return ErrorLevel
		}

		AntiShake(delta, ByRef x, ByRef y) {
			static block := {x: 5, y: 5}

			If ( delta.x <= block.x )
				x := 0
			If ( delta.y <= block.y )
				y := 0
		}

		Humanizer(self, delta, x, y) {
			static limit := {x: Ceil(A_ScreenWidth*0.075), y: Ceil(A_ScreenHeight*0.11111111111), times: 6}

			If (delta.x <= limit.x) && (delta.y <= limit.y)
				Return this.MoveMouse(self, x / self.offset.modifier, y / self.offset.modifier)

			Loop, % limit.times
			{
				this.MoveMouse(self, x/limit.times, y/limit.times)
				Sleep, 1
			}

		}

		MoveMouse(self, x, y) {
			Return self.Mouse.Move.(1, Floor(x), Floor(y))
		}
	}
}


#Include %A_LineFile%\..\3rd-party\Class SetMouseSpeed.ahk
;#Include %A_LineFile%\..\3rd-party\Class LLMouse.ahk
#Include %A_LineFile%\..\3rd-party\Class Public.ahk