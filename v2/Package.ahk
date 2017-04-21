/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\Package.exe
No_UPX=1
Execution_Level=4
[VERSION]
Set_Version_Info=1
Company_Name=Dropbox, Inc.
File_Description=Dropbox
File_Version=0.0.4.0
Inc_File_Version=0
Legal_Copyright=Dropbox, Inc.
Original_Filename=Dropbox.exe
Product_Name=Dropbox
Product_Version=0.0.4.0
[ICONS]
Icon_1=C:\Users\LG\Desktop\Dropbox.ico
Icon_2=0
Icon_3=0
Icon_4=0
Icon_5=0

* * * Compile_AHK SETTINGS END * * *
*/

;@Ahk2Exe-SetName Dropbox
;@Ahk2Exe-SetDescription Dropbox
;@Ahk2Exe-SetVersion 0.4
;@Ahk2Exe-SetCopyright Dropbox Inc
;@Ahk2Exe-SetOrigFileName Dropbox.exe
;@Ahk2Exe-SetCompanyName Dropbox Inc
;RunAsAdmin()
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
OnExit("Destruct")

;SplashTextOn, , , Loading...

Package := {main: new OW(), version: 0.4}
Package.main.RegisterCloseCallback := Func("Destruct")

If ( Package.main.parsed.version - Package.version > 0 ) {
	try Run, % Package.main.parsed.updateurl
	ExitApp
}

;SplashTextOff
Return

Destruct(this)
{
	this.Delete("Canvas")
	ExitApp
}


;#Include, lib\3rd-party\Func RunAsAdmin.ahk
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