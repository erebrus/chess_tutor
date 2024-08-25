extends Panel

const entry_scene:PackedScene = preload("res://src/ui/move_entry.tscn")

func _ready() -> void:
	Events.board_changed.connect(update_list)
	
func update_list(history:Array):
	while %MoveTable.get_child_count():
		var child = %MoveTable.get_child(0)
		%MoveTable.remove_child(child)
		child.queue_free()
	for entry in history:
		if entry.move < 1:
			continue
		%MoveTable.add_child(_create_entry(entry))
	
func _create_entry(entry:HistoryEntry):
		var ret = entry_scene.instantiate()
		ret.text= entry.to_move_notation()
		return ret


func _on_start_button_pressed() -> void:
	Events.move_to_start_requested.emit()


func _on_back_button_pressed() -> void:
	Events.move_back_requested.emit()

func _on_forward_button_pressed() -> void:
	Events.move_forward_requested.emit()

func _on_end_button_pressed() -> void:
	Events.move_to_end_requested.emit()
