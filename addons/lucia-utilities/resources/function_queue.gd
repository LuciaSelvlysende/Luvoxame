class_name FunctionQueue
extends Resource

## Utility resource that stores a list of functions to be called later.


var object: Object  ## The object that functions from [member queue] are called on.
var queue: Dictionary = {}  ## Used to store functions to be ran on the next tick.


## Creates a FunctionQueue resource that is ready to be used. FunctionQueues created with [method Object.new] will cause a crash if used without providing a value for [member object].
static func create(object) -> FunctionQueue:
	var function_queue: FunctionQueue = FunctionQueue.new()
	function_queue.object = object
	return function_queue


## Adds a function to the function queue, provided that it does not exceed the limit for that function.
func add_function(function: String, parameters: Array = [], limit: int = 1) -> bool:
	if queue.keys().count(function) < limit:
		queue[function] = parameters
		return true
	else:
		return false


## Performs functions added to the function queue within the last tick.
func call_functions() -> void:
	for function in queue.keys():
		Callable(object, function).callv(queue[function])
		queue.erase(function)
