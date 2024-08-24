extends Area2D
class_name Piece

@export var white:Texture 
@export var black:Texture 


var dragging := false
var mouse_over := false
var original_position:Vector2
var board_position:Position
var color:Types.PieceColor = Types.PieceColor.WHITE

var moved:=false

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2D
	sprite.texture = white if color == Types.PieceColor.WHITE else black
	assert(sprite.texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if mouse_over and \
			not dragging and \
			event.pressed and \
			event.button_index == MOUSE_BUTTON_LEFT:
				_start_drag()
		elif dragging and \
			not event.pressed and \
			event.button_index == MOUSE_BUTTON_LEFT:
				_stop_drag()
	if dragging and event is InputEventMouseMotion:
		global_position = get_global_mouse_position()
func _start_drag():
	dragging = true
	original_position = global_position
	global_position = get_global_mouse_position()
	Events.piece_selected.emit(self)
	
func _stop_drag():
	dragging = false
	global_position = original_position
	Events.piece_unselected.emit(self)
	

func get_valid_moves(board:Board)->Array:
	return []
	
func move_to(_position:Position)->void:
	moved=true
	pass

func add_if_valid_move_or_take(board:Board, cell:Vector2i, all_moves:Array)->bool:
	var piece_on_cell:=board.get_piece_on_cell(cell)
	if not Position.is_valid_cell(cell):
		return true
	elif piece_on_cell != null:
		if  piece_on_cell.color != color:
			all_moves.append(cell)
		return true
	else:		
		all_moves.append(cell)	
		return false
