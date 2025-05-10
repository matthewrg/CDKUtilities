#include-once

Func Capslock_View()
                         GUICtrlCreateTabItem("Capslock")
    Local Const $panel = GUICtrlCreateEdit   (''     , 10, 30, 425, 425)
    Local Const $clear = GUICtrlCreateButton ("Clear", 10, 465)
                         GUICtrlCreateTabItem('')

    Local Const $this = _AutoItObject_Class()

    $this.Create()

	$this.AddMethod("Print", "CapsLock_View_Print")
	$this.AddMethod("Erase", "CapsLock_View_Erase")

    $this.AddProperty("Panel", $ELSCOPE_READONLY, $panel)
    $this.AddProperty("btnClear", $ELSCOPE_READONLY, $clear)

    Return $this.Object
EndFunc

Func CapsLock_View_Print(Const ByRef $this, Const ByRef $text)
	GUICtrlSetData($this.Panel, $text & @CRLF, True)
EndFunc

Func CapsLock_View_Erase(Const ByRef $this)
	GuiCtrlSetData($this.Panel, '')
EndFunc

