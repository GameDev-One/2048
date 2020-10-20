extends Node

onready var Clock = $MarginContainer/VBoxContainer/HBoxContainer/Clock
onready var Overlay = $MarginContainer/VBoxContainer/CenterContainer/Overlay
onready var Grid = $MarginContainer/VBoxContainer/CenterContainer/ColorRect/MarginContainer/Grid
onready var RestartBtn = $MarginContainer/VBoxContainer/HBoxContainer/Buttons/ColorRect/TextureRect/VBoxContainer/RestartBtn
onready var AudioBtn = $MarginContainer/VBoxContainer/HBoxContainer/Buttons/ColorRect/TextureRect/VBoxContainer/AudioBtn
onready var PauseBtn = $MarginContainer/VBoxContainer/HBoxContainer/Buttons/ColorRect/TextureRect/VBoxContainer/PauseBtn
onready var InfoBtn = $MarginContainer/VBoxContainer/HBoxContainer/Buttons/ColorRect/TextureRect/VBoxContainer/InfoBtn

func _ready():
	RestartBtn.self_modulate = ColorN("dodgerblue")
	AudioBtn.self_modulate = ColorN("darkgoldenrod")
	PauseBtn.self_modulate = ColorN("firebrick")
	InfoBtn.self_modulate = ColorN("mediumspringgreen")
	
	AudioBtn.get_node("AudioStreamPlayer").play(21)
	
	var err: int = 0 
	err = Global.connect("GameOver", self, "_on_GameOver")
	if err:
		printerr("Error occured with: " + name + ". Error Code: " + String(err))
	err = Global.connect("TileMatch", self, "_on_TileMatch")
	if err:
		printerr("Error occured with: " + name + ". Error Code: " + String(err))
	
	
func _on_SwipeDetector_swiped(direction):
	
	Grid.Move(direction)
	
	if Global.moved:
		Grid.Add_Tile()
	
	Grid.Draw_Board()
	
	if Global.done:
		Overlay.show()
		Overlay.get_node("Label").show()
		Overlay.get_node("InfoLabel").hide()
		RestartBtn.get_node("AnimationPlayer").play("flash")

func _on_RestartBtn_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_AudioBtn_toggled(button_pressed):
	var AudioStrPlyr = AudioBtn.get_node("AudioStreamPlayer")
	if button_pressed:
		AudioBtn.self_modulate = ColorN("darkmagenta")
		AudioStrPlyr.stop()
	else:
		AudioBtn.self_modulate = ColorN("darkgoldenrod")
		AudioStrPlyr.play(AudioStrPlyr.get_playback_position())


func _on_PauseBtn_toggled(button_pressed):
	if not Global.done:
		if button_pressed:
			PauseBtn.self_modulate = ColorN("forestgreen")
			Overlay.show()
			Overlay.get_node("Label").hide()
			Overlay.get_node("InfoLabel").hide()
			get_tree().paused = true
		else:
			PauseBtn.self_modulate = ColorN("firebrick")
			Overlay.hide()
			get_tree().paused = false


func _on_InfoBtn_pressed():
	PauseBtn.pressed = true
	_on_PauseBtn_toggled(true)
	Overlay.get_node("Label").hide()
	Overlay.get_node("InfoLabel").show()


func _on_GameOver():
	InfoBtn.disabled = true
	PauseBtn.disabled = true
	Clock.Stop()
	Overlay.show()
	
	if Global.win:
		Overlay.get_node("Label").text = "You Win!"
		Overlay.get_node("Label").set("custom_colors/font_color",ColorN("green"))
	else:
		Overlay.get_node("Label").text = "Game Over"
		Overlay.get_node("Label").set("custom_colors/font_color",ColorN("red"))
	
	Overlay.get_node("Label").show()
	Overlay.get_node("InfoLabel").hide()
	RestartBtn.get_node("AnimationPlayer").play("flash")

func _on_TileMatch(amount:float):
	Clock.Add_Time(amount)
