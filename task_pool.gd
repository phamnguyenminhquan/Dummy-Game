extends Resource
class_name  TaskPool

@export var tasks: Array[Task] = []

func get_random_task() -> Task:
	return tasks[randi() % tasks.size()]
