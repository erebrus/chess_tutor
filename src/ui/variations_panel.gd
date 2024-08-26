extends Panel

const ItemScene:PackedScene = preload("res://src/ui/variation_entry.tscn")
@onready var variation_list: VBoxContainer = %VariationList
@onready var current_variation_text: Label = %CurrentVariation
@onready var variation_name: TextEdit = %VariationName
@onready var comments_edit: TextEdit = %CommentsEdit

@export var file_dialog:FileDialog

var root_variation:Variation = Variation.new()
var current_variation:Variation = root_variation

func _ready() -> void:
	assert(file_dialog)
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
	_update_current_variation_ui(true)
	Events.variation_requested.emit(current_variation)
	
func update_current(entry:HistoryEntry):
	current_variation.history.append(entry)
	_update_current_variation_ui()

func _on_create_button_pressed() -> void:
	current_variation = Variation.create_new("", current_variation)
	add_variation_to_panel(current_variation)
	_update_current_variation_ui(true)

	

func _on_delete_button_pressed() -> void:
		
	var parent_variation = current_variation.parent
	if parent_variation ==null:
		Logger.warn("Can't remove root variation")
	var entry_to_remove
	for ve in variation_list.get_children():
		if ve.variation == current_variation:
			entry_to_remove = ve
			ve.variation.parent.children.erase(ve.variation)
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
	get_current_entry().update_ui()
	
func get_current_entry()->VariationEntry:
	for child in variation_list.get_children():
		if child.variation == current_variation:
			return child
			
	return null


func _update_current_variation_ui(edit:=false):
	current_variation_text.text = "Current Variation: %s" % current_variation.to_notation(true)
	variation_name.text = current_variation.name
	if edit:
		comments_edit.text = current_variation.comments


func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("save"):
		open_file_dialog(FileDialog.FileMode.FILE_MODE_SAVE_FILE)
	if Input.is_action_just_pressed("load"):
		open_file_dialog(FileDialog.FileMode.FILE_MODE_OPEN_FILE)

func open_file_dialog(mode:FileDialog.FileMode):
	file_dialog.file_mode = mode
	file_dialog.popup()
	
func save(path):
	#var ok=ResourceFormatSaver._recognize(root_variation)
	var result = ResourceSaver.save(root_variation, path)
	Logger.info("save result. %s" % result)
	
	
func load_save(path):
	root_variation = ResourceLoader.load(path) as Variation
	while variation_list.get_child_count():
		var child = variation_list.get_child(0)
		variation_list.remove_child(child)
		child.queue_free()
		
	current_variation=root_variation
	root_variation.verify_parenthood()
	add_variation_to_panel(root_variation, false)
	for v in current_variation.get_all_variations():
		add_variation_to_panel(v, false)
	variation_list.get_child(0).select()
	

func _on_file_dialog_file_selected(path: String) -> void:
	Logger.info("File selected:%s" % path)
	if file_dialog.file_mode == FileDialog.FileMode.FILE_MODE_OPEN_FILE:
		load_save(path)
	else:
		save(path)


func _on_comments_edit_text_changed() -> void:
	current_variation.comments=comments_edit.text
	_update_current_variation_ui(false)
