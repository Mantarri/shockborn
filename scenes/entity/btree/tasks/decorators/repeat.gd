extends Task

# Repeats the child Task, reporting Success after repating for the set number of times *successfully.*

class_name Repeat

export(int) var LIMIT = 3

var count : int = 0
var repeating : bool = false

func run():
	if not repeating:
		repeating = true
		get_child(0).run()
	running()

func child_success():
	if LIMIT > 0:
		count+= 1
		if count >= LIMIT:
			count = 0
			repeating = false
			success()
	if repeating:
		get_child(0).run()

func child_fail():
	repeating = false
	fail()
