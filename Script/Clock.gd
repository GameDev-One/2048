extends Control

var _is_in_warning: bool = false
var _is_in_danger: bool = false

export var time_left: float = 45.0

func _ready():
	$Timer.wait_time = time_left
	$Timer.start()
	
# warning-ignore:return_value_discarded
	Global.connect("TileMatch",self,"Add_Time")
	
# warning-ignore:unused_argument
func _process(delta):
	time_left = $Timer.time_left
	_Update_Timer()

func Add_Time(seconds: float) -> void:
	$Tween.interpolate_property($TextureProgress,"value", null, time_left + seconds, 0.5,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.start()
	time_left += seconds
	$Timer.start(time_left)
	
func Stop() -> void:
	set_process(false)

func _Update_Timer() -> void:
	if not $Tween.is_active():
		Add_Time(0)
		
	if time_left < 10:
		if not _is_in_danger:
			_is_in_danger = true
			$AnimationPlayer.play("danger_flash")
#		$TextureProgress.tint_progress = ColorN("firebrick")
	elif time_left < 30:
		if not _is_in_warning:
			_is_in_warning = true
			$AnimationPlayer.play("warning_flash")
#		$TextureProgress.tint_progress = ColorN("orange")
	else:
		_is_in_danger = false
		_is_in_warning = false
		$TextureProgress.tint_progress = ColorN("Green")
	

func _on_Timer_timeout():
	Global.emit_signal("GameOver")
