#include-once

#include <Array.au3>

Func Titles_Model()
	Local Const $this = _AutoItObject_Class()

	$this.Create()

	$this.AddMethod("Get"  , "Titles_Model_Get"  )
	$this.AddMethod("Find" , "Titles_Model_Find" )
	$this.AddMethod("Find2", "Titles_Model_Find2")

	$this.AddProperty("Titles", $ELSCOPE_READONLY                                   )
	$this.AddProperty("File"  , $ELSCOPE_READONLY, @ScriptDir & "\Titles\Titles.txt")

	Return $this.Object
EndFunc

Func Titles_Model_Get(ByRef $this)
	Local $titles

	_FileReadToArray($this.File, $titles, 0)

	$this.Titles = $titles

	Return $titles
EndFunc

Func Titles_Model_Find(ByRef $this, Const $hWnd)	
	Local Const $titles = $this.Titles

	Local Const $count = UBound($titles) - 1

	Local Const $title = WinGetTitle(hWnd($hWnd))
	
	For $i = 0 to $count 
		If StringInStr($title, $titles[$i]) Then
			Return $titles[$i]
		EndIf
	Next

	Return False
EndFunc

Func Titles_Model_Find2(ByRef $this, Const $hWnd)	
	Local Const $titles = $this.Titles

	Local Const $count = UBound($titles) - 1

	Local Const $title = WinGetTitle(hWnd($hWnd))
	
	For $i = 0 to $count 
		If StringInStr($titles[$i], $title) Then
			Return $titles[$i]
		EndIf
	Next

	Return False
EndFunc
