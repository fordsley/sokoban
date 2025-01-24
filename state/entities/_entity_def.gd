class_name EntityDef extends Resource

@export var tile: Vector2i
@export var attrs: Array[Attr]

var id: String = _get_id()

static var _counter := 0


func _get_id() -> String:
	_counter += 1
	return ''.join([_get_name(), str(_counter)])


func _get_name() -> String:
	var s: Script = get_script()
	if s is Script:
		return s.get_global_name()
	return ''


func get_attr(attr: Script) -> Variant:
	for a in attrs:
		if is_instance_of(a, attr):
			return a
	return null


func del_attr(attr: Script):
	for a in attrs:
		if is_instance_of(a, attr):
			attrs.erase(a)
			return
