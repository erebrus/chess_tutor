class_name VariationEntry extends Label

const SELECTED_COLOR:Color = Color.DARK_GREEN

var variation:Variation:
	set(v):
		variation=v
		update_ui()

var has_mouse:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.variation_selected.connect(_on_variation_selected)
	Events.move_added.connect(_on_move_added)
	
func _on_move_added(entry:HistoryEntry):
	#TODO check sanity
	#variation.add_move(entry)
	update_ui()
	
func update_ui():
	text=variation.to_notation(true)
	
func _on_variation_selected(_variation: Variation):
	if _variation==variation:
		set("theme_override_colors/font_color", SELECTED_COLOR)
	else:
		set("theme_override_colors/font_color", Color.WHITE)

func _on_mouse_entered() -> void:
	has_mouse = true


func _on_mouse_exited() -> void:
	has_mouse=false


func _on_gui_input(event: InputEvent) -> void:
	if has_mouse and event is InputEventMouseButton:
		var mouse_event:= event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			select()
			
func select():
	Events.variation_selected.emit(variation)
			
