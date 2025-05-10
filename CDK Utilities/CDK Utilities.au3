
Opt("SendCapslockMode"   , 0)
Opt("TrayAutoPause"      , 0)
Opt("WinTitleMatchMode"  , 2)
Opt("WinDetectHiddenText", 1)

#include <WinAPI.au3>
#include <WinAPISysWin.au3>
#include <WinAPISysInfoConstants.au3>

#include "AutoItObject.au3"
#include "Model.au3"
#include "Capslock\Capslock.au3"
#include "CopyPaste\CopyPaste.au3"
#include "Titles\Titles.au3"

_AutoItObject_Startup()

Global $cdkUtils = Model()

Global $capslock = Capslock()

Global $copyPaste = CopyPaste()

Global $titles = Titles()

mainLoop()

Func mainLoop()
	$cdkUtils.Init()

	$capslock.Init(CapslockSentinel)

	$copyPaste.Init(CDKCopyVIN, CDKPaste)

	$titles.Init()

	$cdkUtils.View.Show()

	Local $message

	While True
		$message = GUIGetMsg()

		If Not $message Then ContinueLoop

		If $capslock.Handler($message) Then ContinueLoop

		If $copyPaste.Handler($message) Then ContinueLoop

		If $titles.Handler($message) Then ContinueLoop

		Switch $message
			Case $GUI_EVENT_CLOSE
				Exit
		EndSwitch
	WEnd
EndFunc

; ------------------------------------------------------------------------------------------------

Func CapslockSentinel(Const ByRef $hWnd, Const ByRef $iMsg, Const ByRef $wParam, Const ByRef $activeHwnd)
	#forceref $hWnd, $iMsg

	Switch $cdkUtils.WindowActivated($wParam)
		Case True
			If $activeHwnd = hWnd($cdkUtils.CDKhWnd) Then
				Send("{CAPSLOCK ON}")

				Switch $titles.Model.Find($activeHwnd)
					Case False
						$capslock.View.Print("2 Not found. Title: " & @CRLF & @TAB & WinGetTitle($activeHwnd))
				EndSwitch
			Else
				Switch $titles.Model.Find2($activeHwnd) 
					Case True
						Send("{CAPSLOCK ON}")
					Case False
						Send("{CAPSLOCK OFF}")
				EndSwitch
			EndIf
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc

; ------------------------------------------------------------------------------------------------

Func CDKCopyVIN()
	Local Const $text = WinGetText(hWnd($cdkUtils.CDKhWnd))

	Switch $text
		Case True
			Local Const $proText = StringSplit(StringStripWS($text, 4), @CRLF)

			Local Const $vinIndex = _ArrayFindAll($proText, "Serial#:")

			Local Const $vinCount = Ubound($vinIndex)

			If $vinCount = 1 Then
				Local Const $vin = $cdkUtils.RetrieveVIN($proText, $vinIndex[0])

				If $cdkUtils.IsVIN($vin) Then
					ClipPut($vin)

					$copyPaste.View.Display($vin)

					$copyPaste.View.ToolTip($vin)
				EndIf
			ElseIf $vinCount > 1 Then
				$copyPaste.View.Display("Multiple VINs!")

				$copyPaste.View.ToolTip("Multiple VINs!")
			EndIf

		Case False
			$copyPaste.View.Display("No VIN found ... :(")

			$copyPaste.View.ToolTip("No VIN found ... :(")
	EndSwitch
EndFunc

; ------------------------------------------------------------------------------------------------

Func CDKPaste()
	Local Const $title = $titles.Model.Find(hWnd($cdkUtils.CDKhWnd))

	$copyPaste.View.Display("Title: " & $title)

	Local Const $clipboard = ClipGet()

	Local $cmdLinePos

	Switch $title
		Case "Parts Charges For Repair Order"
			If $cdkUtils.IsRONumber($clipboard) Then
				$cmdLinePos = $cdkUtils.CmdLinePosition(297, 222)
			Else
				$cmdLinePos = $cdkUtils.CmdLinePosition(115, 825)
			EndIf

		Case "Create/Modify Parts Invoice", "Invoice (I)"
			$cmdLinePos = $cdkUtils.CmdLinePosition(115, 825)

		Case "Comment Line"
			$cmdLinePos = $cdkUtils.CmdLinePosition(535, 720)

		Case Else
			$copyPaste.View.Display("No Paste =(")

			Return False
	EndSwitch

	ClipPut(StringStripWS($clipboard, 8))

	$copyPaste.Paste($cmdLinePos)

	$copyPaste.View.Display(@TAB & "Pasted:" & $clipboard)
EndFunc

; ------------------------------------------------------------------------------------------------
