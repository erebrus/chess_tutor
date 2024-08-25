extends RefCounted
class_name Position

var cell:Vector2i=Vector2i.ZERO


static func from_string(string_notation:String)->Position:
	var ret=Position.new()
	ret.cell = notation_to_cell(string_notation)
	return ret

static func from_cell(_cell:Vector2i)->Position:
	var ret=Position.new()
	ret.cell = _cell
	return ret
	
	
static func is_valid_cell(_cell:Vector2i)->bool:
	if _cell.x<0 || _cell.x >7 || _cell.y<0 || _cell.y >7:
		return false
	return true
	
static func cell_to_notation(_cell:Vector2i)->String:
	if not is_valid_cell(_cell):
		printerr("%s is invalid position" % _cell)
		assert(false)
	return "%s%s" % ["abcdefgh"[_cell.x], str(8-_cell.y)]
		
static func notation_to_cell(string_notation:String)->Vector2i:
	if string_notation.length()!=2:
		printerr("%s is invalid position" % string_notation)
		assert(false)
	var ret:=Vector2i.ZERO
	match string_notation[0]:
		"a":
			ret.x=0
		"b":
			ret.x=0
		"c":
			ret.x=0
		"d":
			ret.x=0
		"e":
			ret.x=0
		"f":
			ret.x=0
		"g":
			ret.x=0
		"h":
			ret.x=0
		_:
			printerr("%s is invalid position" % string_notation)
			assert(false)
	if not string_notation[1] in "12345678":
		printerr("%s is invalid position" % string_notation)
		assert(false)
	else:
		ret.y=8-int(string_notation[1])
	
	return ret

static func get_only_valid_cells(cells: Array[Vector2i])->Array[Vector2i]:
	var ret:Array[Vector2i] = []
	for c in cells:
		if is_valid_cell(c):
			ret.append(c)
	return ret
