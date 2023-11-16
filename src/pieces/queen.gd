extends Piece
class_name Queen


func get_valid_moves()->Array[Vector2i]:
	var all_moves:Array[Vector2i] = []
	for x in range(-8,9):
		for y in range(-8,9):
			if (x == 0 and y!=0) or \
				(y == 0 and x!=0) or \
				(x == y) or (x == -y): 
					all_moves.append(board_position.cell+Vector2i(x,y))
	
	return  Position.get_only_valid_cells(all_moves)
