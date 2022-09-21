extends MeshInstance

export(float) var speed : float = 1.0
var counter : int = 0

func _physics_process(delta):
	if !counter >= 60:
		counter += 1
		transform.origin.y += 0.125 * speed
	else:
		queue_free()
