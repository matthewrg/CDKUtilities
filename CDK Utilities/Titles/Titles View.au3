#include-once

Func Titles_View()
                         GUICtrlCreateTabItem("Titles"                  )
    Local Const $input = GUICtrlCreateInput  (''     , 15 , 35, 350, 25 )
    Local Const $enter = GuiCtrlCreateButton ("Enter", 370, 35, 45      )
    Local Const $panel = GUICtrlCreateEdit   (''     , 15 , 70, 425, 380)
                         GUICtrlCreateTabItem(''                        )

    Local Const $this = _AutoItObject_Class()

    $this.Create()

	$this.AddMethod("Read"   , "Titles_View_Read"   )
	$this.AddMethod("Display", "Titles_View_Display")

    $this.AddProperty("Input", $ELSCOPE_READONLY, $input)
    $this.AddProperty("Enter", $ELSCOPE_READONLY, $enter)
    $this.AddProperty("Panel", $ELSCOPE_READONLY, $panel)

    Return $this.Object
EndFunc

Func Titles_View_Read(Const ByRef $this)
	Return GUICtrlRead($this.Input)
EndFunc

Func Titles_View_Display(Const ByRef $this, Const $data)
	GUICtrlSetData($this.Panel, $data & @CRLF, True)
EndFunc
