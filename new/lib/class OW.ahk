class OW
{
	__New(json)
	{	
		Window := {Width: json.width
				, Height: json.height
				, Title: SubStr(A_ScriptName, 1, -4)
				, StatusBarText: json.statusbartext}
		
		this.Gui := new GUI(Window.Title, "+LastFound -Resize -Caption -Border")
		this.Gui.Color("FFFFFF")
		this.Gui.Margin(10, 10)
		
		this.Bound := []
		this.Bound.OnMessage := ObjBindMethod(OW.OnMessage, "Calls", this)
		
		this.AntiShake := 1		; prevent shakes
		this.Humanizer := 1 	; default
		this.Alternative := 1 	; mt seems to work better
		this.Delay := 30 		; default delay
		
		Buttons := new OW.MenuButtons(this)
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
		]], ["Smoothness", [
				["Manually", Buttons.Custom.Bind(Buttons)],
				["1", Buttons.Smoothness.Bind(Buttons)],
				["1", Buttons.Smoothness.Bind(Buttons)],
				["1.5", Buttons.Smoothness.Bind(Buttons)],
				["2", Buttons.Smoothness.Bind(Buttons)],
				["2.5", Buttons.Smoothness.Bind(Buttons)],
				["3", Buttons.Smoothness.Bind(Buttons)],
				["3.5", Buttons.Smoothness.Bind(Buttons)],
				["4", Buttons.Smoothness.Bind(Buttons)],
				["4.5", Buttons.Smoothness.Bind(Buttons)],
				["5", Buttons.Smoothness.Bind(Buttons)],
				["5.5", Buttons.Smoothness.Bind(Buttons)],
				["6", Buttons.Smoothness.Bind(Buttons)],
				["6.5", Buttons.Smoothness.Bind(Buttons)],
				["7", Buttons.Smoothness.Bind(Buttons)],
				["8", Buttons.Smoothness.Bind(Buttons)],
				["9", Buttons.Smoothness.Bind(Buttons)]
		]], ["Advanced", [
				["Set Delay [30]", Buttons.Delay.Bind(Buttons)],
				["Anti-Shake [ON]", Buttons.AntiShake.Bind(Buttons)],
				["Humanizer [ON]", Buttons.Humanizer.Bind(Buttons)],
				["Alternative Mode [ON]", Buttons.Alternative.Bind(Buttons)],
				["Roadhog Hook lock [OFF]", Buttons.RoadHog.Bind(Buttons)]
			]]
		]
		)
		
		this.Menus := MenuBar.Create(Menus, "OW_")
		this.Gui.Options("Menu", this.Menu[1])
		MenuBar.Item.Disable("OW_4", ["Humanizer [ON]", "Alternative Mode [ON]", "Roadhog Hook lock [OFF]"])
		MenuBar.Item.Toggle("OW_4", ["Alternative Mode [ON]", "Humanizer [ON]", "Anti-Shake [ON]", "Set Delay [30]"])
		MenuBar.Tray.NoStandard()
		
		this.hBorderLeft := this.Gui.Add("Text", "x" 0 " y" 0 " w" 1 " h" Window.Height " +0x4E")
		this.hBorderRight := this.Gui.Add("Text", "x" Window.Width-1 " y" 0 " w" 1 " h" Window.Height " +0x4E")
		this.hBorderBottom := this.Gui.Add("Text", "x" 1 " y" Window.Height-1 " w" Window.Width-2 " h" 1 " +0x4E")
		
		For Key, Value in [this.hBorderLeft, this.hBorderRight, this.hBorderBottom]
			DllCall("SendMessage", "Ptr", Value, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0072C6", 1, 1))
		
		this.hTitleHeader := this.Gui.Add("Text", "x" 1 " y" 0 " w" Window.Width-2 " h" 67 " +0x4E")
		DllCall("SendMessage", "Ptr", this.hTitleHeader, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
		
		this.Gui.Font("s9 cFFFFFF", "Segoe UI")
		this.hTitle := this.Gui.Add("Text", "x" 140 " y" 12 " w" Window.Width-280 " +BackgroundTrans +0x101", Window.Title)
		this.Gui.Font()
		
		this.hStatusBar := this.Gui.Add("Picture", "x" 1 " y" Window.Height-23 " w" Window.Width-2 " h" 22 " +0x4E")
		StatusBar := "#@@@@@@@@@@@@@@@@@@@@@"
		StringReplace, StatusBar, StatusBar, #, BFBFBF|, All
		StringReplace, StatusBar, StatusBar, @, F1F1F1|, All
		StringTrimRight, StatusBar, StatusBar, 1
		DllCall("SendMessage", "Ptr", this.hStatusBar, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(StatusBar, 1, 22))
		
		this.Gui.Font("s8 c515050", "Segoe UI")
		this.hStatusBarText := this.Gui.Add("Text", "x" 8 " y" Window.Height-19 " w" Window.Width-16 " +BackgroundTrans", Window.StatusBarText)
		this.Gui.Font()
		
		this.hButtonMinimizeN := this.Gui.Add("Picture", "x" Window.Width-139 " y" 1 " w" 46 " h" 31 " +0x4E Hidden0")
		this.hButtonMinimizeH := this.Gui.Add("Picture", "x" Window.Width-139 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		this.hButtonMinimizeP := this.Gui.Add("Picture", "x" Window.Width-139 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		
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
		
		
		this.hButtonMaximizeN := this.Gui.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden0")
		this.hButtonMaximizeH := this.Gui.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		this.hButtonMaximizeP := this.Gui.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		
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
		
		
		this.hButtonRestoreN := this.Gui.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		this.hButtonRestoreH := this.Gui.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		this.hButtonRestoreP := this.Gui.Add("Picture", " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		
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
		
		
		this.hButtonCloseN := this.Gui.Add("Picture", " x" Window.Width-47 " y" 1 " w" 46 " h" 31 " +0x4E Hidden0")
		this.hButtonCloseH := this.Gui.Add("Picture", " x" Window.Width-47 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		this.hButtonCloseP := this.Gui.Add("Picture", " x" Window.Width-47 " y" 1 " w" 46 " h" 31 " +0x4E Hidden1")
		
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
		
		this.Gui.Font("s9 cFFFFFF", "Segoe UI")
		
		; // 1st Menu
		this.hButtonMenu1N := this.Gui.Add("Picture", " x" 2 " y" 36 " w" 60 " h" 24 " +0x4E Hidden0")
		this.hButtonMenu1H := this.Gui.Add("Picture", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E Hidden1")
		this.hButtonMenu1Text := this.Gui.Add("Text", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +BackgroundTrans +0x201", "Aim")
		
		; // 2nd Menu
		this.hButtonMenu2N := this.Gui.Add("Picture", " x+" 2 " yp" 0 " w" 60 " h" 24 " +0x4E Hidden0")
		this.hButtonMenu2H := this.Gui.Add("Picture", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E Hidden1")
		this.hButtonMenu2Text := this.Gui.Add("Text", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +BackgroundTrans +0x201", "Suspend")
		
		; // 3rd Menu
		this.hButtonMenu3N := this.Gui.Add("Picture", " x+" 2 " yp" 0 " w" 80 " h" 24 " +0x4E Hidden0")
		this.hButtonMenu3H := this.Gui.Add("Picture", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E Hidden1")
		this.hButtonMenu3Text := this.Gui.Add("Text", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +BackgroundTrans +0x201", "Smoothness")
		
		; // 4th Menu
		this.hButtonMenu4N := this.Gui.Add("Picture", " x+" 2 " yp" 0 " w" 60 " h" 24 " +0x4E Hidden0")
		this.hButtonMenu4H := this.Gui.Add("Picture", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E Hidden1")
		this.hButtonMenu4Text := this.Gui.Add("Text", " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +BackgroundTrans +0x201", "Advanced")
		
		For Key, Value in [this.hButtonMenu1N, this.hButtonMenu2N, this.hButtonMenu3N, this.hButtonMenu4N]
			DllCall("SendMessage", "Ptr", Value, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
		For Key, Value in [this.hButtonMenu1H, this.hButtonMenu2H, this.hButtonMenu3H, this.hButtonMenu4H]
			DllCall("SendMessage", "Ptr", Value, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("2A8AD4", 1, 1))
		
		this.Gui.Font()
		this.BoardMsg := this.Gui.Add("Text", "x20 y80", DownloadToStr("https://raw.githubusercontent.com/Visionary1/Tracker/master/Board.txt"))
		this.StartBtn := this.Gui.Add("Button", "x20 y80 w" Window.Width - 40 " h" Window.Height - 120 " Hidden", "initialize", ObjBindMethod(OW.Run, "Initialize", this))
		
		WinEvents.Register(this.Gui.hwnd, this)
		For each, Msg in [0x200, 0x201, 0x202, 0x2A3] ; WM_MOUSEMOVE, WM_LBUTTONDOWN, WM_LBUTTONUP, WM_MOUSELEAVE
			OnMessage(Msg, this.Bound.OnMessage)

		this.Gui.Show(" w" Window.Width " h" Window.Height)
	}
	
	GuiClose()
	{
		this.Bound.HotKey.Delete()

		; Relase wm_message hooks
		For each, Msg in [0x200, 0x201, 0x202, 0x2A3]
			OnMessage(Msg, this.Bound.OnMessage, 0)
		
		If (this.Alternative)
		{
			this.Bound.Thread := ""
		}
		
		this.Tracker := ""
		this.Delete("Bound")
		WinEvents.Unregister(this.Gui.hwnd)
		this.Gui.Destroy()

		; // Release menu bar (Has to be done after Gui, Destroy)
		For each, MenuName in this.Menus
			Menu, %MenuName%, DeleteAll

		; // pushed by interface
		this.RegisterCloseCallback()
	}
	
	class Run
	{
		Initialize(self)
		{
			self.Gui.Control("Hide", self.StartBtn)
			self.Gui.Control("Show", self.BoardMsg)
			
			self.Tracker := new Tracker()
			
			pn := new PureNotify(self.Tracker.X1, self.Tracker.Y1, (self.Tracker.X2 - self.Tracker.X1), (self.Tracker.Y2 - self.Tracker.Y1))
			pn.Text("Initializing..."
			, "Searching area is (" (self.Tracker.X2 - self.Tracker.X1) "x" (self.Tracker.Y2 - self.Tracker.Y1) ")`n`nAim [" 
			. self.AimKey "]`nSuspend [" self.SuspendKey "]`nSmoothness [" self.Sensitivity
			. "]`nAnti-shake " (self.AntiShake ? "[ON]" : "[OFF]")
			. "`nDelay [" self.Delay "]")
			Sleep, 5000
			pn := ""
			
			If (self.Alternative)
			{
				self.Bound.Thread := new Thread(ObjBindMethod(OW.Run, "As_alternative", self), self.Delay)
				self.Bound.Thread.Start()
			}
			else
			{
				this.As_normal(self)
			}
		}

		Debug(self)
		{
			ToolTip, % self.AntiShake "`n" self.Sensitivity "`n" self.AimKey
		}
		
		As_normal(self)
		{
			While, !self.Alternative
			{
				;ToolTip, standard
				If (self.Tracker.Firing(self.AimKey))
				{
					self.Tracker.Calculate(self.Sensitivity, self.AntiShake, self.Humanizer)
				}
				
				DllCall("Sleep", "UInt", self.Delay)
			}
		}
		
		As_alternative(self)
		{
			; If !A_IsCompiled
			; 	ToolTip, % A_TickCount

			If (self.Tracker.Firing(self.AimKey))
			{
				self.Tracker.Calculate(self.Sensitivity, self.AntiShake, self.Humanizer)
			}
		}
		
		Pause(self)
		{
			static flag := True
			
			If !(self.Bound.Thread)
				Return
			
			If (flag)
			{
				self.Bound.Thread.Stop()
			}
			Else If !(flag)
			{
				self.Bound.Thread.Start()
			}
			
			flag := !flag

			; // debug purpose...
			If !(A_IsCompiled)
				TrayTip, % "Tracker", % flag ? "OFF" : "ON"
			
			;Pause, Toggle, 1
		}
	}
	
	class MenuButtons
	{
		__New(self) 
		{
			this.__Parent := &self
		}
		
		Parent[]
		{
			get {
				If (NumGet(this.__Parent) = NumGet(&this)) ; safety check or you can use try/catch/finally
					Return Object(this.__Parent)
			}
		}
		
		AimKey()
		{
			MenuBar.Item.Toggle(A_ThisMenu, this.Parent.AimKey, A_ThisMenuItem)
			this.Parent.AimKey := A_ThisMenuItem
			this.Initialize()
		}
		
		SuspendKey()
		{
			MenuBar.Item.Toggle(A_ThisMenu, this.Parent.SuspendKey, A_ThisMenuItem)

			If (this.Parent.Bound.HotKey)
				this.Parent.Bound.HotKey.Delete()

			this.Parent.Bound.HotKey := new HotKey(A_ThisMenuItem, ObjBindMethod(OW.Run, "Pause", this.Parent))
			this.Parent.SuspendKey := A_ThisMenuItem
			this.Initialize()
		}
		
		Smoothness()
		{
			MenuBar.Item.Toggle(A_ThisMenu, this.Parent.Sensitivity, A_ThisMenuItem)
			this.Parent.Sensitivity := A_ThisMenuItem
			this.Initialize()
		}
		
		Custom()
		{
			Gui, % WinExist("A") ": +OwnDialogs"
			InputBox, OutputVar, % A_TickCount, input number for Smoothness,, 300, 150,,,,, type number (0.00~100.00)

			If (ErrorLevel = 0)
			{
				; to prevent duplicate items (eg, 1, 2, 3 ...)
				IF OutputVar = 0
					Return
				
				If OutputVar Is Float
					OutputVar := OutputVar . "0"
				Else If OutputVar Is Integer
					OutputVar := OutputVar . ".0"
				Else
					Return
				
				MenuBar.Item.Toggle(A_ThisMenu, this.Parent.Sensitivity, A_ThisMenuItem)
				this.Parent.Sensitivity := OutputVar
				MenuBar.Item.Rename(A_ThisMenu, A_ThisMenuItem, this.Parent.Sensitivity)
				this.Initialize()
			}
		}
		
		; // WIP
		Alternative()
		{
			MenuBar.Item.Toggle(A_ThisMenu, A_ThisMenuItem)
			this.Parent.Bound.Alternative := !this.Parent.Bound.Alternative
			
			If !(this.Parent.Bound.Alternative) ;turn off Alternative mode and switch to standard
			{
				this.Parent.Bound.Thread.Stop()
				;this.Parent.Bound.Thread := ""
				
				; has to fix an issue
				Return this.Parent.Run._Standard(this.Parent)
			}
			Else If (this.Parent.Bound.Alternative) ;turn Alternative mode on
			{
				Return this.Parent.Bound.Thread.Start()
			}
		}
		
		Delay()
		{
			Gui, % WinExist("A") ": +OwnDialogs"
			InputBox, OutputVar, % A_TickCount, Set default sleep time for each process,, 300, 150,,,,, in millisecond (10 = 0.01 sec)
			If (ErrorLevel = 0)
			{
				If OutputVar Is Not Number
					Return
				
				this.Parent.Delay := Round(OutputVar)
				MenuBar.Item.Rename(A_ThisMenu, A_ThisMenuItem, "Delay [" this.Parent.Delay "]")
				
				If (this.Parent.Alternative) && (this.Parent.Bound.Thread)
				{
					this.Parent.Bound.Thread := ""
					this.Parent.Bound.Thread := new Thread(ObjBindMethod(OW.Run, "As_alternative", this.Parent), this.Parent.Delay)
					this.Parent.Bound.Thread.Start()
				}
			}
		}
		
		AntiShake()
		{
			MenuBar.Item.Toggle(A_ThisMenu, A_ThisMenuItem)
			this.Parent.AntiShake := !this.Parent.AntiShake
			MenuBar.Item.Rename(A_ThisMenu, A_ThisMenuItem, this.Parent.AntiShake ? "Anti-shake [ON]" : "Anti-shake [OFF]")
		}
		
		; // WIP
		Humanizer()
		{
			; Menu, % A_ThisMenu, ToggleCheck, % A_ThisMenuItem
			; this.Parent.Bound.Humanizer := !this.Parent.Bound.Humanizer
			; Menu, % A_ThisMenu, Rename, % A_ThisMenuItem, % (this.Parent.Bound.Humanizer ? "Humanizer on" : "Humanizer off")
		}
		
		RoadHog()
		{
			static toggleFlag := 0 ;, CSID, obj
			;global InGameSens
			
			/*
			If !CSID
			CSID := CreateGUID()
			
			If (toggleFlag) {
				; if running
				obj.Terminate(), ObjRegisterActive(hKeybd, "")
				Menu, % A_ThisMenu, UnCheck, % "Roadhog Hook lock [ON]"
				Menu, % A_ThisMenu, Rename, % A_ThisMenuItem, % "Roadhog Hook lock [OFF]"
				Return toggleFlag := 0
			}
			
			Gui, % WinExist("A") ": +OwnDialogs"
			InputBox, OutputVar, Hook, input your 'in-game' sensitivity,, 300, 150,,,,, only 'in-game' sensitivity (0.00~100.00)
			If (ErrorLevel = 0) {
				If OutputVar Is Not Number
				Return
				
				InGameSens := OutputVar
				
				ObjRegisterActive(hKeybd, CSID)
				
				code =
				(LTrim
				#SingleInstance, Force
				#NoEnv
				#KeyHistory, 0
				#Persistent
				ListLines, Off
				SetBatchLines, -1
				CoordMode, Pixel, Screen
				
				baseObj := ComObjActive("%CSID%")
				obj := new baseObj()
				Return
				)
				FileDelete, % A_ScriptDir . "\Internal.ahk"
				
				FileOpen(A_ScriptDir . "\Internal.ahk", "rw", "UTF-8").Write(code).Close()
				obj := new DynaScript(FileOpen("Internal.ahk", "r").Read())
				obj.Exec()
				
				Instruction := "Hook lock has been set up"
				Content := "'Shift' will trigger the hook lock"
				TaskDialog(Instruction, Content, "Roadhog Hook lock", 0x1, 0xFFFD, "", WinExist("A"))
				toggleFlag := 1
				Menu, % A_ThisMenu, Rename, % A_ThisMenuItem, % "Roadhog Hook lock [ON]"
				Menu, % A_ThisMenu, Check, % "Roadhog Hook lock [ON]"
			}
			*/
			
			
			If (toggleFlag)
			{
				this.Parent.Bound.Lock := ""
				MenuBar.Item.Toggle(A_ThisMenu, "Roadhog Hook Lock [ON]")
				MenuBar.Item.Rename(A_ThisMenu, A_ThisMenuItem, "Roadhog Hook Lock [OFF]")
				toggleFlag := 0
				Return
			}
			
			Gui, % WinExist("A") ": +OwnDialogs"
			InputBox, OutputVar, % A_TickCount, input your 'in-game' sensitivity,, 300, 150,,,,, only 'in-game' sensitivity (0.00~100.00)
			If (ErrorLevel = 0)
			{
				If OutputVar Is Not Number
					Return
				
				this.Parent.Bound.Lock := new hKeyBd(ObjBindMethod(AimLock, "RoadHog", OutputVar))
				Instruction := "Hook lock has been set up", Content := "'Shift' will trigger the hook lock"
				TaskDialog(Instruction, Content, A_TickCount, 0x1, 0xFFFD, "", WinExist("A"))
				toggleFlag := 1
				MenuBar.Item.Rename(A_ThisMenu, A_ThisMenuItem, "Roadhog Hook Lock [ON]")
				MenuBar.Item.Toggle(A_ThisMenu, "Roadhog Hook Lock [ON]")
			}
		}
		
		Initialize()
		{
			static flag := 0
			
			If (this.Parent.AimKey) && (this.Parent.SuspendKey) && (this.Parent.Sensitivity) && !(flag)
			{
				this.Parent.Gui.Control("Hide", this.Parent.BoardMsg)
				this.Parent.Gui.Control("Show", this.Parent.StartBtn)
				flag := 1
			}
		}
	}
	
	GuiSize()
	{
		If (ErrorLevel = 1)
			Return

		this.Gui.Control("MoveDraw", this.hTitleHeader, " w" A_GuiWidth-2)
		, this.Gui.Control("MoveDraw", this.hBorderLeft, " h" A_GuiHeight)
		, this.Gui.Control("MoveDraw", this.hBorderRight, " x" A_GuiWidth-1 " h" A_GuiHeight)
		, this.Gui.Control("MoveDraw", this.hBorderBottom, " y" A_GuiHeight-1 " w" A_GuiWidth-2)
		, this.Gui.Control("MoveDraw", this.hTitle, " w" A_GuiWidth-280)
		, this.Gui.Control("MoveDraw", this.hStatusBar, " w" A_GuiWidth-2 " y" A_GuiHeight-23)
		, this.Gui.Control("MoveDraw", this.hStatusBarText, " w" A_GuiWidth-16 " y" A_GuiHeight-19)
		, this.Gui.Control("MoveDraw", this.hButtonMinimizeN, " x" A_GuiWidth-139)
		, this.Gui.Control("MoveDraw", this.hButtonMinimizeH, " x" A_GuiWidth-139)
		, this.Gui.Control("MoveDraw", this.hButtonMinimizeP, " x" A_GuiWidth-139)
		, this.Gui.Control("MoveDraw", this.hButtonMaximizeN, " x" A_GuiWidth-93)
		, this.Gui.Control("MoveDraw", this.hButtonMaximizeH, " x" A_GuiWidth-93)
		, this.Gui.Control("MoveDraw", this.hButtonMaximizeP, " x" A_GuiWidth-93)
		, this.Gui.Control("MoveDraw", this.hButtonRestoreN, " x" A_GuiWidth-93)
		, this.Gui.Control("MoveDraw", this.hButtonRestoreH, " x" A_GuiWidth-93)
		, this.Gui.Control("MoveDraw", this.hButtonRestoreP, " x" A_GuiWidth-93)
		, this.Gui.Control("MoveDraw", this.hButtonCloseN, " x" A_GuiWidth-47)
		, this.Gui.Control("MoveDraw", this.hButtonCloseH, " x" A_GuiWidth-47)
		, this.Gui.Control("MoveDraw", this.hButtonCloseP, " x" A_GuiWidth-47)
	}
	
	class OnMessage
	{
		Calls(self, wParam, lParam, Msg, hWnd)
		{
			If (hWnd = self.Gui.hwnd)
			{
				MouseGetPos,,,, MouseCtrl, 2
				
				If (Msg = 0x200)
					Return this.WM_MOUSEMOVE(self, MouseCtrl)
				Else If (Msg = 0x201)
					Return this.WM_LBUTTONDOWN(self, MouseCtrl)
				Else If (Msg = 0x202)
					Return this.WM_LBUTTONUP(self, MouseCtrl)
				Else If (Msg = 0x2A3)
					Return this.WM_MOUSELEAVE(self)
			}
		}
		
		WM_MOUSEMOVE(self, MouseCtrl)
		{
			self.Gui.Control( (MouseCtrl = self.hButtonMinimizeN || MouseCtrl = self.hButtonMinimizeH) ? "Show" : "Hide", self.hButtonMinimizeH )
			, self.Gui.Control( (MouseCtrl = self.hButtonMaximizeN || MouseCtrl = self.hButtonMaximizeH) ? "Show" : "Hide", self.hButtonMaximizeH )
			, self.Gui.Control( (MouseCtrl = self.hButtonRestoreN || MouseCtrl = self.hButtonRestoreH) ? "Show" : "Hide", self.hButtonRestoreH )
			, self.Gui.Control( (MouseCtrl = self.hButtonCloseN || MouseCtrl = self.hButtonCloseH) ? "Show" : "Hide", self.hButtonCloseH )
			, self.Gui.Control( (MouseCtrl = self.hButtonMenu1Text) ? "Show" : "Hide", self.hButtonMenu1H )
			, self.Gui.Control( (MouseCtrl = self.hButtonMenu2Text) ? "Show" : "Hide", self.hButtonMenu2H )
			, self.Gui.Control( (MouseCtrl = self.hButtonMenu3Text) ? "Show" : "Hide", self.hButtonMenu3H )
			, self.Gui.Control( (MouseCtrl = self.hButtonMenuToolsText) ? "Show" : "Hide", self.hButtonMenuToolsH )
			, self.Gui.Control( (MouseCtrl = self.hButtonMenu4Text) ? "Show" : "Hide", self.hButtonMenu4H )

		}
		
		WM_LBUTTONDOWN(self, MouseCtrl)
		{
			If (MouseCtrl = self.hTitleHeader || MouseCtrl = self.hTitle)
			{
				DllCall("user32.dll\PostMessage", "Ptr", self.Gui.hwnd, "UInt", 0xA1, "Ptr", 2, "Ptr", 0)
			}
			self.Gui.Control( (MouseCtrl = self.hButtonMinimizeH) ? "Show" : "Hide", self.hButtonMinimizeP )
			, self.Gui.Control( (MouseCtrl = self.hButtonMaximizeH) ? "Show" : "Hide", self.hButtonMaximizeP )
			, self.Gui.Control( (MouseCtrl = self.hButtonRestoreH) ? "Show" : "Hide", self.hButtonRestoreP )
			, self.Gui.Control( (MouseCtrl = self.hButtonCloseH) ? "Show" : "Hide", self.hButtonCloseP )
		}
		
		WM_LBUTTONUP(self, MouseCtrl)
		{
			If (MouseCtrl = self.hButtonMinimizeP){
				WinMinimize
			}
			else If (MouseCtrl = self.hButtonMaximizeP || MouseCtrl = self.hButtonRestoreP){
				WinGet, MinMaxStatus, MinMax
				
				If (MinMaxStatus = 1){
					WinRestore
					GuiControl, Hide, % self.hButtonRestoreN
				}
				else {
					WinMaximize
					GuiControl, Show, % self.hButtonRestoreN
				}
			}
			else If (MouseCtrl = self.hButtonCloseP){
				self.GuiClose()
			}
			else If (MouseCtrl = self.hButtonMenu1Text){
				ControlGetPos, ctlX, ctlY, ctlW, ctlH, , % "ahk_id " self.hButtonMenu1Text
				Menu, OW_1, Show, %ctlX%, % ctlY + ctlH
			}
			else If (MouseCtrl = self.hButtonMenu2Text){
				ControlGetPos, ctlX, ctlY, ctlW, ctlH, , % "ahk_id " self.hButtonMenu2Text
				Menu, OW_2, Show, %ctlX%, % ctlY + ctlH
			}
			else If (MouseCtrl = self.hButtonMenu3Text){
				ControlGetPos, ctlX, ctlY, ctlW, ctlH, , % "ahk_id " self.hButtonMenu3Text
				Menu, OW_3, Show, %ctlX%, % ctlY + ctlH
			}
			else If (MouseCtrl = self.hButtonMenu4Text){
				ControlGetPos, ctlX, ctlY, ctlW, ctlH, , % "ahk_id " self.hButtonMenu4Text
				Menu, OW_4, Show, %ctlX%, % ctlY + ctlH
			}
			
			self.Gui.Control("Hide", self.hButtonMinimizeP)
			, self.Gui.Control("Hide", self.hButtonMaximizeP)
			, self.Gui.Control("Hide", self.hButtonRestoreP)
			, self.Gui.Control("Hide", self.hButtonCloseP)
			, self.Gui.Control("Hide", self.hButtonMenu1H)
			, self.Gui.Control("Hide", self.hButtonMenu2H)
			, self.Gui.Control("Hide", self.hButtonMenu3H)
			, self.Gui.Control("Hide", self.hButtonMenu4H)
		}
		
		WM_MOUSELEAVE(self)
		{
			static Handles := ["hButtonMinimizeH", "hButtonMaximizeH", "hButtonRestoreH", "hButtonCloseH"
			, "hButtonMinimizeP", "hButtonMaximizeP", "hButtonRestoreP", "hButtonCloseP"
			, "hButtonMenu1H", "hButtonMenu2H", "hButtonMenu3H", "hButtonMenu4H"]
			
			For Key, Value in Handles
				self.Gui.Control("Hide", self.Value)
		}
	}
}


#Include %A_LineFile%\..\class Tracker.ahk
#Include %A_LineFile%\..\class Thread.ahk
#Include %A_LineFile%\..\3rd-party\Class hHook.ahk
#Include %A_LineFile%\..\3rd-party\Class PureNotify.ahk
#Include %A_LineFile%\..\3rd-party\Class GUI.ahk
#Include %A_LineFile%\..\3rd-party\Class MenuBar.ahk
#Include %A_LineFile%\..\3rd-party\Class WinEvents.ahk
#Include %A_LineFile%\..\3rd-party\Class HotKey.ahk
#Include %A_LineFile%\..\3rd-party\Class JSON.ahk
#Include %A_LineFile%\..\3rd-party\Func DownloadToString.ahk
#Include %A_LineFile%\..\3rd-party\Class TaskDialog.ahk
;#Include %A_LineFile%\..\3rd-party\Func NET Framework Interop.ahk              