extends Label

func _ready():
	text = String(int($Timer.time_left))

# warning-ignore:unused_argument
func _process(delta):
	text = String(int($Timer.time_left))
	
func Add_Time(amount:float):
	$Timer.start($Timer.time_left + amount)
