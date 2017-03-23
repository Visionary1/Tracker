DownloadToStr(url, Async := False)
{
	static obj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	obj.Open("GET", url, Async), obj.Send(), obj.WaitForResponse()
	Return obj.ResponseText
}