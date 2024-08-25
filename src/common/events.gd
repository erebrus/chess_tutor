extends Node

signal piece_selected(piece:Piece)
signal piece_unselected(piece:Piece)
signal piece_move_requested(piece:Piece, pos:Vector2)
signal piece_taken(piece:Piece)

signal move_successful(piece:Piece)
signal move_failed(piece:Piece)
signal turn_changed(side:Types.PieceColor)

signal move_added(entry:HistoryEntry)
signal board_changed(history:Array)

signal move_to_start_requested()
signal move_back_requested()
signal move_forward_requested()
signal move_to_end_requested()

signal variation_requested(variation:Variation)
signal variation_selected(variation:Variation)
