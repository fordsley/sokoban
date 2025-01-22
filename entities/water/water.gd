@tool
class_name Water extends Node3D

@onready var mesh: MeshInstance3D = $Mesh
@onready var area_hazard: AreaHazard = $AreaHazard

@export var size = Vector2i(1, 1):
	set(val):
		size = val
		if area_hazard:
			area_hazard.size = size

		if mesh:
			var quad = mesh.mesh as QuadMesh
			quad.size = size
			quad.subdivide_width = size.x * 10
			quad.subdivide_depth = size.y * 10


func _ready() -> void:
	size = size
