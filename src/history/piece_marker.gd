class_name PieceMarker extends Resource

@export var color: Types.PieceColor
@export var piece: Types.PieceType

const PieceScenes={
	Types.PieceType.PAWN: preload("res://src/pieces/pawn.tscn"),
	Types.PieceType.KNIGHT: preload("res://src/pieces/knight.tscn"),
	Types.PieceType.BISHOP: preload("res://src/pieces/bishop.tscn"),
	Types.PieceType.ROOK: preload("res://src/pieces/rook.tscn"),
	Types.PieceType.QUEEN: preload("res://src/pieces/queen.tscn"),
	Types.PieceType.KING:  preload("res://src/pieces/king.tscn")
}


static func create(_piece:Types.PieceType, _color:Types.PieceColor):
	var ret:= PieceMarker.new()
	ret.color = _color
	ret.piece = _piece
	return ret
	
func _to_string() -> String:
	return "%s %s" % ["WHITE" if color == Types.PieceColor.WHITE else "BLACK", Types.PieceType.keys()[piece]] 
	
func create_piece()->Piece:
	var scene:Piece = PieceScenes[piece].instantiate()
	scene.color = color
	return scene
