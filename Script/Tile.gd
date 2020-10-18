extends Control

var value = 0
var blocked = false

var text = '' setget set_text

func _ready():
	pass

func set_text(t: String):
	if not t == "0":
		$Bg/Label.text = t
		$Bg/Label.show()
		$Bg/Panel.show()
	else:
		$Bg/Label.text = ""
		$Bg/Label.hide()
		$Bg/Panel.hide()
		
func grow():
	$AnimationPlayer.play("grow")
	
func shrink():
	$AnimationPlayer.play("shrink")
	
func change_color():
	match value:
		2:
			$Bg/Panel.self_modulate = Color8(238, 229, 233)
		4:
			$Bg/Panel.self_modulate = Color8(248, 221, 201)
		8:
			$Bg/Panel.self_modulate = Color8(236, 210, 172)
		16:
			$Bg/Panel.self_modulate = Color8(161, 232, 175)
		32:
			$Bg/Panel.self_modulate = Color8(148, 197, 149)
		64:
			$Bg/Panel.self_modulate = Color8(197, 216, 109)
		128:
			$Bg/Panel.self_modulate = Color8(128, 148, 157)
		256:
			$Bg/Panel.self_modulate = Color8(14, 120, 170)
		512:
			$Bg/Panel.self_modulate = Color8(136, 27, 36)
		1024:
			$Bg/Panel.self_modulate = Color8(222, 186, 8)
		2048:
			$Bg/Panel.self_modulate = Color8(50, 23, 77)
		_:
			print("Invalid value for: " + name)
	

# warning-ignore:unused_argument
func fade(direction:Vector2):
	$AnimationPlayer.play("fadeout")
