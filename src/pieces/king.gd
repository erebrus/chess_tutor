extends Piece
class_name King

func get_valid_moves()->Array[Vector2i]:
	var all_moves:Array[Vector2i] = []
	for x in range(-1,2):
		for y in range(-1,2):
			if x == 0 or y == 0:
				continue
			all_moves.append(board_position.cell+Vector2i(x,y))
	
	return  Position.get_only_valid_cells(all_moves)
