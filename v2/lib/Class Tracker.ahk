﻿Class Tracker
{
	static ColorID := 0xFF0013, ColorVariation := 0
	, offset := {x: Round(45 - A_ScreenWidth / 2) , y: Round(70 - A_ScreenHeight / 2)}

	__New(X1 := 0, X2 := 0)
	{
		this.Mouse := []
		;this.Mouse.Move := DynaCall("mouse_event", ["uiiiuii", 2, 3], 1, _x := 0, _y := 0, 0, 0)
		;DllCall("SendInput", "UInt", 1, "Ptr", &MOUSEINPUT, "Int", 28) ;superceded by SendInput
		;this.Mouse.Move := DynaCall("SendInput", ["uiti", 2], 1, _lpinput := 0, 28)
		this.Mouse.Speed := new SetMouseSpeed(10)

		; reserved for future use
		; GetClientRect(WinExist("오버워치"),(rc:=Struct("Int left,top,right,bottom"))[])
		; TaskDialog("'OverWatch' detected", rc.right "x" rc.bottom, "Tracker", 0x1, 0xFFFD)

		; this.offset := {x: Round(45 - A_ScreenWidth / 2) ;Round(0.0234375*A_ScreenWidth - A_ScreenWidth/2) ; 45 - 
		; 	, y: Round(70 - A_ScreenHeight / 2) ;Round(0.06481481481*A_ScreenHeight - A_ScreenHeight/2) ; 70 - 
		; 	, plus: {l: 0, r: 0}} ;Round(-0.43518518519 * A_ScreenHeight)} ;(85 + ya * 5) - A_ScreenHeight/2}

		this.X1 := X1 ? X1 : Round(A_ScreenWidth/2 - A_ScreenWidth/6)
		this.Y1 := Round(A_ScreenHeight/2 - A_ScreenHeight/5)
		this.X2 := X2 ? X2 : Round(A_ScreenWidth/2 + A_ScreenWidth/6)
		this.Y2 := Round(A_ScreenHeight/2 + A_ScreenHeight/5)
	}

	__Delete()
	{
		this.Delete("Mouse")
	}

	Firing(Key)
	{
		Return GetKeyState(Key, "P")
	}

	Class Calculate extends Public
	{
		Call(self, Sensitivity, AntiShake, Humanizer)
		{
			;ToolTip, % Sensitivity "`n" AntiShake
			If !WinActive("오버워치")
				Return

			If (this.Search(self))
				Return

			x := this.Aim.x + Tracker.offset.x  ;+ (this.Aim.x + self.offset.x > 0 ? self.offset.plus.r : self.offset.plus.l)
			y := this.Aim.y + Tracker.offset.y
			delta := {x: Abs(x), y: Abs(y)}

			x := x * (10 / Sensitivity)
			y := y * (10 / Sensitivity)

			If (AntiShake)
				this.AntiShake(delta, x, y)

			If (Humanizer)
				this.Humanizer(delta, x, y)

			Return this.MoveMouse(x, y)

			; Humanizer 
			; ? this.Humanizer(self, delta, Sensitivity, x, y)
			; : this.MoveMouse(self, x * (10 / Sensitivity), y * (10 / Sensitivity))
		}

		Search(self)
		{
			PixelSearch, OutputVarX, OutputVarY, self.X1, self.Y1, self.X2, self.Y2, Tracker.ColorID, Tracker.ColorVariation, Fast RGB
			If (ErrorLevel = 0)
				this.Aim := {x: OutputVarX, y: OutputVarY}

			Return ErrorLevel
		}

		AntiShake(delta, ByRef x, ByRef y)
		{
			static block := {x: 10, y: 5}

			If ( delta.x <= block.x )
				x := 0
			If ( delta.y <= block.y )
				y := 0
		}

		Humanizer(delta, ByRef x, ByRef y)
		{
			If (delta.x < 400)
				 x := x / 6
			Else
				x := x / 5

			If (delta.y < 200)
				y := y / 6
			Else
				y := y / 5
		}

		MoveMouse(x, y) {
			static BoundMove := DynaCall("SendInput", ["uiti", 2], 1, _lpinput := 0, 28)
			;// http://msdn.microsoft.com/en-us/library/windows/desktop/ms646270(v=vs.85).aspx
			;// http://msdn.microsoft.com/en-us/library/windows/desktop/ms646273(v=vs.85).aspx
			;// http://msdn.microsoft.com/en-us/library/windows/desktop/ms646310(v=vs.85).aspx

			; // type = 0 (INPUT_MOUSE), ;// mouseData = 0, ;// dwFlags = 1 (MOUSEEVENTF_MOVE), ;// time = 0, ;// dwExtraInfo = 0
			; VarSetCapacity(MOUSEINPUT, 28, 0), NumPut(0, MOUSEINPUT, 0), NumPut(0, MOUSEINPUT, 12),NumPut(0x0001, MOUSEINPUT, 16, "UInt") 
			; , NumPut(0, MOUSEINPUT, 20), NumPut(0, MOUSEINPUT, 24)
			; , NumPut(Round(x), MOUSEINPUT, 4, "Int"), NumPut(Round(y), MOUSEINPUT, 8, "Int")

			VarSetCapacity(MOUSEINPUT, 28, 0)
			, NumPut(Round(x), MOUSEINPUT, 4, "Int"), NumPut(Round(y), MOUSEINPUT, 8, "Int")
			, NumPut(0x0001, MOUSEINPUT, 16, "UInt")
			Return BoundMove[&MOUSEINPUT]
			;, DllCall("SendInput", "UInt", 1, "Ptr", &MOUSEINPUT, "Int", 28)

			;
			;Return self.Mouse.Move.(1, Round(x), Round(y))
		}
	}
}

Class AimLock
{
	static Activator := new Tracker(0, A_ScreenWidth)

	RoadHog(InGameSens, lParam)
	{
		If (NumGet(lParam+0, 0) = 160) ;LShift
			Return AimLock.Activator.Calculate(InGameSens, 0, 0)
	}

	Ana(InGameSens, lParam) ;Work in progress..
	{
		;Activator.Calculate(this.InGameSens, 0, 0)
	}
}


#Include %A_LineFile%\..\3rd-party\Class SetMouseSpeed.ahk
;#Include %A_LineFile%\..\3rd-party\Class LLMouse.ahk
#Include %A_LineFile%\..\3rd-party\Class Public.ahk