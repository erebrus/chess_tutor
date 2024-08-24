extends Piece
class_name King


func get_valid_moves(board:Board)->Array[Vector2i]:
	var all_moves:Array[Vector2i] = []
	for x in range(-1,2):
		for y in range(-1,2):
			if x == 0 and y == 0:
				continue
			var cell := board_position.cell+Vector2i(x,y)
			add_if_valid_move_or_take(board, cell, all_moves)
		
	if not moved:
		for x in [0,7]:
			var rook_pos := Vector2i(x,board_position.cell.y)
			var long_castle:bool = abs(board_position.cell.x-rook_pos.x)==4
			var is_valid := true
			var d=sign(rook_pos.x-board_position.cell.x)
			for dx in range(board_position.cell.x+d, rook_pos.x, d):
				if board.get_piece_on_cell(Vector2i(dx, board_position.cell.y)):
					is_valid = false
					break
			if is_valid:
				all_moves.append(board_position.cell+Vector2i(2,0)*d)
			#TODO Check for attacked positions
			
	
		
	return  Position.get_only_valid_cells(all_moves)
