extends Piece
class_name Rook


func get_valid_moves()->Array[Vector2i]:
	var all_moves:Array[Vector2i] = []
	for x in range(-8,9):
		if x!=0:
			all_moves.append(board_position.cell+Vector2i(x,0))
	for y in range(-8,9):
		if y!=0:
			all_moves.append(board_position.cell+Vector2i(0,y))
	
	return  Position.get_only_valid_cells(all_moves)
