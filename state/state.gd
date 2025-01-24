class_name State extends Resource

@export var entities: Array[EntityDef]

var wall_tiles: Array[Vector2i]
var area_hazards: Array[Rect2i]


func is_wall(tile: Vector2i) -> bool:
	return wall_tiles.has(tile)


func is_hazard(tile: Vector2i) -> bool:
	if get_entities_at_tile(tile).any(func (e: EntityDef): return e.get_attr(WalkableAttr)):
		return false
	return area_hazards.any(func (r: Rect2i): return r.has_point(tile))


func get_entities_at_tile(tile: Vector2i) -> Array[EntityDef]:
	return entities.filter(func(e: EntityDef): return e.tile == tile)


func try_move(entity_to_move: EntityDef, translation: Vector2i):
	var test_tile = entity_to_move.tile + translation
	if is_wall(test_tile) or is_hazard(test_tile): return

	for other in get_entities_at_tile(test_tile):
		for child in other.attrs:
			if child is PushableAttr:
				var pushable_test_tile = other.tile + translation
				if is_wall(pushable_test_tile):
					return
				var entities_at_tile = get_entities_at_tile(pushable_test_tile)
				if entities_at_tile.size() && !entities_at_tile.any(func (e: EntityDef): return e.get_attr(WalkableAttr)):
					return
				other.tile = pushable_test_tile
				if is_hazard(pushable_test_tile):
					other.del_attr(Movable)
					other.attrs.append_array([SunkAttr.new(), WalkableAttr.new()])

			elif child is LockableAttr:
				if child.locked:
					var unlocker = InventoryAttr.get_item(entity_to_move, UnlockerAttr)
					if unlocker is Unlocker:
						unlocker.used = true
						child.locked = false
				if child.locked:
					return

			elif child is CollectibleAttr:
				var inventory = entity_to_move.get_attr(InventoryAttr)
				if inventory is InventoryAttr:
					if inventory.add_if_room(child):
						entities.erase(child)

	entity_to_move.tile = test_tile
	changed.emit()
