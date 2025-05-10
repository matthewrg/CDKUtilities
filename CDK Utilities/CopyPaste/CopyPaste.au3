#include-once

#include "CopyPaste View.au3"

Func CopyPaste()
    Local Const $this = _AutoItObject_Class()

    $this.Create()

    $this.AddMethod("Init"   , "CopyPaste_Init"   )
    $this.AddMethod("Handler", "CopyPaste_Handler")
    $this.AddMethod("Paste"  , "CopyPaste_Paste"  )

    $this.AddMethod("MouseClick", "CopyPaste_MouseClick", True)
    $this.AddMethod("MouseMove" , "CopyPaste_MouseMove" , True)
    $this.AddMethod("Send"      , "CopyPaste_Send"      , True)

    $this.AddProperty("View", $ELSCOPE_READONLY)

    $this.AddDestructor("CopyPaste_Dtor")

    Return $this.Object
EndFunc

Func CopyPaste_Init(ByRef $this, Const ByRef $copyCallback, Const ByRef $pasteCallback)
    $this.View = CopyPaste_View()

    HotKeySet("^+c", $copyCallback)

    HotKeySet("^+v", $pasteCallback)
EndFunc

Func CopyPaste_Handler(Const ByRef $this, Const $message)
    Switch $message
        Case $this.View.btnClear
            $this.View.Clear()

			Return True
    EndSwitch

	Return False
EndFunc

Func CopyPaste_Paste(Const ByRef $this, Const ByRef $pos)
	Local Const $mouse_pos_memo = MouseGetPos()

	$this.MouseClick($MOUSE_CLICK_RIGHT, $pos)

	$this.Send('P')

	$this.MouseMove($mouse_pos_memo)
EndFunc

Func CopyPaste_MouseClick(Const ByRef $this, Const ByRef $button, Const ByRef $mouse_pos)
	MouseClick($button, $mouse_pos[0], $mouse_pos[1], 1, 1)

	Sleep(100)
EndFunc

Func CopyPaste_MouseMove(Const ByRef $this, Const ByRef $mouse_pos)
	MouseMove($mouse_pos[0], $mouse_pos[1], 1)

	Sleep(100)
EndFunc

Func CopyPaste_Send(Const ByRef $this, Const ByRef $key)
   SendKeepActive(hWnd($cdkUtils.CDKhWnd))

   Send($key)

   SendKeepActive('')
EndFunc

Func CopyPaste_Dtor(Const ByRef $this)
	HotKeySet("^+c")

	HotKeySet("^+v")
EndFunc
