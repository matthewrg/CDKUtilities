#include-once

#include "Capslock View.au3"

Func Capslock()
    Local Const $this = _AutoItObject_Class()

    $this.Create()

    $this.AddMethod("Handler"   , "Capslock_Handler"   )
    $this.AddMethod("Init"      , "Capslock_Init"      )
	$this.AddMethod("CapsLockOn", "Capslock_CapsLockOn")

    $this.AddProperty("View", $ELSCOPE_READONLY)

    $this.AddDestructor("Capslock_Dtor")

    Return $this.Object
EndFunc

Func Capslock_Init(ByRef $this, Const ByRef $callback)
    $this.View = Capslock_View()

    _WinAPI_RegisterShellHookWindow($cdkUtils.View.Form)

    GUIRegisterMsg(_WinAPI_RegisterWindowMessage("SHELLHOOK"), $callback)
EndFunc

Func Capslock_Handler(Const ByRef $this, Const $message)
    Switch $message
        Case $capslock.View.btnClear
            $capslock.View.Erase()

            Return True
    EndSwitch

    Return False
EndFunc

Func Capslock_CapsLockOn(Const ByRef $this)
	If _WinAPI_GetKeyState(0x14) Then
		Return True
	Else
		Return False
	EndIf
EndFunc

Func Capslock_Dtor(Const ByRef $this)
    _WinAPI_DeregisterShellHookWindow($cdkUtils.View.Form)
EndFunc