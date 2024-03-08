extends Node

var timedFunctions = {}

func createTimer(time: float, function: FuncRef, args: Array = [], repeat: bool = false):
	timedFunctions[function.to_string()] = {}

	timedFunctions[function.to_string()]["time"] = time
	timedFunctions[function.to_string()]["maxTime"] = time

	timedFunctions[function.to_string()]["function"] = function
	if args != [] or args != null:
		timedFunctions[function.to_string()]["args"] = args

	timedFunctions[function.to_string()]["repeat"] = repeat

func _process(delta):
	for subdict in timedFunctions.values():
		if subdict and subdict.get("time") <= 0:
			if subdict.get("args"):
				subdict.get("function").call_funcv(subdict.get("args"))
			else:
				subdict.get("function").call_func()

			if !subdict["repeat"]:
				timedFunctions.erase(subdict.get("function").to_string())

			subdict["time"] = subdict["maxTime"]
		elif subdict:
			subdict["time"] -= delta

