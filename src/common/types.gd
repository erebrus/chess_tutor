extends Node

enum PieceColor {WHITE, BLACK}
enum Mode {PLAY, MOVE, FREE}
enum PieceType {PAWN, KNIGHT, BISHOP, ROOK, QUEEN, KING}

#var PieceScenes={
	#PieceType.PAWN: preload("res://src/pieces/pawn.tscn"),
	#PieceType.KNIGHT: preload("res://src/pieces/knight.tscn"),
	#PieceType.BISHOP: preload("res://src/pieces/bishop.tscn"),
	#PieceType.ROOK: preload("res://src/pieces/rook.tscn"),
	#PieceType.QUEEN: preload("res://src/pieces/queen.tscn"),
	#PieceType.KING:  preload("res://src/pieces/king.tscn")
#}
