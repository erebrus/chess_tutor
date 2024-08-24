extends Node

signal piece_selected(piece:Piece)
signal piece_unselected(piece:Piece)
signal piece_move_requested(piece:Piece, pos:Vector2)
signal piece_taken(piece:Piece)

signal move_successful(piece:Piece)
signal move_failed(piece:Piece)
signal turn_changed(side:Types.PieceColor)
