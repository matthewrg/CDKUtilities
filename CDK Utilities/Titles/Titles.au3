#include-once

#include "Titles Model.au3"
#include "Titles View.au3"

Func Titles()
	Local $titles[]

	Local Const $this = _AutoItObject_Class()

	$this.Create()

    $this.AddMethod("Init"   , "Titles_Init"   )
	$this.AddMethod("Handler", "Titles_Handler")
	$this.AddMethod("Add"    , "Titles_Add"    )

	$this.AddProperty("Model", $ELSCOPE_READONLY)
	$this.AddProperty("View" , $ELSCOPE_READONLY)

	Return $this.Object
EndFunc

Func Titles_Init(ByRef $this)
	$this.Model = Titles_Model() 

	$this.View = Titles_View() 

	$this.Model.Get()

	Local Const $titles = $this.Model.Titles

	Local Const $count = UBound($titles) - 1

	For $i = 0 to $count
		$this.View.Display($titles[$i])
	Next
EndFunc

Func Titles_Handler(Const ByRef $this, Const $message)
	Switch $message
		Case $this.View.Enter
			Local Const $newTitle = $this.Add()

			$this.View.Display($newTitle)

			Return True
	EndSwitch

	Return False
EndFunc

Func Titles_Add(Const ByRef $this)
	Local Const $newTitle = $this.View.Read()

	FileWrite($this.Model.File, @CRLF & $newTitle)

	Return $this.Model.Get()
EndFunc
