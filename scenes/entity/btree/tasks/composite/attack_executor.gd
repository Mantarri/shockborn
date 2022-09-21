extends TaskPlayer

class_name AttackExecutor

func _ready():
	pass

func _unhandled_input(event):
	for i in get_children():
		i.run()
