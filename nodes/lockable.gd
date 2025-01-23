class_name Lockable extends Node

signal changed

@export var locked = true:
	set(val):
		locked = val
		changed.emit()
