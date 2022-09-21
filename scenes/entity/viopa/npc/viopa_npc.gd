extends Viopa

func _ready():
	for i in $Casts.get_children():
		i.enabled = false
