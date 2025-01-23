class_name Unlocker extends Node

var used = false:
	set(val):
		used = val
		var parent = get_parent()
		if parent is Node3D:
			parent.visible = !used
