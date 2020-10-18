extends Node

func _ready():
	$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/RestartBtn.self_modulate = ColorN("dodgerblue")
	$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/AudioBtn.self_modulate = ColorN("darkgoldenrod")
	$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/PauseBtn.self_modulate = ColorN("firebrick")
	$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/InfoBtn.self_modulate = ColorN("mediumspringgreen")
	
	$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/AudioBtn/AudioStreamPlayer.play(21)
	
# warning-ignore:return_value_discarded
	Global.connect("GameOver", self, "_on_GameOver")
	Global.connect("TileMatch", self, "_on_TileMatch")
	
	
func _on_SwipeDetector_swiped(direction):
	
	$VBoxContainer/CenterContainer/ColorRect/Grid.Move(direction)
	
	if Global.moved:
		$VBoxContainer/CenterContainer/ColorRect/Grid.Add_Tile()
	
	$VBoxContainer/CenterContainer/ColorRect/Grid.Draw_Board()
	
	if Global.done:
		$VBoxContainer/CenterContainer/Overlay.show()
		$VBoxContainer/CenterContainer/Overlay/Label.show()
		$VBoxContainer/CenterContainer/Overlay/InfoLabel.hide()
		$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/RestartBtn/AnimationPlayer.play("flash")

func _on_RestartBtn_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_AudioBtn_toggled(button_pressed):
	if button_pressed:
		$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/AudioBtn.self_modulate = ColorN("darkmagenta")
		$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/AudioBtn/AudioStreamPlayer.stop()
	else:
		$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/AudioBtn.self_modulate = ColorN("darkgoldenrod")
		$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/AudioBtn/AudioStreamPlayer.play($VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/AudioBtn/AudioStreamPlayer.get_playback_position())


func _on_PauseBtn_toggled(button_pressed):
	if not Global.done:
		if button_pressed:
			$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/PauseBtn.self_modulate = ColorN("forestgreen")
			$VBoxContainer/CenterContainer/Overlay.show()
			$VBoxContainer/CenterContainer/Overlay/Label.hide()
			$VBoxContainer/CenterContainer/Overlay/InfoLabel.hide()
			get_tree().paused = true
		else:
			$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/PauseBtn.self_modulate = ColorN("firebrick")
			$VBoxContainer/CenterContainer/Overlay.hide()
			get_tree().paused = false


func _on_InfoBtn_pressed():
	$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/PauseBtn.pressed = true
	_on_PauseBtn_toggled(true)
	$VBoxContainer/CenterContainer/Overlay/Label.hide()
	$VBoxContainer/CenterContainer/Overlay/InfoLabel.show()


func _on_GameOver():
	$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/InfoBtn.disabled = true
	$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/PauseBtn.disabled = true
	$VBoxContainer/CenterContainer/Overlay.show()
	
	if Global.win:
		$VBoxContainer/CenterContainer/Overlay/Label.text = "You Win!"
		$VBoxContainer/CenterContainer/Overlay/Label.set("custom_colors/font_color",ColorN("green"))
	else:
		$VBoxContainer/CenterContainer/Overlay/Label.text = "Game Over"
		$VBoxContainer/CenterContainer/Overlay/Label.set("custom_colors/font_color",ColorN("red"))
	
	$VBoxContainer/CenterContainer/Overlay/Label.show()
	$VBoxContainer/CenterContainer/Overlay/InfoLabel.hide()
	$VBoxContainer/HBoxContainer/VBoxContainer/ColorRect/TextureRect/HBoxContainer/RestartBtn/AnimationPlayer.play("flash")


func _on_Timer_timeout():
	$VBoxContainer/HBoxContainer/Timer/Timer.stop()
	Global.emit_signal("GameOver")
	
func _on_TileMatch(amount:float):
	$VBoxContainer/HBoxContainer/Timer.Add_Time(amount)
