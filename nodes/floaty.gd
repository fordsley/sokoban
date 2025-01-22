class_name Floaty extends Node

@export var target: Node3D
@export var rotation_speed = -0.7
@export var bob_speed = 1.5
@export var bob_magnitude = 0.3

func _process(delta: float) -> void:
	target.rotation.y += delta * rotation_speed
	if target.rotation_degrees.y > 360:
		target.rotation_degrees.y -= 360
	target.position.y = sin(Time.get_ticks_msec() / 1000.0 * bob_speed) * bob_magnitude
