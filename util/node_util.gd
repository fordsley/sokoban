class_name NodeUtil

static func get_trait(parent: Node, Type: Script):
	for child in parent.get_children():
		if child.get_script() == Type:
			return child
