class Tracker
{
	__New(X1 := 0, X2 := 0)
	{
		this.mspeed := new Tracker.MouseSpeed(10)
		this.X1 := X1 ? X1 : Round(A_ScreenWidth/2 - A_ScreenWidth/6)
		this.Y1 := Round(A_ScreenHeight/2 - A_ScreenHeight/5)
		this.X2 := X2 ? X2 : Round(A_ScreenWidth/2 + A_ScreenWidth/6)
		this.Y2 := Round(A_ScreenHeight/2 + A_ScreenHeight/5)
	}

	__Delete()
	{
		this.mspeed := ""
	}

	Firing(Key)
	{
		static vkc := {LButton: 0x01, RButton: 0x02, MButton: 0x04, CapsLock: 0x14, Ctrl: 0x11, Space: 0x20}

		Return DllCall("GetAsyncKeyState", "Int", vkc[Key])
		;Return GetKeyState(Key, "P")
	}

	class Calculate extends Private
	{
		Call(self, Sensitivity, AntiShake, Humanizer)
		{
			static calibrate := {x: 45, y: 70}

			;ToolTip, % Sensitivity "`n" AntiShake

			If (this.Search(self))
				Return

			x := this.hpbar.x + calibrate.x
			, y := this.hpbar.y + calibrate.y
			, distance := {x: Abs(x), y: Abs(y)}
			, x := x * (10 / Sensitivity)
			, y := y * (10 / Sensitivity)

			If (AntiShake)
				this.AntiShake(distance, x, y)

			If (Humanizer)
				this.Humanizer(distance, x, y)

			Return this.MoveMouse(x, y)
		}

		Search(self)
		{
			static ColorID := 0xFF0013, ColorVariation := 0

			If !WinActive("오버워치")
				Return 1

			PixelSearch, OutputVarX, OutputVarY, self.X1, self.Y1, self.X2, self.Y2, ColorID, ColorVariation, Fast RGB
			If (ErrorLevel = 0)
				this.hpbar := {x: OutputVarX, y: OutputVarY}

			Return ErrorLevel
		}

		AntiShake(distance, ByRef x, ByRef y)
		{
			static allow := {x: 10, y: 5}

			If (distance.x <= allow.x)
				x := 0
			If (distance.y <= allow.y)
				y := 0
		}

		Humanizer(distance, ByRef x, ByRef y)
		{
			static divider := {x: Round(0.20833333333*A_ScreenWidth) ;400
							, y: Round(0.18518518518*A_ScreenHeight)} ;200

			If (distance.x <= divider.x)
				x := x / 6
			Else
				x := x / 5

			If (distance.y <= divider.y)
				y := y / 6
			Else
				y := y / 5
		}

		MoveMouse(x, y)
		{
			; static Exec := DynaCall("SendInput", ["uiti", 2], 1, _lpinput := 0, 28)
			; ;// http://msdn.microsoft.com/en-us/library/windows/desktop/ms646270(v=vs.85).aspx
			; ;// http://msdn.microsoft.com/en-us/library/windows/desktop/ms646273(v=vs.85).aspx
			; ;// http://msdn.microsoft.com/en-us/library/windows/desktop/ms646310(v=vs.85).aspx
			; ; // type = 0 (INPUT_MOUSE), ;// mouseData = 0, ;// dwFlags = 1 (MOUSEEVENTF_MOVE), ;// time = 0, ;// dwExtraInfo = 0
			; ; VarSetCapacity(MOUSEINPUT, 28, 0), NumPut(0, MOUSEINPUT, 0), NumPut(0, MOUSEINPUT, 12),NumPut(0x0001, MOUSEINPUT, 16, "UInt") 
			; ; , NumPut(0, MOUSEINPUT, 20), NumPut(0, MOUSEINPUT, 24)
			; ; , NumPut(Round(x), MOUSEINPUT, 4, "Int"), NumPut(Round(y), MOUSEINPUT, 8, "Int")

			; ; VarSetCapacity(MOUSEINPUT, 28, 0)
			; ; , NumPut(Round(x), MOUSEINPUT, 4, "Int"), NumPut(Round(y), MOUSEINPUT, 8, "Int")
			; ; , NumPut(0x0001, MOUSEINPUT, 16, "UInt"), DllCall("SendInput", "UInt", 1, "Ptr", &MOUSEINPUT, "Int", 28)

			; VarSetCapacity(MOUSEINPUT, 28, 0)
			; , NumPut(Round(x), MOUSEINPUT, 4, "Int"), NumPut(Round(y), MOUSEINPUT, 8, "Int")
			; , NumPut(0x0001, MOUSEINPUT, 16, "UInt")
			; ;DllCall("SendInput", _ptr, 1, "Ptr", &MOUSEINPUT, "Int", 28)
			; Return Exec[&MOUSEINPUT]

			Return DllCall("mouse_event", "UInt", 0x0001, "Int", Round(x), "Int", Round(y))
		}
	}

	class MouseSpeed
	{
		__New(value)
		{
			DllCall("SystemParametersInfo", "UInt", 0x70, "UInt", 0, "UIntP", original, "UInt", 0)
			this.original := original
			this.change(value)
		}

		change(value)
		{
			DllCall("SystemParametersInfo", "UInt", 0x71, "UInt", 0, "UInt", value, "UInt", 0)
		}

		__Delete()
		{
			this.change(this.original)
		}
	}
}

; class AimLock
; {
; 	static Activator := new Tracker(0, A_ScreenWidth)

; 	RoadHog(InGameSens, lParam)
; 	{
; 		If (NumGet(lParam+0, 0) = 160) ;LShift
; 			Return AimLock.Activator.Calculate(InGameSens, 0, 0)
; 	}

; 	Ana(InGameSens, lParam) ;Work in progress..
; 	{
; 		;Activator.Calculate(this.InGameSens, 0, 0)
; 	}
; }

class Private
{
	__Call(method, args*)
	{
		If IsObject(method) || (method == "")
			Return method ? this.Call(method, args*) : this.Call(args*)
	}
}
