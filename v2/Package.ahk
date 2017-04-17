;@Ahk2Exe-SetName Tracker
;@Ahk2Exe-SetDescription Advanced pixel tracker
;@Ahk2Exe-SetVersion 0.3
;@Ahk2Exe-SetCopyright Copyright (c) 2017`, 예지력 (https://github.com/Visionary1)
;@Ahk2Exe-SetOrigFileName Tracker.exe
;@Ahk2Exe-SetCompanyName Copyright (c) 2017`, 예지력 (https://github.com/Visionary1)
;RunAsAdmin()
#SingleInstance, Force
#NoEnv
;#NoTrayIcon
;#Warn
#KeyHistory, 0
ListLines, Off
SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1
CoordMode, Pixel, Screen
OnExit("Terminate")

SplashTextOn, , , Loading...

Package := {Main: new OW(), version: 0.3}

If ( Package.Main.parsed.version - Package.version > 0 ) {
	try Run, % Package.Main.parsed.updateurl
	ExitApp
}

Package.Main.RegisterCloseCallback(Func("Terminate"))
SplashTextOff
Return

Terminate()
{
	global Package
	
	Package.Main := ""
	ExitApp
}


#Include, lib\3rd-party\Func RunAsAdmin.ahk
#Include, lib\Class OW.ahk

; Class JSON by CoCo (https://github.com/cocobelgica)
; Class GUI by Rune (https://github.com/Run1e)
; Class LLMouse by evilc
; Class QuasiThread by CoCo
; Class WinEvents.ahk by Geekdude
; Class HotKey by Rune (https://github.com/Run1e)
; Class Public by coco
; Func Gdip by tic (https://autohotkey.com/boards/viewtopic.php?t=6517)
; Func .NET Framework Interop by Lexikos
; several codes were inspired from Lexikos, HotKeyIt, evicC, G33kdude, coco, and lots more...