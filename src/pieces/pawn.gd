extends Piece
class_name Pawn


func get_valid_moves(board:Board)->Array[Vector2i]:
	var color_modifier=-1 if color == Types.PieceColor.WHITE else 1
	
	var all_moves:Array[Vector2i] = []
	
	#move forward
	all_moves.append(board_position.cell+Vector2i(0,color_modifier))
	#move forward 2 squares if first move
	if not moved:
		all_moves.append(board_position.cell+Vector2i(0,2 * color_modifier))
	all_moves = Position.get_only_valid_cells(all_moves)

	#remove moves if square occupied
	var ret:Array[Vector2i] = []
	for move in all_moves:
		var piece_at_cell = board.get_piece_on_cell(move)
		if piece_at_cell == null:
			ret.append(move)
	
	#generate attack positions
	var attack_positions:= Position.get_only_valid_cells([
			board_position.cell+Vector2i(1,2 * color_modifier),
			board_position.cell+Vector2i(-1,2 * color_modifier)
			])
	#generate remove if not enemies there
	for move in attack_positions:
		var piece_at_cell = board.get_piece_on_cell(move)
		if piece_at_cell != null and piece_at_cell.color != color:
			ret.append(move)
		
	return  ret
