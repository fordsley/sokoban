class_name PlayerDef extends EntityDef

var facing := Vector2i.DOWN

func _init() -> void:
	attrs = [
		ControllableAttr.new(),
		InventoryAttr.new(),
	]
