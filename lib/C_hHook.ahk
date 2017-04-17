Class hHook
{
	static WH_MOUSE_LL := 14, WH_KEYBOARD_LL := 13

	UnHook(hHook)
	{
		this.UnhookWindowsHookEx(hHook)
	}

	UnhookWindowsHookEx(hHook)
	{
		Return DllCall("UnhookWindowsHookEx", "Uint", hHook)
	}

	CallNextHookEx(nCode, wParam, lParam, hHook = 0)
	{
		Return DllCall("CallNextHookEx", "Uint", hHook, "int", nCode, "Uint", wParam, "Uint", lParam)
	}

	SetWindowsHookEx(idHook, pfn)
	{
		Return DllCall("SetWindowsHookEx", "int", idHook, "Uint", pfn, "Uint", DllCall("GetModuleHandle", "Uint", 0), "Uint", 0)
	}
}

Class hHookMouse extends hHook
{
	__New(Func)
	{
		this.Mouse := this.SetWindowsHookEx(base.WH_MOUSE_LL, RegisterCallback(Func, "Fast"))
	}

	__Delete()
	{
		this.UnHook(this.Mouse)
	}
}

Class hHookKeybd extends hHook
{
	__New(Func)
	{
		this.Keybd := this.SetWindowsHookEx(base.WH_KEYBOARD_LL, RegisterCallback(Func, "Fast"))
	}

	__Delete()
	{
		this.UnHook(this.Keybd)
	}
}

__hHookKeybd(nCode, wParam, lParam)
{
	global Application

	Critical

	SetFormat, Integer, H
	If ((wParam = 0x100)  ; WM_KEYDOWN
	|| (wParam = 0x101))  ; WM_KEYUP
	{
		KeyName := GetKeyName("vk" NumGet(lParam+0, 0))
		Tooltip, % (wParam = 0x100) ? KeyName " Down" : KeyName " Up"

		If (KeyName = "LShift")
		{
			Application.OW.Search(), Application.OW.Calculate_v2(5.5)
		}

	}
	Return hHook.CallNextHookEx(nCode, wParam, lParam)
}

__hHookMouse(nCode, wParam, lParam)
{
	;global Application
	;Critical
	;SetFormat, Integer, D
	; If (wParam = 0x201)
	; {
	; 	; If ( Application.OW.bufferflag )
	; 	; {
	; 	; 	Return
	; 	; }
	; 	ToolTip, 누름
	; 	;Return -1 ; here goes the code
	; 	return -1
	; }
	; If (wParam = 0x202)
	; 	return -1
	If !nCode && (wParam = 0x200)
	Tooltip, % " X: " . NumGet(lParam+0, 0, "int")
	. " Y: " . NumGet(lParam+0, 4, "int")
	
	Return hHook.CallNextHookEx(nCode, wParam, lParam)
}

#Persistent
tmp := new hHookKeybd(ObjBindMethod(Test, "Keybd"))
Return



; WM_MOUSEMOVE = 0x200
; WM_LBUTTONDOWN = 0x201
; WM_LBUTTONUP = 0x202
; WM_LBUTTONDBLCLK = 0x203
; WM_RBUTTONDOWN = 0x204
; WM_RBUTTONUP = 0x205
; WM_RBUTTONDBLCLK = 0x206
; WM_MBUTTONDOWN = 0x207
; WM_MBUTTONUP = 0x208
; WM_MBUTTONDBLCLK = 0x209
; WM_MOUSEWHEEL = 0x20A
; WM_MOUSEHWHEEL = 0x20E