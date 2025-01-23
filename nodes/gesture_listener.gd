class_name GestureListener extends Node

var swipe_start: InputEventMouseButton
var minimum_drag = 72

signal swipe(e: InputEventMouseButton)
signal tap(e: InputEventMouseButton)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("mouse1"):
			swipe_start = event
		if event.is_action_released("mouse1"):
			if event.position.distance_to(swipe_start.position) >= minimum_drag:
				swipe.emit(event)
			else:
				tap.emit(event)
