class_name Map extends Node3D

@export var initial_entities: Array[EntityDef]

var state: State

var get_player_mf := MemoizedFn.create(func (s: State) -> EntityDef:
	for e in s.entities:
		if e is PlayerDef:
			return e
	return null
)

@onready var wall_group: Node = $WallGroup
@onready var hazard_group: Node = $HazardGroup
@onready var entity_group: Node = $EntityGroup
@onready var gesture_listener: GestureListener = $GestureListener


func _ready() -> void:
	gesture_listener.tap.connect(func (_e):
		var input_event = InputEventAction.new()
		input_event.action = "jump"
		input_event.pressed = true
		Input.parse_input_event(input_event)
	)
	gesture_listener.swipe.connect(func (e: InputEventMouseButton):
		var input_event = InputEventAction.new()
		var angle = gesture_listener.swipe_start.position.angle_to_point(e.position)
		var angle_snapped = int(rad_to_deg(snapped(angle, PI / 2)))
		match angle_snapped:
			-90: input_event.action = "up"
			0: input_event.action = "right"
			90: input_event.action = "down"
			-180, 180: input_event.action = "left"
		input_event.pressed = true
		Input.parse_input_event(input_event)
	)


func _input(event: InputEvent) -> void:
	var translation = get_input_translation(event)
	if translation is Vector2i:
		var player = get_player_mf.fn(state)
		state.try_move(player, translation)


func get_component(e: EntityDef):
	if e is CrateDef: return preload("res://entities/kenney_platformer/crate.glb")
	if e is KeyDef: return preload("res://entities/key/Key.tscn")
	if e is DoorDef: return preload("res://entities/door/door.tscn")
	if e is PlayerDef: return preload("res://entities/character/character.tscn")


func update():
	var v_nodes: Array[VNode]
	v_nodes.assign(state.entities.map(func (e: EntityDef):
		var type = get_component(e)
		if !type: return
		return VNode.create(type, e.id, func (n: Node3D):
			n.position = tile_to_v3(e.tile)
			if e is CrateDef:
				n.scale = Vector3(1.9, 1.9, 1.9)
			elif e is KeyDef:
				n.position.y += 0.5
		)
	))
	VNode.reconcile(entity_group, v_nodes)


func get_input_translation(event: InputEvent):
	if event.is_action_pressed("jump"):
		var player = get_player_mf.fn(state)
		return player.facing if PlayerDef else null
	if event.is_action_pressed("up"):
		return Vector2i.UP
	if event.is_action_pressed("right"):
		return Vector2i.RIGHT
	if event.is_action_pressed("down"):
		return Vector2i.DOWN
	if event.is_action_pressed("left"):
		return Vector2i.LEFT
	return null


func get_wall_tiles() -> Array[Vector2i]:
	var walls = wall_group.get_children()
	var wall_tiles: Array[Vector2i]
	wall_tiles.assign(walls.map(func (w: Node3D): return v3_to_tile(w.position)))
	return wall_tiles


func get_area_hazards() -> Array[Rect2i]:
	var hazards = hazard_group.get_children()
	var area_hazards: Array[Rect2i]
	for hazard in hazards:
		for child in hazard.get_children():
			if child is AreaHazard:
				var pos = (hazard as Node3D).position
				var rect = Rect2i(
					pos.x - child.size.x / 2,
					pos.y - child.size.y / 2,
					child.size.x,
					child.size.y,
				)
				area_hazards.append(rect)
	return area_hazards


static func tile_to_v3(tile: Vector2i) -> Vector3:
	return Vector3(tile.x, 0, tile.y)


static func v3_to_tile(v3: Vector3) -> Vector2i:
	return Vector2i(round(v3.x), round(v3.z))
