CreateGUID()
{
    VarSetCapacity(pguid, 16, 0)
    if (DllCall("ole32.dll\CoCreateGuid", "ptr", &pguid) != 0)
        return (ErrorLevel := 1) & 0
    size := VarSetCapacity(sguid, 38 * (A_IsUnicode ? 2 : 1) + 1, 0)
    if !(DllCall("ole32.dll\StringFromGUID2", "ptr", &pguid, "ptr", &sguid, "int", size))
        return (ErrorLevel := 2) & 0
    return StrGet(&sguid)
}