extends TaskViopa

# Scan with given method for `Viopa` entities and choose given `Task(s)`
# based on the result

class_name ViopaScan

export(NodePath) var scanTaskPath
var scanTask : TaskViopa

func _ready():
	if !scanTask == null:
		scanTask = get_node(scanTaskPath)

func run():
	if !scanTask == null:
		scanTask.run()
		running()

func child_success():
	success()


func child_fail():
	fail()
