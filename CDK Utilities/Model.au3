#include-once

#include "View.au3"

Func Model()
	Local Const $this = _AutoItObject_Class()

	$this.Create()

	$this.AddMethod("Init"           , "Model_Init"           )
	$this.AddMethod("GetCDKhWnd"     , "Model_GetCDKhWnd"     )
	$this.AddMethod("FormatClipboard", "Model_FormatClipboard")
	$this.AddMethod("hWndUnderMouse" , "Model_HWndUnderMouse" )
	$this.AddMethod("RetrieveVIN"    , "Model_RetrieveVIN"    )
	$this.AddMethod("IsRONumber"     , "Model_IsRONumber"     )
	$this.AddMethod("IsVIN"          , "Model_IsVIN"          )
	$this.AddMethod("WindowActivated", "Model_WindowActivated")
	$this.AddMethod("CmdLinePosition", "Model_CmdLinePosition")

	$this.AddProperty("View"   , $ELSCOPE_READONLY)
	$this.AddProperty("CDKhWnd", $ELSCOPE_READONLY)

	$this.AddMethod("TagPointStruct", "Model_TagPointStruct", True)
	$this.AddMethod("GetTimeout"    , "Model_GetTimeout"    , True)

	Return $this.Object
EndFunc

Func Model_Init(ByRef $this)
	$this.GetCDKhWnd()

	$this.View = View()
EndFunc

Func Model_GetCDKhWnd(ByRef $this)
	Local Const $CDK_hWnd = WinGetHandle("CDK Drive")

	$this.CDKhWnd = $CDK_hWnd

	Return $CDK_hWnd
EndFunc

Func Model_CmdLinePosition(ByRef $this, Const $x, Const $y)
	Local $cmdLinePos[2]

	$cmdLinePos[0] = $x
	$cmdLinePos[1] = $y

	Return $cmdLinePos
EndFunc

Func Model_FormatClipboard(Const ByRef $this)
	ClipPut(StringStripWS(ClipGet(), 8))
EndFunc

Func Model_HWndUnderMouse(Const ByRef $this, Const $hWndUnderMouse)
	; This is to match the delay that happens when x-mouse is enabled ... probably
	Local Static $timeout = $this.GetTimeout()

	Sleep($timeout)

	Local Const $childHWnd = _WinAPI_ChildWindowFromPointEX($hWndUnderMouse, $this.TagPointStruct(MouseGetPos()))

	Switch $childHWnd
		Case True
			Return _WinAPI_GetAncestor($childHWnd, $GA_PARENT)
		Case False
			Return SetError(1, @error, 0)
	EndSwitch
EndFunc

Func Model_TagPointStruct(Const ByRef $this, Const ByRef $mousePos)
	Local Static $g_tStruct = DllStructCreate($tagPOINT)

	DllStructSetData($g_tStruct, 'X', $mousePos[0])

	DllStructSetData($g_tStruct, 'Y', $mousePos[1])

	Return $g_tStruct
EndFunc

Func Model_GetTimeout(Const ByRef $this)
	Local Static $struct = DllStructCreate("dword")

	Local Static $structPtr = DllStructGetPtr($struct)

	_WinAPI_SystemParametersInfo($SPI_GETACTIVEWNDTRKTIMEOUT, 0, $structPtr)

	Return DllStructGetData($struct, 1)
EndFunc

Func Model_RetrieveVIN(Const ByRef $this, Const ByRef $text_array, Const ByRef $vin_index)
	Return StringStripWS($text_array[$vin_index - 3], 8)
EndFunc

Func Model_IsRONumber(Const ByRef $this, Const ByRef $text)
	Local Const $text1 = StringStripWS($text, 8)

	If StringLen($text1) = 6 Then
		If IsInt($text1) Then
			Return True
		EndIf
	EndIf

	Return False
EndFunc

Func Model_IsVIN(Const ByRef $this, Const $vin)
	Return StringLen($vin) = 17
EndFunc

Func Model_WindowActivated(Const ByRef $this, Const $hWnd)
	Return BitAND($hWnd, $HSHELL_WINDOWACTIVATED) = $HSHELL_WINDOWACTIVATED
EndFunc