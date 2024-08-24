extends Piece
class_name Queen


func get_valid_moves(pieces:Dictionary)->Array[Vector2i]:
	var all_moves:Array[Vector2i] = []
	
	for mod in [-1,1]:
		for x in range(1,9):
			var cell:=board_position.cell+Vector2i(mod*x,0)
			if add_if_valid_move_or_take(pieces, cell, all_moves):
				break
		for y in range(1,9):
			var cell:=board_position.cell+Vector2i(0, mod*y)
			if add_if_valid_move_or_take(pieces, cell, all_moves):
				break
				
				
	for mod_x in [-1,1]:
		for mod_y in [-1,1]:
			for i in range(1,9):
				var cell:=board_position.cell+Vector2i(mod_x*i,mod_y*i)
				if add_if_valid_move_or_take(pieces, cell, all_moves):
					break
	
	return  Position.get_only_valid_cells(all_moves)
