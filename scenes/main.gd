extends Node3D

@onready var character: Node3D = $Character
@onready var map: Map = $ExampleMap

var character_speed = 0.2


func _input(event: InputEvent) -> void:
	var character_tile = Map.v3_to_tile(character.position)
	var translation = get_input_translation(event)
	if translation is not Vector2i: return

	var test_tile = character_tile + translation
	if map.is_wall(test_tile) or map.is_hazard(test_tile): return

	var entities = map.get_entities_at_tile(test_tile)
	for entity in entities:
		var movable = NodeUtil.get_trait(entity, Movable)
		if movable:
			var movable_test_tile = Map.v3_to_tile(entity.position) + translation
			if map.is_wall(movable_test_tile):
				return
			var entities_at_tile = map.get_entities_at_tile(movable_test_tile)
			if entities_at_tile.size() && !entities_at_tile.any(func (e): return NodeUtil.get_trait(e, Walkable)):
				return
			var tween_movable = create_tween()
			var new_position = Map.tile_to_v3(movable_test_tile)
			tween_movable.set_ease(Tween.EASE_OUT)
			tween_movable.set_trans(Tween.TRANS_CUBIC)
			tween_movable.tween_property(entity, "global_position", new_position, character_speed)
			if map.is_hazard(movable_test_tile):
				tween_movable.tween_property(entity, "global_position", new_position + Vector3(0, -1, 0), character_speed)
				entity.remove_child(movable)
				movable.queue_free()
				var walkable = Walkable.new()
				entity.add_child(walkable)
			break

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(character, "global_position", Map.tile_to_v3(test_tile), character_speed)
	character.rotation.y = -atan2(translation.y, translation.x) + deg_to_rad(90)


func get_input_translation(event: InputEvent):
	if event.is_action_pressed("up"):
		return Vector2i.UP
	if event.is_action_pressed("right"):
		return Vector2i.RIGHT
	if event.is_action_pressed("down"):
		return Vector2i.DOWN
	if event.is_action_pressed("left"):
		return Vector2i.LEFT
	return null
