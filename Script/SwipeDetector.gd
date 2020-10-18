extends Node
"""
Sourced from:

https://youtu.be/7XlMqjikI9A

https://github.com/GDQuest/godot-power-pitch/blob/master/godot-3-presentation/
src/touch_controls/swipe_detector/SwipeDetector.gd
"""

signal swiped(direction)
signal swiped_cancelled(start_position)
export(float, 1.0, 50.5) var MAX_DIAGONAL_SLOPE= 1.3

onready var timer = $Timer
var swipe_start_position: Vector2 = Vector2()

func _input(event):
	if not event is InputEventScreenTouch:
		return
		
	if event.pressed:
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)

func _start_detection(position):
	swipe_start_position = position
	timer.start()
	
func _end_detection(position):
	timer.stop()
	var direction = (position - swipe_start_position).normalized()
	if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
		return
	if abs(direction.x) > abs(direction.y):
		emit_signal("swiped", Vector2(-sign(direction.x), 0.0))
	else:
		emit_signal("swiped", Vector2(0.0, -sign(direction.y)))

func _on_Timer_timeout():
	emit_signal("swiped_cancelled", swipe_start_position)