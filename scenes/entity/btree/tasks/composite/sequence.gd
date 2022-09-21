extends Task

# All child Tasks must run successfully to succeed

class_name Sequence

var currentChild : int = 0

func run():
	get_child(currentChild).run()
	running()

func child_success():
	currentChild += 1
	if currentChild >= get_child_count():
		currentChild = 0
		success()

func child_fail():
	currentChild = 0
	fail()
