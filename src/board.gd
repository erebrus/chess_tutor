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

var mode:Types.PieceColor = Types.PieceColor.WHITE

var pieces := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.piece_selected.connect(_on_piece_selected)
	Events.piece_unselected.connect(_on_piece_unselected)
	create_board();
#	get_cell_tile_data(0, Vector2.ZERO).set_custom_data("piece")

func _on_piece_selected(piece:Piece):
	
	var moves=piece.get_valid_moves(self)
	print("adding highlight for moves %s" % [moves])
	for move in moves:
		var h = highlightScene.instantiate()
		$highlights.add_child(h)
		h.position  = map_to_local(move)
		

func _on_piece_unselected(piece:Piece):
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

	#add_pawns(6, Types.PieceColor.WHITE)
	#add_pawns(1, Types.PieceColor.BLACK)
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
	#add_piece(bishopScene, Vector2i(2,y), piece_color)
	#add_piece(queenScene, Vector2i(3,y), piece_color)
	add_piece(kingScene, Vector2i(4,y), piece_color)
	#add_piece(bishopScene, Vector2i(5,y), piece_color)
	#add_piece(knightScene, Vector2i(6,y), piece_color)
	add_piece(rookScene, Vector2i(7,y), piece_color)

func add_pawns(y:int, piece_color:Types.PieceColor)->void:
	for x in range(8):
		add_piece(pawnScene, Vector2i(x,y), piece_color)
		
func get_piece_on_cell(cell:Vector2i)->Piece:
	if cell in pieces:
		return pieces[cell]
	else:
		return null
		
