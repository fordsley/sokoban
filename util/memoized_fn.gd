class_name MemoizedFn

var inner_fn: Callable

var _last_arg: Variant
var _last_res: Variant


static func create(fn_to_memoize: Callable) -> MemoizedFn:
	var mf = MemoizedFn.new()
	mf.inner_fn = fn_to_memoize
	return mf


func fn(arg: Variant) -> Variant:
	if arg == _last_arg:
		return _last_res

	var res = inner_fn.call(arg)
	_last_arg = arg
	_last_res = res

	return res
