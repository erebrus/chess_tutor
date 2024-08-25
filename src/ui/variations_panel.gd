extends Panel

const ItemScene:PackedScene = preload("res://src/history/variation_entry.tscn")
@onready var variation_list: VBoxContainer = %VariationList
@onready var current_variation_text: Label = %CurrentVariation
@onready var variation_name: TextEdit = %VariationName

var root_variation:Variation = Variation.new()
var current_variation:Variation = root_variation

func _ready() -> void:
	Events.move_added.connect(update_current)
	Events.variation_selected.connect(_on_variation_selected)
	add_variation_to_panel(current_variation,false)
	variation_list.get_child(0)._on_variation_selected(current_variation)
	variation_list.get_child(0).update_ui()

func add_variation_to_panel(_variation:Variation, select:=true):
	var scene:= ItemScene.instantiate() as VariationEntry
	scene.variation=_variation
	variation_list.add_child(scene)
	if select:
		scene.select()
	
func _on_variation_selected(variation:Variation):
	current_variation=variation
	_update_current_variation_ui()
	Events.variation_requested.emit(current_variation)
	
func update_current(entry:HistoryEntry):
	current_variation.history.append(entry)
	_update_current_variation_ui()

func _on_create_button_pressed() -> void:
	current_variation = Variation.create_new("", current_variation)
	add_variation_to_panel(current_variation)
	_update_current_variation_ui()

	

func _on_delete_button_pressed() -> void:
		
	var parent_variation = current_variation.parent
	if parent_variation ==null:
		Logger.warn("Can't remove root variation")
	var entry_to_remove
	for ve in variation_list.get_children():
		if ve.variation == current_variation:
			entry_to_remove = ve
			break
	variation_list.remove_child(entry_to_remove)
	entry_to_remove.queue_free()

	current_variation=parent_variation
	select_variation_from_list(parent_variation)

	
	
func select_variation_from_list(variation:Variation):
	for ve in variation_list.get_children():
		if ve.variation == variation:
			ve.select()


func _on_variation_name_focus_exited() -> void:
	current_variation.name = variation_name.text


func _on_variation_name_text_changed() -> void:
	current_variation.name = variation_name.text

func _update_current_variation_ui():
	current_variation_text.text = current_variation.to_notation()
	variation_name.text = current_variation.name
