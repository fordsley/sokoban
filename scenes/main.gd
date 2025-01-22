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
