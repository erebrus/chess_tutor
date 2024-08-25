extends TileMap
class_name Board

var bishopScene:PackedScene = preload("res://src/pieces/bishop.tscn")
var knightScene:PackedScene = preload("res://src/pieces/knight.tscn")
var pawnScene:PackedScene = preload("res://src/pieces/pawn.tscn")
var rookScene:PackedScene = preload("res://src/pieces/rook.tscn")
var kingScene:PackedScene = preload("res://src/pieces/king.tscn")
var queenScene:PackedScene = preload("res://src/pieces/queen.tscn")
var highlightScene:PackedScene = preload("res://src/highlight.tscn")

const LIGHT_SQUARE_ID=5
const DARK_SQUARE_ID=4

var mode :Types.Mode = Types.Mode.PLAY
var side:Types.PieceColor = Types.PieceColor.WHITE
var move:int = 0
var pieces := {}
var history := []
var history_idx :=-1

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.piece_selected.connect(_on_piece_selected)
	Events.piece_unselected.connect(_on_piece_unselected)
	Events.piece_move_requested.connect(_on_piece_move_requested)
	Events.piece_taken.connect(_on_piece_taken)
	Events.move_successful.connect(_on_move_successful)
	Events.move_back_requested.connect(back)
	Events.move_forward_requested.connect(forward)
	Events.move_to_end_requested.connect(to_end)
	Events.move_to_start_requested.connect(to_start)
	create_board();
	Events.turn_changed.emit(side)
	await get_tree().process_frame
	add_record(pieces, null,Vector2.ZERO)
	move=1
#	get_cell_tile_data(0, Vector2.ZERO).set_custom_data("piece")


func _on_move_successful(_piece:Piece):
	if side == Types.PieceColor.WHITE:
		side = Types.PieceColor.BLACK
	else:
		side = Types.PieceColor.WHITE
		move += 1
	Events.turn_changed.emit(side)
		
func _on_piece_taken(piece:Piece):
	piece.queue_free()
	
func add_record(_pieces,piece:Piece, cell, taken:Piece=null):
	history_idx += 1
	var move_record = HistoryEntry.create_from_board(_pieces,move, piece, cell, taken)			
	if piece:
		Logger.info(str(move_record))
	history.append(move_record)
	Events.board_changed.emit(history.slice(0,history_idx+1))

func _on_piece_move_requested(piece:Piece, pos:Vector2):
	var cell := local_to_map(to_local(pos))
	var tentative := pieces.duplicate()
	var taken:Piece
	if cell in piece.get_valid_moves(tentative):				
		if get_piece_on_cell(cell) == null:
			tentative.erase(piece.board_position.cell)
			tentative[cell]=piece
		elif get_piece_on_cell(cell).color != piece.color:
			taken = get_piece_on_cell(cell)
			tentative.erase(cell)
			tentative.erase(piece.board_position.cell)
			tentative[cell]=piece
		else:
			Events.move_failed.emit(piece)
			return
		
		if check_pieces(tentative):
			
			
			pieces = tentative
			var origin_cell = piece.board_position.cell
			piece.move_to(Position.from_cell(cell))			
			piece.position = map_to_local(cell)

			add_record(tentative, piece, origin_cell, taken)
			Events.move_successful.emit(piece)


			if taken:
				Events.piece_taken.emit(taken)	
				
			
			
			
func get_king_cell(tentative:Dictionary, _side:Types.PieceColor):
	for cell in tentative:
		if tentative[cell] is King and tentative[cell].color == _side:
			return cell
	assert(false)
	return Vector2i.ONE*-1
	
func check_pieces(tentative:Dictionary)->bool:
	var king_cell = get_king_cell(tentative,side)
	for cell in tentative:
		var piece:Piece = tentative[cell] if cell in tentative else null
		if piece.color == side:
			continue
		if king_cell in piece.get_valid_moves(tentative):
			return false
	return true	
	
func _on_piece_selected(piece:Piece):	
	var moves=piece.get_valid_moves(pieces)
	print("adding highlight for moves %s" % [moves])
	for move in moves:
		var h = highlightScene.instantiate()
		$highlights.add_child(h)
		h.position  = map_to_local(move)
		

func _on_piece_unselected(_piece:Piece):
	while $highlights.get_child_count()>0:
		$highlights.remove_child($highlights.get_child(0))
	
		
func create_board():
	var draw_black := true
	for y in range(8):
		draw_black = not draw_black
		for x in range(8):
			var source_id = DARK_SQUARE_ID if draw_black else LIGHT_SQUARE_ID
			print("cell %s = %d" % [Vector2i(x,y), source_id])
			set_cell(0,Vector2i(x,y),source_id, Vector2i.ZERO)
			draw_black = not draw_black

	add_pawns(6, Types.PieceColor.WHITE)
	add_pawns(1, Types.PieceColor.BLACK)
	add_back_rank(7,Types.PieceColor.WHITE)
	add_back_rank(0,Types.PieceColor.BLACK)

func add_piece(pieceScene:PackedScene, cell:Vector2i, piece_color:Types.PieceColor)->void:
	var piece:=pieceScene.instantiate()
	piece.color = piece_color
	add_child(piece)
	piece.board_position=Position.from_cell(cell)
	piece.position = map_to_local(cell)
	pieces[cell]=piece
#	var cell_data = get_cell_tile_data(0,cell)
#	cell_data.set_custom_data("",piece)	

func add_back_rank(y:int, piece_color:Types.PieceColor)->void:
	add_piece(rookScene, Vector2i(0,y), piece_color)
	add_piece(knightScene, Vector2i(1,y), piece_color)
	add_piece(bishopScene, Vector2i(2,y), piece_color)
	add_piece(queenScene, Vector2i(3,y), piece_color)
	add_piece(kingScene, Vector2i(4,y), piece_color)
	add_piece(bishopScene, Vector2i(5,y), piece_color)
	add_piece(knightScene, Vector2i(6,y), piece_color)
	add_piece(rookScene, Vector2i(7,y), piece_color)

func add_pawns(y:int, piece_color:Types.PieceColor)->void:
	for x in range(8):
		add_piece(pawnScene, Vector2i(x,y), piece_color)
		
func get_piece_on_cell(cell:Vector2i)->Piece:
	if cell in pieces:
		return pieces[cell]
	else:
		return null
		
func to_start():
	restore_board(0)
	
func to_end():
	restore_board(history.size()-1)
	
func back():
	if history_idx>0:
		restore_board(history_idx - 1)

func forward():
	if history_idx< history.size()-1:
		restore_board(history_idx + 1)
	
func restore_board(idx:int):
	history_idx=idx
	for cell in pieces.keys():
		var piece = pieces[cell]
		pieces.erase(cell)
		piece.queue_free()
	
	for cell in history[idx].snapshot:
		var marker:PieceMarker = history[idx].snapshot[cell]
		var piece:Piece = marker.create_piece()
		piece.board_position=Position.from_cell(cell)
		pieces[cell] = piece
		piece.visible=false
		if idx==history.size()-1 and piece.color == side:
			piece.active=true
		add_child(piece)
		piece.position = map_to_local(piece.board_position.cell)
		piece.visible=true		
	Events.board_changed.emit(history.slice(0,history_idx+1))
	Logger.info ("restored %s" % history[idx])
			
func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_left"):
		back()
	if Input.is_action_just_pressed("ui_right"):
		forward()
