extends Task

# Extension of `Task` for autocomplete purposes

class_name TaskPlayer

var player : ViopaPlayer

func _ready() -> void:
	yield(owner, "ready")
	
	player = owner as ViopaPlayer
	
	assert(player != null)
