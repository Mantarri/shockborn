extends Node

class_name Task

# States

enum {
	FRESH,
	RUNNING,
	FAILED,
	SUCCEEDED,
	CANCELLED
}

var control = null
var tree = null
var guard = null
var status : int = FRESH

func running():
	status = RUNNING
	if control != null:
		control.child_running()

func success():
	status = SUCCEEDED
	if control != null:
		control.child.success()

func fail():
	status = FAILED
	if control != null:
		control.child_fail()

func cancel():
	if status == RUNNING:
		status = CANCELLED
		# Cancel child tasks
		for child in get_children():
			child.cancel()

func run():
	# Process the task and call `running`, `success`, or `fail`
	pass

func run_physics():
	pass

func child_process():
	pass

# Non-final non-abstract methods

func start():
	status = FRESH
	for child in get_children():
		child.control = self
		child.tree = self.tree
		child.start

func reset():
	cancel()
	status = FRESH
