extends GridContainer

func _ready():
	randomize()
	add_tile()
	add_tile()
	draw_board()

func add_tile() -> void:
	for tile in get_children():
		while tile.value < 2:
			var open_tile = randi() % 16
			if get_child(open_tile).value < 2:
				var percentage = randi() % 100
				if percentage > 89:
					get_child(open_tile).value = 4
				else:
					get_child(open_tile).value = 2
					
				if _can_move():
					return
					
	Global2048.done = true
	
func draw_board() -> void:
	for tile in get_children():
		tile.text = String(tile.value)
	
func _can_move() -> bool:
	for tile in get_children():
		if tile.value < 2:
			return true
			
	for y in range(4):
		for x in range(4):
			var test_index = x + (y * 4)
			if _test_add(x + 1, y, get_child(test_index).value):
				return true
			if _test_add(x - 1, y, get_child(test_index).value):
				return true
			if _test_add(x, y + 1, get_child(test_index).value):
				return true
			if _test_add(x, y - 1, get_child(test_index).value):
				return true
	return false
	
func _test_add(x:int, y:int, value:int) -> bool:
	if x < 0 || x > 3 || y < 0 || y > 3 :
		return false
	
	return get_child(x + (y * 4)).value == value
	
func move(direction: Vector2) -> void:
	Global2048.moved = false
	
	match direction:
		Vector2.DOWN:
			for x in range(4):
				for y in range(1,4):
					if get_child(x + y * 4).value > 0:
						_move_vertical(x, y, -1)
		Vector2.UP:
			for x in range(4):
				for y in range(2, -1 , -1):
					if get_child(x + y * 4).value > 0:
						_move_vertical(x, y, 1)
		Vector2.RIGHT:
			for y in range(4):
				for x in range(1, 4):
					if get_child(x + y * 4).value > 0:
						_move_horizontal(x, y, -1)
		Vector2.LEFT:
			for y in range(4):
				for x in range(2, -1, -1):
					if get_child(x + y * 4).value > 0:
						_move_horizontal(x, y, 1)
		_:
			printerr("Invalide moved was made.")
			
	for tile in get_children():
		tile.blocked = false
	
func _move_vertical(x:int, y:int, direction:int) -> void:
	var old_index = x + (y * 4)
	var new_index = x + ((y + direction) * 4)
	var old_tile = get_child(old_index)
	var new_tile = get_child(new_index)
	
	if new_tile and new_tile.value == old_tile.value:
		if not new_tile.blocked and not old_tile.blocked:
			old_tile.value = 0
			new_tile.value *= 2
			
			if new_tile.value == 2048:
				Global2048.win = true
				
		new_tile.blocked = true
		Global2048.moved = true
		
	elif not new_tile.value and old_tile.value:
			new_tile.value = old_tile.value
			old_tile.value = 0
			Global2048.moved = true
			
	if direction > 0:
		if y + direction < 3:
			_move_vertical(x, y + direction, 1)
	else:
		if y + direction > 0:
			_move_vertical(x, y + direction, -1)
	
func _move_horizontal(x:int, y:int, direction:int) -> void:
	var old_index = x + (y * 4)
	var new_index = x + ((y * 4)+direction)
	var old_tile = get_child(old_index)
	var new_tile = get_child(new_index)
	
	if new_tile and new_tile.value == old_tile.value:
		if not new_tile.blocked and not old_tile.blocked:
			old_tile.value = 0
			new_tile.value *= 2
			if new_tile.value == 2048:
				Global2048.win = true
				
			new_tile.blocked = true
			Global2048.moved = true
			
	elif not new_tile.value and old_tile.value:
		new_tile.value = old_tile.value
		old_tile.value = 0
		Global2048.moved = true
		
	if direction > 0:
		if x + direction < 3:
			_move_horizontal(x + direction, y, 1)
	else:
		if x + direction > 0:
			_move_horizontal(x + direction, y, -1)		
























