dd := new PureNotify(100,0, 300, 300, 0xEE263238)
Return


Class PureNotify
{
	static Ptr := A_PtrSize ? "UPtr" : "UInt"

	__New(x, y, w, h, ARGB)
	{
		Gui, New, +hwndhwnd -Caption +E0x80000 +AlwaysOnTop +ToolWindow +OwnDialogs +E0x20
		Gui, Show, NA

		this.hwnd := hwnd
		this.gdi := new this.GDIP()
		this.hbm := this.gdi.CreateDIBSection(w, h)
		this.hdc := this.gdi.CreateCompatibleDC()
		this.obm := this.gdi.SelectObject(this.hdc, this.hbm)

		this.G := this.gdi.GraphicsFromHDC(this.hdc)
		this.gdi.SetSmoothingMode(this.G, 4) ; Set the sm
		this.pBrush := this.gdi.BrushCreateSolid(ARGB)
		this.gdi.FillRoundedRectangle(this.G, this.pBrush, 0, 0, w, h, 25)
		this.gdi.DeleteBrush(this.pBrush) ; Delete the brush as it is no longer needed and wastes memory
		this.UpdateLayeredWindow(hwnd, this.hdc, x, y, w, h, 200)
	}

	__Delete()
	{
		;this.Fade()
		this.gdi.SelectObject(this.hdc, this.obm) ; Select the object back into the hdc
		this.gdi.DeleteObject(this.hbm) ; Now the bitmap may be deleted
		this.gdi.DeleteDC(this.hdc) ; Also the device context related to the bitmap may be deleted
		this.gdi.DeleteGraphics(this.G) ; The graphics may now be deleted
		this.gdi := ""
		Gui, % this.hwnd ": Destroy"
	}


	class GDIP
	{
		__New()
		{
			If !DllCall("GetModuleHandle", "str", "gdiplus", PureNotify.Ptr)
			DllCall("LoadLibrary", "str", "gdiplus")
			VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
			DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, PureNotify.Ptr, &si, PureNotify.Ptr, 0)

			this.pToken := pToken

			If !(pToken)
			{
				MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
				ExitApp
			}
		}

		__Delete()
		{
			DllCall("gdiplus\GdiplusShutdown", PureNotify.Ptr, this.pToken)
			If hModule := DllCall("GetModuleHandle", "str", "gdiplus", PureNotify.Ptr)
			DllCall("FreeLibrary", PureNotify.Ptr, hModule)
			Return 0
		}

		DeleteGraphics(pGraphics)
		{
		   return DllCall("gdiplus\GdipDeleteGraphics", A_PtrSize ? "UPtr" : "UInt", pGraphics)
		}

		DeleteDC(hdc)
		{
		   return DllCall("DeleteDC", A_PtrSize ? "UPtr" : "UInt", hdc)
		}

		DeleteObject(hObject)
		{
		   return DllCall("DeleteObject", A_PtrSize ? "UPtr" : "UInt", hObject)
		}

		UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
		{
			if ((x != "") && (y != ""))
			VarSetCapacity(pt, 8), NumPut(x, pt, 0, "UInt"), NumPut(y, pt, 4, "UInt")

			if (w = "") ||(h = "")
			WinGetPos,,, w, h, ahk_id %hwnd%

			return DllCall("UpdateLayeredWindow"
				, PureNotify.Ptr, hwnd
				, PureNotify.Ptr, 0
				, PureNotify.Ptr, ((x = "") && (y = "")) ? 0 : &pt
				, "int64*", w|h<<32
				, PureNotify.Ptr, hdc
				, "int64*", 0
				, "uint", 0
				, "UInt*", Alpha<<16|1<<24
				, "uint", 2)
		}

		TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0)
		{
			IWidth := Width, IHeight:= Height

			RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
			RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
			RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
			RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
			RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
			RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
			RegExMatch(Options, "i)NoWrap", NoWrap)
			RegExMatch(Options, "i)R(\d)", Rendering)
			RegExMatch(Options, "i)S(\d+)(p*)", Size)

			If !( this.DeleteBrush(this.CloneBrush(Colour2)) )
			PassBrush := 1, pBrush := Colour2

			If !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
			return -1

			Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
			Loop, Parse, Styles, |
			{
				If RegExMatch(Options, "\b" A_loopField)
				Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
			}

			Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
			Loop, Parse, Alignments, |
			{
				If RegExMatch(Options, "\b" A_loopField)
				Align |= A_Index//2.1      ; 0|0|1|1|2|2
			}

			xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
			ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
			Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
			Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
			If !PassBrush
			Colour := "0x" (Colour2 ? Colour2 : "ff000000")
			Rendering := ((Rendering1 >= 0) && (Rendering1 <= 5)) ? Rendering1 : 4
			Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12

			hFamily := this.Font.FamilyCreate(Font)
			hFont := this.Font.Create(hFamily, Size, Style)
			FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
			hFormat := this.StringFormatCreate(FormatStyle)
			pBrush := PassBrush ? pBrush : this.BrushCreateSolid(Colour)
			If !(hFamily && hFont && hFormat && pBrush && pGraphics)
			return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0

			this.CreateRectF(RC, xpos, ypos, Width, Height)
			this.SetStringFormatAlign(hFormat, Align)
			this.SetTextRenderingHint(pGraphics, Rendering)
			ReturnRC := this.MeasureString(pGraphics, Text, hFont, hFormat, RC)

			If vPos
			{
				StringSplit, ReturnRC, ReturnRC, |

				If (vPos = "vCentre") || (vPos = "vCenter")
				ypos += (Height-ReturnRC4)//2
				else If (vPos = "Top") || (vPos = "Up")
				ypos := 0
				else If (vPos = "Bottom") || (vPos = "Down")
				ypos := Height-ReturnRC4

				this.CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
				ReturnRC := this.MeasureString(pGraphics, Text, hFont, hFormat, RC)
			}

			If !Measure
			E := this.DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)

			If !PassBrush
			this.DeleteBrush(pBrush)
			this.DeleteStringFormat(hFormat)   
			this.Font.DeleteFont(hFont)
			this.Font.DeleteFontFamily(hFamily)
			Return E ? E : ReturnRC
		}

		DeleteStringFormat(hFormat)
		{
			Return DllCall("gdiplus\GdipDeleteStringFormat", PureNotify.Ptr, hFormat)
		}

		DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF)
		{	
			if (!A_IsUnicode)
			{
				nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, PureNotify.Ptr, &sString, "int", -1, PureNotify.Ptr, 0, "int", 0)
				VarSetCapacity(wString, nSize*2)
				DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, PureNotify.Ptr, &sString, "int", -1, PureNotify.Ptr, &wString, "int", nSize)
			}
			
			Return DllCall("gdiplus\GdipDrawString"
				, PureNotify.Ptr, pGraphics
				, PureNotify.Ptr, A_IsUnicode ? &sString : &wString
				, "int", -1
				, PureNotify.Ptr, hFont
				, PureNotify.Ptr, &RectF
				, PureNotify.Ptr, hFormat
				, PureNotify.Ptr, pBrush)
		}

		MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF)
		{
			VarSetCapacity(RC, 16)
			if !A_IsUnicode
			{
				nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, PureNotify.Ptr, &sString, "int", -1, "uint", 0, "int", 0)
				VarSetCapacity(wString, nSize*2)   
				DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, PureNotify.Ptr, &sString, "int", -1, PureNotify.Ptr, &wString, "int", nSize)
			}

			DllCall("gdiplus\GdipMeasureString"
				, PureNotify.Ptr, pGraphics
				, PureNotify.Ptr, A_IsUnicode ? &sString : &wString
				, "int", -1
				, PureNotify.Ptr, hFont
				, PureNotify.Ptr, &RectF
				, PureNotify.Ptr, hFormat
				, PureNotify.Ptr, &RC
				, "uint*", Chars
				, "uint*", Lines)

			return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
		}

		SetTextRenderingHint(pGraphics, RenderingHint)
		{
			Return DllCall("gdiplus\GdipSetTextRenderingHint", PureNotify.Ptr, pGraphics, "int", RenderingHint)
		}

		SetStringFormatAlign(hFormat, Align)
		{
			Return DllCall("gdiplus\GdipSetStringFormatAlign", PureNotify.Ptr, hFormat, "int", Align)
		}

		CreateRectF(ByRef RectF, x, y, w, h)
		{
			VarSetCapacity(RectF, 16)
			NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
		}

		class Font
		{
			FamilyCreate(Font)
			{
				if (!A_IsUnicode)
				{
					nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, PureNotify.Ptr, &Font, "int", -1, "uint", 0, "int", 0)
					VarSetCapacity(wFont, nSize*2)
					DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, PureNotify.Ptr, &Font, "int", -1, PureNotify.Ptr, &wFont, "int", nSize)
				}

				DllCall("gdiplus\GdipCreateFontFamilyFromName"
					, PureNotify.Ptr, A_IsUnicode ? &Font : &wFont
					, "uint", 0
					, PureNotify.Ptr . "*", hFamily)

				return hFamily
			}

			Create(hFamily, Size, Style=0)
			{
				DllCall("gdiplus\GdipCreateFont", PureNotify.Ptr, hFamily, "float", Size, "int", Style, "int", 0, PureNotify.Ptr . "*", hFont)
				return hFont
			}

			DeleteFontFamily(hFamily)
			{
				Return DllCall("gdiplus\GdipDeleteFontFamily", PureNotify.Ptr, hFamily)
			}

			DeleteFont(hFont)
			{
				Return DllCall("gdiplus\GdipDeleteFont", PureNotify.Ptr, hFont)
			}
		}

		StringFormatCreate(Format=0, Lang=0)
		{
			DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, PureNotify.Ptr . "*", hFormat)
			return hFormat
		}

		CreateDIBSection(w, h)
		{
			VarSetCapacity(bi, 40, 0)

			NumPut(w, bi, 4, "uint")
			, NumPut(h, bi, 8, "uint")
			, NumPut(40, bi, 0, "uint")
			, NumPut(1, bi, 12, "ushort")
			, NumPut(0, bi, 16, "uInt")
			, NumPut(32, bi, 14, "ushort")

			hbm := DllCall("CreateDIBSection"
				, PureNotify.Ptr, hdc2
				, PureNotify.Ptr, &bi
				, "uint", 0
				, A_PtrSize ? "UPtr*" : "uint*", 0
				, PureNotify.Ptr, 0
				, "uint", 0, PureNotify.Ptr)

			Return hbm
		}

		CreateCompatibleDC()
		{
			Return DllCall("CreateCompatibleDC", PureNotify.Ptr, 0)
		}

		SelectObject(hdc, hgdiobj)
		{
			Return DllCall("SelectObject", PureNotify.Ptr, hdc, PureNotify.Ptr, hgdiobj)
		}

		GraphicsFromHDC(hdc)
		{
			DllCall("gdiplus\GdipCreateFromHDC", PureNotify.Ptr, hdc, PureNotify.Ptr . "*", pGraphics)
			Return pGraphics
		}

		SetSmoothingMode(pGraphics, SmoothingMode)
		{
			Return DllCall("gdiplus\GdipSetSmoothingMode", PureNotify.Ptr, pGraphics, "int", SmoothingMode)
		}

		BrushCreateSolid(ARGB=0xff000000)
		{
			DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, PureNotify.Ptr . "*", pBrush)
			Return pBrush
		}

		DeleteBrush(pBrush)
		{
			Return DllCall("gdiplus\GdipDeleteBrush", PureNotify.Ptr, pBrush)
		}

		CloneBrush(pBrush)
		{
			DllCall("gdiplus\GdipCloneBrush", A_PtrSize ? "UPtr" : "UInt", pBrush, PureNotify.Ptr . "*", pBrushClone)
			Return pBrushClone
		}

		FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
		{
			Region := this.GetClipRegion(pGraphics)
			this.SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
			this.SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
			this.SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
			this.SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
			E := this.FillRectangle(pGraphics, pBrush, x, y, w, h)
			this.SetClipRegion(pGraphics, Region, 0)
			this.SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
			this.SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
			this.FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
			this.FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
			this.FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
			this.FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
			this.SetClipRegion(pGraphics, Region, 0)
			this.DeleteRegion(Region)
			Return E
		}

		FillRectangle(pGraphics, pBrush, x, y, w, h)
		{
			Return DllCall("gdiplus\GdipFillRectangle"
				, PureNotify.Ptr, pGraphics
				, PureNotify.Ptr, pBrush
				, "float", x
				, "float", y
				, "float", w
				, "float", h)
		}

		SetClipRect(pGraphics, x, y, w, h, CombineMode=0)
		{
			Return DllCall("gdiplus\GdipSetClipRect", PureNotify.Ptr, pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
		}

		GetClipRegion(pGraphics)
		{
			Region := this.CreateRegion()
			DllCall("gdiplus\GdipGetClip", PureNotify.Ptr, pGraphics, "UInt*", Region)
			Return Region
		}

		CreateRegion()
		{
			DllCall("gdiplus\GdipCreateRegion", "UInt*", Region)
			return Region
		}

		DeleteRegion(Region)
		{
			Return DllCall("gdiplus\GdipDeleteRegion", PureNotify.Ptr, Region)
		}

		SetClipRegion(pGraphics, Region, CombineMode=0)
		{	
			Return DllCall("gdiplus\GdipSetClipRegion", PureNotify.Ptr, pGraphics, PureNotify.Ptr, Region, "int", CombineMode)
		}

		FillEllipse(pGraphics, pBrush, x, y, w, h)
		{	
			Return DllCall("gdiplus\GdipFillEllipse", PureNotify.Ptr, pGraphics, PureNotify.Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
		}

	}
}


; CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0)
; {
; 	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
; 	hdc2 := hdc ? hdc : GetDC()
; 	VarSetCapacity(bi, 40, 0)
	
; 	NumPut(w, bi, 4, "uint")
; 	, NumPut(h, bi, 8, "uint")
; 	, NumPut(40, bi, 0, "uint")
; 	, NumPut(1, bi, 12, "ushort")
; 	, NumPut(0, bi, 16, "uInt")
; 	, NumPut(bpp, bi, 14, "ushort")
	
; 	hbm := DllCall("CreateDIBSection"
; 		, Ptr, hdc2
; 		, Ptr, &bi
; 		, "uint", 0
; 		, A_PtrSize ? "UPtr*" : "uint*", ppvBits
; 		, Ptr, 0
; 		, "uint", 0, Ptr)

; 	if !hdc
; 	ReleaseDC(hdc2)
; 	return hbm
; }

; CreateCompatibleDC(hdc=0)
; {
; 	return DllCall("CreateCompatibleDC", A_PtrSize ? "UPtr" : "UInt", hdc)
; }

; SelectObject(hdc, hgdiobj)
; {
; 	Ptr := A_PtrSize ? "UPtr" : "UInt"
	
; 	return DllCall("SelectObject", Ptr, hdc, Ptr, hgdiobj)
; }

; Gdip_GraphicsFromHDC(hdc)
; {
; 	DllCall("gdiplus\GdipCreateFromHDC", A_PtrSize ? "UPtr" : "UInt", hdc, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
; 	return pGraphics
; }

; Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
; {
; 	return DllCall("gdiplus\GdipSetSmoothingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", SmoothingMode)
; }

; Gdip_BrushCreateSolid(ARGB=0xff000000)
; {
; 	DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
; 	return pBrush
; }

; Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
; {
; 	Region := Gdip_GetClipRegion(pGraphics)
; 	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
; 	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
; 	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
; 	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
; 	E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
; 	Gdip_SetClipRegion(pGraphics, Region, 0)
; 	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
; 	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
; 	Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
; 	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
; 	Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
; 	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
; 	Gdip_SetClipRegion(pGraphics, Region, 0)
; 	Gdip_DeleteRegion(Region)
; 	return E
; }

; Gdip_DeleteBrush(pBrush)
; {
; 	return DllCall("gdiplus\GdipDeleteBrush", A_PtrSize ? "UPtr" : "UInt", pBrush)
; }

; Gdip_TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0)
; {
; 	IWidth := Width, IHeight:= Height
	
; 	RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
; 	RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
; 	RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
; 	RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
; 	RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
; 	RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
; 	RegExMatch(Options, "i)NoWrap", NoWrap)
; 	RegExMatch(Options, "i)R(\d)", Rendering)
; 	RegExMatch(Options, "i)S(\d+)(p*)", Size)

; 	if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour2))
; 	PassBrush := 1, pBrush := Colour2
	
; 	if !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
; 	return -1

; 	Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
; 	Loop, Parse, Styles, |
; 	{
; 		if RegExMatch(Options, "\b" A_loopField)
; 		Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
; 	}

; 	Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
; 	Loop, Parse, Alignments, |
; 	{
; 		if RegExMatch(Options, "\b" A_loopField)
; 		Align |= A_Index//2.1      ; 0|0|1|1|2|2
; 	}

; 	xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
; 	ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
; 	Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
; 	Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
; 	if !PassBrush
; 	Colour := "0x" (Colour2 ? Colour2 : "ff000000")
; 	Rendering := ((Rendering1 >= 0) && (Rendering1 <= 5)) ? Rendering1 : 4
; 	Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12

; 	hFamily := Gdip_FontFamilyCreate(Font)
; 	hFont := Gdip_FontCreate(hFamily, Size, Style)
; 	FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
; 	hFormat := Gdip_StringFormatCreate(FormatStyle)
; 	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
; 	if !(hFamily && hFont && hFormat && pBrush && pGraphics)
; 	return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0

; 	CreateRectF(RC, xpos, ypos, Width, Height)
; 	Gdip_SetStringFormatAlign(hFormat, Align)
; 	Gdip_SetTextRenderingHint(pGraphics, Rendering)
; 	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)

; 	if vPos
; 	{
; 		StringSplit, ReturnRC, ReturnRC, |
		
; 		if (vPos = "vCentre") || (vPos = "vCenter")
; 		ypos += (Height-ReturnRC4)//2
; 		else if (vPos = "Top") || (vPos = "Up")
; 		ypos := 0
; 		else if (vPos = "Bottom") || (vPos = "Down")
; 		ypos := Height-ReturnRC4
		
; 		CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
; 		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
; 	}

; 	if !Measure
; 	E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)

; 	if !PassBrush
; 	Gdip_DeleteBrush(pBrush)
; 	Gdip_DeleteStringFormat(hFormat)   
; 	Gdip_DeleteFont(hFont)
; 	Gdip_DeleteFontFamily(hFamily)
; 	return E ? E : ReturnRC
; }

; UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
; {
	
; 	if ((x != "") && (y != ""))
; 	VarSetCapacity(pt, 8), NumPut(x, pt, 0, "UInt"), NumPut(y, pt, 4, "UInt")

; 	if (w = "") ||(h = "")
; 	WinGetPos,,, w, h, ahk_id %hwnd%

; 	return DllCall("UpdateLayeredWindow"
; 		, PureNotify.Ptr, hwnd
; 		, PureNotify.Ptr, 0
; 		, PureNotify.Ptr, ((x = "") && (y = "")) ? 0 : &pt
; 		, "int64*", w|h<<32
; 		, PureNotify.Ptr, hdc
; 		, "int64*", 0
; 		, "uint", 0
; 		, "UInt*", Alpha<<16|1<<24
; 		, "uint", 2)
; }