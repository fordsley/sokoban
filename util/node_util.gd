class_name NodeUtil

static func get_trait(parent: Node, Type: Script):
	for child in parent.get_children():
		if child.get_script() == Type:
			return child


static func remove_trait(parent: Node, Type: Script):
	var t = get_trait(parent, Type)
	if t:
		parent.remove_child(t)
		t.queue_free()
