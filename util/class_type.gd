class_name ClassType

static func get_class_name(o: Object) -> String:
	var s = o.get_script()
	if s is Script: return s.get_global_name()
	return o.get_class()
