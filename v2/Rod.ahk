#SingleInstance, Force
#NoEnv
;#NoTrayIcon
;#Warn
#KeyHistory, 0
#Persistent
ListLines, Off
SetBatchLines, -1
CoordMode, Pixel, Screen
keybdHook := new hHookKeybd(Func("Chase"))
Return

Chase(nCode, wParam, lParam)
{
	static abc := new Tracker(0, A_ScreenWidth)

	Critical
	SetFormat, IntegerFast, H

	If (wParam = 0x100) 
	{
		If (GetKeyName("vk" NumGet(lParam+0, 0)) = "LShift")
		{
			abc.Calculate(4, 0, 0)
		}
	}

	Return hHook.CallNextHookEx(nCode, wParam, lParam)
}

#Include, %A_ScriptDir%\lib\Class Tracker.ahk
#Include, %A_ScriptDir%\lib\3rd-party\Class hHook.ahk

