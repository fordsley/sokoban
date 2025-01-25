@tool
extends Node3D

func _ready() -> void:
	print('===', [sign(-3), sign(0), sign(3)])
	for i in -3:
		print('i: ', i)
	return
	for child in get_children():
		remove_child(child)
		child.queue_free()
	print('===cleanup complete')
	var names: Array[String] = ['node1', 'node2']
	child_order_changed.connect(func ():
		print('%s order changed')
	)
	for n in names:
		var node := Node.new()
		node.tree_entered.connect(func (): print('%s entered' % n))
		node.tree_exited.connect(func (): print('%s exited' % n))
		node.tree_exiting.connect(func (): print('%s exiting' % n))
		node.name = n
		add_child(node)
		node.owner = get_tree().edited_scene_root

	var node2 = get_child(0)
	move_child(node2, 0)
	move_child(node2, 0)
	move_child(node2, 0)
	move_child(node2, 0)
	move_child(node2, 0)
	move_child(node2, 0)
	move_child(node2, 0)
	move_child(node2, 0)
	print('===finished ready')
