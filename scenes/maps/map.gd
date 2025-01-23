class_name Map extends Node3D

@onready var wall_group: Node = $WallGroup
@onready var hazard_group: Node = $HazardGroup
@onready var entity_group: Node = $EntityGroup

var _wall_tiles: Array[Vector2i]
var _area_hazards: Array[Rect2i]


static func tile_to_v3(tile: Vector2i) -> Vector3:
	return Vector3(tile.x, 0, tile.y)


static func v3_to_tile(v3: Vector3) -> Vector2i:
	return Vector2i(round(v3.x), round(v3.z))


func _ready() -> void:
	var walls = wall_group.get_children()
	_wall_tiles.assign(walls.map(func (w: Node3D): return v3_to_tile(w.position)))

	var hazards = hazard_group.get_children()
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
				_area_hazards.append(rect)


func is_wall(tile: Vector2i) -> bool:
	return _wall_tiles.has(tile)


func is_hazard(tile: Vector2i) -> bool:
	if get_entities_at_tile(tile).any(func (e: Node): return NodeUtil.get_trait(e, Walkable)):
		return false
	return _area_hazards.any(func (r: Rect2i): return r.has_point(tile))


func get_entities_at_tile(tile: Vector2i) -> Array[Node]:
	return entity_group.get_children().filter(func (e: Node3D): return v3_to_tile(e.position) == tile)
