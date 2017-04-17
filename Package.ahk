; Header =======================================================================
; Name .........: Microsoft Office 2016 Inspired UI
; Description ..: A custom UI design based on Microsoft Office 2016
; AHK Version ..: 1.1.23.01 (Unicode 32-bit) - January 24, 2016
; OS Version ...: Windows 2000+
; Language .....: English (en-US)
; Author .......: (TheDewd) Weston Campbell <westoncampbell@gmail.com>
; Filename .....: Office16.ahk
; Link .........: https://autohotkey.com/boards/viewtopic.php?f=6&t=3851&p=70009#p70009
; ==============================================================================

#SingleInstance, Force
#NoEnv
#NoTrayIcon ; Disable the tray icon of the script
#KeyHistory, 0
ListLines, Off
;SetBatchLines, -1 ; Run the script at maximum speed
SetWinDelay, -1 ; The delay to occur after modifying a window
SetControlDelay, -1 ; The delay to occur after modifying a control
CoordMode, Pixel, Screen
OnExit, GuiClose

parsed := JSON.Load(DownloadToStr("https://raw.githubusercontent.com/Visionary1/Tracker/master/info.json"))
Application := {} ; Create Application Object
Application.version := 0.2

If ( (Application.version - parsed.version) < 0)
{
	try Run, % parsed.updateurl
	ExitApp
}

Window := {} ; Create Window Object
Window.Width := 500
Window.Height := 300
Window.StatusBarText := parsed.StatusBarText
Window.Title := parsed.title " " Application.version

Menu_dump := {}
Menu_dump.Fire_Menu := ["LButton", "RButton", "MButton", "Ctrl", "CapsLock", "Ctrl", "Space"]
Menu_dump.Suspend_Menu := ["F1", "F2", "CapsLock", "MButton", "Ctrl", "Alt"]
Menu_dump.Sens_Menu := ["1", "2", "3", "4", "4.5", "5", "5.5", "6", "7", "8", "9", "10"]
Menu_dump.Dev_Menu := ["x축 오차범위", "y축 오차범위", "서칭 범위조절", "소스코드"]
Menu_dump.Help_Menu := ["늅늅이 도움말"]
Menu.Add(Menu_dump, "MenuHandler")

Application.FireKey := ""
Application.SusKey := ""
Application.SensKey := ""

Gui, +LastFound -Resize -Caption -Border +HWNDhGui1
Gui, Color, FFFFFF
Gui, Margin, 10, 10

; Window Border
Gui, Add, Text, % " x" 0 " y" 0 " w" 1 " h" Window.Height " +0x4E +HWNDhBorderLeft"
Gui, Add, Text, % " x" Window.Width-1 " y" 0 " w" 1 " h" Window.Height " +0x4E +HWNDhBorderRight"
Gui, Add, Text, % "x" 1 " y" Window.Height-1 " w" Window.Width-2 " h" 1 " +0x4E +HWNDhBorderBottom"
DllCall("SendMessage", "Ptr", hBorderLeft, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0072C6", 1, 1))
DllCall("SendMessage", "Ptr", hBorderRight, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0072C6", 1, 1))
DllCall("SendMessage", "Ptr", hBorderBottom, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0072C6", 1, 1))

; Window Header
Gui, Add, Text, % "x" 1 " y" 0 " w" Window.Width-2 " h" 67 " +0x4E +HWNDhTitleHeader"
DllCall("SendMessage", "Ptr", hTitleHeader, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))

; Window Title
Gui, Font, s9 cFFFFFF, Segoe UI ; Set font options
Gui, Add, Text, % " x" 140 " y" 12 " w" Window.Width-280 " +BackgroundTrans +0x101 +HWNDhTitle", % Window.Title
Gui, Font ; Reset font options

; Window StatusBar
Gui, Add, Picture, % " x" 1 " y" Window.Height-23 " w" Window.Width-2 " h" 22 " +0x4E +HWNDhStatusBar"
StatusBar := "#@@@@@@@@@@@@@@@@@@@@@"
StringReplace, StatusBar, StatusBar, #, BFBFBF|, All
StringReplace, StatusBar, StatusBar, @, F1F1F1|, All
StringTrimRight, StatusBar, StatusBar, 1
DllCall("SendMessage", "Ptr", hStatusBar, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(StatusBar, 1, 22))
Gui, Font, s8 c515050, Segoe UI ; Set font options
Gui, Add, Text, % " x" 8 " y" Window.Height-19 " w" Window.Width-16 " +HWNDhStatusBarText +BackgroundTrans", % Window.StatusBarText
Gui, Font ; Reset font options

; Window Minimize Button
Gui, Add, Picture, % " x" Window.Width-139 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonMinimizeN Hidden0"
Gui, Add, Picture, % " x" Window.Width-139 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonMinimizeH Hidden1"
Gui, Add, Picture, % " x" Window.Width-139 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonMinimizeP Hidden1"

ButtonMinimize := "####################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################@@@@@@@@@@####################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################"

StringReplace, ButtonMinimizeN, ButtonMinimize, #, 0173C7|, All
StringReplace, ButtonMinimizeN, ButtonMinimizeN, @, FFFFFF|, All
StringTrimRight, ButtonMinimizeN, ButtonMinimizeN, 1

StringReplace, ButtonMinimizeH, ButtonMinimize, #, 2A8AD4|, All
StringReplace, ButtonMinimizeH, ButtonMinimizeH, @, FFFFFF|, All
StringTrimRight, ButtonMinimizeH, ButtonMinimizeH, 1

StringReplace, ButtonMinimizeP, ButtonMinimize, #, 015C9F|, All
StringReplace, ButtonMinimizeP, ButtonMinimizeP, @, FFFFFF|, All
StringTrimRight, ButtonMinimizeP, ButtonMinimizeP, 1

DllCall("SendMessage", "Ptr", hButtonMinimizeN, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonMinimizeN, 46, 31))
DllCall("SendMessage", "Ptr", hButtonMinimizeH, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonMinimizeH, 46, 31))
DllCall("SendMessage", "Ptr", hButtonMinimizeP, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonMinimizeP, 46, 31))

; Window Maximize Button
Gui, Add, Picture, % " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonMaximizeN Hidden0"
Gui, Add, Picture, % " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonMaximizeH Hidden1"
Gui, Add, Picture, % " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonMaximizeP Hidden1"

ButtonMaximize := "##############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################@@@@@@@@@@####################################@########@####################################@########@####################################@########@####################################@########@####################################@########@####################################@########@####################################@########@####################################@########@####################################@@@@@@@@@@############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################"

StringReplace, ButtonMaximizeN, ButtonMaximize, #, 0173C7|, All
StringReplace, ButtonMaximizeN, ButtonMaximizeN, @, FFFFFF|, All
StringTrimRight, ButtonMaximizeN, ButtonMaximizeN, 1

StringReplace, ButtonMaximizeH, ButtonMaximize, #, 2A8AD4|, All
StringReplace, ButtonMaximizeH, ButtonMaximizeH, @, FFFFFF|, All
StringTrimRight, ButtonMaximizeH, ButtonMaximizeH, 1

StringReplace, ButtonMaximizeP, ButtonMaximize, #, 015C9F|, All
StringReplace, ButtonMaximizeP, ButtonMaximizeP, @, FFFFFF|, All
StringTrimRight, ButtonMaximizeP, ButtonMaximizeP, 1

DllCall("SendMessage", "Ptr", hButtonMaximizeN, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonMaximizeN, 46, 31))
DllCall("SendMessage", "Ptr", hButtonMaximizeH, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonMaximizeH, 46, 31))
DllCall("SendMessage", "Ptr", hButtonMaximizeP, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonMaximizeP, 46, 31))

; Window Restore Button
Gui, Add, Picture, % " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonRestoreN Hidden1"
Gui, Add, Picture, % " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonRestoreH Hidden1"
Gui, Add, Picture, % " x" Window.Width-93 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonRestoreP Hidden1"

ButtonRestore := "################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################@@@@@@@@######################################@######@####################################@@@@@@@@#@####################################@######@#@####################################@######@#@####################################@######@#@####################################@######@#@####################################@######@@@####################################@######@######################################@@@@@@@@##############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################"

StringReplace, ButtonRestoreN, ButtonRestore, #, 0173C7|, All
StringReplace, ButtonRestoreN, ButtonRestoreN, @, FFFFFF|, All
StringTrimRight, ButtonRestoreN, ButtonRestoreN, 1

StringReplace, ButtonRestoreH, ButtonRestore, #, 2A8AD4|, All
StringReplace, ButtonRestoreH, ButtonRestoreH, @, FFFFFF|, All
StringTrimRight, ButtonRestoreH, ButtonRestoreH, 1

StringReplace, ButtonRestoreP, ButtonRestore, #, 015C9F|, All
StringReplace, ButtonRestoreP, ButtonRestoreP, @, FFFFFF|, All
StringTrimRight, ButtonRestoreP, ButtonRestoreP, 1

DllCall("SendMessage", "Ptr", hButtonRestoreN, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonRestoreN, 46, 31))
DllCall("SendMessage", "Ptr", hButtonRestoreH, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonRestoreH, 46, 31))
DllCall("SendMessage", "Ptr", hButtonRestoreP, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonRestoreP, 46, 31))

; Window Close Button
Gui, Add, Picture, % " x" Window.Width-47 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonCloseN Hidden0"
Gui, Add, Picture, % " x" Window.Width-47 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonCloseH Hidden1"
Gui, Add, Picture, % " x" Window.Width-47 " y" 1 " w" 46 " h" 31 " +0x4E +HWNDhButtonCloseP Hidden1"

ButtonClose := "##############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################-$######$-####################################$-$####$-$#####################################$-$##$-$#######################################$-$$-$#########################################$--$##########################################$--$#########################################$-$$-$#######################################$-$##$-$#####################################$-$####$-$####################################-$######$-############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################"

StringReplace, ButtonCloseN, ButtonClose, #, 0173C7|, All
StringReplace, ButtonCloseN, ButtonCloseN, $, 4096D5|, All
StringReplace, ButtonCloseN, ButtonCloseN, -, FFFFFF|, All
StringTrimRight, ButtonCloseN, ButtonCloseN, 1

StringReplace, ButtonCloseH, ButtonClose, #, E81123|, All
StringReplace, ButtonCloseH, ButtonCloseH, $, EE4C59|, All
StringReplace, ButtonCloseH, ButtonCloseH, -, FFFFFF|, All
StringTrimRight, ButtonCloseH, ButtonCloseH, 1

StringReplace, ButtonCloseP, ButtonClose, #, F1707A|, All
StringReplace, ButtonCloseP, ButtonCloseP, $, F4939B|, All
StringReplace, ButtonCloseP, ButtonCloseP, -, FFFFFF|, All
StringTrimRight, ButtonCloseP, ButtonCloseP, 1

DllCall("SendMessage", "Ptr", hButtonCloseN, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonCloseN, 46, 31))
DllCall("SendMessage", "Ptr", hButtonCloseH, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonCloseH, 46, 31))
DllCall("SendMessage", "Ptr", hButtonCloseP, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB(ButtonCloseP, 46, 31))

; Window Menu Button
Gui, Font, s9 cFFFFFF, Segoe UI ; Set font options
Gui, Add, Picture, % " x" 2 " y" 36 " w" 60 " h" 24 " +0x4E +HWNDhButtonMenuFileN Hidden0"
Gui, Add, Picture, % " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E +HWNDhButtonMenuFileH Hidden1"
Gui, Add, Text, % " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +HWNDhButtonMenuFileText +BackgroundTrans +0x201", % "에임키"
DllCall("SendMessage", "Ptr", hButtonMenuFileN, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
DllCall("SendMessage", "Ptr", hButtonMenuFileH, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("2A8AD4", 1, 1))

Gui, Add, Picture, % " x+" 2 " yp" 0 " w" 60 " h" 24 " +0x4E +HWNDhButtonMenuEditN Hidden0"
Gui, Add, Picture, % " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E +HWNDhButtonMenuEditH Hidden1"
Gui, Add, Text, % " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +HWNDhButtonMenuEditText +BackgroundTrans +0x201", % "중지키 "
DllCall("SendMessage", "Ptr", hButtonMenuEditN, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
DllCall("SendMessage", "Ptr", hButtonMenuEditH, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("2A8AD4", 1, 1))

Gui, Add, Picture, % " x+" 2 " yp" 0 " w" 60 " h" 24 " +0x4E +HWNDhButtonMenuViewN Hidden0"
Gui, Add, Picture, % " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E +HWNDhButtonMenuViewH Hidden1"
Gui, Add, Text, % " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +HWNDhButtonMenuViewText +BackgroundTrans +0x201", % "감도"
DllCall("SendMessage", "Ptr", hButtonMenuViewN, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
DllCall("SendMessage", "Ptr", hButtonMenuViewH, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("2A8AD4", 1, 1))

Gui, Add, Picture, % " x+" 2 " yp" 0 " w" 60 " h" 24 " +0x4E +HWNDhButtonMenuToolsN Hidden0"
Gui, Add, Picture, % " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E +HWNDhButtonMenuToolsH Hidden1"
Gui, Add, Text, % " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +HWNDhButtonMenuToolsText +BackgroundTrans +0x201", % "고급"
DllCall("SendMessage", "Ptr", hButtonMenuToolsN, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
DllCall("SendMessage", "Ptr", hButtonMenuToolsH, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("2A8AD4", 1, 1))

Gui, Add, Picture, % " x+" 2 " yp" 0 " w" 60 " h" 24 " +0x4E +HWNDhButtonMenuHelpN Hidden0"
Gui, Add, Picture, % " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +0x4E +HWNDhButtonMenuHelpH Hidden1"
Gui, Add, Text, % " xp" 0 " yp" 0 " wp" 0 " hp" 0 " +HWNDhButtonMenuHelpText +BackgroundTrans +0x201", % "도움말"
DllCall("SendMessage", "Ptr", hButtonMenuHelpN, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("0173C7", 1, 1))
DllCall("SendMessage", "Ptr", hButtonMenuHelpH, "UInt", 0x172, "Ptr", 0, "Ptr", CreateDIB("2A8AD4", 1, 1))
Gui, Font ; Reset font options

Gui, Add, Button, % "x20 y80 w" Window.Width - 40 " h" Window.Height - 120 " hwndBoundBtn vStartBtn Hidden", Start
BoundFunc := Func("Initialize")
GuiControl +g, % BoundBtn, % BoundFunc

Gui, Add, Text, x20 y80 vStatInfo
, % DownloadToStr("https://raw.githubusercontent.com/Visionary1/Tracker/master/Board.txt")

Gui, Show, % " w" Window.Width " h" Window.Height, % Window.Title

OnMessage(0x200, "WM_MOUSEMOVE")
OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x202, "WM_LBUTTONUP")
OnMessage(0x2A3, "WM_MOUSELEAVE")

VarSetCapacity(TME, 16, 0), NumPut(16, TME, 0), NumPut(2, TME, 4), NumPut(hGui1, TME, 8)
return ; End automatic execution
; ==============================================================================

; Labels =======================================================================
GuiSize:
	If (ErrorLevel = 1) {
		return ; The window has been minimized.  No action needed.
	}

	GuiControl, MoveDraw, % hTitleHeader, % " w" A_GuiWidth-2
	GuiControl, MoveDraw, % hBorderLeft, % " h" A_GuiHeight
	GuiControl, MoveDraw, % hBorderRight, % " x"  A_GuiWidth-1 " h" A_GuiHeight
	GuiControl, MoveDraw, % hBorderBottom, % " y" A_GuiHeight-1 " w" A_GuiWidth-2
	GuiControl, MoveDraw, % hTitle, % " w" A_GuiWidth-280
	GuiControl, MoveDraw, % hStatusBar, % " w" A_GuiWidth-2 " y" A_GuiHeight-23
	GuiControl, MoveDraw, % hStatusBarText, % " w" A_GuiWidth-16 " y" A_GuiHeight-19
	GuiControl, MoveDraw, % hButtonMinimizeN, % " x" A_GuiWidth-139
	GuiControl, MoveDraw, % hButtonMinimizeH, % " x" A_GuiWidth-139
	GuiControl, MoveDraw, % hButtonMinimizeP, % " x" A_GuiWidth-139
	GuiControl, MoveDraw, % hButtonMaximizeN, % " x" A_GuiWidth-93
	GuiControl, MoveDraw, % hButtonMaximizeH, % " x" A_GuiWidth-93
	GuiControl, MoveDraw, % hButtonMaximizeP, % " x" A_GuiWidth-93
	GuiControl, MoveDraw, % hButtonRestoreN, % " x" A_GuiWidth-93
	GuiControl, MoveDraw, % hButtonRestoreH, % " x" A_GuiWidth-93
	GuiControl, MoveDraw, % hButtonRestoreP, % " x" A_GuiWidth-93
	GuiControl, MoveDraw, % hButtonCloseN, % " x" A_GuiWidth-47
	GuiControl, MoveDraw, % hButtonCloseH, % " x" A_GuiWidth-47
	GuiControl, MoveDraw, % hButtonCloseP, % " x" A_GuiWidth-47
return


Pause::Pause


Initialize()
{
	global Application

	GuiControl, Hide, StartBtn
	GuiControl, Show, StatInfo
	Application.OW := new Tracker()
	Application.Box := new PureNotify(Application.OW.X1, Application.OW.Y1, (Application.OW.X2 - Application.OW.X1), (Application.OW.Y2 - Application.OW.Y1))
	Application.Box.Text("시작"
	, "현재 보이는 구간이 서칭 범위입니다 (" Floor(Application.OW.X2 - Application.OW.X1) "x" Floor(Application.OW.Y2 - Application.OW.Y1) ")`n`n에임키 " Application.FireKey "`n중지키 " Application.SusKey "`n감도 " Application.SensKey)
	Sleep, 4500
	Application.Box := ""
	Tick := A_IsCompiled ? SubStr(A_ScriptName, 1, -4) : 0

	Loop,
	{
		If ( Application.OW.Firing(Application.FireKey) )
		{
			;ToolTip, % Application.FireKey "`n" Application.SensKey
			Application.OW.Search(), Application.OW.Calculate_v2(Application.SensKey)
			Sleep, % Tick
		}
	}
}

MenuHandler:
	;MsgBox,, MenuHandler, % "Menu Item: " A_ThisMenuItem "`nMenu: " A_ThisMenu
	If (A_ThisMenu = "Fire_Menu")
		Application.FireKey := A_ThisMenuItem
	Else If (A_ThisMenu = "Suspend_Menu") && !(Hotkey1)
	{
		Application.SusKey := A_ThisMenuItem
		HotKey1 := A_ThisMenuItem
		Hotkey, %HotKey1%, Pause
		Menu.Disable(A_ThisMenu, Menu_dump[A_ThisMenu])
	}
	Else If (A_ThisMenu = "Sens_Menu")
	{
		Application.SensKey := A_ThisMenuItem
	}
	Else If (A_ThisMenu = "Dev_Menu")
	{
		Return
	}
	Else If (A_ThisMenu = "Help_Menu")
	{
		Return
	}

	Menu.Toggle(A_ThisMenu, Menu_dump[A_ThisMenu], A_ThisMenuItem)

	If ( (Application.FireKey) && (Application.SusKey) && (Application.SensKey) && !ControlFlag )
	{
		GuiControl, Hide, StatInfo
		ControlFlag := True
		GuiControl, Show, StartBtn
	}
Return

GuiClose:
	Application := ""
	ExitApp

; ==============================================================================
#Include, lib\C_Tracker.ahk
#Include, lib\C_PureNotify.ahk
#Include, lib\C_Menu.ahk
#Include, lib\guiSupportFunc.ahk
#Include, lib\C_JSON.ahk
#Include, lib\DownloadToStr.ahk