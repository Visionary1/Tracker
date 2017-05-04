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
OnExit("Destruct")

global namespace := {}
namespace.json := JSON.Load(DownloadToStr("https://raw.githubusercontent.com/Visionary1/Tracker/master/new/Package.json"))
namespace.main := new OW(namespace.json)
namespace.main.RegisterCloseCallback := Func("Destruct")
Return

Destruct(self){
	Try self.GuiClose()
	namespace := ""
	ExitApp
}

#Include, lib\class OW.ahk