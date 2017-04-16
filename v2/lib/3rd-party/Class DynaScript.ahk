/**
	* Class DynaScript
	*		파이프를 통한 Child 프로세스 Spawn
	* 버전:
	*		v1.0 [마지막 수정 12/14/2015 (MM/DD/YYYY)]
	* 라이센스:
	*		WTFPL (http://wtfpl.net/)
	* 시스템 환경:
	*		AutoHotkey v1.1.22.09
	* 설치:
	*		#Include DynaScript.ahk 또는, Lib 폴더로 이동
	* 정보:
	*		Credits Lexikos for demonstrating the idea, Coco, GeekDude for their ExecScript
*/
class DynaScript
{
	static Shell := ComObjCreate("WScript.Shell")

	__New(Code, ProcName := "", Interpreter := "")
	{
		ProcName := ProcName ? ProcName : "Child " . A_TickCount
		this.Pipe := []
		Loop, 2 
		{
			this.Pipe[A_Index] := DllCall(
			(Join, Q C
				"CreateNamedPipe"            	; https://goo.gl/XNZ9US
				"Str",  "\\.\pipe\" . ProcName  ; lpName
				"UInt", 2                    	; dwOpenMode
				"UInt", 0                    	; dwPipeMode
				"UInt", 255                  	; nMaxInstances
				"UInt", 0                   	; nOutBufferSize
				"UInt", 0                    	; nInBufferSize
				"Ptr",  0                    	; nDefaultTimeOut
				"Ptr",  0                    	; lpSecurityAttributes
			))
		}

		If !FileExist(Interpreter) || (Interpreter == "") {
			If FileExist(A_AhkPath)
				Interpreter := A_AhkPath
			Else
				Throw Exception("Specify the AutoHotkey's path`n" . Interpreter)
		}

		cmd = "%Interpreter%" /CP65001 "\\.\pipe\%ProcName%"
		this.cmd := cmd
		this.Code := Code
	}

	__Delete()
	{
		this.Terminate()
	}

	Run() ;독립 프로세스로
	{
		this.Shell.Run(this.cmd)
		this.ConnectPipe(this.Pipe, this.Code)
	}

	Exec() ;자식 프로세스로
	{
		this.Exec := this.Shell.Exec(this.cmd)
		this.ConnectPipe(this.Pipe, this.Code)
		Return this.Exec
	}

	Terminate() ;자식 프로세스 종료
	{
		If (this.Exec.Status = 0)
			this.Exec.Terminate()
	}

	ConnectPipe(Pipe, Code)
	{
		DllCall("ConnectNamedPipe", "Ptr", Pipe[1], "Ptr", 0)
		DllCall("CloseHandle", "Ptr", Pipe[1])
		DllCall("ConnectNamedPipe", "Ptr", Pipe[2], "Ptr", 0)
		FileOpen(Pipe[2], "h", "UTF-8").Write(Code)
		DllCall("CloseHandle", "Ptr", Pipe[2])
	}
}