extends Piece
class_name Knight

func get_valid_moves(pieces:Dictionary)->Array[Vector2i]:
	var all_moves:Array[Vector2i] = []
	
	for x in [1,2,-1,-2]:
		for y in [1,2,-1,-2]:
			if abs(x) == abs(y):
				continue
			var cell := board_position.cell+Vector2i(x,y)
			add_if_valid_move_or_take(pieces, cell, all_moves)
					
	
	return  Position.get_only_valid_cells(all_moves)
