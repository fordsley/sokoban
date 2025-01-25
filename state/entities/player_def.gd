class_name PlayerDef extends EntityDef

var facing := Vector2i.DOWN

func reset() -> void:
	attrs = [
		InventoryAttr.new(),
	]
