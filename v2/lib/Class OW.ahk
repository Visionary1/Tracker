Class OW
{
	__New() {
		
		parsed := JSON.Load(DownloadToStr("https://raw.githubusercontent.com/Visionary1/Tracker/master/info.json"))

		Window := {Width: 500, Height: 300, Title: parsed.title, StatusBarText: parsed.StatusBarText}

		this.Canvas := new GUI("Canvas", "+LastFound -Resize -Caption -Border")
		this.Canvas.Color("FFFFFF")
		this.Canvas.Margin(10, 10)

		this.Bound := []
		this.Bound.OnMessage := this.OnMessage.Bind(this)
		this.Bound.AntiShake := 0
		this.Bound.Humanizer := 0

		Buttons := new this.MenuButtons(this)
		Menus :=
		( Join
		[
			["Aim", [
				["LButton", Buttons.AimKey.Bind(Buttons)],
				["RButton", Buttons.AimKey.Bind(Buttons)],
				["MButton", Buttons.AimKey.Bind(Buttons)],
				["CapsLock", Buttons.AimKey.Bind(Buttons)],
				["Space", Buttons.AimKey.Bind(Buttons)],
				["Ctrl", Buttons.AimKey.Bind(Buttons)]
			]], ["Suspend", [
				["CapsLock", Buttons.SuspendKey.Bind(Buttons)],
				["MButton", Buttons.SuspendKey.Bind(Buttons)],
				["F1", Buttons.SuspendKey.Bind(Buttons)],
				["Alt", Buttons.SuspendKey.Bind(Buttons)]
			]], ["Sensitivity", [
				["0.5", Buttons.Sensitivity.Bind(Buttons)],
				["1", Buttons.Sensitivity.Bind(Buttons)],
				["1.5", Buttons.Sensitivity.Bind(Buttons)],
				["2", Buttons.Sensitivity.Bind(Buttons)],
				["2.5", Buttons.Sensitivity.Bind(Buttons)],
				["3", Buttons.Sensitivity.Bind(Buttons)],
				["3.5", Buttons.Sensitivity.Bind(Buttons)],
				["4", Buttons.Sensitivity.Bind(Buttons)],
				["4.5", Buttons.Sensitivity.Bind(Buttons)],
				["5", Buttons.Sensitivity.Bind(Buttons)],
				["5.5", Buttons.Sensitivity.Bind(Buttons)],
				["6", Buttons.Sensitivity.Bind(Buttons)],
				["7", Buttons.Sensitivity.Bind(Buttons)],
				["8", Buttons.Sensitivity.Bind(Buttons)],
				["9", Buttons.Sensitivity.Bind(Buttons)]
			]], ["Advanced", [
				["Anti-Shake", Buttons.AntiShake.Bind(Buttons)],
				["Humanizer", Buttons.Humanizer.Bind(Buttons)]
			]]
		]
		)

		this.Menus := this.CreateMenuBar(Menus)
		;Gui, Menu, % this.Menus[1]
		this.Canvas.Options("Menu", this.Menu[1])

		this.hBorderLeft := this.Canvas.Add("Text", "x" 0 " y" 0 " w" 1 " h" Window.Height " +0x4E")
		this.hBorderRight := this.Canvas.Add("Text", "x" Window.Width-1 " y" 0 " w" 1 " h" Window.Height " +0x4E")
		this.hBorderBottom := this.Canvas.Add("Text", "x" 1 " y" Window.Height-1 " w" Window.Width-2 " h" 1 " +0x4E")

		For Key, Value in [this.hBorderLeft, this.hBorderRight, this.hBorderBottom]
			DllCall("SendMessage", "Ptr", Value, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0072C6", 1, 1))

		this.hTitleHeader := this.Canvas.Add("Text", "x" 1 " y" 0 " w" Window.Width-2 " h" 67 " +0x4E")
		DllCall("SendMessage", "Ptr", this.hTitleHeader, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))

		this.Canvas.Font("s9 cFFFFFF", "Segoe UI")
		this.hTitle := this.Canvas.Add("Text", "x" 140 " y" 12 " w" Window.Width-280 " +BackgroundTrans +0x101", Window.Title)
		this.Canvas.Font()

		this.hStatusBar := this.Canvas.Add("Picture", "x" 1 " y" Window.Height-23 " w" Window.Width-2 " h" 22 " +0x4E")
		StatusBar := "#@@@@@@@@@@@@@@@@@@@@@"
		StringReplace, StatusBar, StatusBar, #, BFBFBF|, All
		StringReplace, StatusBar, StatusBar, @, F1F1F1|, All
		StringTrimRight, StatusBar, StatusBar, 1
		DllCall("SendMessage", "Ptr", this.hStatusBar, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(StatusBar, 1, 22))

		this.Canvas.Font("s8 c515050", "Segoe UI")
		this.hStatusBarText := this.Canvas.Add("Text", "x" 8 " y" Window.Height-19 " w" Window.Width-16 " +BackgroundTrans", Window.StatusBarText)
		this.Canvas.Font()

		this.hButtonMinimizeN := this.Canvas.Add("Picture", "x" Window.Width-139 " y" 1 " w" 46 " h" 31 " +0x4E Hidden0")
		this.hButtonMinimizeH := this.Canvas.Add("Picture", "x" Window.Width-139 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		this.hButtonMinimizeP := this.Canvas.Add("Picture", "x" Window.Width-139 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")

		ButtonMinimize := "####################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################@@@@@@@@@@####################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################"

		StringReplace, ButtonMinimizeN, ButtonMinimize, #, 0173C7|, All
		StringReplace, ButtonMinimizeN, ButtonMinimizeN, @, FFFFFF|, All
		StringTrimRight, ButtonMinimizeN, ButtonMinimizeN, 1

		StringReplace, ButtonMinimizeH, ButtonMinimize, #, 2A8AD4|, All
		StringReplace, ButtonMinimizeH, ButtonMinimizeH, @, FFFFFF|, All
		StringTrimRight, ButtonMinimizeH, ButtonMinimizeH, 1

		StringReplace, ButtonMinimizeP, ButtonMinimize, #, 015C9F|, All
		StringReplace, ButtonMinimizeP, ButtonMinimizeP, @, FFFFFF|, All
		StringTrimRight, ButtonMinimizeP, ButtonMinimizeP, 1

		For Key, Value in {this.hButtonMinimizeN: ButtonMinimizeN, this.hButtonMinimizeH: ButtonMinimizeH, this.hButtonMinimizeP: ButtonMinimizeP}
			DllCall("SendMessage", "Ptr", Key, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(Value, 46, 31))


		this.hButtonMaximizeN := this.Canvas.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden0")
		this.hButtonMaximizeH := this.Canvas.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		this.hButtonMaximizeP := this.Canvas.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")

		ButtonMaximize := "##############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################@@@@@@@@@@####################################@########@####################################@########@####################################@########@####################################@########@####################################@########@####################################@########@####################################@########@####################################@########@####################################@@@@@@@@@@############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################"

		StringReplace, ButtonMaximizeN, ButtonMaximize, #, 0173C7|, All
		StringReplace, ButtonMaximizeN, ButtonMaximizeN, @, FFFFFF|, All
		StringTrimRight, ButtonMaximizeN, ButtonMaximizeN, 1

		StringReplace, ButtonMaximizeH, ButtonMaximize, #, 2A8AD4|, All
		StringReplace, ButtonMaximizeH, ButtonMaximizeH, @, FFFFFF|, All
		StringTrimRight, ButtonMaximizeH, ButtonMaximizeH, 1

		StringReplace, ButtonMaximizeP, ButtonMaximize, #, 015C9F|, All
		StringReplace, ButtonMaximizeP, ButtonMaximizeP, @, FFFFFF|, All
		StringTrimRight, ButtonMaximizeP, ButtonMaximizeP, 1

		For Key, Value in {this.hButtonMaximizeN: ButtonMaximizeN, this.hButtonMaximizeH: ButtonMaximizeH, this.hButtonMaximizeP: ButtonMaximizeP}
			DllCall("SendMessage", "Ptr", Key, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(Value, 46, 31))


		this.hButtonRestoreN := this.Canvas.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		this.hButtonRestoreH  := this.Canvas.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		this.hButtonRestoreP := this.Canvas.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")

		ButtonRestore := "################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################@@@@@@@@######################################@######@####################################@@@@@@@@#@####################################@######@#@####################################@######@#@####################################@######@#@####################################@######@#@####################################@######@@@####################################@######@######################################@@@@@@@@##############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################"

		StringReplace, ButtonRestoreN, ButtonRestore, #, 0173C7|, All
		StringReplace, ButtonRestoreN, ButtonRestoreN, @, FFFFFF|, All
		StringTrimRight, ButtonRestoreN, ButtonRestoreN, 1

		StringReplace, ButtonRestoreH, ButtonRestore, #, 2A8AD4|, All
		StringReplace, ButtonRestoreH, ButtonRestoreH, @, FFFFFF|, All
		StringTrimRight, ButtonRestoreH, ButtonRestoreH, 1

		StringReplace, ButtonRestoreP, ButtonRestore, #, 015C9F|, All
		StringReplace, ButtonRestoreP, ButtonRestoreP, @, FFFFFF|, All
		StringTrimRight, ButtonRestoreP, ButtonRestoreP, 1

		For Key, Value in {this.hButtonRestoreN: ButtonRestoreN, this.hButtonRestoreH: ButtonRestoreH, this.hButtonRestoreP: ButtonRestoreP}
			DllCall("SendMessage", "Ptr", Key, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(Value, 46, 31))


		this.hButtonCloseN := this.Canvas.Add("Picture", " x" Window.Width-47 " y" 1 " w" 46 " h" 31 " +0x4E Hidden0")
		this.hButtonCloseH := this.Canvas.Add("Picture", " x" Window.Width-47 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		this.hButtonCloseP := this.Canvas.Add("Picture", " x" Window.Width-47 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")

		ButtonClose := "##############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################-$######$-####################################$-$####$-$#####################################$-$##$-$#######################################$-$$-$#########################################$--$##########################################$--$#########################################$-$$-$#######################################$-$##$-$#####################################$-$####$-$####################################-$######$-############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################"

		StringReplace, ButtonCloseN, ButtonClose, #, 0173C7|, All
		StringReplace, ButtonCloseN, ButtonCloseN, $, 4096D5|, All
		StringReplace, ButtonCloseN, ButtonCloseN, -, FFFFFF|, All
		StringTrimRight, ButtonCloseN, ButtonCloseN, 1

		StringReplace, ButtonCloseH, ButtonClose, #, E81123|, All
		StringReplace, ButtonCloseH, ButtonCloseH, $, EE4C59|, All
		StringReplace, ButtonCloseH, ButtonCloseH, -, FFFFFF|, All
		StringTrimRight, ButtonCloseH, ButtonCloseH, 1

		StringReplace, ButtonCloseP, ButtonClose, #, F1707A|, All
		StringReplace, ButtonCloseP, ButtonCloseP, $, F4939B|, All
		StringReplace, ButtonCloseP, ButtonCloseP, -, FFFFFF|, All
		StringTrimRight, ButtonCloseP, ButtonCloseP, 1

		For Key, Value in {this.hButtonCloseN: ButtonCloseN, this.hButtonCloseH: ButtonCloseH, this.hButtonCloseP: ButtonCloseP}
			DllCall("SendMessage", "Ptr", Key, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(Value, 46, 31))


		this.Canvas.Font("s9 cFFFFFF", "Segoe UI")
		this.hButtonMenu1N := this.Canvas.Add("Picture", " x" 2 " y" 36 " w" 60 " h" 24 " +0x4E Hidden0")
		this.hButtonMenu1H := this.Canvas.Add("Picture", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E Hidden1")
		this.hButtonMenu1Text := this.Canvas.Add("Text", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +BackgroundTrans +0x201", "Aim")
		;DllCall("SendMessage", "Ptr", this.hButtonMenu1N, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
		;DllCall("SendMessage", "Ptr", this.hButtonMenu1H, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("2A8AD4", 1, 1))

		this.hButtonMenu2N := this.Canvas.Add("Picture", " x+" 2 " yp" 0 " w" 60 " h" 24 " +0x4E Hidden0")
		this.hButtonMenu2H := this.Canvas.Add("Picture", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E Hidden1")
		this.hButtonMenu2Text := this.Canvas.Add("Text", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +BackgroundTrans +0x201", "Suspend")
		;DllCall("SendMessage", "Ptr", this.hButtonMenu2N, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
		;DllCall("SendMessage", "Ptr", this.hButtonMenu2H, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("2A8AD4", 1, 1))

		this.hButtonMenu3N := this.Canvas.Add("Picture", " x+" 2 " yp" 0 " w" 60 " h" 24 " +0x4E Hidden0")
		this.hButtonMenu3H := this.Canvas.Add("Picture", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E Hidden1")
		this.hButtonMenu3Text := this.Canvas.Add("Text", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +BackgroundTrans +0x201", "Sensitivity")
		;DllCall("SendMessage", "Ptr", this.hButtonMenu3N, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
		;DllCall("SendMessage", "Ptr", this.hButtonMenu3H, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("2A8AD4", 1, 1))

		this.hButtonMenu4N := this.Canvas.Add("Picture", " x+" 2 " yp" 0 " w" 60 " h" 24 " +0x4E Hidden0")
		this.hButtonMenu4H := this.Canvas.Add("Picture", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E Hidden1")
		this.hButtonMenu4Text := this.Canvas.Add("Text", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +BackgroundTrans +0x201", "Advanced")
		;DllCall("SendMessage", "Ptr", this.hButtonMenu4N, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
		;DllCall("SendMessage", "Ptr", this.hButtonMenu4H, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("2A8AD4", 1, 1))

		For Key, Value in [this.hButtonMenu1N, this.hButtonMenu2N, this.hButtonMenu3N, this.hButtonMenu4N]
			DllCall("SendMessage", "Ptr", Value, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
		For Key, Value in [this.hButtonMenu1H, this.hButtonMenu2H, this.hButtonMenu3H, this.hButtonMenu4H]
			DllCall("SendMessage", "Ptr", Value, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("2A8AD4", 1, 1))

		this.Canvas.Font()
		this.BoardMsg := this.Canvas.Add("Text", "x20 y80", DownloadToStr("https://raw.githubusercontent.com/Visionary1/Tracker/master/Board.txt"))
		this.StartBtn := this.Canvas.Add("Button", "x20 y80 w" Window.Width - 40 " h" Window.Height - 120 " Hidden", "initialize", ObjBindMethod(this, "initialize"))
		
		this.Canvas.Show(" w" Window.Width " h" Window.Height, Window.Title)
		
		WinEvents.Register(this.Canvas.hwnd, this)
		For each, Msg in [0x200, 0x201, 0x202, 0x2A3] ; WM_MOUSEMOVE, WM_LBUTTONDOWN, WM_LBUTTONUP, WM_MOUSELEAVE
			OnMessage(Msg, this.Bound.OnMessage)

		VarSetCapacity(this.TME, 16, 0), NumPut(16, this.TME, 0), NumPut(2, this.TME, 4), NumPut(hGui1, this.TME, 8)
	}

	RegisterCloseCallback(CloseCallback) {
		this.CloseCallback := CloseCallback
	}

	initialize() {
		this.Canvas.Control("Hide", this.StartBtn)
		this.Canvas.Control("Show", this.BoardMsg)

		this.Tracker := new Tracker()

		this.pn := new PureNotify(this.Tracker.X1, this.Tracker.Y1, (this.Tracker.X2 - this.Tracker.X1), (this.Tracker.Y2 - this.Tracker.Y1))
		this.pn.Text("initializing..."
		, "Searching area (" (this.Tracker.X2 - this.Tracker.X1) "x" (this.Tracker.Y2 - this.Tracker.Y1) ")`n`nAim  " this.AimKey "`nSus  " this.SuspendKey "`nSensitivity  " this.Sensitivity)
		Sleep, 4000
		this.Delete("pn")
		;Tick := A_IsCompiled ? SubStr(A_ScriptName, 1, -4) : 0

		this.Bound.__Run := new QuasiThread(ObjBindMethod(this, "__Run"))
		this.Bound.__Run.Start(10)
	}

	;reserved for internal use
	__Run() { 
		If ( this.Tracker.Firing(this.AimKey) )
		{
			;ToolTip, % this.AimKey "`n" this.Sensitivity
			this.Tracker.Calculate(this.Sensitivity, this.Bound.AntiShake, this.Bound.Humanizer)
		}
	}

	;reserved for internal use
	__Pause() {
		Pause, Toggle, 1
	}

	OnMessage(wParam, lParam, Msg, hWnd) {
		If (hWnd == this.Canvas.hwnd) {
			DllCall("TrackMouseEvent", "UInt", &this.TME)
			MouseGetPos,,,, MouseCtrl, 2

			If (Msg == 0x200)
				Return this.WM_MOUSEMOVE(MouseCtrl)
			Else If (Msg == 0x201)
				Return this.WM_LBUTTONDOWN(MouseCtrl)
			Else If (Msg == 0x202)
				Return this.WM_LBUTTONUP(MouseCtrl)
			Else If (Msg == 0x2A3)
				Return this.WM_MOUSELEAVE()
		}
	}


	WM_MOUSEMOVE(MouseCtrl) {
		; DllCall("TrackMouseEvent", "UInt", &this.TME)

		; MouseGetPos,,,, MouseCtrl, 2

		this.Canvas.Control( (MouseCtrl = this.hButtonMinimizeN || MouseCtrl = this.hButtonMinimizeH) ? "Show" : "Hide", this.hButtonMinimizeH )
		this.Canvas.Control( (MouseCtrl = this.hButtonMaximizeN || MouseCtrl = this.hButtonMaximizeH) ? "Show" : "Hide", this.hButtonMaximizeH )
		this.Canvas.Control( (MouseCtrl = this.hButtonRestoreN || MouseCtrl = this.hButtonRestoreH) ? "Show" : "Hide", this.hButtonRestoreH )
		this.Canvas.Control( (MouseCtrl = this.hButtonCloseN || MouseCtrl = this.hButtonCloseH) ? "Show" : "Hide", this.hButtonCloseH )
		this.Canvas.Control( (MouseCtrl = this.hButtonMenu1Text) ? "Show" : "Hide", this.hButtonMenu1H )

		this.Canvas.Control( (MouseCtrl = this.hButtonMenu2Text) ? "Show" : "Hide", this.hButtonMenu2H )
		this.Canvas.Control( (MouseCtrl = this.hButtonMenu3Text) ? "Show" : "Hide", this.hButtonMenu3H )
		this.Canvas.Control( (MouseCtrl = this.hButtonMenuToolsText) ? "Show" : "Hide", this.hButtonMenuToolsH )
		this.Canvas.Control( (MouseCtrl = this.hButtonMenu4Text) ? "Show" : "Hide", this.hButtonMenu4H )
	}

	WM_LBUTTONDOWN(MouseCtrl) {
		If (MouseCtrl = this.hTitleHeader || MouseCtrl = this.hTitle) {
			PostMessage, 0xA1, 2
		}

		this.Canvas.Control( (MouseCtrl = this.hButtonMinimizeH) ? "Show" : "Hide", this.hButtonMinimizeP )
		this.Canvas.Control( (MouseCtrl = this.hButtonMaximizeH) ? "Show" : "Hide", this.hButtonMaximizeP )
		this.Canvas.Control( (MouseCtrl = this.hButtonRestoreH) ? "Show" : "Hide", this.hButtonRestoreP )
		this.Canvas.Control( (MouseCtrl = this.hButtonCloseH) ? "Show" : "Hide", this.hButtonCloseP )
	}

	WM_LBUTTONUP(MouseCtrl) {
		If (MouseCtrl = this.hButtonMinimizeP) {
			WinMinimize
		} Else If (MouseCtrl = this.hButtonMaximizeP || MouseCtrl = this.hButtonRestoreP) {
			WinGet, MinMaxStatus, MinMax

			If (MinMaxStatus = 1) {
				WinRestore
				GuiControl, Hide, % this.hButtonRestoreN
			} Else {
				WinMaximize
				GuiControl, Show, % this.hButtonRestoreN
			}
		} Else If (MouseCtrl = this.hButtonCloseP) {
			this.GuiClose()
		} Else If (MouseCtrl = this.hButtonMenu1Text) {
			ControlGetPos, ctlX, ctlY, ctlW, ctlH, , % "ahk_id " this.hButtonMenu1Text
			Menu, OW_1, Show, %ctlX%, % ctlY + ctlH
		} Else If (MouseCtrl = this.hButtonMenu2Text) {
			ControlGetPos, ctlX, ctlY, ctlW, ctlH, , % "ahk_id " this.hButtonMenu2Text
			Menu, OW_2, Show, %ctlX%, % ctlY + ctlH
		} Else If (MouseCtrl = this.hButtonMenu3Text) {
			ControlGetPos, ctlX, ctlY, ctlW, ctlH, , % "ahk_id " this.hButtonMenu3Text
			Menu, OW_3, Show, %ctlX%, % ctlY + ctlH
		} Else If (MouseCtrl = this.hButtonMenu4Text) {
			ControlGetPos, ctlX, ctlY, ctlW, ctlH, , % "ahk_id " this.hButtonMenu4Text
			Menu, OW_4, Show, %ctlX%, % ctlY + ctlH
		}
		; } Else If (MouseCtrl = this.hButtonMenu4Text) {
		; 	ControlGetPos, ctlX, ctlY, ctlW, ctlH, , % "ahk_id " this.hButtonMenu4Text
		; 	Menu, Help_Menu, Show, %ctlX%, % ctlY + ctlH

		this.Canvas.Control("Hide", this.hButtonMinimizeP)
		this.Canvas.Control("Hide", this.hButtonMaximizeP)
		this.Canvas.Control("Hide", this.hButtonRestoreP)
		this.Canvas.Control("Hide", this.hButtonCloseP)
		this.Canvas.Control("Hide", this.hButtonMenu1H)
		this.Canvas.Control("Hide", this.hButtonMenu2H)
		this.Canvas.Control("Hide", this.hButtonMenu3H)
		this.Canvas.Control("Hide", this.hButtonMenu4H)
		; this.Canvas.Control("Hide", this.hButtonMenu4H)
	}

	WM_MOUSELEAVE() {
		this.Canvas.Control("Hide", this.hButtonMinimizeH)
		this.Canvas.Control("Hide", this.hButtonMaximizeH)
		this.Canvas.Control("Hide", this.hButtonRestoreH)
		this.Canvas.Control("Hide", this.hButtonCloseH)
		this.Canvas.Control("Hide", this.hButtonMinimizeP)
		this.Canvas.Control("Hide", this.hButtonMaximizeP)
		this.Canvas.Control("Hide", this.hButtonRestoreP)
		this.Canvas.Control("Hide", this.hButtonCloseP)
		this.Canvas.Control("Hide", this.hButtonMenu1H)
		this.Canvas.Control("Hide", this.hButtonMenu2H)
		this.Canvas.Control("Hide", this.hButtonMenu3H)
		this.Canvas.Control("Hide", this.hButtonMenu4H)
		;this.Canvas.Control("Hide", this.hButtonMenuToolsH)
	}

	GuiClose() {
		
		HotKey.Disable(this.SuspendKey)
		; Relase wm_message hooks
		For each, Msg in [0x200, 0x201, 0x202, 0x2A3]
			OnMessage(Msg, this.Bound.OnMessage, 0)

		this.Tracker := ""
		this.Bound.__Run.__Delete()
		this.Delete("Bound")
		WinEvents.Unregister(this.Canvas.hwnd)
		
		this.Canvas.Release_glabel(this.StartBtn)
		this.Canvas.Destroy()

		; Release menu bar (Has to be done after Gui, Destroy)
		For each, MenuName in this.Menus
			Menu, %MenuName%, DeleteAll

		this.Canvas := ""
		this.CloseCallback()
	}

	GuiSize() {
		If (ErrorLevel = 1)
			Return

		this.Canvas.Control("MoveDraw", this.hTitleHeader, " w" A_GuiWidth-2)
		this.Canvas.Control("MoveDraw", this.hBorderLeft, " h" A_GuiHeight)
		this.Canvas.Control("MoveDraw", this.hBorderRight, " x"  A_GuiWidth-1 " h" A_GuiHeight)
		this.Canvas.Control("MoveDraw", this.hBorderBottom, " y" A_GuiHeight-1 " w" A_GuiWidth-2)
		this.Canvas.Control("MoveDraw", this.hTitle, " w" A_GuiWidth-280)
		this.Canvas.Control("MoveDraw", this.hStatusBar, " w" A_GuiWidth-2 " y" A_GuiHeight-23)
		this.Canvas.Control("MoveDraw", this.hStatusBarText, " w" A_GuiWidth-16 " y" A_GuiHeight-19)
		this.Canvas.Control("MoveDraw", this.hButtonMinimizeN, " x" A_GuiWidth-139)
		this.Canvas.Control("MoveDraw", this.hButtonMinimizeH, " x" A_GuiWidth-139)
		this.Canvas.Control("MoveDraw", this.hButtonMinimizeP, " x" A_GuiWidth-139)
		this.Canvas.Control("MoveDraw", this.hButtonMaximizeN, " x" A_GuiWidth-93)
		this.Canvas.Control("MoveDraw", this.hButtonMaximizeH, " x" A_GuiWidth-93)
		this.Canvas.Control("MoveDraw", this.hButtonMaximizeP, " x" A_GuiWidth-93)
		this.Canvas.Control("MoveDraw", this.hButtonRestoreN, " x" A_GuiWidth-93)
		this.Canvas.Control("MoveDraw", this.hButtonRestoreH, " x" A_GuiWidth-93)
		this.Canvas.Control("MoveDraw", this.hButtonRestoreP, " x" A_GuiWidth-93)
		this.Canvas.Control("MoveDraw", this.hButtonCloseN, " x" A_GuiWidth-47)
		this.Canvas.Control("MoveDraw", this.hButtonCloseH, " x" A_GuiWidth-47)
		this.Canvas.Control("MoveDraw", this.hButtonCloseP, " x" A_GuiWidth-47)
	}

	CreateMenuBar(Menu) {
		static MenuName := 0
		Menus := ["OW_" MenuName++]
		for each, Item in Menu
		{
			Ref := Item[2]
			if IsObject(Ref) && Ref._NewEnum()
			{
				SubMenus := this.CreateMenuBar(Ref)
				Menus.Push(SubMenus*), Ref := ":" SubMenus[1]
			}
			Menu, % Menus[1], Add, % Item[1], %Ref%
		}
		return Menus
	}

	Class MenuButtons 
	{
		__New(Parent) {
			this.Parent := Parent
		}
		
		AimKey() {
			this.__Toggle(this.Parent.AimKey)
			this.Parent.AimKey := A_ThisMenuItem
			this.__Ready()
		}

		SuspendKey() {
			this.__Toggle(this.Parent.SuspendKey)

			If (this.Parent.SuspendKey)
				HotKey.Rebind(this.Parent.SuspendKey, A_ThisMenuItem)
			Else
				Hotkey.Bind(A_ThisMenuItem, ObjBindMethod(this.Parent, "__Pause"))

			this.Parent.SuspendKey := A_ThisMenuItem

			; For Key, Value in ["CapsLock", "MButton", "F1", "Alt"]
			; 	Menu, % A_ThisMenu, Disable, % Value

			this.__Ready()
		}

		Sensitivity() {
			this.__Toggle(this.Parent.Sensitivity)
			this.Parent.Sensitivity := A_ThisMenuItem
			this.__Ready()
		}

		AntiShake() {
			this.__Toggle(A_ThisMenuItem)
			this.Parent.Bound.AntiShake := !this.Parent.Bound.AntiShake
			Menu, % A_ThisMenu, Rename, % A_ThisMenuItem, % (this.Parent.Bound.AntiShake ? "Anti-shake on" : "Anti-shake off")
		}

		Humanizer() {
			this.__Toggle(A_ThisMenuItem)
			this.Parent.Bound.Humanizer := !this.Parent.Bound.Humanizer
			Menu, % A_ThisMenu, Rename, % A_ThisMenuItem, % (this.Parent.Bound.Humanizer ? "Humanizer on" : "Humanizer off")
		}

		__Toggle(Item) {
			If (Item != A_ThisMenuItem) {
				try Menu, % A_ThisMenu, UnCheck, % Item
				Menu, % A_ThisMenu, ToggleCheck, % A_ThisMenuItem
			}
			Else
				Menu, % A_ThisMenu, ToggleCheck, % Item
		}

		__Ready() {
			static ReadyFlag := 0

			If (this.Parent.AimKey) && (this.Parent.SuspendKey) && (this.Parent.Sensitivity) && !(Readyflag) {
				this.Parent.Canvas.Control("Hide", this.Parent.BoardMsg)
				this.Parent.Canvas.Control("Show", this.Parent.StartBtn)
				Readyflag := 1
			}
		}
	}
}


#Include %A_LineFile%\..\Class Tracker.ahk
#Include %A_LineFile%\..\Class hHook.ahk
#Include %A_LineFile%\..\3rd-party\Class GUI.ahk
#Include %A_LineFile%\..\3rd-party\Class WinEvents.ahk
#Include %A_LineFile%\..\3rd-party\Class HotKey.ahk
#Include %A_LineFile%\..\3rd-party\Class JSON.ahk
#Include %A_LineFile%\..\3rd-party\Class QuasiThread.ahk
#Include %A_LineFile%\..\3rd-party\Func DownloadToString.ahk