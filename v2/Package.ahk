#SingleInstance, Force
#NoEnv
#NoTrayIcon
#KeyHistory, 0
ListLines, Off
;SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1
CoordMode, Pixel, Screen

Package := {Main: new OW(), version: 0.1}

If ( Package.version < Package.Main.parsed.version )
{
	try Run, % parsed.updateurl
	ExitApp
}

Package.Main.RegisterCloseCallback(Func("Terminate"))
Return



Terminate()
{
	ExitApp
}

Pause::Pause


#Include, lib\Class OW.ahk
#Include, lib\3rd-party\Class WinEvents.ahk
#Include, lib\3rd-party\Class PureNotify.ahk
#Include, lib\3rd-party\Func DownloadToString.ahk
