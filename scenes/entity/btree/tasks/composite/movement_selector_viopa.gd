extends TaskViopa

class_name MovementSelectorViopa

func _ready():
	yield(owner, "ready")
	if viopa.has_node("SearchArea"):
		var area : Area = viopa.get_node("SearchArea")
		area.connect("body_entered", self, "search_area_entered")
		area.connect("body_exited", self, "search_area_exited")

func _physics_process(delta):
	pass

func search_area_entered(body : Node):
	if body is ViopaPlayer:
		for i in get_children():
			if i is MovementGenericViopa:
				i.run()

func search_area_exited(body : Node):
	if body is ViopaPlayer:
		for i in get_children():
			if i is MovementGenericViopa:
				i.success()
