#NoEnv
#SingleInstance force
#KeyHistory, 0
ListLines, Off
; SetBatchLines, -1
Menu, Tray, NoStandard
CoordMode, Pixel, Screen
OnExit, Exit


; Sensi := SubStr(A_ScriptName, -1, 2)

Application := {}
Application.OW := new Tracker("High")
Application.Box := new PureNotify(Application.OW.X1, Application.OW.Y1, (Application.OW.X2 - Application.OW.X1), (Application.OW.Y2 - Application.OW.Y1))
Application.Box.Text("Head", "Body"), Application.Box := ""

; Application.hook := new hHookKeybd(Func("__hHookKeybd"))

Loop, 
{
	If ( Application.OW.Firing("LButton") )
	{
		Application.OW.Search(), Application.OW.Calculate_v2(5.5)
	}
	
}
Return

F1::
DllCall("mouse_event", "UInt", 0x01, "Int", 500, "Int", 0)
Return

F2::
Loop, 500
{
	DllCall("mouse_event", "UInt", 0x01, "Int", 1, "Int", 0)
}
Return

F3::
Application.OW.Search(), Application.OW.Calculate_v2(7)
Return

Esc::
Exit:
Application := ""
ExitApp


#Include, lib\C_Tracker.ahk
#Include, lib\C_PureNotify.ahk
;#Include, lib\C_Menu.ahk
;#Include, lib\guiSupportFunc.ahk
#Include, lib\C_JSON.ahk
#Include, lib\DownloadToStr.ahk


