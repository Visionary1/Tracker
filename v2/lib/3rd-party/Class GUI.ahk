Class GUI 
{
	static Instances := []
	, Parameters := {   Size:["A_EventInfo", "A_GuiWidth", "A_GuiHeight"]
					, DropFiles:["A_GuiEvent", "A_EventInfo", "A_GuiControl", "A_GuiX", "A_GuiY"]
					, ContextMenu:["A_GuiEvent", "A_EventInfo", "A_GuiControl", "A_GuiX", "A_GuiY"]}
	
	__New(Title := "AutoHotkey Window", Options := "") {
		Gui, New, % "+hwndHWND " Options, % Title
		this.hwnd := HWND
		this.ahkid := "ahk_id" hwnd
		this.IsVisible := false
		Gui % this.hwnd ": -E0x10" ; disable drag-drop by default
		Gui.Instances[hwnd] := this
	}
	
	__Delete() {
		try this.Destroy()
		Gui.Instances[hwnd] := ""
	}
	
	; bind a function/method to a control with the Function parameter. example: Instance.Method.Bind(Instance, Param1, Param2, ...)
	Add(ControlType, Options := "", Params := "", Function := "") {
		Gui % this.hwnd ":Add", % ControlType, % Options " hwndControlHWND", % Params
		If (Function)
			GuiControl, +g, % ControlHWND, % Function ; ty geekdude for this amazing godsent knowledge, may the darkness of labels be eternally abolished
		Return ControlHWND
	}

	Release_glabel(hwnd) {
		GuiControl, -g, % hwnd
	}
	
	Control(Command := "", Control := "", ControlParams := "") {
		GuiControl % this.hwnd ":" Command, % Control, % ControlParams
	}
	
	Show(Options := "", Title := "") {
		this.IsVisible := true
		Gui % this.hwnd ":Show", % Options, % Title
	}
	
	Hide(Options := "") {
		this.IsVisible := false
		Gui % this.hwnd ":Hide", % Options
	}
	
	SetDefault() {
		Gui % this.hwnd ":Default"
	}
	
	Activate() {
		WinActivate % this.ahkid
	}
	
	Tab(num) {
		Gui % this.hwnd ":Tab", % num
	}
	
	Disable() {
		Gui % this.hwnd ":+Disabled"
	}
	
	Enable() {
		Gui % this.hwnd ":-Disabled"
	}
	
	SetTitle(NewTitle) {
		;WinSetTitle, % this.ahkid,, % NewTitle
		this.Show(this.IsVisible ? "" : "Hide", NewTitle)
		;tooltip % errorlevel
	}
	
	ControlGet(Command, Value := "", Control := "") {
		ControlGet, out, % Command, % (StrLen(Value) ? Value : ""), % (StrLen(Control) ? Control : ""), % this.ahkid
		Return out
	}
	
	GuiControlGet(Command := "", Control := "", Param := "") {
		GuiControlGet, out, % (StrLen(Command) ? Command : ""), % (StrLen(Control) ? Control : ""), % (StrLen(Param) ? Param : "")
		Return out
	}
	
	Pos(x := "", y := "", w := "", h := "", NoActivate := true) {
		WinMove, % this.ahk_id,, % x, % y, % w, % h
	}
	
	SetIcon(Icon) {
		hIcon := DllCall("LoadImage", UInt,0, Str, Icon, UInt, 1, UInt, 0, UInt, 0, UInt, 0x10)
		SendMessage, 0x80, 0, hIcon ,, % this.ahkid  ; One affects Title bar and
		SendMessage, 0x80, 1, hIcon ,, % this.ahkid  ; the other the ALT+TAB menu
	}
	
	Destroy() {
		this.IsVisible := false
		Gui % this.hwnd ":Destroy"
	}
	
	Color(BackgroundColor := "", ControlColor := "") {
		Gui % this.hwnd ":Color", % BackgroundColor, % ControlColor
	}
	
	Options(Options, ext := "") {
		Gui % this.hwnd ":" Options, % ext
	}
	
	Margin(HorizontalMargin, VerticalMargin) {
		Gui % this.hwnd ":Margin", % HorizontalMargin, % VerticalMargin
	}
	
	Font(Options := "", Font := "") {
		Gui % this.hwnd ":Font", % Options, % Font
	}
	
	Submit(Options := "") {
		Gui % this.hwnd ":Submit", % Options
	}
	
	GetText(Control) {
		ControlGetText, ControlText, % Control, % this.ahkid
		return ControlText
	}
	
	SetText(Control, Text := "") {
		this.Control(, Control, Text)
	}
	
	DropFilesToggle(Toggle) {
		this.Options((Toggle ? "+" : "-") . "E0x10")
	}
	
	/*
		for more documentation on window events look here: https://autohotkey.com/docs/commands/Gui.htm#Labels
			
		window event labels call the instance method. GuiClose will call Instance.Close() and GuiDropFiles will call Instance.DropFiles() with all the appropriate parameters.
	*/
	
	Close() {
		this.Destroy()
	}
	
	Escape() {
		this.Close()
	}	
	
	/*
		FileList = list of files, separated by linefeed (`n)
		FileCount = number of files dropped
		ControlHWND = name of control under mouse when files were dropped
		GuiX = X position on gui where files were dropped
		GuiY = Y position
	*/
	DropFiles(FileList, FileCount, ControlHWND, GuiX, GuiY) {
	}
	
	/*
		EventInfo = 0: The window has been restored, or resized normally such as by dragging its edges, 1: The window has been minimized, 2: The window has been maximized.
		GuiWidth = new width of the gui
		GuiHeight = new height of the gui
		
		if you need the x/y position you can use WinGetPos, GuiX, GuiY,,, % this.ahkid 
	*/
	Size(EventInfo, GuiWidth, GuiHeight) {
	}
	
	/*
			ControlHWND = control that received the ContextMenu EventInfo
		ControlInfo = info from the control, for example the clicked row in a listview
		IsRightClick = Contains "RightClick" if the Gui was right-clicked and "Normal" if the menu was triggered by the Apps key or Shift-F10
		GuiX = X position of the event
		GuiY = Y position of the event
	*/
	ContextMenu(IsRightClick, ControlInfo, ControlHWND, GuiX, GuiY) {
	}
}

CreateDIB(Input, W, H, ResizeW := 0, ResizeH := 0, Gradient := 1 ) {
	WB := Ceil((W * 3) / 2) * 2, VarSetCapacity(BMBITS, (WB * H) + 1, 0), P := &BMBITS

	Loop, Parse, Input, |
	{
		P := Numput("0x" . A_LoopField, P + 0, 0, "UInt") - (W & 1 && Mod(A_Index * 3, W * 3) = 0 ? 0 : 1)
	}

	hBM := DllCall("CreateBitmap", "Int", W, "Int", H, "UInt", 1, "UInt", 24, "Ptr", 0, "Ptr")
	hBM := DllCall("CopyImage", "Ptr", hBM, "UInt", 0, "Int", 0, "Int", 0, "UInt", 0x2008, "Ptr")
	DllCall("SetBitmapBits", "Ptr", hBM, "UInt", WB * H, "Ptr", &BMBITS)

	If (Gradient != 1) {
		hBM := DllCall("CopyImage", "Ptr", hBM, "UInt", 0, "Int", 0, "Int", 0, "UInt", 0x0008, "Ptr")
	}

	return DllCall("CopyImage", "Ptr", hBM, "Int", 0, "Int", ResizeW, "Int", ResizeH, "Int", 0x200C, "UPtr")
}