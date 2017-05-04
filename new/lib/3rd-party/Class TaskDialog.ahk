/**
	* Class MsgBox
	*		윈도우 Vista 이후부터 지원되는 TaskDialog 메시지박스 모듈화
	* 		관련 링크 : https://msdn.microsoft.com/en-us/library/windows/desktop/bb760540%28v=vs.85%29.aspx
	* 버전:
	*		v1.0 [마지막 수정 11/26/2015 (MM/DD/YYYY)]
	* 라이센스:
	*		WTFPL [http://wtfpl.net/]
	* 시스템 요구사항:
	*		AutoHotkey v1.1.22.09 (제 환경입니다, 아마 1.1 이후부터는 다 될꺼에요)
	* 설치:
	*		#Include Class TaskDialog.ahk 또는, Lib 폴더로 이동
	* 정보:
	*		라이브러리 제작자 - 예지력 ( http://knowledgeisfree.tistory.com )
	*		참고 - https://autohotkey.com/boards/viewtopic.php?t=4635
*/

Class TaskDialog
{
	static TDCBF_BUTTON 	:= { "확인": 0x01, "예": 0x02, "아니오": 0x04, "취소": 0x08, "다시 시도": 0x10, "닫기": 0x20 }
	, pnButton 		:= [ "확인", "취소",, "다시 시도",, "예", "아니오", "닫기" ]
	, TD_ICON		:= { "WARNING": 1, "ERROR": 2, "INFO": 3, "SHIELD": 4, "BLUE": 5, "YELLOW": 6, "RED": 7, "GREEN": 8, "GRAY": 9 }
	

	/**
		* __New 메타함수:
		* 			Return 		:= new TaskDialog( [제목], [설명], [내용], 버튼, [아이콘], [Parent 부모 윈도우] )
		*			[제목]		메시지박스의 제목
		*			[설명]		Instruction 메시지박스 위 설명
		*			[내용]		메시지박스의 내용
		*			버튼			메시지박스의 버트 바인딩, | 로 버튼 추가하세요!
		*			아이콘		메시지박스의 아이콘
		*			[Parent]	바인딩할 부모 윈도우
		
		* 			Return		클릭한 버튼명을 '문자' 로 리턴합니다!
	*/
	__New(pszWindowTitle := "", pszMainInstruction :="", pszContent := 0, dwCommonButtons := 0, pszIcon := 0, hWndParent := 0)
	{
		if ( A_OSVersion == "WIN_XP")
			throw 	"TaskDialog 모듈은 윈도우 XP를 지원하지 않습니다!"
		return 		this.Create(pszWindowTitle, pszMainInstruction, pszContent , dwCommonButtons, pszIcon, hWndParent)
	}
	
	Create(pszWindowTitle, pszMainInstruction, pszContent, dwCommonButtons, pszIcon, hWndParent)
	{
		this.btns := 0
		if !(Abs(dwCommonButtons) == "")
			this.btns := dwCommonButtons & 0x3F
		else
			for each, Item in StrSplit(dwCommonButtons, ["|", " ", ",", "`n"])
				this.btns |= (b := this.TDCBF_BUTTON[Item]) ? b : 0
		
		this.ico			:= (each := this.TD_ICON[pszIcon]) ? 0x10000 - each : 0
		this.hWndParent			:= hWndParent
		this.hInstance			:= 0
		this.pszWindowTitle		:= pszWindowTitle != "" ? pszWindowTitle : A_ScriptName
		this.pszMainInstruction	:= pszMainInstruction
		this.pszContent			:= pszContent
		HRESULT := 0 ;prevent warn
		this.HRESULT			:= DllCall("comctl32\TaskDialog", "Ptr", this.hWndParent
		, "Ptr", this.hInstance
		, "WStr", this.pszWindowTitle
		, "WStr", this.pszMainInstruction
		, this.pszContent = 0 ? "Ptr" : "WStr", this.pszContent
		, "UInt", this.btns
		, "Ptr", this.ico
		, "IntP", HRESULT)
		return				this.pnButton[HRESULT]
	}
}