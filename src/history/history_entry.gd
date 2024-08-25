class_name HistoryEntry extends Resource

@export var snapshot={}
@export var move:int=1
@export var origin_cell:Vector2i
@export var target_cell:Vector2i
@export var piece:PieceMarker
@export var taken:PieceMarker



static func create_from_board(pieces:Dictionary, _move:int, piece:Piece, _origin_cell:Vector2i, _taken:Piece=null):
	var ret = HistoryEntry.new()
	ret.move = _move
	if piece !=null:
		ret.origin_cell = _origin_cell
		ret.target_cell =  piece.board_position.cell
		ret.piece = PieceMarker.create(get_type_from_piece(piece), piece.color)
		
		ret.taken = null if _taken == null else PieceMarker.create(get_type_from_piece(_taken), _taken.color) 
	for cell in pieces:
		var _piece = pieces[cell]
		var marker :PieceMarker= PieceMarker.create(get_type_from_piece(_piece), _piece.color)
		ret.snapshot [cell] = marker
	Logger.info("Created entry: %s" % ret)
	return ret
	
static func get_type_from_piece(piece:Piece)->Types.PieceType:
	if piece is King:
		return Types.PieceType.KING
	elif piece is Queen:
		return Types.PieceType.QUEEN
	elif piece is Rook:
		return Types.PieceType.ROOK
	elif piece is Knight:
		return Types.PieceType.KNIGHT
	elif piece is Bishop:
		return Types.PieceType.BISHOP
	else:
		return Types.PieceType.PAWN


func _to_string() -> String:
	return "%d - %s %s -> %s (%s)" % [move, piece, Position.cell_to_notation(origin_cell) , Position.cell_to_notation(target_cell), taken]

func piece_code(piece: Types.PieceType)-> String:
	if piece == Types.PieceType.PAWN:
		return ""
	return Types.PieceType.keys()[piece].left(1).to_lower()
func to_move_notation() -> String:
	if not piece:
		return ""
	if taken:
		return "%d. %s%sx%s" % [move,piece_code(piece.piece),Position.cell_to_notation(origin_cell), Position.cell_to_notation(target_cell)]
	else:
		return "%d. %s%s" % [move,piece_code(piece.piece), Position.cell_to_notation(target_cell)]
#func get_snapshot_str()-> String:
	#for 
