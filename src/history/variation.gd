class_name Variation extends Resource

@export var name:String = ""
@export var history:Array = []
@export var parent:Variation
@export var children:Array[Variation]=[]


func _to_string() -> String:
	return "%s: %s" % [name, to_notation()]
	
#func add_move(entry:HistoryEntry):
	#history.append(entry)

func get_full_history()->Array:
	if not parent:
		return history
	var ret=[]
	ret.append_array(parent.get_full_history())
	ret.append_array(history)
	return ret

func get_all_variations():
	var ret=[]	
	for child in children:
		ret.append(child)
		ret.append_array(child.get_all_variations())
	return ret
	
func to_notation(include_all:=false)->String:
	var str="" if (not include_all or not parent) else parent.to_notation()
	for entry in history:
		if entry.move<1:
			continue
		str += (entry as HistoryEntry).to_move_notation()+" "
	return str

static func create_new(name:String, parent:Variation)->Variation:
	var ret := Variation.new()
	ret.name = name
	ret.parent = parent
	ret.history = []
	if parent:
		parent.children.append(ret)
	return ret
