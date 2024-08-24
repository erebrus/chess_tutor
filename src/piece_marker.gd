class_name PieceMarker extends Resource

@export var color: Types.PieceColor
@export var piece: Types.PieceType


static func create(_piece:Types.PieceType, _color:Types.PieceColor):
	var ret:= PieceMarker.new()
	ret.color = _color
	ret.piece = _piece
	return ret
	
func _to_string() -> String:
	return "%s %s" % ["WHITE" if color == Types.PieceColor.WHITE else "BLACK", Types.PieceType.keys()[piece]] 
	
func create_piece()->Piece:
	var scene:Piece = Types.PIECE_SCENES[piece].instantiate()
	scene.color = color
	return scene
