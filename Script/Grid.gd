extends GridContainer

func _ready():
	randomize()
	Add_Tile()
	Add_Tile()
	Draw_Board()
	

func Add_Tile()-> void:
	for tile in get_children():
		while tile.value < 2:
			var open_tile = randi() % 16
			if get_child(open_tile).value < 2:
				var percentage = randi() % 100
				if percentage > 89:
					get_child(open_tile).value = 4
				else:
					get_child(open_tile).value = 2
					
				get_child(open_tile).grow()
				
				if Can_Move():
					return
	Global.done = true
	
func Draw_Board():
	var debug_arr: String = ""
	var newline = 0
	for tile in get_children():
		tile.text = String(tile.value)
		tile.change_color()
		debug_arr += String(tile.value) + " "
		newline += 1
		if newline > 3:
			debug_arr += "\n"
			newline = 0
	print(debug_arr)

func Can_Move() -> bool:
	for tile in get_children():
		if tile.value < 2:
			return true
			
	for y in range(4):
		for x in range(4):
			var test_index = x + (y * 4)
			if Test_Add(x+1, y, get_child(test_index).value):
				return true
			if Test_Add(x-1, y, get_child(test_index).value):
				return true
			if Test_Add(x, y+1, get_child(test_index).value):
				return true
			if Test_Add(x, y-1, get_child(test_index).value):
				return true
			
	return false
	
func Test_Add(_x:int, _y:int, _value:int) -> bool:
	if (_x < 0 || _x > 3 || _y < 0 || _y > 3):
		return false
	return get_child(_x+(_y*4)).value == _value
	
func Move(_direction: Vector2):
	
	Global.moved = false
	
	match _direction:
		Vector2.DOWN:
			for x in range(4):
				for y in range(1,4):
					if get_child(x+(y*4)).value > 0:
						Move_Vert(x,y,-1)
		Vector2.UP:
			for x in range(4):
				for y in range(2,-1,-1):
					if get_child(x+(y*4)).value > 0:
						Move_Vert(x,y,1)
		Vector2.RIGHT:
			for y in range(4):
				for x in range(1,4):
					if get_child(x+(y*4)).value > 0:
						Move_Hori(x,y,-1)
		Vector2.LEFT:
			for y in range(4):
				for x in range(2,-1,-1):
					if get_child(x+(y*4)).value > 0:
						Move_Hori(x,y,1)
		_:
			printerr("INVALID MOVE WAS MADE IN ", _direction, " DIRECTION.")
			
	for tile in get_children():
		tile.blocked = false

func Move_Vert(_x:int, _y:int, _direction:int):
	var old_index = _x + (_y*4)
	var new_index = _x + ((_y +_direction) * 4)
	var old_tile = get_child(old_index)
	var new_tile = get_child(new_index)
	
	if new_tile and new_tile.value == old_tile.value:
		if not new_tile.blocked and not old_tile.blocked:
			old_tile.value = 0
			new_tile.value *= 2
			
			if new_tile.value == 2048:
				Global.emit_signal("GameOver", true)
				
			new_tile.blocked = true
			new_tile.shrink()
			Global.emit_signal("TileMatch", new_tile.value / 20.0)
			Global.moved = true
			
	elif not new_tile.value and old_tile.value:
		new_tile.value = old_tile.value
		old_tile.value = 0
		Global.moved = true
	
	if _direction > 0:
		if _y + _direction < 3:
			Move_Vert(_x, _y + _direction, 1)
	else:
		if _y + _direction > 0: 
			Move_Vert(_x, _y + _direction, -1)
			
func Move_Hori(_x:int, _y:int, _direction:int):
	var old_tile = get_child(_x + (_y*4))
	var new_tile = get_child(_x + (_y*4) +_direction)
	if new_tile and new_tile.value == old_tile.value:
		if not new_tile.blocked and not old_tile.blocked:
			old_tile.value = 0
			new_tile.value *= 2
			
			if new_tile.value == 2048:
				Global.emit_signal("GameOver", true)
				
			new_tile.blocked = true
			new_tile.shrink()
			Global.emit_signal("TileMatch", new_tile.value / 20.0)
			Global.moved = true
	elif not new_tile.value and old_tile.value:
			new_tile.value = old_tile.value
			old_tile.value = 0
			Global.moved = true
			
	if _direction > 0:
		if _x + _direction < 3:
			Move_Hori(_x + _direction, _y, 1)
	else:
		if _x + _direction > 0:
			Move_Hori(_x + _direction, _y, -1)
