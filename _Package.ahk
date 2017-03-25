#NoEnv
#SingleInstance force
#KeyHistory, 0
ListLines, Off
SetBatchLines, -1

Menu, Tray, NoStandard
Sensi := SubStr(A_ScriptName, -1, 2)

Application := {}
Application.OW := new Tracker("High")
Application.Box := new PureNotify(Application.OW.X1, Application.OW.Y1, (Application.OW.X2 - Application.OW.X1), (Application.OW.Y2 - Application.OW.Y1))
Application.Box.Text("Head", "Body"), Application.Box := ""

Loop, 
{
	If ( Application.OW.Firing("Space") )
	{
		Application.OW.Search(), Application.OW.Calculate_v2(Sensi)
	}
	
}
Return

F3::
ExitApp

#Include, lib\C_Tracker.ahk
#Include, lib\C_PureNotify.ahk
;#Include, lib\C_Menu.ahk
;#Include, lib\guiSupportFunc.ahk
#Include, lib\C_JSON.ahk
#Include, lib\DownloadToStr.ahk


