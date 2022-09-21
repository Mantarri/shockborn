extends Task

# Choose child(ren) to process based on detected input

class_name MovementSelector

var numResults : int = 0

var selected : Task

export(Dictionary) var inputMap = {}

func _unhandled_input(event : InputEvent):
	if !event is InputEventMouse:
		for i in inputMap:
			if inputMap[i] is PoolStringArray:
				for j in inputMap[i]:
					if InputMap.event_is_action(event, j):
						selected = get_node(i)
			else:
				if InputMap.event_is_action(event, inputMap[i]):
					selected = get_node(i)

func _process(_delta):
	if !selected == null:
		selected.run()
		running()

func run():
	pass

func child_success():
	numResults += 1
	if numResults >= get_child_count():
		numResults = 0
		success()


func child_fail():
	numResults += 1
	if numResults >= get_child_count():
		numResults = 0
		fail()
