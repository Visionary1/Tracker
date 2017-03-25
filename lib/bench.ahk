CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

F1::
Loop, 1
{
	MouseGetPos, xpos, ypos
	PixelGetColor, OutputVar, xpos, ypos, RGB

	; WinGetPos,winX,winY,,,A
	; x += winX
	; y += winY
	snap := new CGdipSnapshot(0,0,A_ScreenWidth,A_ScreenHeight)
	snap.TakeSnapshot()
	snap.SaveSnapshot("myfile.png")		; PNG format

	ToolTip, % OutputVar "`n" snap.PixelSnap[0,0].rgb

	snap := ""
	
}
Return

F2::
DllCall("mouse_event", uint, 1, int, 100, int, 0, uint, 0, int, 0)
Return

F3::
Exit

Return

#Include, CGdipSnapshot.ahk

PixelSearch(x, y, color) 
{ 
	WinGetPos,winX,winY,,,A
	x += winX
	y += winY
    pToken := GDIP_StartUp() 
    pBitMap := GDIP_BitmapFromScreen() 
    ARGB := GDIP_GetPixel(pBitMap, x, y) 
    Gdip_DisposeImage(pBitmap) 
    Gdip_Shutdown(pToken) 
    If (ARGB = color) 
        Return true 
    Else 
        Return false 
}