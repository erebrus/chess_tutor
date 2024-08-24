extends Piece
class_name Bishop


func get_valid_moves(pieces:Dictionary)->Array[Vector2i]:
	var all_moves:Array[Vector2i] = []
	
	for mod_x in [-1,1]:
		for mod_y in [-1,1]:
			for i in range(1,9):
				var cell:=board_position.cell+Vector2i(mod_x*i,mod_y*i)
				if add_if_valid_move_or_take(pieces, cell, all_moves):
					break
	
	return  Position.get_only_valid_cells(all_moves)
