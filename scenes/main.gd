extends Node3D

@onready var character: Character = $Character
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
	character.get_child(0).rotation.y = -atan2(translation.y, translation.x) + PI / 2
	character.animation_player.play("sprint", -1, 2.0)
	character.animation_player.seek(0.25)
	character.animation_player.queue("idle")
	
	var collectibles = entities.filter(func (e): return NodeUtil.get_trait(e, Collectible))
	for c in collectibles:
		NodeUtil.remove_trait(c, Floaty)
		var c_tween = create_tween()
		c_tween.set_parallel(true)
		c_tween.set_ease(Tween.EASE_OUT)
		c_tween.set_trans(Tween.TRANS_CUBIC)
		c_tween.tween_property(c.get_child(0), "rotation_degrees:y", 0, character_speed / 2).set_delay(character_speed / 2)
		c_tween.tween_property(c.get_child(0), "position", Vector3.ZERO, character_speed / 2).set_delay(character_speed / 2)
		c_tween.tween_property(c, "global_position", c.global_position + Vector3.UP, character_speed / 2).set_delay(character_speed / 2)
		c_tween.set_parallel(false)
		c_tween.tween_callback(func (): c.reparent(character))


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
