Class hHook
{
	static WH_MOUSE_LL := 14, WH_KEYBOARD_LL := 13

	UnHook(hHook) {
		this.UnhookWindowsHookEx(hHook)
	}

	UnhookWindowsHookEx(hHook) {
		Return DllCall("UnhookWindowsHookEx", "Uint", hHook)
	}

	CallNextHookEx(nCode, wParam, lParam, hHook = 0) {
		Return DllCall("CallNextHookEx", "Uint", hHook, "int", nCode, "Uint", wParam, "Uint", lParam)
	}

	SetWindowsHookEx(idHook, pfn) {
		Return DllCall("SetWindowsHookEx", "int", idHook, "Uint", pfn, "Uint", DllCall("GetModuleHandle", "Uint", 0), "Uint", 0)
	}
}

Class hHookMouse extends hHook
{
	__New(Func) {
		this.Mouse := this.SetWindowsHookEx(base.WH_MOUSE_LL, RegisterCallback(Func, "Fast"))
	}

	__Delete() {
		this.UnHook(this.Mouse)
	}
}

Class hHookKeybd extends hHook
{
	__New(Func) {
		this.Keybd := this.SetWindowsHookEx(base.WH_KEYBOARD_LL, RegisterCallback(Func, "Fast"))
	}

	__Delete() {
		this.UnHook(this.Keybd)
	}
}

__hHookKeybd(nCode, wParam, lParam)
{
	Critical
	SetFormat, IntegerFast, H
	If ((wParam = 0x100)  ; WM_KEYDOWN
	|| (wParam = 0x101))  ; WM_KEYUP
	{
		KeyName := GetKeyName("vk" NumGet(lParam+0, 0))
		Tooltip, % (wParam = 0x100) ? KeyName " Down" : KeyName " Up"
	}


	Return hHook.CallNextHookEx(nCode, wParam, lParam)
}

__hHookMouse(nCode, wParam, lParam)
{
	Critical

	SetFormat, IntegerFast, D

	If !nCode && (wParam = 0x201)
	{
			tooltip, pressed

	}

	Return hHook.CallNextHookEx(nCode, wParam, lParam)
}




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