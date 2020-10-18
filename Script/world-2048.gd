extends Node

func _on_swipedetector2048_swiped(direction):
	$"Center/grid-2048".move(direction)
	
	if Global2048.moved:
		$"Center/grid-2048".add_tile()
		
	$"Center/grid-2048".draw_board()
	
	if Global2048.done:
		if Global2048.win:
			print("You Win!")
		else: 
			print("Game Over")
