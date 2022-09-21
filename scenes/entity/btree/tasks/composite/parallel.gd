extends Task

# Run all child tasks together in SEQUENCE or SELECTOR policy mode

class_name Parallel

enum {SEQUENCE, SELECTOR}

export(bool) var policy = SEQUENCE

var numResults : int = 0

func run():
	for child in get_children():
		child.run()
	running()

func child_success():
	numResults += 1
	if policy == bool(SEQUENCE):
		if numResults >= get_child_count():
			numResults = 0
			success()
	else:
		success()


func child_fail():
	numResults += 1
	if policy == bool(SELECTOR):
		if numResults >= get_child_count():
			numResults = 0
			fail()
	else:
		fail()
