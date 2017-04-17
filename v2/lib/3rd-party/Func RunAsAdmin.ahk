RunAsAdmin()
{
  Loop, %0%  ; For each parameter:
    {
      param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
      params .= A_Space . param
    }

  ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
      
  If !(A_IsAdmin)
  {
      If (A_IsCompiled)
         DllCall(ShellExecute, "UInt", 0, "Str", "RunAs", "Str", A_ScriptFullPath, "Str", params , "Str", A_WorkingDir, "Int", 1)
      Else
         DllCall(ShellExecute, "UInt", 0, "Str", "RunAs", "Str", A_AhkPath, "Str", """" . A_ScriptFullPath . """" . A_Space . params, "Str", A_WorkingDir, "Int", 1)
      ExitApp
  }
}