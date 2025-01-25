extends Node3D

var state := State.new()
@onready var example_map: Map = $ExampleMap

func _ready() -> void:
	state.entities = example_map.initial_entities # TODO: This probably needs to be duplicated recursively
	for e in state.entities: e.reset()
	state.area_hazards = example_map.get_area_hazards()
	state.wall_tiles = example_map.get_wall_tiles()
	example_map.state = state
	example_map.update()
	state.changed.connect(example_map.update)
