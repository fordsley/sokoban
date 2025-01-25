class_name Reconciler

var _cache: Dictionary
var fn: Callable


static func create(fn_: Callable) -> Reconciler:
	var r = Reconciler.new()
	r.fn = fn_
	return r


func reconcile(node: Node, data: Array):
	var existing_nodes = node.get_children()
	for i in data.size():
		var el = data[i]
		var new_node := fn.call(el) as Node
		var existing_index := existing_nodes.find(new_node, 0)
		if existing_index < 0:
			node.add_child(new_node)
		node.move_child(new_node, i)
		_cache[new_node.name] = new_node

	var new_children = node.get_children()
	var delta = new_children.size() - data.size()
	if delta > 0:
		for i in delta:
			node.remove_child(new_children[data.size() + i])


func get_or_create(type: Variant, name: String) -> Object:
	var node_in_cache = _cache.get(name)
	if node_in_cache:
		_cache.erase(name)
		return node_in_cache

	var new_node = type.instantiate() if type is PackedScene else type.new()
	new_node.name = name
	return new_node
