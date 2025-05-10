#include-once

#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <StaticConstants.au3>

Func View()
    Local Const $form = GUICreate("CDK Utilities", 450, 500)

    GUICtrlCreateTab(10, 10, 440, 450)

    GUISetFont(10, 0, 0, "Segoe UI") 

    Local Const $this = _AutoItObject_Class()

    $this.Create()

	$this.AddMethod("Show"   , "View_Show"   )
	$this.AddMethod("Tooltip", "View_Tooltip")

    $this.AddProperty("Form", $ELSCOPE_READONLY, $form)

    Return $this.Object
EndFunc

Func View_Show(Const ByRef $this)
    GUISetState(@SW_SHOWNORMAL, $this.Form)
EndFunc

Func View_Tooltip(Const ByRef $this, Const ByRef $text)
   ToolTip($text)

   Sleep(500)

   ToolTip('')
EndFunc
