class_name FunctionQueue
extends Resource


var queue: Dictionary = {}  ## Used to store functions to be ran on the next player tick.


## Adds a function to the function queue, provided that it does not exceed the limit for that function.
func add_function(function: String, parameters: Array = [], limit: int = 1) -> bool:
	if queue.keys().count(function) < limit:
		queue[function] = parameters
		return true
	else:
		return false


## Performs functions added to the function queue within the last tick.
func call_functions(object: Object) -> void:
	for function in queue.keys():
		Callable(object, function).callv(queue[function])
		queue.erase(function)
