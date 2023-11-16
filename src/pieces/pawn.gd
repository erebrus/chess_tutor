extends Piece
class_name Pawn


func get_valid_moves(board:Board)->Array[Vector2i]:
	var all_moves:Array[Vector2i] = []
	for x in range(-1,2):
		for y in range(-1,2):
			if x == 0 or y == 0:
				continue
			all_moves.append(board_position.cell+Vector2i(x,y))
	all_moves = Position.get_only_valid_cells(all_moves)
	var ret:Array[Vector2i] = []
	for move in all_moves:
		var piece_at_cell = board.get_piece_on_cell(move)
		
	return  Position.get_only_valid_cells(all_moves)
