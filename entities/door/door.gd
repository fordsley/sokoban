class_name Door extends Node3D

@onready var lockable: Lockable = $Lockable
@onready var hinge: Node3D = $Hinge
@onready var lock: Node3D = $Hinge/Gate/Lock

func _ready() -> void:
	lockable.changed.connect(func ():
		hinge.rotation_degrees.y = 0 if lockable.locked else 90
		lock.visible = lockable.locked
	)
