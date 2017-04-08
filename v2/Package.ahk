;@Ahk2Exe-SetName Tracker
;@Ahk2Exe-SetDescription Advanced pixel tracking
;@Ahk2Exe-SetVersion 0.2
;@Ahk2Exe-SetCopyright Copyright (c) 2017`, 예지력 (https://github.com/Visionary1)
;@Ahk2Exe-SetOrigFileName Tracker.exe
;@Ahk2Exe-SetCompanyName Copyright (c) 2017`, 예지력 (https://github.com/Visionary1)
#SingleInstance, Force
#NoEnv
#NoTrayIcon
;#Warn
#KeyHistory, 0
ListLines, Off
SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1
CoordMode, Pixel, Screen

Package := {Main: new OW(), version: 0.2}

If ( Package.version < Package.Main.parsed.version )
{
	try Run, % parsed.updateurl
	ExitApp
}

Package.Main.RegisterCloseCallback(Func("Terminate"))
;keybdproc := new hHookKeybd(Func("AdjustHook"))

Return

; AdjustHook(nCode, wParam, lParam)
; {
; 	static temp := new Tracker()

; 	Critical

; 	SetFormat, IntegerFast, H

; 	If (wParam = 0x100) 
; 	{
; 		If ( GetKeyName("vk" NumGet(lParam+0, 0)) = "LShift" )
; 		{
; 			;SendInput, {LShift Down}{LShift Up}
; 			temp.Calculate(5)
; 		}
; 	}

; 	Return hHook.CallNextHookEx(nCode, wParam, lParam)
; }


Terminate()
{
	ExitApp
}


#Include, lib\Class OW.ahk
#Include, lib\3rd-party\Class PureNotify.ahk

; Class JSON by CoCo (https://github.com/cocobelgica)
; Class GUI by Rune (https://github.com/Run1e)
; Class LLMouse by evilc
; Class QuasiThread by CoCo
; Class WinEvents.ahk by Geekdude
; Class HotKey by Rune (https://github.com/Run1e)
; Class Public by coco
; Func Gdip by tic (https://autohotkey.com/boards/viewtopic.php?t=6517)
; several codes were inspired from G33kdude, coco, and lots more...