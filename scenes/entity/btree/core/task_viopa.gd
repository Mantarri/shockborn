extends Task

# Extension of `Task` for autocomplete purposes

class_name TaskViopa

var viopa : Viopa

func _ready() -> void:
	yield(owner, "ready") 
	
	viopa = owner as Viopa
	
	assert(viopa != null)
