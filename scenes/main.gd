extends Node3D

@export var state: State
@onready var example_map: Map = $ExampleMap

func _ready() -> void:
	example_map.state = state
