class_name NodeUtil


static func get_trait(parent: Node, Type: Script):
	for node in parent.get_children():
		if is_instance_of(node, Type):
			return node


static func remove_trait(parent: Node, Type: Script):
	var t = get_trait(parent, Type)
	if t:
		parent.remove_child(t)
		t.queue_free()
