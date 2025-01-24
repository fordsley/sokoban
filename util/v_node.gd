class_name VNode

var type: Object
var id: String
var updater: Callable


static func _spawn_new(v_child: VNode, parent: Node):
	var type_ = v_child.type
	var child = type_.instantiate() if type_ is PackedScene else type_.new()
	parent.add_child(child)
	child.name = v_child.id
	if v_child.updater:
		v_child.updater.call(child)
	return child


static func create(type_: Object, id_: String, updater_ = null) -> VNode:
	var v_node = VNode.new()
	v_node.type = type_
	v_node.updater = updater_
	v_node.id = id_
	return v_node


static func reconcile(parent: Node, v_nodes: Array[VNode]):
	var children = parent.get_children()
	for i in maxi(children.size(), v_nodes.size()):
		var child: Node = children[i] if i < children.size() else null
		var v_child: VNode = v_nodes[i] if i < v_nodes.size() else null

		#region Remove node
		if !v_child:
			if child:
				parent.remove_child(child)
				child.queue_free() # TODO: Don't queue_free until we're all done rendering (it may have gotten reparented)
			continue
		#endregion

		#region Add node
		# Nothing at that position
		if !child:
			child = _spawn_new(v_child, parent)

		# The thing at that position isn't reconcilable with the incoming node
		elif (v_child.id != child.name):
			parent.remove_child(child)
			child.queue_free() # TODO: Don't queue_free until we're all done rendering (it may have gotten reparented)
			child = _spawn_new(v_child, parent)
			parent.move_child(child, i)
		#endregion

		#region Update node
		# Update the existing node with the incoming node's props
		else:
			if v_child.updater:
				v_child.updater.call(child)
		#endregion
