class_name EntityDef extends Resource

@export var tile: Vector2i
@export var attrs: Array[Attr]

var id: String = _get_id()

static var _counter := 0


func _get_id() -> String:
	_counter += 1
	return ''.join([ClassType.get_class_name(self), str(_counter)])


func reset():
	pass


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
