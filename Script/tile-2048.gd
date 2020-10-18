extends Control

var value: int = 0
var blocked: bool = false

var text: String = "" setget _set_text

func _set_text(new_text:String):
	if not new_text == "0":
		$Bg/Label.text = new_text
		$Bg/Label.show()
	else:
		$Bg/Label.text = ""
		$Bg/Label.hide()
