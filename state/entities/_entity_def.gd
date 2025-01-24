class_name EntityDef extends Resource

@export var tile: Vector2i

@export var attrs: Array[Attr]


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
