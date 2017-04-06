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
#Include, lib\3rd-party\Class WinEvents.ahk ; by G33kdude
#Include, lib\3rd-party\Class PureNotify.ahk ; by me(Visionary1, Soft)
#Include, lib\3rd-party\Func DownloadToString.ahk ; by me(Visionary1, Soft)

; Class JSON by CoCo (https://github.com/cocobelgica)
; Class GUI by Rune (https://github.com/Run1e)
; Func Gdip by tic (https://autohotkey.com/boards/viewtopic.php?t=6517)
; several codes were inspired from G33kdude, coco, and lots more...