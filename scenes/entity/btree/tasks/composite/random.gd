extends Task

# One random chosen child must Succeed

class_name RandomSelector

var sequence : Array
var idx : int = 0

func _ready():
	set_sequence()

func set_sequence():
	idx = 0
	sequence = range(get_child_count())
	sequence.shuffle()

func run():
	get_child(sequence[idx]).run()
	running()

func child_success():
	set_sequence()
	success()

func child_fail():
	idx += 1
	if idx >= sequence.size():
		set_sequence()
		fail()
