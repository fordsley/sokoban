class_name Character extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var idle = animation_player.get_animation("idle")
	idle.loop_mode = Animation.LOOP_LINEAR
	animation_player.speed_scale = 0.5
