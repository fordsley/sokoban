class_name InventoryAttr extends Attr

var max_item_count = 1

var items: Array[EntityDef]


static func get_item(entity: EntityDef, desired_attr) -> Variant:
	for attr in entity.attrs:
		if attr is InventoryAttr:
			for item in attr.items:
				if is_instance_of(entity, desired_attr):
					return item
	return null


func add_if_room(entity: EntityDef) -> bool:
	if items.size() < max_item_count:
		items.append(entity)
		return true
	return false
