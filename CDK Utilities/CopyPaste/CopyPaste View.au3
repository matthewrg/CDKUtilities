#include-once

Func CopyPaste_View()
                         GUICtrlCreateTabItem("Copy/Paste")
    Local Const $panel = GUICtrlCreateEdit   (''     , 10, 30, 425, 425)
    Local Const $clear = GUICtrlCreateButton ("Clear", 10, 465         )
                         GUICtrlCreateTabItem('')

    Local Const $this = _AutoItObject_Class()

    $this.Create()

	$this.AddMethod("Display", "CopyPaste_View_Display")
	$this.AddMethod("Clear"  , "CopyPaste_View_Clear"  )
	$this.AddMethod("ToolTip", "CopyPaste_View_ToolTip")

    $this.AddProperty("Panel", $ELSCOPE_READONLY, $panel)
    $this.AddProperty("btnClear", $ELSCOPE_READONLY, $clear)

    Return $this.Object
EndFunc

Func CopyPaste_View_Display(ByRef $this, Const ByRef $message)
	GUICtrlSetData($this.Panel, $message & @CRLF, True)
EndFunc

Func CopyPaste_View_Clear(ByRef $this)
	GuiCtrlSetData($this.Panel, '')
EndFunc

volatile Func CopyPaste_View_ToolTip(Const ByRef $this, Const $text)
    ToolTip($text)

    Sleep(2000)

    ToolTIp('')
EndFunc