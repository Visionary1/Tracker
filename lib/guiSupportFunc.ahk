; Functions ====================================================================
WM_MOUSEMOVE(wParam, lParam, Msg, Hwnd) {
	Global

	DllCall("TrackMouseEvent", "UInt", &TME)

	MouseGetPos,,,, MouseCtrl, 2

	GuiControl, % (MouseCtrl = hButtonMinimizeN || MouseCtrl = hButtonMinimizeH) ? "Show" : "Hide", % hButtonMinimizeH
	GuiControl, % (MouseCtrl = hButtonMaximizeN || MouseCtrl = hButtonMaximizeH) ? "Show" : "Hide", % hButtonMaximizeH
	GuiControl, % (MouseCtrl = hButtonRestoreN || MouseCtrl = hButtonRestoreH) ? "Show" : "Hide", % hButtonRestoreH
	GuiControl, % (MouseCtrl = hButtonCloseN || MouseCtrl = hButtonCloseH) ? "Show" : "Hide", % hButtonCloseH

	GuiControl, % (MouseCtrl = hButtonMenuFileText) ? "Show" : "Hide", % hButtonMenuFileH
	GuiControl, % (MouseCtrl = hButtonMenuEditText) ? "Show" : "Hide", % hButtonMenuEditH
	GuiControl, % (MouseCtrl = hButtonMenuViewText) ? "Show" : "Hide", % hButtonMenuViewH
	GuiControl, % (MouseCtrl = hButtonMenuToolsText) ? "Show" : "Hide", % hButtonMenuToolsH
	GuiControl, % (MouseCtrl = hButtonMenuHelpText) ? "Show" : "Hide", % hButtonMenuHelpH
}

WM_LBUTTONDOWN(wParam, lParam, Msg, Hwnd) {
	Global

	If (MouseCtrl = hTitleHeader || MouseCtrl = hTitle) {
		PostMessage, 0xA1, 2
	}

	GuiControl, % (MouseCtrl = hButtonMinimizeH) ? "Show" : "Hide", % hButtonMinimizeP
	GuiControl, % (MouseCtrl = hButtonMaximizeH) ? "Show" : "Hide", % hButtonMaximizeP
	GuiControl, % (MouseCtrl = hButtonRestoreH) ? "Show" : "Hide", % hButtonRestoreP
	GuiControl, % (MouseCtrl = hButtonCloseH) ? "Show" : "Hide", % hButtonCloseP
}

WM_LBUTTONUP(wParam, lParam, Msg, Hwnd) {
	Global

	If (MouseCtrl = hButtonMinimizeP) {
		WinMinimize
	} Else If (MouseCtrl = hButtonMaximizeP || MouseCtrl = hButtonRestoreP) {
		WinGet, MinMaxStatus, MinMax

		If (MinMaxStatus = 1) {
			WinRestore
			GuiControl, Hide, % hButtonRestoreN
		} Else {
			WinMaximize
			GuiControl, Show, % hButtonRestoreN
		}
	} Else If (MouseCtrl = hButtonCloseP) {
		ExitApp
	} Else If (MouseCtrl = hButtonMenuFileText) {
		ControlGetPos, ctlX, ctlY, ctlW, ctlH, , ahk_id %hButtonMenuFileText%
		Menu, Fire_Menu, Show, %ctlX%, % ctlY + ctlH
	} Else If (MouseCtrl = hButtonMenuEditText) {
		ControlGetPos, ctlX, ctlY, ctlW, ctlH, , ahk_id %hButtonMenuEditText%
		Menu, Suspend_Menu, Show, %ctlX%, % ctlY + ctlH
	} Else If (MouseCtrl = hButtonMenuViewText) {
		ControlGetPos, ctlX, ctlY, ctlW, ctlH, , ahk_id %hButtonMenuViewText%
		Menu, Sens_Menu, Show, %ctlX%, % ctlY + ctlH
	} Else If (MouseCtrl = hButtonMenuToolsText) {
		ControlGetPos, ctlX, ctlY, ctlW, ctlH, , ahk_id %hButtonMenuToolsText%
		Menu, Dev_Menu, Show, %ctlX%, % ctlY + ctlH
	} Else If (MouseCtrl = hButtonMenuHelpText) {
		ControlGetPos, ctlX, ctlY, ctlW, ctlH, , ahk_id %hButtonMenuHelpText%
		Menu, Help_Menu, Show, %ctlX%, % ctlY + ctlH
	}

	GuiControl, Hide, % hButtonMinimizeP
	GuiControl, Hide, % hButtonMaximizeP
	GuiControl, Hide, % hButtonRestoreP
	GuiControl, Hide, % hButtonCloseP
	GuiControl, Hide, % hButtonMenuFileH
	GuiControl, Hide, % hButtonMenuEditH
	GuiControl, Hide, % hButtonMenuViewH
	GuiControl, Hide, % hButtonMenuToolsH
	GuiControl, Hide, % hButtonMenuHelpH
}

WM_MOUSELEAVE(wParam, lParam, Msg, Hwnd) {
	Global

	GuiControl, Hide, % hButtonMinimizeH
	GuiControl, Hide, % hButtonMaximizeH
	GuiControl, Hide, % hButtonRestoreH
	GuiControl, Hide, % hButtonCloseH
	GuiControl, Hide, % hButtonMinimizeP
	GuiControl, Hide, % hButtonMaximizeP
	GuiControl, Hide, % hButtonRestoreP
	GuiControl, Hide, % hButtonCloseP
	GuiControl, Hide, % hButtonMenuFileH
	GuiControl, Hide, % hButtonMenuEditH
	GuiControl, Hide, % hButtonMenuViewH
	GuiControl, Hide, % hButtonMenuToolsH
	GuiControl, Hide, % hButtonMenuHelpH
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